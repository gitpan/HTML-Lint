# $Id: 10.test-html-lint.t,v 1.3 2002/08/02 21:08:27 petdance Exp $

use Test::More tests => 3;
use Test::HTML::Lint;

BEGIN { use_ok( 'Test::HTML::Lint' ); }

my $chunk = << 'END';
<P>This is a fine chunk of code</P>
END

html_ok( '' );  # Blank is OK
html_ok( $chunk );
