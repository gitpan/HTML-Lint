#!/usr/local/bin/perl -w
#
# i18n.t - weblint tests for i18n related elements
#
# Copyright (C) 1995-1999 Neil Bowers.  All rights reserved.
#
# See README for additional blurb.
# Bugs, comments, suggestions welcome: neilb@weblint.org
#
# $Id: i18n.t,v 1.3 1999/04/05 16:04:22 neilb Exp $
#

use lib qw( . t/ );
use LintTest qw(run_tests);
use strict;

run_tests();

exit 0;

#============================================================================
#============================================================================

__END__
Use of all valid attributes on HEAD element
####
<HTML>
    <HEAD lang=en dir=ltr profile="profile.dat">
	<TITLE>foo</TITLE>
    </HEAD>
    <BODY>this is the body</BODY>
</HTML>
#------------------------------------------------------------------------
invalid value for DIR attribute on HEAD
####
<HTML>
    <HEAD lang=en dir=ltl>
	<TITLE>foo</TITLE>
    </HEAD>
    <BODY>this is the body</BODY>
</HTML>
####
2:attribute-format
#------------------------------------------------------------------------
correct use of BDO element
####
<HTML>
    <HEAD><TITLE>foo</TITLE></HEAD>
    <BODY>
	this is the body
	<BDO lang=en dir=ltr id=foo class=wotsit title=bdo
		>some more of the body</BDO>
	and more
    </BODY>
</HTML>
#------------------------------------------------------------------------
bad use of BDO - the DIR attribute is required
####
<HTML>
    <HEAD><TITLE>foo</TITLE></HEAD>
    <BODY>
	this is the body
	<BDO lang=en>some more of the body</BDO>
	and more
    </BODY>
</HTML>
####
5:required-attribute
#------------------------------------------------------------------------
BDO example from HTML 4.0 spec
####
<HTML>

    <HEAD>
	<TITLE>foo</TITLE>
    </HEAD>

    <BODY>

	<PRE>
	<BDO DIR=LTR>english1 2WERBEH english3</BDO>
	<BDO DIR=LTR>4WERBEH english5 6WERBEH</BDO>
	</PRE>

    </BODY>

</HTML>
#------------------------------------------------------------------------
