#!/usr/bin/perl
# filecleaner.plx
# filecleaner removes all unwanted characters from a plain text (UTF-8) version of a flora chapter. 
# By unwanted we mean stuff like double or triple spaces (or worse), spaces before dots, commas, 
# colons, semi-colons, newline characters, exclamation marks, question marks, and closing brackets, 
# spaces at the start of lines and in front of the first word in brackets, as well as double newlines 
# with no contents (or worse). It also replaces tab-characters by spaces (actually, it starts with this).
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, ">$destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Replaces all tab-characters with spaces:
	s/\t/ /g;
	# Replaces space-like whitespace (that isn't a space character) by proper spaces:
	s/ / /g;
	# Replaces 'wrong' hyphens by proper hyphens:
	s/–/-/g;
	# Replaces all hyphens that are both preceded and trailed by a space by long dashes preceded and trailed by a space:
	s/ - / — /g; 
	# Removes the leading space(s) from a variety of unwanted combinations:
	s/( +)( |\.|,|:|;|\!|\]|\)|\n)/$2/g;
	# Removes multiple dots:
	s/\.+/./g;
	# Removes multiple commas:
	s/,+/,/g;
	# Removes multiple colons:
	s/:+/:/g;
	# Removes multiple semi-colons:
	s/;+/;/g;
	# Removes commas before dots:
	s/(,)(\.)/$2/g;
	# Removes the trailing spaces and dots behind two types of brackets:
	s/(\(|\[)( +|\.+)/$1/g;
	# Removes empty sets of brackets:
	s/(\(|\[)(\)|\])//g;
	# Removes whitespace at beginning of line:
	s/^\s+//;
	# Removes whitespace at end of line:
	s/\s+$/\n/;
	# Prints all non-empty lines to file (comment out the loop itself if you want empty lines too):
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;