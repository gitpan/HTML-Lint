package HTML::Lint::Error;

use 5.6.0;
use strict;
use warnings;

our %_errors;

=head1 NAME

HTML::Lint::Error - Error object for the Lint functionality

=head1 SYNOPSIS

See L<HTML::Lint> for all the gory details.

=head1 EXPORTS

None.  It's all object-based.

=head1 METHODS

Almost everything is an accessor.

=head2 new()

Create an object.  It's not very exciting.

=cut

sub new {
    my $class = shift;

    my $file = shift;
    my $line = shift;
    my $column = shift;
    my $errcode = shift;

    # Add an element that says what tag caused the error (B, TR, etc)
    # so that we can match 'em up down the road.
    my $self  = {
	_file => $file,
	_line => $line,
	_column => $column,
	_errcode => $errcode,
	_errtext => _expand_error( $errcode, @_ ),
    };

    bless $self, $class;

    return $self;
}

sub _expand_error {
    my $errcode = shift;
    
    my $str = $_errors{$errcode} || "Unknown code: $errcode";

    while ( @_ ) {
	my $var = shift;
	my $val = shift;
	$str =~ s/\$\{$var\}/$val/g;
    }

    return $str;
}

sub where {
    my $line;
    my $col;

    if ( not ref $_[0] ) {
	$line = shift;
	$col = shift;
    } else {
	my $self = shift;
	$line = $self->{_line};
	$col = $self->{_column};
    }
    return sprintf( "(%s:%s)", $line, $col + 1 );
}

sub as_string {
    my $self = shift;

    return sprintf( "%s %s %s", $self->file, $self->where, $self->errtext );
}

sub file { my $self = shift; return $self->{_file} }
sub line { my $self = shift; return $self->{_line} }
sub column { my $self = shift; return $self->{_column} }
sub errcode { my $self = shift; return $self->{_errcode} }
sub errtext { my $self = shift; return $self->{_errtext} }


=head1 TODO

=item * None

=head1 LICENSE

This code may be distributed under the same terms as Perl itself.

Please note that these modules are not products of or supported by the
employers of the various contributors to the code.

=head1 AUTHOR

Andy Lester, E<lt>andy@petdance.comE<gt>

=cut

INIT {
    while (<DATA>) {
	chomp;
	next if /^\s*#/;
	next if /^$/;

	my ($name,$text) = split( /\s+/, $_, 2 );
	$_errors{$name} = $text;
    } # while
}

1; # happy

__DATA__
# Errors that are commented out have not yet been implemented.

# Generic element stuff
#elem-head-only			<${tag}> can only appear in the <HEAD> element
elem-unknown 			Unknown element <${tag}> 
#elem-nonrepeatable 		Element <${tag}> is non-repeatable, but already showed up at line ${n} 
#elem-non-head-element 		<${tag}> cannot appear in the <HEAD> element 
#elem-obsolete 			<${tag}> is obsolete 
elem-unopened 			</${tag}> with no opening <${tag}> 
elem-unclosed 			<${tag}> at ${where} is never closed 
#elem-nested-element 		<${tag}> cannot be nested -- one is already opened at ${where}
$elem-overlap 			</${tag}> seems to overlap <${othertag}> opened at ${where}
elem-empty-but-closed 		<${tag}> is not a container -- </${tag}> is not allowed 
#elem-wrong-context		Illegal context for <${tag}> -- must appear in <${othertag}> tag.
#elem-heading-in-anchor		<A> should be inside <${tag}>, not <${tag}> inside <A>
elem-input-image-sizes-missing	<INPUT TYPE="image"> can benefit from HEIGHT and WIDTH, like an IMG tag.
elem-input-not-sizable		<INPUT> tag cannot have HEIGHT and WIDTH unless TYPE="image"

# HEAD-specific
#elem-head-missing		No <HEAD> element found
#elem-head-missing-title 	No <TITLE> in <HEAD> element

# IMG-specific
elem-img-sizes-missing		<IMG> tag has no HEIGHT and WIDTH attributes.
#elem-img-sizes-incorrect	<IMG> tag's HEIGHT and WIDTH attributes are incorrect.  They should be ${correct}.
elem-img-alt-missing		<IMG> does not have ALT text defined

attr-repeated 			${attr} attribute in <${tag}> is repeated
attr-unknown 			Unknown attribute "${attr}" for tag <${tag}>
#attr-missing 			<${tag}> is missing a "${attr}" attribute
#attr-closing-tag		Closing tag </${tag}> should not have any attributes.

#comment-unclosed		Unclosed comment
#comment-markup			Markup embedded in a comment can confuse some browsers

#text-here-anchor		Bad form to use "here" as anchor text
#text-literal-metacharacter	Metacharacter $char should be represented as "$otherchar"
#text-title-length		The HTML spec recommends that that <TITLE> be no more than 64 characters
#text-markup			Tag <${tag}> found in the <TITLE>, which will not be rendered properly.

file-cannot-open		File ${filename} can't be opened: ${error}

#elem-physical-markup		<${tag}> is physical font markup.  Use logical (such as <${othertag}>) instead.
#elem-leading-whitespace	<${tag}> should not have whitespace between "<" and "${tag}>"
#'must-follow' => [ ENABLED, MC_ERROR, '<$argv[0]> must immediately follow <$argv[1]>', ],
# 'empty-container' => [ ENABLED, MC_WARNING, 'empty container element <$argv[0]>.', ],
# 'directory-index' => [ ENABLED, MC_WARNING, 'directory $argv[0] does not have an index file ($argv[1])', ],
# 'attribute-delimiter' => [ ENABLED, MC_WARNING, 'use of \' for attribute value delimiter is not supported by all browsers (attribute $argv[0] of tag $argv[1])', ],
# 'container-whitespace' => [ DISABLED, MC_WARNING, '$argv[0] whitespace in content of container element $argv[1]', ],
# 'bad-text-context' => [ ENABLED, MC_ERROR, 'illegal context, <$argv[0]>, for text; should be in $argv[1].', ],
# 'attribute-format' => [ ENABLED, MC_ERROR, 'illegal value for $argv[0] attribute of $argv[1] ($argv[2])', ],
# 'quote-attribute-value' => [ ENABLED, MC_ERROR, 'value for attribute $argv[0] ($argv[1]) of element $argv[2] should be quoted (i.e. $argv[0]="$argv[1]")', ],
# 'meta-in-pre' => [ ENABLED, MC_ERROR, 'you should use "$argv[0]" in place of "$argv[1]", even in a PRE element.', ],
#  'implied-element' => [ ENABLED, MC_WARNING, 'saw <$argv[0]> element, but no <$argv[1]> element', ],
#  'button-usemap' => [ ENABLED, MC_ERROR, 'illegal to associate an image map with IMG inside a BUTTON', ],
