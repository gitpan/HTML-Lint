# $Id: 02.versions.t,v 1.1 2002/08/08 02:08:43 petdance Exp $

use Test::More tests => 3;

use_ok( 'HTML::Lint' );
use_ok( 'Test::HTML::Lint' );

is( $HTML::Lint::VERSION, $Test::HTML::Lint::VERSION, "HTML::Lint and Test::HTML::Lint versions match" );
