# $Id: Makefile.PL,v 1.6 2002/07/18 03:18:00 petdance Exp $
use strict;
use ExtUtils::MakeMaker;
use File::Find;

find( \&filecheck, "." );

sub filecheck {
	unlink if /~$/;	# Remove any vi backup files
	die "Aborting: Swapfile $_ found" if /\.swp$/;
}

eval { require LWP::Simple; };

if ( $@ ) {
    print <<EOF;
    
NOTE: It seems that you don't have LWP::Simple installed.
      The weblint program will not be able to retrieve web pages.

EOF
}

&WriteMakefile(
	NAME		=> 'HTML::Lint',
	DISTNAME	=> 'HTML-Lint',
	VERSION_FROM	=> 'lib/HTML/Lint.pm',
	ABSTRACT_FROM	=> 'lib/HTML/Lint.pm',
	PMLIBDIRS	=> [qw(lib/)],
	AUTHOR		=> 'Andy Lester <andy@petdance.com>',
	PREREQ_PM	=> {
		'Test::More'	=> 0,
		'Test::Builder' => 0,
		'HTML::Parser'	=> '3.20',
		'HTML::Tagset'	=> '3.03',
		'File::Find'    => 0,
		},
	EXE_FILES	=> [qw(pl/weblint)],
	dist => {
		COMPRESS => 'gzip -9f', 
		SUFFIX => 'gz',
		},
	);

