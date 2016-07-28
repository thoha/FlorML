#!/usr/bin/perl
# keytags.pl
# Adds mark-up to keys of a.b.c. format. 
# Notes:
# 1) Examples are taxonomically fictional.
# 2) Unless explicitly mentioned, 'taxon name' refers to a single word.
# 3) Some combinations were made out of convenience, because they fitted earlier code and it would be more work to add another statement than just add the combination. Sorry if that makes the code less readable.
# 4) Code strips off page numbers.
	# TODO: further ranks (Series, subgenus, etc.) - Do Later whenever encountered.
	
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
	# Marks up KEYTITLES:
	s/(^(?:KEY|REGIONAL KEY))(.+)($)/\t\t\t<key>\n\t\t\t\t<keyTitle>$1$2$3<\/keyTitle>/;
	
	# Question leads:
	# General format of beginning of line of this type of key: a., b., c. are all followed by a space and a capital letter. NOTES: a. is preceded by a number.
	
	# The following marks up various formats of b. and c. leads:
		
	# Marks up b. and c. leads ending on a number + genus name + species name + infraspecific rank + infraspecific name + page number ("67. Cornus macrophylla var. macrophylla (p. 567)"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9$10$11$12<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a genus name + species name + infraspecific rank + infraspecific name + page number ("Cornus macrophylla var. macrophylla (p. 67)"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7$8$9$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a number + genus name + species name + infraspecific rank + infraspecific name ("56. Cornus macrophylla var. macrophylla"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9$10$11$12<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a genus name + species name + infraspecific rank + infraspecific name ("Cornus macrophylla var. macrophylla"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7$8$9$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up b. and c. leads ending on a number + taxon name + taxon rank + taxon name + page number  ("45. Tectaria sect. Tectaria (p. 56)"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9$10$11<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a taxon name + taxon rank + taxon name + page number ("Tectaria sect. Tectaria (p. 56)"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7$8$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a number + taxon name + taxon rank + taxon name ("45. Tectaria sect. Tectaria"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9$10$11<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a taxon name + taxon rank + taxon name ("Tectaria sect. Tectaria"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7$8$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up b. and c. leads ending on a number + taxon rank (or abbreviated genus) + taxon name + page number ("1. Section Cornus (p. 123)" or "a. var. cornus (p. 123)" or "45b. var. Cornus (p. 45)"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w*\. )([[:lower:]]\w+|[[:upper:]]\w+))( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a number + taxon rank (or abbreviated genus (using * after special character \w)) + taxon name ("1. Section Cornus" or "a. var. Cornus" or "45b. var. cornus"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w*\. )([[:lower:]]\w+$|[[:upper:]]\w+$))/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up b. and c. leads ending on a number + taxon rank (or unabbreviated genus) + taxon name + page number ("Section Cornus (p. 123)" or "var. cornus (p. 123)"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+|[[:upper:]]\w+))( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num="$7">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a number + taxon rank (or unabbreviated genus) + taxon name ("Section Cornus" or "var. cornus"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+$|[[:upper:]]\w+$))/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num="$7">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up b. and c. leads ending on a taxon rank (or unabbreviated genus) + taxon name + page number ("Section Cornus (p. 123)" or "var. cornus (p. 123)"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+|[[:upper:]]\w+))( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
		
	# Marks up b. and c. leads ending on a taxon rank (or unabbreviated genus) + taxon name ("Section Cornus" or "var. cornus"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+$|[[:upper:]]\w+$))/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up b. and c. leads ending on a number + taxon name + page number ("1. Cornus (p. 123)") (wipes page number):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )(\d+)(\. )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a number + taxon name ("1. Cornus"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )(\d+)(\. )([[:upper:]]\w+(?:| p\.p\.)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$7\">$9<\/toTaxon>\n\t\t\t\t\t<\/question>/;
		
		
	# Marks up b. and c. leads ending on a taxon name + page number ("Cornus (p. 123)") (wipes page number):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up b. and c. leads ending on a taxon name ("Cornus"):
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+$)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toTaxon>$7<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up b. and c. leads ending on a couplet number:
	s/(^)(b|c|d)(\. )([[:upper:]])(.+)( )(\d+)($)/$1\t\t\t\t\t<question num=\"$2\">\n\t\t\t\t\t\t<text>$4$5<\/text>\n\t\t\t\t\t\t<toCouplet num=\"$7\">$7<\/toCouplet>\n\t\t\t\t\t<\/question>/;
	
	
	# Couplet tags are added in with a. leads
	# The following marks up various formats (the same ones as for the b./c. leads) of a. leads:
	
	# Marks up a. leads ending on a number + genus name + species name + infraspecific rank + infraspecific name + page number ("67. Cornus macrophylla var. macrophylla (p. 567)"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10$11$12$13<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a genus name + species name + infraspecific rank + infraspecific name + page number ("Cornus macrophylla var. macrophylla (p. 67)"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8$9$10$11<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a number + genus name + species name + infraspecific rank + infraspecific name ("56. Cornus macrophylla var. macrophylla"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10$11$12$13<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a genus name + species name + infraspecific rank + infraspecific name ("Cornus macrophylla var. macrophylla"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ |[[:upper:]]\. )([[:lower:]]\w+ )(forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. )([[:lower:]]\w+$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8$9$10$11<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up a. leads ending on a number + taxon name + taxon rank + taxon name + page number  ("45. Tectaria sect. Tectaria (p. 56)"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10$11$12<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a taxon name + taxon rank + taxon name + page number ("Tectaria sect. Tectaria (p. 56)"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8$9$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a number + taxon name + taxon rank + taxon name ("45. Tectaria sect. Tectaria"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10$11$12<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a taxon name + taxon rank + taxon name ("Tectaria sect. Tectaria"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+ )(sect\. |Sect\. |section | Section )([[:upper:]]\w+$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8$9$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up a. leads ending on a number + taxon rank (or abbreviated genus) + taxon name + page number ("1. Section Cornus (p. 123)" or "a. var. cornus (p. 123)" or "45b. var. Cornus (p. 45)"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w*\. )([[:lower:]]\w+|[[:upper:]]\w+))( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a number + taxon rank (or abbreviated genus (using * after special character \w)) + taxon name ("1. Section Cornus" or "a. var. Cornus" or "45b. var. cornus"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w*\. )([[:lower:]]\w+$|[[:upper:]]\w+$))/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up a. leads ending on a number + taxon rank (or unabbreviated genus) + taxon name + page number ("Section Cornus (p. 123)" or "var. cornus (p. 123)"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+|[[:upper:]]\w+))( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num="$8">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
		
	# Marks up a. leads ending on a number + taxon rank (or unabbreviated genus) + taxon name ("Section Cornus" or "var. cornus"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+|[[:lower:]]|\d+[[:lower:]])(\. )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+$|[[:upper:]]\w+$))/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num="$8">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a taxon rank (or unabbreviated genus) + taxon name + page number ("Section Cornus (p. 123)" or "var. cornus (p. 123)"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+|[[:upper:]]\w+))( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
		
	# Marks up a. leads ending on a taxon rank (or unabbreviated genus) + taxon name ("Section Cornus" or "var. cornus"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )((forma |form |var\. |subsp\. |ssp\. |subforma |subform |subvar\. |sect. |[[:upper:]]\w+\. |[[:upper:]]\w+ )([[:lower:]]\w+$|[[:upper:]]\w+$))/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	# Marks up a. leads ending on a number + taxon name + page number ("1. Cornus (p. 123)") (wipes page number):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+)(\. )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a number + taxon name ("1. Cornus"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+)(\. )([[:upper:]]\w+(?:| p\.p\.)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon num=\"$8\">$10<\/toTaxon>\n\t\t\t\t\t<\/question>/;
		
		
	# Marks up a. leads ending on a taxon name + page number ("Cornus (p. 123)") (wipes page number):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+)( \(p\. \d+\)$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	# Marks up a. leads ending on a taxon name ("Cornus"):
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )([[:upper:]]\w+$)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toTaxon>$8<\/toTaxon>\n\t\t\t\t\t<\/question>/;
	
	
	
	# Marks up a. leads ending on a couplet number:
	s/(^)(\d+)(a)(\. )([[:upper:]])(.+)( )(\d+)($)/$1\t\t\t\t<\/couplet>\n\t\t\t\t<couplet num=\"$2\">\n\t\t\t\t\t<question num=\"$3\">\n\t\t\t\t\t\t<text>$5$6<\/text>\n\t\t\t\t\t\t<toCouplet num=\"$8\">$8<\/toCouplet>\n\t\t\t\t\t<\/question>/;
	
		
	# Some manual clean-up of keys is required to make them all functional, but this program ought to save time.
	
	 print OUT $_;
}

close IN;
close OUT;