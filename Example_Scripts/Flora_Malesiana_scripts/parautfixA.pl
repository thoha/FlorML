#!/usr/bin/perl
# parautfixA.pl
# This script prepares a file for fixing the non-standard auct non XXX construction
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, ">$destination" or die "can't write on file $destination: $!\n";

while (<IN>) {

	
	# Removes newline following parauts concerned:
	s/("paraut">non.+?<\/name>)(\n)/$1/;
	
	
	
	# Prints all non-empty lines to file (comment out the loop itself if you want empty lines too):
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;