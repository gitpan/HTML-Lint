# $Id: 30.test-builder.t,v 1.1 2003/09/02 22:16:23 petdance Exp $

# The test is not that html_ok() works, but that the tests=>1 gets
# acts as it should.

use Test::HTML::Lint tests=>1;

my $chunk = "<P>This is a fine chunk of code</P>";

html_ok( $chunk );
