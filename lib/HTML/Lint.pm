package HTML::Lint;

=head1 NAME

HTML::Lint - check for HTML errors in a string or file

=head1 VERSION

Version 1.28

    $Header: /cvsroot/html-lint/html-lint/lib/HTML/Lint.pm,v 1.63 2004/01/27 23:15:34 petdance Exp $

=cut

use vars '$VERSION';
$VERSION = '1.28';

=head1 SYNOPSIS

    my $lint = HTML::Lint->new;
    $lint->only_types( HTML::Lint::STRUCTURE );

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

And finally, you can also get L<Apache::HTML::Lint> that passes any
mod_perl-generated code through HTML::Lint and get it dumped into your
Apache F<error_log>.

    [Mon Jun  3 14:03:31 2002] [warn] /foo.pl (1:45) </p> with no opening <p>
    [Mon Jun  3 14:03:31 2002] [warn] /foo.pl (1:49) Unknown element <gronk>
    [Mon Jun  3 14:03:31 2002] [warn] /foo.pl (1:56) Unknown attribute "x" for tag <table>

=cut

use strict;

use HTML::Parser 3.20;
use HTML::Tagset 3.03;
use HTML::Lint::Error;
use HTML::Lint::HTML4 qw( %isKnownAttribute %isRequired %isNonrepeatable %isObsolete );
use HTML::Entities qw( %char2entity );

use vars qw( @ISA );

@ISA = qw( HTML::Parser );

=head1 EXPORTS

None.  It's all object-based.

=head1 METHODS

C<HTML::Lint> is based on the L<HTML::Parser> module.  Any method call that works with 
C<HTML::Parser> will work in C<HTML::Lint>.  However, you'll probably only want to use
the C<parse()> or C<parse_file()> methods.

=head2 new()

Create an HTML::Lint object, which inherits from HTML::Parser.
You may pass the types of errors you want to check for in the
C<only_types> parm.

    my $lint = HTML::Lint->new( only_types => HTML::Lint::Error::STRUCTURE );

If you want more than one, you must pass an arrayref:

    my $lint = HTML::Lint->new( 
	only_types => [HTML::Lint::Error::STRUCTURE, HTML::Lint::Error::FLUFF] );

=cut

sub new {
    my $class = shift;
    my %args = @_;

    my $self  = 
        HTML::Parser->new(
	    api_version => 3,
	    start_document_h	=> [ \&_start_document,	'self' ],
	    end_document_h	=> [ \&_end_document,   'self,line,column' ],
	    start_h		=> [ \&_start,		'self,tagname,line,column,@attr' ],
	    end_h		=> [ \&_end,		'self,tagname,line,column,@attr' ],
	    text_h		=> [ \&_text,		'self,text' ],
	    strict_names => 1,
	    );

    bless $self, $class;

    $self->{_errors} = [];
    $self->{_stack} = [];
    $self->{_first_occurrence} = {};
    $self->{_types} = [];

    if ( my $only = $args{only_types} ) {
	$self->only_types( ref $only eq "ARRAY" ? @$only : $only );
	delete $args{only_types};
    }

    warn "Unknown argument $_\n" for keys %args;

    return $self;
}

=head2 only_types( $type1[, $type2...] )

Specifies to only want errors of a certain type.

    $lint->only_types( HTML::Lint::Error::STRUCTURE );

Calling this without parameters makes the object return all possible
errors.

The error types are C<STRUCTURE>, C<HELPER> and C<FLUFF>.
See L<HTML::Lint::Error> for details on these types.

=cut

sub only_types {
    my $self = shift;

    $self->{_types} = [@_];
}

=head2 errors()

In list context, C<errors> returns all of the errors found in the
parsed text.  Each error is an object of the type L<HTML::Lint::Error>.

In scalar context, it returns the number of errors found.

=cut

sub errors {
    my $self = shift;

    if ( wantarray ) {
	return @{$self->{_errors}};
    } else {
	return scalar @{$self->{_errors}};
    }
}

=head2 clear_errors()

Clears the list of errors, in case you want to print and clear, print and clear.

=cut

sub clear_errors {
    my $self = shift;

    $self->{_errors} = [];
}

=head2 gripe( $errcode, [$key1=>$val1, ...] )

Adds an error message, in the form of an L<HTML::Lint::Error> object,
to the list of error messages for the current object.  The file,
line and column are automatically passed to the L<HTML::Lint::Error>
constructor, as well as whatever other key value pairs are passed.

For example:

    $lint->gripe( 'attr-repeated', tag => $tag, attr => $attr );

Usually, the user of the object won't call this directly, but just
in case, here you go.

=cut

sub gripe {
    my $self = shift;

    my $err = new HTML::Lint::Error( 
    	$self->file, $self->line, $self->column, @_ );

    my @keeps = @{$self->{_types}};
    if ( !@keeps || $err->is_type(@keeps) ) {
	push( @{$self->{_errors}}, $err );
    }
}

=head2 newfile( $filename )

Call C<newfile()> whenever you switch to another file in a batch of 
linting.  Otherwise, the object thinks everything is from the same file.
Note that the list of errors is NOT cleared.

=cut

sub newfile {
    my $self = shift;
    my $file = shift;

    $self->{_file} = $file;
    $self->{_line} = 0;
    $self->{_column} = 0;
    $self->{_first_seen} = {};

    return $self->{_file};
} # newfile

=head2 file()

Returns the current file being linted.

=cut

sub file {
    return shift->{_file};
}

=head2 line()

Returns the current line in the file.

=cut

sub line {
    return shift->{_line};
}

=head2 column()

Returns the current column in the file.

=cut

sub column {
    return shift->{_column};
}

=pod

Here are all the internal functions that nobody needs to know about

=cut

sub _start_document {
    my $self = shift;
}


sub _end_document {
    my ($self,$line,$column) = @_;

    for my $tag ( keys %isRequired ) {
	if ( !$self->{_first_seen}->{$tag} ) {
	    $self->gripe( 'doc-tag-required', tag => $tag );
	}
    }
}

sub _start {
    my ($self,$tag,$line,$column,@attr) = @_;

    $self->{_line} = $line;
    $self->{_column} = $column;

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

    if ( my $where = $self->{_first_seen}{$tag} ) {
	if ( $isNonrepeatable{$tag} ) {
	    $self->gripe( 'elem-nonrepeatable', 
			    tag => $tag, 
			    where => HTML::Lint::Error::where(@$where)
			);
	}
    } else {
	$self->{_first_seen}{$tag} = [$line,$column];
    }

    # Call any other overloaded func
    my $tagfunc = "_start_$tag";
    if ( $self->can($tagfunc) ) {
       $self->$tagfunc( $tag, @attr );
    }
}

sub _text {
    my ($self,$text) = @_;

    while ( $text =~ /([^\x09\x0A\x0D -~])/g ) {
	my $bad = $1;
	$self->gripe(
	    'text-use-entity', 
		char => sprintf( '\x%02lX', ord($bad) ),
		entity => $char2entity{ $bad },
	);
    }
}

sub _end {
    my ($self,$tag,$line,$column,@attr) = @_;

    $self->{_line} = $line;
    $self->{_column} = $column;

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

    return;

}

sub _element_pop_back_to {
    my $self = shift;
    my $tag = shift;
    
    my $offset = $self->_find_tag_in_stack($tag) or return;

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

=head1 BUGS, WISHES AND CORRESPONDENCE

Please feel free to email me at andy@petdance.com.  I'm glad to help as
best I can, and I'm always interested in bugs, suggestions and patches.

Please report any bugs or feature requests to
C<< <bug-html-lint@rt.cpan.org> >>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically
be notified of progress on your bug as I make changes.

=head1 TODO

=over 4

=item * Check for attributes that require values

For instance, BGCOLOR should be BGCOLOR="something", but if it's just BGCOLOR, 
that's a problem.  (Plus, that crashes IE OSX)

=item * Add link checking

=item * Handle obsolete tags

=item * Anything like <BR> or <P> inside of <A>

=item * <TABLE>s that have no rows.

=item * Form fields that aren't in a FORM

=item * Check for valid entities, and that they end with semicolons

=item * DIVs with nothing in them.

=item * HEIGHT= that have percents in them.

=item * Check for goofy stuff like:

    <b><li></b><b>Hello Reader - Spanish Level 1 (K-3)</b>

=back

=head1 LICENSE

Copyright 2003 Andy Lester, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

Please note that these modules are not products of or supported by the
employers of the various contributors to the code.

=head1 AUTHOR

Andy Lester, E<lt>andy@petdance.comE<gt>

=cut

