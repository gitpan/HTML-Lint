#!/usr/bin/perl -w

use strict;
use HTML::Lint;

HTML::Lint::_check_test_more( [
    [ 'elem-empty-but-closed' => qr/<hr> is not a container -- <\/hr> is not allowed/ ],
], <DATA> );
    
__DATA__
<HTML>
    <HEAD>
	<TITLE>Test stuff</TITLE>
    </HEAD>
    <BODY BGCOLOR="white">
	<HR>This is a bad paragraph</HR>
    </BODY>
</HTML>
