# $Id: 10.test-html-lint.t,v 1.2 2002/07/24 22:10:04 petdance Exp $

use Test::More tests => 2;

BEGIN { use_ok( 'Test::HTML::Lint' ); }

my $chunk = << 'END';
<P>This is a fine chunk of code</P>
END

html_ok( $chunk );
