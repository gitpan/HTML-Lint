#!/usr/local/bin/perl -w
#
# html4.t - basic weblint tests for HTML 4 features
#
# Copyright (C) 1995-1999 Neil Bowers.  All rights reserved.
#
# See README for additional blurb.
# Bugs, comments, suggestions welcome: neilb@weblint.org
#
# $Id: html4.t,v 1.4 1999/04/05 17:00:08 neilb Exp $
#

use lib '/home/neilb/weblint/lib';
use Weblint::Test qw(run_tests);
use strict;

run_tests();

exit 0;

#============================================================================
#============================================================================

__END__
simple syntactically correct html
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>this is the body</BODY>
</HTML>
#------------------------------------------------------------------------
paragraph usage
####
<HTML>
<HEAD><TITLE>paragraph usage</TITLE></HEAD>
<BODY><P>first paragraph</P><P>second paragraph</P></BODY>
</HTML>
#------------------------------------------------------------------------
paragraph usage with all valid attributes
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
    <P align=center id=mine class=para style="sad" title="the one and only"
	lang=en dir=ltr
	onclick="click()"
	ondblclick="dblclick()"
	onmousedown="mousedown()"
	onmouseup="mouseup()"
	onmouseover="mouseover()"
	onmousemove="mousemove()"
	onmouseout="mouseout()"
	onkeypress="keypress()"
	onkeydown="keydown()"
	onkeyup="keyup()"
    >Hello, World!</P>
</BODY>
</HTML>
#------------------------------------------------------------------------
html which starts with DOCTYPE specifier
####
<!DOCTYPE HTML PUBLIC '-//W3O//DTD WWW HTML 2.0//EN'>
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>this is the body</BODY>
</HTML>
#------------------------------------------------------------------------
correct use of information type and font style elements
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<EM>Emphasized Text</EM>
<CITE>Cited Text</CITE>
<STRONG>Strongly emphasized Text</STRONG>
<CODE>Teletype Text</CODE>
<SAMP>sequence of literal characters</SAMP>
<KBD>Keyboarded Text</KBD>
<VAR>Variable name</VAR>
<DFN>Defining instance</DFN>
<B>Bold text</B>
<I>Italic text</I>
<TT>Teletype text</TT>
<U>Underlined text</U>
<STRIKE>Striked through text</STRIKE>
<BIG>Big text</BIG>
<SMALL>Small text</SMALL>
<SUB>Subscript text</SUB>
<SUP>Superscript text</SUP>
</BODY></HTML>
#------------------------------------------------------------------------
newline within a tag
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<IMG SRC="foo.gif"
 ALT="alt text">
</BODY></HTML>
#------------------------------------------------------------------------
simple comment
####
<!-- comment before the HTML element -->
<HTML>
<!-- comment between the HTML and HEAD elements -->
<HEAD>
<!-- comment in the HEAD element -->
<TITLE>foo</TITLE></HEAD><BODY>
<!-- this is a simple comment in the body -->
this is the body
</BODY>
<!-- comment between end of BODY and end of HTML -->
</HTML>
<!-- comment after the end of the HTML element -->
####
#------------------------------------------------------------------------
comment with space before the closing >
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<!-- this is a simple comment -- >
this is the body
</BODY></HTML>

#------------------------------------------------------------------------
whitespace around the = of an element attribute
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<IMG SRC = foo.gif ALT="alt text">
</BODY></HTML>
#------------------------------------------------------------------------
no HTML tags around document
####
<HEAD><TITLE>title</TITLE></HEAD>
<BODY>this is the body</BODY>
####
1:html-outer
1:must-follow
#------------------------------------------------------------------------
whitespace between opening < and tag name
####
<HTML><HEAD>< TITLE>title</TITLE></HEAD>
<BODY>this is the body</BODY></HTML>
####
1:leading-whitespace
#------------------------------------------------------------------------
bad style to use "here" as anchor text
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY><A HREF="foo.html">here</A></BODY>
</HTML>
####
3:here-anchor
#------------------------------------------------------------------------
mis-matched heading tags <H1> .. </H2>
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY><H1>title</H2></BODY>
</HTML>
####
3:heading-mismatch
#------------------------------------------------------------------------
obsolete element
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY><XMP>foobar()</XMP></BODY></HTML>
####
3:obsolete
#------------------------------------------------------------------------
illegal attribute in B element
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY><B FOO>foobar</B></BODY></HTML>
####
3:unknown-attribute
#------------------------------------------------------------------------
empty tag: <>
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY><>this is the body</BODY></HTML>
####
3:unknown-element
#------------------------------------------------------------------------
unclosed comment
####
<HTML><HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<!-- this is an unclosed comment >
</BODY></HTML>
####
3:unclosed-comment
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
repeated attribute
####
<HTML><HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<IMG SRC="foo.gif" SRC="foo.gif" ALT="alt text">
</BODY></HTML>
####
3:repeated-attribute
#------------------------------------------------------------------------
no HTML tags around document, last thing is valid comment
####
<HEAD><TITLE>title</TITLE></HEAD>
<BODY>this is the body</BODY>
<!-- this is a valid comment -->
####
1:html-outer
1:must-follow
#------------------------------------------------------------------------
spurious text between HEAD and BODY elements
####
<HTML><HEAD><TITLE>title</TITLE></HEAD>
Should not put any text here!
<BODY>this is the body</BODY></HTML>
####
3:must-follow
#------------------------------------------------------------------------
attributes on closing tag
####
<HTML><HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<A NAME="foobar">bleh</A NAME="foobar">
</BODY></HTML>
####
3:closing-attribute
#------------------------------------------------------------------------
use of ' as attribute value delimiter
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<IMG SRC = foo.gif ALT='alt text'>
</BODY></HTML>
####
2:attribute-delimiter
#------------------------------------------------------------------------
IMG without HEIGHT and WIDTH attributes
-e img-size
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<IMG SRC = foo.gif ALT="alt text">
</BODY></HTML>
####
2:img-size
#------------------------------------------------------------------------
use of -pedantic command-line switch
-pedantic
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<IMG SRC = foo.gif ALT="alt text">
<B>This is bold text -- should use the STRONG element</B>
<A HREF="foobar.html">non-existent file</A>
</BODY></HTML>
####
1:mailto-link
2:img-size
3:physical-font
#------------------------------------------------------------------------
leading whitespace in container
-e container-whitespace
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<A HREF=foobar.html> hello</A>
</BODY></HTML>
####
2:container-whitespace
#------------------------------------------------------------------------
valid Java applet
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<APPLET CODEBASE="http://java.sun.com/JDK-prebeta1/applets/NervousText" CODE="NervousText.class" WIDTH=400 HEIGHT=75 ALIGN=CENTER>
<PARAM NAME="text" VALUE="This is the applet viewer.">
<BLOCKQUOTE>
If you were using a Java-enabled browser,
you wouldn't see this!
</BLOCKQUOTE>
</APPLET>
</BODY></HTML>
#------------------------------------------------------------------------
PARAM can only appear in an APPLET element
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<PARAM NAME="text" VALUE="This is the applet viewer.">
</BODY></HTML>
####
2:required-context
#------------------------------------------------------------------------
non-empty list element, with comment last thing
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<UL>
<LI>line 9
<!-- line 10 -->
<LI>line 11
</UL>
</BODY></HTML>
####
#------------------------------------------------------------------------
html which doesn't start with DOCTYPE
-e require-doctype
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>this is the body</BODY>
</HTML>
####
1:require-doctype
#------------------------------------------------------------------------
html which starts with DOCTYPE
-e require-doctype
####
<!DOCTYPE HTML PUBLIC '-//W3O//DTD WWW HTML 2.0//EN'>
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>this is the body</BODY>
</HTML>
#------------------------------------------------------------------------
should use &gt; in place of >
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
text with > instead of &gt;
</BODY>
</HTML>
####
4:literal-metacharacter
#------------------------------------------------------------------------
text appearing in unexpected context
####
<HTML>
<HEAD>
Having text here is not legal!
<TITLE>test</TITLE></HEAD>
<BODY>
<UL>
Having text here is not legal!
</UL>
<OL>
Having text here is not legal!
</OL>
<DL>
Having text here is not legal!
</DL>
<TABLE>
Having text here is not legal!
<TR>
Having text here is not legal!
<TD>This is ok</TD>
</TR>
</TABLE>
</BODY></HTML>
####
4:bad-text-context
8:bad-text-context
11:bad-text-context
14:bad-text-context
17:bad-text-context
19:bad-text-context
#------------------------------------------------------------------------
IMG element with illegal value for ALIGN attribute
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<IMG SRC=foo.gif ALIGN=MODDLE ALT="alt text=">
</BODY></HTML>
####
2:attribute-format
#------------------------------------------------------------------------
HR element can have percentage width
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<HR WIDTH="50%">
</BODY></HTML>
#------------------------------------------------------------------------
correct and incorrect values for CLEAR attribute
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
ok left<BR CLEAR=LEFT>
ok right<BR CLEAR=RIGHT>
ok all<BR CLEAR=ALL>
not ok<BR CLEAR=RIHGT>
</BODY>
</HTML>
####
7:attribute-format
#------------------------------------------------------------------------
illegal color attribute values
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY ALINK="#ffaaff" VLINK="#ggaagg">
This is the body of the page
</BODY>
</HTML>
####
3:attribute-format
3:body-colors
#------------------------------------------------------------------------
unquoted attribute value which should be quoted
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY TEXT=#00ffff>
<TABLE WIDTH=100%>
<TR><TH>Heading<TD>Datum</TD></TR>
</TABLE>
</BODY>
</HTML>
####
3:body-colors
3:quote-attribute-value
4:quote-attribute-value
#------------------------------------------------------------------------
use of > in a PRE element
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
<PRE>
   if (x > y)
      printf("x is greater than y");
</PRE>
</BODY>
</HTML>
####
5:meta-in-pre
#------------------------------------------------------------------------
heading inside an anchor
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
<A NAME="foo"><H2>Bogus heading in anchor</H2></A>
</BODY>
</HTML>
####
4:heading-in-anchor
#------------------------------------------------------------------------
IMG with ALT set to empty string
####
<HTML>
<HEAD>
<TITLE>test</TITLE>
</HEAD>
<BODY>
<IMG SRC="foo.gif" ALT="">
<IMG SRC="foo.gif" ALT=''>
</BODY>
</HTML>
####
7:attribute-delimiter
#------------------------------------------------------------------------
use of > multiple times in a PRE element
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
<PRE>
   if (x > y)
      foobar();
   if (x > z)
      barfoo();
</PRE>
</BODY>
</HTML>
####
5:meta-in-pre
7:meta-in-pre
#------------------------------------------------------------------------
don't check attributes of unknown elements
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
Hello, <BOB SIZE="+1">World!</BOB>
</BODY>
</HTML>
####
4:unknown-element
4:unknown-element
#------------------------------------------------------------------------
legal attributes on BODY element
####
<HTML>
<HEAD>
  <TITLE>test</TITLE>
</HEAD>
<BODY BACKGROUND="back.gif" BGCOLOR=white TEXT=black
 LINK=blue VLINK=red ALINK=purple onload="onload()" onunload="unload()"
 id=bodyid class=structure title=bodytitle style="foo" lang=en dir=ltr>
    Hello, World!
</BODY>
</HTML>
#------------------------------------------------------------------------
Wilbur test #2
####
<HTML>
<HEAD>
    <ISINDEX PROMPT="text prompt">
    <TITLE>test</TITLE>
    <LINK HREF="foo" REL="rel" REV=MADE TITLE="le title">
</HEAD>
<BODY>
<BASEFONT SIZE=4>
    <APPLET ALIGN=LEFT ALT="alt text" CODE="foo code"
     CODEBASE="applets" HEIGHT=100 HSPACE=5 NAME=applet
     VSPACE=5 WIDTH=100>
        <PARAM NAME="fruit" VALUE="banana">
    </APPLET>
<MAP NAME="testmap">
    <AREA ALT="alt test" COORDS="1,1,2,2" SHAPE=RECT
     HREF="foo.html">
    <AREA COORDS="2,2,4,4" SHAPE=CIRCLE NOHREF alt="alt text">
</MAP>
<BR><BR CLEAR=LEFT><BR CLEAR=RIGHT><BR CLEAR=ALL><BR CLEAR=NONE>
<DIR><LI>item 1<LI>item 2</DIR>
<DIR COMPACT><LI>item 1<LI>item 2</DIR>
<DIV>a text division</DIV>
<DIV ALIGN=LEFT>left aligned text</DIV>
<DIV ALIGN=CENTER>center aligned text</DIV>
<DIV ALIGN=RIGHT>right aligned text</DIV>
<FONT SIZE=4>size 4 text</FONT>
<FONT COLOR=red>red text</FONT>
<IMG ALIGN=LEFT ALT="alt text" BORDER=1
 HEIGHT=50 HSPACE=5 ISMAP
 SRC="foo.gif" USEMAP VSPACE=5 WIDTH=50>
<UL><LI TYPE=DISC>item 1<LI TYPE=SQUARE>item 2
    <LI TYPE=CIRCLE>item 3</UL>
<OL><LI TYPE=A VALUE=1>item 1<LI TYPE=a>item 2
    <LI TYPE=i>item 3<LI TYPE=I>item 4<LI TYPE=1>item 5</OL>
<MENU><LI>item 1<LI>item 2</MENU>
<MENU COMPACT><LI>compact item 1<LI>compact item 2</MENU>
<OL TYPE=a START=1 COMPACT><LI>item 1<LI>item 2</OL>
<P ALIGN=CENTER>centered paragraph</P>
<UL TYPE=disc COMPACT><LI>item 1<LI>item 2</UL>
</BODY>
</HTML>
#------------------------------------------------------------------------
Legal use of ADDRESS element
####
<HTML>
<HEAD>
  <TITLE>test</TITLE>
</HEAD>
<BODY>
Hello, World!
<ADDRESS lang=en dir=ltr title=address>Neil Bowers</ADDRESS>
</BODY>
</HTML>
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
H1 through H6 with combinations of legal attributes
<none>
####
<HTML><HEAD><TITLE>headings</TITLE></HEAD>
<BODY>
<H1 lang=en dir=ltr>Level 1 heading</H1>
<H2 id=myid class=heading style="cool" title="heading" ALIGN=LEFT
	>level 2 heading</H2>
<H3 ALIGN=CENTER
	onclick="click()"
	ondblclick="dblclick()"
	onmousedown="mousedown()"
	onmouseup="mouseup()"
	onmouseover="mouseover()"
	onmousemove="mousemove()"
	onmouseout="mouseout()"
	onkeypress="keypress()"
	onkeydown="keydown()"
	onkeyup="keyup()"
	>level 3</H3>
<H4 ALIGN=CENTER>level 4</H4>
<H5 ALIGN=CENTER>level 5</H5>
<H6 ALIGN=CENTER>level 6</H6>
</BODY></HTML>
#------------------------------------------------------------------------
HR with all attributes set
####
<HTML><HEAD><TITLE>valid HR example</TITLE></HEAD>
<BODY>
Hello
<HR NOSHADE WIDTH="50%" SIZE=3 ALIGN=CENTER id=no1 class=rule style="cool"
	title="my horizontal rule">
World
</BODY></HTML>
#------------------------------------------------------------------------
HR can't take LANG or DIR attributes (for hopefully obvious reasons :-)
####
<HTML><HEAD><TITLE>illegal attributes on HR</TITLE></HEAD>
<BODY>
Hello
<HR NOSHADE WIDTH="50%" SIZE=3 ALIGN=CENTER id=no1 class=rule style="cool"
	title="my horizontal rule" lang=en dir=rtl>
World
</BODY></HTML>
####
5:unknown-attribute
5:unknown-attribute
#------------------------------------------------------------------------
Valid use of BR with all legal attributes
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD>
<BODY>
	Hello
	<BR id=breaks class=private style="foo" title="break" clear=all>
	World!
</BODY>
</HTML>
#------------------------------------------------------------------------
Valid use of CENTER element
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD>
<BODY>
	<CENTER id=foobar class=formatting style="foo" title="center"
	 lang=en dir=ltr>
		Hello, World!
	</CENTER>
</BODY>
</HTML>
#------------------------------------------------------------------------
Valid use of A element with lots of attributes
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD>
<BODY>
	We also have a
	<A HREF="japanese.html" HREFLANG=ja NAME=foo TARGET="_top"
		ACCESSKEY="a">Japanese version</A>.
</BODY>
</HTML>
#------------------------------------------------------------------------
Valid use of PRE element with all valid attributes
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD>
<BODY>
    <PRE WIDTH="80%"
	id=foobar class=formatting style="foo" title="pre-formatted block"
	lang=en dir=ltr
	onclick="click()"
	ondblclick="dblclick()"
	onmousedown="mousedown()"
	onmouseup="mouseup()"
	onmouseover="mouseover()"
	onmousemove="mousemove()"
	onmouseout="mouseout()"
	onkeypress="keypress()"
	onkeydown="keydown()"
	onkeyup="keyup()"
	>
	Alas poor Yorkie, I ate it well, Horatio.
    </PRE>
</BODY>
</HTML>
#------------------------------------------------------------------------
simple use of Q element
####
<HTML><HEAD><TITLE>quotation</TITLE></HEAD>
<BODY>
    <Q>Hello, Sailor!</Q>
</BODY>
</HTML>
#------------------------------------------------------------------------
Valid use of Q element with all valid attributes
####
<HTML><HEAD><TITLE>quotation</TITLE></HEAD>
<BODY>
    <Q CITE="http://www.weblint.org/~neilb/quotations/"
	id=foobar class=formatting style="foo" title="quotation"
	lang=en dir=ltr
	onclick="click()"
	ondblclick="dblclick()"
	onmousedown="mousedown()"
	onmouseup="mouseup()"
	onmouseover="mouseover()"
	onmousemove="mousemove()"
	onmouseout="mouseout()"
	onkeypress="keypress()"
	onkeydown="keydown()"
	onkeyup="keyup()"
	>
	Alas poor Yorkie, I ate it well, Horatio.
    </Q>
</BODY>
</HTML>
#------------------------------------------------------------------------
simple use of BLOCKQUOTE element
####
<HTML><HEAD><TITLE>block quotation</TITLE></HEAD>
<BODY>
    <BLOCKQUOTE>Hello, Sailor!</BLOCKQUOTE>
</BODY>
</HTML>
#------------------------------------------------------------------------
Valid use of BLOCKQUOTE element with all valid attributes
####
<HTML><HEAD><TITLE>block quotation</TITLE></HEAD>
<BODY>
    <BLOCKQUOTE CITE="http://www.weblint.org/~neilb/quotations/"
	id=foobar class=formatting style="foo" title="lock stock"
	lang=en dir=ltr
	onclick="click()"
	ondblclick="dblclick()"
	onmousedown="mousedown()"
	onmouseup="mouseup()"
	onmouseover="mouseover()"
	onmousemove="mousemove()"
	onmouseout="mouseout()"
	onkeypress="keypress()"
	onkeydown="keydown()"
	onkeyup="keyup()"
	>
	Alas poor Yorkie, I ate it well, Horatio.
    </BLOCKQUOTE>
</BODY>
</HTML>
#------------------------------------------------------------------------
Valid use of INS and DEL elements with all valid attributes
####
<HTML>
     <HEAD><TITLE>insertions & deletions</TITLE></HEAD>
<BODY>

    <INS CITE="http://www.weblint.org/~neilb/insertions/"
	DATETIME="1999-03-24T11:54:00Z"
	id=foobar class=formatting style="foo" title="lock stock"
	lang=en dir=ltr
	onclick="click()"
	ondblclick="dblclick()"
	onmousedown="mousedown()"
	onmouseup="mouseup()"
	onmouseover="mouseover()"
	onmousemove="mousemove()"
	onmouseout="mouseout()"
	onkeypress="keypress()"
	onkeydown="keydown()"
	onkeyup="keyup()"
	>
	Some inserted text
    </INS>

    <DEL CITE="http://www.weblint.org/~neilb/deletions/"
	DATETIME="1999-03-24T11:55:00Z"
	id=foobar class=formatting style="foo" title="lock stock"
	lang=en dir=ltr
	onclick="click()"
	ondblclick="dblclick()"
	onmousedown="mousedown()"
	onmouseup="mouseup()"
	onmouseover="mouseover()"
	onmousemove="mousemove()"
	onmouseout="mouseout()"
	onkeypress="keypress()"
	onkeydown="keydown()"
	onkeyup="keyup()"
	>
	Some deleted text
    </DEL>

</BODY>
</HTML>
#------------------------------------------------------------------------
Valid example of SPAN usage
####
<HTML>
     <HEAD><TITLE>simple SPAN usage</TITLE></HEAD>
<BODY>

    <!-- English Messages -->
    <P><SPAN id=msg1 class=info lang=en>Variable declared twice</SPAN>
    <P><SPAN id=msg2 class=warning lang=en>undeclared variable</SPAN>
    <P><SPAN id=msg3 class=error lang=en>Bad syntax for variable name</SPAN>

</BODY>
</HTML>
#------------------------------------------------------------------------
Example of DIV and SPAN usage
####
<HTML>
     <HEAD><TITLE>DIV and SPAN usage</TITLE></HEAD>
<BODY>

    <DIV id="client-boyera" class="client">
    <P><SPAN class="client-title">Client information</SPAN>
    <TABLE class="client-data">
    <TR><TH>Last name:<TD>Boyera</TR>
    <TR><TH>First name:<TD>Stephane</TR>
    <TR><TH>Tel:<TD>(212) 555-1212</TR>
    <TR><TH>Email:<TD>sb@foo.org</TR>
    </TABLE>
    </DIV>

</BODY>
</HTML>
#------------------------------------------------------------------------
Example of BODY without any colors
####
<HTML>
    <HEAD><TITLE>simple HTML example</TITLE></HEAD>
<BODY>
    Hello, World!
</BODY>
</HTML>
#------------------------------------------------------------------------
Example of BODY with only some color attributes
####
<HTML>
    <HEAD><TITLE>BODY with only some color attributes</TITLE></HEAD>
<BODY BGCOLOR="#ffffff">
    Hello, World!
</BODY>
</HTML>
####
3:body-colors
#------------------------------------------------------------------------
Example of BODY with all color attributes
####
<HTML>
    <HEAD><TITLE>BODY with all color attributes</TITLE></HEAD>
<BODY BGCOLOR="#ffffff" TEXT=black LINK=blue VLINK=purple ALINK=red>
    Hello, World!
</BODY>
</HTML>
#------------------------------------------------------------------------
