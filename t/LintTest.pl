use Test::More;
use HTML::Lint;

sub checkit {
    my @expected = @{+shift};
    my @lines = @_;

    plan( tests => 3*(scalar @expected) + 4 );

    my $lint = new HTML::Lint;
    isa_ok( $lint, 'HTML::Lint', 'Created lint object' );
    $lint->parse( $_ ) for @_;
    $lint->eof;

    my @errors = $lint->errors();
    is( scalar @errors, scalar @expected, 'Right # of errors' );

    while ( @errors && @expected ) {
        my $error = shift @errors;
        isa_ok( $error, 'HTML::Lint::Error' );

        my $expected = shift @expected;

        is( $error->errcode, $expected->[0] );
        my $match = $expected->[1];
        if ( ref $match eq "Regexp" ) {
            like( $error->as_string, $match );
        } else {
            is( $error->as_string, $match );
        }
    }

    my $dump;

    is( scalar @errors, 0, 'No unexpected errors found' ) or $dump = 1;
    is( scalar @expected, 0, 'No expected errors missing' ) or $dump = 1;

    if ( $dump && @errors ) {
        diag( "Leftover errors..." ); 
        diag( $_->as_string ) for @errors;
    }
}

1; # happy
