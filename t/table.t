#!/usr/local/bin/perl -w
#
# table.t - table markup tests for weblint
#
# Copyright (C) 1995-1999 Neil Bowers.  All rights reserved.
#
# See README for additional blurb.
# Bugs, comments, suggestions welcome: neilb@weblint.org
#
# $Id: table.t,v 1.2 1999/03/24 21:14:59 neilb Exp $
#

use lib qw( . t/ );
use LintTest qw(run_tests);
use strict;

run_tests();

exit 0;

#============================================================================
#============================================================================

__END__
simple table
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<TABLE><TR><TH>height<TD>1.0<TR><TH>weight<TD>1.0</TABLE>
</BODY></HTML>
#------------------------------------------------------------------------
table without TR
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD><BODY>
<TABLE><TH>height<TD>1.0<TR><TH>weight<TD>1.0</TABLE>
</BODY></HTML>
####
2:required-context
2:required-context
#------------------------------------------------------------------------
CAPTION element appearing outside of TABLE or FIG
####
<HTML><HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<TABLE><CAPTION>legal use of caption</CAPTION></TABLE>
<CAPTION>this is an invalid use of caption</CAPTION>
</BODY></HTML>
####
4:required-context
#------------------------------------------------------------------------
Ok to have empty TD elements in a table
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<TABLE>
<TR><TD></TD></TR>
</TABLE>
</BODY></HTML>
#------------------------------------------------------------------------
