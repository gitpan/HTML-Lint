use strict;
require 't/LintTest.pl';

checkit( [
    [ 'elem-img-sizes-missing' => qr/<IMG> tag has no HEIGHT and WIDTH attributes./i ],
], <DATA> );
    
__DATA__
<HTML>
    <HEAD>
	<TITLE>Test stuff</TITLE>
    </HEAD>
    <BODY BGCOLOR="white">
	<P ALIGN=RIGHT>This is my paragraph</P>
	<IMG SRC="http://www.petdance.com/random/randal-thong.jpg" BORDER=3 ALT="Randal Schwartz in a thong">
    </BODY>
</HTML>
