# $Id: 01.coverage.t,v 1.4 2003/06/10 15:59:42 petdance Exp $

use Test::More 'no_plan';

use_ok( 'HTML::Lint::Error' );

my @errors = do { no warnings; keys %HTML::Lint::Error::errors };

isnt( scalar @errors, 0, 'There are at least some errors to be found.' );

for my $error ( @errors ) {
    my $filename = "t/$error.t";
    ok( -e $filename, "$filename exists" );
}
