#!/usr/bin/perl
# nomenclature.pl
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
		s/(^\d+(?:[a-z]|)\. )/\t\t\t<nomenclature>\n$1/;
		
		# Insert opening nomenclature tags for those lines starting with a small letter:
		s/(^[[:lower:]]\. )/\t\t\t<nomenclature>\n$1/;
		
		# Insert opening nomenclature tags for those lines starting with "In the Guianas only:":
		s/(^In the Guianas only: )/\t\t\t<nomenclature>\n$1/;
		
		
		# Mark up homotypes, add tags for accepted names and synonyms at start of line (some synonyms should be accepted names, change by hand afterwards):
		if (/\t\t\t<nomenclature/) {
			# Starting with number:
			s/(^)(\t\t\t<nomenclature>\n)(\d+(?:[a-z]|)|[[:lower:]])(\. )(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t<num>$3<\/num>\n$5$6\n\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>/;
			# "In the Guianas only:":
			s/(^)(\t\t\t<nomenclature>\n)(In the Guianas only: )(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t<nomenclaturalNotes>$3<\/nomenclaturalNotes>\n$4$5\n\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>/;
			
		}
		else {
			s/(^)(?!Type: )(?!Lectotype)(.+)($)/\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="synonym">\n$1$2$3\n\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>/;
		}
		
		# Note: above code will mark up taxa WITHOUT A NUMBER improperly, these need a manual check afterwards.
		
		
		# Split off types:
		
		# SpecimenTypes:
		# Regular:
		s/(\.)( )(Type(?: locality|): )(.+)(\n\t\t\t\t\t<\/nom>)/$1$5\n\t\t\t\t\t<specimenType>$3$4/;
		# Lectotypes:
		s/(\.)( )(Lectotype(?: here designated|))(.+)(\n\t\t\t\t\t<\/nom>|)/$1$5\n\t\t\t\t\t<specimenType typeStatus="lectotype">$3$4/;
		# Neotypes:
		s/(\.)( )(Neotype)(.+)(\n\t\t\t\t\t<\/nom>)/$1$5\n\t\t\t\t\t<specimenType typeStatus="neotype">$3$4/;
		# Neotypes:
		s/(\.)( )(Syntype)(.+)(\n\t\t\t\t\t<\/nom>)/$1$5\n\t\t\t\t\t<specimenType typeStatus="syntype">$3$4/;
		
		# NameTypes:
		s/(\t\t\t\t\t<specimenType>)(Type: )([[:upper:]]\. [[:lower:]]+ (?:\([[:upper:]][[:lower:]\.]+\) |)[[:upper:]](?:[[:lower:]]+|)(?:\.|))/\t\t\t\t\t<nameType>$2$3/;
		s/(\t\t\t\t\t<specimenType typeStatus="lectotype">)(Lectotype(?: here designated|): )([[:upper:]]\. [[:lower:]]+ [[:upper:]](?:[[:lower:]]+|)(?:\.|))/\t\t\t\t\t<nameType typeStatus="lectotype">$2$3/;
		s/(^)(Type: )([[:upper:]]\. [[:lower:]]+ (?:\([[:upper:]][[:lower:]\.]+\) |)[[:upper:]](?:[[:lower:]]+|)(?:\.|))/\t\t\t\t\t<nameType>$2$3/;
		s/(^)(Lectotype(?:.+?|): )([[:upper:]]\. [[:lower:]]+ (?:\([[:upper:]][[:lower:]\.]+\) |)[[:upper:]](?:[[:lower:]]+|)(?:\.|))/\t\t\t\t\t<nameType typeStatus="lectotype">$2$3/;
		
		# Type genus (in-line):
		s/(\.)( )(Type genus)(.+)(\n\t\t\t\t\t<\/nom>)/$1$5\n\t\t\t\t\t<nameType>$3$4/;
		
		
		
		# Mark up rest of synonyms:
		if (/ (?:—|−) /) {
			s/( (?:—|−) )/\n\t\t\t\t\t<\/nom>\n\t\t\t\t\t<nom class="synonym">\n/g;
		}
		else {
		}
		
		# Splits citations and taxonomic names:
		s/(\t\t\t\t\t<nom class="(?:synonym|basionym|homonym|accepted)">\n(?:\t\t\t\t\t\t<name class="note">.+?<\/name>\n|\t\t\t\t\t\t<num>\d+<\/num>\n|))(.+?)(, )(?!comb\. nov\.)(?!nov\. sp\.)(.+)/$1$2\n$4/g;
		# Moves editor to correct place:
		s/(\t\t\t\t\t<nom class="(?:synonym|basionym|homonym|accepted)">\n(?:\t\t\t\t\t\t<name class="note">.+?<\/name>\n|\t\t\t\t\t\t<num>\d+<\/num>\n|).+?)( )(in .+?)(\n)(.+)/$1$4$3, $5/g;
		
	
		
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