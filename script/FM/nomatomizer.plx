#!/usr/bin/perl
# nomatomizer.plx
# Atomize nomenclature and types (including type citations).
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# To do: add atomization of names with author starting with "auct\. non"

	# Nomenclature and citations are:
	# Not lines starting with < or ending on a <br /> or </string> or being the doctype:
	if (/^(?!\t*<)(?!.+(<br \/>|<\/li>)$)(?!.+<\/string>$)(?!.+<\/char>$)(?!.+<\/feature>$)(?!.+xmlns:xsi)/) {
		# Split off usage citations:
		s/; /<\/citation>\n\t\t\t\t\t\t<citation class="usage">/g;
		# Add closing tag to last citation of line:
		if (/\]$/) {
			s/(\])($)/<\/citation>$1/;
		}
		else {
			s/$/<\/citation>/;
		}

		# Split off publication citations on first "in" for works where the author of a name isn't the author of a reference:
		# s/( in )([[:upper:]])/\n\t\t\t\t\t\t<citation class="publication">$1$2/;
			
		
		# Atomize taxonomic names:
		# Notes:
		#	1) for non-complex forms of "auct.:|auct:" mark-up is also made.
		#	2) Add formats whenever a new one is needed (same applies to annotation versions of the formats).
		# Two possibilities for Taxon names at beginning of line: ^ and ^[
		
		
		# Family:
		# Family Author:
		s/(^)([[:upper:]][a-z-]+aceae)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>/;
		
		
		# Subfamily|subfam.:
		# Family subfamilyrank Subfamily Infraut:
		s/(^)([[:upper:]][a-z-]+aceae)( )(Subfamily|subfamily|Subfam\.|subfam\.)( )([[:upper:]][a-z-]+oideae)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subfamily">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		
		
		# Tribe|tribus:
		# Family triberank Tribe Infraut:
		s/(^)([[:upper:]][a-z-]+aceae)( )(Tribe|tribe|Tribus|tribus)( )([[:upper:]][a-z-]+eae)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="tribe">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		# triberank Tribe:
		s/(^)(Tribe|tribe|Tribus|tribus)( )([[:upper:]][a-z-]+eae)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="tribe">$4<\/name>/;
		# Tribe Author:
		s/(^)([[:upper:]][a-z-]+eae)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="tribe">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>/;
		
		
		# Section|Sect.|§:
		
		# Genus Author sectionrank Section (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="section">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		
		# Genus Author sectionrank Section Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="section">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		# Genus Author sectionrank Section:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="section">$8<\/name>/;
		# Genus sectionrank Section Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="section">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		# Genus sectionrank Section:
		s/(^)([[:upper:]][a-z-]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="section">$6<\/name>/;
		
		
		# Subsections:
		# Genus Author subsectionrank Subsection Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(subsect\.)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subsection">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		
		
		# Series:
		# Genus Author seriesrank Series Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(ser\.)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="series">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		
		
		
		# Subgenus:
		# Genus Author subgenusrank Subgenus Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subgenus">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		# Genus Author subgenusrank Subgenus (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )((?:[[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subgenus">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		# Genus Author subgenusrank Subgenus:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subgenus">$8<\/name>/;
		
		# Genus subgenusrank Subgenus Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subgenus">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		# Genus subgenusrank Subgenus (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subgenus">$6<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$9<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>/;
		
		
		# Genus:
		# Genus Author:
		s/(^)([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>/;
		
		# Genus (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="paraut">$5<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>/;
		
		
		# var.:
		# Genus species Author varietyrank variety Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$9<\/name>\n\t\t\t\t\t\t<name class="variety">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$13<\/name>/;
		# Genus species Author varietyrank variety (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="variety">$10<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$13<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>/;
		# Genus species (Paraut) Author varietyrank variety Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="variety">$15<\/name>\n\t\t\t\t\t\t<name class="infraut">$17<\/name>/;
		# Genus species (Paraut) Author varietyrank variety (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="variety">$15<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$18<\/name>\n\t\t\t\t\t\t<name class="infraut">$21<\/name>/;
		
				
		# Genus species Author varietyrank variety:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$9<\/name>\n\t\t\t\t\t\t<name class="variety">$11<\/name>/;
		# Genus species (Paraut) Author varietyrank variety:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="variety">$15<\/name>/;
		
		# Genus species varietyrank variety Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		# Genus species varietyrank variety (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		
		# Genus species varietyrank variety:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(variety|var\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>/;
		
		# subsp.:
		# Genus species (Paraut) Author subspeciesrank subspecies Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$12<\/name>\n\t\t\t\t\t\t<name class="subspecies">$14<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>/;
		# Genus species (Paraut) Author subspeciesrank subspecies (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$12<\/name>\n\t\t\t\t\t\t<name class="subspecies">$14<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$17<\/name>\n\t\t\t\t\t\t<name class="infraut">$20<\/name>/;
		
		# Genus species Author subspeciesrank subspecies Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="subspecies">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>/;
		# Genus species Author subspeciesrank subspecies (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )((?:[[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="subspecies">$10<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$13<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>/;
		# Genus species Author subspeciesrank subspecies:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="subspecies">$10<\/name>/;
		
		# Genus species subspeciesrank subspecies Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subspecies">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		# Genus species subspeciesrank subspecies (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subspecies">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		
		
		# forma:
		# Genus species formarank forma (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(form\.|forma)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="form">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		# Genus species formarank forma Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(form\.|forma)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="form">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		
		# Genus species (Paraut) Author formarank forma Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(form\.|forma)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$12<\/name>\n\t\t\t\t\t\t<name class="form">$14<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>/;
		
		# Genus species Author formarank forma (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(form\.|forma)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="form">$10<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$13<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>/;
		# Genus species Author formarank forma Infraut:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)( )(form\.|forma)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="form">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>/;
		
		
		# Hybrids ( x | × ):
		# Genus × species Author:
		s/(^)([[:upper:]][a-z-]+)( (?:×|x) )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="hybrid">$2$3$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>/;
		# Genus species × Genus species Author:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( (?:×|x) )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="hybrid">$2$3$4$5$6$7$8<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>/;
		# Genus species × Genus species (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( (?:×|x) )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="hybrid">$2$3$4$5$6$7$8<\/name>\n\t\t\t\t\t\t<name class="paraut">$11<\/name>\n\t\t\t\t\t\t<name class="author">$14<\/name>/;
		
		# Genus species × Genus species:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( (?:×|x) )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="hybrid">$2$3$4$5$6$7$8<\/name>/;

		# All others:
		# Genus species Author:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:|auct\. non [[:upper:]][A-Z\p{Ll}\- &\.]+(?:| p\.p\.):)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>/;
		# Genus species (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )([[:upper:]][A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>/;
			
		# Same for Annotated names:
		# Genus species Author:
		s/(^)(\[)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t$2<name class="genus">$3<\/name>\n\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t<name class="author">$7<\/name>/;
		# Genus species (Paraut) Author:
		s/(^)(\[)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )([[:upper:]][A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t$2<name class="genus">$3<\/name>\n\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t<name class="paraut">$8<\/name>\n\t\t\t\t\t\t<name class="author">$11<\/name>/;
		
		
		
		# Names of which it is known that they can only go into fullName:
		
		# Section # Name c. Name *** Name Author.:
		s/(^)([[:upper:]][a-z-]+)( # )([[:upper:]][a-z-]+)( c\. )([[:upper:]][a-z-]+)( \*\*\* )(([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<fullName rank="section">$2$3$4$5$6$7$8<\/fullName>/;
		# Section *** Name Author:
		s/(^)([[:upper:]][a-z-]+)( \*\*\* )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<fullName rank="section">$2$3$4$5$6<\/fullName>/;
		# Section # Name Author:
		s/(^)([[:upper:]][a-z-]+)( # )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<fullName rank="section">$2$3$4$5$6<\/fullName>/;

		
		# Change "auct.:" and "auct:" parts of names to proper name class, and duplicate author name of publication:
		s/(<name class=")(author)(">)(auct\.: |auct: )([[:upper:]][A-Z\p{Ll}\- &\.]+)(<\/name>)/$1status$3$4$5$6, $5/;
		s/(<name class=")(infraut)(">)(auct\.: |auct: )([[:upper:]][A-Z\p{Ll}\- &\.]+)(<\/name>)/$1status$3$4$5$6, $5/;
		
		
		# Split off remaining publication citations on first comma:
		s/(<\/(?:n|fullN)ame>)(, )/$1\n\t\t\t\t\t\t<citation class="publication">/;
		
		
		# Remove some excessive closing citation tags:
		s/(<\/name>)(<\/citation>)/$1/;
	
	}
	
	
	# Types:
	# NameTypes:
	elsif (/\t\t\t\t\t<nameType/) {
		# Atomizes based on type format:
		if (/Type species/) {
			# Type format: Type species: Genus species Author:
			s/(Type species: )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.]+)($| )/\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			# Type format: Type species: Genus species (Paraut) Author:
			s/(Type species: )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )([[:upper:]][A-Z\p{Ll}\- &\.]+)($| )/\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			
			# Type format: Type species (Author): Genus species Author:
			s/(Type species: \()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\): )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.]+)($| )/\n\t\t\t\t\t\t<citation class="type"><refPart class="author">$2<\/refPart><\/citation>\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus">$4<\/name>\n\t\t\t\t\t\t\t<name class="species">$6<\/name>\n\t\t\t\t\t\t\t<name class="author">$8<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			# Type format: Type species (Author): Genus species (paraut) Author:
			s/(Type species: \()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\): )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )([[:upper:]][A-Z\p{Ll}\- &\.]+)($| )/\n\t\t\t\t\t\t<citation class="type"><refPart class="author">$2<\/refPart><\/citation>\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus">$4<\/name>\n\t\t\t\t\t\t\t<name class="species">$6<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$9<\/name>\n\t\t\t\t\t\t\t<name class="author">$12<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			
			# Type format: Type species (Author year): Genus species Author:
			s/(Type species \()(([[:upper:]][A-Z\p{Ll}\- &\.]+)( )(\d\d\d\d))(\): )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.]+)($| )/\n\t\t\t\t\t\t<citation class="type"><refPart class="author">$3<\/refPart><refPart class="year">$5<\/refPart><\/citation>\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus">$7<\/name>\n\t\t\t\t\t\t\t<name class="species">$9<\/name>\n\t\t\t\t\t\t\t<name class="author">$11<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;			
			# Type format: Type species (Author year): Genus species (paraut) Author:
			s/(Type species \()(([[:upper:]][A-Z\p{Ll}\- &\.]+)( )(\d\d\d\d))(\): )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )([[:upper:]][A-Z\p{Ll}\- &\.]+)($| )/\n\t\t\t\t\t\t<citation class="type"><refPart class="author">$3<\/refPart><refPart class="year">$5<\/refPart><\/citation>\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus">$7<\/name>\n\t\t\t\t\t\t\t<name class="species">$9<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$12<\/name>\n\t\t\t\t\t\t\t<name class="author">$15<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
		}
		# nameType Lectotypes:
		elsif (/Lectotype species/) {
			# First markup text between brackets (if present) following "Lectotype species":
			if (/(Lectotype species \(selected here\):)/) {
				# "Selected here" and similar:
				s/(Lectotype species \()(selected here)(\): )/$1<typeNotes><string>$2<\/string><\/typeNotes>$3/;
			}
			else {
				# Type format: Lectotype species (Author year): Genus species Author:
				s/(Lectotype species \()(([[:upper:]][A-Z\p{Ll}\- &\.]+)( )(\d\d\d\d))(\): )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.]+)($| )/\n\t\t\t\t\t\t<citation class="type"><refPart class="author">$3<\/refPart><refPart class="year">$5<\/refPart><\/citation>\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus">$7<\/name>\n\t\t\t\t\t\t\t<name class="species">$9<\/name>\n\t\t\t\t\t\t\t<name class="author">$11<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;			
				# Type format: Lectotype species (Author year): Genus species (paraut) Author:
				s/(Lectotype species \()(([[:upper:]][A-Z\p{Ll}\- &\.]+)( )(\d\d\d\d))(\): )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )([[:upper:]][A-Z\p{Ll}\- &\.]+)($| )/\n\t\t\t\t\t\t<citation class="type"><refPart class="author">$3<\/refPart><refPart class="year">$5<\/refPart><\/citation>\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus">$7<\/name>\n\t\t\t\t\t\t\t<name class="species">$9<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$12<\/name>\n\t\t\t\t\t\t\t<name class="author">$15<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			}
		}
		elsif (/Type genus/) {
			
			# Type format: Type genus: Genus Author:
			s/(Type genus: )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			# Type format: Type genus: Genus (Paraut) Author:
			s/(Type genus: )([[:upper:]][a-z-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$5<\/name>\n\t\t\t\t\t\t\t<name class="author">$8<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			
			# Type format: Type genus: Genus.
			s/(Type genus: )([[:upper:]][a-z-]+)(\.)/\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
		
		}
		else {
		}
		# Marks up nameType accepted names:
		# Format: Genus species Author:
		s/(<\/nom>\n\t\t\t\t\t<\/nameType>)(= )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.]+)($)/\t$2<acceptedName>\n\t\t\t\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t\t\t\t<name class="genus">$3<\/name>\n\t\t\t\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t\t\t\t<name class="author">$7<\/name>\n\t\t\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t\t<\/acceptedName>\n\t\t\t\t\t\t$1/;
		# Format: Genus species (Paraut) Author:
		s/(<\/nom>\n\t\t\t\t\t<\/nameType>)(= )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )([[:upper:]][A-Z\p{Ll}\- &\.]+)($)/\t$2<acceptedName>\n\t\t\t\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t\t\t\t<name class="genus">$3<\/name>\n\t\t\t\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t\t\t\t<name class="paraut">$8<\/name>\n\t\t\t\t\t\t\t\t\t<name class="author">$11<\/name>\n\t\t\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t\t<\/acceptedName>\n\t\t\t\t\t\t$1/;
		
		# Format: Genus species Author (Location):
		s/(<\/nom>\n\t\t\t\t\t<\/nameType>)(= )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.]+)( )((\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\)\.))($)/\t$2<acceptedName>\n\t\t\t\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t\t\t\t<name class="genus">$3<\/name>\n\t\t\t\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t\t\t\t<name class="author">$7<\/name>\n\t\t\t\t\t\t\t\t\t<name class="notes">$9<\/name>\n\t\t\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t\t<\/acceptedName>\n\t\t\t\t\t\t$1/;
		# Format: Genus species (Paraut) Author (Location):
		s/(<\/nom>\n\t\t\t\t\t<\/nameType>)(= )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\))( )([[:upper:]][A-Z\p{Ll}\- &\.]+)( )((\()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\)\.))($)/\t$2<acceptedName>\n\t\t\t\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t\t\t\t<name class="genus">$3<\/name>\n\t\t\t\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t\t\t\t<name class="paraut">$8<\/name>\n\t\t\t\t\t\t\t\t\t<name class="author">$11<\/name>\n\t\t\t\t\t\t\t\t\t<name class="notes">$13<\/name>\n\t\t\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t\t<\/acceptedName>\n\t\t\t\t\t\t$1/;
		
	}
	# Include adding closing nameType tags somewhere around here.
	
	
	
	# SpecimenTypes:
	elsif (/\t\t\t\t\t<specimenType/) {
	
		# Note: write more/better specimentype atomizer, too many get missed.
		# Atomizes based on type format:
		# Type format: Type: Collector FieldNum, Locality (CollectionAndType).:
		if (/(Type: .+)( (\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+), )(.+)( )(\(.+\)\.)/) {
			s/(Type: )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+)(, )(.+)( )(\(.+\))(\.)($)/<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><locality class="">$6<\/locality><collectionAndType>$8<\/collectionAndType><\/gathering>$9<\/specimenType>/;
		}
		# Type format: Type: Collector FieldNum, (CollectionAndType), Locality.:
		elsif (/(Type: .+)( (\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+), )(\(.+\), )(.+\.)/) {
			s/(Type: )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+)(, )(\(.+\))(, )(.+)(\.)($)/<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><collectionAndType>$6<\/collectionAndType><locality class="">$8<\/locality><\/gathering>$9<\/specimenType>/;
		}
		# Type format: Type: Collector FieldNum (CollectionAndType).:
		elsif (/(Type: .+)( (\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+) )(\(.+\)\.)/) {
			s/(Type: )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+)( )(\(.+\))(\.)($)/<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><collectionAndType>$6<\/collectionAndType><\/gathering>$7<\/specimenType>/;
		}
		# Type format: Type: Collector FieldNum, Locality.:
		elsif (/(Type: .+)( (\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+), )(.+\.)/) {
			s/(Type: )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+)(, )(.+)(\.)($)/<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><locality class="">$6<\/locality><\/gathering>$7<\/specimenType>/;
		}
				
		# Lectotypes:
		elsif (/(Lectotype \(.+\):)/) {
			# First markup text between brackets (if present) following "Lectotype":
			if (/(Lectotype \(selected here\):)/) {
				# "Selected here" and similar:
				s/(Lectotype \()(selected here)(\): )/$1<typeNotes><string>$2<\/string><\/typeNotes>$3/;
			}
			else {
				# Citation - author only:
				s/(Lectotype \()([[:upper:]][A-Z\p{Ll}\- &\.]+)(\): )/$1<citation class="type"><refPart class="author">$2<\/refPart><\/citation>$3/;
				# Citation - author and year:
				s/(Lectotype \()(([[:upper:]][A-Z\p{Ll}\- &\.]+)( )(\d\d\d\d))(\): )/$1<citation class="type"><refPart class="author">$3<\/refPart><refPart class="year">$5<\/refPart><\/citation>$6/;
			}
			
			# Type format: Lectotype (text): Collector FieldNum, Locality (CollectionAndType).:
			s/(Lectotype)( )(\(.+\))(: )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+)(, )(.+)( )(\(.+\))(\.)($)/$1$2$3$4<gathering><collector>$5<\/collector><fieldNum>$7<\/fieldNum><locality class="">$9<\/locality><collectionAndType>$11<\/collectionAndType><\/gathering>$12<\/specimenType>/;
			# Type format: Lectotype (text): Collector FieldNum (CollectionAndType).:
			s/(Lectotype)( )(\(.+\))(: )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+)( )(\(.+\))(\.)($)/$1$2$3$4<gathering><collector>$5<\/collector><fieldNum>$7<\/fieldNum><collectionAndType>$9<\/collectionAndType><\/gathering>$10<\/specimenType>/;
		} 
		elsif {
		# Adds closing tags to divergent specimenTypes:
		s/(^)(\t\t\t\t\t<specimenType>)(.+)($)/$1$2$3<\/specimenType>$4/;
		}
		else {
		}
	}
	else {
	}
	
	
	
	print OUT $_;
}

close IN;
close OUT;