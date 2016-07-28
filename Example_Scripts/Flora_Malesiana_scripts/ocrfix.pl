#!/usr/bin/perl
# ocrfix.pl
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



	# Fixes OCR errors where spaces were missed between volumes and years and pages:
	s/(\d)(?: |)(\(\d\d\d\d\))(?: |)(\d)/$1 $2 $3/g;
	
	# Fixes OCR-errors P1., p1., PL., pL., BL., F1., f1. (Pl., pl., Bl., Fl., fl.):
	s/( )(P|p|F|f|B)(1|L|I)(\.)/$1$2l$4/g;
	s/(^)(P|p|B)(1|L|I)(\.)/$1$2l$4/g;
	
	# Fixes OCR-error 'iwn' (instead of 'ium') in taxon names:
	s/(iwn)( |\n|[[:punct:]])/ium$2/g;
	# Fixes OCR error 'la.' instead of '1a.' in keys:
	s/(^)(l|I|i)(a\.)/1$3/g;
	
	
	
	# Fixes OCR error "ﬁ" instead of "fi":
	s/ﬁ/fi/g;
	# Fixes OCR error "ﬂ" instead of "fl":
	s/ﬂ/fl/g;
	
	# Fixes punctuation errors:
	s/ ;/;/g;
	s/ :/:/g;
	
	
	# Fractions not given using fractions, but "number slash number", e.g. 11/2 instead of 1½:
	s/(1)(\/)(2)/½/g;
	s/(1)(\/)(3)/⅓/g;
	s/(1)(\/)(4)/¼/g;
	s/(2)(\/)(3)/⅔/g;
	s/(3)(\/)(4)/¾/g;
	# Inserts space after fraction when followed by a letter:
	s/(½|⅓|¼|⅔|¾)([a-z])/$1 $2/g;
	
	# Removes space in s. n. , giving s.n.:
	s/(s\.)( )(n\.)/$1$3/g;
	# Changes p. p. into p.p.:
	s/( )(p\. p\.)/$1p\.p\./g;
	
	# Prints all non-empty lines to file:
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;