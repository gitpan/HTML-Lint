use strict;
use HTML::Lint;

HTML::Lint::_check_test_more( [
    [ 'elem-img-alt-missing' => qr/<IMG> does not have ALT text defined/i ],
], <DATA> );
    
__DATA__
<HTML>
    <HEAD>
	<TITLE>Test stuff</TITLE>
    </HEAD>
    <BODY BGCOLOR="white">
	<P ALIGN=RIGHT>This is my paragraph</P>
	<IMG SRC="http://www.petdance.com/random/whizbang.jpg" BORDER=3 HEIGHT=4 WIDTH=921>
    </BODY>
</HTML>
