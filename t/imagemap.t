#!/usr/local/bin/perl -w
#
# imagemap.t - weblint tests related to image maps
#
# Copyright (C) 1995-1999 Neil Bowers.  All rights reserved.
#
# See README for additional blurb.
# Bugs, comments, suggestions welcome: neilb@weblint.org
#
# $Id: imagemap.t,v 1.2 1999/03/24 21:14:58 neilb Exp $
#

use lib qw( . t/ );
use LintTest qw(run_tests);
use strict;

run_tests();

exit 0;

#============================================================================
#============================================================================

__END__
IMG element with ALT and ISMAP attributes
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<IMG SRC=foo.gif ISMAP ALT="alt text">
</BODY></HTML>
#------------------------------------------------------------------------
AREA can only appear in a MAP, MAP must have a NAME
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<AREA SHAPE="RECT" COORDS="10,10,20,20" HREF="foo.html" alt="">
<MAP>
<AREA SHAPE="RECT" COORDS="40,40,50,50" NOHREF alt="alt text">
</MAP>
</BODY></HTML>
####
2:required-context
3:required-attribute
#------------------------------------------------------------------------
Another client side image map example
####
<HTML>
<HEAD>
    <TITLE>test</TITLE>
</HEAD>
<BODY>
<MAP NAME="testmap"
	id=mymap class=client style="foo" title="my map"
	lang=en dir=ltr onmouseover="over()">
    <AREA ALT="alt test" COORDS="1,1,2,2" SHAPE=RECT HREF="foo.html">
    <AREA ALT="foo bar" COORDS="1,1,2,2" SHAPE=RECT HREF="foo.html">
    <AREA COORDS="2,2,4,4" SHAPE=CIRCLE NOHREF onfocus="focus()"
	onblur="blur()" tabindex=2 accesskey=f alt="alt text" target="_top"
	id=myarea class=client style="foo" title="my area"
	lang=end dir=ltr>
</MAP>
</BODY>
</HTML>
#------------------------------------------------------------------------
