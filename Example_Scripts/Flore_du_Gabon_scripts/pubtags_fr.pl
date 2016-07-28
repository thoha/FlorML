#!/usr/bin/perl
# pubtags_fr.plx
# Ajoute les premiers et derniers tags XML a un fichier.
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

# Ajoute les premiers tags XML requis par le schema XML pour flore FM:
print OUT "<publication xmlns:xsi=\"http://www\.w3\.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"\"xmlns:mods=\"http://www\.loc\.gov/mods/v3\" lang=\"fr\">\n\t<metaData>\n\t\t<defaultMediaUrl>http://media\.e-taxonomy\.eu/flora-gabon/</defaultMediaUrl>\n\t</metaData>\n\t<treatment>\n\t\t<taxon>\n";

while (<IN>) {
	# Imprime toutes les lignes vers le fichier:
		print OUT $_;

}

# Ajoute les derniers tag XML au fichier:
print OUT "\n\t\t</taxon>\n\t</treatment>\n</publication>";

close IN;
close OUT;

