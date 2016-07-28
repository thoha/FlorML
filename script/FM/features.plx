#!/usr/bin/perl
# features.plx
# Adds mark-up to features.

# Changing script as follows should make it possible to not duplicate list of localities:
# 1) First do basic distribution feature mark up
# 2) then do location mark-up based on basic distribution markup being present.

use warnings;
use strict;
use switch;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# For each string:
	for ($_) {
		# Features starting with ALL CAPS HEADINGS:
		
		# Marks up headings only:
		s/(^)((?:|VEGETATIVE )ANATOMY)($)/$1\t\t\t<feature class="anatomy">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(SEED ANATOMY)($)/$1\t\t\t<feature class="seed anatomy">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(FLOWER ANATOMY)($)/$1\t\t\t<feature class="flower anatomy">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(CHEMOTAXONOMY)($)/$1\t\t\t<feature class="chemotaxonomy">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(CONSERVATION)($)/$1\t\t\t<feature class="conservation">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(CYTOLOGY|CYTOTAXONOMY|CHROMOSOME NUMBERS|CHROMOSOMES)($)/$1\t\t\t<feature class="cytology">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(ECOLOGY)($)/$1\t\t\t<feature class="ecology">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(DISTRIBUTION)($)/$1\t\t\t<feature class="distribution">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)((?:|SEED )DISPERSAL)($)/$1\t\t\t<feature class="dispersal">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(EMBRYOLOGY)($)/$1\t\t\t<feature class="embryology">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(FIELD CHARACTERS)($)/$1\t\t\t<feature class="field characters">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(FRUITS AND SEEDS)($)/$1\t\t\t<feature class="fruits and seeds">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(AGE AND FOSSIL RECORDS|FOSSILS)($)/$1\t\t\t<feature class="fossils">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(GERMINATION(?:| AND SEEDLING))($)/$1\t\t\t<feature class="germination">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(HABITAT)($)/$1\t\t\t<feature class="habitat">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(HABITAT AND ECOLOGY|HABITAT & ECOLOGY)($)/$1\t\t\t<feature class="habitatecology">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(INFLORESCENCES(?:| AND FLOWERS))($)/$1\t\t\t<feature class="inflorescences">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(INTRODUCED SPECIES)($)/$1\t\t\t<feature class="introducedspecies">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(LEAF ANATOMY)($)/$1\t\t\t<feature class="leaf anatomy">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(LEAF MORPHOLOGY)($)/$1\t\t\t<feature class="leaf morphology">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(REPRODUCTIVE BIOLOGY)($)/$1\t\t\t<feature class="lifehistory">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(MORPHOLOGY|MORPHOLOGICAL VARIATION)($)/$1\t\t\t<feature class="morphology">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(NOTE|NOTE ON SPELLING|INDUMENTUM, COLOUR OF PLANT ON DRYING)($)/$1\t\t\t<feature class="" isNotes="true">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(VEGETATIVE MORPHOLOGY)($)/$1\t\t\t<feature class="vegetative morphology">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(REPRODUCTIVE MORPHOLOGY)($)/$1\t\t\t<feature class="reproductive morphology">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(PHYTOCHEMISTRY)($)/$1\t\t\t<feature class="phytochemistry">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(PHYTOCHEMISTRY AND CHEMOTAXONOMY)($)/$1\t\t\t<feature class="phytochemo">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(POLLEN MORPHOLOGY|PALYNOLOGY)($)/$1\t\t\t<feature class="palynology">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(PHYLOGENY|SYSTEMATICS)($)/$1\t\t\t<feature class="phylogeny">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(POLLINATION|POLLINATORS|POLLINATION AND DISPERSAL)($)/$1\t\t\t<feature class="pollination">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(PROBRACTS)($)/$1\t\t\t<feature class="probracts">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(SCOPE)($)/$1\t\t\t<feature class="scope">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(SEEDLING MORPHOLOGY)($)/$1\t\t\t<feature class="seedling morphology">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(SEXUAL CONDITION)($)/$1\t\t\t<feature class="sexual condition">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(|RELATIONSHIPS|SUBDIVISION AND DELIMITATION|DELIMITATION AND SUBDIVISION(?:| OF THE FAMILY)|TAXONOMY|CLASSIFICATION)($)/$1\t\t\t<feature class="taxonomy">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(TENDRILS)($)/$1\t\t\t<feature class="tendrils">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(USES)($)/$1\t\t\t<feature class="uses">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(VERNACULAR NAMES)($)/$1\t\t\t<feature class="vernacular">\n\t\t\t\t<heading>$2<\/heading>/;
		s/(^)(WOOD ANATOMY)($)/$1\t\t\t<feature class="wood">\n\t\t\t\t<heading>$2<\/heading>/;
		
		# Marks up distribution feature starting with heading (ALL CAPS):
		
		
			# If-Constructions below are used to force mark-up of exceptions (=parts of territories) before marking up the whole territory without getting double tags. This has one inconvenience, being that if a distribution both features part of a territory and the whole territory, only one of them will be marked up. Yet it should take care of most mark-up and minimize manual mark-up of  distributionLocalities.
			# Rules for adding new localities:
			# 1) Put them in the right list, in alphabetical order of the whole territory.
			# 2) Whenever part of territories are in need of mark-up, use the if-else construction. Doing otherwise causes a mess (unless I can find a way to do it without having the stupid drawbacks listed earlier)
			# 3) Non-overlapping alternatives don't need the if-else construction, but can use the |.
			# 4) Make sure the multiple copies of the territory-lists are all the same!
	
	
	
		# Features starting with Subheadings:
		
		# Marks up distribution feature starting with subheading:
		if (/Distribution — /) {
			s/(^)(Distribution)( — )(.+)(\.|<br \/>)($)/$1\t\t\t<feature class=\"distribution\">\n\t\t\t\t<string><subHeading>$2<\/subHeading> $4$5<\/string>\n\t\t\t<\/feature>/;
			
			# If-Constructions below are used to force mark-up of exceptions (=parts of territories) before marking up the whole territory without getting double tags. This has one inconvenience, being that if a distribution both features part of a territory and the whole territory, only one of them will be marked up. Yet it should take care of most mark-up and minimize manual mark-up of  distributionLocalities.
			# Rules for adding new localities:
			# 1) Put them in the right list, in alphabetical order of the whole territory.
			# 2) Whenever part of territories are in need of mark-up, use the if-else construction. Doing otherwise causes a mess (unless I can find a way to do it without having the stupid drawbacks listed earlier).
			# 3) Non-overlapping alternatives don't need the if-else construction, but can use the |.
			# 4) Make sure the multiple copies of the territory-lists are all the same!
			
			# Marks up distributionLocalities:
			
			# Global:
			s/( )((Southern |Northern )(Hemisphere|hemisphere))/$1<distributionLocality class=\"world\">$2<\/distributionLocality>/g;
			
			s/( )(pantropical|neotropical)/$1<distributionLocality class=\"world\">$2<\/distributionLocality>/g;
			
			s/( )(Pantropics|pantropics|Neotropics|neotropics)/$1<distributionLocality class=\"world\">$2<\/distributionLocality>/g;
			s/( )(Pantropic|pantropic|Neotropic|neotropic)/$1<distributionLocality class=\"world\">$2<\/distributionLocality>/g;
			
			s/( )((?:Old|New) World)/$1<distributionLocality class=\"world\">$2<\/distributionLocality>/g;
			
			
			# Continents:
			# (Parts of) Africa:
			if (/S Africa|N Africa|NE Africa|continental Africa/) {
				s/( )(S Africa|N Africa|NE Africa|continental Africa)/$1<distributionLocality class=\"continental region\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(Africa)/$1<distributionLocality class=\"continent\">$2<\/distributionLocality>/g;
			}			
			# (Parts of) America:
			if (/tropical America|S America|South America|N America|North America|Central America/) {
				s/( )(tropical America|S America|South America|N America|North America|Central America)/$1<distributionLocality class=\"continental region\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(America)/$1<distributionLocality class=\"continent\">$2<\/distributionLocality>/g;
			}
			# (Parts of) Asia:
			if (/Southeast Asia|SE Asia|NE Asia|E Asia|East Asia|tropical Asia|subtropical Asia/) {
				s/( )(Southeast Asia|SE Asia|NE Asia|E Asia|East Asia|tropical Asia|subtropical Asia)/$1<distributionLocality class=\"continental region\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(Asia)/$1<distributionLocality class=\"continent\">$2<\/distributionLocality>/g;
			}
			# (Parts of) Australia:
			if (/SE Australia|NE Australia/) {
				s/( )(SE Australia|NE Australia)/$1<distributionLocality class=\"continental region\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(Australia)/$1<distributionLocality class=\"continent\">$2<\/distributionLocality>/g;
			}
			s/( )(Australasia)/$1<distributionLocality class=\"continental region\">$2<\/distributionLocality>/g;
			
			
			# Countries:
			s/( )(Afghanistan)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Bangladesh)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Bengal)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Bhutan)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Brunei)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			if (/N Burma|Southern Burma/) {
				s/( )(N Burma|Southern Burma)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(Burma)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			s/( )(Cambodia)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			if (/SW China|SE China|S China|South China/) {
				s/( )(SW China|SE China|S China|South China)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(China)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			s/( )(Colombia)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			if (/western Ecuador/) {
				s/( )(western Ecuador)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(Ecuador)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			s/( )(Ethiopia)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Fiji)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			if (/NE India|S India|South India/) {
				s/( )(NE India|S India|South India)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(India)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			if (/S Japan/) {
				s/( )(S Japan)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(Japan)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			s/( )(Korea)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Madagascar)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			if (/W Malaysia|Peninsular Malaysia/) {
				s/( )(W Malaysia|Peninsular Malaysia)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(Malaysia)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			s/( )(Mauritius)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Mexico)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Myanmar)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(New Hebrides)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Panama)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			if (/northern Amazonian Peru/) {
				s/( )(northern Amazonian Peru)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(Peru)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			s/( )(Philippines)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Samoa)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Singapore)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Solomons|Solomon Islands|Solomon Is\.)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Sri Lanka)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			if (/N Thailand|North Thailand|Peninsular Thailand|S Thailand/) {
				s/( )(N Thailand|North Thailand|Peninsular Thailand|S Thailand)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(Thailand)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			s/( )(Vanuatu)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			if (/northern Venezuela/) {
				s/( )(northern Venezuela)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(Venezuela)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			if (/N Vietnam|S Vietnam/) {
				s/( )(N Vietnam|S Vietnam)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/( )(Vietnam)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			}
			s/( )(West Indies)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			s/( )(Yemen)/$1<distributionLocality class=\"country\">$2<\/distributionLocality>/g;
			
			
			# Regions:
			s/(\(| )(Alor)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Admiralty Is\.|Admiralty Island(?:|s))/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Ambon)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Andaman Is\.|Andaman Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Arnhem Land)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Aru Is\.|Aru Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Assam)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Atjeh)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Babar)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Bali)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Balabac)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Banda)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Banka)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Banks Is\.|Banks Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Basilan)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Batanta Is\.|Batanta Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Batjan)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Batudaka Is\.|Batudaka Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Bawean)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Biak Is\.|Biak Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Billiton)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Bismarck Arch\.|Bismarck Archipelago)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Bohol)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Bonin Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/NE Borneo|N Borneo/) {
				s/(\(| )(NE Borneo|N Borneo)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Borneo)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			if (/Mt\. Bougainville/) {
				s/(\(| )(Mt\. Bougainville)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Bougainville)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Bukit Timah)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Buru)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Buton Is\.|Buton Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Cagayan Sulu)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Cameron Highlands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Carolines|Caroline Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/NE Celebes|N Celebes|S Celebes|SE Celebes|SW Celebes|Central Celebes/) {
				s/(\(| )(NE Celebes|N Celebes|S Celebes|SE Celebes|SW Celebes|Central Celebes)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Celebes)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			if (/SE Ceram/) {
				s/(\(| )(SE Ceram)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Ceram)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Christmas Is\.|Christmas Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Efate)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Enggano)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Flores)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Guadalcanal)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Guam)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Halmahera)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Himalayas|Himalaya region)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Hong Kong)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Indochina)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/NW Irian Jaya/) {
				s/(\(| )(NW Irian Jaya)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Irian Jaya)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Japen Is\.)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/W Java|East Java|E Java/) {
				s/(\(| )(W Java|East Java|E Java)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Java)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Kai Is\.|Kai Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/Central Kalimantan|E Kalimantan|SE Kalimantan|W Kalimantan/) {
				s/(\(| )(Central Kalimantan|E Kalimantan|SE Kalimantan|W Kalimantan)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Kalimantan)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Kangean Is\.|Kangean Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Kedah)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Kelantan)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Key Is\.|Key Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Kolombangara)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Langkawi Is\.)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Leyte)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Lombok)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Lord How Is\.|Lord How Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Louisiade Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/southern Luzon|Southern Luzon|S Luzon|North Luzon|Northern Luzon/) {
				s/(\(| )(southern Luzon|Southern Luzon|S Luzon|North Luzon|Northern Luzon)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Luzon)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Madura)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/W Malay Peninsula/) {
				s/(\(| )(W Malay Peninsula)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Malay Peninsula)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Malaya)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/Eastern Malesia|western Malesia|Western Malesia|W Malesia/) {
				s/(\(| )(Eastern Malesia|western Malesia|Western Malesia|W Malesia)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Malesia)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Manado)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Manokwari)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Manus Is\.|Manus Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Marianas|Marianas Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Medan)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(the Mediterranean)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Melanesia)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Mentawi Is\.|Mentawi Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Mirconesia)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Minahassa)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/eastern Mindanao/) {
				s/(\(| )(eastern Mindanao)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Mindanao)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Mindoro)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Moluccas)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Morotai)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Natuna Is\.|Natuna Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Negros)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(New Britain)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(New Caledonia)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/Papua New Guinea|Northern Papua New Guinea|Western New Guinea|W New Guinea|Eastern New Guinea|E New Guinea|NE New Guinea|SE New Guinea/) {
				s/(\(| )(Papua New Guinea|Northern Papua New Guinea|Western New Guinea|W New Guinea|Eastern New Guinea|E New Guinea|NE New Guinea|SE New Guinea)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(New Guinea)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(New Ireland)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(New South Wales)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Nicobar Is\.|Nicobar Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Norfolk Is\.|Norfolk Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/Obi Is\.|Obi Island/) {
				s/(\(| )(Obi Is\.|Obi Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Obi)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Pacific area)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Padang Highlands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Pahang)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Palawan)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Panay)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Panching)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Penang)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Perak)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Perlis)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Polynesia)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Pulau Tioman)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/NE Queensland|N Queensland/) {
				s/(\(| )(NE Queensland|N Queensland)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Queensland)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Rapa)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Riouw Archipelago|Riouw-Lingga Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Roma)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Rota)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Rotuma Is\.)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Ryukyu Is\.|Ryukyu Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Sabah)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Saipan)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Salawati)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Samar)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Samoa)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Santa Cruz Is\.)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Sarawak)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Schouten Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Selangor)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/W Sepik/) {
				s/(\(| )(W Sepik)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Sepik)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Sibolangit)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Sibuyan)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Sikkim)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/Simalur Island/) {
				s/(\(| )(Simalur Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Simalur)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Sino-Himalayan region)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Sudest Is\.)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/SE Sulawesi/) {
				s/(\(| )(SE Sulawesi)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Sulawesi)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Sula Is\.|Sula Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Sulu Arch\.|Sulu Archipelago|Sulu Is\.|Sulu Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/N Sumatra|S Sumatra/) {
				s/(\(| )(N Sumatra|S Sumatra)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Sumatra)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			if (/Sumbawa/) {
				s/(\(| )(Sumbawa)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Sumba)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Lesser Sunda Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Surigao)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Tahiti)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			if (/Sumbawa/) {
				s/(\(| )(Talaud Is\.|Talaud Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			else {
				s/(\(| )(Talaud)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			}
			s/(\(| )(Taiwan)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Tanimbar Is\.|Tanimbar Islands)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Ternate)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Timor)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Tonga)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Tonkin)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Waigeo Is\.|Waigeo Island)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Wetar)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Woodlark Is\.)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			s/(\(| )(Yapen)/$1<distributionLocality class=\"region\">$2<\/distributionLocality>/g;
			
			
			# States:
			s/(\(| )(Hawaii)/$1<distributionLocality class=\"state\">$2<\/distributionLocality>/g;
			
			
			# Provinces:
			s/(\(| )(Cebu|Camiguin de Mindanao|Yunnan|Kwangtung|Zambales Province|Hainan|Morobe Prov\.|Morobe Province|Milne Bay Prov\.)/$1<distributionLocality class=\"province\">$2<\/distributionLocality>/g;
			
			
			# Districts:
			s/(\(| )(Miri Dist\.|Sorong Dist\.)/$1<distributionLocality class=\"district\">$2<\/distributionLocality>/g;
			
			
			# Localities:
			s/(\(| )(Chittagong|Darwin|Sylhet|G\. Sago|Mt Kinabalu|Idenburg River|San Cristobal|Malaita|Khasia Hills|Korinchi Peak|G\. Mulu National Park|Mt Sago|Mt Dempo|Mt Raja)/$1<distributionLocality class=\"locality\">$2<\/distributionLocality>/g;
			
			# Others:
			
			
			
			
		}
		elsif (/Distribution\./) {
			s/(^)(Distribution\. )(.+)(\.)($)/$1\t\t\t<feature class=\"distribution\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
			
			# Copy code for distribution Localities here:
			
		}
		elsif (/Distr\./) {
			s/(^)(Distr\. )(.+)(\.)($)/$1\t\t\t<feature class=\"distribution\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
			
			# Copy code for distribution Localities here:
			
		}
		
		# Marks up habitat features:
		elsif (/Habitat — /) {
			s/(^)(Habitat)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"habitat\">\n\t\t\t\t<string><subHeading>$2<\/subHeading><habitat><\/habitat>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up habitat & ecology features:
		elsif (/Habitat & Ecology — /) {
			s/(^)(Habitat & Ecology)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"habitatecology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading><habitat><\/habitat>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up ecology features:
		elsif (/Ecology — /) {
			s/(^)(Ecology)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"ecology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Ecology\./) {
			s/(^)(Ecology\. )(.+)(\.)($)/$1\t\t\t<feature class=\"ecology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Ecol\./) {
			s/(^)(Ecol\. )(.+)(\.)($)/$1\t\t\t<feature class=\"ecology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# From here on alphabetical order.
		
		# Marks up anatomy features:
		elsif (/Anatomy — /) {
			s/(^)(Anatomy)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"anatomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Vegetative anatomy — /) {
			s/(^)(Vegetative anatomy)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"anatomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Leaf anatomy — /) {
			s/(^)(Leaf anatomy)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"anatomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Anatomy\./) {
			s/(^)(Anatomy\. )(.+)(\.)($)/$1\t\t\t<feature class=\"anatomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Anat\./) {
			s/(^)(Anat\. )(.+)(\.)($)/$1\t\t\t<feature class=\"anatomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Vegetative anatomy\./) {
			s/(^)(Vegetative anatomy\. )(.+)(\.)($)/$1\t\t\t<feature class=\"anatomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Wood anatomy\./) {
			s/(^)(Wood anatomy\. )(.+)(\.)($)/$1\t\t\t<feature class=\"anatomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Wood anat\./) {
			s/(^)(Wood anat\. )(.+)(\.)($)/$1\t\t\t<feature class=\"anatomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up conservation features:
		elsif (/Conservation — /) {
			s/(^)(Conservation)( — )(.+)(\.)($)/$1\t\t\t<feature class="conservation">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/IUCN conservation category — /) {
			s/(^)(IUCN conservation category)( — )(.+)(\.)($)/$1\t\t\t<feature class="conservation">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up cytology features:
		elsif (/Cytology — /) {
			s/(^)(Cytology)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"cytology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Chromosomes — /) {
			s/(^)(Chromosomes)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"cytology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;	
		}
		elsif (/Chromosome numbers — /) {
			s/(^)(Chromosome numbers)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"cytology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;	
		}
		elsif (/Chromosome number — /) {
			s/(^)(Chromosome number)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"cytology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;	
		}
		elsif (/Cytology\./) {
			s/(^)(Cytology\. )(.+)(\.)($)/$1\t\t\t<feature class=\"cytology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Cytotaxonomy\./) {
			s/(^)(Cytotaxonomy\. )(.+)(\.)($)/$1\t\t\t<feature class=\"cytology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Chromosomes\./) {
			s/(^)(Chromosomes\. )(.+)(\.)($)/$1\t\t\t<feature class=\"cytology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Chromosome numbers\./) {
			s/(^)(Chromosome numbers\. )(.+)(\.)($)/$1\t\t\t<feature class=\"cytology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up dispersal features:
		elsif (/Dispersal — /) {
			s/(^)(Dispersal)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"dispersal\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Dispersal\./) {
			s/(^)(Dispersal\. )(.+)(\.)($)/$1\t\t\t<feature class=\"dispersal\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up embryology features:
		elsif (/Embryology — /) {
			s/(^)(Embryology)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"embryology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Embryology\./) {
			s/(^)(Embryology\. )(.+)(\.)($)/$1\t\t\t<feature class=\"embryology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Embryography\./) {
			s/(^)(Embryography\. )(.+)(\.)($)/$1\t\t\t<feature class=\"embryology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up field characters features:
		elsif (/Field characters — /) {
			s/(^)(Field characters)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"field characters\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up fossils features:
		elsif (/Fossils — /) {
			s/(^)(Fossils)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"fossils\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Fossils\./) {
			s/(^)(Fossils\. )(.+)(\.)($)/$1\t\t\t<feature class=\"dispersal\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
				
		# Marks up morphology features:
		elsif (/Morphology — /) {
			s/(^)(Morphology)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"morphology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Fruits and Seeds — /) {
			s/(^)(Fruits and Seeds)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"morphology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Seedlings — /) {
			s/(^)(Seedlings)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"morphology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Morphology\./) {
			s/(^)(Morphology\. )(.+)(\.)($)/$1\t\t\t<feature class=\"morphology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Morph\./) {
			s/(^)(Morph\. )(.+)(\.)($)/$1\t\t\t<feature class=\"morphology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Floral morphology\./) {
			s/(^)(Flora morphology\. )(.+)(\.)($)/$1\t\t\t<feature class=\"morphology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Floral morph\./) {
			s/(^)(Flora morph\. )(.+)(\.)($)/$1\t\t\t<feature class=\"morphology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up Field Notes:
		elsif (/Field notes — /) {
			s/(^)(Field notes)( — )(.+)(\.)($)/$1\t\t\t<feature class="field notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Field-notes — /) {
			s/(^)(Field-notes)( — )(.+)(\.)($)/$1\t\t\t<feature class="field notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Field notes\./) {
			s/(^)(Field notes\.)(.+)(\.)($)/$1\t\t\t<feature class="field notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up notes features:
		elsif (/Note — /) {
			s/(^)(Note)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"\" isNotes=\"true\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}		
		elsif (/Notes — /) {
			s/(^)(Notes)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"\" isNotes=\"true\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5/;		
		}		
		elsif (/Note\./) {
			s/(^)(Note\. )(.+)(\.)($)/$1\t\t\t<feature class=\"\" isNotes="true">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Notes\./) {
			s/(^)(Notes\.)(.+)(\.)($)/$1\t\t\t<feature class=\"\" isNotes=\"true\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4/;
		}
		elsif (/Notes for collectors\./) {
			s/(^)(Notes for collectors\.)(.+)(\.)($)/$1\t\t\t<feature class=\"notes\" isNotes=\"true\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4/;
		}
		elsif (/Hints to collectors\./) {
			s/(^)(Hints to collectors\.)(.+)(\.)($)/$1\t\t\t<feature class=\"notes\" isNotes=\"true\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4/;
		}
		
		# Marks up palynology features:
		elsif (/Palynology — /) {
			s/(^)(Palynology)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"palynology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Palynology\./) {
			s/(^)(Palynology\. )(.+)(\.)($)/$1\t\t\t<feature class=\"palynology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Palyn\./) {
			s/(^)(Palyn\. )(.+)(\.)($)/$1\t\t\t<feature class=\"palynology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Pollen morphology\./) {
			s/(^)(Pollen morphology\. )(.+)(\.)($)/$1\t\t\t<feature class=\"palynology\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up parasitism features:
		elsif (/Parasitism — /) {
			s/(^)(Parasitism)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"parasitism\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		
		}
		elsif (/Parasitism\./) {
			s/(^)(Parasitism\. )(.+)(\.)($)/$1\t\t\t<feature class=\"parasitism\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Galls\./) {
			s/(^)(Galls\. )(.+)(\.)($)/$1\t\t\t<feature class=\"parasitism\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up phylogeny features:
		elsif (/Relationships — /) {
			s/(^)(Relationships)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"phylogeny\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Phylogeny\./) {
			s/(^)(Phylogeny\. )(.+)(\.)($)/$1\t\t\t<feature class=\"phylogeny\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Inter-relationships\./) {
			s/(^)(Inter-relationships\. )(.+)(\.)($)/$1\t\t\t<feature class=\"phylogeny\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up phytochemistry features:
		elsif (/Phytochemistry & Chemotaxonomy — /) {
			s/(^)(Phytochemistry & Chemotaxonomy)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"phytochemo\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Phytochemistry — /) {
			s/(^)(Phytochemistry)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"phytochemo\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Chemistry — /) {
			s/(^)(Chemistry)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"phytochemo\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Chemical compounds — /) {
			s/(^)(Chemical compounds)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"phytochemo\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Phytochemistry\./) {
			s/(^)(Phytochemistry\. )(.+)(\.)($)/$1\t\t\t<feature class=\"phytochemo\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Chemotaxonomy\./) {
			s/(^)(Chemotaxonomy\. )(.+)(\.)($)/$1\t\t\t<feature class=\"phytochemo\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
				
		# Marks up pollination features:
		elsif (/Pollination — /) {
			s/(^)(Pollination)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"pollination\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Pollinators — /) {
			s/(^)(Pollinators)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"pollination\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Pollination\./) {
			s/(^)(Pollination\. )(.+)(\.)($)/$1\t\t\t<feature class=\"pollination\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Flower-biology\./) {
			s/(^)(Flower-biology\. )(.+)(\.)($)/$1\t\t\t<feature class=\"pollination\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}		
		
		# Marks up taxonomy features:
		elsif (/Taxonomy — /) {
			s/(^)(Taxonomy)( — )(.+)(\.|<br \/>)($)/$1\t\t\t<feature class=\"taxonomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Subdivision — /) {
			s/(^)(Subdivision)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"taxonomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Delimitation — /) {
			s/(^)(Delimitation)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"taxonomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Taxonomy\./) {
			s/(^)(Taxonomy\. )(.+)(\.)($)/$1\t\t\t<feature class=\"taxonomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Taxon\./) {
			s/(^)(Taxon\. )(.+)(\.)($)/$1\t\t\t<feature class=\"taxonomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Taxonomical affinities\./) {
			s/(^)(Taxonomical affinities\. )(.+)(\.)($)/$1\t\t\t<feature class=\"taxonomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Affinities\./) {
			s/(^)(Affinities\. )(.+)(\.)($)/$1\t\t\t<feature class=\"taxonomy\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up uses features:
		elsif (/Uses — /) {
			s/(^)(Uses)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"uses\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Uses\./) {
			s/(^)(Uses\. )(.+)(\.)($)/$1\t\t\t<feature class=\"uses\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Use\./) {
			s/(^)(Use\. )(.+)(\.)($)/$1\t\t\t<feature class=\"uses\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Useful & noxious plants\./) {
			s/(^)(Useful & noxious plants\. )(.+)(\.)($)/$1\t\t\t<feature class=\"uses\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up vernacular names features:
		elsif (/Vernacular names — /) {
			s/(^)(Vernacular names)( — )(.+)(\.)($)/$1\t\t\t<feature class=\"vernacular\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Vern\./) {
			s/(^)(Vern\. )(.+)(\.)($)/$1\t\t\t<feature class=\"vernacular\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		elsif (/Indigenous name(|s) — /) {
			s/(^)(Indigenous name(?:|s))( — )(.+)(\.)($)/$1\t\t\t<feature class=\"vernacular\">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4$5<\/string>\n\t\t\t<\/feature>/;
		}
		
		# Marks up non-feature subheadings:
		elsif (/Subdivision of the genus — /) {
			s/(^)(Subdivision of the genus)( — )(.+)(\.)($)/<subHeading>$2<\/subHeading>$4$5/;
		}
		elsif (/Description of species — /) {
			s/(^)(Description of species)( — )(.+)(\.)($)/<subHeading>$2<\/subHeading>$4$5/;
		}
		
		else {
		}
		
		# References sections basic mark-up:
		
		# Sections starting with ALL-CAPS heading:
		s/(^)(REFERENCES)($)/$1\t\t\t\t<references><heading>$2<\/heading>/;
		
		# Sections starting with a subheading:
		s/(^)((?:References|Reference|Literature|Literature \(selected references only\)):)( )(.+)($)/$1\t\t\t\t<references><subHeading>$2<\/subHeading>$4<\/references>$5/;
	}
	
	
	
	print OUT $_; 
}

close IN;
close OUT;