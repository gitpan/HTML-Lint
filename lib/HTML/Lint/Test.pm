#
# HTML::Lint::Test - test harness for Weblint
#
# Copyright (C) 1995-1999 Neil Bowers.	All rights reserved.
#
# See README for additional blurb.
# Bugs, comments, suggestions welcome: neilb@weblint.org
#

package HTML::Lint::Test;
require Exporter;

use HTML::Lint;
use HTML::Lint::Constants;
use Getopt::Long;
use strict;
use vars qw($VERSION @EXPORT_OK @ISA);

$VERSION	= '1.012';

@EXPORT_OK = qw(run_tests);
@ISA	   = qw(Exporter);

my $state;
my $weblint;
my @messages;
my @failedTests;
my $testID	 = 0;
my $failCount = 0;
my $passCount = 0;
my $testDescription;
my %switch;

#=======================================================================
#
# run_tests
#
# This is an ugly hack - I did it to get the new stuff running as
# quickly as possible. I'll fix it someday, honest.
#
#=======================================================================
sub run_tests
{
	my @args;
	my $arg;
	my $line;
	my @warns;
	my @bits;
	my $subject;
	my $body;
	my $slurp;
	my $id;
	local $/;
	local $_;


	&HTML::LintTestInitialize();
	$state = 'start';

	#-------------------------------------------------------------------
	# If we're not running in verbose mode, then we're in standard
	# perl test mode, and we need to start off by spitting out "1..N",
	# where N is the number of tests. So we slurp them all in,
	# and count the number of tests.
	#-------------------------------------------------------------------
	$slurp = <main::DATA>;
	if (not defined $switch{verbose})
	{
	@bits = split(/\n#-----+/, $slurp);
	pop @bits if $bits[-1] =~ /^\s*$/;
	print "1..", int(@bits), "\n";
	}

	@bits = split(/\n/, $slurp);
	while (@bits > 0)
	{
	$_ = shift @bits;

	#--------------------------------------------------------------------
	# A line of dashes (minus characters) signify end of test
	#--------------------------------------------------------------------
	if (/^\#----/)
	{
		push(@args, '') if @args == 0;
		foreach $arg (@args)
		{
		if (@warns > 0)
		{
			&ExpectWARN($subject, $arg, $body, @warns);
		}
		else
		{
			&ExpectOK($subject, $arg, $body);
		}
		}

		$subject = undef;
		$body	 = '';
		@args	 = ();
		@warns	 = ();

		$state	 = 'start';

		next;
	}

	#--------------------------------------------------------------------
	# A line starting with 3 (FOUR) hashes (#) delimits the HTML test
	#--------------------------------------------------------------------
	if (/^\#\#\#\#/)
	{
		$state = ($state eq 'start' || $state eq 'args') ? 'body' : 'end';

		next;
	}

	#--------------------------------------------------------------------
	# In START state, we are about to read the subject line of the test
	#--------------------------------------------------------------------
	if ($state eq 'start')
	{
		$subject = $_;
		$state	 = 'args';
		next;
	}

	if ($state eq 'args')
	{
		$_ = '' if /^\s*<none>\s*$/io;
		push(@args, $_);
		next;
	}

	if ($state eq 'body')
	{
		$body .= "$_\n";
		next;
	}

	if ($state eq 'end')
	{
		next if /^\s*$/;
		($line, $id) = split(/:/, $_, 2);
		push(@warns, $line, $id);
		next;
	}

	} continue {
	if (@bits == 0 && $_ !~ /^#----/) {
		push(@bits, '#------');
	}
	}

	&HTML::LintTestEnd();
}


#========================================================================
# Function: ExpectOK
# Purpose:	Run a test, for which we expect no warnings.
#========================================================================
sub ExpectOK
{
	my $description = shift;
	my $flags		= shift;
	my $html		= shift;

	my @results;


	&NextTest($description);
	@results = &RunHTML::Lint($html, $flags);
	if (@results == 0)
	{
	&TestPasses();
	}
	else
	{
	&TestFails($html, @results);
	}
}


#========================================================================
# Function: ExpectWARN
# Purpose:	A test which we expect weblint to complain about.
#		We pass in one or more expected errors.
#========================================================================
sub ExpectWARN
{
	my $description = shift;
	my $flags		= shift;
	my $html		= shift;
	my @expected	= @_;

	my @results;
	my @notSeen;
	my($i, $j);


	&NextTest($description);
	@results = &RunHTML::Lint($html, $flags);

	if (@results == 0)
	{
	&TestFails($html);
	return;
	}

	OUTER: for ($i=0; $i < $#expected; $i += 2)
	{
	INNER: for ($j = 0; $j < $#results; $j += 2)
	{
		if ($results[$j] == $expected[$i]
		&& $results[$j+1] eq $expected[$i+1])
		{
		splice(@results, $j, 2);
		next OUTER;
		}
	}
	@notSeen = (@notSeen, $expected[$i], $expected[$i+1]);
	}

	if (@notSeen == 0 && @results == 0)
	{
	&TestPasses();
	}
	else
	{
	&TestFails($html, @results);
	}
}


#========================================================================
# Function: RunHTML::Lint
# Purpose:	This function runs weblint and parses the output.
#		The results from weblint are passed back in an array.
#========================================================================
sub RunHTML::Lint
{
	my $html = shift;
	my $flags = shift;

	my @argv = split(/\s+/, $flags);
	my $arg;


	@messages = ();
	$weblint->{msgs}->reset_defaults(); # ooh, don't look!
	while (@argv > 0)
	{
		$arg = shift @argv;
		if ($arg eq '-pedantic') {
		$weblint->pedantic();
	} elsif ($arg eq '-e') {
		$weblint->enable(shift(@argv), ENABLED);
	}
	}
	$weblint->check_string("test $testID", $html);

	return @messages;
}


#========================================================================
# Function: HTML::LintTestInitialize()
# Purpose:	Initialize global variables and open log file.
#========================================================================
sub HTML::LintTestInitialize
{
	my $logname;


	GetOptions(\%switch, 'verbose|v');

	$weblint = HTML::Lint->new();
	$weblint->set_message_handler(\&my_handler);

	$testID   = 0;
	$failCount = 0;
	$passCount = 0;

	if (defined $switch{'verbose'})
	{
	($logname = $0) =~ s!^.*/!!;
	$logname .= '.log';

	print STDERR "LOG NAME = $logname\n";

	open(LOGFILE, "> $logname") || die "Can't write logfile $logname: $!\n";

	print LOGFILE "HTML::Lint Testsuite:\n";
	print LOGFILE "    HTML::Lint Version:   weblint v$Weblint::VERSION\n";
	print LOGFILE "    Testsuite Version: $VERSION\n";
	print LOGFILE '=' x 76, "\n";

	print STDERR "Running weblint testsuite:\n";
	print STDERR "	  HTML::Lint Version:	 weblint v$Weblint::VERSION\n";
	print STDERR "	  Testsuite Version: $VERSION\n";
	print STDERR "	  Results Logfile:	 $logname\n";
	print STDERR "Running test cases (. for pass, ! for failure):\n";
	}
}

#========================================================================
# Function: HTML::LintTestEnd()
# Purpose:	Generate summary in logfile, close logfile, then
#		clean up working files and directory.
#========================================================================
sub HTML::LintTestEnd
{
	if (defined $switch{'verbose'})
	{
	print LOGFILE '=' x 76, "\n";
	print LOGFILE "Number of Passes:   $passCount\n";
	print LOGFILE "Number of Failures: $failCount\n";
	close LOGFILE;

	print STDERR "\n", '-' x 76, "\n";
	if ($failCount > 0)
	{
		print STDERR "Failed tests:\n";
		foreach my $failure (@failedTests)
		{
		print STDERR "	  $failure\n";
		}
		print STDERR '-' x 76, "\n";

	}
	print STDERR "Number of Passes:   $passCount\n";
	print STDERR "Number of Failures: $failCount\n";
	}
}

#========================================================================
# Function: NextTest()
# Purpose:	Introduce a new test -- increment test id, write
#		separator and test information to log file.
#========================================================================
sub NextTest
{
	my $description = shift;


	++$testID;
	if (defined $switch{'verbose'})
	{
	print LOGFILE '-' x 76, "\n";
	}
	$testDescription = $description;
}

#========================================================================
# Function: TestPasses()
# Purpose:	The current test passed.  Write result to logfile, and
#		increment the count of successful tests.
#========================================================================
sub TestPasses
{
	if (defined $switch{'verbose'})
	{
	printf LOGFILE ("%3d %s%s%s", $testID, $testDescription,
			' ' x (68 - length($testDescription)), "PASS\n");
	# printf STDERR "%3d: pass (%s)\n", $testID, $testDescription;
	print STDERR ".";
	print STDERR "\n" if $testID % 70 == 0;
	}
	else
	{
	print "ok $testID\n";
	}
	++$passCount;
}

#========================================================================
#
# TestFails()
#
# The current test failed.	Write result to logfile,
# including the html which failed, and the output from weblint.
#
#========================================================================
sub TestFails
{
	my $html	= shift;
	my @results = @_;

	my $string;
	my $line;
	my $wid;


	# printf STDERR "%3d: FAIL (%s)\n", $testID, $testDescription;
	$string = sprintf("%3d: %s", $testID, $testDescription);
	push(@failedTests, $string);
	if (defined $switch{'verbose'})
	{
	print STDERR "!";
	print STDERR "\n" if $testID % 70 == 0;

	printf LOGFILE ("%3d %s%s%s", $testID, $testDescription,
			' ' x (68 - length($testDescription)), "FAIL\n");

	$html =~ s/\n/\n	/g;
	print LOGFILE "\n  HTML:\n	  $html\n\n";
	print LOGFILE "  WEBLINT OUTPUT:\n";
	while (@results > 1)
	{
		($line, $wid) = splice(@results, 0, 2);
		print LOGFILE "    line $line: $wid\n";
	}
	print LOGFILE "\n";
	}
	else
	{
	print "not ok $testID\n";
	}
	++$failCount;
}

#========================================================================
#
# my_handler
#
# Our message handler, to catch messages from HTML::Lint. We don't want to
# print out any messages, just record that we've seen them.
#
#========================================================================
sub my_handler
{
	my $filename = shift;
	my $line	 = shift;
	my $id		 = shift;
	my @argv	 = @_;


	push(@messages, $line, $id);
}

#============================================================================
#============================================================================

1;
__END__

=head1 NAME

HTML::Lint::Test - test harness for weblint tests

=head1 SYNOPSIS

	use HTML::Lint::Test qw(run_tests);
	
	run_tests();
	exit 0;
	__END__
	... test data ...


=head1 DESCRIPTION

B<HTML::Lint::Test> is a module which provides the test harness for
the testsuites which are included in the weblint distribution.
This provides a simple format for tests, as described in
the section L<TEST FORMAT> below.

=head1 TEST FORMAT

Test data is provided in the DATA section of the test script;
this is everything after the magic __END__ symbol.

=head1 SEE ALSO

=over 4

=item HTML::Lint

=back

=head1 AUTHOR

Andy Lester E<lt>andy@petdance.comE<gt>

=head1 COPYRIGHT

Copyright (c) Andy Lester 2001. All Rights Reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

