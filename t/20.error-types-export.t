# $Id: 20.error-types-export.t,v 1.1 2003/09/02 19:20:24 petdance Exp $

use Test::More tests => 5;

BEGIN { use_ok( 'HTML::Lint::Error', ':types' ); }

my $err = HTML::Lint::Error->new( undef, undef, undef, 'elem-empty-but-closed' );

ok( $err->is_type( STRUCTURE ) );
ok( !$err->is_type( FLUFF, HELPER ) );

$err = HTML::Lint::Error->new( undef, undef, undef, 'attr-unknown' );
ok( $err->is_type( FLUFF ) );
ok( !$err->is_type( STRUCTURE, HELPER ) );
