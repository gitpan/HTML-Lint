#!/usr/bin/perl -w

use strict;
use HTML::Lint;

HTML::Lint::_check_test_more( [
    [ 'elem-unclosed' => qr/<b> at \(6:5\) is never closed/i ],
], <DATA> );
    
__DATA__
<HTML>
    <HEAD>
	<TITLE>Test stuff</TITLE>
    </HEAD>
    <BODY BGCOLOR="white">
	<P><B>This is my paragraph</P>
    </BODY>
</HTML>
