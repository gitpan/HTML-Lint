# $Id: Makefile.PL,v 1.2 2002/02/23 08:38:52 comdog Exp $
use strict;
use ExtUtils::MakeMaker;
use File::Find;

find( \&filecheck, "." );

sub filecheck {
	unlink if /~$/;	# Remove any vi backup files
	die "Aborting: Swapfile $_ found" if /\.swp$/;
}

&WriteMakefile(
	NAME		=> 'HTML::Lint',
	DISTNAME	=> 'HTML-Lint',
	VERSION_FROM	=> 'lib/HTML/Lint.pm',
	ABSTRACT_FROM	=> 'lib/HTML/Lint.pm',
	PMLIBDIRS	=> [qw(lib/)],
	AUTHOR		=> 'Andy Lester <andy@petdance.com>',
	PREREQ_PM	=> {
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

