#!/usr/bin/perl
# nomatomizer.pl
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
	
	# TODO: 
	# - FIX missed statusses after page numbers.
	# - FIX issues with divergent type mark-up (gathering and other tags not inserted)
	# - Types starting with "Type specimen" or "Type-species"


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
		#	1) for non-complex forms of "auct.:|auct:" mark-up is also done.
		#	2) Add formats whenever a new one is needed (same applies to bracketed versions of the formats).
		# Two possibilities for Taxon names at beginning of line: ^ and ^[
		
		
		# IMPORTANT NOTE:
		# When working with newer volumes, some regexes with ALL CAPS parts may need to be disabled.
		
		# Division:
		# Division:
		s/(^)(PTERIDOPHYTA)/\t\t\t\t\t\t<name class="division">$2<\/name>/;
		
		
		# Order:
		# Order:
		s/(^)(CONIFERALES)/\t\t\t\t\t\t<name class="order">$2<\/name>/;
		
		
		
		
		# Family:
		# Family (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+aceae)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\) )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="paraut">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>,/;
		# Family Author:
		s/(^)([[:upper:]][a-z-]+aceae)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>,/;
		# FAMILY AUTHOR:
		s/(^)([[:upper:]][A-Z-]+ACEAE)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>,/;
		# Family:
		s/(^)([[:upper:]][A-Z-]+ACEAE|[[:upper:]][a-z]+aceae|CRUCIFERAE|LABIATAE|UMBELLIFERAE|﻿ARALIACEAE—I)/\t\t\t\t\t\t<name class="family">$2<\/name>/;
		# Doubtful:
		# Family Author:
		s/(^)([[:upper:]][a-z-]+aceae)(?: |)(\?)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="status">$3<\/name>\n\t\t\t\t\t\t<name class="author">$5<\/name>,/;
		
		
		
		
		# Subfamily|subfam.:
		# Family subfamilyrank Subfamily (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+aceae)( )(Subfamily|subfamily|Subfam\.|subfam\.)( )([[:upper:]][a-z-]+oideae)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\) )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subfamily">$6<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Family subfamilyrank Subfamily Infraut:
		s/(^)([[:upper:]][a-z-]+aceae)( )(Subfamily|subfamily|Subfam\.|subfam\.)( )([[:upper:]][a-z-]+oideae)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subfamily">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		
		
		# subfamilyrank Subfamily (Infrparaut) Infraut:
		s/(^)(SUBFAMILY|Subfamily|subfamily|Subfam\.|subfam\.)( )([[:upper:]][a-z-]+oideae)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\) )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subfamily">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# subfamilyrank Subfamily Infraut:
		s/(^)(SUBFAMILY|Subfamily|subfamily|Subfam\.|subfam\.)( )([[:upper:]][a-z-]+oideae)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subfamily">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		
		# subfamilyrank Subfamily:
		s/(^)(SUBFAMILY|Subfamily|subfamily|Subfam\.|subfam\.)( )([[:upper:]][a-z-]+oideae|[[:upper:]][[:upper:]]+OIDEAE)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subfamily">$4<\/name>/;
		
		# SUBFAMILY INFRAUT:
		s/(^)(GONYSTYLOIDEAE)( )([[:upper:]]+)/\t\t\t\t\t\t<name class="subfamily">$2<\/name>\n\t\t\t\t\t\t<name class="infraut">$4<\/name>,/;
		# Subfamily:
		s/(^)(Ajugoideae|Prasioideae|Scutellarioideae|Stachyoideae|Ocimoideae)/\t\t\t\t\t\t<name class="subfamily">$2<\/name>/;
		
		
		
		# Tribe|tribus:
		# Family triberank Tribe (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+aceae)( )(Tribe|tribe|Tribus|tribus)( )([[:upper:]][a-z-]+eae)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\) )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="tribe">$6<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Family triberank Tribe Infraut:
		s/(^)([[:upper:]][a-z-]+aceae)( )(Tribe|tribe|Tribus|tribus)( )([[:upper:]][a-z-]+eae)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="tribe">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# triberank Tribe INFRAUT:
		s/(^)(Tribe|tribe|Tribus|tribus)( )([[:upper:]][a-z-]+eae)( )(B\. & H\.|LAW YUH-WU|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?:(?: |)ƒ\.|))/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="tribe">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# triberank Tribe Infraut:
		s/(^)(Tribe|tribe|Tribus|tribus)( )([[:upper:]][a-z-]+eae)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="tribe">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# triberank Tribe:
		s/(^)(Tribe|tribe|Tribus|tribus)( )([[:upper:]][a-z-]+eae)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="tribe">$4<\/name>/;
		s/(^)(TRIB(?:E|US))( )([[:upper:]][A-Z-]+EAE)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="tribe">$4<\/name>/;
		# Tribe AUTHOR:
		s/(^)([[:upper:]][a-z-]+eae)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?:(?: |)ƒ\.|))/\t\t\t\t\t\t<name class="tribe">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>,/;
		# Tribe Author:
		s/(^)([[:upper:]][a-z-]+eae)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="tribe">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>,/;
		
		
		# Subtribe|Subtribus:
		
		# Family subtriberank Tribe Infraut:
		s/(^)([[:upper:]][a-z-]+aceae)( )(Subtribe|subtribe|Subtribus|subtribus)( )([[:upper:]][a-z-]+eae)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subtribe">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# subtriberank Tribe INFRAUT:
		s/(^)((?:S|s)ubtrib(?:e|us))( )([[:upper:]][a-z-]+eae)( )(B\. & H\.|LAW YUH-WU|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subtribe">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		
		
		
		# Section|Sect.|§:
		
		# Genus Author sectionrank Section (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="section">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>,/;
		
		# Genus AUTHOR sectionrank Section INFRAUT:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="section">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Genus Author sectionrank Section Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="section">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		
		# Genus Author sectionrank Section:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="section">$8<\/name>/;
		# Genus sectionrank Section (INFRPARAUT) INFRAUT:
		s/(^)([[:upper:]][a-z-]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( \()(Bl\.|[[:upper:]][[:upper:]\-&\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?:f\.|))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="section">$6<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Genus sectionrank Section (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="section">$6<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Genus sectionrank Section INFRAUT:
		s/(^)([[:upper:]][a-z-]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )(B\. & H\.|C\. Chr\.|DE LAUB\.|F\.v\.M\.|H\. Ito|H\. J\. LAM|R\. BR\.|(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]+(?:\.|) \& (?:(?:[[:upper:]]\.)+ |)[[:upper:]]+(?:\.|)(?:f\.|)|(?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?:(?: |)f\.|))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="section">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# Genus sectionrank Section Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )(Eu-Sticherus|[[:upper:]][a-z-]+)( )(v\.A\.v\.R\.|(?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="section">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# Genus sectionrank Section:
		s/(^)([[:upper:]][a-z-]+)( )(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="section">$6<\/name>/;
		
		
		
		# sectionrank Section (INFRPARAUT) INFRAUT:
		s/(^)(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( \()(Bl\.|[[:upper:]][[:upper:]\- &\.']+)(\) )(B\. & H\.|DE LAUB\.|MEIJER DREES|(?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="section">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# sectionrank Section (Infrparaut) Infraut:
		s/(^)(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="section">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# sectionrank Section INFRAUT:
		s/(^)(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )(C\. B\. CLARKE|DE LAUB\.|DING HOU|MEIJER DREES|(?:[[:upper:]](?:\. [[:upper:]]|[[:upper:]\.]+ & |)|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="section">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# sectionrank Section Infraut:
		s/(^)(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="section">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# sectionrank Section:
		s/(^)(Section|section|Sect\.|sect\.|§|Sectio|sectio)( )([[:upper:]][a-z-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="section">$4<\/name>/;
		
		# Specific sections:
		# Section (Infrparaut) Infraut:
		s/(^)(Barringtonieae)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="section">$2<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		
		
		
		# Subsections:
		# Genus Author subsectionrank Subsection (INFRPARAUT) INFRAUT:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)( )((?:S|s)ubsect(?:\.|ion))( )([[:upper:]][a-z-]+)( \()(Bl\.|[[:upper:]][[:upper:]\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subsection">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>,/;
		# Genus Author subsectionrank Subsection INFRAUT:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)( )((?:S|s)ubsect(?:\.|ion))( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subsection">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Genus Author subsectionrank Subsection (Paraut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(subsect\.)( )([[:upper:]][a-z-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subsection">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>,/;
		# Genus Author subsectionrank Subsection Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(subsect\.)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subsection">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		
		
		# subsectionrank Subsection (INFRPARAUT) INFRAUT:
		s/(^)((?:S|s)ubsect(?:\.|ion))( )([[:upper:]][a-z-]+)( \()(Bl\.|[[:upper:]][[:upper:]\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subsection">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# subsectionrank Subsection (Infrparaut) Infraut:
		s/(^)((?:S|s)ubsect(?:\.|ion))( )([[:upper:]][a-z-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subsection">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# subsectionrank Subsection INFRAUT:
		s/(^)((?:S|s)ubsect(?:\.|ion))( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subsection">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# subsectionrank Subsection:
		s/(^)((?:S|s)ubsect(?:\.|ion))( )([[:upper:]][a-z-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subsection">$4<\/name>,/;
		
		
		
		# Series:
		# Genus Author seriesrank Series Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(ser\.)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="series">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Genus Author seriesrank Series (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(ser\.)( )([[:upper:]][a-z-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="series">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>,/;
		# Genus seriesrank Series Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(ser\.)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="series">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# Genus seriesrank Series (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(ser\.)( )([[:upper:]][a-z-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="series">$6<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		
		
		
		# Seriesrank Series (INFRPARAUT) INFRAUT:
		s/(^)((?:S|s)er(?:ies|\.))( )([[:upper:]][a-z-]+)( \()(Bl\.|[[:upper:]][[:upper:]\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="series">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# Seriesrank Series INFRAUT:
		s/(^)(Ser(?:ies|\.))( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="series">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# Seriesrank Series Infraut:
		s/(^)(Ser(?:ies|\.))( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="series">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		
		
		# Subseries:
		# Genus Author subseriesrank Series Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(subser\.)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subseries">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Genus subseriesrank Series Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(subser\.)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subseries">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# subseriesrank Series (INFRPARAUT) INFRAUT:
		s/(^)((?:S|s)ubser(?:ies|\.))( )([[:upper:]][a-z-]+)( \()(Bl\.|[[:upper:]][[:upper:]\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subseries">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# subseriesrank Series INFRAUT:
		s/(^)((?:S|s)ubser(?:ies|\.))( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subseries">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		
		
		# Group:
		s/(^)(LINDSAEA-GROUP)/\t\t\t\t\t\t<name class="group">$2<\/name>/;
		
		
		
		# Subgenus:
		# Genus Author subgenusrank Subgenus Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subgenus">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Genus Author subgenusrank Subgenus (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )((?:[[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subgenus">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>,/;
		# Genus Author subgenusrank Subgenus:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subgenus">$8<\/name>/;
		
		# Genus subgenusrank Subgenus INFRAUT:
		s/(^)([[:upper:]][a-z-]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )(K\. Iwats\.|L\. C\. RICH\.(?: ex PERS\.|)|W\. & A\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subgenus">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# Genus subgenusrank Subgenus Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subgenus">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# Genus subgenusrank Subgenus (INFRPARAUT) INFRAUT:
		s/(^)([[:upper:]][a-z-]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )(\()([[:upper:]][[:upper:]\-&\.']+(?:, non [[:upper:]][[:upper:]\-&\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subgenus">$6<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$9<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>,/;
		# Genus subgenusrank Subgenus (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subgenus">$6<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$9<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>,/;
		
		# subgenusrank Subgenus (INFRPARAUT) INFRAUT:
		s/(^)(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( \()([[:upper:]][[:upper:]\-&\.']+(?:, non [[:upper:]][[:upper:]\-&\.']+|))(\) )(DE LAUB\.|F\.v\.M\.|(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]+(?:\.|) \& (?:(?:[[:upper:]]\.)+ |)[[:upper:]]+(?:\.|)|(?:[[:upper:]]\. |)[[:upper:]l\.]+(?:,|) (?:em\.|ex) (?:Bl\.|(?:(?:[[:upper:]]\.)+ |)[[:upper:]\.]+)|((?:(?:[[:upper:]]\.)+ |)[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subgenus">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# subgenusrank Subgenus (Infrparaut) Infraut:
		s/(^)(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\) )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subgenus">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# subgenusrank Subgenus INFRAUT:
		s/(^)(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )(DE LAUB\.|F\.v\.M\.|(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]+(?:\.|) \& (?:(?:[[:upper:]]\.)+ |)[[:upper:]]+(?:\.|)|(?:[[:upper:]]\. |)[[:upper:]l\.]+(?:,|) (?:em\.|ex) (?:Bl\.|(?:(?:[[:upper:]]\.)+ |)[[:upper:]\.]+)|((?:(?:[[:upper:]]\.)+ |)[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): |Cf\. )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subgenus">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# subgenusrank Subgenus Infraut:
		s/(^)(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subgenus">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# subgenusrank Subgenus:
		s/(^)(Subgenus|subgenus|Subg\.|subg\.)( )([[:upper:]][a-z-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subgenus">$4<\/name>/;
		#
		
		# Genus:
		# Genus AUTHOR:
		s/(^)([[:upper:]][a-z-]+)( )(Bl\.(?: ex Miq\.|)|D\. Don|DE LAUB\.|DE VRIESE|F\.v\.M\.|F\. M\. Bailey|G\. Don Ex Hook\.|H\. J\. LAM|HOOK f\. & TH\.|J\. (?:E\. |)Sm(?:\.|ith)|R\.(?: |)Br\.|L\. C\. RICH\.|S\. H\. WRIGHT|S\. T\. BLAKE|VALCK\. SUR\.|VAN STEENIS|VAN TIEGH\.|W\. & A\.|(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]+(?:\.|)(?:f\.|) \& (?:(?:[[:upper:]]\.)+ |)[[:upper:]]+(?:\.|)|(?:[[:upper:]]\. |)[[:upper:]l\.]+(?:,|) (?:em\.|ex) (?:Bl\.|(?:(?:[[:upper:]]\.)+ |)[[:upper:]\.]+)|((?:(?:[[:upper:]]\.)+ |)[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?:(?: |)f\.|))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>,/;
		# Genus Author:
		s/(^)([[:upper:]][a-z-]+)( )(v\.A\.v\.R\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>,/;
		# GENUS AUTHOR:
		s/(^)([[:upper:]][[:upper:]-]+)( )(A\. C\. SMITH|Bl\.(?: ex Miq\.|)|DE LAUB\.|DING HOU|F\.v\.M\.|H\. J\. LAM|HOOK\.f\. & TH\.|J\. E\. S(?:MITH|mith)|J\. F\. MILL\.|J\. Sm\.|L\. C\. R(?:ich|ICH)(?:\.|ard)|P\. Browne|R\.(?: |)Br(?:\.|own)|VAN ROYEN|VAN STEENIS|W\. R\. Philipson|(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]+(?:\.|) \& (?:(?:[[:upper:]]\.)+ |)[[:upper:]]+(?:\.|)|(?:(?:[[:upper:]]\.)+ |)[[:upper:]\.]+(?:,|) (?:em\.|ex) [[:upper:]\.-]+(?:f\.|)|((?:[[:upper:]]\.(?: |)|)[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\p{Ll}\- &\.']+\) |)[[:upper:]][[:upper:]\p{Ll}\- &\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?:(?: |)f\.|))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>,/;
		# GENUS Author:
		s/(^)([[:upper:]][[:upper:]-]+)( )(l'Herit\.|Mich ex Linne|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>,/;
		
		
		# Genus (PARAUT) AUTHOR:
		s/(^)([[:upper:]][a-z-]+)( )(\()((?:non |)[[:upper:]][[:upper:]\-&\.']+(?:, non [[:upper:]][[:upper:]\-&\.']+|))(\))( )(DE LAUB\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="paraut">$5<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>,/;
		# Genus (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+)( )(\()((?:non |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="paraut">$5<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>,/;
		# GENUS (Paraut) Author:
		s/(^)([[:upper:]][[:upper:]-]+)( )(\()((?:non |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="paraut">$5<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>,/;
		# GENUS (PARAUT) AUTHOR:
		s/(^)([[:upper:]][[:upper:]-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\-&\.']+(?:, non [[:upper:]][[:upper:]\p{Ll}\-&\.']+|))(\))( )(DE LAUB\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\p{Ll}\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\p{Ll}\-&\.']+\) |)[[:upper:]][[:upper:]\p{Ll}\-&\.']+(?:| p\.p\.): )[[:upper:]\p{Ll}\-&\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="paraut">$5<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>,/;
		
		# Doubtful:
		# ? Genus Author:
		s/(^)(\?)( |)([[:upper:]][a-z-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="status">$2<\/name>\n\t\t\t\t\t\t<name class="genus">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>,/;
		
		
		# Same for annotated names:
		# [Genus AUTHOR:
		s/(^)(\[)([[:upper:]][a-z-]+)( )((?:[[:upper:]]\. |)[[:upper:]\.]+(?:,|) (?:em\.|ex) (?:Bl\.|(?:[[:upper:]]\. |)[[:upper:]\.]+)|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t$2<name class="genus">$3<\/name>\n\t\t\t\t\t\t<name class="author">$5<\/name>,/;
		
		
		# var.:
		# Genus species AUTHOR varietyrank variety INFRAUT:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(Bl\.|((?:(?:[[:upper:]]\. |)[[:upper:]\.]+(?:,|) (?:em\.|ex) |)[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)( )(variety|var\.)( )([[:lower:]\-]+)( )((?:(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]+(?:\.|) \& (?:(?:[[:upper:]]\.)+ |)(?:DE VRIESE|[[:upper:]]+)(?:\.|)|[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?:f\.|))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$9<\/name>\n\t\t\t\t\t\t<name class="variety">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$13<\/name>,/;
		# Genus species Author varietyrank variety Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(v\.A\.v\.R\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(v\.A\.v\.R\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$9<\/name>\n\t\t\t\t\t\t<name class="variety">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$13<\/name>,/;
		
		
		# Genus species AUTHOR varietyrank variety (INFRPARAUT) INFRAUT:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(L\.|(?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)( )(variety|var\.)( )([[:lower:]\-]+)( \()(Bl\.|L\.|(?:non |)[[:upper:]][[:upper:]\-&\.']+(?:, non [[:upper:]][[:upper:]\-&\.']+|))(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?:F\.|f\.|)(?: & [[:upper:]\-\.]+|))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="variety">$10<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$12<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>,/;
		# Genus species Author varietyrank variety (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(v\.A\.v\.R\.|(?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="variety">$10<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$13<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>,/;
		
		# Genus species (Paraut) Author varietyrank variety Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(v\.A\.v\.R\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="variety">$15<\/name>\n\t\t\t\t\t\t<name class="infraut">$17<\/name>,/;
		# Genus species (PARAUT) AUTHOR varietyrank variety (INFRAPARAUT) INFRAUT:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\-&\.']+(?:, non [[:upper:]][[:upper:]\-&\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\-&\.']+(?:, non [[:upper:]][[:upper:]\-&\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="variety">$15<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$18<\/name>\n\t\t\t\t\t\t<name class="infraut">$21<\/name>,/;
		# Genus species (Paraut) Author varietyrank variety (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(v\.A\.v\.R\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="variety">$15<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$18<\/name>\n\t\t\t\t\t\t<name class="infraut">$21<\/name>,/;
		
		# Doubtful:
		# Genus species Author varietyrank ? variety Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )(\?)( |)([[:lower:]\-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$9<\/name>\n\t\t\t\t\t\t<name class="status">$11<\/name>\n\t\t\t\t\t\t<name class="variety">$13<\/name>\n\t\t\t\t\t\t<name class="infraut">$15<\/name>,/;
		
		
		# Genus species Author varietyrank variety:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$9<\/name>\n\t\t\t\t\t\t<name class="variety">$11<\/name>/;
		# Genus species (Paraut) Author varietyrank variety:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(variety|var\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="variety">$15<\/name>/;
		
		# Genus species varietyrank variety INFRAUT:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(AIRY SHAW|C\. Chr\.|DE LAUB\.|F\.v\.M\.|H\. Ito|H\. J\. LAM|VALCK\. SUR\.|(?:(?:[[:upper:]]\. |)[[:upper:]\.]+(?:,|) (?:em\.|ex) |(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?: & [[:upper:]\-\.]+|)(?:(?: |)ƒ\.|))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Genus species varietyrank variety Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(v\.A\.v\.R\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Genus species varietyrank variety (INFRPARAUT) INFRAUT:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\-&\.']+(?:, non [[:upper:]][[:upper:]\-&\.']+|))(\))( )(((?:[[:upper:]\.]+(?: |)|)[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>,/;
		# Genus species varietyrank variety (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(variety|var\.)( )([[:lower:]\-]+)( )(\()((?:non |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(v\.A\.v\.R\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>,/;
		
		
		
		# Genus species varietyrank variety:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(variety|var\.)( )([[:lower:]\-]+)(?![A-Za-z\. ]+?subvar\.)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>/;
		
		# varietyrank variety INFRAUT:
		s/(^)(var\.)( )([[:lower:]\-]+)((?::|) )(C\. Chr\.|DE LAUB\.|DE WILDE|DING HOU|H\. J\. LAM|((?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]](?:[[:upper:]\.]+ & |)|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?: f\.|))/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="variety">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# varietyrank variety Infraut:
		s/(^)(var\.)( )([[:lower:]\-]+)( )(v\.A\.v\.R\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="variety">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# varietyrank variety (INFRPARAUT) INFRAUT:
		s/(^)(var\.)( )([[:lower:]\-]+)( \()(Bl\.|F\.v\.M\.|K\. & G\.|[[:upper:]][[:upper:]\-&\.']+(?:F\.|f\.|)(?:, non [[:upper:]][[:upper:]\-&\.']+|))(\) )(C\. Chr\.|DE LAUB\.|H\. J\. LAM|((?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]](?:[[:upper:]\.]+ & |)|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?:(?: |)f\.|))/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="variety">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# varietyrank variety (Infrparaut) Infraut:
		s/(^)(var\.)( )([[:lower:]\-]+)( )(\()(v\.A\.v\.R\.|[[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="variety">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$7<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		
		# varietyrank variety:
		s/(^)(var\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="variety">$4<\/name>/;
		
		
		# subvariety:
		
		# subvarietyrank subvariety Infraut:
		s/(^)(subvar\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subvariety">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# subvarietyrank subvariety (Infrparaut) Infraut:
		s/(^)(subvar\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subvariety">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$7<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		
		# subvarietyrank subvariety:
		s/(^)(subvar\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subvariety">$4<\/name>/;
		
		
		# subsp.:
		# Genus species (Paraut) Author subspeciesrank subspecies Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$12<\/name>\n\t\t\t\t\t\t<name class="subspecies">$14<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>,/;
		# Genus species (Paraut) Author subspeciesrank subspecies (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$12<\/name>\n\t\t\t\t\t\t<name class="subspecies">$14<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$17<\/name>\n\t\t\t\t\t\t<name class="infraut">$20<\/name>,/;
		
		# Genus species Author subspeciesrank subspecies Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)(?![A-Za-z\. ]+?var\.)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="subspecies">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>,/;
		# Genus species AUTHOR subspeciesrank subspecies (INFRPARAUT) INFRAUT:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\-&\.']+(?:, non [[:upper:]][[:upper:]\-&\.']+|))(\))((?::|) )((?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]+(?:\.|) \& (?:(?:[[:upper:]]\.)+ |)[[:upper:]]+(?:\.|)|(?:(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]|auct\.:|auct:)[[:upper:]\-&\.]+)(?![A-Za-z\. ]+?var\.)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="subspecies">$10<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$13<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>,/;
		
		# Genus species Author subspeciesrank subspecies (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )((?:[[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)(?![A-Za-z\. ]+?var\.)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="subspecies">$10<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$13<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>,/;
		# Genus species Author subspeciesrank subspecies:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)(?![A-Za-z\. ]+?var\.)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="subspecies">$10<\/name>/;
		
		# Genus species subspeciesrank subspecies INFRAUT:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )(K\. Iwats\.|((?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?: ex [[:upper:]\.]+|))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subspecies">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Genus species subspeciesrank subspecies Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subspecies">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		# Genus species subspeciesrank subspecies (INFRPARAUT) INFRAUT:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( \()(non (?:Bl\.|Sw\.|[[:upper:]\.-]+(?:\.|)(?:(?: |)f\.|))|[[:upper:]][[:upper:]\-&\.']+(?:, non [[:upper:]][[:upper:]\-&\.']+|))(\) )((?:(?:[[:upper:]]\. |)[[:upper:]\.]+(?:,|) (?:em\.|ex) |[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?: & [[:upper:]\-\.]+(?: (?:em\.|ex) [[:upper:]\-&\.]+(?: & (?:DE LAUB\.|[[:upper:]\-\.]+))|)|))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subspecies">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>,/;
		# Genus species subspeciesrank subspecies (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(subspecies|subsp\.|ssp\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subspecies">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>,/;
		
		
		# subspeciesrank subspecies INFRAUT:
		s/(^)(subsp\.|ssp\.|spp\.)( )([[:lower:]\-]+)( )(COSTE & REYN\.|H\. Ohba|VAN DE WATER|((?:[[:upper:]\.]+(?: |)|)[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subspecies">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# subspeciesrank subspecies Infraut:
		s/(^)(subsp\.|ssp\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subspecies">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# subspeciesrank subspecies (INFRPARAUT) INFRAUT:
		s/(^)(subsp\.|ssp\.|spp\.)( )([[:lower:]\-]+)( \()(F\.v\.M\.|(?:non |)[[:upper:]]+\.(?:(?: |)f\.|) \& [[:upper:]\.]+|[[:upper:]][[:upper:]\-&\.']+(?:, non [[:upper:]][[:upper:]\-&\.']+|))(\) )(DING HOU|VAN DE WATER|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subspecies">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# subspeciesrank subspecies (Infrparaut) Infraut:
		s/(^)(subsp\.|ssp\.)( )([[:lower:]\-]+)( \()(v\.A\.v\.R\.|[[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\) )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subspecies">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		
		# subspeciesrank subspecies:
		s/(^)(subsp\.|ssp\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subspecies">$4<\/name>/;
		
		
		# forma:
		# Genus species formarank forma (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(form\.|forma|f\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="form">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>,/;
		# Genus species formarank forma Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(form\.|forma|f\.)( )([[:lower:]\-]+)( )(v\.A\.v\.R\.|(?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="form">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>,/;
		
		# Genus species (Paraut) Author formarank forma Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(form\.|forma)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$12<\/name>\n\t\t\t\t\t\t<name class="form">$14<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>,/;
		
		# Genus species (Paraut) Author formarank forma (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(form\.|forma|f\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$6<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>\n\t\t\t\t\t\t<name class="infrank">$10<\/name>\n\t\t\t\t\t\t<name class="form">$12<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$15<\/name>\n\t\t\t\t\t\t<name class="infraut">$18<\/name>,/;
		# Genus species (Paraut) Author formarank forma Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(form\.|forma|f\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$6<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>\n\t\t\t\t\t\t<name class="infrank">$10<\/name>\n\t\t\t\t\t\t<name class="form">$12<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>,/;
		# Genus species Author formarank forma (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(form\.|forma|f\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="form">$10<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$13<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>,/;
		# Genus species AUTHOR formarank forma INFRAUT:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)( )(form\.|forma|f\.)( )([[:lower:]\-]+)( )(H\. J\. LAM|(?:(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]+(?:\.|) \& (?:(?:[[:upper:]]\.)+ |)(?:DE VR(?:IESE|\.)|[[:upper:]]+)(?:\.|)|[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+(?:(?: |)f\.|))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="form">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>,/;
		# Genus species Author formarank forma Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(form\.|forma|f\.)( )([[:lower:]\-]+)( )(v\.A\.v\.R\.|(?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="form">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>,/;
		# Genus species Author formarank forma:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)( )(f\.|form\.|forma)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="form">$10<\/name>,/;
		
		
		# formarank forma (Infrparaut) Infraut:
		s/(^)(form\.|forma|f\.)( )([[:lower:]\-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="form">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# formarank forma Infraut:
		s/(^)(form\.|forma|f\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="form">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# formarank forma:
		s/(^)(form\.|forma)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="form">$4<\/name>/;
		
		
		# nothomorphs:
		
		# nothomorphrank nothomorph (Infrparaut) Infraut:
		s/(^)(nm\.)( )([[:lower:]\-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="nothomorph">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>,/;
		# nothomorphrank nothomorph Infraut:
		s/(^)(nm\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="nothomorph">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>,/;
		# nothomorphrank nothomorph:
		s/(^)(nm\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="nothomorph">$4<\/name>/;
		
		
		
		
		
		# Hybrids ( x | × ):
		# Genus species Author × Genus species Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+(?:f\.|))( (?:×|x) )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="hybrid">$2$3$4$5$6$7$8$9$10$11$12<\/name>,/;
		
		# Genus × species Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( (?:×|x) )([[:lower:]\-]+)( )(v\.A\.v\.R\.|([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="hybrid">$2$3$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>,/;
		# Genus × species (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( (?:×|x) )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="hybrid">$2$3$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>,/;
		# Genus species × Genus species Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( (?:×|x) )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="hybrid">$2$3$4$5$6$7$8<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>,/;
		# Genus species × Genus species (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( (?:×|x) )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="hybrid">$2$3$4$5$6$7$8<\/name>\n\t\t\t\t\t\t<name class="paraut">$11<\/name>\n\t\t\t\t\t\t<name class="author">$14<\/name>,/;
		
		# Genus species × Genus species:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( (?:×|x) )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="hybrid">$2$3$4$5$6$7$8<\/name>/;

		
		
		# All others: 
		# Genus species AUTHOR:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.|Ch\.|Fl\.|Gl\.|Ph\.|Pl\.|St\.|Sch\.|Tr\.)( )([[:lower:]\-]+|sp\.)( )(A\. Cunn\.|C\. A\. Mey\. ex Krecz\.|AIRY SHAW|BINN\. ex K\. & V\.|C\. Chr\.(?: ex Holtt\.| ex Ogata| & Tardieu-Blot| & Tard\.|)|C\.(?: |)T\. White|C\. Moore|(?:A\.|)DC\.|Bl\.(?: (?:em\.|ex) (?:M(?:IQ|iq)\.|Boerl\.|Hook\. & Baker|LECOMTE)|)|C\. B\. Clarke|C\.E\.C\. Fischer|D\. Don|DE LAUB\.|DE VRIESE|DING HOU|E\. Marchal|F\.v\.M\.(?: (?:em\.|ex) (?:BENTH\.|KURZ)| & F\.M\. BAILEY|)|F\. M\. Bailey|F\.-Vill\.|H\. Pfeiff\.|HORN AF RANTZIEN|I\. H\. Burkill|J\.A\. & J\.H\. SCHULTES|J\. (?:E\. |)Sm(?:\.|ith)(?: ex Fee| ex Hook\.|)|K\. Sch\.|K\. & V\.|L\. H\. Bailey|L\.f\.|MEIJER DREES|M\. R\. Henderson|R\.(?: |)Bonap\.|R\.(?: |)Br\.(?:ex Mett\.|)|S\. T\. Blake|S\. & Z\.|(?:H\. |)S(?:T|t)(?:\.|) J(?:OHN|ohn)|T\. & B\.|v\.A\.v\.R\.|v\. Royen|VAN ROYEN|(?:v|V)\. D\. LINDEN|VALCK\. SUR\.|VAN DE WATER|VAN TIEGH\.|VON SEEMEN|W\. & A\.|W\. Ait\.|W\. R\. Philipson|WALL\. ex Hook\.|WHITE & FRANCIS ex LANE POOLE|Z\. & M\.(?: (?:em\.|ex) ZOLL\.|)|(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]+(?:\.|) \& (?:(?:[[:upper:]]\.)+ |)(?:DE VR(?:IESE|\.)|[[:upper:]]+)(?:\.|)|(?:(?:[[:upper:]]\. |)[[:upper:]\.]+(?:(?:F|f)\.|)(?:,|) (?:em\.|ex) |(?:(?:[[:upper:]]\.)+ |)[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\- &\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): |auct\. non |sensu )(?:(?:A\.|)DC\.|Ashton|Bl(?:\.|ume)|C\. Chr\.|Copeland|DE LAUB\.|DE VR(?:IESE|\.)|DING HOU|F\.v\.M\.|Holtt\.|MEIJER DREES|R\.(?: |)Br\.|Rac\.|J\. Sm\.|J\.A\. & J\.H\. SCHULTES|R\. & S\.|T\. & B\.|v\.A\.v\.R\.|VAN DE WATER|(?:[[:upper:]]\. |[[:upper:]])[[:upper:]\-&\.]+(?:(?: |)(?:Ƒ|f).|)(?: & [[:upper:]\-\.]+(?: (?:em\.|ex) [[:upper:]\.]+|)|))(?:: [[:upper:]\.]+|)(?:(?: |)ƒ\.|(?: |)f\.|))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>,/;
		
		# Genus species Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.|Ch\.|Fl\.|Gl\.|Ph\.|Pl\.|St\.|Sch\.|Tr\.)( )([[:lower:]\-]+)( )(de Vriese|v\.A\.v\.R\.|van Royen|(?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): |auct\. non |sensu )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>,/;
		
		# Genus species (PARAUT) AUTHOR:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.|Ch\.|Fl\.|Gl\.|Ph\.|Pl\.|St\.|Sch\.|Tr\.)( )([[:lower:]\-]+|sp\.)( \()((?:A\.|)DC\.|AIRY SHAW|Bl\.|DE LAUB\.|DE VRIESE|F\.v\.M\.|K\. & V\.|(?:non |)L\.|MEIJER DREES|S\. & Z\.|Sw\.|T\. & B\.|v\.A\.v\.R\.|(?:v|V)\. D\. LINDEN|VAN DE WATER|VAN ROYEN|WALL\. (?:em\.|ex) G\. DON|non (?:(?:A\.|)DC\.|Bl\.|DE LAUB\.|F\.v\.M\.|H\. & B\.|K\. & V\.|L\.|MEIJER DREES|S\. & Z\.|Sw\.|WALL\. (?:em\.|ex) G\. DON|(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]\.-]+(?:\.|)(?:(?: |)f\.|))(?:(?:,|) nec [[:upper:]\.-]+(?:\.|)(?:(?: |)f\.|)|)+(?: \d\d\d\d|)|(?:non |)[[:upper:]]+\.(?:(?: |)f\.|) \& [[:upper:]]+\.|(?:non |)(?:[[:upper:]]\. |)[[:upper:]\.]+(?:,|) (?:em\.|ex) [[:upper:]\.]+|(?:(?:[[:upper:]]\.)+ |)[[:upper:]][[:upper:]\-&\.']+(?:(?: |)f\.|)(?:, (?:in|non) [[:upper:]][[:upper:]\-&\.']+(?:(?: |)f\.|)|))(\)(?::|) )(A\. C\. SMITH|AIRY SHAW|C\. A\. MEY\.|C\. Chr\.|(?:A\.|)DC\.|A\. Gray ex Kunth|Bl\.(?: ex Moore|)|D\. Dietr\.|DE LAUB\.|DE VRIESE|DE WILDE|DING HOU|F\.v\.M\.|F\.-Vill\.|F\. M\. BAILEY|H\. J\. LAM|J\. F\. GMEL\.|J\. G\. SMITH|J\. Sm\.(?: ex Hook\.|)|J\. (?:E\. |)Sm(?:\.|ith)|J\. J\. SMITH|K\. Iwat(?:s|)\.|K\. & V\.|L\.|MEIJER DREES|O\. K(?:\.|tze)|P\. G\. WILSON|R\.(?: |)Br\.(?: ex Link| ex R\. & S\.|)|K\. SCH\. & LAUT\.|S\. T\. BLAKE|Sw\.|S\. Y\. Hu|S\. & Z\.|T\. & B\.|T\. Moore|v\.A\.v\.R\.|(?:v|V)\. D\. LINDEN|VAN DE WATER|VAN ROYEN|(?:[[:upper:]\.]+|)[[:upper:]]+(?:\.|)(?:(?: |)(?:f|Ƒ)\.|) \& (?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]+(?:\.|)|(?:(?:[[:upper:]]\. |)[[:upper:]\.]+(?:,|) (?:em\.|ex) [[:upper:]\.]+|(?:auct\.: |)(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]][[:upper:]\-&\.']+(?:(?: |)(?:Ƒ|f).|)))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$6<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>,/;
		# Genus species (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.|Ch\.|Fl\.|Gl\.|Ph\.|Pl\.|St\.|Sch\.|Tr\.)( )([[:lower:]\-]+)( )(\()(v\.A\.v\.R\.|(?:non |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(v\.A\.v\.R\.|[[:upper:]][A-Z\p{Ll}\- &\.']+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>,/;
		 
		
		
		# Genus species:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)(<\/citation>|$)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>/;
		
		# Doubtful names:
		# ? Genus species AUTHOR:
		s/(^)(\?)( |)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:(?:(?:[[:upper:]]\.)+(?: |)|)[[:upper:]]+(?:\.|) \& (?:(?:[[:upper:]]\.)+ |)(?:DE VRIESE|[[:upper:]]+)(?:\.|)|[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="status">$2<\/name>\n\t\t\t\t\t\t<name class="genus">$4<\/name>\n\t\t\t\t\t\t<name class="species">$6<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>,/;
		# ? Genus species Author:
		s/(^)(\?)( |)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="status">$2<\/name>\n\t\t\t\t\t\t<name class="genus">$4<\/name>\n\t\t\t\t\t\t<name class="species">$6<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>,/;
		# Genus ? species AUTHOR:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( |)(\?)( |)([[:lower:]\-]+)( )(Bl\.|(?:[[:upper:]]\. |)[[:upper:]\.]+(?:,|) (?:em\.|ex) [[:upper:]\.]+|(?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][[:upper:]\-&\.']+|)(?:\)|)|vix) (?:\([[:upper:]][[:upper:]\-&\.']+\) |)[[:upper:]][[:upper:]\-&\.']+(?:| p\.p\.): )[[:upper:]\-&\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="status">$4<\/name>\n\t\t\t\t\t\t<name class="species">$6<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>,/;
		# Genus ? species Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )(\?)( |)([[:lower:]\-]+)( )((?:[[:upper:]]|auct(?:\.|): |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="status">$4<\/name>\n\t\t\t\t\t\t<name class="species">$6<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>,/;
		
		# Same for Annotated names:
		# Genus species AUTHOR:
		s/(^)(\[)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\-&\.]+)/\t\t\t\t\t\t$2<name class="genus">$3<\/name>\n\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t<name class="author">$7<\/name>,/;
		
		# Genus species Author:
		s/(^)(\[)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t$2<name class="genus">$3<\/name>\n\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t<name class="author">$7<\/name>,/;
		# Genus species (Paraut) Author:
		s/(^)(\[)([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )([[:upper:]][A-Z\p{Ll}\- &\.']+)/\t\t\t\t\t\t$2<name class="genus">$3<\/name>\n\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t<name class="paraut">$8<\/name>\n\t\t\t\t\t\t<name class="author">$11<\/name>,/;
		
		
		
		# Genus spec: Author, Genus spec., Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )((?:prob\. |)(?:nov\. |)sp(?:ec|)(?:\.|)(?: nov\.|))((?:,|:|) )((?:[[:upper:]]|auct\.: |auct: |auct\. (?:(?:\(|)non(?:\.|)(?: [[:upper:]][A-Z\p{Ll}\- &\.']+|)(?:\)|)|vix) (?:\([[:upper:]][A-Z\p{Ll}\- &\.']+\) |)[[:upper:]][A-Z\p{Ll}\- &\.']+(?:| p\.p\.): )[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>,/;
		# Genus spec: Author & Genus spec.:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]\.)( )(sp(?:ec|)(?:\.|)(?![[:lower:]]))/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>,/;
		
		
		# Rest:
		# Adds very basic mark-up to most remaining names (allowing later splitting off of publication):
		s/(^)([[:upper:]][[:upper:][:lower:]\d,\(\)\.\?\[\]'& -]+(?:A\.C\. SMITH|ADANSON|BACK\. & BAKH\.F\.|BAILEY|Benth\.|BENTH\.|BLANCO|Blume|BLUME|BURK\.|BURM\.f\.|CHODAT|CLARKE|COCKBURN|CRAIB|DC|DECNE|(?:D\. |)Don|Duhamel|EPLING|F\.-VILL\.|FORMAN|Fourn\.|G\.DON|GAMBLE|Guédès|GIBBS|Hartley et al\.|Hassk\.|HASSK\.|HATUS\.|HEMSL\.|Hook\. & Arn\.|JACK|KLOTZSCH|KOORD\.|Kosterm\.|KUDO|LAM & HOLTHUIS|LAUT\.|Leenh\.(?: & Vente|)|LINNE|MERR\.|W\. MEIJER|MIERS|MILLER|Miq\.|MIQ\.|(?:S\. |)MOORE|PERSOON|PILGER|PLANCH\.|RAVEN|RIDL(?:\.|EY)|ROYEN|ROYLE|Rumph\.|RUMPH\.|SPAN\.|STEEN\.|SWAMY|THUNB\.|v\. Malm|Verde(?:\.|)|VIDAL|W\. & A\.|WARB\.|YAMAMOTO|))(, .+)(<\/citation>|$)/\t\t\t\t\t\t<name class="">$2<\/name>$3$4/;
		# Same for annotated names:
		s/(^)(\[)([[:upper:]][[:upper:][:lower:]\d,\(\)\.\?\[\]'& -]+(?:A\.C\. SMITH|ADANSON|BACK\. & BAKH\.F\.|BAILEY|Benth\.|BENTH\.|BLANCO|Blume|BLUME|BURK\.|BURM\.f\.|CHODAT|CLARKE|COCKBURN|CRAIB|DC|DECNE|(?:D\. |)Don|Duhamel|EPLING|F\.-VILL\.|FORMAN|Fourn\.|G\.DON|GAMBLE|Guédès|GIBBS|Hartley et al\.|Hassk\.|HASSK\.|HATUS\.|HEMSL\.|Hook\. & Arn\.|JACK|KLOTZSCH|KOORD\.|Kosterm\.|KUDO|LAM & HOLTHUIS|LAUT\.|Leenh\.(?: & Vente|)|LINNE|MERR\.|W\. MEIJER|MIERS|MILLER|Miq\.|MIQ\.|(?:S\. |)MOORE|PERSOON|PILGER|PLANCH\.|RAVEN|RIDL(?:\.|EY)|ROYEN|ROYLE|Rumph\.|RUMPH\.|SPAN\.|STEEN\.|SWAMY|THUNB\.|v\. Malm|Verde(?:\.|)|VIDAL|W\. & A\.|WARB\.|YAMAMOTO))(, .+)(<\/citation>|$)/\t\t\t\t\t\t$2<name class="">$3<\/name>$4$5/;
		# The above seems to skip things it shouldn't skip, debug later...
		# NOTE: Add support for names with "non" in them...

		
		# Genus abbreviation species:
		s/(^)([[:upper:]]\.)( )(angusta|dentata|latifolia|moorei|pleniflora|recisa|sagittata|sinensis|smilacina)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>/;
		
		
		
		
		# Changes "genus" to "genus abbreviation" in names using genus abbreviations:
		s/(<name class=")(genus)(">[[:upper:]]\.<\/name>)/$1genus abbreviation$3/;
		
		
		# Names of which it is known that they can only go into fullName:
		
		# Section # Name c. Name *** Name Author.:
		s/(^)([[:upper:]][a-z-]+)( # )([[:upper:]][a-z-]+)( c\. )([[:upper:]][a-z-]+)( \*\*\* )(([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<fullName rank="section">$2$3$4$5$6$7$8<\/fullName>,/;
		# Section *** Name Author:
		s/(^)([[:upper:]][a-z-]+)( \*\*\* )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<fullName rank="section">$2$3$4$5$6<\/fullName>,/;
		# Section # Name Author:
		s/(^)([[:upper:]][a-z-]+)( # )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\t\t\t\t\t\t<fullName rank="section">$2$3$4$5$6<\/fullName>,/;
		# Genus subgenusrank Subgenus sectionrank Section Author:
		s/(^)([[:upper:]][a-z]+ subg\. [[:upper:]][a-z]+ (?:sect\.|§) (?:[[:upper:]][a-z]+|\d) (?:v\.A\.v\.R\.|([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+))/\t\t\t\t\t\t<fullName rank="section">$2<\/fullName>,/;
		# Genus species varietyrank variety subvarietyrank subvariety Author:
		s/(^)([[:upper:]][a-z]+ [[:lower:]]+ var\. [[:lower:]]+ subvar\. [[:lower:]]+ (?:v\.A\.v\.R\.|([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+))/\t\t\t\t\t\t<fullName rank="subvariety">$2<\/fullName>,/;
		

		
		
		# Fixes wrongly split names/publications in earlier FM vols.:
		#s/(name class="author">(?:Bl\.|GRIFF\.|Warb\. ex Boerl\.|Bth\. in B\. & H\.))( [[:upper:]][[:lower:]][[:upper:][:lower:]\. ]+(?: |)| (?:I|l)\.(?:c|e)\.(?: |)| MUS\.[[:upper:][:lower:]\. -]+(?: |))(<\/name>(?:,|))/$1$3,$2/;
		# Somewhat buggy...
		
		
		# Change "auct.:" and "auct:" parts of names to proper name class, and duplicate author name of publication:
		# s/(<name class=")(author)(">)(auct\.: |auct: )([[:upper:]][A-Z\p{Ll}\- &\.']+)(<\/name>)/$1status$3$4$5$6, $5/;
		# s/(<name class=")(infraut)(">)(auct\.: |auct: )([[:upper:]][A-Z\p{Ll}\- &\.']+)(<\/name>)/$1status$3$4$5$6, $5/;
		
		
		# Moves publication editor names (and sometimes following publication name) out of atomised taxonomic names:
		s/(<(?:n|fullN)ame (?:class="(?:author|infraut)"|rank="[a-z]+")>.+?)( )(in .+?)(<\/(?:n|fullN)ame>,(?: |))/$1$4$3/;
		# Adds comma after publication editor names:
		s/(<\/(?:n|fullN)ame>,)((?: |)in (?:B\. & H\.|Back\.|E\. & P\.|Hochr\.|Hook\.(?:f\.|)|K\. Sch\. & Laut\.|Lestib\.|Mats\.|Merr\.|Mor\.))/$1$2,/;
		
		
		
		# Removes double comma/space that may prevent splitting off publication:
		s/(,)((?: |),)/$1/;
		s/(<\/(?:n|fullN)ame>, )( )/$1/;
		
		# Split off remaining publication citations on first comma:
		s/(<\/(?:n|fullN)ame>)(,(?: |))/$1\n\t\t\t\t\t\t<citation class="publication">/;
		
		
		
		# Remove some excessive closing citation tags:
		s/(<\/name>)((?:\.|,|)<\/citation>)/$1/;
	
		# Fixes name statusses recognised as publications:
		s/(<citation class="publication">)(nom\. (?:cons\.|event\.|nud\.)|(?:comb\.|nom\.|sect\.|(?:s|)sp\.|stat\.|var\.|f\.) nov(?:a|)\.|nov\. (?:comb\.|s(?:s|p|)p(?:ec|)\.|stat\.|var\.)|incl\. .+?|in (?:sched\.|syn\.)|non Hance\.)(<\/citation>)/<name class="status">$2<\/name>/;
		# <citation class="publication">comb. nov.</citation>
		
		# Remove empty publication tags:
		s/(\n\t\t\t\t\t\t<citation class="publication"><\/citation>)//;
		
		
		# Removal of other multiple commas:
		# s/, , /, /;
		
	}
	
	
	# Types:
	# NameTypes:
	elsif (/\t\t\t\t\t<nameType/) {
		# Atomizes based on type format:
		# if (/Type species/) {
			# Type format: Type species: Genus species Author:
			s/(Type(?:(?: |-)species|): )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.']+)($| )/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			# Type format: Type species: Genus species (Paraut) Author:
			s/(Type(?:(?: |-)species|): )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )([[:upper:]][A-Z\p{Ll}\- &\.']+)($| )/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			
			# Type format: Type species (Author): Genus species Author:
			s/(Type(?:(?: |-)species|): \([[:upper:]][A-Z\p{Ll}\- &\.']+\): )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.']+)($| )/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			# Type format: Type species (Author): Genus species (paraut) Author:
			s/(Type(?:(?: |-)species|): \([[:upper:]][A-Z\p{Ll}\- &\.']+\): )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )([[:upper:]][A-Z\p{Ll}\- &\.']+)($| )/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$6<\/name>\n\t\t\t\t\t\t\t<name class="author">$8<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			
			# Type format: Type species (Author year): Genus species Author:
			s/(Type(?:(?: |-)species|) \([[:upper:]][A-Z\p{Ll}\- &\.']+ \d\d\d\d\): )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.']+)($| )/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			# Type format: Type species (Author year): Genus species (paraut) Author:
			s/(Type(?:(?: |-)species|) \([[:upper:]][A-Z\p{Ll}\- &\.']+ \d\d\d\d\): )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )([[:upper:]][A-Z\p{Ll}\- &\.']+)($| )/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$6<\/name>\n\t\t\t\t\t\t\t<name class="author">$8<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
		# }
		# nameType Lectotypes:
		if (/Lectotype species/) {
			# First markup text between brackets (if present) following "Lectotype species":
			if (/(Lectotype species \(selected here\):)/) {
				# "Selected here" and similar:
				s/(Lectotype species \()(selected here)(\): )/$1<typeNotes><string>$2<\/string><\/typeNotes>$3/;
			}
			else {
				# Type format: Lectotype species (Author year): Genus species Author:
				s/(Lectotype species \([[:upper:]][A-Z\p{Ll}\- &\.']+ \d\d\d\d\): )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.']+)($| )/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;			
				# Type format: Lectotype species (Author year): Genus species (paraut) Author:
				s/(Lectotype species \([[:upper:]][A-Z\p{Ll}\- &\.']+ \d\d\d\d\): )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\) )([[:upper:]][A-Z\p{Ll}\- &\.']+)($| )/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$6<\/name>\n\t\t\t\t\t\t\t<name class="author">$8<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			}
		}
		elsif (/Type genus/) {
			
			# Type format: Type genus: Genus Author:
			s/(Type genus: )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			# Type format: Type genus: Genus (Paraut) Author:
			s/(Type genus: )([[:upper:]][a-z-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )(([[:upper:]]|auct\.:|auct:)[A-Z\p{Ll}\- &\.]+)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$5<\/name>\n\t\t\t\t\t\t\t<name class="author">$8<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			
			# Type format: Type genus: Genus.
			s/(Type genus: )([[:upper:]][a-z-]+)(\.)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
		
		}
		else {
		}
		
		# Marks up nameType accepted names (basionyms):
		# Format: Genus species Author:
		s/(<\/nom>\n\t\t\t\t\t<\/nameType>)((?:\[|\(|)= )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.']+(?:\]\.|\)\.|))($)/<nom class="basionym">$2\n\t\t\t\t\t\t\t<name class="genus">$3<\/name>\n\t\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t\t<name class="author">$7<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t$1/;
		# Format: Genus species (Paraut) Author:
		s/(<\/nom>\n\t\t\t\t\t<\/nameType>)((?:\[|)= )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )([[:upper:]][A-Z\p{Ll}\- &\.']+(?:\]\.|))($)/<nom class="basionym">$2\n\t\t\t\t\t\t\t<name class="genus">$3<\/name>\n\t\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$8<\/name>\n\t\t\t\t\t\t\t<name class="author">$11<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t$1/;
		
		# Format: Genus species Author (Location):
		s/(<\/nom>\n\t\t\t\t\t<\/nameType>)((?:\[|)= )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )([[:upper:]][A-Z\p{Ll}\- &\.']+)( )((\()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\)\.)(?:\]\.|))($)/<nom class="basionym">$2\n\t\t\t\t\t\t\t\t\t<name class="genus">$3<\/name>\n\t\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t\t<name class="author">$7<\/name>\n\t\t\t\t\t\t\t<name class="notes">$9<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t$1/;
		# Format: Genus species (Paraut) Author (Location):
		s/(<\/nom>\n\t\t\t\t\t<\/nameType>)((?:\[|)= )([[:upper:]][a-z-]+|[[:upper:]]\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][A-Z\p{Ll}\- &\.']+(?:, non [[:upper:]][A-Z\p{Ll}\- &\.']+|))(\))( )([[:upper:]][A-Z\p{Ll}\- &\.']+)( )((\()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\)\.)(?:\]\.|))($)/<nom class="basionym">$2\n\t\t\t\t\t\t\t<name class="genus">$3<\/name>\n\t\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$8<\/name>\n\t\t\t\t\t\t\t<name class="author">$11<\/name>\n\t\t\t\t\t\t\t<name class="notes">$13<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t$1/;
		
		# Changes "genus" to "genus abbreviation" in names using genus abbreviations:
		s/(<name class=")(genus)(">[[:upper:]]\.<\/name>)/$1genus abbreviation$3/;
		# Moves closing square bracket to correct place:
		s/(\]\.|\)\.)(<\/name>)/$2$1/;
		
		
		
		
	}
	
	
	
	
	# SpecimenTypes:
	elsif (/\t\t\t\t\t<specimenType/) {
	
		# Note: write more/better specimentype atomizer, too many get missed.
		# Atomizes based on type format:
		# Type format: Type: Collector FieldNum, Locality (CollectionAndType).:
		if (/((?:Synt|T)yp(?:e|us)(?: specimen|)(?:\.|:) .+)( (\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+|\d+[[:lower:]]), )(.+)( )(\(.+\)\.)/) {
			s/((?:Synt|T)yp(?:e|us)(?: specimen|)(?:\.|:) )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+|\d+[[:lower:]])(, )(.+)( )(\(.+\))(\.)($)/<gathering>$1<collector>$2<\/collector><fieldNum>$4<\/fieldNum><locality class="">$6<\/locality><collectionAndType>$8<\/collectionAndType><\/gathering>$9<\/specimenType>/;
		}
		# Type format: Type: Collector FieldNum, (CollectionAndType), Locality.:
		elsif (/((?:Synt|T)yp(?:e|us)(?: specimen|)(?:\.|:) .+)( (\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+|\d+[[:lower:]])(?:,|) )(\(.+\), )(.+\.)/) {
			s/((?:Synt|T)yp(?:e|us)(?: specimen|)(?:\.|:) )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+|\d+[[:lower:]])((?:,|) )(\(.+\))(, )(.+)(\.)($)/<gathering>$1<collector>$2<\/collector><fieldNum>$4<\/fieldNum><collectionAndType>$6<\/collectionAndType><locality class="">$8<\/locality><\/gathering>$9<\/specimenType>/;
		}
		# Type format: Type: Collector FieldNum (CollectionAndType).:
		elsif (/((?:Synt|T)yp(?:e|us)(?: specimen|)(?:\.|:) .+)( (\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+|\d+[[:lower:]]) )(\(.+\)\.)/) {
			s/((?:Synt|T)yp(?:e|us)(?: specimen|)(?:\.|:) )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+|\d+[[:lower:]])( )(\(.+\))(\.)($)/<gathering>$1<collector>$2<\/collector><fieldNum>$4<\/fieldNum><collectionAndType>$6<\/collectionAndType><\/gathering>$7<\/specimenType>/;
		}
		# Type format: Type: Collector FieldNum, Locality.:
		elsif (/((?:Synt|T)yp(?:e|us)(?: specimen|)(?:\.|:) .+)( (\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+|\d+[[:lower:]]), )(.+\.)/) {
			s/((?:Synt|T)yp(?:e|us)(?: specimen|)(?:\.|:) )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+|\d+[[:lower:]])(, )(.+)(\.)($)/<gathering>$1<collector>$2<\/collector><fieldNum>$4<\/fieldNum><locality class="">$6<\/locality><\/gathering>$7<\/specimenType>/;
		}
		# Type format: Type: Collector FieldNum.:
		elsif (/((?:Synt|T)yp(?:e|us)(?: specimen|)(?:\.|:) .+)( (\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+|\d+[[:lower:]]))/) {
			s/((?:Synt|T)yp(?:e|us)(?: specimen|)(?:\.|:) )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+|\d+[[:lower:]])(.+)/<gathering>$1<collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5<\/specimenType>/;
		}
				
		# Lecto/Neo/Syntypes:
		elsif (/((?:Lecto|Neo|Syn)type \(.+\):)/) {
			# First markup text between brackets (if present) following "Lectotype":
			if (/(Lectotype \(selected here\):)/) {
				# "Selected here" and similar:
				s/(Lectotype \()(selected here)(\): )/$1<typeNotes><string>$2<\/string><\/typeNotes>$3/;
			}
			else {
				# Citation - author only:
				s/(Lectotype \()([[:upper:]][A-Z\p{Ll}\- &\.']+)(\): )/$1<citation class="type"><refPart class="author">$2<\/refPart><\/citation>$3/;
				# Citation - author and year:
				s/(Lectotype \()(([[:upper:]][A-Z\p{Ll}\- &\.']+)( )(\d\d\d\d))(\): )/$1<citation class="type"><refPart class="author">$3<\/refPart><refPart class="year">$5<\/refPart><\/citation>$6/;
			}
			
			# Type format: Lectotype (text): Collector FieldNum, Locality (CollectionAndType).:
			s/((?:Lecto|Neo|Syn)type)( )(\(.+\))(: )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+)(, )(.+)( )(\(.+\))(\.)($)/$1$2$3$4<gathering><collector>$5<\/collector><fieldNum>$7<\/fieldNum><locality class="">$9<\/locality><collectionAndType>$11<\/collectionAndType><\/gathering>$12<\/specimenType>/;
			# Type format: Lectotype (text): Collector FieldNum (CollectionAndType).:
			s/((?:Lecto|Neo|Syn)type)( )(\(.+\))(: )(.+)( )(\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+)( )(\(.+\))(\.)($)/$1$2$3$4<gathering><collector>$5<\/collector><fieldNum>$7<\/fieldNum><collectionAndType>$9<\/collectionAndType><\/gathering>$10<\/specimenType>/;
		} 
		elsif (/(\t\t\t\t\t<specimenType>)/) {
		# Adds closing tags and base atomisation tags to divergent specimenTypes:
		s/(^)(\t\t\t\t\t<specimenType>)(.+)($)/$1$2<gathering><collector><\/collector><fieldNum><\/fieldNum><locality class=""><\/locality><collectionAndType><\/collectionAndType><\/gathering>$3<\/specimenType>$4/;
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