# $Id: 00.load.t,v 1.5 2004/01/27 22:47:57 petdance Exp $

use Test::More tests => 2;

use_ok( 'HTML::Lint' );
use_ok( 'Test::HTML::Lint' );

diag( "Testing HTML::Lint $HTML::Lint::VERSION" );
