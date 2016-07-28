#!/usr/bin/perl
# atomprepa.plx
# Preparation pour l'atomisation
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Enleve la nouvelle ligne pour certains 'features', pour faciliter l'atomisation:
	s/(^)(\t\t\t<feature class="(?:distribution|vernacular)">)(\n)/$1$2/g;


		print OUT $_;

}

close IN;
close OUT;