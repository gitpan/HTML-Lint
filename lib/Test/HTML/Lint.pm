package Test::HTML::Lint;

use strict;
use warnings;
use Test::Builder;
use Exporter;

use HTML::Lint 1.10;

our @ISA = qw( HTML::Parser Exporter );

=head1 VERSION

Version 1.10

    $Header: /cvsroot/html-lint/html-lint/lib/Test/HTML/Lint.pm,v 1.4 2002/07/18 03:56:47 petdance Exp $

=cut

our $VERSION = '1.10';

our @EXPORT = qw( html_ok );

my $Tester = Test::Builder->new;

my $lint = HTML::Lint->new;

=head1 NAME

Test::HTML::Lint - Test::More-style wrapper around HTML::Lint

=head1 SYNOPSIS

    use Test::More tests => 4;
    use Test::HTML::Lint;

    my $table = build_display_table();
    html_ok( $table, 'Built display table properly' );

=head1 DESCRIPTION

This module provides a few convenience methods for testing exception
based code. It is built with L<Test::Builder> and plays happily with
L<Test::More> and friends.

If you are not already familiar with L<Test::More> now would be the time
to go take a look.

=cut

=head2 C<html_ok( $html, $name )>

=cut

sub html_ok {
    my $html = shift;
    my $name = shift;

    $lint->clear_errors();
    $lint->parse( $html );

    my $ok = $Tester->is_num( scalar $lint->errors, 0, $name );

    $Tester->diag( $_->as_string ) for $lint->errors;

    return $ok;
}

=head1 BUGS

None known at the time of writing.

If you find any please let me know at E<lt>andy@petdance.comE<gt>,
or report the problem with L<http://rt.cpan.org/>.

=head1 TO DO

There needs to be a C<html_table_ok()> to check that the HTML is a
self-contained, well-formed table, and then a comparable one for
C<html_page_ok()>.

If you think this module should do something that it doesn't do at the
moment please let me know.

=head1 ACKNOWLEGEMENTS

Thanks to chromatic and Michael G Schwern for the excellent Test::Builder,
without which this module wouldn't be possible.

Thanks to Adrian Howard for writing Test::Exception, from which most of
this module is taken.

=head1 LICENSE

Copyright 2002 Andy Lester, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

Please note that these modules are not products of or supported by the
employers of the various contributors to the code.

=head1 AUTHOR

Andy Lester, E<lt>andy@petdance.comE<gt>

=cut

1;
