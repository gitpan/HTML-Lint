use strict;
use HTML::Lint;

HTML::Lint::_check_test_more( [
    [ 'doc-tag-required' => qr/<html> tag is required/ ],
], <DATA> );
    
__DATA__
    <HEAD>
	<TITLE>Test stuff</TITLE>
    </HEAD>
    <BODY BGCOLOR="white">
	<P>This is my paragraph</P>
    </BODY>
