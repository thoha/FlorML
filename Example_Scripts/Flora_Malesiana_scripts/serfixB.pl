#!/usr/bin/perl
# serfixB.pl
# This script fixes wrongly marked up Series and volumes
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, ">$destination" or die "can't write on file $destination: $!\n";

while (<IN>) {

	
	
	# Fixes problem for specific pubnames:
	s/("pubname">.+?<\/refPart>\t+<refPart class=")(volume)(">[A-Z]+<\/refPart>\t+<refPart class=")(issue)(">\d)/$1series$3volume$5/;
	
	
	# Re-inserts newlines for refParts put on a single line by previous script:
	s/(<\/refPart>)(\t\t\t\t\t\t\t<refPart class="[a-z]+")/$1\n$2/g;
	
	
	
	# Prints all non-empty lines to file (comment out the loop itself if you want empty lines too):
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;