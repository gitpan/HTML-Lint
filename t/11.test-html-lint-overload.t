# $Id: 11.test-html-lint-overload.t,v 1.3 2003/09/02 19:15:15 petdance Exp $

use Test::More tests => 4;

BEGIN { use_ok( 'Test::HTML::Lint' ); }
BEGIN { use_ok( 'HTML::Lint' ); }
BEGIN { use_ok( 'HTML::Lint::Error' ); }

my $lint = HTML::Lint->new();
$lint->only_types( HTML::Lint::Error::FLUFF );

# This code is invalid, but the linter should ignore it
my $chunk = << 'END';
<P><TABLE>This is a fine chunk of code</P>
END

html_ok( $lint, $chunk, 'STRUCTUREally naughty code passed' );
