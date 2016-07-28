#!/usr/bin/perl
# ocrfix.plx
# Fixes commonly occuring OCR errors in text.
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Fixes OCR-error P1. and p1. (Pl. and pl.):
	s/( )(P|p)(1)(\.)/$1$2l$4/g;
	# Fixes OCR-error 'iwn' (instead of 'ium') in taxon names:
	s/(iwn)( |\n|[[:punct:]])/ium$2/g;
	# Fixes OCR error 'la.' instead of '1a.' in keys:
	s/(^)(l|I|i)(a\.)/$1\1$3/g;
	# Prints all non-empty lines to file:
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;