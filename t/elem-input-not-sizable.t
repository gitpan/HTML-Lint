#!/usr/bin/perl -w

use strict;
use HTML::Lint;

HTML::Lint::_check_test_more( [
    [ 'elem-input-not-sizable' => qr/<INPUT> tag cannot have HEIGHT and WIDTH unless TYPE="image"/ ],
], <DATA> );
    
__DATA__
<HTML>
    <HEAD>
	<TITLE>Test stuff</TITLE>
    </HEAD>
    <BODY BGCOLOR="white">
	<P ALIGN=RIGHT>This is my paragraph</P>
	<INPUT TYPE="checkbox" HEIGHT=14 WIDTH=192>
	<INPUT TYPE="image" HEIGHT=33 WIDTH=27>
    </BODY>
</HTML>
