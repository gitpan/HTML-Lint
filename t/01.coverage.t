# $Id: 01.coverage.t,v 1.2 2002/06/10 20:36:55 petdance Exp $

use Test::More 'no_plan';

use_ok( 'HTML::Lint::Error' );

my @errors = keys %HTML::Lint::Error::errors;
isnt( scalar @errors, 0, 'There are at least some errors to be found.' );

for my $error ( @errors ) {
    my $filename = "t/$error.t";
    ok( -e $filename ) or diag( "$filename does not exist" ); 
}
