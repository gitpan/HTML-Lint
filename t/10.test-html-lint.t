# $Id: 10.test-html-lint.t,v 1.1 2002/07/18 03:54:21 petdance Exp $

use Test::More tests => 1;
use Test::HTML::Lint;

my $chunk = << 'END';
<P>This is a fine chunk of code</P>
END

html_ok( $chunk );
