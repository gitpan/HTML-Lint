#!/usr/bin/perl -w

use strict;
use HTML::Lint;

HTML::Lint::_check_test_more( [
    [ 'text-use-entity'	=> qr/Invalid character \\x0B should be written as &#11;/i ],
    [ 'text-use-entity'	=> qr/Invalid character \\xF1 should be written as &ntilde;/i ],
], <DATA> );
    
__DATA__
<HTML>
    <HEAD>
	<TITLE>Test stuff</TITLE>
    </HEAD>
    <BODY BGCOLOR="white">
	Here's a non-entityable char [].
	<P>
	We'll get to it ma�ana, which should really have an &ntilde;.
    </BODY>
</HTML>
