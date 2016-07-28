#!/usr/bin/perl
# figures.pl
# Adds mark-up to figures and figure references
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Figure mark up:

	# Actual figures and their legends:
	if (/^(Fig\.|Map|Plate) \d+(a|b|)(\.|:| \([[:upper:]]-[[:upper:]]\)\.| [[:upper:]]-[[:upper:]]\.| [[:upper:]]\.) /) {
		# Basic figure mark-up:
		s/(^)((?:Fig\.|Map|Plate) )(\d+(?:a|b|))(\. |: )(.+)(\.)($)/\t\t\t<figure id=\"\" type=\"\">$2<num>$3<\/num>$4<figureLegend>$5$6<\/figureLegend><\/figure>/;
		s/(^)((?:Fig\.|Map|Plate) )(\d+(?:a|b|))( )((?:\([[:upper:]]-[[:upper:]]\)|[[:upper:]]-[[:upper:]]|[[:upper:]]).+)(\.)($)/\t\t\t<figure id=\"\" type=\"\">$2<num>$3<\/num>$4<figureLegend>$5$6<\/figureLegend><\/figure>/;
		
		# Gatherings mark-up:
			
			# Matches collectors + numbers only:
			s/((?:Acevedo-Rdgz\.(?:& Angell| et al\.)|Alencar|Anderson|Appun|Baker|Berti|Broadway|Brothers|Bunting|Campbell et al\.|Cid(?: & Lima|)|Clarke|Cremers|D'Arcy|Daly et al\.|Davidse|de Granville|de la Cruz|Delprete|Diaz and Jiménez|Dick|Ducke|Dunlap|Duno|Feuillet|Forest Dept\. (?:British Guiana|BG)|Gentry|Gillespie|Görts-van Rijn|Grández & Ruiz|Hatchbach|Henderson et al\.|(?:Hoffman & |)Henkel|Hoffman|Irwin(?: et al\.|)|Jansen-Jacobs|Jonker-Verhoef & Jonker|Kubitzki|Lance|Liesner|Maas|(?:Steyermark & |)Maguire(?: & Politi|)|Mori(?: & Bolton| & Boom| and Gracie| and Veyret|)|Mutchnick|Nelson|Oldeman|Palmer|Phillipe et al\.|Pipoly(?: & Gharbarran|)|Prance(?: et al\.|)|Pulle|Rebinds|Ribeiro|Skog(?: & Harvel| and Feuillet)|A.C. Smith|Smith|Spruce|Stergios(?: & Aymard|)|Steyermark|Tate|Thomas et al\.|Uw|Wessels Boer|Westra|Wurdack(?: & Adderley|))(?:| et al\.))(?: )((?:[[:upper:]]+|)\d+|s\.n\.)/<gathering><collector>$1<\/collector><fieldNum>$2<\/fieldNum><\/gathering>/g;
			
			
			# Adds mark-up by matching figure parts (3 options), collector name, space, field number, separator:
			s/([[:upper:]](?:-[[:upper:]]|(?:, [[:upper:]])+|), )([[:upper:]][[:upper:][:lower:] &,]+(?:|et al\.))( )(\d+|s\.n\.)(;|\))/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5/g;
			
			
			# For those gatherings with herbarium code etc. present:
			s/(<\/gathering>)( )(\(((?:type|NY|US)\)))/<collectionAndType>$3<\/collectionAndType>$1/g;
			
			
			# For those gatherings with localities present:
			s/(<\/gathering>)(, )(from [[:upper:]][[:lower:]]+)/<locality class="">$3<\/locality>$1/g;
			

	}
	# References to figures:
	elsif (/( |)— (Fig\. |Figs\. |Map |Maps |Plate |Plates )/) {
	
		# Simple figure reference formats that do not require splitting of figure references:
		# Marks up figure references of the format " — Fig. 1.":
		s/( — )(Fig\. |Map |Plate )(\d+)(?:\.|)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/g;
		# Marks up figure references of the format " — Fig. 1." on separate line:
		s/(^— )(Fig\. |Map |Plate )(\d+)($)/\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/g;
		# Marks up figure references of the format " — Fig. 1; Map 1.":
		s/( — )(Fig\. )(\d+)(; )((?:Map|Plate) )(\d+)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>\n\t\t\t<figureRef ref="">$5<num>$6<\/num>$7<\/figureRef>/g;
		
		# Marks up figure references of the formats " — Fig. 1a.", " — Fig. 1a-c.", " — Fig. 1 A-C", " — Fig. 1(A-C)" etc.:
		s/( — )(Fig\. |Figs\. |Map |Maps |Plate |Plates )(\d+)(?: |)([[:lower:]]|[[:lower:]]-[[:lower:]]|(?:\(|)[[:upper:]](?:\)|)|(?:\(|)[[:upper:]]-[[:upper:]](?:\)|))($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>/g;
		# Marks up figure references of the formats " — Fig. 1a.", " — Fig. 1a-c.", " — Fig. 1 A-C", " — Fig. 1(A-C)" etc. on separate line:
		s/(^— )(Fig\. |Figs\. |Map |Maps |Plate |Plates )(\d+)(?: |)([[:lower:]]|[[:lower:]]-[[:lower:]]|(?:\(|)[[:upper:]](?:\)|)|(?:\(|)[[:upper:]]-[[:upper:]](?:\)|))($)/\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>/g;
		# Marks up figure references of the format " — Fig. 1a; Map 1.", "Fig. 1a-c; Map 1.":
		s/( — )(Fig\. |Figs\. )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(; )((?:Map|Plate) )(\d+)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>\n\t\t\t<figureRef ref="">$6<num>$7<\/num>$8<\/figureRef>/g;
		# Marks up figure references of the format "" — Fig. 1a; Map 1a.", "Fig. 1a-c; Map 1a-c." and all mixes:
		s/( — )(Fig\. |Figs\. )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(; )((?:Map|Plate) )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>\n\t\t\t<figureRef ref="">$6<num>$7<\/num><figurePart>$8<\/figurePart>$9<\/figureRef>/g;
		
		# Marks up figure references of the format " — Fig. 1a, c, f.", " — Fig. 1a-c, f-h.", and all mixes:
		s/( — )(Fig\. |Figs\. |Map |Maps |Plate |Plates )(\d+)(([[:lower:]]|[[:lower:]]-[[:lower:]])(, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>\.<\/figureRef>/g;
		# Marks up figure references of the format " — Fig. 1a, c, f; Map 1.", " — Fig. 1a-c, f-h; Map 1.", and all mixes:
		s/( — )(Fig\. |Figs\. )(\d+)((?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(; )((?:Map|Plate) )(\d+)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>\n\t\t\t<figureRef ref="">$6<num>$7<\/num>$8<\/figureRef>/g;
		
		# Marks up figure references of the format " — Plate 3. 6-10.":
		s/( — )(Plate )(\d+)(\. )(\d+-\d+)(\.)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<figurePart>$5<\/figurePart>$6<\/figureRef>/g;
		# Marks up figure references of the format " — Fig. 27 (3).":
		s/( — )(Fig\. )(\d+)( \()(\d+)(\)\.)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<figurePart>$5<\/figurePart>$6<\/figureRef>/g;
		
		# Marks up figure references of the format " — Figs. 3 and 4" and " — Plate 3 and 4":
		s/( — )(Fig(?:s|)\. |Plate )(\d+)( and )(\d+)(\.|)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$6<\/figureRef>\n\t\t\t<figureRef ref="">$2<num>$5<\/num>$6<\/figureRef>/g;
		
		
		
		# Complicated (so to speak) reference formats that do require splitting of figure references:
		if (/ — (Figs\.|Fig\.) \d+(,|-|[[:lower:]];|[[:lower:]],|[[:lower:]]-[[:lower:]];)/) {
			# Puts figure line of formats mentioned one line earlier on separate line:
			s/( — )(Fig(?:|s)\. )(.+)($)/\n\t\t\t<figureRef ref="">Fig\. <num>$3<\/num><\/figureRef>$4/;
			# Splits individual figures, using look-ahead as security check:
			s/(\d+)(, | and )(?=\d+)/$1<\/num>\.<\/figureRef>\n\t\t\t<figureRef ref="">Fig\. <num>/g;
			# Splits figures with references to figureparts:
			s/(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]]|([[:lower:]]|[[:lower:]]-[[:lower:]])(, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(; )(?=\d+)/$1$2<\/num>\.<\/figureRef>\n\t\t\t<figureRef ref="">Fig\. <num>/g;
			# Marks up figureparts:
			s/(<figureRef ref="">Fig. <num>\d+)([[:lower:]]|[[:lower:]]-[[:lower:]]|([[:lower:]]|[[:lower:]]-[[:lower:]])(, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(<\/num>\.<\/figureRef>)/$1<figurePart>$2<\/figurePart>$5/g;
			
			# Fixes dot on wrong place:
			s/(<num>\d+)(\.)(<\/num>)/$1$3$2/g;
		}
		

	}
	
	else {
	}
	print OUT $_;
}

close IN;
close OUT;