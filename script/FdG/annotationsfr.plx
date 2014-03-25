#!/usr/bin/perl
# annotations.plx
# Ajoute les tags d'annotation.
use warnings;
use strict;

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {

# Note: controler le document pour voir s'il y a des [ et ] abberants avant d'utiliser le script.

	# Remplace chaque [ par le tag d'ouverture pour annotations:
	s/\[/<annotation>\[/g;
	# tag de fermeture:
	s/\]/\]<\/annotation>/g;
	
	# Annotations dans cles:
	# suivant le taxon:
	s/(\t+<toTaxon(?: num="\d+"|)>.+?)(\((?:cf\.|(?:V|v)oir) .+?\))(<\/toTaxon>)/$1<annotation>$2<\/annotation>$3/;
	s/(\t+<toTaxon(?: num="\d+"|)>.+?)(\(p\))(<\/toTaxon>)/$1<annotation>$2<\/annotation>$3/;
	s/(\t+<toTaxon(?: num="\d+"|)>.+?)(\(.+?\))(<\/toTaxon>)/$1<annotation>$2<\/annotation>$3/;
	
	
	
	


	print OUT $_;

}

close IN;
close OUT;