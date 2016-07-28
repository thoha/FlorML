#!/usr/bin/perl
# taxontags_fr.plx
# Insere tous les tags taxon excepte le premier et le dernier
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Remplace chaque ligne vide par un tag taxon ouvrant et un tag taxon fermant:
	s/^$/\t\t<\/taxon>\n\t\t<taxon>/g;
	# Imprime toutes les lignes non-vides vers le fichier sortant:
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;