#!/usr/bin/perl
# reparocr.plx
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
	# Repare erreurs OCR P1., p1., PL., pL., BL., F1., f1. (Pl., pl., Bl., Fl., fl.):
	s/( )(P|p|F|f|B)(1|L|I)(\.)/$1$2l$4/g;
	s/(^)(P|p|B)(1|L|I)(\.)/$1$2l$4/g;
	
	# Remplace Ι par I:
	s/Ι/I/g;
	# Remplace ﬁ par fi:
	s/ﬁ/fi/g;
	# Remplace ﬂ par fl:
	s/ﬂ/fl/g;
	
	# Remplace mauvaise ponctuation par ponctuation normale:
	s/ ;/;/g;
	s/ :/:/g;
	s/(-|–)/-/g;
	
	# Repare erreurs de chiffre dans les annees:
	# Change par ex. (199o) en (1990)
	s/( \(\d\d\d)(o|O)(\))/${1}0${3}/g;
	# Change par ex. (i878) en (1878)
	s/( \()(i|l)(\d\d\d\))/${1}1${3}/g;
	# Change par ex. (i76o) en (1760)
	s/( \()(i|l)(\d\d)(o|O)(\))/${1}1${3}0${5}/g;
	
	# Repare erreurs de chiffre dans des numeros:
	# Change par ex. 9o en 90
	s/(\d)(o)/${1}0/g;
	# Change par ex. 9o9 en 909
	s/(\d)(o)(\d)/${1}0${3}/g;
	# Change par ex. i5 en 15, ou l5 en 15
	s/(-| )(i|l)(\d)/${1}1${3}/g;
	# Change par ex. 5i5 en 515, ou 5l5 en 515
	s/(\d)(i|l)(\d)/${1}1${3}/g;
	# Change par ex. 5i en 51, ou 5l en 51
	s/(\d)(i|l)/${1}1/g;
	# Change par ex. o,6 en 0,6
	s/(-| )(o)(,\d)/${1}0${3}/g;
	# Change par ex. i,6 en 1,6
	s/(-| )(i)(,\d)/${1}1${3}/g;
	# Change par ex. io-15 en 10-15
	s/(io)(\-|\-)(\d)/10${2}${3}/g;
	# Change par ex. i-1,5 en 1-1,5
	s/(i)(\-|\-)(\d)/1${2}${3}/g;
	
	# Repare erreurs de parenthese:
	s/(\{)(\d)/($2/g;
	s/(\d)(\})/$1)/g;
	
	# Enleve l'espace entre s. et n. dans s. n., donnant s.n.:
	s/(s\.)( )(n\.)/$1$3/g;
	
	# Repare erreur OCR 'iwn' (a la place de 'ium') dans les noms taxonomiques:
	s/(iwn)( |\n|[[:punct:]])/ium$2/g;
	
	# Repare erreurs dans certains noms:
	
	s/gahonensis/gabonensis/g;
	s/Æ/AE/g;
	s/æ/ae/g;
	
	# Change p. p. en p.p.:
	s/( )(p\. p\.)/$1p\.p\./g;
	
	
	
	
	
	# Prints all non-empty lines to file:
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;