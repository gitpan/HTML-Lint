#!/usr/local/bin/perl -w
#
# font.t - weblint tests related to fonts
#
# Copyright (C) 1995-1999 Neil Bowers.  All rights reserved.
#
# See README for additional blurb.
# Bugs, comments, suggestions welcome: neilb@weblint.org
#
# $Id: font.t,v 1.2 1999/03/24 21:14:56 neilb Exp $
#

use lib '/home/neilb/weblint/lib';
use Weblint::Test qw(run_tests);
use strict;

run_tests();

exit 0;

#============================================================================
#============================================================================

__END__
correct use of information type and font style elements
####
<HTML>
    <HEAD><TITLE>foo</TITLE></HEAD>
    <BODY>
	<TT lang=en dir=ltr class=style id=foo title=em>Teletype text</TT>
	<I lang=en dir=ltr class=style id=foo title=em>Italic text</I>
	<B lang=en dir=ltr class=style id=foo title=em>Bold text</B>
	<U lang=en dir=ltr class=style id=foo title=em>Underlined text</U>
	<S lang=en dir=ltr class=style id=foo title=em>Striked through text</S>
	<STRIKE lang=en dir=ltr class=style id=foo title=em>Striked through text</STRIKE>
	<BIG lang=en dir=ltr class=style id=foo title=em>Big text</BIG>
	<SMALL lang=en dir=ltr class=style id=foo title=em>Small text</SMALL>

	<EM lang=en dir=ltr class=style id=foo title=em>Emphasized Text</EM>
	<STRONG lang=en dir=ltr class=style id=foo title=em>Strongly emphasized Text</STRONG>
	<DFN lang=en dir=ltr class=style id=foo title=em>Defining instance</DFN>
	<CODE lang=en dir=ltr class=style id=foo title=em>Teletype Text</CODE>
	<SAMP lang=en dir=ltr class=style id=foo title=em>sequence of literal characters</SAMP>
	<KBD lang=en dir=ltr class=style id=foo title=em>Keyboarded Text</KBD>
	<VAR lang=en dir=ltr class=style id=foo title=em>Variable name</VAR>
	<CITE lang=en dir=ltr class=style id=foo title=em>Cited Text</CITE>
	<ABBR lang=en dir=ltr class=style id=foo title=em>Cited Text</ABBR>
	<ACRONYM lang=en dir=ltr class=style id=foo title=em>Cited Text</ACRONYM>
	<SUB lang=en dir=ltr class=style id=foo title=em>Subscript text</SUB>
	<SUP lang=en dir=ltr class=style id=foo title=em>Superscript text</SUP>
    </BODY>
</HTML>
#------------------------------------------------------------------------
illegal attribute in B element
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY><B FOO>foobar</B></BODY></HTML>
####
3:unknown-attribute
#------------------------------------------------------------------------
use of physical font markup
-e physical-font
####
<HTML><HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<B>This is bold text</B>
<STRONG>This is strong text</STRONG>
</BODY></HTML>
####
3:physical-font
#------------------------------------------------------------------------
All text style elements
####
<HTML><HEAD><TITLE>test</TITLE></HEAD><BODY>
    <B>      bold text        </B>
    <BIG>    big text         </BIG>
    <I>      italic text      </I>
    <KBD>    keyboard text    </KBD>
    <CITE>   citation         </CITE>
    <CODE>   code goes here   </CODE>
    <EM>     emphasised text  </EM>
    <SAMP>   sample text      </SAMP>
    <SMALL>  small text       </SMALL>
    <STRIKE> strikeout text   </STRIKE>
    <STRONG> strong emphasis  </STRONG>
    <SUB>    subscript text   </SUB>
    <SUP>    superscript text </SUP>
    <TT>     typewriter font  </TT>
    <U>      underlined text  </U>
    <BLOCKQUOTE>blockquoted text</BLOCKQUOTE>
    <FONT FACE=Helvetica SIZE=4 COLOR=red>red helvetica text</FONT>
</BODY></HTML>
#------------------------------------------------------------------------
legal use of BASEFONT
####
<HTML><HEAD><TITLE>test</TITLE></HEAD><BODY>
	<BASEFONT id=base size=4 color=red face=helvetica>
</BODY></HTML>
#------------------------------------------------------------------------
legal use of BASEFONT - SIZE attribute is required
####
<HTML><HEAD><TITLE>test</TITLE></HEAD><BODY>
	<BASEFONT id=base color=red face=helvetica>
</BODY></HTML>
####
2:required-attribute
#------------------------------------------------------------------------
legal use of FONT
####
<HTML><HEAD><TITLE>test</TITLE></HEAD><BODY>
	<FONT lang=en class=greeting dir=ltr id=base size=4
	 color=red face=helvetica>
		Hello, World!
	</FONT>
</BODY></HTML>
#------------------------------------------------------------------------
