#!/usr/bin/perl
# characters.plx
# Adds mark-up to characters in descriptions, then fixes form of feature and char mark-up at beginning and end, then add proper classes to characters (as far as possible).
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Implement <subChar> element to allow for better atomization? dot-space-capital letter = <chars>, all other = <subchars>. Need to remove 'wrong' opening (immediately preceding </char>) and closing (immediately following <char>) tags after inserting subChar tags.
	
	# Find descriptions based on previously inserted mark-up:
	if (/^<feature class="description"><char class="">/) {
		# Fixes form of feature and char mark-up at beginning and end:
		s/(^)(<feature class="description">)(<char class="">)/$1\t\t\t$2\n\t\t\t\t$3/;
		s/(<\/char>)(<\/feature>)($)/$1\n\t\t\t$2$3/g;
		
		# Inserts basic character mark-up:
		# Format #1:
		if (/\. [[:upper:]][[:lower:]]/) {
			s/(\.)( )([[:upper:]][[:lower:]])/$1<\/subChar><\/char>\n\t\t\t\t<char class="">$3/g;
			# Format #1.5:
			if (/\. — [[:upper:]][[:lower:]]/) {
				s/(\.)( — )([[:upper:]][[:lower:]])/$1<\/subChar><\/char>\n\t\t\t\t<char class="">$3/g;
			}
			elsif (/(;|:) [[:lower:]][[:lower:]]/) {
				s/(;|:)( )([[:lower:]][[:lower:]]|\d+)/$1<\/subChar>\n\t\t\t\t\t<subChar class="">$3/g;
			}
			else {
			}
		}
		# Format #2 (Unique to FM Series II Vol. 2):
		elsif (/; [[:lower:]][[:lower:]]/) {
			s/(;)( )([[:lower:]][[:lower:]])/$1<\/char>\n\t\t\t\t<char class="">$3/g;
		}
		# Single sentence descriptions:
		else {
		}
		
		# FIX: If description ends on subChar, currently no subChar tag is inserted!
		
		# Removal of excess closing <subChar> tags:
		s/(<char class="">.+?)(<\/subChar>)/$1/g;
		# Putting closing <char> tag on separate line when preceded by closing <subChar> tag:
		s/(<\/subChar>)(<\/char>)/$1\n\t\t\t\t$2/g;
		
		# Finds specific characters, inserts accompanying mark-up:
		
		# Ferns:
			
			s/(<(?:subC|c)har class=")(">)(acumen)/$1acumen$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a)nnul(?:us|i))/$1annulus cells$2$3/g;
			s/(<(?:subC|c)har class=")(">)(antherozoids)/$1antherozoids$2$3/g;
			s/(<(?:subC|c)har class=")(">)(baculae)/$1baculae$2$3/g;
			s/(<(?:subC|c)har class=")(">)(basal pair)/$1basal pair$2$3/g;
			s/(<(?:subC|c)har class=")(">)(peltate blades)/$1peltate blades$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)apsule(?:|s))/$1capsules$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Caudex)/$1caudex$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Coenosor(?:us|i))/$1coenosori$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)osta(?:|e))/$1costae$2$3/g;
			s/(<(?:subC|c)har class=")(">)(costules)/$1costules$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ertile (?:area|part))/$1fertile parts$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:D|d)ilated frond bases)/$1dilated frond bases$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)ase frond(?:|s))/$1base fronds$2$3/g;
			s/(<(?:subC|c)har class=")(">)(persistent base frond(?:|s))/$1persistent base fronds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)oliage frond(?:|s))/$1foliage fronds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)rond(?:|s))/$1fronds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:D|d)issected frond(?:|s))/$1dissected fronds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ertile frond)/$1fertile fronds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)innatifid frond(?:|s))/$1pinnatifid fronds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)imple frond(?:|s))/$1simple fronds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)terile frond)/$1sterile fronds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:H|h)ydathodes)/$1hydathodes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)ndusi(?:a|um))/$1indusia$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ateral leaflets)/$1lateral leaflets$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ertile terminal leaflet)/$1fertile terminal leaflets$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)terile terminal leaflet)/$1sterile terminal leaflets$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ertile lea(?:f|ves))/$1fertile leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)terile lea(?:f|ves))/$1sterile leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l|The l|the l)obe(?:|s))/$1lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)(acroscopic lobe)/$1acroscopic lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)(basal acroscopic lobe)/$1basal acroscopic lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)(apical lobe)/$1apical lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Basiscopic lobe|basiscopic lobe)/$1basiscopic lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)(basal basiscopic lobe)/$1basal basiscopic lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)(lateral lobe(?:|s))/$1lateral lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaf lobe(?:|s))/$1leaf lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:D|d)orsal leaf lobe(?:|s))/$1dorsal leaf lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:V|v)entral leaf lobe(?:|s))/$1ventral leaf lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)(upper lobe(?:|s))/$1upper lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)assulae)/$1massulae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)egagametophyte)/$1megagametophyte$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)icrogametophyte)/$1microgametophyte$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:N|n|without n)otches)/$1notches$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p|Scaly p)araphyses)/$1paraphyses$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r)eceptacular paraphyses)/$1receptacular paraphyses$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)etiolules)/$1petiolules$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ongest petiolules)/$1longest petiolules$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:|P|p)hyllopods)/$1phyllopods$2$3/g;
			s/(<(?:subC|c)har class=")(">)(pinna-lobe)/$1pinna-lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)inna-segments)/$1pinna-segments$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)innae)/$1pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a)pical pinnae)/$1apical pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)asal pinnae)/$1basal pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)entral pinnae)/$1central pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:D|d)istal pinnae)/$1distal pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:D|d)istal adnate pinnae)/$1distal adnate pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|Fully f)ertile pinnae)/$1fertile pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ree pinnae)/$1free pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)argest pinna)/$1largest pinna$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)argest (?:|fully )fertile pinna)/$1largest fertile pinna$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)argest fertile lateral pinna)/$1largest fertile lateral pinna$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)argest sterile pinna)/$1largest sterile pinna$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ongest pinnae)/$1longest pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ower pinnae|(?:L|l)owermost pinnae)/$1lower pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)iddle pinnae)/$1middle pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)econd pair of pinnae)/$1second pair of pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Sterile pinnae)/$1sterile pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)uprabasal pinnae|(?:S|s)upra-basal pinnae)/$1suprabasal pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:U|u)pper pinnae|(?:U|u)ppermost pinnae)/$1upper pinnae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)innule-segments)/$1pinnule-segments$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)innules)/$1pinnules$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ongest pinnules)/$1longest pinnules$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)rimary pinnules)/$1primary pinnules$2$3/g;
			s/(<(?:subC|c)har class=")(">)(acroscopic pinnule)/$1acroscopic pinnules$2$3/g;
			s/(<(?:subC|c)har class=")(">)(basal acroscopic pinnule)/$1basal acroscopic pinnules$2$3/g;
			s/(<(?:subC|c)har class=")(">)(basiscopic pinnule)/$1basiscopic pinnules$2$3/g;
			s/(<(?:subC|c)har class=")(">)(basal basiscopic pinnule)/$1basal basiscopic pinnules$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ateral pinnules)/$1lateral pinnules$2$3/g;
			s/(<(?:subC|c)har class=")(">)(pinnatifid pinnules)/$1pinnatifid pinnules$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r)achis(?:|es))/$1rachises$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)inna-rachises)/$1pinna-rachises$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Rhizome scales)/$1rhizome scales$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Rhizome)/$1rhizome$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Sinuses|sinuses)/$1sinuses$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)inus-teeth|(?:S|s)inus teeth)/$1sinus-teeth$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)ase of stipe(?:|s)|(?:S|s)tipe base)/$1stipe base$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)tipe(?:|s))/$1stipes$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Soral patch(?:|es))/$1soral patches$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)ori)/$1sori$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s|Ripe s)porangia)/$1sporangia$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)porangiophore(?:|s))/$1sporangiophores$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)pore(?:|s))/$1spores$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)egaspore(?:|s))/$1megaspore$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)icrospore(?:|s))/$1microspores$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)porocarp(?:|s))/$1sporocarps$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)egasporocarp(?:|s))/$1megasporocarps$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)icrosporocarp(?:|s))/$1microsporocarps$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)egasporoderm)/$1megasporoderm$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)egasporangi(?:a|um))/$1megasporangia$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)icrosporangi(?:a|um))/$1microsporangia$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)trobilus)/$1strobili$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Vascular strands|vascular strands)/$1vascular strands$2$3/g;
			
		
		# Ferns and angiosperms:
		
			s/(<(?:subC|c)har class=")(">)(Anatomy)/$1anatomy$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Stem anatomy)/$1stem anatomy$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:O|o|commonly o)pposite|terminal or axillary|(?:|completely )included)/$1arrangement$2$3/g; # Arrangements (various)
			s/(<(?:subC|c)har class=")(">)((?:A|a)x(?:e|i)s of raceme(?:|s))/$1axes of racemes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a)x(?:e|i)s)/$1axes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)edian ax(?:e|i)s)/$1median axes$2$3/g;
			s/(<(?:subC|c)har class=")(">)(bundle sheath)/$1bundle sheath$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)undles)/$1bundles$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)nterlacunar bundles)/$1interlacunar bundles$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)ubepidermal bundles)/$1subepidermal bundles$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:V|v)ascular bundles)/$1vascular bundles$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)entral vascular bundle)/$1central vascular bundle$2$3/g;
			s/(<(?:subC|c)har class=")(">)(central cells|cell walls)/$1cellular anatomy$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)entral cylinder)/$1central cylinder$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c|Gametic c)hromosome(?:s| number))/$1chromosomes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)ortex)/$1cortex$2$3/g;
			s/(<(?:subC|c)har class=")(">)(outer edge)/$1outer edges$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:U|u)nicellular glands|(?:G|g)lands|glandulation)/$1glands$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:N|n)ectar glands)/$1nectar glands$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:G|g)round tissue)/$1ground tissue$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:H|h|Stellate h|\d+-celled glandular h|Blackish h)airs|(?:|stems strigose or |densely )tomentose|(?:|partly |minutely |sparsely |densely |sparsely to densely brown |densely brown |shortly brown |outside and inside )pube(?:scent|rulous|rulent)|glabr(?:ous|escent)|(?:|appressed brown |densely brown appressed )velutinous|(?:P|p)lant hairy|trichomes)/$1hairs$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)nner vascular ring)/$1inner vascular ring$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)ntervenium)/$1intervenium$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaf trichomes)/$1leaf hairs$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Lamina|lamina)/$1lamina$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Fertile lamina|fertile lamina)/$1fertile lamina$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Sterile lamina|sterile lamina)/$1sterile lamina$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Apical lamina|apical lamina)/$1apical lamina$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaflets)/$1leaflets$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a)pical leaflet(?:|s))/$1apical leaflets$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)erminal leaflet(?:|s))/$1terminal leaflets$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:U|u)ltimate leaflets)/$1ultimate leaflets$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaf axes)/$1leaf axes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaf sheath)/$1leaf sheath$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaf twigs)/$1leaf twigs$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaves of climbing stems)/$1climbing stem leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaves of short stems)/$1short stem leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaves of tall stems)/$1tall stem leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l|Devoid of l)eaves)/$1leaves$2$3/g; # Leaves
			s/(<(?:subC|c)har class=")(">)((?:B|b)asal rosette leaves)/$1basal rosette leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)auline leaves)/$1cauline leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)limbing leaves)/$1climbing leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)loating leaves)/$1floating leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)ntermediate leaves)/$1intermediate leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)ubmer(?:s|g)ed leaves)/$1submerged leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:U|u)nifoliate leaves)/$1unifoliate leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m|the m)argin(?:|s))/$1margins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:H|h)yaline margin(?:|s))/$1hyaline margins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaf blade margin(?:|s))/$1leaf blade margins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaf blade(?:|s))/$1leaf blades$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ower leaf blade(?:|s))/$1lower leaf blades$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Red anthocyanin pigments)/$1pigments$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:U|u)pper ridge)/$1upper ridge$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s|Narrow s)cales)/$1scales$2$3/g;
			s/(<(?:subC|c)har class=")(">)(basal scales)/$1basal scales$2$3/g;
			s/(<(?:subC|c)har class=")(">)(large scales)/$1large scales$2$3/g;
			s/(<(?:subC|c)har class=")(">)(small scales)/$1small scales$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s|the s)heath(?:|s))/$1sheaths$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:D|d)orsal side of sheath(?:|s))/$1dorsal side of sheaths$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)oral scales)/$1soral scales$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s|the s)clerenchyma strands)/$1sclerenchyma strands$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)clerenchyma)/$1sclerenchyma$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)clerified sheath)/$1sclerified sheath$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)egments)/$1segments$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:U|u)ltimate segments)/$1ultimate segments$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:|Mon|Di|mon|di|Plants mon|Plants di)oecious)/$1plant sexuality$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)tele)/$1stele$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)tomata)/$1stomata$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:Both |both |)surfaces)/$1surfaces$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)nner surface(?:|s))/$1inner surfaces$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l|on l)ower (?:leaf |)surface(?:|s))/$1lower surfaces$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:U|u|on u)pper surface(?:|s))/$1upper surfaces$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:U|u)pper and lower surface)/$1surfaces$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)annin cells)/$1tannin cells$2$3/g;
			s/(<(?:subC|c)har class=")(">)(apical teeth)/$1apical teeth$2$3/g;
			s/(<(?:subC|c)har class=")(">)(teeth)/$1teeth$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:V|v)ein endings)/$1vein endings$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:V|v)einlets)/$1veinlets$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ree veinlets)/$1free veinlets$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:V|v)eins)/$1veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)asal veins)/$1basal veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)onnecting veins)/$1connecting veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)ross veins)/$1cross veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)alse veins)/$1false veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)ntermarginal veins)/$1intermarginal veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ateral veins)/$1lateral veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ongitudinal veins)/$1longitudinal veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)ennate veins)/$1pennate veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)ain veins)/$1main veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s|\d+-\d+ pairs of s|\d+-\d+\(-\d+\) pairs of s)econdary veins)/$1secondary veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)(secondary and tertiary ve(?:ins|nation))/$1secondary and tertiary veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)ubmarginal veins)/$1submarginal veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:V|v)essels)/$1vessels$2$3/g;
		
		
		
		
		
		# Angiosperms (global category mentioned in comment following substitution)
			s/(<(?:subC|c)har class=")(">)((?:A|a)lbumen)/$1albumen$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a)ndroecium)/$1androecium$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a)ndrophore)/$1androphore$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a)nthophore)/$1anthophore$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a)nther(?:|s))/$1anthers$2$3/g; # Flowers
			s/(<(?:subC|c)har class=")(">)((?:A|a)reoles)/$1areoles$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a|the a)ril)/$1aril$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a)rticles)/$1articles$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a)uriculae)/$1auriculae$2$3/g;
			s/(<(?:subC|c)har class=")(">)(Bark and wood exuding)/$1exudates$2$3/g; # Exudates
			s/(<(?:subC|c)har class=")(">)((?:I|i)nner bark)/$1inner bark$2$3/g; # Bark
			s/(<(?:subC|c)har class=")(">)((?:O|o)uter bark)/$1outer bark$2$3/g; # Bark
			s/(<(?:subC|c)har class=")(">)((?:B|b)ark)/$1bark$2$3/g; # Bark
			s/(<(?:subC|c)har class=")(">)((?:B|b)eak)/$1beak$2$3/g; # Seeds
			s/(<(?:subC|c)har class=")(">)((?:E|e|the e)ndocarpous beak)/$1endocarpous beak$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b|Leaf b)lade(?:|s))/$1blade$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)racteole(?:|s))/$1bracteoles$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b|sessile wart-like b)rachyblast(?:|s))/$1brachyblasts$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)asal bracts)/$1basal bracts$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)nterfloral bracts)/$1interfloral bracts$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)nvolucral bracts)/$1involucral bracts$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ateral bracts)/$1lateral bracts$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)eduncular bracts)/$1peduncular bracts$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)robract(?:|s))/$1probracts$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)ubtending bracts)/$1subtending bracts$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)ract IV)/$1bract IV$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)ract III)/$1bract III$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)ract II)/$1bract II$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)ract I)/$1bract I$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)ract(?:|s))/$1bracts$2$3/g;
			s/(<(?:subC|c)har class=")(">)(branching)/$1branching$2$3/g; # Habit
			s/(<(?:subC|c)har class=")(">)((?:B|b|Short b)ranches)/$1branches$2$3/g; # Branches
			s/(<(?:subC|c)har class=")(">)((?:B|b)ranchlets)/$1branchlets$2$3/g; # Branches
			s/(<(?:subC|c)har class=")(">)((?:A|a)xillary bud(?:|s))/$1axillary buds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)xtra-axillary bud(?:|s))/$1extra-axillary buds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)loral bud(?:|s))/$1floral buds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaf bud(?:|s))/$1leaf buds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)ature bud(?:|s))/$1mature buds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)erminal bud(?:|s))/$1terminal buds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)ud(?:|s))/$1buds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)uttresses)/$1buttresses$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)alyx)/$1calyx$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)arpels)/$1carpels$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)arpophore)/$1carpophore$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)aruncle)/$1caruncle$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b)asal cataphylls)/$1basal cataphylls$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c|longest c)ilia)/$1cilia$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c|with c|many c|without c|no c)olleters)/$1colleters$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)olumn)/$1column$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:c|with a c|with an apical c)oma)/$1coma$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)entral column)/$1central column$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)onnective)/$1connective$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)orolla)/$1corolla$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)ature corolla)/$1mature corolla$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:O|o)pen corolla)/$1open corolla$2$3/g;
			s/(<(?:subC|c)har class=")(">)(antipetalous corona lobes)/$1antipetalous corona lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)(alterni(?:ing|petalous) corona lobes)/$1alternipetalous corona lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c|small c)orona lobes)/$1corona lobes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c|with a c)orona)/$1corona$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)otyledons)/$1cotyledons$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)ystoliths)/$1cystoliths$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:|trunk )\d+-\d+ (?:|c)m dbh|trunk to \d+ cm dbh)/$1dbh$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:D|d|longitudinally d|Not d|not d)ehisc(?:ent|ing))/$1dehiscence$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:D|d|occasionally with d|hair-filled d|with or without d|without d)omatia)/$1domatia$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eaf(?:-| )domatia)/$1leaf domatia$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)uft(?:-| )domatia)/$1tuft domatia$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:D|d)ots)/$1dots$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:D|d)rupe(?:|s))/$1drupes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)taminal disc)/$1staminal disc$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:D|d)is(?:c|k))/$1disk$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)mbryo sack)/$1embryo sack$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)mbryo)/$1embryo$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)ndocarp)/$1endocarp$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)ndodermis)/$1endodermis$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)ndosperm formation)/$1endosperm formation$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)ndosperm)/$1endosperm$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)ndotheci(?:um|al cells))/$1endothecium$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)picalyx)/$1epicalyx$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)picalyx scales)/$1epicalyx scales$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)picarp)/$1epicarp$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e|the e)pidermis)/$1epidermis$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:E|e)xocarp)/$1exocarp$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ibre(?:|s))/$1fibres$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ig receptacle)/$1fig receptacle$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ig(?:|s))/$1figs$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ilament(?:|s))/$1filaments$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)laps)/$1flaps$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)carious flaps)/$1scarious flaps$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)lowering)/$1flowering$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)lowers numerous|many-flowered)/$1flower number$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:B|b|In b|in b)isexual flower(?:|s))/$1bisexual flowers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f|in f)emale flower(?:|s)|Female ‘flower(?:|s)’)/$1female flowers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m|in m)ale flower(?:|s)|Male ‘flower(?:|s)’)/$1male flowers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)ature flower(?:|s))/$1mature flowers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:O|o)pen flower(?:|s))/$1open flowers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)lower(?:|s)|‘Flowers’)/$1flowers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)oramen)/$1foramen$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f|With two f)ringed wing(?:|s))/$1fringed wings$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ruiting pedicel(?:|s))/$1fruiting pedicel$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ruiting perianth)/$1fruiting perianth$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)alse fruit(?:|s))/$1false fruits$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)mmature fruit(?:|s)|(?:Y|y)oung fruit(?:|s))/$1juvenile fruits$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)ature fruit(?:|s)|(?:R|r)ipe fruit(?:|s))/$1mature fruits$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ruit(?:|s))/$1fruits$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:W|w|the w)axy gland(?:|s|ular spots)|(?:N|n)odal glands)/$1glands$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:G|g|no g|few g|lacking g)lands)/$1glands$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:G|g)rain)/$1grain$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:G|g)rowth rings)/$1growth rings$2$3/g; # Wood
			s/(<(?:subC|c)har class=")(">)((?:G|g)ynoecium)/$1gynoecium$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:A|a|in a)pocarpous gynoeci(?:um|a))/$1apocarpous gynoecium$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s|in s)yncarpous gynoeci(?:um|a))/$1syncarpous gynoecium$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)nternal hairs)/$1hairs$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:H|h)air bases|dark dots \(corky hair bases\))/$1hair bases$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:H|h)eight)/$1height$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:H|h)ypanthium)/$1hypanthium$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:H|h)ypodermis)/$1hypodermis$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)seudo(?:|-)hypodermis)/$1pseudohypodermis$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)ndument(?:|um))/$1indumentum$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)emale inflorescence(?:|s))/$1female inflorescences$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)ale inflorescence(?:|s))/$1male inflorescences$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)nflorescence(?:|s))/$1inflorescences$2$3/g; # Inflorescences
			s/(<(?:subC|c)har class=")(">)(rhachis of inflorescence)/$1rhachis of inflorescence$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)nfructescence(?:|s))/$1infructescences$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)nternal bristles)/$1inner bristles$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)nternodes)/$1internodes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:|usually )with an interpetiolar ridge)/$1interpetiolar ridge$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:J|j)uvenile leaves)/$1juvenile leaves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:J|j)uvenile plant(?:|s)|(?:Y|y)oung plant(?:|s))/$1juvenile plants$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:J|j)uvenile part(?:|s)|(?:Y|y)oung(?:|est) part(?:|s))/$1juvenile parts$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l|producing white l|copious white l)atex)/$1latex$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)enticels|(?:|not |sparsely to densely |often sparsely |rarely |pale )lenticellate)/$1lenticels$2$3/g; # Bark
			s/(<(?:subC|c)har class=")(">)((?:L|l|the l)id)/$1lid$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l|the l|no l)igula)/$1ligula$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l|the l)ip)/$1lip$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ocules)/$1locules$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)ericarp(?:|s))/$1mericarps$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)esocarp(?:|s))/$1mesocarps$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m|the m)idrib)/$1midrib$2$3/g; # Leaves
			s/(<(?:subC|c)har class=")(">)((?:M|m)ilk(?:| )sap)/$1milk sap$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m|the m)outh)/$1mouth$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)itcher mouth)/$1pitcher mouth$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:N|n)ectaries)/$1nectaries$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:N|n)euter flowers)/$1neuter flowers$2$3/g; # Flowers
			s/(<(?:subC|c)har class=")(">)((?:N|n)erves)/$1nerves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)ntermediate nerves)/$1intermediate nerves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ateral nerves)/$1lateral nerves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ongitudinal nerves)/$1longitudinal nerves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)ennate nerves)/$1pennate nerves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:N|n)odes)/$1nodes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:O|o|with o)chrea)/$1ochrea$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:O|o)stiole)/$1ostiole$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:O|o)var(?:y|ies))/$1ovary$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:O|o|several o|many o|\d+ o)vule(?:|s))/$1ovules$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)apillae|(?:P|p)apillose)/$1papillae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p|male and female flowers with slender p)edicel(?:|s))/$1pedicels$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)eduncle(?:|s))/$1peduncle$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)onnate part of the peduncle(?:|s))/$1connate part of the peduncle$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)ree part of th peduncle(?:|s))/$1free part of the peduncle$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)artial peduncle(?:|s))/$1partial peduncles$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p|dry p)ericarp)/$1pericarp$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:F|f)emale perianth)/$1female perianth$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)ale perianth)/$1male perianth$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)erianth)/$1perianth$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p|the p)eristome)/$1peristome$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p|the p)etal(?:|s))/$1petals$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)eriderm)/$1periderm$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)etiole(?:|s))/$1petiole$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)etiolule(?:|s))/$1petiolule$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)hyllotaxy)/$1phyllotaxy$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)istillate flowers)/$1pistillate flowers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)istillate inflorescences)/$1pistillate inflorescences$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)istillode)/$1pistillode$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)istil)/$1pistil$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)itcher(?:|s))/$1pitchers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)nner pitcher(?:|s))/$1inner pitchers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)ntermediate pitcher(?:|s))/$1intermediate pitchers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ower pitcher(?:|s))/$1lower pitchers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ower and intermediate pitcher(?:|s))/$1lower and intermediate pitchers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:O|o)uter pitcher(?:|s))/$1outer pitchers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:U|u)nopened pitcher(?:|s))/$1unopened pitchers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:U|u)pper pitcher(?:|s))/$1upper pitchers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:Y|y)oung pitcher(?:|s))/$1juvenile pitchers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)mmature pollen)/$1immature pollen$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)ollen)/$1pollen$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)ollination)/$1pollination$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)rojection)/$1projection$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)rophyllum)/$1prophyllum$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)seudohilum)/$1pseudohilum$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r)aceme(?:|s))/$1racemes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r)adicle)/$1radicle$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r)ays)/$1rays$2$3/g; # Bark, Wood
			s/(<(?:subC|c)har class=")(">)((?:R|r)eceptacle)/$1receptacle$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r)esting buds)/$1resting buds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r)eticulation(?:|s))/$1reticulation$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r)etinacula)/$1retinacula$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r|each r)hipidium)/$1rhipidium$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r)oots)/$1roots$2$3/g; # Roots
			s/(<(?:subC|c)har class=")(">)((?:A|a)dventitious roots)/$1adventitious roots$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:P|p)rimary root(?:|s))/$1primary roots$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:|knee-shaped )pneumatophore roots)/$1pneumatophore roots$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r)osette)/$1rosettes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:R|r)ostrum)/$1rostrum$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)cars of(?:| the) leaves|(?:L|l)eaf scars)/$1leaf scars$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)cars of the petioles)/$1petiole scars$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)cars of the stipules|(?:S|s)tipule scars)/$1stipule scars$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)eedling(?:|s))/$1seedlings$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)eed(?:|s)|\d+-seeded)/$1seeds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:I|i)mmature seed(?:|s)|\d+-seeded)/$1immature seeds$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)epal(?:|s))/$1sepals$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:O|o)uter sepal(?:|s))/$1outer sepals$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)hoots)/$1shoots$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)limbing shoots)/$1climbing shoots$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:G|g)enerative shoot(?:|s))/$1generative shoots$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:H|h)orizontal shoot(?:|s))/$1horizontal shoots$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)hort(?:-| )shoots)/$1short shoots$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:V|v)ertical shoot(?:|s))/$1vertical shoots$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:Y|y)oung shoots)/$1juvenile shoots$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)padix)/$1spadix$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)pathe)/$1spathe$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)pathal sheath)/$1spathal sheath$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)pike(?:|s))/$1spikes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s|with s)pine(?:|s))/$1spines$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)pur(?:|s))/$1spurs$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)quamulae intravaginales)/$1squamulae intravaginales$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)talk(?:|s))/$1stalks$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)tamen(?:|s))/$1stamens$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)taminal column)/$1staminal column$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)taminate flowers)/$1staminate flowers$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)taminate inflorescences)/$1staminate inflorescences$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s|minutes s)taminode(?:|s))/$1staminodes$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)tem(?:|s))/$1stems$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:C|c)limbing stem(?:|s))/$1climbing stems$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ateral stem(?:|s))/$1lateral stems$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ive stem(?:|s))/$1live stems$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)ain stem(?:|s))/$1main stems$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)econd stem(?:|s))/$1second stems$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)hort stem(?:|s))/$1short stems$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)all stem(?:|s))/$1tall stems$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)tigma(?:|s))/$1stigma$2$3/g;
			s/(<(?:subC|c)har class=")(">)(stilt-roots)/$1stilt-roots$2$3/g; # Habit
			s/(<(?:subC|c)har class=")(">)((?:S|s)tipule-like appendages)/$1stipule-like appendages$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)tipules)/$1stipules$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s|short s)tyle head)/$1style head$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s|the s)tyle(?:|s))/$1style$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:S|s)ynandrium)/$1synandrium$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)egmen)/$1tegmen$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)endril(?:|s))/$1tendrils$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)epals)/$1tepals$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)ower tepals)/$1lower tepals$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)esta)/$1testa$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)hecae)/$1thecae$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)ip)/$1tip$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)runk)/$1trunk$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)ube)/$1tube$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:M|m)ature tube)/$1tube$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t|No t)urion)/$1turion$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l)eafy twigs)/$1leafy twigs$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:O|o)lder twigs)/$1older twigs$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:Y|y)oung twigs)/$1juvenile twigs$2$3/g; # Twigs
			s/(<(?:subC|c)har class=")(">)((?:T|t)wigs)/$1twigs$2$3/g; # Twigs
			s/(<(?:subC|c)har class=")(">)((?:U|u)tricle)/$1utricles$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:V|v)alves)/$1valves$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:V|v)ernation)/$1vernation$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:V|v)enation)/$1veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:L|l|basal l)ateral vein(?:|s))/$1lateral veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:T|t)ertiary(?:| and smaller) ve(?:nation|ins))/$1tertiary veins$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:W|w)ing)/$1wings$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:W|w)ood)/$1wood$2$3/g; # Wood
			s/(<(?:subC|c)har class=")(">)((?:S|s)apwood)/$1sapwood$2$3/g;
			s/(<(?:subC|c)har class=")(">)((?:H|h)eartwood)/$1heartwood$2$3/g;
		
		# Habit:
			s/(<(?:subC|c)har class=")(">)((?:Root-c|C|Large woody c|Large or medium woody c|Large or small woody c|Small or large c|Delicate c|Stout herbaceous annual c|Tall c|Terrestrial c)limber(?:|s)|(?:C|Ground c)reeper(?:|s)|Deciduous|Dioecious|(?:H|General h)abit|(?:H|Terrestrial or epilithic h|Aquatic h)erb|(?:L|Slender l)iana|(?:Large t|Small t|Large to small t|Small or big t|Small to medium-sized t|Medium-sized to big t|Medium to tall t|Tall t|T)ree(?:|s)|(?:Subs|S|Erect s|Climbing s|Small s|Terrestrial, monopodial s)hrub(?:|s)|Perennial(?:|s)|(?:A|Submerged a)nnual(?:|s)|Stout plant(?:|s)|Epiphytic|(?:Small|Large||Medium-sized|Medium-sized epiphytic|Terrestrial) fern(?:|s)|(?:A|a|Small a)quatic plants|Carnivorous|Terrestrial|Canopy epiphyte|Polymorphous)/$1habit$2$3/g;
		
		
		# classes covering various things:
			s/(<(?:subC|c)har class=")(">)((?:O|o|commonly o)pposite|terminal or axillary|(?:|completely )included|adnate to)/$1arrangement$2$3/g; # Arrangements
			s/(<(?:subC|c)har class=")(">)((?:|mid-)green|olivaceous|white|yellow|red|blue|(?:|dark |greenish|greenish \(dark\) )brown|black|purple|pink)(, )/$1appearance$2$3$4/g; # Appearance (color + texture, sometimes other information too)
			s/(<(?:subC|c)har class=")(">)((?:C|c)olour|olivaceous|(?:|mid-)green|white|yellow|red|blue|(?:|dark |greenish |greenish \(dark\) )brown|black|purple|pink)/$1colour$2$3/g; # Only colour
			s/(<(?:subC|c)har class=")(">)((?:|mostly )salverform|infundibuliform|campanulate|rotate|urceolate|(?:|mostly )petiolate|actinomorphic|zygomorphic|wide at base|ovoid\.|(?:|fusiform or )linear|base|apex|narrowed towards)/$1shape$2$3/g; # Shapes
			s/(<(?:subC|c)har class=")(">)(coriaceous|papery)/$1texture$2$3/g; # Textures
		
	}
	else {
	}
	print OUT $_;
}

close IN;
close OUT;