#!/usr/bin/perl
# serfixA.pl
# This script prepares a file for fixing wrongly marked up Series and volumes
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, ">$destination" or die "can't write on file $destination: $!\n";

while (<IN>) {

	# Removes newlines from select refParts:
	# Pubnames:
	s/(<refPart class="pubname">.+?<\/refPart>)(\n)/$1/;
	# Volumes containing only Roman numerals (= Capital letters):
	s/(<refPart class="volume">[A-Z]+<\/refPart>)(\n)/$1/;
	
	

	# Prints all non-empty lines to file (comment out the loop itself if you want empty lines too):
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;