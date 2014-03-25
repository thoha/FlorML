#!/usr/bin/perl
# nettoyeur.plx
# nettoyeur enleve tous les characteres non-voulus dans un fichier .txt (UTF-8) d'un chapitre ou volume d'une flore.
# Examples: double ou triple espace (ou plus), espaces avant un point ou une virgule, etc., tout comme des lignes sans texte.
# Les marques de tabulation sont remplaces par des espaces.

use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, ">$destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Remplace toutes les marques de tabulation par des espaces:
	s/\t/ /g;
	# Remplace tous les traits courts devances d'un espace et suivis d'un espace par des traits longs (avec espaces):
	s/ - / — /g;
	# Remplace des apostrophes divergents par des apostrophes normaux:
	s/’/'/g;
	#  Remplace des signes egal abnormauz par des signes egal normaux:
	s/═/=/g;
	# Insere un espace a la fin de signes egals, au cas ou celui-ci manquerai:
	s/=/= /g;
	# Enleve l'espace devancant certains elements a des locations ou ce n'est pas voulu:
	s/( +)( |\.|,|:|;|\!|\]|\)|\n)/$2/g;
	# Enleve plusieurs points se suivant: 
	s/\.+/./g;
	# Enleve plusieurs virgules se suivant:
	s/,+|„/,/g;
	# Enleve plusieurs double points se suivant:
	s/:+/:/g;
	# Enleve plusieurs point-virgules se suivant:
	s/;+/;/g;
	# Enleve des virgules directement suivis par des points:
	s/(,)(\.)/$2/g;
	# Enleve des espaces et points non-voulus suivant la premiere parenthese:
	s/(\(|\[)( +|\.+)/$1/g;
	# Enleve des parentheses sans contenu:
	s/(\(|\[)(\)|\])//g;
	# Enleve des espaces au debut d'une ligne:
	s/^\s+//;
	# Enleve des espaces a la fin d'une ligne, ajoute un newline:
	s/\s+$/\n/;
	# Imprime toutes les lignes non-vides vers le fichier sortant:
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;