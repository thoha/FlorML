#!/usr/bin/perl
# parautfixB.pl
# This script fixes the non-standard auct non XXX construction
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, ">$destination" or die "can't write on file $destination: $!\n";

while (<IN>) {

	
	# Fixes non-standard construction and brings it in line with later volumes:
	s/(name class=")(paraut)(">)(non .+?)(<\/name>\t+<name class="author">)(.+?<\/name>)/$1author$3auct. $4: $6/;
	
	
	# Prints all non-empty lines to file (comment out the loop itself if you want empty lines too):
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;