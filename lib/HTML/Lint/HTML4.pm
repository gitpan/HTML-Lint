# $Id: HTML4.pm,v 1.6 2002/07/15 19:19:20 petdance Exp $
package HTML::Lint::HTML4;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT_OK = qw( %isKnownAttribute %isRequired %isNonrepeatable %isObsolete );

sub hash(@) { my %hash; $hash{$_} = 1 for @_; return \%hash; }

our @physical	= qw( b big code i kbd s small strike sub sup tt u xmp );
our @content	= qw( abbr acronym cite code dfn em kbd samp strong var );

our @core	= qw( class id style title );
our @i18n	= qw( dir lang );
our @events	= qw( onclick ondblclick onkeydown onkeypress onkeyup onmousedown onmousemove onmouseout onmouseover onmouseup );
our @std	= (@core,@i18n,@events);

our %isRequired = %{hash( qw( body head title ) )};
our %isNonrepeatable = %isRequired;
our %isObsolete	=> hash( qw( listing plaintext xmp ) );

# Some day I might do something with these.  For now, they're just comments.
sub ie_only { return @_ };
sub ns_only { return @_ };

our %isKnownAttribute = (
    # All the physical markup has the same
    (map { $_=>hash(@std) } (@physical, @content) ),

    a		=> hash( @std, qw( accesskey charset coords href hreflang name onblur onfocus rel rev shape tabindex target type ) ),
    addresss	=> hash( @std ),
    applet	=> hash( @std ),
    area	=> hash( @std, qw( accesskey alt coords href nohref onblur onfocus shape tabindex target ) ),
    base	=> hash( qw( href target ) ),
    basefont	=> hash( qw( color face id size ) ),
    bdo		=> hash( @core, @i18n ),
    blockquote	=> hash( @std, qw( cite ) ),
    body	=> hash( @std, 
		    qw( alink background bgcolor link marginheight marginwidth onload onunload text vlink ),
		    ie_only( qw( bgproperties leftmargin topmargin ) )
		    ),
    br		=> hash( @core, qw( clear ) ),
    button	=> hash( @std, qw( accesskey disabled name onblur onfocus tabindex type value ) ),
    caption	=> hash( @std, qw( align ) ),
    center	=> hash( @std ),
    cite	=> hash(),
    col		=> hash( @std, qw( align char charoff span valign width ) ),
    colgroup	=> hash( @std, qw( align char charoff span valign width ) ),
    del		=> hash( @std, qw( cite datetime ) ),
    div		=> hash( @std, qw( align ) ),
    dir		=> hash( @std, qw( compact ) ),
    dd		=> hash( @std ),
    dl		=> hash( @std, qw( compact ) ),
    dt		=> hash( @std ),
    fieldset	=> hash( @std ),
    font	=> hash( @core, @i18n, qw( color face size ) ),
    form	=> hash( @std, qw( accept-charset action enctype method name onreset onsubmit target ) ),
    frame 	=> hash( @core, qw( frameborder longdesc marginheight marginwidth name noresize scrolling src ) ),
    frameset	=> hash( @core, qw( cols onload onunload rows ) ),
    h1		=> hash( @std, qw( align ) ),
    h2		=> hash( @std, qw( align ) ),
    h3		=> hash( @std, qw( align ) ),
    h4		=> hash( @std, qw( align ) ),
    h5		=> hash( @std, qw( align ) ),
    h6		=> hash( @std, qw( align ) ),
    head	=> hash( @i18n, qw( profile ) ),
    hr		=> hash( @core, @events, qw( align noshade size width ) ),
    html	=> hash( @i18n, qw( version )),
    iframe	=> hash( @core, qw( align frameborder height longdesc marginheight marginwidth name scrolling src width ) ),
    img		=> hash( @std, qw( align alt border height hspace ismap longdesc src usemap vspace width ) ),
    input 	=> hash( @std, qw( accept accesskey align alt border checked disabled height width maxlength name onblur onchange onfocus onselect readonly size src tabindex type usemap value ) ),
    ins		=> hash( @std, qw( cite datetime ) ),
    isindex	=> hash( @core, @i18n, qw( prompt ) ),
    label 	=> hash( @std, qw( accesskey for onblur onfocus ) ),
    legend	=> hash( @std, qw( accesskey align ) ),
    li		=> hash( @std, qw( type value ) ),
    link	=> hash( @std, qw( charset href hreflang media rel rev target type ) ),
    listing	=> hash(),
    map		=> hash( @std, qw( name ) ),
    menu	=> hash( @std, qw( compact ) ),
    meta	=> hash( @i18n, qw( content http-equiv name scheme ) ),
    nobr	=> hash( @std ),
    noframes	=> hash( @std ), 
    noscript	=> hash( @std ), 
    object	=> hash( @std, qw( align archive border classid codebase codetype data declare height hspace name standby tabindex type usemap vspace width )),
    ol		=> hash( @std, qw( compact start type ) ),
    optgroup	=> hash( @std, qw( disabled label ) ),
    option	=> hash( @std, qw( disabled label selected value ) ),
    p 		=> hash( @std, qw( align ) ),
    param 	=> hash( qw( id name type value valuetype ) ),
    plaintext  	=> hash(),
    pre		=> hash( @std, qw( width ) ),
    q 		=> hash( @std, qw( cite ) ),
    script	=> hash( qw( charset defer event for language src type ) ),
    select	=> hash( @std, qw( disabled multiple name onblur onchange onfocus size tabindex ) ),
    span	=> hash( @std ),
    strong	=> hash(),
    style 	=> hash( @i18n, qw( media title type ) ),
    table 	=> hash( @std, 
		    qw( align bgcolor border cellpadding cellspacing datapagesize frame rules summary width ),
		    ie_only( qw( background bordercolor bordercolordark bordercolorlight ) ),
		    ns_only( qw( bordercolor cols height hspace vspace ) ),
		    ),
    tbody 	=> hash( @std, qw( align char charoff valign ) ),
    td		=> hash( @std, 
		    qw( abbr align axis bgcolor char charoff colspan headers height nowrap rowspan scope valign width ),
		    ie_only( qw( background bordercolor bordercolordark bordercolorlight ) ),
		    ),
    textarea	=> hash( @std, qw( accesskey cols disabled name onblur onchange onfocus onselect readonly rows tabindex ) ),
    th		=> hash( @std, 
		    qw( abbr align axis bgcolor char charoff colspan headers height nowrap rowspan scope valign width ),
		    ie_only( qw( background bordercolor bordercolordark bordercolorlight ) ),
		    ),
    thead 	=> hash( @std, qw( align char charoff valign ) ),
    tfoot 	=> hash( @std, qw( align char charoff valign ) ),
    title 	=> hash( @i18n ),
    tr		=> hash( @std, 
		    qw( align bgcolor char charoff valign ),
		    ie_only( qw( bordercolor bordercolordark bordercolorlight nowrap ) ),
		    ns_only( qw( nowrap ) ),
		),
    ul		=> hash( @std, qw( compact type ) ),
);

=for oldobsoletestuffthatIwanttokeep 
my %booger = (
    'maybePaired'  => 'LI DT DD P TD TH TR OPTION COLGROUP THEAD TFOOT TBODY COL',

	'expectArgsRE' => 'A|FONT',

	'headTagsRE' => 'TITLE|NEXTID|LINK|BASE|META',

	'requiredContext' =>
	{
	'AREA'	   => 'MAP',
	'CAPTION'  => 'TABLE',
	'DD'	   => 'DL',
	'DT'	   => 'DL',
	'FIELDSET' => 'FORM',
	'FRAME'    => 'FRAMESET',
	'INPUT'    => 'FORM',
	'LABEL'    => 'FORM',
	'LEGEND'   => 'FIELDSET',
	'LI'	   => 'DIR|MENU|OL|UL',
	'NOFRAMES' => 'FRAMESET',
	'OPTGROUP' => 'SELECT',
	'OPTION'   => 'SELECT',
	'SELECT'   => 'FORM',
	'TD'	   => 'TR',
	'TEXTAREA' => 'FORM',
	'TH'	   => 'TR',
	'TR'	   => 'TABLE',
	'PARAM'    => 'APPLET|OBJECT',
	},

	'okInHead' =>
		{
			'ISINDEX' => 1,
			'TITLE'   => 1,
			'NEXTID'  => 1,
			'LINK'	  => 1,
			'BASE'	  => 1,
			'META'	  => 1,
			'RANGE'   => 1,
			'STYLE'   => 1,
			'OBJECT'  => 1,
			'!--'	  => 1,
		},


	## elements which cannot be nested
	'nonNest' => 'A|FORM',

	'requiredAttributes' =>
	{
	APPLET	=> 'WIDTH|HEIGHT',
	AREA		=> 'ALT',
	BASE		=> 'HREF',
	BASEFONT	=> 'SIZE',
	BDO		=> 'DIR',
	FORM		=> 'ACTION',
	IMG		=> 'SRC|ALT',
	LINK		=> 'HREF',
	MAP		=> 'NAME',
	NEXTID	=> 'N',
	SELECT	=> 'NAME',
	TEXTAREA	=> 'NAME|ROWS|COLS'
	},

	'attributeFormat' =>
	{
		'ALIGN',	 'BOTTOM|MIDDLE|TOP|LEFT|CENTER|RIGHT|JUSTIFY|'.
				'BLEEDLEFT|BLEEDRIGHT|DECIMAL',
		'ALINK' 	 => 'color',
		'BGCOLOR'	   => 'color',
		'CLEAR',	'LEFT|RIGHT|ALL|NONE',
		'COLOR' 	 => 'color',
		'COLS', 	 '\d+|(\d*[*%]?,)*\s*\d*[*%]?',
		'COLSPAN',	   '\d+',
		'DIR'		=> 'LTR|RTL',
		'HEIGHT',	   '\d+',
		'INDENT',	   '\d+',
		'LINK'		=> 'color',
		'MAXLENGTH',   '\d+',
		'METHOD',	   'GET|POST',
		'ROWS', 	   '\d+|(\d*[*%]?,)*\s*\d*[*%]?',
		'ROWSPAN',	   '\d+',
		'SEQNUM',	   '\d+',
		'SIZE', 	   '[-+]?\d+|\d+,\d+',
		'SKIP', 	   '\d+',
		'TYPE', 	   'CHECKBOX|HIDDEN|IMAGE|PASSWORD|RADIO|RESET|'.
				'SUBMIT|TEXT|[AaIi1]|disc|square|circle|'.
				'FILE|.*',
		'UNITS',	 'PIXELS|EN',
		'VALIGN',	 'TOP|MIDDLE|BOTTOM|BASELINE',
		'VLINK' 	 => 'color',
		'WIDTH',	 '\d+%?',
		'WRAP', 	 'OFF|VIRTUAL|PHYSICAL',
		'X',		 '\d+',
		'Y',		 '\d+'
	},

	'badTextContext' =>
	{
		'HEAD',  'BODY, or TITLE perhaps',
		'UL',	 'LI or LH',
		'OL',	 'LI or LH',
		'DL',	 'DT or DD',
		'TABLE', 'TD or TH',
		'TR',	 'TD or TH'
	},

	'bodyColorAttributes' =>
	[
		qw(BGCOLOR TEXT LINK ALINK VLINK)
	],

);
=cut

1;

__END__

=head1 NAME

HTML::Lint::HTML4.pm -- Rules for HTML 4 as used by HTML::Lint.

=head1 SYNOPSIS

No user serviceable parts inside.  Used by HTML::Lint.

=head1 SEE ALSO

=over 4

=item HTML::Lint

=back

=head1 AUTHOR

Andy Lester E<lt>andy@petdance.comE<gt>

=head1 COPYRIGHT

Copyright (c) Andy Lester 2001. All Rights Reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
