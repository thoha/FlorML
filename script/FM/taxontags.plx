#!/usr/bin/perl
# taxontags.plx
# Inserts all taxon tags except the first and last one.
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Replaces each blank line (see manual) by closing and opening taxon tag
	s/^$/\t\t<\/taxon>\n\t\t<taxon>/g;
	# Prints all non-empty lines to file:
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;