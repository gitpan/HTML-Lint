use strict;
use HTML::Lint;

HTML::Lint::_check_test_more( [
    [ 'elem-input-image-sizes-missing' => qr/<INPUT TYPE="image"> can benefit from HEIGHT and WIDTH, like an IMG tag./ ],
], <DATA> );
    
__DATA__
<HTML>
    <HEAD>
	<TITLE>Test stuff</TITLE>
    </HEAD>
    <BODY BGCOLOR="white">
	<P ALIGN=RIGHT>This is my paragraph</P>
	<INPUT TYPE="image">
    </BODY>
</HTML>
