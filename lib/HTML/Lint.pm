package HTML::Lint;

=head1 NAME

HTML::Lint - Perl extension for checking validity of HTML

=head1 SYNOPSIS

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

Version 0.91

=cut

our $VERSION = '0.91';

=head1 EXPORTS

None.  It's all object-based.

=head1 METHODS

C<HTML::Lint> is based on the L<HTML::Parser> module.  Any method call that works with 
C<HTML::Parser> will work in <HTML::Lint>.  However, you'll probably only want to use
the C<parse()> or C<parse_file()> methods.

=head2 new()

Constructor for linting.  Takes no arguments.

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


sub errors { my $self = shift; return @{$self->{_errors}}; }

sub gripe {
    my $self = shift;

    my $err = new HTML::Lint::Error( $self->file, $self->line, $self->column, @_ );

    push( @{$self->{_errors}}, $err );
}

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
	$self->_element_push( $tag ) unless $HTML::Tagset::emptyElement{ $tag };
    } else {
	$self->gripe( 'elem-unknown', tag => $tag );
    }

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
		$self->gripe( 'elem-unclosed', tag => $tag, where => HTML::Lint::Error::where($line,$col) )
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


=head1 TODO

=over 4

=item * Check form validity: Are any fields duplicated on the form?

=item * Add link checking

=item * Handle obsolete tags

=item * Create a .t file for each potential error message

=back

=head1 LICENSE

This code may be distributed under the same terms as Perl itself.

Please note that these modules are not products of or supported by the
employers of the various contributors to the code.

=head1 AUTHOR

Andy Lester, E<lt>andy@petdance.comE<gt>

=cut

