#!/usr/local/bin/perl -w
#
# lists.t - weblint tests for list elements
#
# Copyright (C) 1995-1999 Neil Bowers.  All rights reserved.
#
# See README for additional blurb.
# Bugs, comments, suggestions welcome: neilb@weblint.org
#
# $Id: lists.t,v 1.2 1999/03/24 21:14:59 neilb Exp $
#

use lib '/home/neilb/weblint/lib';
use Weblint::Test qw(run_tests);
use strict;

run_tests();

exit 0;

#============================================================================
#============================================================================

__END__
legal unordered list
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<UL>
<LI>first item
<LI>second item</LI>
</UL>
</BODY></HTML>
#------------------------------------------------------------------------
legal definition list
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<DL>
<DT>first tag<DD>first definition
<DT>second tag<DD>second definition
</DL>
</BODY></HTML>
#------------------------------------------------------------------------
LI element must be used in DIR, MENU, OL, OL or UL
####
<HTML><HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<DIR><LI>legal list item in DIR</DIR>
<MENU><LI>legal list item in MENU</MENU>
<OL><LI>legal list item in OL</OL>
<UL><LI>legal list item in UL</UL>
<LI>illegal list item
</BODY></HTML>
####
7:required-context
#------------------------------------------------------------------------
empty list element
####
<HTML><HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<UL>
<LI>this is the first element
<LI>
<LI>this is the third or second element...
</UL>
</BODY></HTML>
####
5:empty-container
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
leading whitespace in list item
-e container-whitespace
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
<UL>
<LI>First item
<LI> Second item
<LI>Third item
</UL>
</BODY>
</HTML>
####
6:container-whitespace
#------------------------------------------------------------------------
empty list items
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
<UL>
<LI>
<LI>Second item
<LI>
<LI>Fourth item
<LI>
</UL>
</BODY>
</HTML>
####
5:empty-container
7:empty-container
9:empty-container
#------------------------------------------------------------------------
definition list with all valid attributes on elements
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
    <DL COMPACT
	id=foobar class=list style="foo" title="lock stock"
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
	<DT
	    id=foobar class=list style="foo" title="lock stock"
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
	    >word</DT>
	<DD
	    id=foobar class=list style="foo" title="lock stock"
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
	    >definition</DD>
    </DL>
</BODY>
</HTML>
#------------------------------------------------------------------------
ordered list (OL) with all valid attributes on elements
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
    <OL TYPE=1 COMPACT START=1
	id=foobar class=list style="foo" title="lock stock"
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
	<LI
	    TYPE=a VALUE=1
	    id=foobar class=list style="foo" title="lock stock"
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
	    >list item number 1</LI>
	<LI
	    TYPE=1 VALUE=2
	    id=foobar class=list style="foo" title="lock stock"
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
	    >list item number 2</LI>
    </OL>
</BODY>
</HTML>
#------------------------------------------------------------------------
unordered list (UL) with all valid attributes on elements
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
    <UL TYPE=square COMPACT
	id=foobar class=list style="foo" title="lock stock"
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
	<LI
	    TYPE=disc
	    id=foobar class=list style="foo" title="lock stock"
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
	    >list item number 1</LI>
	<LI
	    TYPE=square
	    id=foobar class=list style="foo" title="lock stock"
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
	    >list item number 2</LI>
    </UL>
</BODY>
</HTML>
#------------------------------------------------------------------------
directory list (DIR) with all valid attributes on elements
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
    <DIR COMPACT
	id=foobar class=list style="foo" title="lock stock"
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
	<LI
	    id=foobar class=list style="foo" title="lock stock"
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
	    >directory list item number 1</LI>
	<LI
	    id=foobar class=list style="foo" title="lock stock"
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
	    >directory list item number 2</LI>
    </DIR>
</BODY>
</HTML>
#------------------------------------------------------------------------
menu list (MENU) with all valid attributes on elements
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
    <MENU COMPACT
	id=foobar class=list style="foo" title="lock stock"
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
	<LI
	    id=foobar class=list style="foo" title="lock stock"
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
	    >menu list item number 1</LI>
	<LI
	    id=foobar class=list style="foo" title="lock stock"
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
	    >menu list item number 2</LI>
    </MENU>
</BODY>
</HTML>
#------------------------------------------------------------------------
