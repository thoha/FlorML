#!/usr/bin/perl
# features.plx
# Ajoute la plupart des tags aux features

use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	
	# Separe types et literature:
	s/(\.)( )((?:|LECTO|SYN)TYPE(?:|S):)/$1\n$3/;
	
	
	# Auteurs de textes taxonomiques:
	s/(^)(par: [[:lower:][:upper:]\. &†-]+)/\t\t\t<writer>$2<\/writer>/;
	
	
	
	# Listes de references aux grandes bibliographies (vol. 38+):
	s/(^)(BIBLIOGRAPHIE:)( .+)($)/\t\t\t<references><heading>$2<\/heading>$3<\/references>/;
	
	
	
	
	# Noms vernaculaires:
	s/(^)(Nom(?:|s) vernaculaire(?:|s)(?:| gabonais)|Nom(?:|s) vulgaire(?:|s)|Nom(?:|s) vernac)(\.|:)(.+)($)/$1\t\t\t<feature class="vernacular">\t\t\t\t<string><subHeading>$2$3<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	s/(^)(NOM(?:|S) VERNACULAIRE(?:|S)(?:| GABONAIS)|NOM (?:FANG|GABONAIS)|NOM(?:|S) USUEL(?:|S)|NOM(?:|S) LOCAL(?:|S))(\.|:)(.+)($)/$1\t\t\t<feature class="vernacular">\t\t\t\t<string><subHeading>$2$3<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Noms vernaculaires \(.+\):)(.+)($)/$1\t\t\t<feature class="vernacular">\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)((?:Noms relevés par Walker et Sillans|Noms vernaculaires, d'après l'abbé Walker \(in shed.\)|Nom vern\.|Noms vernaculaires des bananes à consommer crues, en général|Cette espèce, est signalée comme commune au Gabon par Walker et Sillans, avec le nom vernaculaire suivant|Noms vernaculaires d'après Walker et Sillans|Deux noms vernaculaires|Nom Bakota non contrôlé|Nom Bakota):)(.+)($)/$1\t\t\t<feature class="vernacular">\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Aucun nom vernaculaire|Le(?:|s) nom(?:|s) vernaculaire(?:|s)|Nom(?:|s) vernaculaire(?:|s)|Très peu de noms vernaculaires)(.+)($)/$1\t\t\t<feature class="vernacular">\t\t\t\t<string>$2$3<\/string>\n\t\t\t<\/feature>/;
	
	# Noms commercials:
	s/(^)(Nom(?:|s) commercial(?:|s))(\.|:)(.+)($)/$1\t\t\t<feature class="commercial names">\t\t\t\t<string><subHeading>$2$3<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	
	
	
	
	# Utilisation:
	s/(^)(Utilisation|Usage|Thérapeutique|USAGE)(|s|S)(\.|:)(.+)($)/$1\t\t\t<feature class="uses">\n\t\t\t\t<string><subHeading>$2$3$4<\/subHeading>$5<\/string>\n\t\t\t<\/feature>/;
	
	
	# Matériel étudié:
	# Reparation si le double-point manque:
	s/(^)((?:Autre matériel|Autres spécimens|Matériel|Spécimens)(?:| gabonais) étudié(?:|s|du (?:G|g)abon))($)/$1$2:/;
	
	# Version avec materiel qui suit directement:
	s/(^)((?:Autre matériel|Autres spécimens|Matériel|Spécimens)(?:| gabonais) étudié(?:|s|.+?)(?:\.|:))( )(.+)($)/$1\t\t\t<feature class="specimens">\n\t\t\t\t<string><subHeading>$2<\/subHeading><br \/>\n$4<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Matériel d'herbier gabonais(?:\.|:)|MATERIEL (?:CAMEROUNAIS|GABONAIS)(?: ETUDIE|):|(?:É|E)chantillon(?:|s):|AUTRE(?:|S) SPECIMEN(?:|S) (?:ETUDIE(?:|S)|GABONAIS):|MATERIEL ETUDIE POUR LE GABON:)( )(.+)($)/$1\t\t\t<feature class="specimens">\n\t\t\t\t<string><subHeading>$2<\/subHeading><br \/>\n$4<\/string>\n\t\t\t<\/feature>/;
	# Version avec materiel qui suit directement: Seul matériel étudié,
	s/(^)(Seul matériel étudié)(, )(.+)($)/$1\t\t\t<feature class="specimens">\n\t\t\t\t<string><subHeading>$2:<\/subHeading><br \/>\n$4<\/string>\n\t\t\t<\/feature>/;
	
	# Version seul titre:
	s/(^)((?:Autre matériel|Autres spécimens|Matériel|Spécimens)(?:| gabonais) étudié(?:|s|.+?)(?:\.|:))($)/$1\t\t\t<feature class="specimens">\n\t\t\t\t<string><subHeading>$2<\/subHeading><br \/>/;
	# Versions seul titre ALL CAPS:
	s/(^)(AUTRE MAT(?:E|É)RIEL (?:E|É)TUDI(?:E|É)|AUTRE MAT(?:E|É)RIEL GABONAIS|MAT(?:E|É)RIEL CAMEROUNAIS (?:E|É)TUDI(?:E|É)|MAT(?:E|É)RIEL GABONAIS (?:E|É)TUDI(?:E|É)|MAT(?:E|É)RIEL CAMEROUNAIS (?:E|É)TUDI(?:E|É) \(.+\)|MAT(?:E|É)RIEL GABONAIS (?:E|É)TUDI(?:E|É) \(.+\)|MAT(?:E|É)RIEL(?:|S) (?:CAMEROUNAIS|GABONAIS)(?:\.|:)|(?:MAT(?:E|É)RIEL (?:E|É)TUDI(?:E|É) POUR LE GABON|MAT(?:E|É)RIEL (?:E|É)TUDI(?:E|É)|MAT(?:E|É)RIEL GABONAIS|MAT(?:E|É)RIEL GABONAIS (?:|ADDITIONNEL )(?:E|É)TUDI(?:E|É)|MAT(?:E|É)RIEL (?:E|É)TUDI(?:E|É) (?:DU|POUR LE) GABON|EXEMPLAIRES ETUDIES POUR LE GABON|SPECIMENS GABONAIS (?:E|É)TUDI(?:E|É)S|MAT(?:E|É)RIEL (?:E|É)XAMIN(?:E|É)|MAT(?:E|É)RIEL GABONAIS (?:ET|OU) LIMITROPHE|MAT(?:E|É)RIEL DU GABON ET DU MUNI|MAT(?:E|É)RIEL CONSPECIFIQUE|MAT(?:E|É)RIEL GABONAIS OU LIMITROPHE ETUDIE|MAT(?:E|É)RIEL GABONAIS OU LIMITROPHE ETUDIE|MAT(?:E|É)RIEL GABONAIS ET DES TERRITOIRES LIMITROPHES|MAT(?:E|É)RIEL (?:E|É)TUDI(?:E|É) DANS LES TERRITOIRES LIMITROPHES|MAT(?:E|É)RIEL GABONAIS \(.+\)|MAT(?:E|É)RIEL GABONAIS \(OU limitrophe\)|MAT(?:E|É)RIEL ETUDIE POUR LE GABON \(et Muni\)|MAT(?:E|É)RIEL (?:E|É)TUDI(?:E|É) \(en totalité du Gabon\)|MAT(?:E|É)RIEL (?:CITÉ|COMPL(?:E|É)MENTAIRE) \((?:Cameroun|Nigeria)\)|MAT(?:E|É)RIEL (?:E|É)TUDI(?:E|É) \(.+\)|MAT(?:E|É)RIEL (?:E|É)TUDI(?:E|É) \(seul connu\)|MATERIEL ETUDIE \(Monts de Cristal\)|MAT(?:E|É)RIEL (?:E|É)TUDI(?:E|É) \(décrit ci-dessus\)|MAT(?:E|É)RIEL (?:E|É)TUDI(?:E|É) \(Gabon et Cameroun\))|(?:|AUTRE )MAT(?:E|É)RIEL DOUTEUX|MAT(?:E|É)RIAUX (?:E|É)TUDI(?:E|É)S \(.+\)|MAT(?:E|É)RIAUX (?:E|É)TUDI(?:E|É)S)(?:\.|:|: |)($)/$1\t\t\t<feature class="specimens">\n\t\t\t\t<string><subHeading>$2$3<\/subHeading><br \/>/;
	# Autres versions seul titre:
	s/(^)(Matériel (?:de référence caractéristique pour le Gabon|provenant de \w+|récolté au Gabon|connu du Gabon|gabonais|d'herbier gabonais)(?:\.|:))($)/$1\t\t\t<feature class="specimens">\n\t\t\t\t<string><subHeading>$2<\/subHeading><br \/>/;
	
	# Collections restantes:
	# Debut et fin:
	s/(^|\t\t\t<feature class="specimens">\n\t\t\t\t<string><subHeading>(?:.+)<\/subHeading><br \/>\n)(Abbé Walker|Adams|Àdebusuyi|Aké Assi|Alston-Smith|Ammer|Anetoh|Annet|(?:|J\.)Anton(?:-| )Smith|J\. Aton-Smith|(?:D|d)e Wilde & Arends|Arends (?:et|&) al\.|Arends, Louis & De Wilde|Arends|Armel|Asonganyi|Attims|Aubert|A\. Aubr(?:é|e)ville|Aubr(?:e|é)ville|Aubry Lecomte|Aubry-(?:L|l)e(?:|-)(?:C|c)omte|Aubry le Comte|Audran ex Heckel|Autran in (?:Klaine|Meckel)|Autran|Bahute|Baies|Baldwin|Bamps|Barreteau|Barter|(?:|G\.(?:| )L\. )Bates|Battiscombe|Baudon|Bernard & (?:Corbet|Durand|Estasse)|Bernard|Bernard-Duboislouveau|Bertin|Bigot|Biholong|Binuyo et Daramola|Boddingius|Bogner|Bois:|Bos, (?:V|v)an der Laan(?:,|) (?:&|et) Nzabi|Bos & (?:al\.|de Bruijn|van der Laan)|Bos|Boughey|Bounougou|(?:|A\. )Bouquet|Braun|Savorgnan de Brazza|Brazza J\.(?: de|)|De Brazza J\.(?: de|)|(?:|J\. de |(?:S\. d|D|d)e )Brazza|Brenan & (?:Jones|Onochie)|Brenan|Breteler c\. s\.|Breteler & (?:al\.|Breteler|Breteler-Klein Breteler|de Bruijn|(?:D|d)e Wilde J\.J\.F\.E\.|(?:D|d)e Wilde J\.(?:|-)J\.|(?:D|d)e Wilde|J\.J\.F\.E\. de Wilde|Jongkind|Lemmens|(?:V|v)an Raalte)|Breteler, Jongkind(?:,|) (?:&|et) (?:Dibata|Wieringa)|Breteler, (?:Jongkind, Nzabi & Wieringa|Jongkind, Wieringa(?:,| &) Moussavou|Lemmens & Nzabi|Nzabi et Wieringa)|Breteler|(?:van der Maesen, Louis|Louis, Breteler|van der Maesen)(?:,|) (?:&|et) de Bruijn|Brunt|Buchholz|Büsgen|(?:|R\. )B(?:ü|ù|u)ttner|Caballé|Calsalisu|Carbet|Du Chaillu|(?:|C. )Chalot|Chapman|Charlot|(?:A\. |)Chevalier|A\. Chev\.|Christy|Clever|CNAD|Commandant Masson|Conrau|Corbet|Cours|Courtet|C\.T\.F\.T\.|CTFT-Gabon|CTFT|Dalziel|Dang|(?:|Binuyo & |Latilo et )Daramola|Davies (?:&|et) Jeffrey|Davies & Anton-Smith|Davies J\. N\.|(?:|J\.(?:| )N\. )Davies|Davis|(?:|G\. )Debeaux|(?:D|d)e (?:Saint|St)(?:-| )Aubin|De Saint Aubin-SRF|(?:|O\. )Debeaux|Decaisne|Deistel|(?:|B\. )Descoing(?:|s)|Arends(?:t|), Louis(?:,|) (?:&|et) de Wilde|(?:D|d)e Wilde, Arends(?:,|) (?:&|et) (?:al\.|(?:D|d)e Bruijn)|(?:D|d)e Wilde, (?:Arends, Louis, Bouman & Karper|Arends, Louis, F\. Bouman & J\. J\. Karper|Arends, Louis & Wieringa|Arends, J\. de Bruijn|Arends & de Bruijn|Arends & al|Sosef & van Nek|van der Maesen, Bourobou & Moussavou|van der Maesen & Moussavou)|Van der Maesen & de Bruijn|(?:D|d)e Wilde & (?:al\.|de Wilde-Bakhuizen|Jongkind|Sosef)|J\. de Wilde & al|de Wilde, J\.J\. & al\.|De Wilde (?:J|W|J\.J|J\.J\.F\.W|W\.c\.s)\.|(?:d|D)e Wilde|De Wit|Dibata|Dinklage|Doumeng(?:|u)e|Dubusse|(?:|R\.(?:| |-)P\. )Duparquet|Dupasquier|Du Bellay|Du Bois|(?:D|d)u(?:| )(?:B|b)oislouveau|(?:D|d)u Chaillu|Dunlap|Durand|J\. Dybowski|Dyboswki|Dybowsk(?:y|i)|J\.J\. Eckendorf|(?:|J\.(?:| )J\. )Eckendorff|École Faune Garoua|Ejiofor|Endengle Elias|Endengle|Estasse|Ezavin|C\. Fanon|Fanshawe|Farron & Ollome|Farron|Fleury in Chev(?:\.|alier)|Fleury-Chevalier|(?:|F\. )Fleury|Florence|Floret, Louis A.M. &. Moungazi|Floret & (?:Louis A\.M\.|Louis)|Floret|Fotius|Foury|Franchet|Franquet|Franzini|Gaston|Gauchotte(?: et Durand| et Guillery|-Guillery)|Gauchotte|Gazonneau, SRF|Gazonnaud|Geerling & al.|Geerling|Gentry|Gilbert|Gilles M\. G\.|Gilles|Gillet|Gossweiler|(?:|Griffon(?:-| )d(?:e|u)(?:-| )|d(?:e|u) )Bellay(?:|, Leroy)|(?:J\. |)Groulez|Guibert|Guigonis-SF|Guigonis|Guillemet|Guillery|Guiral|N\. Hall(?:e|é|è) (?:et|&) (?:(?:G\. |)Cours|(?:A\. |)Le Thomas|(?:|J\.(?:|-| )F\. )Villiers)|Hall(?:é|e)(?:|,)(?:| N\.), Aubréville & Le Thomas|Hall(?:é|e)(?:|,)(?:| N\.) (?:&|et) (?:Cours G\.|Cours|Villiers J\.-F\.|Villiers|(?:A\. L|L|l)e Thomas|Normand)|Hall(?:é|e)(?:,|) N\.|(?:|N\. )Hall(?:é|e)(?:| comb\. nov\. Spire)|Le Bay|Haegens & van der Burgt|Haegens|Heckel|H(?:e|é)din|Heitz|Hepper|Hermant|Hijman & Weerdenburg|Hladik, A\.|Hladi(?:|c)k|Houssin|Hückstädt|Ileitz|I\.N\.E\.F\.|INEF|Inst\. nat\. études forestières|Jacques-Félix|Jardin|Jean Louis|(?:|C\. |G\. )Jeffrey|Jeme|(?:|G\. )Jo(?:|l)ly|Jongkind|Jourdan|Kalbreyer|Ngameni Kamga|Karmann|De Wilde, J\.J\.F\.E\., Arends, Louis A\.M\., Bouman & Karper|Keay|(?:|R\. P\. |R\.P\. )Klaine|Klein|Koechlin|Koufani|Krause|Krücke|B\. A\. Krukoff|Krukoff|Kwab|Lachiver|Ladurantie|Lartigue|Latilo & Oguntayo|Latil(?:|h)o|Lau SF|(?:|H\. )Lecomte|Ledermann|Leeuwenberg, Persoon & Nzabi|Leeuwenberg & Persoon|(?:|Breteler, De Wilde(?:| J\.)(?:, | & ))Leeuwenberg|Lehmbach|Lemmie|Mgr(?:|\.) Leroy|Leroy (?:Mgr\.|\(Mgr(?:\.|)\))|(?:|Mgr(?:|\.| A\.) )Le(?:roy| Roy)|(?:|G\. )Le Testu|Le Thomas|Letouzey & Villiers J\.-F\.|Letouzey|Lhote|Lightbody|Linder|L(?:o|ö)tz|(?:|G\. )Loubens|Louis, Breteler & (?:De |)Bruijn|Louis & (al\.|Bos|Nzabi)|Louis (?:A\.M\.|& al\.)|Louis, A\.M\. (?:Breteler & de Bruijn|& al\.)|(?:|J\. )Louis|Loury|Mac Key|Maitland|Makany|Maley|Malzy|(?:|G\. )Mann|(?:A\. |)Mariaux|Masson|Mbarga Apollinaire|Mbarga|Mbenkum|McPherson|Médou|Ménager|Menzouret in Hallé N\.|Meurillon|Mezili|Michaloud|Mildbr(?:ae|ea)d|Mission Foureau|M(?:e|é)zili|(?:Bradbury & |)Michaloud|Milne|Mollez|Morel et Gauchotte|(?:|J\. )Morel|Motuba|Moub|(?:|Floret, Louis (?:|A\.M\. )& )Moungazi|Mpom Beno(?:i|î)t|Mpom|(?:Wieringa, van Nek, Hedin|Wieringa, van Nek) & Moussavou|Nana Pierre|Nana|Nandi|Ngameni Kanga|Jongkind & Ngoye|Nicklès|D\. Normand|Normand|(?:Breteler, Lemmens|Jongkind, Ngoye) (?:&|et) Nzabi|Ol(?:|l)o(?:m|n)e|(?:|R\. )Olorunfemi|Onochie|Osmaston|Pambou Tchivounda|Pauly|(?:|L\. )P(?:e|é)riquet|Pescatore|Pierre|Piot|(?:|H\. )Pob(?:é|e)guin|Polhill et Paulo|Pomeroy|Pouillat|Pouret|Preuss|Prévost|Quint|Rabourdin|Rammell|Raynal J\. (?:et|&) A\.|(?:|J\.(?:| |(?:| )& )A\. )Raynal|Raynaud|Reitsma, Breteler & Louis|Reitsma & (?:al\.|Louis|Reitsma)|Reitsma J\. M\. & B\.(?:, Breteler & Louis| & Louis|)|J\. M\. & B\. Reitsma, Breteler & Louis|J\. M\. & B\. Reitsma & (?:Breteler|Louis)|J\. M\. & B\. Reitsma|Reitsma|Renthinger|Reussner|Reutlinger|Ribourt|R\.I\.C\.C\.|Rielh|Robyns|Rosenthal|Rosevear|Rozena|Rudatis|Sachiver|Saint Aubin|W\. W\. Sanford|Sargos|Satabi(?:e|é) & Letouzey|Satabi(?:e|é)|(?:S|s)\.(?:| )(?:C|c)\.|(?:|R\. )Schlechter|Schlechter|Schmit|S(?:é|e)bire(?:|-Estasse| et Estasse)|Schoenmaker|Schultze in Mildbraed|Schwébisch et Thollon|Schweinfurth|S(?:|\.)(?:| )F(?:|\.)|S(?:|\.)F(?:|\.)M(?:|\.)C(?:|\.)|Service (?:f|F)orestier du Cameroun|Service (?:f|F)orestier|Sillans|Sillitoe|Sit(?:h|)a|Schlechter|Slootweg & Missler|Smeyers|Smith|(?:|H\. )Soyaux|Spire|Endengle SRFCam|S(?:|\.)R(?:|\.)F(?:|\.)Cam(?:|\.)|S\.(?:| )R\.(?:| )F\.|(?:Deval |)S(?:|\.)R(?:|\.)F(?:|\.)G(?:|\.)|Standi|Staudt|Steele|Steudel|Stolz|Surville|Talbot|Tamajong|Vroumsia Tchinaye|(?:|G\. )Tessman(?:|n)|Teusz|(?:|F\. R\. )Thollon|Thomas, D\.|Thomas & Wilks|Thomas|(?:|A\. P\. )Thomson|Tiku|Tisserant|Tonnelle S\.R\.F\.|Tonnelle|Toupin|Toussaint|(?:|G\. )Touzet|(?:|(?:H|R|T)\.(?:| )P\. )Trilles|Trochain|Tweedi|Tiku, Dioh et Ujor|Vadon|Vaillant|(?:v|V)an der Laan|van der Maesen, Louis & de Bruijn|(?:V|v)an der Maesen & de Bruijn|(?:V|v)an der Maesen|(?:V|v)an Meer|(?:V|v)an Nek|Vavin|Veen|Vicent|Villiers J\.-F\.|(?:|J\.(?:|-| )F\. )Villiers|Vroumsia Tchinaye|Wagemans|(?:|A\. )Walker|Walker-Chevalier|White|Wieringa & (?:al\.|Epoma|Haegens|Hédin|Nzabi|van de Poll)|Wieringa|Thomas & Wilks|Wilks & al\.|Wilks Wil|Wilks|Winkler|Yvon|Zenker (?:et|&) Staudt|Zenker)((?:|:|\.) )(.+)(\.|\. |;)($|<\/string>\n\t\t\t<\/feature>$)/$1<gathering><collector>$2<\/collector>$4$5<\/gathering><br \/>$6/;
	
	# Le nome de collecteur "Bois" est suivi par un double-point dans le code ci-dessus, pour eviter d'ajouter des tags au lignes commencant par le mot "Bois". Le regex ci-dessous deplace ce double point pour que les regexs suivant font correctement leurs travail:
	s/(<gathering><collector>Bois)(:)(<\/collector>)/$1$3$2/;
	
	# Repare "& al." rates:
	s/(<\/collector>)( & al\.)/$2$1/;
	s/(<\/collector>)( & al)/$2$1/;
	
	# Repare point et tag <br /> inverses:
	s/(<br \/>)(\.)/$2$1/;
	
	# Debut et fin (special 5bis):
	# s/(^|\t\t\t<feature class="specimens">\n\t\t\t\t<string><subHeading>(?:.+)<\/subHeading><br \/>\n)(Alers (?:|& Blom )\(Lopé\)|Arends, Louis & de Wilde|van Bergen|Blom \(Lopé\)|Boddingius|Bos, van der Laan & Nzabi|Breteler & Jongkind|Breteler & Breteler-Klein Breteler|Breteler & van Raalte|Breteler, Lemmens & Nzabi|Breteler, Jongkind & Wieringa|Breteler, Nzabi & Wieringa|Breteler, Jongkind & Dibata|Breteler, Jongkind, Wieringa & Moussavou|Breteler, Jongkind, Nzabi & Wieringa|Breteler|Coomans|Dibata|Everts|Gilles|Haegens & van der Burgt|Hallé & Villiers|Jongkind|Leeuwenberg(?:|, Persoon & Nzabi)|Louis, Breteler & de Bruijn|Louis|van der Maesen, Louis & de Bruijn|Meurillon|van Nek|Reitsma(?: & Reitsma|)|Reitsma, Reitsma & Louis|Reitsma, Reitsma, Breteler & Louis|Schoenmaker|Sterck & Elias|Thomas(?: & Wilks|)|Thomson|Wieringa & Nzabi|Wieringa & van de Poll|Wieringa & Haegens|Wieringa|de Wilde & de Wilde-Bakhuizen|de Wilde, Arends & de Bruijn|de Wilde, Arends, Louis, Bouman & Karper|de Wilde, Arends, Louis, Karper & Bouman|de Wilde, Arends, Louis & Wieringa|de Wilde & Jongkind|de Wilde & van der Maesen|de Wilde, van der Maesen & Moussavou|de Wilde & Sosef|de Wilde, Sosef & van Nek|de Wilde, van der Maesen, Bourobou & Moussavou|Wilks|White & Abernethy|White)( )(.+)(\.|\. |;)($|<\/string>\n\t\t\t<\/feature>$)/$1<gathering><collector>$2<\/collector>: $4$5<\/gathering><br \/>$6/;
	
	# Les parties entre:
	# NOTE: each collector name is followed by one or more gatherings - mark-up must reflect this.
	if (/^<gathering><collector>|\t\t\t<feature class="specimens">/) {
	
		# Collecteurs incertains:
		s/(<collector)(>.+)(<\/collector>)( \(\?\))(: (?:: )+|:)/$1 doubtful="true"$2$4$3$5/g;
		
		
		# Enlevement du double point apres le collecteur:
		s/(<\/collector>)(: (?:: )+|: )/$1/;
		# Division des collections faites par le meme collecteur:
		s/(; )(?!f(?:r|l)\.)/<\/gathering>$1<gathering>/g;
		
		
		# Reparation de latitudes/longitudes avec OCR mauvais:
		
		# Reparation de 0 ou " a la place de °:
		# Format 11°11'N-11°11'E:
		s/(, )(\d\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d\d)(0|"|°)(\d\d'(?:E|W))/$1$2°$4$5$6°$8/g;
		s/(, c\. )(\d\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d\d)(0|"|°)(\d\d'(?:E|W))/$1$2°$4$5$6°$8/g;
		s/(\d\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d\d)(0|"|°)(\d\d'(?:E|W))/$1°$3$4$5°$7/g;
		s/(c\. )(\d\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d\d)(0|"|°)(\d\d'(?:E|W))/$1°$3$4$5°$7/g;
		
		# Format 1°11'N-1°11'E:
		s/(, )(\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d)(0|"|°)(\d\d'(?:E|W))/$1$2°$4$5$6°$8/g;
		s/(, c\. )(\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d)(0|"|°)(\d\d'(?:E|W))/$1$2°$4$5$6°$8/g;
		s/(\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d)(0|"|°)(\d\d'(?:E|W))/$1°$3$4$5°$7/g;
		s/(c\. )(\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d)(0|"|°)(\d\d'(?:E|W))/$1°$3$4$5°$7/g;
		
		# Format 11°11'N-1°11'E:
		s/(, )(\d\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d)(0|"|°)(\d\d'(?:E|W))/$1$2°$4$5$6°$8/g;
		s/(, c\. )(\d\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d)(0|"|°)(\d\d'(?:E|W))/$1$2°$4$5$6°$8/g;
		s/(\d\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d)(0|"|°)(\d\d'(?:E|W))/$1°$3$4$5°$7/g;
		s/(c\. )(\d\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d)(0|"|°)(\d\d'(?:E|W))/$1°$3$4$5°$7/g;
		
		# Format 1°11'N-11°11'E:
		s/(, )(\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d\d)(0|"|°)(\d\d'(?:E|W))/$1$2°$4$5$6°$8/g;
		s/(, c\. )(\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d\d)(0|"|°)(\d\d'(?:E|W))/$1$2°$4$5$6°$8/g;
		s/(\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d\d)(0|"|°)(\d\d'(?:E|W))/$1°$3$4$5°$7/g;
		s/(c\. )(\d)(0|"|°)(\d\d'(?:S|N))((?:| )-(?:| ))(\d\d)(0|"|°)(\d\d'(?:E|W))/$1°$3$4$5°$7/g;
		
		
		# Reparation de " a la place de °:
		s/(, )(\d+)(")(\d+'(?:S|N))((?:| )-(?:| ))(\d+)(")(\d+'(?:E|W))/$1$2°$4$5$6°$8/g;
		s/(, c\. )(\d+)(")(\d+'(?:S|N))((?:| )-(?:| ))(\d+)(")(\d+'(?:E|W))/$1$2°$4$5$6°$8/g;
		s/(\d+)(")(\d+'(?:S|N))((?:| )-(?:| ))(\d+)(")(\d+'(?:E|W))/$1°$3$4$5°$7/g;
		s/(c\. )(\d+)(")(\d+'(?:S|N))((?:| )-(?:| ))(\d+)(")(\d+'(?:E|W))/$1°$3$4$5°$7/g;
		
		# Reparation d'espaces entre les differentes parties:
		s/(, (?:|c\. |env\. |environ |± ))(\d+°)(| )(\d+')(| )(S|N|E|W)(, | et |-)(\d+°)(| )(\d+')(| )(E|W|S|N)/$1$2$4$6-$8$10$12/g;
		s/(, (?:|c\. |env\. |environ |± ))(\d+°)(| )(\d+')(| )(\d")(| )(S|N|E|W)(, | et |-)(\d+°)(| )(\d+')(| )(\d")(| )(E|W|S|N)/$1$2$4$6$8-$10$12$14$16/g;
		
		
		# Latitude/Longitude:
		s/(, )(\d+(?:°|")\d+'(?:|\d")(?:S|N))((?:| )-(?:| ))(\d+(?:°|")\d+'(?:|\d")(?:E|W))/$1<locality class="locality"><coordinates><latitude>$2<\/latitude><longitude>$4<\/longitude><\/coordinates><\/locality>/g;
		s/(, c\. )(\d+(?:°|")\d+'(?:|\d")(?:S|N))((?:| )-(?:| ))(\d+(?:°|")\d+'(?:|\d")(?:E|W))/$1<locality class="locality"><coordinates><latitude estimate="true">$2<\/latitude><longitude estimate="true">$4<\/longitude><\/coordinates><\/locality>/g;
		s/(\d+(?:°|")\d+'(?:|\d")(?:S|N))((?:| )-(?:| ))(\d+(?:°|")\d+'(?:|\d")(?:E|W))/<locality class="locality"><coordinates><latitude>$1<\/latitude><longitude>$3<\/longitude><\/coordinates><\/locality>/g;
		s/(c\. )(\d+(?:°|")\d+'(?:|\d")(?:S|N))((?:| )-(?:| ))(\d+(?:°|")\d+'(?:|\d")(?:E|W))/$1<locality class="locality"><coordinates><latitude estimate="true">$2<\/latitude><longitude estimate="true">$4<\/longitude><\/coordinates><\/locality>/g;
		
		# Longitude/Latitude (inverse aussi l'information pour obtenir l'ordre comme ci-dessus):
		s/(, )(\d+(?:°|")\d+'(?:|\d")(?:E|W))((?:| )-(?:| ))(\d+(?:°|")\d+'(?:|\d")(?:S|N))/$1<locality class="locality"><coordinates><latitude>$4<\/latitude><longitude>$2<\/longitude><\/coordinates><\/locality>/g;
		s/(, (?:c\.|env\.|environ|±) )(\d+(?:°|")\d+'(?:|\d")(?:E|W))((?:| )-(?:| ))(\d+(?:°|")\d+'(?:|\d")(?:S|N))/$1<locality class="locality"><coordinates><latitude estimate="true">$4<\/latitude><longitude estimate="true">$2<\/longitude><\/coordinates><\/locality>/g;
		s/(\d+(?:°|")\d+'(?:|\d")(?:E|W))((?:| )-(?:| ))(\d+(?:°|")\d+'(?:|\d")(?:S|N))/<locality class="locality"><coordinates><latitude>$3<\/latitude><longitude>$1<\/longitude><\/coordinates><\/locality>/g;
		s/((?:c\.|env\.|environ|±) )(\d+(?:°|")\d+'(?:|\d")(?:E|W))((?:| )-(?:| ))(\d+(?:°|")\d+'(?:|\d")(?:S|N))/$1<locality class="locality"><coordinates><latitude estimate="true">$4<\/latitude><longitude estimate="true">$2<\/longitude><\/coordinates><\/locality>/g;
		
		# Seulement latitude:
		s/(, lat\. )(\d+ (?:S|N)°)/$1<coordinates><latitude>$2<\/latitude><\/coordinates>/g;
		s/(, lat\. )(\d+° (?:S|N))/$1<coordinates><latitude>$2<\/latitude><\/coordinates>/g;
		
		
		
		# Altitude:
		# Ranges d'altitudes, estimation:
		s/((?:±|env\.) (?:\d+|\d \d+)-(?:\d+|\d \d+) m alt\.|alt\. (?:±|env\.) (?:\d+|\d \d+)-(?:\d+|\d \d+) m)/<altitude estimate="true" range="true">$1<\/altitude>/g;
		# Ranges d'altitudes:
		s/((?:\d+|\d \d+)-(?:\d+|\d \d+) m alt\.|alt\. (?:\d+|\d \d+)-(?:\d+|\d \d+) m)/<altitude range="true">$1<\/altitude>/g;
		# Une seule altitude, estimation:
		s/((?:±|env\.) (?:\d+|\d \d+) m alt\.|alt\. (?:±|env\.) (?:\d+|\d \d+) m|vers (?:\d+|\d \d+) m)/<altitude estimate="true">$1<\/altitude>/g;
		# Une seule altitude:
		s/((?:\d+|\d \d+) m alt\.|alt\. (?:\d+|\d \d+) m)/<altitude>$1<\/altitude>/g;
		
		
		
		# Repare doubles tags d'altitude:
		s/(<altitude estimate="true">(?:±|env\.) )(<altitude>)/$1/g;
		s/(<altitude range="true">)(\d+-)(<altitude>)/$1$2/g;
		
		
		
		# Premier numero de collection:
		s/(<\/collector>(?:| )|<gathering>)(s\.n\.|(?:CNAD|E|FHI|FvK|HNC|MINK (?:S|W)|SRFCam|SRF|SRFK|S\.R\.F\.) \d+|\d+ (?:CTFT|FvK|HNC|SRFCam|SRFG|SRF|Ca)|\d+)/$1<fieldNum>$2<\/fieldNum>/g;
		# Numeros de collection alternatifs:
		# Version 1: (inactive, donne trop de problemes)
		# s/(, )(\d+|s\.n\.|(?:FHI|SRFCam|SRF|S\.R\.F\.) \d+|\d+ (?:SRFCam|SRF))(?! km|\d+ km|-\d+ km|\d+-\d+ km|°|,|\d+,|\.\d+\.)/<alternativeFieldNum>$2<\/alternativeFieldNum>/g;
		# Version 2:
		s/(\(= )(s\.n\.|(?:CNAD|E|FHI|FvK|HNC|MINK (?:S|W)|SRFCam|SRF|SRFK|S\.R\.F\.) \d+|\d+ (?:CTFT|FvK|HNC|SRFCam|SRFG|SRF|Ca)|\d+)(\))/$1<alternativeFieldNum>$2<\/alternativeFieldNum>$3/g;
		
		# Collecteurs et numeros de colelction alternatifs:
		s/(\(= )([[:upper:]][[:lower:]]+)( )(s\.n\.|(?:CNAD|E|FHI|FvK|HNC|MINK (?:S|W)|SRFCam|SRF|SRFK|S\.R\.F\.) \d+|\d+ (?:CTFT|FvK|HNC|SRFCam|SRFG|SRF|Ca)|\d+)(\))/$1<alternativeCollector>$2<\/alternativeCollector><alternativeFieldNum>$4<\/alternativeFieldNum>$5/g;
		
		
		
		# Repare numeros mal-identifies:
		s/(<alternativeFieldNum>)(\d+)(<\/alternativeFieldNum>)('|\/|-)/ $2$4/g;
		# Altitude reconnu comme numero de collection:
		s/(<alternativeFieldNum>)(\d+)(<\/alternativeFieldNum>)( m|km)/ $2$4/g;
		
		
		# Repare numeros bis, ter, etc.:
		s/(<\/fieldNum>)((?:| )(?:bis|ter))/$2$1/g;
		# Repare numeros a, b, etc.:
		s/(<\/fieldNum>)((?:| )(?:A|a|B|b|C|c))(,)/$2$1$3/g;
		
		
		# Numeros questionables:
		s/(<fieldNum)(>)(\d+|s\.n\.|(?:FHI|SRFCam) \d+|\d+ SRFCam)(<\/fieldNum>)( \?)/$1 doubtful="true"$2$3$5$4/g;
		s/(<fieldNum)(>)(\d+|s\.n\.|(?:FHI|SRFCam) \d+|\d+ SRFCam)(<\/fieldNum>)( \(\?\))/$1 doubtful="true"$2$3$5$4/g;
		
		# Sous-collections:
		# s/(\()(f(?:r|l)\.(?: ♂| ♀|), (?:|j\. )f(?:r|l)\.)(\))/$1<subCollection>$2<\/subCollection>$3/g;
		# s/(\()(f(?:r|l)\.(?: ♂| ♀| p\.p\.))(\))/$1<subCollection>$2<\/subCollection>$3/g;
		# s/(\()(f(?:r|l)\.|bout\. fl\.|st(?:é|e)r\.)(\))/$1<subCollection>$2<\/subCollection>$3/g;
		
		# s/(, )(f(?:r|l)\.(?: ♂| ♀|), (?:|j\. )f(?:r|l)\.)(?!<\/subCollection>)/$1<subCollection>$2<\/subCollection>/g;
		# s/(, )(f(?:r|l)\.(?: ♂| ♀|))(?!<\/subCollection>)/$1<subCollection>$2<\/subCollection>/g;
		# s/(, )(f(?:r|l)\.|bout\. fl\.)(?!<\/subCollection>)/$1<subCollection>$2<\/subCollection>/g;
		
		# Dates:
		# Annees (an 1000 a an 2999):
		# s/(, | |)(\()((?:1|2)\d\d\d)(\))/$2<dates><year>$3<\/year><\/dates>$4/g;
		
		# Dates precises:
		
		
		
		# Sous-collections + dates:
		# Format: fr. ♂, fr. ♂, date
		s/(\(|; |(?:\d (?:|c)m|arbre|liane), )((?:(?:|j\. |v\. |vieux |vieilles |fin (?:|de )|bout\. )f(?:r|l)\.|bout(?:|\.)|fig\.|fil\.|fll\.|gall\.|galles|gr(?:\.|aine(?:|s))|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.(?:|, bois)|bois)(?: ♂| ♀| ♂, ♀| ⚥| (?:non|presque) mûr(?:|s)| fanée(?:|s)| vert(?:|s|es)| jaun(?:|âtr)e(?:|s)| rouge(?:|s)| blanche(?:|s)| orangé(?:|s)| dessiné(?:|s)| immature(?:|s)), (?:(?:|j\. |v\. |vieux |vieilles |fin (?:|de )|bout\. )f(?:r|l)\.|bout(?:|\.)|fig\.|fil\.|fll\.|gall\.|galles|gr(?:\.|aine(?:|s))|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.(?:|, bois)|bois)(?: ♂| ♀| ♂, ♀| ⚥| (?:non|presque) mûr(?:|s)| fanée(?:|s)| vert(?:|s|es)| jaun(?:|âtr)e(?:|s)| rouge(?:|s)| blanche(?:|s)| orangé(?:|s)| dessiné(?:|s)| immature(?:|s)))(?:, (?:|de )| )((?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.|(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)(?:-|(?: a| à| et|,) )(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)|1(?:8|9)\d\d)(?:| \d\d\d\d))(\)|;)/$1<subCollection>$2<\/subCollection><dates><fullDate>$3<\/fullDate><\/dates>$4/g;
		# Format: fr., fr. ♂, date
		s/(\(|; |(?:\d (?:|c)m|arbre|liane), )((?:(?:|j\. |v\. |vieux |vieilles |fin (?:|de )|bout\. )f(?:r|l)\.|bout(?:|\.)|fig\.|fil\.|fll\.|gall\.|galles|gr(?:\.|aine(?:|s))|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.(?:|, bois)|bois), (?:(?:|j\. |v\. |vieux |vieilles |fin (?:|de )|bout\. )f(?:r|l)\.|bout(?:|\.)|fig\.|fil\.|fll\.|gall\.|galles|gr(?:\.|aine(?:|s))|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.(?:|, bois)|bois)(?: ♂| ♀| ♂, ♀| ⚥| (?:non|presque) mûr(?:|s)| fanée(?:|s)| vert(?:|s|es)| jaun(?:|âtr)e(?:|s)| rouge(?:|s)| blanche(?:|s)| orangé(?:|s)| dessiné(?:|s)| immature(?:|s)))(?:, | )((?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.|(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)(?:-|(?: a| à| et|,) )(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)|1(?:8|9)\d\d)(?:| \d\d\d\d))(\)|;)/$1<subCollection>$2<\/subCollection><dates><fullDate>$3<\/fullDate><\/dates>$4/g;
		# Format: fr. ♂, fr., date
		s/(\(|; |(?:\d (?:|c)m|arbre|liane), )((?:(?:|j\. |v\. |vieux |vieilles |fin (?:|de )|bout\. )f(?:r|l)\.|bout(?:|\.)|fig\.|fil\.|fll\.|gall\.|galles|gr(?:\.|aine(?:|s))|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.(?:|, bois)|bois)(?: ♂| ♀| ♂, ♀| ⚥| (?:non|presque) mûr(?:|s)| fanée(?:|s)| vert(?:|s|es)| jaun(?:|âtr)e(?:|s)| rouge(?:|s)| blanche(?:|s)| orangé(?:|s)| dessiné(?:|s)| immature(?:|s)), (?:(?:|j\. |v\. |vieux |vieilles |fin (?:|de )|bout\. )f(?:r|l)\.|bout(?:|\.)|bois|gr(?:\.|aine(?:|s))))(?:, | )((?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.|(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)(?:-|(?: a| à| et|,) )(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)|1(?:8|9)\d\d)(?:| \d\d\d\d))(\)|;)/$1<subCollection>$2<\/subCollection><dates><fullDate>$3<\/fullDate><\/dates>$4/g;
		# Format: fr. ♂, date
		s/(\(|; |(?:\d (?:|c)m|arbre|liane), )((?:(?:|j\. |v\. |vieux |vieilles |fin (?:|de )|bout\. )f(?:r|l)\.|bout(?:|\.)|fig\.|fil\.|fll\.|gall\.|galles|gr(?:\.|aine(?:|s))|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.(?:|, bois)|bois)(?: ♂| ♀| ♂, ♀| ⚥| (?:non|presque) mûr(?:|s)| fanée(?:|s)| vert(?:|s|es)| jaun(?:|âtr)e(?:|s)| rouge(?:|s)| blanche(?:|s)| orangé(?:|s)| dessiné(?:|s)| immature(?:|s)))(, )((?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.|(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)(?:-|(?: a| à| et|,) )(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)|1(?:8|9)\d\d)(?:| \d\d\d\d))(\)|;)/$1<subCollection>$2<\/subCollection><dates><fullDate>$4<\/fullDate><\/dates>$5/g;
		# Format: fr., fr., date
		s/(\(|; |(?:\d (?:|c)m|arbre|liane), )((?:(?:|j\. |v\. |vieux |vieilles |fin (?:|de )|bout\. )f(?:r|l)\.|bout(?:|\.)|fig\.|fil\.|fll\.|gall\.|galles|gr(?:\.|aine(?:|s))|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.(?:|, bois)|bois)(?:, | et |, et | ou | )(?:(?:(?:|j\. |v\. |vieux |vieilles |fin (?:|de )|bout\. )f(?:r|l)\.|bout(?:|\.))|fig\.|gr(?:\.|aine(?:|s))|st\.|st(?:é|e)r\.(?:|, bois)|bois))(?:, | )((?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.|(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)(?:-|(?: a| à| et|,) )(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)|1(?:8|9)\d\d)(?:| \d\d\d\d))(\)|;)/$1<subCollection>$2<\/subCollection><dates><fullDate>$3<\/fullDate><\/dates>$4/g;
		# Format: fr., date
		s/(\(|; |(?:\d (?:|c)m|arbre|liane), )((?:|j\. |v\. |vieux |vieilles |fin (?:|de )|bout\. )f(?:r|l)\.|bout(?:|ons)|bout\.|fr\. (?:non |presque )(?:mûr(?:|s)|vert(?:|s|es)|jaun(?:|âtr)e(?:|s)|rouge(?:|s)|blanche(?:|s)|orangé(?:|s)|dessiné(?:|s)|immature(?:|s))|gall\.|galles|path\.|plant(?:\.|ule)|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.(?:|, bois)|bois|gr(?:\.|aine(?:|s))|fin de flor\.|fig\.|fil\.|fll\.|dessiné)(?:, | )((?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.|(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)(?:-|(?: a| à| et|,) )(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)|1(?:8|9)\d\d)(?:| \d\d\d\d))(\)|;)/$1<subCollection>$2<\/subCollection><dates><fullDate>$3<\/fullDate><\/dates>$4/g;
		
		
		# Sous-collections sans dates:
		s/(\()((?:(?:|j\. |v\. |fin (?:|de )|bout\. )f(?:r|l)\.(?:| ♂| ♀| ⚥| p\.p\.| juv\.| courts| longs| immat\.)|bois|(?:|j\. )bout(?:|ons|\.)|fir\.|fr\. (?:non|presque) mûrs|galles|path\.|plant(?:\.|ule)|fig\.|fil\.|fll\.|gall\.|galles|gr(?:\.|aine(?:|s))|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.|♂|♀|fl\. avec fr\.)(?:, | et |, et | ou | )(?:(?:|j\. |v\. |fin (?:|de )|bout\. )f(?:r|l)\.(?:| ♂| ♀| p\.p\.| juv\.| courts| longs|, gr\.(?:|, bois))|bois|bout(?:|ons|\.)|fir\.|fr\. non mûrs|gall\.|galles|path\.|st(?:é|e)r\.|♂|♀|gr\.))(\))/$1<subCollection>$2<\/subCollection>$3/g;
		
		s/(\()((?:|j\. |v\. |fin (?:|de )|bout\. )f(?:r|l)\.(?:| ♂| ♀| ⚥| p\.p\.| juv\.| courts| longs| immat\.)|bois|(?:|j\. )bout(?:|ons|\.)|fir\.|fr\. (?:non|presque) mûrs|gall\.|galles|gr(?:\.|aine(?:|s))|path\.|plant(?:\.|ule)|fig\.|fil\.|fll\.|gr\.|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.|♂|♀)(\))/$1<subCollection>$2<\/subCollection>$3/g;
		
		# Note: Si deux sous-collections se suivent, et les deux sont egales convernant le format, a part les parentheses et point-virgules, la deuxieme sous-collection ne sera pas tagge.
		
		# Dates sans sous-collections:
		s/(\(|, )((?:|d')(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)u(?:|i)llet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.|(?:|d')(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)u(?:|i)llet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.)(?:-|(?: a| à| et|,) )(?:(?:J|j)an(?:|v)\.|(?:F|f)(?:é|e)v(?:|r)\.|(?:M|m)ars|(?:A|a)vr(?:\.|il)|(?:M|m)ai|(?:J|j)uin|(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)u(?:|i)llet|(?:A|a)o(?:û|u)t|(?:S|s)ept\.|(?:O|o)ct\.|(?:N|n)ov\.|(?:D|d)(?:é|e)c\.))(?:| \d\d\d\d))(\))/$1<dates><fullDate>$2<\/fullDate><\/dates>$3/g;
		
		
		# Normalisation des dates dans les sous-collections:
		# Mois seuls:
		s/(<dates>)(<fullDate>(?:J|j)an(?:|v)\.<\/fullDate>)(<\/dates>)/$1<month>--01<\/month>$3/g;
		s/(<dates>)(<fullDate>(?:F|f)(?:é|e)v(?:|r)\.<\/fullDate>)(<\/dates>)/$1<month>--02<\/month>$3/g;
		s/(<dates>)(<fullDate>(?:M|m)ars<\/fullDate>)(<\/dates>)/$1<month>--03<\/month>$3/g;
		s/(<dates>)(<fullDate>(?:A|a)vr(?:\.|il)<\/fullDate>)(<\/dates>)/$1<month>--04<\/month>$3/g;
		s/(<dates>)(<fullDate>(?:M|m)ai<\/fullDate>)(<\/dates>)/$1<month>--05<\/month>$3/g;
		s/(<dates>)(<fullDate>(?:J|j)uin<\/fullDate>)(<\/dates>)/$1<month>--06<\/month>$3/g;
		s/(<dates>)(<fullDate>(?:(?:J|j)u(?:|i)l(?:|l)\.|(?:J|j)uillet)<\/fullDate>)(<\/dates>)/$1<month>--07<\/month>$3/g;
		s/(<dates>)(<fullDate>(?:A|a)o(?:û|u)t<\/fullDate>)(<\/dates>)/$1<month>--08<\/month>$3/g;
		s/(<dates>)(<fullDate>(?:S|s)ept\.<\/fullDate>)(<\/dates>)/$1<month>--09<\/month>$3/g;
		s/(<dates>)(<fullDate>(?:O|o)ct\.<\/fullDate>)(<\/dates>)/$1<month>--10<\/month>$3/g;
		s/(<dates>)(<fullDate>(?:N|n)ov\.<\/fullDate>)(<\/dates>)/$1<month>--11<\/month>$3/g;
		s/(<dates>)(<fullDate>(?:D|d)(?:é|e)c\.<\/fullDate>)(<\/dates>)/$1<month>--12<\/month>$3/g;
		
		# Mois + Annee:
		s/(<dates>)(<fullDate>(?:J|j)an(?:|v)\.)( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--01<\/month><year>$4<\/year>$6/g;
		s/(<dates>)(<fullDate>(?:F|f)(?:é|e)v(?:|r)\.)( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--02<\/month><year>$4<\/year>$6/g;
		s/(<dates>)(<fullDate>(?:M|m)ars)( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--03<\/month><year>$4<\/year>$6/g;
		s/(<dates>)(<fullDate>(?:A|a)vr(?:\.|il))( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--04<\/month><year>$4<\/year>$6/g;
		s/(<dates>)(<fullDate>(?:M|m)ai)( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--05<\/month><year>$4<\/year>$6/g;
		s/(<dates>)(<fullDate>(?:J|j)uin)( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--06<\/month><year>$4<\/year>$6/g;
		s/(<dates>)(<fullDate>(?:J|j)u(?:|i)l(?:|l)\.)( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--07<\/month><year>$4<\/year>$6/g;
		s/(<dates>)(<fullDate>(?:A|a)o(?:û|u)t)( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--08<\/month><year>$4<\/year>$6/g;
		s/(<dates>)(<fullDate>(?:S|s)ept\.)( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--09<\/month><year>$4<\/year>$6/g;
		s/(<dates>)(<fullDate>(?:O|o)ct\.)( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--10<\/month><year>$4<\/year>$6/g;
		s/(<dates>)(<fullDate>(?:N|n)ov\.)( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--11<\/month><year>$4<\/year>$6/g;
		s/(<dates>)(<fullDate>(?:D|d)(?:é|e)c\.)( )(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<month>--12<\/month><year>$4<\/year>$6/g;
		
		# Annees seules:
		s/(<dates>)(<fullDate>)(\d\d\d\d)(<\/fullDate>)(<\/dates>)/$1<year>$3<\/year>$5/g;
		
		
		
		# Autres dates:
		# Separation par point:
		# s/(, )(\d(?:|\d))(\.)(\d(?:|\d))(\.)(\d\d\d\d)/<dates><day>---$2<\/day><month>--$4<\/month><year>$6<\/year><\/dates>/g;
		# s/(, )(\d(?:|\d))(\.)(\d\d\d\d)/<dates><month>--$2<\/month><year>$4<\/year><\/dates>/g;
		# s/(\d(?:|\d))(\.)(\d(?:|\d))(\.)(\d\d\d\d)/<dates><day>---$2<\/day><month>--$4<\/month><year>$6<\/year><\/dates>/g;
		# s/(\d(?:|\d))(\.)(\d\d\d\d)/<dates><month>--$2<\/month><year>$4<\/year><\/dates>/g;
		# Separation par trait /:
		s/(, )(\d(?:|\d))(\/)(\d(?:|\d))(\/)(\d\d\d\d)/<dates><day>---$2<\/day><month>--$4<\/month><year>$6<\/year><\/dates>/g;
		s/(, )(\d(?:|\d))(\/)(\d\d\d\d)/<dates><month>--$2<\/month><year>$4<\/year><\/dates>/g;
		s/(\d(?:|\d))(\/)(\d(?:|\d))(\/)(\d\d\d\d)/<dates><day>---$1<\/day><month>--$3<\/month><year>$5<\/year><\/dates>/g;
		s/(\d(?:|\d))(\/)(\d\d\d\d)/<dates><month>--$1<\/month><year>$3<\/year><\/dates>/g;
		# Separation par trait / + an en deux chiffres:
		s/(, )(\d(?:|\d))(\/)(\d(?:|\d))(\/)(\d\d)/<dates><day>---$2<\/day><month>--$4<\/month><year>19$6<\/year><\/dates>/g;
		s/(, )(\d(?:|\d))(\/)(\d\d)/<dates><month>--$2<\/month><year>19$4<\/year><\/dates>/g;
		s/(\d(?:|\d))(\/)(\d(?:|\d))(\/)(\d\d)/<dates><day>---$1<\/day><month>--$3<\/month><year>19$5<\/year><\/dates>/g;
		s/(\d(?:|\d))(\/)(\d\d)/<dates><month>--$1<\/month><year>19$3<\/year><\/dates>/g;
		
		
		
		# nom de mois + an:
		s/(jan(?:|v)\.)( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--01<\/month><year>$3<\/year><\/dates>/g;
		s/(fév\.)( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--02<\/month><year>$3<\/year><\/dates>/g;
		s/(mar(?:s|\.))( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--03<\/month><year>$3<\/year><\/dates>/g;
		s/(avr(?:\.|il))( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--04<\/month><year>$3<\/year><\/dates>/g;
		s/(mai)( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--05<\/month><year>$3<\/year><\/dates>/g;
		s/(juin(?:|\.))( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--06<\/month><year>$3<\/year><\/dates>/g;
		s/(juil(?:|l)\.)( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--07<\/month><year>$3<\/year><\/dates>/g;
		s/(ao(?:û|u)t)( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--08<\/month><year>$3<\/year><\/dates>/g;
		s/(sep(?:|t)\.)( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--09<\/month><year>$3<\/year><\/dates>/g;
		s/(oct\.)( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--10<\/month><year>$3<\/year><\/dates>/g;
		s/(nov\.)( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--11<\/month><year>$3<\/year><\/dates>/g;
		s/(d(?:é|e)c\.)( )(\d\d\d\d)(<?!\/fullDate>)/<dates><month>--12<\/month><year>$3<\/year><\/dates>/g;
		
		# Precedants precedes d'un jour:
		# Numeros:
		s/(\(|f(?:l|r)\. )(\d+)( )(<dates>)(<month>)/$1$4<day>---$2<\/day>$5/g;
		
		# Special volume 29 etc.:
		# Dates numeriques:
		# Format: Jour.Mois.Annee (example: 5.12.1999):
		s/(\d|\d\d)(?:\.)(\d|\d\d)(?:\.|\. )(1(?:7|8|9)\d\d)/<dates><day>---$1<\/day><month>--$2<\/month><year>$3<\/year><\/dates>/g;
		# Format: Mois.Annee
		s/(\d|\d\d)(?:\.|\. )(1(?:7|8|9)\d\d)/<dates><month>--$1<\/month><year>$2<\/year><\/dates>/g;
		
		
		
		# Fin de la section "Special volume 29 etc."
		
		
		# Ajoute des zeros au jours:
		s/(<day>---1<\/day>)/<day>---01<\/day>/g;
		s/(<day>---2<\/day>)/<day>---02<\/day>/g;
		s/(<day>---3<\/day>)/<day>---03<\/day>/g;
		s/(<day>---4<\/day>)/<day>---04<\/day>/g;
		s/(<day>---5<\/day>)/<day>---05<\/day>/g;
		s/(<day>---6<\/day>)/<day>---06<\/day>/g;
		s/(<day>---7<\/day>)/<day>---07<\/day>/g;
		s/(<day>---8<\/day>)/<day>---08<\/day>/g;
		s/(<day>---9<\/day>)/<day>---09<\/day>/g;
		
		# Ajoute des zeros au mois:
		s/(<month>--1<\/month>)/<month>--01<\/month>/g;
		s/(<month>--2<\/month>)/<month>--02<\/month>/g;
		s/(<month>--3<\/month>)/<month>--03<\/month>/g;
		s/(<month>--4<\/month>)/<month>--04<\/month>/g;
		s/(<month>--5<\/month>)/<month>--05<\/month>/g;
		s/(<month>--6<\/month>)/<month>--06<\/month>/g;
		s/(<month>--7<\/month>)/<month>--07<\/month>/g;
		s/(<month>--8<\/month>)/<month>--08<\/month>/g;
		s/(<month>--9<\/month>)/<month>--09<\/month>/g;
		
		
		# Sous-collections restantes:
		s/(\()(f(?:l|r)\.|f(?:l|r)\.(?:,| et) f(?:l|r)\.)( )(<dates>)/$1<subCollection>$2<\/subCollection>$4/g;
		
		
		
		
		# collectionAndTypes
		# Format WAG, WAG! ou WAG (holotype):
		s/(<\/(?:dates|subCollection)>\)(?:|,) )((?:A|B|BM|BOL|BR|BREM|C|COI|E|EA|ENT|F|FHI|FHO|FI|G|GB|GH|GOET|GRA|GRO|HAL|omn\. HBG|HBG|IFAN|IRSC|JE|K|L|LBV|LD|LE|LISC|LISU|LY|M|MO|MPU|NBG|NLI|NY|P|PR|PRE|PRF|S|SL|SRGH|TCD|TOM|U|UC|UCI|UPS|US|W|omn\. WAG|WAG|WRSL|WU|YA|Z)(?:| \((?:(?:|holo|iso|iso-néo|néo|para)type(?:|s)|non vidi)\)|!)(?:(?:,|) (?:A|B|BM|BOL|BR|BREM|C|COI|E|EA|ENT|F|FHI|FHO|FI|G|GB|GH|GOET|GRA|GRO|HAL|omn\. HBG|HBG|IFAN|IRSC|JE|K|L|LBV|LD|LE|LISC|LISU|LY|M|MO|MPU|NBG|NLI|NY|P|PR|PRE|PRF|S|SL|SRGH|TCD|TOM|U|UC|UCI|UPS|US|W|omn\. WAG|WAG|WRSL|WU|YA|Z)(?:| \((?:(?:|holo|iso|iso-néo|néo|para)type(?:|s)|non vidi)\)|!))+)(<\/gathering>)/$1<collectionAndType>$2<\/collectionAndType>$3/g;
		
		s/(<\/(?:dates|subCollection)>\)(?:|,) )((?:A|B|BM|BOL|BR|BREM|C|COI|E|EA|ENT|F|FHI|FHO|FI|G|GB|GH|GOET|GRA|GRO|HAL|omn\. HBG|HBG|IFAN|IRSC|JE|K|L|LBV|LD|LE|LISC|LISU|LY|M|MO|MPU|NBG|NLI|NY|P|PR|PRE|PRF|S|SL|SRGH|TCD|TOM|U|UC|UCI|UPS|US|W|omn\. WAG|WAG|WRSL|WU|YA|Z)(?:| \((?:(?:|holo|iso|iso-néo|néo|para)type(?:|s)|non vidi)\)|!))(<\/gathering>)/$1<collectionAndType>$2<\/collectionAndType>$3/g;
		
		# Format (K!) ou (K):
		s/(\((?:A|B|BM|BOL|BR|BREM|C|COI|E|EA|ENT|F|FHI|FHO|FI|G|GB|GH|GOET|GRA|GRO|HAL|omn\. HBG|HBG|IFAN|IRSC|JE|K|L|LBV|LD|LE|LISC|LISU|LY|M|MO|MPU|NBG|NLI|NY|P|PR|PRE|PRF|S|SL|SRGH|TCD|TOM|U|UC|UCI|UPS|US|W|omn\. WAG|WAG|WRSL|WU|YA|Z)(?:!|)\))/<collectionAndType>$1<\/collectionAndType>/g;
		# Format (K! L!) ou (K L):
		s/(\((?:A|B|BM|BOL|BR|BREM|C|COI|E|EA|ENT|F|FHI|FHO|FI|G|GB|GH|GOET|GRA|GRO|HAL|omn\. HBG|HBG|IFAN|IRSC|JE|K|L|LBV|LD|LE|LISC|LISU|LY|M|MO|MPU|NBG|NLI|NY|P|PR|PRE|PRF|S|SL|SRGH|TCD|TOM|U|UC|UCI|UPS|US|W|omn\. WAG|WAG|WRSL|WU|YA|Z)(?:!|)(?:(?:|,) (?:A|B|BM|BOL|BR|BREM|C|COI|E|EA|ENT|F|FHI|FHO|FI|G|GB|GH|GOET|GRA|GRO|HAL|omn\. HBG|HBG|IFAN|IRSC|JE|K|L|LBV|LD|LE|LISC|LISU|LY|M|MO|MPU|NBG|NLI|NY|P|PR|PRE|PRF|S|SL|SRGH|TCD|TOM|U|UC|UCI|UPS|US|W|omn\. WAG|WAG|WRSL|WU|YA|Z)(?:!|))+\))/<collectionAndType>$1<\/collectionAndType>/g;
		
		
		# Localites:
		
		# Tag d'ouverture:
		# Apres (alternative)fieldnum:
		s/(<\/fieldNum>|<\/alternativeFieldNum>\))(, )/$1<locality class="locality">/g;
		
		# Tag de fermeture:
		# Avant sous-collection:
		s/( )(\(<subCollection>)/<\/locality>$2/g;
		# Avant dates seules:
		s/( )(\(<dates>)/<\/locality>$2/g;
		# Entre altitude et tag de fermeture de gathering:
		s/(<\/altitude>)(<\/gathering>)/$1<\/locality>$2/g;
		
		s/(<locality class="locality">)([[:upper:]][[:upper:][:lower:] \d-]+)(<\/gathering>(?:<br \/>|;))/$1$2<\/locality>$3/g;
		
		
		
		
		# Special vol 29 etc.:
		# Inverse tag de dates et tag de fermeture pour la localite:
		s/(?: |, |)(<dates>(?:|<day>---\d\d<\/day>)<month>--\d\d<\/month><year>\d\d\d\d<\/year><\/dates>)(<\/locality>)/$2, $1 /g;
		
		
		# Cas specifiques pour les localites:
		# Sans location:
		s/(<locality class=")(locality)(">)(s(?:|in)\.(?:| )l(?:|oc)(?:\.|)|sans localité)/$1unknown$3$4/g;
		
		# Comme location precedente:
		s/(<locality class="locality")(>)(eod\. loc\.)/$1 isPreviousLocality="true"$2$3/g;
		
		# Localite incertaine:
		s/(<locality class="locality" isPreviousLocality="true")(>eod\. loc\. \(\?\)<\/locality>)/$1 doubtful="true"$2/g;
		s/(<locality class="locality")(>[[:upper:][:lower:], \.\(\)]+ \(\?\)<\/locality>)/$1 doubtful="true"$2/g;
		
		
		# Elimine tags de localite en double:
		s/(<\/locality>(?:|, ))(<\/locality>)/$1/g;
		s/(<\/locality>)((?:|, )[[:upper:][:lower:], '-\.0-9]+<\/locality>)/$2/g;
		
		s/(<locality class="[a-z]+">[[:upper:][:lower:], '-\.0-9]+)(<locality class="[a-z]+">)/$1/g;
		
		
		
		
		# Special 5bis:
		# s/(<\/coordinates>)(<\/locality>)(, )(\w.+?)(| )(\((d+|\w.+?)\)(|\.)<\/gathering>|<\/gathering>)/$1$4<\/locality>$6/g;
		# Normal:
		# s/(<\/fieldNum>)(, )(\w.+?)(| )(\((d+|\w.+?)\)(|\.)<\/gathering>|<\/gathering>)/$1<locality class="locality">$3<\/locality>$5/g;
		# s/(, )(\w.+?)(| )(\((d+|\w.+?)\)(|\.)<\/gathering>|<\/gathering>)/<locality class="locality">$2<\/locality>$4/g;
		# s/(sans localité(?:| précise)|sans indication du lieu de récolte)((|\.)<\/gathering>|<\/gathering>)/<locality class="unknown">$1<\/locality>$2/g;
		
		
		
	
	}
	
	# Pour eviter l'ajout de tags au mauvais endroits, on evite les parties qui ont deja des tags:
	if (/^(?!\t*<)(?!.+xmlns:xsi)/) {
	
		# Notes taxonomiques:
		s/(^)(Affinité(?:|s)|Note(?:|s) taxonomique(?:|s)(?:\.|:)|NOTES TAXONOMIQUES:)(.+)($)/$1\t\t\t<feature class="taxonomy" isNotes="true">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
		s/(^)(NOTES TAXONOMIQUES:)($)/$1\t\t\t<feature class="taxonomy" isNotes="true">\n\t\t\t\t<string><subHeading>$2<\/subHeading><\/string>\n\t\t\t<\/feature>/;
		s/(^)(AFFINITÉS(?:\.|:))(.+)($)/$1\t\t\t<feature class="taxonomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
		
		s/(^)(Environ \d+ espèces)(.+)($)/$1\t\t\t<feature class="taxonomy">\n\t\t\t\t<string>$2$3<\/string>\n\t\t\t<\/feature>/;
		
		
		
		# Notes:
		s/(^)((?:Remarque(?:|s)|Nota(?:|s)|Note(?:|s)|NOTE(?:|S)|NOTA|Observation(?:|s)|REMARQUE(?:|S))(?:\.|:))(.+)($)/$1\t\t\t<feature class="notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
		s/(^)(Obs\. — )(.+)($)/$1\t\t\t<feature class="notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
		
		# Notes - version seul titre:
		s/(^)((REMARQUE(?:|S))(?:\.|:))($)/$1\t\t\t<feature class="notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>/;
		
		
		# Ecologie et habitat:
		s/(^)(Ecologie|Herbe fréquente)(.+)($)/$1\t\t\t<feature class="habitatecology">\n\t\t\t\t<string>$2$3<\/string>\n\t\t\t<\/feature>/;
		s/(^)((?:É|E)COLOGIE:|(?:É|E)cologie:|L'écologie varie aussi:|Les données écologiques sont variables:)( )(.+)($)/$1\t\t\t<feature class="habitatecology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<habitat>$4<\/habitat><\/string>\n\t\t\t<\/feature>/;
		
		# Ecologie:
		# s/(^)((?:É|E)cologie:|(?:É|E)COLOGIE:)(.+)($)/$1\t\t\t<feature class="ecology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
		
		
		
		# Habitat:
		s/(^)(Habitat d'après Robyns et Wilczek:)(.+)($)/$1\t\t\t<feature class="habitat">\n\t\t\t\t<string><subHeading>$2<\/subHeading><habitat>$3<\/habitat><\/string>\n\t\t\t<\/feature>/;
		s/(^)(Altitude|Cette espèce est connue dans la forêt dense humide|Cette plante se rencontre dans les forêts ombrophiles|dans des zones de forêt dense humide sempervirente|(?:D|d)ans les forêts (?:dense|marécageuse|ombrophile|ripicole)(?:s|)|dans les zones de forêt dense humide|dans les fourrés littoraux|Elle semble préférer les zones marécageuses|Espèce (?:de forêt dense humide|héliophile|forestière|ripicole)|(?:F|En f)orêt(?:|s) (?:de montagne|marécageuse(?:|s)|ombrophile(?:|s)|ripicole(?:|s)|secondaire(?:|s)|semi-décidue(?:|s)|sublittorale(?:|s)|dense(?:|s)|(?:|très )humide(?:|s)|et lisières très humides)|Habitat|Lieux humides,|Sous-bois (?:des forêts|forestier)|Plante(?:|s) (?:des sous-bois ombragés|ripicoles ou de forêts humides)|Même habitat ripicole|Plante de rochers et sommets découverts|(?:S|s|En s)avanes|(?:S|s|En s)ous(?: |-)bois|Lieux frais demi-ombragés|Terrains découverts et ensoleillés|(?:Berges|Sols) sableu(?:x|ses)|Bancs vaseux|Sables littoraux|Elle croît en terrains découverts|Pentes de montagnes|Lisières|Rives de fleuves|Forêts et friches|Bords de (?:cours d'eau|rivières)|Forêt ou haute brousse secondaire|En forêt(?:|s) (?:dense|marécageuse|ombrophile|ripicole)(?:|s)|Talus drainés|Plante de sous-bois|Rochers isolés|De lisières forestières|Bosquets|Plante de forêts sublittorales|Son biotope|dans les galleries forestières)(.+)($)/$1\t\t\t<feature class="habitat">\n\t\t\t\t<string><habitat>$2$3<\/habitat><\/string>\n\t\t\t<\/feature>/;
		s/(^)(en savane\.(?:| ))($)/$1\t\t\t<feature class="habitat">\n\t\t\t\t<string><habitat>$2<\/habitat><\/string>\n\t\t\t<\/feature>/;
		
		
		if (/^(?!\t*<)(?!.+xmlns:xsi)/) {
			s/(^)(.+)(\. Altitude |commune (?:dans (?:les marécages|le sous-bois forestier)|de la brousse)|croît dans les forêts denses|des formations forestières|le bord des cours d'eau|les forêts denses humides|pousse (?:|surtout )(?:dans les (?:forêts|lieux humides)|au bord des rivières)|se rencontre (?:dans les (?:forêts|recrus)|sur le bord de mer)|fréquente au bord des routes)(.+)($)/$1\t\t\t<feature class="habitat">\n\t\t\t\t<string><habitat>$2$3$4<\/habitat><\/string>\n\t\t\t<\/feature>/;
		}
		
		# Chromosomes:
		s/(^)(Le(?:|s) nombre(?:|s) chromosomique(?:|s))(.+)($)/$1\t\t\t<feature class="cytology">\n\t\t\t\t<string>$2$3<\/string>\n\t\t\t<\/feature>/;
		
		
		# Morphologie:
		s/(^)(Note morphologique:)($)/$1\t\t\t<feature class="morphology" isNotes="true">\n\t\t\t\t<string><subHeading>$2<\/subHeading><\/string>\n\t\t\t<\/feature>/;
		
		
		# Pollinisateurs:
		s/(^)(Pollinisateur(?:|s):)(.+)($)/$1\t\t\t<feature class="pollination">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
		s/(^)(La pollinisation)(.+)($)/$1\t\t\t<feature class="pollination">\n\t\t\t\t<string>$2$3<\/string>\n\t\t\t<\/feature>/;
		
		
		
		# Floraison:
		s/(^)(L(?:a|es) floraison(?:|s))(.+)($)/$1\t\t\t<feature class="pollination">\n\t\t\t\t<string>$2$3<\/string>\n\t\t\t<\/feature>/;
		
		# Etymologie:
		s/(^)((?:E|É)tymologie(?:| grecque):)(.+)($)/$1\t\t\t<feature class="etymology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
		s/(^)((?:E|É)tymologie |L'étymologie du nom)(.+)($)/$1\t\t\t<feature class="etymology">\n\t\t\t\t<string>$2$3<\/string>\n\t\t\t<\/feature>/;
		
		# Distribution/Répartition:
		s/(^)((?:Distribution|Distribution d'ensemble|Distribution générale(?: \(.+\)|, toutes variétés réunies)|Répartition|Répartition géographique|DISTRIBUTION G(?:É|E)OGRAPHIQUE|DISTRIBUTION|NOTES PHYTOG(?:É|E)OGRAPHIQUES|R(?:É|E)PARTITION|R(?:É|E)PARTITION G(?:É|E)OGRAPHIQUE)(?:\.|:|\. — ))(.+)($)/$1\t\t\t<feature class="distribution">\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
		
		if (/^(?!\t*<)(?!.+xmlns:xsi)/) {
			s/(^)(?!\()(.+)(connue(?:|s)(?:| uniquement| également| seulement) (?:d(?:e|u)|au|en)|de l'hémisphère|distribuée(?:|s)|(?:E|e)ndémique (?:au|de|d'|du|gabonais)|groupe au Cameroun|localisée(?:|s)(?! sur le stigmate)|régions (?:chaudes du globe|tempérées)|répandue|répartie|répartition|représentée seulement|s'étend (?:de la|du)|(?<!: )(?:S|s)ignalé(?:|e)(?:|s)|se rencontr(?:ant|e|ent)(?! dans certains genres)|très fréquemment cultivée|existe probablement|n'est connue qu(?:'au|e du)|îlot du moyen Ivindo|A rechercher au Gabon|des zones tempérées)(.+)($)/$1\t\t\t<feature class="distribution">\t\t\t\t<string>$2$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		s/(^)(Aire (?:de dispersion couvrant|limitée)|(?:C|c)onnue(?:|s)(?:| uniquement) d(?:e|u)|Cosmopolite|(?:Cette|E)spèce (?:a une aire s'étendant (?:de|du)|banale (?:au|sur|de|du|en)|confinée au|(?:est |)connue (?:(?:actuellement |seulement |)au|sur|de|du|en)|croissant (?:|également )au|endémique|gabonaise|d'origine|n'est à ce jour connue que|originaire (?:au|sur|de|du|en)|pantropicale|représentée (?:au|sur|de|du|en)|trouvée (?:au|sur|de|du|en)|(?:au|de|du|en))|Distribution de|Elle pourrait exister|Endémique|Genre (?:africain|banal (?:au|sur|de|du|en)|circumtropical|connu (?:au|sur|de|du|en)|de l'Afrique|endémique|monospécifique|monotypique|d'origine|originaire (?:au|sur|de|du|en)|paléotropical|pantropical|répandu|représenté (?:au|sur|de|du|en)|trouvé (?:au|sur|de|du|en))|(?:O|o)riginaire d(?:'|e|u)|Présence probable|(?:S|s)ignalé(?:|e)(?:|s)|Tropiques|du (?:Cameroun|Gabon)|depuis (?:la|le|l')|L'aire (?:d'extension de cette espèce couvre|de cette plante s'étend (?:de|sur)|de cette espèce est)|Répandu dans tout)(.+)($)/$1\t\t\t<feature class="distribution">\t\t\t\t<string>$2$3<\/string>\n\t\t\t<\/feature>/;
		
		# Commencant par un pays ou continent:
		s/(^)((?:En A|Espèce de l'A|A)frique équatoriale: |(?:Espèce très commune en A|A)frique occidentale|(?:Répandue en A|A)frique orientale|(?:|Toute l')Afrique|(?:|(?:Espèce à|A) rechercher au |Du )Camero(?:o|u)n|(?:|Surtout au )Congo|(?:|(?:D|d)e la |de )Côte(?: |-)d'Ivoire|(?:Endémique du G|Espèce à rechercher au G|G)abon|Ghana|(?:|(?:D|d)e la )Guinée|Liberia|(?:|(?:A|a)u )Nigeria|S(?:\.|ud) Nigeria|Pays Batéké|(?:|Du )Sénégal|Sénégambie|Sierra(?: |-)Leone|Togo|Zaïre|Zimbabwe)(.+)($)/$1\t\t\t<feature class="distribution">\t\t\t\t<string>$2$3<\/string>\n\t\t\t<\/feature>/;
		
		
		# Descriptions:
		s/(^)(Annuelle(?:|s)|Appareil végétatif|(?:Petit(?:|s) a|Très grand(?:|s) a|Grand(?:|s) a|A)rbre|Arbrisseau|(?:A|Grand(?:|s) a|Petit(?:|s) a)rbuste(?:|s| ou petit arbre)|Arbrisseaux|(?:(?:Petits ou g|G)rand(?:|s) b|B)uisson|Chaumes|(?:Plantes é|E|É|Petit (?:é|e))piphyte(?:|s)|Feuille(?:|s) (?:<|\d+-\d|\d+|de \d|coriace(?:|s)|distique(?:|s)|en général étroite(?:|s)|en rosette|flottante(?:|s)|imparipennée(?:|s)|nombreuse(?:|s)|oblongue(?:|s)|pétiolée(?:|s)|plissée(?:|s)|prostrée|solitaire|trinervié(?:|s)|tri- ou pluri-nerviée(?:|s))|Fleurs grandes|Fougères (?:|herbacées)|Petite(?:|s) fougère(?:|s)|Fronde(?:|s) (?:en touffe|flottante|large|pennée|rapprochée)(?:|s)|Genre très caractérisé|Gynostème|C'est un(?:|e) (?:arbre|arbuste|herbe)|(?:Grande|Petite)(?:|s) herbe(?:|s)|(?:Très grande h|H)erbe(?:|s)|(?:Petite h|H)erbacée(?:|s)|Inflorescence|Jusqu'à \d|Labelle|Organes (?:de réserve souterrains|pérennes)|Ovaire|Partie dressée de la plante|Petite(?:|s) plante(?:|s) (?:au rhizome|épiphyte)|Plante(?:|s) annuelle(?:|s)|Plante(?:|s) de \d|Plante(?:|s) (?:<|atteignant|(?:|généralement )avec des pseudobulbes|basse|epiphyte|flottante|grimpante|herbacée|inerme|ligneuse|monoïques|(?:|exclusivement )monopodiales|parasites|pérenne|petites à moyennes|radicante|rampante|robuste|souvent aphylles|(?:|presque toutes )vivace|terrestre)(?:|s)|Pennes espacées de \d|Pétioles atteignant|Racines fasciculées|Jeunes rameaux (?:glabres|vigoureux)|(?:(?:Très g|G)rande(?:|s) l|Petite(?:|s) l|Forte(?:|s) l|L)iane|Plante(?:|s) (?:émergeante(?:|s)|grêle|habituellement robuste|holoparasite(?:|s)|lianoïde|(?:|relativement )petites)|Port très variable|Pseudobulbes|Racines|Rameaux|Rhizome(?:|s) (?:à écaille|appliqué au support|ascendant|court|couvert|dressé|épais|filiforme|grimpant|mince|oblique|portant|ramifié)(?:|s)|Rhizome(?:|s) (?:charnu|globuleux|rameux)|(?:Très gros r|R)hizome(?:|s) (?:|courtement |lâchement |très longuement |longuement )rampant(?:|s)|Rhizophores (?:courts|de \d| dorsaux|généralement|limités|localisés)|Rostellum|Sous-arbrisseau|Sous-arbuste(?:|s)|Stolons|Suffrutex|Tige(?:|s) (?:atteignant|de|s'enracinant|feuillées|principales)|Tige(?:|s)|Touffes|Tronc (?:|épineux)(?:de \d)|Tubercule(?:|s)|Voile)(.+)($)/$1\t\t\t<feature class="description">$2$3<\/feature>/;
		
		if (/^(?!\t*<)(?!.+xmlns:xsi)/) {
			s/(^)(.+)(est un(?:|e) (?:arbuste|petit arbre|petite liane)|Arbrisseaux ou herbes|devient une grande liane|Etages de frondes|Pétiole épais|Inflorescence formée)(.+)($)/$1\t\t\t<feature class="description">$2$3$4<\/feature>/;
		}
		
		
		
		# Descriptions Latines:
		s/(^)(Arbuscula|Arbor|Herba|Rhizomate tenui(?: |,))(.+)($)/$1\t\t\t<feature class="description" lang="la">$2$3<\/feature>/;
		if (/^(?!\t*<)(?!.+xmlns:xsi)/) {
		s/(^)(.+)(Caules foliosae|Herba foliis|ovalis lanceolata)(.+)($)/$1\t\t\t<feature class="description" lang="la">$2$3$4<\/feature>/;
		}
		
		# Repare descriptions reconnues comme distributions:
		s/(<feature class=")(distribution)(">)(\t+<string>)(Arbres et arbustes.+)(<\/string>)(\n\t+)(<\/feature>)/$1description$3$5$8/;
		
		# Usages:
		s/(^)((?:Propri(?:e|é)t(?:e|é)|PROPRI(?:E|É)T(?:E|É)S|Propri(?:e|é)t(?:e|é) et utilisations|PROPRI(?:E|É)T(?:E|É)(?:|S) ET USAGE(?:|S)|Propri(?:e|é)t(?:e|é)s et utilisations|UTILISATION(?:|S))(?:\.|:))(.+)($)/$1\t\t\t<feature class="uses">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
		
		s/(^)(Bois dur|C'est un fourrage|Fourrage|Valeur fourragère|Fruit(?:|s) (?:à usages|comestible(?:|s)|utilisé))(.+)($)/$1\t\t\t<feature class="uses">\n\t\t\t\t<string>$2$3<\/string>\n\t\t\t<\/feature>/;
		
		if (/^(?!\t*<)(?!.+xmlns:xsi)/) {
			s/(^)(.+)(ont de nombreux usages|sont exploités|est exploité(?:|e)|est le principal fournisseur|utilisées|les propriétés et usages font l'objet de peu|serait utilisé)(.+)($)/$1\t\t\t<feature class="uses">\n\t\t\t\t<string>$2$3$4<\/string>\n\t\t\t<\/feature>/;
		}
		
		s/(^)(Notes économiques et sur les usages(?:\.|:))(.+)($)/$1\t\t\t<feature class="uses" isNotes="true">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
		
		
		
	}
	
	print OUT $_; 
}

close IN;
close OUT;