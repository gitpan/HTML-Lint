#
# HTML::Lint::HTML4
#

package HTML::Lint::HTML4;
use strict;


my $ColorNames = 'Black|White|Green|Maroon|Olive|Navy|Purple|Gray|'.
			'Red|Yellow|Blue|Teal|Lime|Aqua|Fuchsia|Silver';
my $colorRE = '#[0-9a-fA-F]{6}'.'|'.$ColorNames;

my @fontstyle = qw(TT I B U S STRIKE BIG SMALL);
my @phrase	  = qw(EM STRONG DFN CODE SAMP KBD VAR CITE ABBR ACRONYM);

my $coreattrs = 'ID|CLASS|STYLE|TITLE';
my $i18n	  = 'LANG|DIR';
my $events	  = 'ONCLICK|ONDBLCLICK|ONMOUSEDOWN|ONMOUSEUP|ONMOUSEOVER|'.
				'ONMOUSEMOVE|ONMOUSEOUT|ONKEYPRESS|ONKEYDOWN|ONKEYUP';
my $attrs	  = $coreattrs.'|'.$i18n.'|'.$events;


my %html_data =
(
	'obsolete' => 'PLAINTEXT|XMP|LISTING',

	'maybePaired'  => 'LI|DT|DD|P|TD|TH|TR|OPTION|COLGROUP|THEAD|TFOOT|'.
			'TBODY|COL',

	'pairElements' =>
		'A|ABBR|ACRONYM|ADDRESS|APPLET|BDO|HTML|HEAD|BIG|BLOCKQUOTE|BODY|CAPTION|DIV|'.
				'H1|H2|H3|H4|H5|H6|CENTER|FONT|MAP|FONT|OBJECT|'.
		'B|I|U|TT|STRONG|EM|CODE|KBD|VAR|DFN|CITE|SAMP|'.
		'DEL|INS|'.
		'UL|OL|DL|'.
		'LABEL|'.
				'MENU|DIR|FORM|NOSCRIPT|SCRIPT|'.
		'Q|'.
		'FRAMESET|IFRAME|NOFRAMES|'.
		'OPTGROUP|FIELDSET|LEGEND|BUTTON|'.
		'COL|COLGROUP|THEAD|TFOOT|TBODY|'.
				'SELECT|SMALL|STRIKE|S|SPAN|STYLE|'.
				'SUB|SUP|TABLE|TEXT|TEXTAREA|TITLE|CODE|PRE|'.
		'PLAINTEXT|XMP|LISTING|'.
		'LI|DT|DD|P|TD|TH|TR|OPTION',

	'cuddleContainers' => 'A|H1|H2|H3|H4|H5|H6|TITLE|LI',

	## expect to see these tags only once
	'onceOnly' => {
			'HTML'	=> 1,
			'HEAD'	=> 1,
			'BODY'	=> 1,
			'TITLE' => 1,
		},

	'physicalFontElements' =>
		{
			'B'  => 'STRONG',
			'I'  => 'EM',
			'TT' => 'CODE, SAMP, KBD, or VAR'
		},

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

	'expectedTags' => ['HEAD', 'TITLE', 'BODY'],

	## elements which cannot be nested
	'nonNest' => 'A|FORM',

	'validAttributes' =>
	{
	'A' 		 => $attrs.'|CHARSET|TYPE|NAME|HREF|HREFLANG|TARGET|'.
			'REL|REV|ACCESSKEY|SHAPE|COORDS|TABINDEX|ONFOCUS|'.
			'ONBLUR',
	'ADDRESS'	 => $attrs,
	'APPLET'	 => $coreattrs.'|CODEBASE|ARCHIVE|CODE|OBJECT|ALT|'.
			'NAME|WIDTH|HEIGHT|ALIGN|HSPACE|VSPACE',
	'AREA'		 => $attrs.'|SHAPE|COORDS|HREF|TARGET|NOHREF|ALT|TABINDEX|'.
			'ACCESSKEY|ONFOCUS|ONBLUR',
	'BASE'		 => 'HREF|TARGET',
	'BASEFONT'	 => 'ID|SIZE|COLOR|FACE',
	'BDO'		 => $coreattrs.'|'.$i18n,
	'BLOCKQUOTE' => $attrs.'|CITE',
	'BODY'		 => $attrs.'|BGCOLOR|TEXT|LINK|VLINK|ALINK|BACKGROUND|'.
							 'ONLOAD|ONUNLOAD',
	'BR'		 => $coreattrs.'|CLEAR',
	'BUTTON'	 => $attrs.'|NAME|VALUE|TYPE|DISABLED|TABINDEX|'.
			'ACCESSKEY|ONFOCUS|ONBLUR',
	'CAPTION'	 => $attrs.'|ALIGN',
	'CENTER'	 => $attrs,
	'COL'		 => $attrs.'|SPAN|WIDTH|ALIGN|CHAR|CHAROFF|VALIGN',
	'COLGROUP'	 => $attrs.'|SPAN|WIDTH|ALIGN|CHAR|CHAROFF|VALIGN',
	'DEL'		 => $attrs.'|CITE|DATETIME',
	'DIV'		 => $attrs.'|ALIGN',
	'DIR'		 => $attrs.'|COMPACT',
	'DD'		 => $attrs,
	'DL'		 => $attrs.'|COMPACT',
	'DT'		 => $attrs,
	'FIELDSET'	 => $attrs,
	'FONT'		 => $coreattrs.'|'.$i18n.'|SIZE|COLOR|FACE',
	'FORM'		 => $attrs.'|ACTION|METHOD|ENCTYPE|ONSUBMIT|'.
			'ONRESET|TARGET|ACCEPT-CHARSET',
	'FRAME' 	 => $coreattrs.'|LONGDESC|NAME|SRC|FRAMEBORDER|'.
			'MARGINWIDTH|MARGINHEIGHT|NORESIZE|SCROLLING',
	'FRAMESET'	 => $coreattrs.'|ROWS|COLS|ONLOAD|ONUNLOAD',
	'H1'		 => $attrs.'|ALIGN',
	'H2'		 => $attrs.'|ALIGN',
	'H3'		 => $attrs.'|ALIGN',
	'H4'		 => $attrs.'|ALIGN',
	'H5'		 => $attrs.'|ALIGN',
	'H6'		 => $attrs.'|ALIGN',
	'HEAD'		 => $i18n.'|PROFILE',
	'HR'		 => $coreattrs.'|'.$events.'|ALIGN|NOSHADE|SIZE|WIDTH',
	'HTML'		 => $i18n.'|VERSION',
	'IFRAME'	 => $coreattrs.'|LONGDESC|NAME|SRC|FRAMEBORDER|'.
			'MARGINWIDTH|MARGINHEIGHT|SCROLLING|ALIGN|'.
			'HEIGHT|WIDTH',
	'IMG'		 => $attrs.'|SRC|ALT|LONGDESC|HEIGHT|WIDTH|USEMAP|ISMAP|'.
			'ALIGN|BORDER|HSPACE|VSPACE',
	'INPUT' 	 => $attrs.'|TYPE|NAME|VALUE|CHECKED|DISABLED|READONLY|'.
			'SIZE|MAXLENGTH|SRC|ALT|USEMAP|TABINDEX|ACCESSKEY|'.
			'ONFOCUS|ONBLUR|ONSELECT|ONCHANGE|ACCEPT|ALIGN',
	'INS'		 => $attrs.'|CITE|DATETIME',
	'ISINDEX'	 => $coreattrs.'|'.$i18n.'|PROMPT',
	'LABEL' 	 => $attrs.'|FOR|ACCESSKEY|ONFOCUS|ONBLUR',
	'LEGEND'	 => $attrs.'|ACCESSKEY|ALIGN',
	'LI'		 => $attrs.'|TYPE|VALUE',
	'LINK'		 => $attrs.'|CHARSET|HREF|HREFLANG|TYPE|REL|REV|'.
			'MEDIA|TARGET',
	'LISTING'	 => 0,
	'MAP'		 => $attrs.'|NAME',
	'MENU'		 => $attrs.'|COMPACT',
	'META'		 => $i18n.'|HTTP-EQUIV|NAME|CONTENT|SCHEME',
	'NOFRAMES'	 => $attrs,
	'NOSCRIPT'	 => $attrs,
	'OBJECT'	 => $attrs.'|DECLARE|CLASSID|CODEBASE|DATA|TYPE|CODETYPE|'.
			'ARCHIVE|STANDBY|HEIGHT|WIDTH|USEMAP|NAME|TABINDEX|'.
			'ALIGN|BORDER|HSPACE|VSPACE',
	'OL'		 => $attrs.'|TYPE|COMPACT|START',
	'OPTGROUP'	 => $attrs.'|DISABLED|LABEL',
	'OPTION'	 => $attrs.'|SELECTED|DISABLED|LABEL|VALUE',
	'P' 		 => $attrs.'|ALIGN',
	'PARAM' 	 => 'ID|NAME|VALUE|VALUETYPE|TYPE',
	'PLAINTEXT'  =>  0,
	'PRE'		 => $attrs.'|WIDTH',
	'Q' 		 => $attrs.'|CITE',
	'SCRIPT'	 => 'CHARSET|TYPE|LANGUAGE|SRC|DEFER|EVENT|FOR',
	'SELECT'	 => $attrs.'|NAME|SIZE|MULTIPLE|DISABLED|TABINDEX|'.
			'ONFOCUS|ONBLUR|ONCHANGE',
	'SPAN'		 => $attrs,
	'STYLE' 	 => $i18n.'|TYPE|MEDIA|TITLE',
	'SUB'		 => $attrs,
	'SUP'		 => $attrs,
	'TABLE' 	 => $attrs.'|SUMMARY|WIDTH|BORDER|FRAME|RULES|'.
			'CELLSPACING|CELLPADDING|ALIGN|BGCOLOR|DATAPAGESIZE',
	'TD'		 => $attrs.'|ABBR|AXIS|HEADERS|SCOPE|ROWSPAN|COLSPAN|'.
			'ALIGN|CHAR|CHAROFF|VALIGN|NOWRAP|BGCOLOR|WIDTH|'.
			'HEIGHT',
	'TEXTAREA'	 => $attrs.'|NAME|ROWS|COLS|DISABLED|READONLY|TABINDEX|'.
			'ACCESSKEY|ONFOCUS|ONBLUR|ONSELECT|ONCHANGE',
	'TH'		 => $attrs.'|ABBR|AXIS|HEADERS|SCOPE|ROWSPAN|COLSPAN|'.
			'ALIGN|CHAR|CHAROFF|VALIGN|NOWRAP|BGCOLOR|WIDTH|'.
			'HEIGHT',
	'THEAD' 	 => $attrs.'|ALIGN|CHAR|CHAROFF|VALIGN',
	'TBODY' 	 => $attrs.'|ALIGN|CHAR|CHAROFF|VALIGN',
	'TFOOT' 	 => $attrs.'|ALIGN|CHAR|CHAROFF|VALIGN',
	'TITLE' 	 => $i18n,
	'TR'		 => $attrs.'|ALIGN|CHAR|CHAROFF|VALIGN|BGCOLOR',
	'TT'		 => 0,
	'UL'		 => $attrs.'|TYPE|COMPACT',
	'XMP'		 => 0,
	},

	'requiredAttributes' =>
	{
	'APPLET'	=> 'WIDTH|HEIGHT',
	'AREA'		=> 'ALT',
	'BASE'		=> 'HREF',
	'BASEFONT'	=> 'SIZE',
	'BDO'		=> 'DIR',
	'FORM'		=> 'ACTION',
	'IMG'		=> 'SRC|ALT',
	'LINK'		=> 'HREF',
	'MAP'		=> 'NAME',
	'NEXTID'	=> 'N',
	'SELECT'	=> 'NAME',
	'TEXTAREA'	=> 'NAME|ROWS|COLS'
	},

	'attributeFormat' =>
	{
		'ALIGN',	 'BOTTOM|MIDDLE|TOP|LEFT|CENTER|RIGHT|JUSTIFY|'.
				'BLEEDLEFT|BLEEDRIGHT|DECIMAL',
		'ALINK' 	 => $colorRE,
		'BGCOLOR'	   => $colorRE,
		'CLEAR',	'LEFT|RIGHT|ALL|NONE',
		'COLOR' 	 => $colorRE,
		'COLS', 	 '\d+|(\d*[*%]?,)*\s*\d*[*%]?',
		'COLSPAN',	   '\d+',
		'DIR'		=> 'LTR|RTL',
		'HEIGHT',	   '\d+',
		'INDENT',	   '\d+',
		'LINK'		=> $colorRE,
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
		'VLINK' 	 => $colorRE,
		'WIDTH',	 '\d+%?',
		'WRAP', 	 'OFF|VIRTUAL|PHYSICAL',
		'X',		 '\d+',
		'Y',		 '\d+'
	},

	'mustFollow' =>
	{
		'LH',		  'UL|OL|DL',
		'OVERLAY',	  'FIG',
		'HEAD', 	  'HTML',
		'BODY', 	  '/HEAD|NOFRAMES|/FRAMESET',
		'FRAMESET',   '/HEAD|/FRAME|FRAMESET|/FRAMESET|/NOFRAMES|HTML',

		# </BODY> can be implied, so it </HTML> can really
		# follow rather a lot of elements :-)
		# This should be added if people want to require explicit
		# use <BODY> etc.
		# '/HTML',		'/BODY|/FRAMESET|/NOFRAMES',
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

foreach my $elt (@fontstyle, @phrase)
{
   $html_data{validAttributes}->{$elt} = $attrs;
}

sub new
{
	my $class = shift;


	return bless \%html_data, $class;
}

1;
__END__

=head1 NAME

HTML::Lint::Test - test harness for weblint tests

=head1 SYNOPSIS

	use HTML::Lint::Test qw(run_tests);
	
	run_tests();
	exit 0;
	__END__
	... test data ...


=head1 DESCRIPTION

B<HTML::Lint::Test> is a module which provides the test harness for
the testsuites which are included in the weblint distribution.
This provides a simple format for tests, as described in
the section L<TEST FORMAT> below.

=head1 TEST FORMAT

Test data is provided in the DATA section of the test script;
this is everything after the magic __END__ symbol.

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

