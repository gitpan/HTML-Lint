# $Id: 20.error-types.t,v 1.1 2002/07/24 21:38:32 petdance Exp $

use Test::More tests => 5;

BEGIN { use_ok( 'HTML::Lint::Error' ); }

my $err = HTML::Lint::Error->new( undef, undef, undef, 'elem-empty-but-closed' );

ok( $err->is_type( HTML::Lint::Error::STRUCTURE ) );
ok( !$err->is_type( HTML::Lint::Error::FLUFF, HTML::Lint::Error::HELPER ) );

$err = HTML::Lint::Error->new( undef, undef, undef, 'attr-unknown' );
ok( $err->is_type( HTML::Lint::Error::FLUFF ) );
ok( !$err->is_type( HTML::Lint::Error::STRUCTURE, HTML::Lint::Error::HELPER ) );
