#!/usr/bin/perl -w

use strict;
use HTML::Lint;

HTML::Lint::_check_test_more( [
    [ 'elem-unknown' => qr/unknown element <donky>/i ],
    [ 'elem-unclosed' => qr/<donky> at \(\d+:\d+\) is never closed/i ],
], <DATA> );
    
__DATA__
<HTML>
    <HEAD>
	<TITLE>Test stuff</TITLE>
    </HEAD>
    <BODY BGCOLOR="white">
	<NOBR>NOBR is fine with me!</NOBR>
	<DONKY>
	<NOBR>But Donky is not</NOBR>
    </BODY>
</HTML>
