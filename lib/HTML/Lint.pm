package HTML::Lint;

=head1 NAME

HTML::Lint - check for HTML errors in a string or file

=head1 SYNOPSIS

    my $lint = HTML::Lint->new;
	
    $lint->parse( $data );
    $lint->parse_file( $filename );
	
    my $error_count = $lint->errors;

    foreach my $error ( $lint->errors ) {
	print $error->as_string, "\n";
    }

HTML::Lint also comes with a wrapper program called F<weblint> that handles
linting from the command line:

    $ weblint http://www.cnn.com/
    http://www.cnn.com/ (395:83) <IMG> tag has no HEIGHT and WIDTH attributes.
    http://www.cnn.com/ (395:83) <IMG> does not have ALT text defined
    http://www.cnn.com/ (396:217) Unknown element <nobr>
    http://www.cnn.com/ (396:241) </nobr> with no opening <nobr>
    http://www.cnn.com/ (842:7) target attribute in <a> is repeated

And finally, you can also get Apache::Lint that passes any mod_perl-generated 
code through HTML::Lint and get it dumped into your Apache F<error_log>.

    [Mon Jun  3 14:03:31 2002] [warn] /foo.pl (1:45) </p> with no opening <p>
    [Mon Jun  3 14:03:31 2002] [warn] /foo.pl (1:49) Unknown element <gronk>
    [Mon Jun  3 14:03:31 2002] [warn] /foo.pl (1:56) Unknown attribute "x" for tag <table>

=cut

use 5.6.0;
use strict;
use warnings;

use HTML::Parser 3.20;
use HTML::Tagset 3.03;
use HTML::Lint::Error;
use HTML::Lint::HTML4;

our @ISA = qw( HTML::Parser );

=head1 VERSION

Version 1.00

    $Header: /cvsroot/html-lint/html-lint/lib/HTML/Lint.pm,v 1.15 2002/06/05 21:29:43 petdance Exp $

=cut

our $VERSION = '1.00';

=head1 EXPORTS

None.  It's all object-based.

=head1 METHODS

C<HTML::Lint> is based on the L<HTML::Parser> module.  Any method call that works with 
C<HTML::Parser> will work in <HTML::Lint>.  However, you'll probably only want to use
the C<parse()> or C<parse_file()> methods.

=over 4

=item new()

Create an HTML::Lint object, which inherits from HTML::Parser.  The C<new> 
method takes no arguments.

=cut

sub new {
    my $class = shift;
    my $self  = 
        HTML::Parser->new(
	    api_version => 3,
	    start_h     => [ \&_start,	'self,tagname,line,column,@attr' ],
	    end_h       => [ \&_end,	'self,tagname,line,column,@attr' ],
	    strict_names => 1,
	    );

    bless $self, $class;

    $self->{_errors} = [];
    $self->{_stack} = [];
    $self->{_first_occurrence} = {};

    return $self;
}

=item errors()

In list context, C<errors> returns all of the errors found in 
the parsed text.  In scalar context, it returns the number of
errors found.

=cut

sub errors {
    my $self = shift;

    if ( wantarray ) {
	return @{$self->{_errors}};
    } else {
	return scalar @{$self->{_errors}};
    }
}

=item clear_errors()

Clears the list of errors, in case you want to print and clear, print and clear.

=cut

sub clear_errors() {
    my $self = shift;

    $self->{_errors} = [];
}


sub gripe {
    my $self = shift;

    my $err = new HTML::Lint::Error( 
    	$self->file, $self->line, $self->column, @_ );

    push( @{$self->{_errors}}, $err );
}

=head2 newfile( $filename )

Call C<newfile()> whenever you switch to another file in a batch of 
linting.  Otherwise, the object thinks everything is from the same file.

=cut

sub newfile($) {
    my $self = shift;
    my $file = shift;

    $self->{_file} = $file;
    $self->line(0);
    $self->column(0);

    return $self->{_file};
} # newfile

sub file() {
    my $self = shift;
    return $self->{_file};
}

sub line($) {
    my $self = shift;
    $self->{_line} = shift if @_;
    return $self->{_line};
}

sub column($) {
    my $self = shift;
    $self->{_column} = shift if @_;
    return $self->{_column};
}

sub _start {
    my ($self,$tag,$line,$column,@attr) = @_;
    $self->line($line);
    $self->column($column);

    my $validattr = $isKnownAttribute{ $tag };
    if ( $validattr ) {
	my %seen;
	my $i = 0;
	while ( $i < @attr ) {
	    my ($attr,$val) = @attr[$i++,$i++];
	    if ( $seen{$attr}++ ) {
		$self->gripe( 'attr-repeated', tag => $tag, attr => $attr );
	    }

	    if ( $validattr && ( !$validattr->{$attr} ) ) {
		$self->gripe( 'attr-unknown', tag => $tag, attr => $attr );
	    }
	} # while attribs
    } else {
	$self->gripe( 'elem-unknown', tag => $tag );
    }
    $self->_element_push( $tag ) unless $HTML::Tagset::emptyElement{ $tag };

    # Call any other overloaded func
    my $tagfunc = "_start_$tag";
    if ( $self->can($tagfunc) ) {
       $self->$tagfunc( $tag, @attr );
    }
}

sub _end {
    my ($self,$tag,$line,$column,@attr) = @_;
    $self->line($line);
    $self->column($column);

    if ( @attr ) {
	$self->gripe( 'attr-closing-tag' );
    }

    if ( $HTML::Tagset::emptyElement{ $tag } ) {
	$self->gripe( 'elem-empty-but-closed', tag => $tag );
    } else {
	if ( $self->_in_context($tag) ) {
	    my @leftovers = $self->_element_pop_back_to($tag);
	    for ( @leftovers ) {
		my ($tag,$line,$col) = @$_;
		$self->gripe( 'elem-unclosed', tag => $tag, 
			where => HTML::Lint::Error::where($line,$col) )
		    	unless $HTML::Tagset::optionalEndTag{$tag};
	    } # for
	} else {
	    $self->gripe( 'elem-unopened', tag => $tag );
	}
    } # is empty element
    
    # Call any other overloaded func
    my $tagfunc = "_end_$tag";
    if ( $self->can($tagfunc) ) {
	$self->$tagfunc( $tag, $line );
    }
}

sub _element_stack { my $self = shift; @{$self->{_stack}} }
sub _element_push { 
    my $self = shift; 
    for ( @_ ) {
	push( @{$self->{_stack}}, [$_,$self->line,$self->column] ); 
    } # while
}

sub _find_tag_in_stack {
    my $self = shift;
    my $tag = shift;
    my $stack = $self->{_stack};

    my $offset = @$stack - 1;
    while ( $offset >= 0 ) {
	if ( $stack->[$offset][0] eq $tag ) {
	    return $offset;
	} # if
	--$offset;
    } # while

    return undef;

}

sub _element_pop_back_to {
    my $self = shift;
    my $tag = shift;
    
    my $offset = $self->_find_tag_in_stack($tag);
    return undef if not defined $offset;

    my @leftovers = splice( @{$self->{_stack}}, $offset + 1 );
    pop @{$self->{_stack}};

    return @leftovers;
}

sub _in_context {
    my $self = shift;
    my $tag = shift;

    my $offset = $self->_find_tag_in_stack($tag);
    return defined $offset;
}

# Overridden tag-specific stuff
sub _start_img {
    my ($self,$tag,%attr) = @_;

    my ($h,$w) = @attr{qw( height width )};
    if ( defined $h && defined $w ) {
	# Check sizes
    } else {
	$self->gripe( "elem-img-sizes-missing" );
    }
    if ( not defined $attr{alt} ) {
	$self->gripe( "elem-img-alt-missing" );
    }
}

sub _start_input {
    my ($self,$tag,%attr) = @_;

    my $is_button = (lc $attr{type} eq "image");
    my ($h,$w) = @attr{qw( height width )};

    if ( $is_button ) {
	if ( defined $h && defined $w ) {
	    # Check sizes (same as in img tag)
	} else {
	    $self->gripe( "elem-input-image-sizes-missing" );
	}
    } else {
	if ( defined $h || defined $w ) {
	    $self->gripe( "elem-input-not-sizable" );
	}
    }
}

=back

=head1 SEE ALSO

L<HTML::Lint::Error>, L<HTML::Parser>

=head1 TODO

=over 4

=item * Allow a "check this string" method for building into tests.

=item * Check for attributes that require values

For instance, BGCOLOR should be BGCOLOR="something", but if it's just BGCOLOR, 
that's a problem.  (Plus, that crashes IE OSX)

=item * Check form validity: Are any fields duplicated on the form?

=item * Add link checking

=item * Handle obsolete tags

=item * Create a .t file for each potential error message

=item * Anything like <BR> or <P> inside of <A>

=item * <TABLE>s that have no rows.

=item * Form fields that aren't in a FORM

=item * Check for valid entities, and that they end with semicolons

=item * DIVs with nothing in them.

=back

=head1 LICENSE

This code may be distributed under the same terms as Perl itself.

Please note that these modules are not products of or supported by the
employers of the various contributors to the code.

=head1 AUTHOR

Andy Lester, E<lt>andy@petdance.comE<gt>

=cut

