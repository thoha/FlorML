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
	if (/^(?!\t*<)(?!.+(<br \/>|<\/li>)$)(?!.+<\/string>$)(?!.+<\/char>$)(?!.+<\/feature>$)(?!.+xmlns:xsi)/) {
		
		
		# TODO:
		# - Types on separate line without dash in front.
		# - Types inline without dash in front.
		
		
		
		# Specific taxon-related headings:
		s/(^)(Anomalous species|DOUBTFUL |DUBIOUS(?: NAMES| SPECIES|)|EXCLUDED AND DUBIOUS|Cultivated|(?:ENUMERATION OF |)CULTIVATED SPECIES|(?:D(?:oubtful|ubious) & |)Excluded|EXCLUDED|Doubtful|Dubious|GENERA AND SPECIES EXCLUDED|Imperfectly known|Inadequately represented|Incertae sedis|INCOMPLETELY KNOWN SPECIES|Introduced|Insufficient(?:ly known|)|INSUFFICIENTLY KNOWN|Hybrid(?:s|)|Nomina nuda|Species dubiae|Uncertain|UNCERTAIN STATUS|Not yet placed - Mature fruit of the following species are unknown)(.+)/\t\t\t<heading>$2$3<\/heading>/;
		s/(^)(Anomalous species|Probably hybrids:|Cultivated|DUBIOUS(?: NAMES| SPECIES|)|(?:ENUMERATION OF |)CULTIVATED SPECIES|(?:D(?:oubtful|ubious) & |)Excluded|EXCLUDED AND DUBIOUS|EXCLUDED|Doubtful|Dubious|GENERA AND SPECIES EXCLUDED|Imperfectly known|Inadequately represented|Incertae sedis|INCOMPLETELY KNOWN SPECIES|Introduced|Insufficient(?:ly known|)|INSUFFICIENTLY KNOWN|Hybrid(?:s|)|Nomina nuda|Species dubiae|Uncertain|UNCERTAIN STATUS|Not yet placed - Mature fruit of the following species are unknown)($)/\t\t\t<heading>$2<\/heading>/;
		
		# If possible, do not use <taxontitle> mark-up (in general it is a pain in the behind to use):
		# Taxontitles:
		# s/(^)([[:upper:]][[:upper:]]+)(.+)($)/\t\t\t<taxontitle>$2$3<\/taxontitle>/;
		# s/(^)((?:Section|Subgenus|Tribe) )(.+)($)/\t\t\t<taxontitle>$2$3<\/taxontitle>/;
		# For species taxontitles (if no separate species taxontitles are present, comment out):
		# s/(^)(\d+|[[:lower:]])(\. )(.+)($)/\t\t\t<taxontitle num="$2">$4<\/taxontitle>/;
		
		# Adds footnoteRef markup if reference to footnote is present in taxontitle:
		# s/(\t\t\t<taxontitle>.+)([0-9]+|\*)(<\/taxontitle>)/$1<footnoteRef ref="">$2<\/footnoteRef>$3/;
		
		# Splits out writer (and eventual footnotes) if present:
		# s/(<taxontitle>)(.+)(\()(.+)(\))(.*)(<footnoteRef ref="">)([0-9]+|\*)(<\/footnoteRef>)(<\/taxontitle>)/$1$2$10\n\t\t\t<writer>$3$4$5$6$7$8$9<\/writer>/;

	
		
		
		# Inserts nomenclaturalNotes tags where needed:
		s/(^(?:For|See|In so far as known|All synonyms|Synonymy as|The synonyms have been arranged under the subspecies) .+$)/\t\t\t\t<nomenclaturalNotes><string>$1<\/string><\/nomenclaturalNotes>/;
		
		
		
		# Insert opening nomenclature tags for those lines starting with a number or number+letter:
		s/(^\d+(?:[a-z]|)\. |H\. \d\. )/\t\t\t<nomenclature>\n$1/;
		
		# Insert opening nomenclature tags for those lines starting with a Roman number + "Subgenus":
		s/(^(?:I|II|III|IV|V|VI|VII|VIII|IX|X)\. Subgenus)/\t\t\t<nomenclature>\n$1/;
		
		# Insert opening nomenclature tags for those lines starting with a small letter:
		s/(^[[:lower:]](?:\d|)\. )/\t\t\t<nomenclature>\n$1/;
		
		# Inserts opening nomenclature tags for those lines beginning with var. or ssp. or similar:
		s/(^(?:(?:f|form|ssp|subsp|subvar|var)\.|forma|Subsection|Section|Tribe|TRIBUS) )/\t\t\t<nomenclature>\n$1/;
		
		# Inserts opening nomenclature tags for families etc.:
		s/(^(?:[[:upper:] ]+(?:CEAE|IDEAE)(?:\d|)|CONIFERALES|CRUCIFERAE|LABIATAE|PTERIDOPHYTA))( |)/\t\t\t<nomenclature>\n$1/;
		
		
		
		# Mark up homotypes, add tags for accepted names and synonyms at start of line (some synonyms should be accepted names, change by hand afterwards):
		if (/\t\t\t<nomenclature/) {
			# Starting with number or single letter or Hybrid numbering:
			s/(^)(\t\t\t<nomenclature>\n)(\d+(?:[a-z]|)|[[:lower:]](?:\d|)|H\. \d)(\. )(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t<num>$3<\/num>\n$5$6\n\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>/;
			# Starting with Roman number + "Subgenus":
			s/(^)(\t\t\t<nomenclature>\n)(I|II|III|IV|V|VI|VII|VIII|IX|X)(\. )(Subgenus.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t<num>$3<\/num>\n$5$6\n\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>/;
			# Starting with "Tribe" + number:
			s/(^)(\t\t\t<nomenclature>\n)(Tribe )(\d)(\. )(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t<num>$4<\/num>\n$3$6$7\n\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>/;
			
			# Other:
			s/(^)(\t\t\t<nomenclature>\n)((?:form|ssp|subsp|subvar|var)\.|forma|Section|Tribe|TRIBUS)(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n$3$4\n\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>/;
			s/(^)(\t\t\t<nomenclature>\n)([[:upper:] ]+(?:CEAE|IDEAE)(?:\d|)|CONIFERALES|CRUCIFERAE|LABIATAE|PTERIDOPHYTA)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n$3$4\n\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>/;
			
		}
		else {
			s/(^)((?!\t)(?!Type)(?!Lectotype)(?!Paratype)(?!<heading>).+)($)/\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="synonym">\n$1$2$3\n\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>/;
		}
		
		# NOTE: Above code MISSES certain taxa without numbers; these need to be corrected manually later on. This especially happens under "Excluded" etc. headings.
		
		
		
		# Split off types:
		if (/ — Type species| — Type genus| — Lectotype species|^Type(?: |-)species|^Lectotype(?: |-)species/) {
			# Nametypes:
			# Regular:
			s/( — )(Type species)(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<nameType>$2$3/;
			s/(^)(Type(?: |-)species)(.+)($)/\t\t\t\t\t<nameType>$2$3/;
			s/( — )(Type genus(?:|:))(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<nameType>$2$3/;
			
			# Lectotypes:
			s/( — )(Lectotype species)(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<nameType typeStatus="lectotype">$2$3/;
			s/(^)(Lectotype(?: |-)species)(.+)($)/\t\t\t\t\t<nameType typeStatus="lectotype">$2$3/;
		}
		
		else {
			# SpecimenTypes:
			# Regular:
			s/( — )(Typ(?:e|us))(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<specimenType>$2$3/;
			# Lectotypes:
			s/( — )(Lectotyp(?:e|us))(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<specimenType typeStatus="lectotype">$2$3/;
			# Neotypes:
			s/( — )(Neotyp(?:e|us))(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<specimenType typeStatus="neotype">$2$3/;
			# Syntypes:
			s/( — )(Syntyp(?:e|us))(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<specimenType typeStatus="syntype">$2$3/;
			
			# "Based on":
			s/( — )(Based on)(.+)(\n\t\t\t\t\t<\/nom>)/$4\n\t\t\t\t\t<specimenType>$2$3/;
			
			# "Type" at start of line:
			s/(^)(Type)(.+)($)/\t\t\t\t\t<specimenType>$2$3/;
			# "Paratype" at start of line:
			s/(^)(Paratype)(.+)($)/\t\t\t\t\t<specimenType typeStatus="paratype">$2$3/;
			# Note: For these to work, add "line start text" as exception to code in line 85.
			
		}
		
		# Mark up rest of synonyms:
		if (/ — /) {
			s/( — )/\n\t\t\t\t\t<\/nom>\n\t\t\t\t\t<nom class="synonym">\n/g;
		}
		else {
		}
	}
	
	# Inserts remaining opening nomenclature tags:
	# elsif (/<\/taxontitle>$/) {
	#	s/(<\/taxontitle>)($)/$1\n\t\t\t<nomenclature>$2/;
	# }
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