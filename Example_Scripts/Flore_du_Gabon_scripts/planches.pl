#!/usr/bin/perl
# planches.plx
# Ajoute les tags aux planches et cartes
# Note: Vu qu'il y a des formats divergents, le document doit etre controle pour etre sur que tous les tags ont ete ajoute. Ce controle peut etre fait vers la fin du processus de tagging, apres les autres scripts.
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Cartes:
	if (/^(Carte|carte|CARTE)/) {
		
		# Avec commentaire apres le numero de carte:
		s/(^)(Carte|carte|CARTE)( )(\d+)(\. — )(.+)/\t\t\t<figure id=\"\" type=\"lineart\" url=\"\">$2$3<num>$4<\/num>$5<figureLegend>$6<\/figureLegend><\/figure>/;
		
		# Sans commentaires apres le numero de carte:
		s/(^)(Carte|carte|CARTE)( )(\d+)/\t\t\t<figure id=\"\" type=\"lineart\" url=\"\">$2$3<num>$4<\/num><\/figure>/;
	}
	
	# Planches:
	# Format #1:
	if (/^(P(l|L)|F(IG|ig))\. /) {
		# Tags XML de base pour planches:
		s/(^)(Pl\. |PL\. |FIG\. |Fig\. )(\d+|[[:upper:]]+)(\. (?:—|—) )(.+)(|\.)($)/\t\t\t<figure id=\"\" type=\"lineart\" url=\"\">$2<num>$3<\/num>$4<figureLegend>$5$6<\/figureLegend><\/figure>/;
	}
	# Format #2:
	if (/^(P(LANCHE|lanche)|Figure) ([[:upper:]]|\d)+(|\.) /) {
		# Tags XML de base pour planches:
		s/(^)((?:P(?:LANCHE|lanche)|Figure) )((?:[[:upper:]]|\d)+)((?:|\.) )(.+)(|\.)($)/\t\t\t<figure id=\"\" type=\"lineart\" url=\"\">$2<num>$3<\/num>$4<figureLegend>$5$6<\/figureLegend><\/figure>/;
		
	}
	

	
	
	
	# Ajoute les tags XML  pour les collections mentiones dans les legendes de figures:
	if (/<figure id="" type="lineart"/) {
	
		# Format: (Staudt 510), (Jacques-Félix 2564), (Jean Louis 616), (A. Chevalier 27023), (Le T. 7504), (Jacques-Félix 2407 bis), (N. Hallé 779, in vivo), et aussi "nom" + "s.n." ou "s. n.":
		s/(\()([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(\)|, in vivo\))/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5/g;
		
		# Format:(de 1 à 8, N. Hallé 779, in vivo)
		s/(\(de \d+ [[:lower:]] \d+, )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(|, in vivo\))/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5/g;
		
		# Format: (Le Testu 8240 et Klaine 38):
		s/(\(|, )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)( (?:et|&) )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(\))/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5<gathering><collector>$6<\/collector><fieldNum>$8<\/fieldNum><\/gathering>$9/g;
		
		
		# Format: (Le Testu 159, Dahomey), (A. Chev. 22442, Côte-d'Ivoire) etc.:
		s/(\()([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(, )([[:upper:]]\w+|[[:upper:]](?:\w+(?:|\.)|\.)(?: |-(?:|d'))[[:upper:]]\w+(?:|\.))(\))/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><locality class="">$6<\/locality><\/gathering>$7/g;
		
		
		# Format: (fleur, Tisserant 168):
		s/(\([[:lower:]]\w+, )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(\)|, in vivo\))/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5/g;
		
		# Format: (fleur, Tisserant 168; feuille, Le Testu 8260; fruit, Tisserant 1719), (feuille, Le Testu 7054; fruit, Klaine 2714; fleurs, Le Testu 7054 ♂‚ et 9093 hermaphrodite):
		s/([[:lower:]]\w+, )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(|, in vivo)/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5/g;
		# Note: N'utilise pas les parentheses dans le format. 
		
		# Format: (1, Klaine 830 G; 2 et 3, Kl. 830 A; 4, Kl. 1348), (1 et 3, Le Testu 8505; 2, 4, 5 et 7, Le T. 6072; 6, Le T. 1845; 8 et 9, Welwitsch 1202; 10 et 11, Tisserant 2427), (1-2: Le Testu 9527; 3-5: Leeuwenberg 5211):
		s/(\d+(?:|'|")(?:| p\.p\.)|\d+(?:|'|") et \d+(?:|'|")|\d+(?:|'|")-\d+(?:|'|")|(?:\d+(?:|'|"), )+\d+(?:|'|") et \d+(?:|'|")|[[:lower:]](?:|-[[:lower:]])|[[:upper:]](?:|-[[:upper:]]|(?:, [[:upper:]])+))((?:,|:) )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(; |\)|, in vivo\))/$1$2<gathering><collector>$3<\/collector><fieldNum>$5<\/fieldNum><\/gathering>$6/g;
		
		# Format precedents avec deux specimens: (3-5: Klaine 1231 et 1410):
		s/(\d+(?:|'|")(?:| p\.p\.)|\d+(?:|'|") et \d+(?:|'|")|\d+(?:|'|")-\d+(?:|'|")|(?:\d+(?:|'|"), )+\d+(?:|'|") et \d+(?:|'|")|[[:lower:]](?:|-[[:lower:]])|[[:upper:]](?:|-[[:upper:]]|(?:, [[:upper:]])+))((?:,|:) )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)( et )(\d\d+(?:| bis)|s\.(?:| )n\.)(; |\)|, in vivo\))/$1$2<gathering><collector>$3<\/collector><fieldNum>$5<\/fieldNum><\/gathering><gathering><collector>$3<\/collector><fieldNum>$7<\/fieldNum><\/gathering>$8/g;
		
		# Format: (1 et 3, Le Testu 8505, Cameroun; 2, 4, 5 et 7, Le T. 6072, Afrique), donc les formats precedents suivi d'un lieu:
		s/(\d+(?:|'|")(?:| p\.p\.)|\d+(?:|'|") et \d+(?:|'|")|\d+(?:|'|")-\d+(?:|'|")|(?:\d+(?:|'|"), )+\d+(?:|'|") et \d+(?:|'|")|[[:lower:]](?:|-[[:lower:]])|[[:upper:]](?:|-[[:upper:]]|(?:, [[:upper:]])+))((?:,|:) )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(, )([[:upper:]]\w+|[[:upper:]](?:\w+(?:|\.)|\.)(?: |(?:-| )(?:|d'))[[:upper:]]\w+(?:|\.))(; |\)|, in vivo\))/$1$2<gathering><collector>$3<\/collector><fieldNum>$5<\/fieldNum><locality class="">$7<\/locality><\/gathering>$8/g;
		
		# Format: (1 et 3, d'après Le Testu 8505, Cameroun; 2, 4, 5 et 7, Le T. 6072, Afrique), donc les formats precedents suivi d'un lieu + d'après:
		s/(\d+(?:|'|")(?:| p\.p\.)|\d+(?:|'|") et \d+(?:|'|")|\d+(?:|'|")-\d+(?:|'|")|(?:\d+(?:|'|"), )+\d+(?:|'|") et \d+(?:|'|")|[[:lower:]](?:|-[[:lower:]])|[[:upper:]](?:|-[[:upper:]]|(?:, [[:upper:]])+))((?:,|:) )(d'après [[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(, )([[:upper:]]\w+|[[:upper:]](?:\w+(?:|\.)|\.)(?: |(?:-| )(?:|d'))[[:upper:]]\w+(?:|\.))(; |\)|, in vivo\))/$1$2<gathering><collector>$3<\/collector><fieldNum>$5<\/fieldNum><locality class="">$7<\/locality><\/gathering>$8/g;
		
		# Format: (1 et 3, d'après Le Testu 8505, Cameroun; 2, 4, 5 et 7, Le T. 6072, Afrique), donc les formats precedents suivi d'un lieu + code herbarium + d'après:
		s/(\d+(?:|'|")(?:| p\.p\.)|\d+(?:|'|") et \d+(?:|'|")|\d+(?:|'|")-\d+(?:|'|")|(?:\d+(?:|'|"), )+\d+(?:|'|") et \d+(?:|'|")|[[:lower:]](?:|-[[:lower:]])|[[:upper:]](?:|-[[:upper:]]|(?:, [[:upper:]])+))((?:,|:) )(d'après [[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(, )([[:upper:]]\w+|[[:upper:]](?:\w+(?:|\.)|\.)(?: |(?:-| )(?:|d'))[[:upper:]]\w+(?:|\.))(, )([[:upper:]]+)(; |\)|, in vivo\))/$1$2<gathering><collector>$3<\/collector><fieldNum>$5<\/fieldNum><locality class="">$7<\/locality><collectionAndType>$9<\/collectionAndType><\/gathering>$8/g;
		
		
		
		
		# Format: (1. Klaine 830 G; 2 et 3. Kl. 830 A; 4. Kl. 1348), (1 et 3. Le Testu 8505; 2, 4, 5 et 7. Le T. 6072; 6. Le T. 1845; 8 et 9. Welwitsch 1202; 10 et 11. Tisserant 2427):
		s/(\d+(?:| p\.p\.)|\d+ et \d+|\d+-\d+(?:|')|(?:\d+, )+\d+ et \d+)(\. )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(; |\)|, in vivo\))/$1$2<gathering><collector>$3<\/collector><fieldNum>$5<\/fieldNum><\/gathering>$6/g;
		
		# Format: (1 et 3. Le Testu 8505, Cameroun; 2, 4, 5 et 7. Le T. 6072, Afrique), donc les formats precedents suivi d'un lieu:
		s/(\d+(?:| p\.p\.)|\d+ et \d+|\d+-\d+(?:|')|(?:\d+, )+\d+ et \d+)(\. )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(, )([[:upper:]]\w+|[[:upper:]](?:\w+(?:|\.)|\.)(?: |-(?:|d'))[[:upper:]]\w+(?:|\.))(; |\)|, in vivo\))/$1$2<gathering><collector>$3<\/collector><fieldNum>$5<\/fieldNum><locality class="">$7<\/locality><\/gathering>$8/g;
		
		
		
		
		# Formats de collections restants pour tagging automatise:
		
		# Format: (Soyaux 350, Cameroun, 
		s/(\(|\(successivement )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(, )([[:upper:]]\w+|[[:upper:]](?:\w+(?:|\.)|\.)(?: |-(?:|d'))[[:upper:]]\w+(?:|\.))(, )/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><locality class="">$6<\/locality><\/gathering>$7/g;
		
		# Format: (Soyaux 350, 
		s/(\(|\(successivement )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(, )/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5/g;
		
		#Format: ; Soyaux 350,
		s/(; )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(, )/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5/g;
		
		
		# Format:  et Leeuwenberg 1881, Cameroun)
		s/( et )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(, )([[:upper:]]\w+|[[:upper:]](?:\w+(?:|\.)|\.)(?: |-(?:|d'))[[:upper:]]\w+(?:|\.))(\)|, in vivo\) )/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><locality class="">$6<\/locality><\/gathering>$7/g;
		
		# Format:  et Leeuwenberg 1881)
		s/( et )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(\)|, in vivo\) )/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5/g;
		
		# Format: ", Leeuwenberg 1881, " et ", Leeuwenberg 1881 et ":
		s/(, )([[:upper:]]\w+|[[:upper:]](?:\w+|\.)(?: |-)[[:upper:]](?:\w+(?:|\.)|\.))( )(\d\d+(?:| bis)|s\.(?:| )n\.)(, | et )/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5/g;
		
		
		
			
		# Deplace le "d'après" vers une meilleure position:
		s/(<collector>)(d'après )(.+?<\/collector>)/$2$1$3/g;
		
		
	}
	
	# References aux planches dans le texte:
	# Versions sur ligne separee:
	elsif (/^\((Cf|cf)\. (Pl|PL|Fig|FIG)\./) {
		# Format: "(Cf. Pl. 5, p.12)"
		s/(^)(\((?:Cf|cf)\. (?:Pl|PL|Fig|FIG)\. )(\d+)(.+\)(?:|\.))($)/\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/;
	}
	
	elsif (/^P(l\.|L) /) {
		
		
		
		# Format "Pl. 19, 12-18, p. 127, et CARTE 36, p. 177."
		s/(^)(P(?:l\.|L) )(\d+)(.+(?:|\.))(, et )(CARTE )(\d+)(.+(?:|\.))($)/\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>\n\t\t\t<figureRef ref="">$6<num>$7<\/num>$8<\/figureRef>/;
		
		
		# Format "Pl. 19, 12-18, p. 127"
		s/(^)(P(?:l\.|L) )(\d+)(.+(?:|\.))($)/\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/;
		
		
		
	}
	
	# Version en fin de ligne #1:
	elsif (/ — (Cf|cf)\. (Pl|PL|Fig|FIG)/) {
		# Format " — CF. Pl. 5, p. 12"
		s/( — )((?:Cf|cf)\. (?:Pl|PL|Fig|FIG)(?:|\.) )(\d+)(.+)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/;
	}
	
	# Version en fin de ligne #2:
	elsif (/ — (Pl|PL|Fig|FIG)(|\.) \d+/) {
		
		# Format "— Pl. 1, 1-7, p. 9."
		s/( — )((?:Pl|PL|Fig|FIG)(?:|\.) )(\d+)(.+)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/;
		
		
	}
	
	# Version en fin de ligne #3:
	elsif (/\((Pl|PL|Fig|FIG)\. (\d+|[IVLMC]+)/) {
		
		# Format " (PL. 2)"
		s/( \()((?:Pl|PL|Fig|FIG)(?:|\.) )(\d+|[IVLMC]+)(\)(?:| |\.|\. ))($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><\/figureRef>/;
		
		# Format " (Pl. 4 et 5)."
		s/( \()((?:Pl|PL|Fig|FIG)(?:|\.) )(\d+|[IVLMC]+)( et )(\d+)(\)(?:| |\.|\. ))($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><\/figureRef>\n\t\t\t<figureRef ref="">$2<num>$5<\/num><\/figureRef>/;
		
		
		
		# Format " (PL. 1, p. 1; 3 p. 31)"
		s/( \()((?:Pl|PL|Fig|FIG)(?:|\.) )(\d+|[IVLMC]+)((?:|,) p\. \d+)(\; )(\d+)((?:|,) p\. \d+)(\)(?:| |\.|\. ))($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>\n\t\t\t<figureRef ref="">$2<num>$6<\/num>$7<\/figureRef>/;
		
		# Format " (FIG. 3 p. 178)"
		s/( \()((?:Pl|PL|Fig|FIG)(?:|\.) )(\d+|[IVLMC]+)((?:|,) p\. \d+)(\)(?:| |\.|\. ))($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/;
		
		
		
		
		# Format " (PL. 10, 9)" ou " (Pl. 27 f. 12)"
		s/( \()((?:Pl|PL|Fig|FIG)(?:|\.) )(\d+|[IVLMC]+)((?:,| f\.) .+)(\)(?:| |\.|\. ))($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/;
		
		
		
	
		
	}
	# Version en fin de ligne #4:
	elsif (/P(l\.|L) \d+(|, (\d+(|-\d+)|[[:upper:]])| et \d+)(|'|"), p\. \d+(|\.| et \d+(|\.))$/) {
		
		# Format: "Pl. 4, p. 19."
		s/((?:Pl|PL)(?:|\.) )(\d+|[IVLMC]+)((?:|,) p\. \d+)(?:| |\.|\. )($)/\n\t\t\t<figureRef ref="">Pl. <num>$2<\/num>$3<\/figureRef>/;
		
		
		# Format: "Pl. 1 et 2, p. 16 et 17."
		s/((?:Pl|PL)(?:|\.) )(\d+|[IVLMC]+)( et )(\d+)((?:|,) p\. \d+)( et )(\d+)(?:| |\.|\. )($)/\n\t\t\t<figureRef ref="">Pl. <num>$2<\/num>$5<\/figureRef>\n\t\t\t<figureRef ref="">Pl. <num>$4<\/num>, p.$7<\/figureRef>/;
		
		
		# Format: "PL 3, 4-5, p. 18." et "Pl. 5, 7, p. 21."
		s/((?:Pl|PL)(?:|\.) )(\d+|[IVLMC]+)(, (?:\d+(?:|-\d+(?:|'|"))|[[:upper:]]))((?:|,) p\. \d+)(?:| |\.|\. )($)/\n\t\t\t<figureRef ref="">Pl. <num>$2<\/num>$3$4<\/figureRef>/;
		
		
	
	}
	
	# Version en fin de ligne #5:
	elsif (/^(MATERIEL ETUDIE|MATÉRIEL ÉTUDIÉ)/) {
		
		# Format: "MATERIEL ETUDIE (Carte 56):"
		s/(Carte )(\d+)/<figureRef ref="">$1<num>$2<\/num><\/figureRef>/;
		
		
		
	}
	
	# Version en fin de ligne #6:
	elsif (/(Planche \d+(|\: [[:upper:]](?:|–[[:upper:]])| \(.+\)(|, \d+)|, Figure \d+(|[[:lower:]]))|Figure \d+[[:lower:]](| \(page \d+\)))$/) {
		
		
		# Format "Planche 4"
		s/( )(Planche )(\d+)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><\/figureRef>/;
		
		# Format "Planche 4: K" ou "Planche 4: K-M"
		s/( )(Planche )(\d+)(: [[:upper:]](?:|–[[:upper:]]))($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/;
		
		
		# Format "Planche 12 (1–3, 5, 6)"
		s/( )(Planche )(\d+)( \()(\d+(?:, |-)\d+(?:|.+)|[[:upper:]](?:-|, )[[:upper:]])(\))($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>, $5<\/figureRef>/;
		
		# Format "Planche 12 (1)" ou "Planche 10 (D)"
		s/( )(Planche )(\d+)( \()(\d+|[[:upper:]])(\))($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>, $5<\/figureRef>/;
		
		
		# Format "Planche 23 (2), 24"
		s/( )(Planche )(\d+)( \()(\d+|[[:upper:]])(\))(, )(\d+)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>, $5<\/figureRef>\n\t\t\t<figureRef ref="">$2<num>$8<\/num><\/figureRef>/;
		
		
		# Format "Planche 142, Figure 30"
		s/( )(Planche )(\d+)(, )(Figure )(\d+)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><\/figureRef>\n\t\t\t<figureRef ref="">$5<num>$6<\/num><\/figureRef>/;
		
		# Format "Planche 1, Figure 1a"
		s/( )(Planche )(\d+)(, )(Figure )(\d+)([[:lower:]])($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><\/figureRef>\n\t\t\t<figureRef ref="">$5<num>$6<\/num>$7<\/figureRef>/;
		
		# Format "Planche 113 (1-4), Figure 19b"
		s/( )(Planche )(\d+)( \()(\d+(?:, |-)\d+(?:|.+)|[[:upper:]](?:-|, )[[:upper:]])(\))(, )(Figure )(\d+)([[:lower:]])($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$5<\/figureRef>\n\t\t\t<figureRef ref="">$8<num>$9<\/num>$10<\/figureRef>/;
		
		
		# Format "Figure 3b"
		s/( )(Figure )(\d+)([[:lower:]])($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/;
		
		# Format "Figure 3b (page 21)"
		s/( )(Figure )(\d+)([[:lower:]] .+)($)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/;
		
		
		
	}
	
	# Versions dans cle:
	
	elsif (/\t+<(toTaxon|text)>/) {
		
		# Format: "Pl. 10 A, p. 56"
		s/((?:pl|Pl|PL|Fig|FIG)(?:\.|) )(\d+)((?:|,) (?:[[:upper:]]|fig\. (?:\d+(?:-|, )\d+|[[:lower:]](?:-|, )[[:lower:]]|[[:lower:]])), p\. \d+)/<figureRef ref="">$1<num>$2<\/num>$3<\/figureRef>/g;
		
		# Format: "Pl. 10 A"
		s/((?:pl|Pl|PL|Fig|FIG)(?:\.|) )(\d+)((?:|,) (?:[[:upper:]]|fig\. (?:\d+(?:-|, )\d+|[[:lower:]](?:-|, )[[:lower:]]|[[:lower:]])))/<figureRef ref="">$1<num>$2<\/num>$3<\/figureRef>/g;
		
		# Format: "Pl. 10"
		s/((?:pl|Pl|PL|Fig|FIG)(?:\.|) )(\d+)/<figureRef ref="">$1<num>$2<\/num><\/figureRef>/g;
		
		
	}
	
	
	# Versions dans texte:
	elsif (/\((P|p)(L|l)|Fig|FIG(|\.) \d+(|, \d+|, \d+ à \d+ p\. \d+)\)/) {
		
		# Format " (PL. 2)"
		s/( \()((?:pl|Pl|PL|Fig|FIG)(?:|\.) )(\d+)(\)(?: |\. |;))/$1<figureRef ref="">$2<num>$3<\/num><\/figureRef>$4/g;
		
		
		
		# Format " (PL 14, 9)" ou " (PL 24, 6 à 9 p. 127)"
		s/( \()((?:pl|Pl|PL|Fig|FIG)(?:|\.) )(\d+)(, .+?)(\)(?: |\.|\. |;|,))/$1<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>$5/g;
		
		
		
	}
	
	
	else {
	}
	
	# Standardisation de "Pl."
	s/((?:<figureRef ref="">|<figure id="" type="lineart" url="">))(P|p)(l|l\.|L|L\.)(| )( <num>)/$1Pl. $5/g;
	s/Pl\.  /Pl. /g;
	
	
	# Ajoute les tags XML pour les parties de planches des references:
	if (/<figureRef ref="">/) {
	
		
		s/(<figureRef ref="">.+<num>.+<\/num>(?:|,|:) )(fig\. [[:lower:]]|[[:upper:]](?:-|, )[[:upper:]]|[[:upper:]])(<\/figure)/$1<figurePart>$2<\/figurePart>$3/g;
		s/(<figureRef ref="">.+<num>.+<\/num>(?:|,) )(fig\. [[:lower:]], [[:lower:]])(<\/figure)/$1<figurePart>$2<\/figurePart>$3/g;
		s/(<figureRef ref="">.+<num>.+<\/num>(?:|,) )((?:|fig\. )\d+(?:-| à | et )\d+|(?:|fig\. )\d+, \d+|fig\. (?:A|B)|fig\. [[:lower:]]-[[:lower:]]|fig\. [[:lower:]], [[:lower:]]|fig\. [[:lower:]]|[[:upper:]](?!i))((?:|,).+)/$1<figurePart>$2<\/figurePart>$3/g;
		
		s/(<figureRef ref="">.+<num>.+<\/num>, )((?:|fig\. )\d+(?:-| à )\d+|(?:|fig\. )\d+, \d+|fig\. (?:A|B)|(?:|fig\. )\d+)((?:|,) .+)/$1<figurePart>$2<\/figurePart>$3/;
		s/(<figureRef ref="">.+<num>.+<\/num>, )((?:|fig\. )\d+(?:-| à )\d+|(?:|fig\. )\d+, \d+|fig\. (?:A|B)|(?:|fig\. )\d+)((?:|,).+)/$1<figurePart>$2<\/figurePart>$3/;
		s/(<figureRef ref="">.+<num>.+<\/num> )((?:f\. |fig\. )\d+(?:-| à )\d+|(?:f\. |fig\. )\d+, \d+|(?:f\. |fig\. )(?:A|B)|(?:f\. |fig\. )\d+)((?:|,) .+)/$1<figurePart>$2<\/figurePart>$3/;
		s/(<figureRef ref="">.+<num>.+<\/num> )((?:f\. |fig\. )\d+(?:-| à )\d+|(?:f\. |fig\. )\d+, \d+|(?:f\. |fig\. )(?:A|B)|(?:f\. |fig\. )\d+)((?:|,).+)/$1<figurePart>$2<\/figurePart>$3/;
		
		s/(<figureRef ref="">.+<num>.+<\/num>)([[:lower:]])(<\/figure)/$1<figurePart>$2<\/figurePart>$3/g;
		s/(<figureRef ref="">.+<num>.+<\/num>)([[:lower:]])( .+<\/figure)/$1<figurePart>$2<\/figurePart>$3/g;
		
		
		# Deplace le ' ou " vers la location correcte:
		s/(<\/figurePart>)("|')/$2$1/;
		
		
		
	}
	
	
	print OUT $_;
}

close IN;
close OUT;