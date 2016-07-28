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

# TODO: Improve script for use with mediocre Naturalis OCR. Auto-fix things like "et a!" and other places with exclamation marks that don't belong, "o/o" and its friends instead of "%", etc.
# em instead of cm, issues w/ micrometer, etc.
# ')ype instead of Type etc.



while (<IN>) {
	# Fixes OCR-error P1. and p1. (Pl. and pl.):
	s/( )(P|p)(1)(\.)/$1$2l$4/g;
	# Fixes OCR-error 'iwn' (instead of 'ium') in taxon names:
	s/(iwn)( |\n|[[:punct:]])/ium$2/g;
	# Fixes OCR error 'la.' instead of '1a.' in keys:
	s/(^)(l|I|i)(a\.)/$1\1$3/g;
	# Fixes OCR error "em" instead of "cm":
	s/( em)( |\)|;|:|\.)/ cm$2/g;
	# Fixes OCR errors ",urn" and "pm" instead of "μm":
	s/(,urn| pm|\!(?:J|l)m)( |\)|;|:|\.)/ μm$2/g;
	# Fixes OCR error "'JYpe:" etc. instead  of "Type:":
	s/((?:'|")(?:f|l\)|I|J|})(?:Y|y|r)pe:|TYpe:)/Type:/g;
	# Fixes OCR error "et a!." instead of "et al.":
	s/et a\!\./et al./g;
	
	# Fixes b questions in the keys when preceded by a number:
	# s/(^)(\d+)(b\. )/$1$3/g;
	# Prints all non-empty lines to file:
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;