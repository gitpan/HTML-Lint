use Test::More;
my $tpc = "Test::Pod::Coverage 0.06";
eval "use $tpc";
plan skip_all => "$tpc required for testing POD coverage" if $@;

plan tests=>4;

pod_coverage_ok( "HTML::Lint" );
pod_coverage_ok( "HTML::Lint::HTML4" );
pod_coverage_ok( "HTML::Lint::Error" );
pod_coverage_ok( "Test::HTML::Lint" );
