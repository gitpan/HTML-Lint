# $Id: 10.test-html-lint.t,v 1.4 2002/08/03 20:57:15 petdance Exp $

use Test::More tests => 4;
use Test::HTML::Lint;

BEGIN { use_ok( 'Test::HTML::Lint' ); }

my $chunk = "<P>This is a fine chunk of code</P>";

TODO: { # undef should fail
    local $TODO = "This test should NOT succeed";
    html_ok( undef );
}
html_ok( '' );  # Blank is OK
html_ok( $chunk );
