#!/usr/bin/perl
# clestags.plx
# Ajoute les tags XML auc cles de style a.b.c. 
# Notes:
# 1) Les Examples sont fictifs taxonomiquement.
# 2) 'taxon name' refere a un seul mot. Si ce n'est pas le cas, ceci est mentione explicitement.
# 3) Le script enleve toute mention de numero de page. 

use warnings;
use strict;
# use switch;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Ajoute les tags au TITRES DE CLÉ:
	s/(^(?:CLÉ|CLE|Clé))(.+)($)/\t\t\t<key>\n\t\t\t\t<keyTitle>$1$2$3<\/keyTitle>/;
	
	# Questions:
	# Format general du debut de ligne pour ces cles: a., b., c. suivi d'un espace et une Majuscule. NOTE 1: a. est precede par un numero. NOTE 2: Les cles utilisant des tabulation pour la 'numerotation' des questions doivent etre transcites vers des cles utilisant des numeros.
	
	# Le suivant ajoute des tags a divers formats de question b. a f.:
	
	
	
	
	
	# Format: Se termine sur: numero + Abbreviation de genre + nom taxonomique + rang infraspecifique + nom infraspecifique:
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+(?:|bis|\.\d+))(\. )(([[:upper:]]|[[:upper:]][[:lower:]])(\. )([[:lower:]]|[[:upper:]])\w+(|-\w+) ((?:var|v)\.) ((?:[[:upper:]]|[[:lower:]])\w+)(|\.)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: Abbreviation de genre + nom taxonomique + rang infraspecifique + nom infraspecifique:
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(([[:upper:]]|[[:upper:]][[:lower:]])(\. )([[:lower:]]|[[:upper:]])\w+(|-\w+) ((?:var|v|subsp|ssp|fa)\.) ((?:[[:upper:]]|[[:lower:]])\w+)(|\.)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: numero + Abbreviation de genre + nom taxonomique ("1. C. macrophylla"), ou numero + Abbreviation de genre + nom taxonomique + Auteur ("1. C. macrophylla Pilger"), ou numero + Abbreviation de variation + nom taxonomique ("1. var. macrophylla"), ou les options precedentes suivi de texte en parentheses (2 options):
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+(?:| bis|\.\d+))(\. )(([[:upper:]]|[[:upper:]][[:lower:]]|II|III|IV|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|var|fa|sect)\. ([[:lower:]]|[[:upper:]])\w+(|-\w+| [[:upper:]]\w+| (?:[[:upper:]]\.)+[[:upper:]]\w+| p\. \d+)(| \(.+\)|\. \(.+\))(|\.)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: Abbreviation de genre + nom taxonomique ("C. macrophylla"), ou Abbreviation de genre + nom taxonomique + Auteur ("C. macrophylla Pilger"), ou Abbreviation de variation + nom taxonomique ("var. macrophylla"), ou les options precedentes suivi de texte en parentheses (2 options):
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(([[:upper:]]|[[:upper:]][[:lower:]]|II|III|IV|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|var|fa|sect)\. ([[:lower:]]|[[:upper:]])\w+(|-\w+| [[:upper:]]\w+| (?:[[:upper:]]\.)+[[:upper:]]\w+| p\. \d+)(| \(.+\)|\. \(.+\))(|\.)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: numero + nom taxonomique + numero de page sans parentheses ("XII. Isachneae p. 9" ou "3. Guaduella p. 9") (elimine le numero de page):
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+|I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX)(\. )([[:upper:]]\w+)( p\. \d+)($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num="$7">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/g;
	
	
	# Format: Se termine sur: rang au-dessus de genre + nom taxonomique ("tribu des Cryptocaryees."):
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )((?:tribu|sous-famille) des [[:upper:]]\w+(|\.)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	
	
	# Format: Se termine sur: numero + Genre + nom taxonomique ("1. Cornus macrophylla")
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+)(\. )([[:upper:]]\w+ \w+(|\.))($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num="$7">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: Genre + nom taxonomique ("Cornus macrophylla") ou abbreviation de sous-espece/variation + nom taxonomique ("subsp. ramosa")
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )((?:[[:upper:]]\w+|subsp\.|var\.) \w+(|\.))($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: numero + Genre + nom taxonomique + texte en parentheses ("1. Cornus (p. 34)")
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+)(\. )([[:upper:]]\w+)(( \(.+\)|\. \(.+\))(|\.)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: numero + nom taxonomique ("1. Cornus"):
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+)(\. )([[:upper:]]\w+(|\.)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: nom taxonomique ("Cornus"):
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )([[:upper:]]\w+(|\.| \(cult\.\)\.)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: numero + Abbreviation de genre + nom taxonomique, le tout entre parentheses ("1. C. macrophylla"), ou numero + Abbreviation de variation + nom taxonomique, le tout entre parentheses ("1. var. macrophylla"), ou les options precedentes suivi de texte en parentheses (2 options):
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()(\d+)(\. )(([[:upper:]]|[[:upper:]][[:lower:]]|II|III|IV|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|var)\. ([[:lower:]]|[[:upper:]])\w+(|-\w+)(| \(.+\)|\. \(.+\))(|\.))(\)\.)($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: Abbreviation de genre + nom taxonomique, le tout entre parentheses ("C. macrophylla"), ou Abbreviation de variation + nom taxonomique, le tout entre parentheses ("var. macrophylla"), ou les options precedentes suivi de texte en parentheses (2 options):
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()(([[:upper:]]|[[:upper:]][[:lower:]]|II|III|IV|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|var)\. ([[:lower:]]|[[:upper:]])\w+(|-\w+)(| \(.+\)|\. \(.+\))(|\.))(\)\.)($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: numero + Genre + nom taxonomique, le tout entre parentheses ("(1. Cornus macrophylla).")
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()(\d+)(\. )([[:upper:]]\w+ \w+(|\.))(\)\.)($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num="$7">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: Genre + nom taxonomique, le tout entre parentheses ("(Cornus macrophylla).")
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()([[:upper:]]\w+ \w+(|\.))(\)\.)($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: numero + nom taxonomique, le tout entre parentheses ("(1. Cornus)."):
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()(\d+)(\. )([[:upper:]]\w+(|\.))(\)\.)($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: nom taxonomique entre parentheses ("(Cornus)."):
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()([[:upper:]]\w+(|\.))(\)\.)($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur Groupe + numero + pages ("Groupe 4 (p. 186)")
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )((?:Groupe|GROUPE) )(\d+)(( \(.+\)|\. \(.+\))(|\.)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$7$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: point suivi d'un numero:
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)(\.)( )(\d+)($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5$6<\/text>\n\t\t\t\t\t\t<toCouplet num=\"$8\">$8<\/toCouplet>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: double point suivi d'un numero:
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)(: )(\d+)($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toCouplet num=\"$7\">$7<\/toCouplet>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: double point suivi de "genres non africains":
	s/(^)(b|c|d|e|f)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)(: )((?:G|g)enres non africains)(\.)($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	
	
	
	# Le suivant ajoute des tags a divers formats de question a.:
	
	# Format: Se termine sur: numero + Abbreviation de genre + nom taxonomique + rang infraspecifique + nom infraspecifique:
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+(?:| bis|\.\d+))(\. )(([[:upper:]]|[[:upper:]][[:lower:]])(\. )([[:lower:]]|[[:upper:]])\w+(|-\w+) ((?:var|v)\.) ((?:[[:upper:]]|[[:lower:]])\w+)(|\.)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: Abbreviation de genre + nom taxonomique + rang infraspecifique + nom infraspecifique:
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(([[:upper:]]|[[:upper:]][[:lower:]])(\. )([[:lower:]]|[[:upper:]])\w+(|-\w+) ((?:var|v|subsp|ssp|fa)\.) ((?:[[:upper:]]|[[:lower:]])\w+)(|\.)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: numero + Abbreviation de genre + nom taxonomique ("1. C. macrophylla"), ou numero + Abbreviation de genre + nom taxonomique + Auteur ("1. C. macrophylla Pilger"), ou numero + Abbreviation de variation + nom taxonomique ("1. var. macrophylla"), ou les options precedentes suivi de texte en parentheses (2 options):
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+(?:| bis|\.\d+))(\. )(([[:upper:]]|[[:upper:]][[:lower:]]|II|III|IV|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|var|fa|sect)\. ([[:lower:]]|[[:upper:]])\w+(|-\w+| [[:upper:]]\w+| (?:[[:upper:]]\.)+[[:upper:]]\w+| p\. \d+)(| \(.+\)|\. \(.+\))(|\.)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: Abbreviation de genre + nom taxonomique ("C. macrophylla"), ou Abbreviation de genre + nom taxonomique + Auteur ("C. macrophylla Pilger"), ou Abbreviation de variation + nom taxonomique ("var. macrophylla"), ou les options precedentes suivi de texte en parentheses (2 options):
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(([[:upper:]]|[[:upper:]][[:lower:]]|II|III|IV|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|var|fa|sect)\. ([[:lower:]]|[[:upper:]])\w+(|-\w+| [[:upper:]]\w+| (?:[[:upper:]]\.)+[[:upper:]]\w+| p\. \d+)(| \(.+\)|\. \(.+\)| s\.s)(|\.)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: numero + nom taxonomique + numero de page sans parentheses ("XII. Isachneae p. 9" ou "3. Guaduella p. 9") (elimine le numero de page):
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+|I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX)(\. )([[:upper:]]\w+)( p\. \d+)($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num="$8">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/g;
	
	
	# Format: Se termine sur: rang au-dessus de genre + nom taxonomique ("tribu des Cryptocaryees."):
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )((?:tribu|sous-famille) des [[:upper:]]\w+(|\.)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: numero + Genre + nom taxonomique ("1. Cornus macrophylla")
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+)(\. )([[:upper:]]\w+ \w+(|\.))($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num="$8">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: Genre + nom taxonomique ("Cornus macrophylla") ou abbreviation de sous-espece/variation + nom taxonomique ("subsp. ramosa")
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )((?:[[:upper:]]\w+|subsp\.|var\.) \w+(|\.))($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: numero + Genre + nom taxonomique + texte en parentheses ("1. Cornus (p. 34)")
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+)(\. )([[:upper:]]\w+)(( \(.+\)|\. \(.+\))(|\.)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: numero + nom taxonomique ("1. Cornus" ou "1. Cornus."):
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )(\d+)(\. )([[:upper:]]\w+(|\.)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: nom taxonomique ("Cornus"):
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )([[:upper:]]\w+(|\.| \(cult\.\)\.)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: numero + Abbreviation de genre + nom taxonomique, le tout entre parentheses ("(1. C. macrophylla)."), ou numero + Abbreviation de variation + nom taxonomique, le tout entre parentheses ("(1. var. macrophylla)."), ou les options precedentes suivi de texte en parentheses (2 options):
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()(\d+)(\. )(([[:upper:]]|[[:upper:]][[:lower:]]|II|III|IV|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|var)\. ([[:lower:]]|[[:upper:]])\w+(|-\w+)(| \(.+\)|\. \(.+\))(|\.))(\)\.)($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: Abbreviation de genre + nom taxonomique, le tout entre parentheses ("(C. macrophylla)."), ou Abbreviation de variation + nom taxonomique ("(var. macrophylla)."), ou les options precedentes suivi de texte en parentheses (2 options):
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()(([[:upper:]]|[[:upper:]][[:lower:]]|II|III|IV|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|var)\. ([[:lower:]]|[[:upper:]])\w+(|-\w+)(| \(.+\)|\. \(.+\)| s\.s)(|\.))(\)\.)($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: numero + Genre + nom taxonomique, le tout entre parentheses ("(1. Cornus macrophylla).")
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()(\d+)(\. )([[:upper:]]\w+ \w+(|\.))(\)\.)($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num="$8">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: Genre + nom taxonomique, le tout entre parentheses ("(Cornus macrophylla).")
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()([[:upper:]]\w+ \w+(|\.))(\)\.)($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: numero + nom taxonomique, le tout entre parentheses ("(1. Cornus)."):
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()(\d+)(\. )([[:upper:]]\w+(|\.))(\)\.)($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: nom taxonomique, le tout entre parentheses ("(Cornus)."):
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( \()([[:upper:]]\w+(|\.))(\)\.)($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur Groupe + numero + pages ("Groupe 4 (p. 186)")
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)( )((?:Groupe|GROUPE) )(\d+)(( \(.+\)|\. \(.+\))(|\.)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$9\">$8$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Format: Se termine sur: point suivi d'un numero:
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)(\.)( )(\d+)($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6$7<\/text>\n\t\t\t\t\t\t<toCouplet num=\"$9\">$9<\/toCouplet>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: double point suivi d'un numero:
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)(: )(\d+)($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toCouplet num=\"$8\">$8<\/toCouplet>\n\t\t\t\t\t<\/question>/;
	
	# Format: Se termine sur: double point suivi de "genres non africains":
	s/(^)(\d+)(a)(\. )([[:upper:]]|\d+(?:|-\d+))(.+)(: )((?:G|g)enres non africains)($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	
	
	
	
	# Elimine le numero de page pour certaines des options au-dessus et deplace le numero du taxon vers la location correcte:
	s/(<toTaxon)(>)(I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX)(\. )((?:[[:lower:]]|[[:upper:]])\w+)( \(p\. \d+\)\.)/$1 num="$3"$2$5/g;
	s/(<toTaxon)(>)(I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX)(\. )((?:[[:lower:]]|[[:upper:]])\w+)( \(p\. \d+\))/$1 num="$3"$2$5/g;
	s/( \(p\. \d+\))(<\/toTaxon>)/$2/g;
	# Deplace le numero du taxon vers la location correcte pour certaines des options au-dessus:
	s/(<toTaxon)(>)(I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX)(\. )((?:[[:lower:]]|[[:upper:]])\w+)/$1 num="$3"$2$5/g;
	s/(<toTaxon)(>)(I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX)(\. )((?:[[:lower:]]|[[:upper:]])\w+)/$1 num="$3"$2$5/g;
	
	
	# Elimine le point devant le tag de fermeture </toTaxon>
	s/(\.)(<\/toTaxon>)/$2/g;
	
	
	# Marks up b. and c. leads ending on a number + genus name + species name + infraspecific rank + infraspecific name + page number ("67. Cornus macrophylla var. macrophylla (p. 567)"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9$10$11$12<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a genus name + species name + infraspecific rank + infraspecific name + page number ("Cornus macrophylla var. macrophylla (p. 67)"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7$8$9$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a number + genus name + species name + infraspecific rank + infraspecific name ("56. Cornus macrophylla var. macrophylla"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9$10$11$12<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a genus name + species name + infraspecific rank + infraspecific name ("Cornus macrophylla var. macrophylla"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7$8$9$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up b. and c. leads ending on a number + taxon name + taxon rank + taxon name + page number  ("45. Tectaria sect. Tectaria (p. 56)"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9$10$11<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a taxon name + taxon rank + taxon name + page number ("Tectaria sect. Tectaria (p. 56)"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7$8$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a number + taxon name + taxon rank + taxon name ("45. Tectaria sect. Tectaria"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9$10$11<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a taxon name + taxon rank + taxon name ("Tectaria sect. Tectaria"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7$8$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up b. and c. leads ending on a number + taxon rank (or abbreviated genus) + taxon name + page number ("1. Section Cornus (p. 123)" or "a. var. cornus (p. 123)" or "45b. var. Cornus (p. 45)"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w*\. )([[:lower:]]\w+|[[:upper:]]\w+))( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a number + taxon rank (or abbreviated genus (using * after special character \w)) + taxon name ("1. Section Cornus" or "a. var. Cornus" or "45b. var. cornus"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w*\. )([[:lower:]]\w+$|[[:upper:]]\w+$))/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up b. and c. leads ending on a taxon rank (or unabbreviated genus) + taxon name + page number ("Section Cornus (p. 123)" or "var. cornus (p. 123)"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+|[[:upper:]]\w+))( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
		
	# Marks up b. and c. leads ending on a taxon rank (or unabbreviated genus) + taxon name ("Section Cornus" or "var. cornus"):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+$|[[:upper:]]\w+$))/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	
	
		
	# Marks up b. and c. leads ending on a taxon name + page number ("Cornus (p. 123)") (wipes page number):
	#s/(^)(b|c)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	
	# Couplet tags are added in with a. leads
	# The following marks up various formats (the same ones as for the b./c. leads) of a. leads:
	
	# Marks up a. leads ending on a number + genus name + species name + infraspecific rank + infraspecific name + page number ("67. Cornus macrophylla var. macrophylla (p. 567)"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10$11$12$13<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a genus name + species name + infraspecific rank + infraspecific name + page number ("Cornus macrophylla var. macrophylla (p. 67)"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8$9$10$11<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a number + genus name + species name + infraspecific rank + infraspecific name ("56. Cornus macrophylla var. macrophylla"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10$11$12$13<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a genus name + species name + infraspecific rank + infraspecific name ("Cornus macrophylla var. macrophylla"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8$9$10$11<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up a. leads ending on a number + taxon name + taxon rank + taxon name + page number  ("45. Tectaria sect. Tectaria (p. 56)"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10$11$12<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a taxon name + taxon rank + taxon name + page number ("Tectaria sect. Tectaria (p. 56)"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8$9$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a number + taxon name + taxon rank + taxon name ("45. Tectaria sect. Tectaria"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10$11$12<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a taxon name + taxon rank + taxon name ("Tectaria sect. Tectaria"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8$9$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up a. leads ending on a number + taxon rank (or abbreviated genus) + taxon name + page number ("1. Section Cornus (p. 123)" or "a. var. cornus (p. 123)" or "45b. var. Cornus (p. 45)"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w*\. )([[:lower:]]\w+|[[:upper:]]\w+))( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a number + taxon rank (or abbreviated genus (using * after special character \w)) + taxon name ("1. Section Cornus" or "a. var. Cornus" or "45b. var. cornus"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w*\. )([[:lower:]]\w+$|[[:upper:]]\w+$))/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up a. leads ending on a taxon rank (or unabbreviated genus) + taxon name + page number ("Section Cornus (p. 123)" or "var. cornus (p. 123)"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+|[[:upper:]]\w+))( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
		
	# Marks up a. leads ending on a taxon rank (or unabbreviated genus) + taxon name ("Section Cornus" or "var. cornus"):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+$|[[:upper:]]\w+$))/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up a. leads ending on a number + taxon name + page number ("1. Cornus (p. 123)") (wipes page number):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+)(\. )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
		
		
	# Marks up a. leads ending on a taxon name + page number ("Cornus (p. 123)") (wipes page number):
	#s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	
	
	
		
	# Some manual clean-up of keys is required to make them all functional, but this program ought to save time.
	
	 print OUT $_;
}

close IN;
close OUT;