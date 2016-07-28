#!/usr/bin/perl
# notesbaspages.plx
# Ajoute les tags pour les notes de bas de page
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Ajoute les tags pour les notes de bas de page
	s/(^\*\)|^\(\d\))(.+\.$)/\t\t\t<footnote id=""><footnoteString>$1$2<\/footnoteString><\/footnote>/g;
	print OUT $_;
}

close IN;
close OUT;