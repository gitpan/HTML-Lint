=head1 NAME

HTML::Lint::Constants - definition of constants used in weblint and friends

=cut

package HTML::Lint::Constants;
use 5.004;
use strict;

use vars qw( $VERSION @ISA @EXPORT );
$VERSION = '';
@ISA	= qw( Exporter );
@EXPORT = qw( DISABLED ENABLED MC_WARNING MC_ERROR MC_STYLE MC_INTERNAL
		MF_DEFAULT MF_LINT MF_TERSE MF_SHORT );

#-----------------------------------------------------------------------
# constants for whether a message is enabled or disabled
#-----------------------------------------------------------------------
use constant DISABLED => 0;
use constant ENABLED  => 1;

#-----------------------------------------------------------------------
# constants for message categories
#-----------------------------------------------------------------------
use constant MC_WARNING  => 0;
use constant MC_ERROR	 => 1;
use constant MC_STYLE	 => 2;
use constant MC_INTERNAL => 3;

#-----------------------------------------------------------------------
# constants for message formats
#-----------------------------------------------------------------------
use constant MF_LINT	 => 0;
use constant MF_TERSE	 => 1;
use constant MF_SHORT	 => 2;

use constant MF_DEFAULT  => MF_LINT;

1;

__END__


=head1 NAME

HTML::Lint::Constants - perl module which defines weblint constants

=head1 SYNOPSIS

	use HTML::Lint::Constants;
	
	$weblint->enable($id, ENABLED);

=head1 DESCRIPTION

B<HTML::Lint::Constants> is a module which defines constants which are used
in weblint modules and scripts.

=head1 SEE ALSO

=over 4

=item HTML::Lint

=back

=head1 AUTHOR

Andy Lester E<lt>andy@petdance.comE<gt>

=head1 COPYRIGHT

Copyright (c) 2001 Andy Lester. All Rights Reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

