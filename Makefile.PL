use strict;
use ExtUtils::MakeMaker;
use File::Find;

my @libdirs = qw( lib/ );

find( \&filecheck, @libdirs );

sub filecheck {
	unlink if /~$/;	# Remove any vi backup files
	die "Aborting: Swapfile $_ found" if /\.swp$/;
}

&WriteMakefile(
	NAME		=> 'HTML::Lint',
	DISTNAME	=> 'HTML-Lint',
	VERSION_FROM	=> 'lib/HTML/Lint.pm',
	ABSTRACT_FROM	=> 'lib/HTML/Lint.pm',
	PMLIBDIRS	=> [@libdirs],
	AUTHOR		=> 'Andy Lester <andy@petdance.com>',
	PREREQ_PM	=> {
		'Getopt::Long'   => 0,
		'File::Find'     => 0,
		},
	EXE_FILES	=> [qw(pl/weblint)],
	dist => {
		COMPRESS => 'gzip -9f', 
		SUFFIX => 'gz',
		},
	);
