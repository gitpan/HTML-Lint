#!/usr/local/bin/perl -w
#
# head.t - weblint tests for HEAD related elements
#
# Copyright (C) 1995-1999 Neil Bowers.  All rights reserved.
#
# See README for additional blurb.
# Bugs, comments, suggestions welcome: neilb@weblint.org
#
# $Id: head.t,v 1.2 1999/03/24 21:14:57 neilb Exp $
#

use lib '/home/neilb/weblint/lib';
use Weblint::Test qw(run_tests);
use strict;

run_tests();

exit 0;

#============================================================================
#============================================================================

__END__
TITLE element can only appear once
####
<HTML>
    <HEAD>
	<TITLE>first title</TITLE>
	<TITLE>second title</TITLE>
    </HEAD>
    <BODY>this is the body</BODY>
</HTML>
####
4:once-only
#------------------------------------------------------------------------
TITLE element with all valid attributes
####
<HTML>
    <HEAD>
	<TITLE lang=en dir=ltr>foo</TITLE>
    </HEAD>
    <BODY>this is the body</BODY>
</HTML>
#------------------------------------------------------------------------
META element with all valid attributes
####
<HTML>
    <HEAD>
	<TITLE>meta example</title>
	<META NAME="keywords" LANG=en DIR=ltr CONTENT="html, validation">
	<META http-equiv=refresh CONTENT="3; http://www.weblint.org/">
	<META SCHEME=ISBN name=identifier content="0-8230-2355-9">
    </HEAD>
    <BODY>this is the body</BODY>
</HTML>
#------------------------------------------------------------------------
acceptable usage of META element
####
<HTML><HEAD><TITLE>foo</TITLE>
<META NAME="IndexType" CONTENT="Service"></HEAD>
<BODY>this is the body</BODY></HTML>
#------------------------------------------------------------------------
no TITLE element in HEAD
####
<HTML>
<HEAD></HEAD>
<BODY>this is the body</BODY>
</HTML>
####
2:empty-container
2:require-head
#------------------------------------------------------------------------
unclosed TITLE in HEAD
####
<HTML>
<HEAD><TITLE></HEAD>
<BODY>this is the body</BODY>
</HTML>
####
2:unclosed-element
#------------------------------------------------------------------------
empty title element
####
<HTML><HEAD><TITLE></TITLE></HEAD>
<BODY>this is the body</BODY></HTML>
####
1:empty-container
#------------------------------------------------------------------------
TITLE of page is longer then 64 characters
####
<HTML>
<HEAD><TITLE>WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW</TITLE></HEAD>
<BODY>
body of page
</BODY>
</HTML>
####
2:title-length
#------------------------------------------------------------------------
ISINDEX with PROMPT
####
<HTML>
<HEAD>
<ISINDEX PROMPT="Enter Surname:">
<TITLE>test</TITLE>
</HEAD>
<BODY>
Hello, World!
</BODY>
</HTML>
#------------------------------------------------------------------------
Use of BASE element with just the HREF attribute
####
<HTML>
<HEAD>
    <TITLE>test</TITLE>
    <BASE HREF="http://www.cre.canon.co.uk/~neilb/">
</HEAD><BODY>
<A HREF="weblint/">Weblint home page</A>
</BODY></HTML>
#------------------------------------------------------------------------
using LINK to link to an external stylesheet
####
<HTML>
<HEAD>

    <TITLE>A Good Title</TITLE>

            <LINK REL=STYLESHEET TYPE="text/JavaScript"

                HREF="http://style.com/mystyles1" TITLE="Cool">

    </HEAD>
<BODY>
Hello, World!
</BODY></HTML>
#------------------------------------------------------------------------
LINK examples
####
<HTML>
    <HEAD>
	<TITLE>link examples</title>
	<LINK title="manual in dutch" type="text/html" rel=alternate
		hreflang=nl href="dutch.html">
	<LINK title="manual in arabic" type="text/html" rel=alternate
		hreflang=ar dir=rtl charset="ISO-8859-6" href="arabic.html">
	<LINK media=print title="manual in postscript"
		type="application/postscript" rel=alternate
		href="postscript.ps">
    </HEAD>
    <BODY>
	Hello, World!
    </BODY>
</HTML>
