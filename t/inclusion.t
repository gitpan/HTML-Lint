#!/usr/local/bin/perl -w
#
# embed.t - weblint tests for embedding elements
#
# Copyright (C) 1995-1999 Neil Bowers.  All rights reserved.
#
# See README for additional blurb.
# Bugs, comments, suggestions welcome: neilb@weblint.org
#
# $Id: inclusion.t,v 1.2 1999/03/24 21:14:58 neilb Exp $
#

use lib qw( . t/ );
use LintTest qw(run_tests);
use strict;

run_tests();

exit 0;

#============================================================================
#============================================================================

__END__
OBJECT example
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
    <OBJECT classid="analogclock.py"></OBJECT>
</BODY>
</HTML>
#------------------------------------------------------------------------
OBJECT must have a closing tag
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
    <OBJECT classid="analogclock.py">
</BODY>
</HTML>
####
5:unclosed-element
#------------------------------------------------------------------------
nested OBJECT elements
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
    <OBJECT title="earth seen from space" classid="analogclock.py">
	<OBJECT data=earth.mpeg type="application/mpeg">
	    <OBJECT data=earth.gif type="image/gif">
		The <STRONG>Earth</STRONG> as seen from space.
	    </OBJECT>
	</OBJECT>
    </OBJECT>
</BODY>
</HTML>
#------------------------------------------------------------------------
OBJECT and PARAM example
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
    <OBJECT classid="analogclock.py">
	<PARAM name=height value=40 valuetype=data>
	<PARAM name=width value=40 valuetype=data>
	This user agent cannot render python applications!
    </OBJECT>
</BODY>
</HTML>
#------------------------------------------------------------------------
APPLET example
####
<HTML>
<HEAD><TITLE>test</TITLE></HEAD>
<BODY>
    <applet code="bubbles.class" width=500 height=500>
	Java applet that draws animated bubbles
    </applet>
</BODY>
</HTML>
#------------------------------------------------------------------------
