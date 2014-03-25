#!/usr/bin/perl
# nomenclature.plx
# Add nomenclature and homotypes tags, split off types, mark up accepted paragraphs and synonym paragraphs as far as possible.
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Not lines starting with < or ending on a <br /> or </string> or being the doctype:
	if (/^(?!\t*<)(?![[:upper:]].+\.<\/li>$)(?!([[:upper:]]|\d).+(\.|:|\))<br \/>$)(?!.+<\/string>$)(?!.+xmlns:xsi)/) {
		
		# Insert opening nomenclature tags for those lines starting with a number:
		s/(^\d+\. )/\t\t\t<nomenclature>\n$1/;
		
		# Insert opening nomenclature tags for those lines starting with a small letter:
		s/(^[[:lower:]]\. )/\t\t\t<nomenclature>\n$1/;
		
		
		# Mark up homotypes, add tags for accepted names and synonyms at start of line (some synonyms should be accepted names, change by hand afterwards):
		if (/\t\t\t<nomenclature/) {
			s/(^)(\t\t\t<nomenclature>\n)(\d+|[[:lower:]])(\. )(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t<num>$3<\/num>\n$5$6\n\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>/;
		}
		else {
			s/(^)(.+)($)/\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="synonym">\n$1$2$3\n\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>/;
		}
		
		# Split off types:
		if (/ — Type species| — Type genus| — Lectotype species/) {
			# Nametypes:
			# Regular:
			s/( — )(Type species)(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<nameType>$2$3/;
			s/( — )(Type genus(?:|:))(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<nameType>$2$3/;
			# Lectotypes:
			s/( — )(Lectotype species)(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<nameType typeStatus="lectotype">$2$3/;
		}
		else {
			# SpecimenTypes:
			# Regular:
			s/( — )(Type)(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<specimenType>$2$3/;
			# Lectotypes:
			s/( — )(Lectotype)(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<specimenType typeStatus="lectotype">$2$3/;
		}
		
		# Mark up rest of synonyms:
		if (/ — /) {
			s/( — )/\n\t\t\t\t\t<\/nom>\n\t\t\t\t\t<nom class="synonym">\n/g;
		}
		else {
		}
	}
	
	# Inserts remaining opening nomenclature tags:
	elsif (/<\/taxontitle>$/) {
		s/(<\/taxontitle>)($)/$1\n\t\t\t<nomenclature>$2/;
	}
	# Inserts closing nomenclature tags:
	elsif (/^\t\t\t<feature class="description">/) {
		s/(^)(\t\t\t<feature class="description">)/\t\t\t<\/nomenclature>\n$1$2/;
	}
	else {
	}
	
	
	
	print OUT $_;
}

close IN;
close OUT;