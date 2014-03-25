#!/usr/bin/perl
# annotations.plx
# replaces annotations' square brackets by annotation tags.
use warnings;
use strict;

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Replaces each annotation opening bracket with annotation opening tag and annotation opening bracket
	s/\[/<annotation>\[/g;
	# Replaces each annotation closing bracket with annotation closing bracket and annotation closing tag
	s/\]/\]<\/annotation>/g;


	print OUT $_;

}

close IN;
close OUT;