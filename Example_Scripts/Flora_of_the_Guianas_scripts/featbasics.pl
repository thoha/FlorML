#!/usr/bin/perl
# features.plx
# Adds basic mark-up to features.

use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {

	# Distributions:
	s/(^)(Distribution(?: and ecology|):)( .+\.)($)/$1\t\t\t<feature class="distribution">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	# Habitats:
	# Splitting off habitats (needs work; crude):
	s/(\t\t\t\t<string><subHeading>Distribution(?: and ecology|):<\/subHeading>.+?\; )(.+?)(; )(.+?\.<\/string>)/$1$4\n\t\t\t<\/feature>\n\t\t\t<feature class="habitat">\n\t\t\t\t<string><subHeading>Habitat:<\/subHeading> $2\.<\/string>/;
	
	# Cleans up double periods after altitude abbreviation:
	s/( (?:alt|elev)\.)\./$1/;
	
	
	# Ecology:
	s/(^)(Ecology:)( .+\.)($)/$1\t\t\t<feature class="ecology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Cultivation:
	s/(^)(Cult(?:ure and use|ivation):)( .+\.)($)/$1\t\t\t<feature class="cultivation">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Vernacular names
	s/(^)(Vernacular(?: \(and commercial\)|) name(?:s|):)( .+\.)($)/$1\t\t\t<feature class="vernacular">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Etymology:
	s/(^)(Etymology:)( .+\.)($)/$1\t\t\t<feature class="etymology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	# Notes:
	s/(^)(Note(?:s|):)( .+(?:\.|:|<br \/>))($)/$1\t\t\t<feature class="notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Wood anatomy:
	s/(^)(Wood anatomy:)( .+\.)($)/$1\t\t\t<feature class="wood">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(WOOD (?:ANATOMY|AND TIMBER))($)/$1\t\t\t<feature class="wood">\n\t\t\t\t<heading>$2<\/heading>/;
	
	# Wood observation species:
	s/(^)(Studied:)( [[:upper:]]\. [[:lower:]]+(?: subsp\. [[:lower:]]+|)(?: \(from [[:upper:]][[:lower:]]+\)|)(?:, [[:upper:]]\. [[:lower:]]+(?: subsp\. [[:lower:]]+|)(?: \(from [[:upper:]][[:lower:]]+\)|)|)+(?:\.|))($)/$1\t\t\t<feature class="wood observation species">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	# Timbers and their properties:
	s/(^)(TIMBERS AND THEIR PROPERTIES)($)/$1\t\t\t<feature class="timber properties">\n\t\t\t\t<heading>$2<\/heading>/;
	
	
	
	# Taxonomy:
	s/(^)((?:Classification(?:s|)|Subdivision(?:s|)|Systematic position|Taxonomy):)( .+(?:\.|:|<br \/>))($)/$1\t\t\t<feature class="taxonomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(TAXONOMIC AND NOMENCLATURAL CHANGES|NOMENCLATURAL CHANGES AND NEW TYPIFICATIONS|TAXONOMIC CHANGES AND NEW TYPIFICATION)($)/$1\t\t\t<feature class="taxonomy">\n\t\t\t\t<heading>$2<\/heading>/;
	
	
	# Uses:
	s/(^)((?:Economic u|U)se(?:s|):)( .+\.)($)/$1\t\t\t<feature class="uses">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Phenology:
	s/(^)(Phenology:)( .+\.)($)/$1\t\t\t<feature class="phenology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	# Pollination:
	s/(^)(Pollination:)( .+\.)($)/$1\t\t\t<feature class="phenology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Cytology:
	s/(^)(Chromosome number .+\.)($)/$1\t\t\t<feature class="cytology">\n\t\t\t\t<string>$2<\/string>\n\t\t\t<\/feature>/;
	
	
	# Literature:
	# Headings:
	s/(^)(Literature:)( .+\.)($)/$1\t\t\t<references>\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/references>/;
	s/(^)(LITERATURE(?: ON WOOD AND TIMBER|)|Literature:)($)/$1\t\t\t<references>\n\t\t\t\t<heading>$2<\/heading>/;
	# Individual references:
	s/(^)([[:upper:]].+?\. \d\d\d\d(?:[[:upper:]]|[[:lower:]]|)\. .+?(?:(?:\.|,) p(?:p|)\. \d+-\d+|: \d+(?:-\d+(?: \+ \d+ plates|)|)(?:; \d+-\d+|)+|: \d+ pp|: p\.(?: |)\d+|\. \d+ p(?:p|)| t(?:ab|)\. \d+-\d+|\. \d+-\d+)(?:\. Leipzig|\. Paris|)\.)($)/<reference>$2<\/reference>/;
	s/(^)([[:upper:]].+?\. \d\d\d\d(?:[[:upper:]]|[[:lower:]]|)\. .+?(?:Amsterdam|Caen|Dakar|Ede|India|Jena|London|Madison|Melbourne|New Haven|New York|Nogent-sur-Marne|Oxford|Paramaribo|Paris|Rijswijk|Stuttgart)\.)($)/<reference>$2<\/reference>/;
	s/(^)([[:upper:]].+?\. \d\d\d\d(?:[[:upper:]]|[[:lower:]]|)\. [[:upper:][:lower:] ]+(?:, ed\. \d|, \d vols|)\.)($)/<reference>$2<\/reference>/;

	
	# Specimens:
	s/(^)((?:(?:Examined s|Representative s|Selected s|S)pecimen(?:s|)(?: examined|)|(?:Fertile s|S)pecimen(?:s|) (?:examined(?: \(by Callejas\)|)|from literature|studied)):)( .+\.)($)/$1\t\t\t<feature class="specimens">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(COLLECTIONS STUDIED(?:\d|))($)/$1\t\t\t<feature class="specimens">\n\t\t\t\t<heading>$2<\/heading>/;
	
	# Wood specimens:
	s/(^)(Material studied \((?:Uw-numbers refer to the Utrecht Wood collection|CTFw-numbers refer to the collection of Centre Technique Forestier, Nogent-sur-Marne, Uw-numbers to the Utrecht Wood collection)\):)($)/$1\t\t\t<feature class="wood specimens">\n\t\t\t\t<string><subHeading>$2<\/subHeading>/;
	
	# Basic collection mark-up:
	# COMPLETE SPECIMEN LIST:
	# Finds collections listed in the complete list of specimens:
	if (/^([[:upper:]][[:lower:]]+(( |-|\. | & ([[:upper:]]\.)+( |)|)[[:upper:]][[:lower:]\.]+|)+|[[:upper:]]+ \(.+?\)|[[:upper:]]+|(C|c)ollector (anonymous|indigen(o|)us( surinamensis|)|unknown)|((I|i)ndigenous|(u|U)nknown|(w|W)ithout) col(lector|l\.|\.)|Forest Dept\. British Guiana \(FD\)|Geldermalsen-de Jongh|Görts-van Rijn|Granville J\.J\. de|Leguillou\?|Leschenault de la Tour|S\.V\.|U\.G\. Field Group), .+[[:lower:]\.]\)( — BR| — FG| — GU| — SU| — VE)(\.|)$/) {
		
		# Inserts <gathering> tags around each line:
		s/^((?:[[:upper:]][[:lower:]]+(?:(?: |-|\. | & (?:[[:upper:]]\.)+(?: |)|)[[:upper:]][[:lower:]\.]+|)+|[[:upper:]]+ \(.+?\)|[[:upper:]]+|(?:C|c)ollector (?:anonymous|indigen(?:o|)us(?: surinamensis|)|unknown)|(?:(?:I|i)ndigenous|(?:u|U)nknown|(?:w|W)ithout) col(?:lector|l\.|\.)|Coll\. ind\.|Forest Dept\. British Guiana \(FD\)|Geldermalsen-de Jongh|Görts-van Rijn|Granville J\.J\. de|Leguillou\?|Leschenault de la Tour|S\.V\.|U\.G\. Field Group), .+[[:lower:]\.]\)(?:( — (?:BR|FG|GU|SU|VE)|)|))(\.|)$/\t\t\t\t<gathering>$1<\/gathering>/;
		
		
		# Removes <gathering> tags from nomenclature accidentally recognized as specimens:
		s/^(\t\t\t\t<gathering>)(.+?(?:Lectot|T)ype:.+?)(<\/gathering>)/$2/;
		
		
	}
	
	# Marks up gatheringGroups in this specimen list:
		s/(GUYANA)($)/\t\t\t\t<gatheringGroup geoscope="">$1/g;
		s/((?:BRAZIL|SURINAM(?:E|)|FRENCH GUIANA|EXTRA GUIANAN|VENEZUELA))($)/\t\t\t\t<\/gatheringGroup>\n\t\t\t\t<gatheringGroup geoscope="">$1/g;
		
		s/(<gatheringGroup geoscope=")(">BRAZIL)/$1brazil$2/;
		s/(<gatheringGroup geoscope=")(">GUYANA)/$1guyana$2/;
		s/(<gatheringGroup geoscope=")(">SURINAM(?:E|))/$1suriname$2/;
		s/(<gatheringGroup geoscope=")(">FRENCH GUIANA)/$1french guiana$2/;
		s/(<gatheringGroup geoscope=")(">EXTRA GUIANAN)/$1extra guianan$2/;
		s/(<gatheringGroup geoscope=")(">VENEZUELA)/$1venezuela$2/;
	
	
	# WOOD SPECIMENS:
	# Inserts <gathering> tags around each line:
	# Format ending on Uw number between parentheses:
	s/^([[:upper:]](?:[[:lower:]]+|\.) [[:lower:]]+ (?:L\.|(?:\([[:upper:]][[:lower:]]+(?:\.|)\) |[[:upper:]][[:lower:]]+(?:\.|) & |[[:upper:]][[:lower:]]+(?:\.|) ex |)(?:(?:[[:upper:]]\.)+ |)[[:upper:]][[:lower:]]+(?:\.|)): (?:Brazil|French Guiana|Guyana|Suriname|\?): .+\)\.)$/\t\t\t\t<gathering>$1<\/gathering>/;
	# Format ending on = Uw number:
	s/^([[:upper:]](?:[[:lower:]]+|\.) [[:lower:]]+ (?:L\.|(?:\([[:upper:]][[:lower:]]+(?:\.|)\) |[[:upper:]][[:lower:]]+(?:\.|) & |[[:upper:]][[:lower:]]+(?:\.|) ex |)(?:(?:[[:upper:]]\.)+ |)[[:upper:]][[:lower:]]+(?:\.|)): (?:Brazil|French Guiana|Guyana|Suriname|\?): .+= Uw \d+\.)$/\t\t\t\t<gathering>$1<\/gathering>/;
	# 
	
	# REMAINING SPECIMENS (regular specimen paragraphs):
	# Selects only those lines with the proper mark-up:
	if (/\t\t\t<feature class="specimens">\n\t\t\t\t<string><subHeading>.+?<\/subHeading>/) {
	
		# Splits paragraph and inserts <gathering> tags around each resulting line:
		s/( )((?:French Guiana|Guyana|Suriname):)( )/<\/gathering>\n$2\n<gathering>/g;
		s/(<\/subHeading>)(<\/gathering>)/$1/;
		s/(<\/string>)/<\/gathering>\n\t\t\t\t$1/;
		
		# Marks up gatheringGroups in specimen lists:
		s/(Guyana)(:)(?: |)/\t\t\t\t<gatheringGroup geoscope="">$1$2/g;
		s/((?:Suriname|French Guiana))(:)(?: |)/\t\t\t\t<\/gatheringGroup>\n\t\t\t\t<gatheringGroup geoscope="">$1$2/g;
		
		s/(<gatheringGroup geoscope=")(">Guyana)/$1guyana$2/;
		s/(<gatheringGroup geoscope=")(">Suriname)/$1suriname$2/;
		s/(<gatheringGroup geoscope=")(">French Guiana)/$1french guiana$2/;
		
	}
	
	
	
	# Descriptions basic mark-up:
	s/(^)(Usually small, glabrous bushes|(?:Acaulescent|Annual|Annual or perennial|Branching|Creeping|Diffuse(?:, pubescent|)|Erect(?: to decumbent| or scrambling|, suffrutescent| prickly)|(?:Acaulescent g|G)labrous(?:, well branched|)|Large|Low, weak|Low-growing diffuse|Narrowly taprooted|(?:Erect p|P)erennial (?:erect|)|Prostrate(?:, weedy|, erect or rarely, climbing,|)|Pubescent(?: or glabrous, unarmed|)|Rhizomatose(?:, stoloniferous|)|Spreading to erect perennial|Stout|Terrestrial|Weak|(?:Spr(?:awling|eading) to ascending w|W)oody) herb(?:s|)|Herbs(?: or subshrubs|, shrubs or (?:lianas|(?:rarely |)trees))|Herb(?:s|)|(?:Predominantly s|S)ucculent|(?:Tall l|Usually l|L)iana(?:s|) or (?:climbing|scandent) shrub(?:s|)|(?:Climbing l|Large l|Usually l|Woody l|L)iana(?: or climber|)|Woody climber|(?:Erect prickly s|Large s|Leafy(?: parasitic|) s|Mangrove(?:-like|) s|Root-parasitic s|Scandent(?: or creeping|) s|Scrambling s|Small s|Woody s|S)hrub(?:s|)|Subshrub(?:s|)|Flowering shoots|(?:Glabrous v|Sarmentose v|Twining v|Woody v|V)ine(?:s|)|(?:Bushy t|(?:Briefly d|D)eciduous t|Slender t|Small (?:to large |)t|T)ree(?:let|)(?:s|)|(?:Annual or p|P)erennial|(?:Ac|C)aulescent|(?:(?:Diffusely b|(?:Delicate, percurrent, m|M)uch b|B)ranched|(?:Dichotomous, |Small, )erect|(?:(?:Usually r|R)ather l|L)arge|Large(?:,|) glabrous|(?:Densely l|Rather small, l|L)eafy(?: parasitic| to squamate|)|(?:Rather leggy, p|P)ercurrent|Scandent|Medium(?:-| )sized|Slender(?:-stemmed|)|(?:A r|R)ather small-leaved|(?:Rather s|S)mall(?:, leafless|)|(?:Rather coarse, s|Delicate, s|Stout, s|S)parsely branch(?:ed|ing)(?:, smooth|)|Squamate|Stout(?:, brittle|)) plant|Semiparasitic mistletoes|Annual|Evergreen|Glabrous|Internodes|(?:Often large, l|L)eafy(?:, glabrous|) parasites|Phyllodes|Plants (?:to|with|mostly dichotomous|percurrent|sparsely branched|submersed)|Stem(?:s|) (?:short|(?:more or less |)terete)|Suffrutescent|Epicortical roots|Very small and delicate species|Young (?:shoots|stems)|(?:Subterranean t|T)ubers|Climber(?:s|))(.+)($)/$1\t\t\t<feature class="description">$2$3<\/feature>/;
	
	if (/^(?!\t*<)(?!.+xmlns:xsi)/) {
	
		# More descriptions mark-up:
		s/^(.+?(?:annual|castaneous|coriaceous|ephemeral|epiphytic|evergreen|funnelform|perennial|quadrangular |subterraneous).+?)$/\t\t\t<feature class="description">$1<\/feature>/;
		
		s/^((?:Aromatic|Corolla|Decumbent|Dioecious|Epiphytic|Epilithic|Erect|Petiole with a sheath|Rosulate|Suffruticose|Terrestrial).+?)$/\t\t\t<feature class="description">$1<\/feature>/;
		
		
	}
	
	
	
	print OUT $_; 
}

close IN;
close OUT;