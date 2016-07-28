#!/usr/bin/perl
# figurl.plx
# This script add figure urls to a marked up file

use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	
	
	# How to use this script:
	# 1)
	# In the second part of each reg-ex, the text following url=" controls how the file name is build up.
	# Each file name consists of the following:
	# "fm" for "Flora Malesiana"
	# - (dash)
	# "series number" in digits - Change this to the series number you need to use for this particular FM volume
	# - (dash)
	# "volume number" in digits - Change this to the volume number you need to use for this particular FM volume
	# - (dash)
	# "figure ID" - This is taken from the original XML
	# .gif or .jpg - for lineart or photos respectively
	# 2)
	# If any linearts are .jpg files (or photos .gifs) according to the image administration, change these manually.
	
	
	# Linearts, which usually will be .gif files:
	s/(<figure id="ID_)(\d+)(" type=")(lineart)(">)/$1$2$3$4" url="fm-1-12-$2.gif$5/g;
	
	# Photos, which usually will be .jpg files:
	s/(<figure id="ID_)(\d+)(" type=")(photo)(">)/$1$2$3$4" url="fm-1-12-$2.jpg$5/g;
	
	
	
	
	# Prints each line to the output file
	print OUT $_;
}

close IN;
close OUT;