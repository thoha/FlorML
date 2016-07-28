#!/usr/bin/perl
# atomizer.pl
# Atomizes characters, distributions, literature, specimens, stc.



use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {

	# TODO: have GU, BR, etc. in  large specimen lists in older volumes converted to Geoscopes - BETA version implemented
	
	# TODO: 
	# 1) Add altitude mark-up to specimens/types (see code snippet in atom2.pl)
	# 2) FIX nameType mark-up to mark-up basionyms properly using nom class="basionym" !
	# 3) Improve specimenType atomisation.
	

	
	# References/Bibliography:
	
	# Bibliographies courtes vol 38+:
	if (/^\t\t\t<references><heading>BIBLIOGRAPHIE:<\/heading>/) {
		# Place le titre sur ligne separee:
		s/(^)(\t\t\t<references>)(<heading>BIBLIOGRAPHIE:<\/heading>)/$1$2\n\t\t\t\t$3/;
		
		# Ajoute tags de reference:
		s/(:<\/heading>)( )/$1\n\t\t\t\t<literatureRef ref="">/;
		s/(, (?!\d))/<\/literatureRef>\n\t\t\t\t<literatureRef ref="">/g;
		s/(\.)(<\/references>)/<\/literatureRef>\n\t\t\t$2/;
		
		# Atomisation:
		s/([[:upper:][:lower:] &\.-]+)( \()(\d\d\d\d(?:[[:lower:]]|)(?:|(?:, \d\d\d\d(?:[[:lower:]]|))+))(\))/\n\t\t\t\t\t<refPart class="author">$1<\/refPart>\n\t\t\t\t\t<refPart class="year">$3<\/refPart>\n\t\t\t\t/g;
		
		s/(, )(\d\d\d\d)/<\/refPart>\n\t\t\t\t<\/literatureRef>\n\t\t\t\t<literatureRef ref="">\n\t\t\t\t\t<refPart class=""><\/refPart>\n\t\t\t\t\t<refPart class="year">$2/g;
		
		
		
	}
	
	
	
	
	# Toutes les lignes qui ne commencent pas avec <, ou ne finissent pas sur <br /> ou </string>, ou ne sont pas le doctype:
	if (/^<reference>/) {
		
		# Bibliographies longues (vol. 38+):
		s/(^)(BIBLIOGRAPHIE)($)/\t<textSection type="bibliography">\n\t\t<references>\n\t\t\t<heading>$2<\/heading>/;
		
		
		# Reference sections:
		
		# Author Annee. Titre. Editeurs, Journal Volume: Pages. Maison d'edition, Location.
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )(.+?)(\. In )([[:upper:]].+\((?:E|e|é)d(?:|s)(?:|\.)\))(, )([[:upper:][:lower:] \.].+)( )(\d+)(: )(\d+-\d+)(\. )([[:upper:][:lower:] ]+)(, )([[:upper:][:lower:]]+)(\.)($)/$1\t\t\t\t\t\t<reference>\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="editors">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$12<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$14<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$16<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publocation">$18<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		# Author Annee. Titre. Editeurs, Journal: Pages. Maison d'edition, Location.
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )(.+?)(\. In )([[:upper:]].+\((?:E|e|é)d(?:|s)(?:|\.)\))(, )([[:upper:][:lower:] \.].+)(: )(\d+-\d+)(\. )([[:upper:][:lower:] ]+)(, )([[:upper:][:lower:]]+)(\.)($)/$1\t\t\t\t\t\t<reference>\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="editors">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$12<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$14<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publocation">$16<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		# Author Year. Title. Editor, Journal Volume(Issue): Pages
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )(.+?)(\. In )([[:upper:][:lower:] \.&-]+)(, )([[:upper:][:lower:] \.].+)( )(\d+)(\()(\d+(?:[[:lower:]]|))(\): )(\d+(?:-\d+||-\d+ and \d+-\d+|))(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t<refPart class="editors">$9<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$11<\/refPart>\n\t\t\t\t\t<refPart class="volume">$13<\/refPart>\n\t\t\t\t\t<refPart class="issue">$15<\/refPart>\n\t\t\t\t\t<refPart class="pages">$17<\/refPart>\n\t\t\t\t$19/;
		# Author Year. Title. Editor, Journal Volume: Pages
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )(.+?)(\. In )([[:upper:][:lower:] \.&-]+)(, )([[:upper:][:lower:] \.].+)( )(\d+)(: )(\d+(?:-\d+|-\d+ and \d+-\d+|))(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t<refPart class="editors">$9<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$11<\/refPart>\n\t\t\t\t\t<refPart class="volume">$13<\/refPart>\n\t\t\t\t\t<refPart class="pages">$15<\/refPart>\n\t\t\t\t$17/;
		# Author Year. Title. Editor, Journal. Pages
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )(.+?)(\. In )([[:upper:][:lower:] \.&-]+)(, )([[:upper:][:lower:] \.].+)(\. )(\d+ pp\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t<refPart class="editors">$9<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$11<\/refPart>\n\t\t\t\t\t<refPart class="pages">$13<\/refPart>\n\t\t\t\t$14/;
		
		
		# Author Year. Title. Journal Volume(Issue): Pages
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )(.+?)(\. )([[:upper:][:lower:] \.].+)( )(\d+)(\()(\d+)(\): )(\d+(?:-\d+|))(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$9<\/refPart>\n\t\t\t\t\t<refPart class="volume">$11<\/refPart>\n\t\t\t\t\t<refPart class="issue">$13<\/refPart>\n\t\t\t\t\t<refPart class="pages">$15<\/refPart>\n\t\t\t\t$17/;
		# Author Year. Title. Journal Volume: Pages
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )(.+?)(\. )([[:upper:][:lower:] \.].+)( )(\d+)(: )(\d+(?:-\d+|))(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$9<\/refPart>\n\t\t\t\t\t<refPart class="volume">$11<\/refPart>\n\t\t\t\t\t<refPart class="pages">$13<\/refPart>\n\t\t\t\t$15/g;
		# Author Year. Title, Journal, Volume: Pages
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )(.+?)(, )([[:upper:][:lower:] \.].+)(, )(\d+)(: )(\d+(?:-\d+|))(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$9<\/refPart>\n\t\t\t\t\t<refPart class="volume">$11<\/refPart>\n\t\t\t\t\t<refPart class="pages">$13<\/refPart>\n\t\t\t\t$15/g;
		# Author Year. Title. Journal Volume
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )(.+?)(\. )([[:upper:][:lower:] \.].+)( )(\d+)(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$9<\/refPart>\n\t\t\t\t\t<refPart class="volume">$11<\/refPart>\n\t\t\t\t$13/g;
		
		
		# Author Annee. Titre. Journal Volume: Pages. Maison d'edition, Location.
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )(.+?)(\. )([[:upper:][:lower:] \.].+)( )(\d+)(: )(\d+-\d+)(\. )([[:upper:][:lower:] ]+)(, )([[:upper:][:lower:]]+)(\.)($)/$1\t\t\t\t\t\t<reference id="">\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$12<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$14<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publocation">$16<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		# Author Annee. Titre. Journal: Pages. Maison d'edition, Location.
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )(.+?)(\. )([[:upper:][:lower:] \.].+)(: )(\d+-\d+)(\. )([[:upper:][:lower:] ]+)(, )([[:upper:][:lower:]]+)(\.)($)/$1\t\t\t\t\t\t<reference id="">\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$12<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publocation">$14<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		
		# Author Year. Book title. Publisher, Berlin, etc. Pages pp. (So this one's for exceptions)
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )([[:upper:][:lower:] \.].+)(\. )([[:upper:][:lower:] -\.]+)(, )(Berlin, etc\.)( )(\d+ pp\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$7<\/refPart>\n\t\t\t\t\t<refPart class="publisher">$9<\/refPart>\n\t\t\t\t\t<refPart class="publocation">$11<\/refPart>\n\t\t\t\t\t<refPart class="pages">$13<\/refPart>\n\t\t\t\t$14/g;
		
		# Author Year. Book title. Publisher: Location. Pages pp.
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )([[:upper:][:lower:] \.].+)(\. )([[:upper:][:lower:] -\.]+)(: )([[:upper:][:lower:] -]+)(\. )(\d+ pp\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$7<\/refPart>\n\t\t\t\t\t<refPart class="publisher">$9<\/refPart>\n\t\t\t\t\t<refPart class="publocation">$11<\/refPart>\n\t\t\t\t\t<refPart class="pages">$13<\/refPart>\n\t\t\t\t$14/g;
		
		# Author Year. Book title. Publisher, Location.
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )([[:upper:][:lower:] \.].+)(\. )([[:upper:][:lower:] -\.’]+)(, )([[:upper:][:lower:] -]+)(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$7<\/refPart>\n\t\t\t\t\t<refPart class="publisher">$9<\/refPart>\n\t\t\t\t\t<refPart class="publocation">$11<\/refPart>\n\t\t\t\t$13/g;
		
		# Author Year. Book title. Publisher.
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )([[:upper:][:lower:] \.].+)(\. )([[:upper:][:lower:] -]+)(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$7<\/refPart>\n\t\t\t\t\t<refPart class="publisher">$9<\/refPart>\n\t\t\t\t$11/g;
		
		
		# Author Year. Book title. ed. Edition
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )([[:upper:][:lower:] ,\.].+)(, )(ed\. \d+)(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$7<\/refPart>\n\t\t\t\t\t<refPart class="edition">$9<\/refPart>\n\t\t\t\t$11/g;
		
		# Author Year. Book title. p. Pages
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )([[:upper:][:lower:] ,\.].+)(\. )(p(?:p|)\. \d+-\d+)(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$7<\/refPart>\n\t\t\t\t\t<refPart class="pages">$9<\/refPart>\n\t\t\t\t$11/g;
		
		
		# Author Year. Book title.
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d))(\. )([[:upper:][:lower:] ,\.].+)(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$7<\/refPart>\n\t\t\t\t$9/g;
		
		
		# Author Year. Website title, URL
		s/(^)(<reference>)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]|-\d\d(?:\d\d|)))(\. )([[:upper:][:lower:] ,\.].+)(, )(www\.[[:lower:]]+\.net\/)(\.)(<\/reference>)($)/$1\t\t\t\t$2\n\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t<refPart class="pubname">$7<\/refPart>\n\t\t\t\t\t<refPart class="url">$9<\/refPart>\n\t\t\t\t$11/g;
		
		
		
		
	}
	
	
	# Nomenclature and citations are all lines that don't start with <, don't end with <br /> or </string>, or are not the doctype:
	if (/^(?!\t*<)(?![[:upper:]].+\.<br \/>$)(?![[:upper:]].+:<br \/>$)(?![[:upper:]].+<br \/>$)(?![[:upper:]].+<\/td>$)(?![[:upper:]].+<\/li>$)(?![[:upper:]].+<\/string>$)(?![[:upper:]].+<\/feature>$)(?!.+xmlns:xsi)/) {
		
		# Citations:
		if (/: | — |l\.c\.|I\.c\.|loc\. cit\.|Monandr\. Pl\.|Bijdr\.|Bot\. Reg\.|Cat\. Pl\. Cub\.|Cult\. Prot\.|Gén\. Pl\.|Fl\. Brit\. W\. I\.|Fl\. Indica|F\.T\.A\.| Éd\. |Enum\.|Esseq\.|Gard\. Dict\.|Gen\. Nov\. Madag\.|Hist\.|Hook\. (?:|f\. )Ic\. Pl\.|Iter Hispan\.|Linnaea|Mant\. Pl\.|mss\.|Parad\. Lond\.|Phytogr\.|Piperac\. N\.|Pl\. Surin\.|Prodr\.|Sp\. Pl\.|Stirpes Surinam\.|Suppl\. Carp\.|Suppl\. Pl\.|Sylva Tell\.|Syst\./) {
			
			
			# Insert citation start and end tags:
			s/(^)((?:[[:upper:]]|dans |in |cf\.|l\.c\.|I\.c\.|loc\. cit\.|cat\. Talb\. Nig\.|Bijdr\.|Cat\. Pl\. Cub\.|Cult\. Prot\.|Fl\. Brit\. W\. I\.|Fl\. Indica|Gard\. Dict\.|Gen\. Nov\. Madag\.|Iter Hispan\.|Mant\. Pl\.|mss\.|Parad\. Lond\.|Phytogr\.|Piperac\. N\.|Pl\. Surin\.|Prodr\.|Sp\. Pl\.|Stirpes Surinam\.|Suppl\. Carp\.|Suppl\. Pl\.|Syst\.)(?:.+|))($)/\t\t\t\t\t\t<citation class="publication">$2<\/citation>/;
			# Prodr. 847. 1788.
			# Splits multiple subsequent citations:
			s/(\.)( — )/$1<\/citation>\n\t\t\t\t\t\t<citation class="usage">/g;
			s/(; )/<\/citation>\n\t\t\t\t\t\t<citation class="usage">/g;
			
			
			# Citation Atomisation:
			
			# Citation end: Pages (Year)
			s/(<citation class="(?:usage|publication)">)(.+?)(: )(\d+-\d+|\d+ et \d+|\d+(?:, \d+)+|\d+|[IVXCML]+|\d+ p\.p\.)((?:\.|) )(\d\d\d\d|\d\d\d\d-\d\d\d\d|\d\d\d\d-\d\d)(\.|,| |)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			# Citation end: Pages Details (Year)
			s/(<citation class="(?:usage|publication)">)(.+?)(: )(\d+-\d+|\d+ et \d+|\d+(?:, \d+)+|\d+|[IVXCML]+)( |, )(.+?)((?:\.|) )(\d\d\d\d|\d\d\d\d-\d\d\d\d|\d\d\d\d-\d\d)(\.|,| |)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			
			# Citation end: Details (Year)
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|:) )((?:fig|f|(?:|Obs\. et )(?:T|t)ab|(?<!Mant\. )(?<!Sp\. )(?:P|p)l|t|op)\. (?:\d+|\d+ et \d+|\d+, (?:fig|f|(?:|Obs\. et )(?:T|t)ab|(?:P|p)l|t|op)\. (?:\d+|\d+-\d+|[[:lower:]])|[XIV]+)(?:|[[:upper:]]))(\. )(\d\d\d\d|\d\d\d\d-\d\d\d\d|\d\d\d\d-\d\d)(\.|,| |)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			
			# Citation end: Pages Details
			s/(<citation class="(?:usage|publication)">)(.+?)(: )(\d+-\d+|\d+, \d+|\d+)( |, )((?:fig|tab|t|Pl)\. \d+|.+?)(<\/citation>)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">$7/g;
			
			# Citation end: Pages
			s/(<citation class="(?:usage|publication)">)(.+?)(: )(\d+-\d+|\d+, \d+|\d+)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			# Citation: l.c. (Year):
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|:) )(\()(\d\d\d\d|\d\d\d\d-\d\d\d\d|\d\d\d\d-\d+)(\))/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			# Citation: Year:
			s/(<citation class="(?:usage|publication)">)(.+?)(\. )(\d\d\d\d|\d\d\d\d-\d\d\d\d|\d\d\d\d-\d\d)(\.|,| |)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			
			
			
			# Citation start: Publication name, Serie ser., Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:\de|[IVXCML]+\.) (?:sér|ser)\.|n\. s(?:|ér|er)\. Bot\.|Bot\. S(?:|ér)\.))((?:|,) )((?:t\. |)\d+|[IVXCML]+)((?:|,) )((?:|n° )\d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$8$9/g;
			
			# Citation start: Publication name, Serie ser., Volume
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:(?:\de|[IVXCML]+\.) (?:sér|ser|série)\.|n\. s(?:|ér|er)\. Bot\.)|(?:sér|ser|série)\. \d+(?:|[[:upper:]]|[[:lower:]])))((?:|,) )((?:t\. |)\d+|[IVXCML]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6$7/g;
			
			# Citation start: Publication name, Volume, série Serie,
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )(\d+)(, )(série \d)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$6$7/g;
			
			
			
			
			# Citation start: Publication name, ed. Edition, Volume
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:ed|éd)\.|(?:ed|éd)\. (?:\d+|[IVXCML]+)))(, |,| )(\d+(?:|b)|[IVXCML]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6$7/g;
			
			
			# Citation start: Publication name, ed. Edition
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:e|\.) (?:é|e|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4$5/g;
			
			
			# Citation start: ed. Edition, Volume
			s/(<citation class="(?:usage|publication)">)((?:\d+ (?:ed|éd)\.|(?:ed|éd)\. (?:\d+|[IVXCML]+)))((?:|,)(?:| ))(\d+|[IVXCML]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="edition">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4$5/g;
			
			
			
			
			# Citation start: Author, Publication name, Serie ser., Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d(?:e|°)|[IVXCML]+(?:\.|e)) (?:(?:(?:s|S)ér|(?:s|S)er|S)\.|(?:S|s)(?:e|é)rie)\.|n\. s(?:|ér|er)\. Bot\.|n\. s(?:|ér|er)\.|Bot\. S\.ser\. B|(?:S|s)(?:é|e)r\. (?:\d+(?:|[[:upper:]]|[[:lower:]])|[IVXCML]+)))((?:|,) )((?:t\. |)\d+|[IVXCML]+)((?:|,) )((?:|n° )\d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$10$11/g;
			
			# Citation start: Author, Publication name, Serie ser., Volume
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d(?:e|°)|[IVXCML]+(?:\.|e)) (?:(?:(?:s|S)ér|(?:s|S)er|S)\.|(?:S|s)(?:e|é)rie)\.|n\. s(?:|ér|er)\. Bot\.|n\. s(?:|ér|er)\.|Bot\. S\.|ser\. B|(?:S|s)(?:é|e)r\. (?:\d+(?:|[[:upper:]]|[[:lower:]])|[IVXCML]+)))((?:|,) )((?:t\. |)\d+|[IVXCML]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8$9/g;
			
			# Citation start: Author, Publication name, Serie ser.
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\de|[IVXCML]+\.) (?:sér|ser)\.|n\. s(?:|ér|er)\. Bot\.|Bot\. S\.|(?:sér|ser)\. \d+))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$6$7/g;
			
			# Citation start: Author, Publication name, Volume, App. appendix
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:t\. |)\d+|[IVXCML]+)((?:,|(?:|,) ))((?:(?:A|a)pp|(?:S|s)uppl)\.(?:| (?:\d+|[IVXCML]+)))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="appendix">$8$9/g;
			
			# Citation start: Author, Publication name, App. appendix
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:A|a)pp|(?:S|s)uppl)\.(?:| (?:\d+|[IVXCML]+)))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="appendix">$6$7/g;
			
			# Citation start: Author, Publication name, ed. Edition, Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))((?:|,) )(\d+)((?:,|(?:|,) ))((?:|n° |fasc\. |Mém\. )(?:\d+|[IVXCML]+))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$10$11/g;
			
			# Citation start: Author, Publication name, Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:t\. |)\d+|[IVXCML]+)((?:,|(?:|,) ))((?:|n° |no |fasc\. |Mém\. )(?:\d+(?:|[[:lower:]])|[IVXCML]+))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$8$9/g;
			
			# Citation start: Author, Publication name, ed. Edition, Volume
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))(,(?:| ))(\d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8$9/g;
			
			
			# Citation start: Author, Publication name, ed. Edition, Volume(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))((?:|,) )(\d+)((?:| )\()(\d+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$10$12/g;
			
			# Citation start: Author, Publication name, ed. Edition(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))((?:| )\()(\d+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$8$10/g;
			
			# Citation start: Author, Publication name, Volume(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )(\d+|[IVXCML]+)((?:| )\()(\d+|\d+-\d+|[IVXCML]+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$8$10/g;
			
			# Citation start: Publication name, ed. Edition, Volume(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))((?:|,) )(\d+)((?:| )\()(\d+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$8$10/g;
			
			# Citation start: Publication name, ed. Edition(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))((?:| )\()(\d+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$6$8/g;
			
			# Citation start: Publication name, Volume(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )(\d+)((?:| )\()(\d+(?:| [[:lower:]])|[IVXCML]+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$6$8/g;
			
			
			# Citation start: Publication name, Volume, App. appendix
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:t\. |)\d+|[IVXCML]+)((?:,|(?:|,) ))((?:(?:A|a)pp|(?:S|s)uppl)\.(?:| (?:\d+|[IVXCML]+)))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="appendix">$6$7/g;
			
			
			# Citation start: Author, Publication name vol. Volume
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)( |, )((?:vol\.|n°) \d+|[[:upper:]]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6$7/g;
			
			# Citation start: Author, Publication name, Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )(\d+)(, )(\d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$8$9/g;
			
			
			# Citation start: Publication name, t. Volume, fasc. Issue
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:t\.|tome|no) \d+)((?:,|(?:|,) ))((?:fasc\.|fascicule) \d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$6$7/g;
			
			
			# Citation start: Author, Publication name Volume
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)( |, )(\d+(?:|a)|[[:upper:]]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6$7/g;
			
			
			
			
			# Citation start: Publication name, Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:|t\. )(?:\d+|[IVXCML]+))((?:,|(?:|,) ))((?:|n° |fasc\. |Mém\.)\d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$6$7/g;
			
			# Citation start: Publication name Edition
			s/(<citation class="(?:usage|publication)">)(.+?)( |, )(Éd\. \d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4$5/g;
			
			# Citation start: Publication name, Volume
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:vol\.|n°|t\.) |)\d+|[IVXCML]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4$5/g;
			
			
			
			
			# Citation start: Author, Publication name
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4$5/g;
			
			
			# Citation start: Publication name Volume(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)( |, )(\d+|[[:upper:]]+)(\()(\d+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$6$8/g;
			
			
			
			# Citation start: Publication name
			s/(<citation class="(?:usage|publication)">)(.+?)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2$3/g;
			
			
			
			# Citation start: Author, mss.
			s/(<citation class="(?:usage|publication)">)([[:upper:]]+)(, )(mss\..+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t$5/g;
			
			# Citation start: mss. etc.
			s/(<citation class="(?:usage|publication)">)(mss\..+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t$3/g;
			
			# Citation: mss.
			s/(<citation class="(?:usage|publication)">)(mss\.)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t$3/g;
			
			
			
			
			# Details:
			s/(<refPart class=")(status)(">)(, |)((?:P(?:l\.|L)|fig\.|tab\.) \d+)(?:|\.)(<\/citation>)/$1details$3$5<\/refPart>\n\t\t\t\t\t\t<\/citation>/g;
			
			
			
			# Unrecognised Authors:
			s/(<refPart class="pubname">)(Alston(?:|\.)|Aubr(?:\.|éville)|A\. Chev\.|Chevalier\.|KEAY, Hutch\. et Dal(?:z|)\.|Engl(?:\.|ler) (?:|u\. |und |et )Prantl|Engl\.|Hack\.|Benth\. and Hook\. f\.|Hook\. f\.|Keay|(?:VAILL\. ex |)L\.|Linnaeus|Linn(?:é|É|\.)|LINN\.||Mart(?:\.|ius)|Exell et Mendonça|Louis et Mullenders|OLIV\.|Pellegrin|Rosc\.|Schnell\.|Desf\. ex Steud\.|WILLD\.)((?:|,) )(.+?)(<\/refPart>)/<refPart class="author">$2$5\n\t\t\t\t\t\t\t$1$4$5/g;
			
			# Unrecognised Notes:
			# ('1978'):
			s/(<refPart class=")status(">\('\d\d\d\d'\))\.(<\/citation>)/$1notes$2<\/refPart>\n\t\t\t\t\t\t$3/g;
			# as 'somespeciesepithet':
			s/(<refPart class=")status(">) (as [[:upper:][:lower:] ‘’']+)(?:\.|)(<\/citation>)/$1notes$2$3<\/refPart>\n\t\t\t\t\t\t$4/g;
			
			
			
			# Unrecognised Statuses:
			s/(<refPart class=")(details)(">)((?:|\()(?:p\.p\.|nomen)(?:|\))(?:|\.))(<\/refPart>)/$1status$3$4$5/g;
			s/(<refPart class="status">)(\()(p\.p\.|nomen)(\)(?:|\.))(<\/refPart>)/$1$3$5/g;
			
			# Unrecognised Series:
			s/(, )(sér\. \d+)(<\/refPart>)/$3\n\t\t\t\t\t\t\t<refPart class="series">$2$3/g;
			
			
			
			# Removal of the space just after the status tag and insertion of the closing status tag:
			s/(<refPart class="status">)((?:|\.|,) )(.+?)(<\/citation>)/$1$3<\/refPart>\n\t\t\t\t\t\t$4/g;
			# Removal of empty statuses:
			s/\t\t\t\t\t\t\t<refPart class="status">(?:|\.(?:| )|;)<\/citation>/\t\t\t\t\t\t<\/citation>/g;
			s/\t\t\t\t\t\t\t<refPart class="status">(?:|\.(?:| )|;)($)/\t\t\t\t\t\t<\/citation>/g;
			
			# Repairs nom., clav.:
			s/(<refPart class=")(details|status)(">nom(?:\.|en))(,)( clav\.<\/refPart>)/$1status$3 in$5/g;
			
			# Editors:
			s/(<refPart class=")(pubname)(">)(in )(.+?)(, )(.+?)/$1editors$3$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$7/g;
			s/(<refPart class=")(author)(">)(in )/$1editors$3/g;
			s/(<refPart class="author">)(.+?)( in )(.+?)(<\/refPart>)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="editors">$4$5/g;
			
			
			# Repairs taxonomic names accidentally recognised as a citation:
			s/(\t\t\t\t\t\t<citation class="publication">)([[:upper:]][[:lower:]]+(?:|\.) (?:|[[:lower:]]+ )auct\. non .+)(<\/citation>)/$2/;
			s/(\t\t\t\t\t\t<citation class="publication">)([[:upper:]]+(?:|\.) (?:|[[:lower:]]+ )auct\. non .+)(<\/citation>)/$2/;
			
			# Repairs <refPart class="pubname">AUTEUR, PUBLICATION</refPart>:
			s/(<refPart class=")(pubname)(">.+?)(, )(FWTA|Ann. Mus. Congo, Bot.|Us. Pl. W. Trop. Afr.)(<\/refPart>)/$1author$3$6\n\t\t\t\t\t\t\t$1$2">$5$6/g;
			
			
			
		}
		
		
		# Corrections in the references/citations:
		# abbreviation "n.s.":
		s/(<refPart class=")(pubname)(">n\.(?:| )s\.<\/refPart>)/$1series$3/g;
		
		
		
		# (References to) Illustrations:
		# Removes curved brackets if required:
		s/(^)(\()(P(?:L|l)\. (?:\d+|[IVXCM]+))((?:|\.)\)(?:|\.))/$3/;
		
		# Figure reference + number, parts, page
		s/(^)(P(?:L|l)\. )(\d+|[IVXCM]+)(, )(\d+-\d+|\d+, \d+)(, p.+)($)/$1\t\t\t<figureRef ref="ID_">$2<num>$3<\/num><figurePart>$5<\/figurePart><\/figureRef>/;
		
		# Figure reference + number, parts, page
		s/(^)(P(?:L|l)\. )(\d+|[IVXCM]+)(, )(\d+-\d+|\d+, \d+)(\.)($)/$1\t\t\t<figureRef ref="ID_">$2<num>$3<\/num><figurePart>$5<\/figurePart><\/figureRef>/;
		
		# Figure reference + number, page
		s/(^)(P(?:L|l)\. )(\d+|[IVXCM]+)(, p.+)($)/$1\t\t\t<figureRef ref="ID_">$2<num>$3<\/num><\/figureRef>/;
		
		# Figure reference + number (normal or Roman)
		s/(^)(P(?:L|l)\. )(\d+|[IVXCM]+)(\.|)($)/$1\t\t\t<figureRef ref="ID_">$2<num>$3<\/num><\/figureRef>/;
		
		
		
		# Nomenclature:
		
		# FIX CODE BELOW TO USE nom class="basionym" INSTEAD:
		# Basionyms:
		s/(^)(\t\t\t\t\t\t)(<citation class="publication">)(Bas\.: )([[:upper:]][[:lower:]]+)( )([[:lower:]]+)( )(.+?)(<\/citation>)/$2<basionym>$4\n\t\t\t\t\t\t\t<name class="genus">$5<\/name>\n\t\t\t\t\t\t\t<name class="species">$7<\/name>\n\t\t\t\t\t\t\t<name class="genus">$9<\/name>\n\t\t\t\t\t\t<\/basionym>/g;
		
		
		
		# Division:
		# Division (exception):
		s/(^)(PTÉRIDOPHYTES)($)/\t\t\t\t\t\t<name class="division">$2<\/name>/;
		
		
		# Ordre:
		# Ordre (exception):
		s/(^)(ORDRE)( )(CARYOPHYLLALES|FILICALES|LYCOPODIALES|MARATTIALES|OPHIOGLOSSALES|PSILOTALES|SCITAMINALES|SÉLAGINELLALES)($)/\t\t\t\t\t\t<name class="rank">$2<\/name>\n\t\t\t\t\t\t<name class="order">$4<\/name>/;
		s/(^)(SCITAMINALES)($)/\t\t\t\t\t\t<name class="order">$2<\/name>/;
		
		
		
		# Sous-famille:
		# Famille subfamilyrank Sous-famille Author:
		s/(^)([[:upper:]][a-z-]+ace(?:ae|æ))( )((?:sous |sub)fam\.)( )([[:upper:]][a-z-]+e(?:ae|æ))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subfamily">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		# SOUS-FAMILLE DES XXX:
		s/(^)(SOUS-FAMILLE DES)( )([[:upper:]]+)($)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subfamily">$4<\/name>/;
		
		
		
		# Famille:
		# Famille (Paraut) Author (annee):
		s/(^)([[:upper:]][A-Za-z-]+(?:ACEAE|aceae|BELLIFERAE))( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( \()(\d\d\d\d)(\))/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="paraut">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="year">$8<\/name>/;
		# Famille Author (annee):
		s/(^)([[:upper:]][A-Za-z-]+(?:ACEAE|aceae|BELLIFERAE))( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( \()(\d\d\d\d)(\))/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="year">$6<\/name>/;
		# Famille Author:
		s/(^)([[:upper:]][a-z-]+aceae)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>/;
		# Famille (status) Author:
		s/(^)([[:upper:]][a-z-]+aceae)( )(\(p\.p\.\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="status">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>/;
		# Famille (sans rien derriere):
		s/(^)([[:upper:]][a-z-]+(?:aceae|ineae))($)/\t\t\t\t\t\t<name class="family">$2<\/name>/;
		# FAMILLE (sans rien derriere):
		s/(^)([[:upper:]]+(?:ACEÆ|ACEAE))($)/\t\t\t\t\t\t<name class="family">$2<\/name>/;
		
		# Famille (exception):
		s/(^)(AIZOAC|AMARANTHAC|BALANITAC|CANNAC|CARYOPHYLLAC|CHÉNOPODIAC|GRAMIN|LAURAC|MARANTAC|MONIMIAC|MUSAC|MYRISTICAC|MYRTAC|NYCTAGINAC|PHYTOLACCAC|POLYGONAC|PORTULACAC|RUTAC|SAPINDAC|STRÉLITZIAC|THYMÉLÉAC|ZINGIBÉRAC|ZYGOPHYLLAC)(ÉES)($)/\t\t\t\t\t\t<name class="family">$2EAE<\/name>/;
		
		
		
		# Tribe|tribus:
		# Family triberank Tribe Infraut:
		s/(^)([[:upper:]][a-z-]+aceae)( )(Tribe|tribe|Tribus|tribus)( )([[:upper:]][a-z-]+eae)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="tribe">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		# Tribe Infraut:
		s/(^)([[:upper:]][a-z-]+ideae)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="tribe">$2<\/name>\n\t\t\t\t\t\t<name class="infraut">$4<\/name>/;
		# Tribus (exception):
		s/(^)(ANDROPOGONÉES|ARUNDINÊES|ARUNDINELLÉES|BAMBUSÉES|CHLORIDÉES|ERAGROSTÉES|FESTUCÉES|OLYRÉES|ORYZÉES|PANICÉES|PHARÊES|SPOROBOLÊES|STIPÉES|THYSANOLAENÉES|Kaelreuterieae|Cossigneae)($)/\t\t\t\t\t\t<name class="tribe">$2<\/name>/;
		s/(^)(DORATOXYLEAE|DODONAEEAE|CUPANIEAE|NEPHELIEAE|SCHLEICHEREAE|LEPISANTHEAE|APHANIEAE|SAPINDEAE|THOUINIEAE|PAULLINIEAE|MEMECYLEAE|DISSOCHAETEAE|SONERILEAE|OSBECKIEAE|HARPULLIEAE)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="tribe">$2<\/name>\n\t\t\t\t\t\t<name class="infraut">$4<\/name>/;
		# Tribu des Xxx:
		s/(^)(Tribu des)( )([[:upper:]][[:lower:]]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="tribe">$4<\/name>/;
		
		
		
		# Subfamily|subfam.:
		# Family subfamilyrank Subfamily Infraut:
		s/(^)([[:upper:]][a-z-]+aceae)( )(Subfamily|subfamily|Subfam\.|subfam\.)( )([[:upper:]][a-z-]+oideae)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subfamily">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		
		
		
		# Section|Sect.|Â§:
		
		# Subgenusrank Genus Author sectionrank Section Infraut:
		s/(^)(subgen\.)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(Section|section|Sect.|sect.|Â§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subgenus">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="section">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>/;
		
		# Genus Author sectionrank Section Infraut status:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(Section|section|Sect.|sect.|Â§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(quoad.+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="section">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>\n\t\t\t\t\t\t<name class="status">$12<\/name>/;
		
		# Genus Author sectionrank Section (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(Section|section|Sect.|sect.|Â§|Sectio|sectio)( )([[:upper:]][a-z-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="section">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>/;
		
		# Genus sectionrank Sectionnumber Section Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(Section|section|Sect.|sect.|Â§|§|Sectio|sectio)( )(\d+\.)( )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="num">$6<\/name>\n\t\t\t\t\t\t<name class="section">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		
		# Genus sectionrank Section Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(Section|section|Sect.|sect.|Â§|Sectio|sectio)( )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="section">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		# Genus sectionrank Section:
		s/(^)([[:upper:]][a-z-]+)( )(Section|section|Sect.|sect.|Â§|Sectio|sectio)( )([[:upper:]][a-z-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="section">$6<\/name>/;
		
		# Sectionrank Sectionnumber Section Infraut:
		s/(^)(Section|section|Sect.|sect.|Â§|Sectio|sectio)( )([[:upper:]]\.)( )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="num">$4<\/name>\n\t\t\t\t\t\t<name class="section">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		# Sectionrank Sectionnumber Section (Infrparaut) Infraut:
		s/(^)(Section|section|Sect.|sect.|Â§|Sectio|sectio)( )([[:upper:]]\.)( )([[:upper:]][a-z-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="num">$4<\/name>\n\t\t\t\t\t\t<name class="section">$6<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		
		
		# Sectionrank Section (Infrparaut) Infraut:
		s/(^)(Section|section|Sect.|sect.|Â§|Sectio|sectio)( )([[:upper:]][a-z-]+|[[:upper:]]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="section">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		# Sectionrank Section Infraut:
		s/(^)(Section|section|Sect.|sect.|Â§|Sectio|sectio)( )([[:upper:]][a-z-]+|[[:upper:]]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="section">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>/;
		
		# Sectionrank Section:
		s/(^)(Section|section|Sect.|sect.|Â§|Sectio|sectio)( )([[:upper:]][a-z-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="section">$4<\/name>/;
		
		
		
		# Sous-sections:
		# Subsectionrank Subsection Infraut:
		s/(^)(Sous-section)( )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subsection">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>/;
		
		
		
		
		# subg.
		# Genus Author subgenusrank Subgenus Infraut (year):
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(Subgenus|subgenus|Subg\.|subg\.|subgen\.|sous-genre)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( \()(\d\d\d\d)(\)\.)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subgenus">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>\n\t\t\t\t\t\t<name class="year">$12<\/name>/;
		# Genus Author subgenusrank Subgenus Infraut:
		s/(^)([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(Subgenus|subgenus|Subg\.|subg\.|subgen\.|sous-genre)( )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subgenus">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		# Genus Author subgenusrank Subgenus (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(Subgenus|subgenus|Subg\.|subg\.|subgen\.|sous-genre)( )([[:upper:]][a-z-]+|[[:upper:]]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subgenus">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		# Genus Author subgenusrank Subgenus:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(Subgenus|subgenus|Subg\.|subg\.|subgen\.|sous-genre)( )([[:upper:]][a-z-]+|[[:upper:]]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subgenus">$8<\/name>/;
		
		# Genus subgenusrank Subgenus Infraut (year):
		s/(^)([[:upper:]][a-z-]+)( )(Subgenus|subgenus|Subg\.|subg\.|subgen\.|sous-genre)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( \()(\d\d\d\d)(\)\.)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subgenus">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>\n\t\t\t\t\t\t<name class="year">$10<\/name>/;
		# Genus subgenusrank Subgenus Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(Subgenus|subgenus|Subg\.|subg\.|subgen\.|sous-genre)( )([[:upper:]][a-z-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subgenus">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		# Genus subgenusrank Subgenus (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+)( )(Subgenus|subgenus|Subg\.|subg\.|subgen\.|sous-genre)( )([[:upper:]][a-z-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subgenus">$6<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$9<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>/;
		
		# subgenusrank Subgenus Infraut (year):
		s/(^)(Subgenus|subgenus|Subg\.|subg\.|subgen\.|sous-genre)( )([[:upper:]][a-z-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( \()(\d\d\d\d)(\)\.)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subgenus">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>\n\t\t\t\t\t\t<name class="year">$8<\/name>/;
		
		# subgenusrank Subgenus (Infrparaut) Infraut:
		s/(^)(Subgenus|subgenus|Subg\.|subg\.|subgen\.|sous-genre)( )([[:upper:]][a-z-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subgenus">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		
		
		
		# subsp./var.:
		# Genus species Author subspeciesrank subspecies (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(subspecies|subsp\.|ssp\.|s\.-sp\.)( )([[:lower:]\-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="subspecies">$10<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$12<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		# Genus species Author varietyrank variety (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(variety|var\.|v\.)( )([[:lower:]\-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="variety">$10<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$12<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		# Genus species Author subspeciesrank subspecies Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(subspecies|subsp\.|ssp\.|s\.-sp\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$9<\/name>\n\t\t\t\t\t\t<name class="subspecies">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$13<\/name>/;
		# Genus species Author varietyrank variety Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(variety|var\.|v\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$9<\/name>\n\t\t\t\t\t\t<name class="variety">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$13<\/name>/;
		
		
		# Genus species (Paraut) Author subspeciesrank subspecies Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(subspecies|subsp\.|ssp\.|s\.-sp\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="subspecies">$15<\/name>\n\t\t\t\t\t\t<name class="infraut">$17<\/name>/;
		# Genus species (Paraut) Author varietyrank variety Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(variety|var\.|v\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="variety">$15<\/name>\n\t\t\t\t\t\t<name class="infraut">$17<\/name>/;
		# Genus species (Paraut) Author subspeciesrank subspecies (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(subspecies|subsp\.|ssp\.|s\.-sp\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="subspecies">$15<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$18<\/name>\n\t\t\t\t\t\t<name class="infraut">$21<\/name>/;
		# Genus species (Paraut) Author varietyrank variety (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(variety|var\.|v\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="variety">$15<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$18<\/name>\n\t\t\t\t\t\t<name class="infraut">$21<\/name>/;
		
		
		# Genus species Author subspeciesrank subspecies:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(subspecies|subsp\.|ssp\.|s\.-sp\.)( )((?:|[[:upper:]])[[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$9<\/name>\n\t\t\t\t\t\t<name class="subspecies">$11<\/name>/;
		# Genus species Author varietyrank variety:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(variety|var\.|v\.)( )((?:|[[:upper:]])[[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$9<\/name>\n\t\t\t\t\t\t<name class="variety">$11<\/name>/;
		# Genus species (Paraut) Author subspeciesrank subspecies:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(subspecies|subsp\.|ssp\.|s\.-sp\.)( )((?:|[[:upper:]])[[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="subspecies">$15<\/name>/;
		# Genus species (Paraut) Author varietyrank variety:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(variety|var\.|v\.)( )((?:|[[:upper:]])[[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="infrank">$13<\/name>\n\t\t\t\t\t\t<name class="variety">$15<\/name>/;
		
		
		# Genus species subspeciesrank subspecies Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(subspecies|subsp\.|ssp\.|s\.-sp\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subspecies">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		# Genus species varietyrank variety Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(variety|var\.|v\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		# Genus species subspeciesrank subspecies (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(subspecies|subsp\.|ssp\.|s\.-sp\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="subspecies">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		# Genus species varietyrank variety (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(variety|var\.|v\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$11<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		
		
		# subspeciesrank subspecies (Infrparaut) Infraut:
		s/(^)(subspecies|ssp\.|subsp\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subspecies">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		# varietyrank variety (Infrparaut) Infraut:
		s/(^)(var\.|v\.|Variété)( )((?:|[[:upper:]])[[:lower:]\-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="variety">$4<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		
		
		# subspeciesrank subspecies Infraut:
		s/(^)(subspecies|ssp\.|subsp\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subspecies">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>/;
		# varietyrank variety Infraut:
		s/(^)(var\.|v\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="variety">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>/;
		
		# varietyrank Variety Infraut:
		s/(^)(var\.|v\.)( )([[:upper:]][[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="variety">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>/;
		
		
		# subspeciesrank subspecies:
		s/(^)(subspecies|ssp\.|subsp\.|s\.-sp\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subspecies">$4<\/name>/;
		# varietyrank variety:
		s/(^)(var\.|v\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="variety">$4<\/name>/;
		
		
		# Repairs certaines varietes improprement atomisees:
		s/(<name class=")(author)(">[[:upper:]][[:lower:]]+)( )(var\.|v\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)(<\/name>)/$1species$3$10\n\t\t\t\t\t\t<name class="infrank">$5<\/name>\n\t\t\t\t\t\t<name class="variety">$7<\/name>\n\t\t\t\t\t\t<name class="infraut">$9<\/name>/;
		
		
		# Subvarieties:
		# Genus species varietyrank variety subvarietyrank subvariety Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(variety|var\.|v\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(subv\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>\n\t\t\t\t\t\t<name class="infrank">$10<\/name>\n\t\t\t\t\t\t<name class="subvariety">$12<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		
		
		
		# formes:
		
		# Genus species varietyrank variety formarank forma Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )(variety|var\.|v\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(form\.|forma|f\.|fa\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="variety">$8<\/name>\n\t\t\t\t\t\t<name class="infrank">$10<\/name>\n\t\t\t\t\t\t<name class="form">$12<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		
		
		# Genus species formarank forma Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )(form\.|forma|f\.|fa\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="infrank">$6<\/name>\n\t\t\t\t\t\t<name class="form">$8<\/name>\n\t\t\t\t\t\t<name class="infraut">$10<\/name>/;
		
		# Genus species author formarank forma Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(form\.|forma|f\.|fa\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="form">$10<\/name>\n\t\t\t\t\t\t<name class="infraut">$12<\/name>/;
		# Genus species author formarank forma (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(form\.|forma|f\.|fa\.)( )([[:lower:]\-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="infrank">$8<\/name>\n\t\t\t\t\t\t<name class="form">$10<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$12<\/name>\n\t\t\t\t\t\t<name class="infraut">$14<\/name>/;
		# Genus species (Paraut) author formarank forma (Infrparaut) Infraut:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( )(form\.|forma|f\.|fa\.)( )([[:lower:]\-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$6<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>\n\t\t\t\t\t\t<name class="infrank">$10<\/name>\n\t\t\t\t\t\t<name class="form">$12<\/name>\n\t\t\t\t\t\t<name class="infrparaut">$14<\/name>\n\t\t\t\t\t\t<name class="infraut">$16<\/name>/;
		
		
		# formarank forma Infraut:
		s/(^)(form\.|forma|f\.|fa\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="form">$4<\/name>\n\t\t\t\t\t\t<name class="infraut">$6<\/name>/;
		# formarank forma:
		s/(^)(form\.|forma|f\.|fa\.)( )([[:lower:]\-]+)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="form">$4<\/name>/;
		
		
		
		# Hybrids ( x | Ã— ):
		# Genus Ã— species Author:
		s/(^)([[:upper:]][a-z-]+)( )(Ã—)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="hybrid">$4<\/name>\n\t\t\t\t\t\t<name class="species">$6<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>/;
		# Genus species Ã— Genus species Author:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(Ã—)( )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="hybrid">$6<\/name>\n\t\t\t\t\t\t<name class="genus">$8<\/name>\n\t\t\t\t\t\t<name class="species">$10<\/name>\n\t\t\t\t\t\t<name class="author">$12<\/name>/;
		# Genus species Ã— Genus species (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(Ã—)( )([[:upper:]][a-z-]+)( )([[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="hybrid">$6<\/name>\n\t\t\t\t\t\t<name class="genus">$8<\/name>\n\t\t\t\t\t\t<name class="species">$10<\/name>\n\t\t\t\t\t\t<name class="paraut">$13<\/name>\n\t\t\t\t\t\t<name class="author">$16<\/name>/;
		

		# All others:
		
		# With status:
		
		# status Genus species Author:
		s/(^)(\(\?\)|\?|vel aff\.)( )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:|auct non [[:upper:]]+:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="status">$2<\/name>\n\t\t\t\t\t\t<name class="genus">$4<\/name>\n\t\t\t\t\t\t<name class="species">$6<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>/;
		
		
		# Genus status species Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:\(|)\?(?:\)|))( )((?:|[[:upper:]])[[:lower:]\-]+)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="status">$4<\/name>\n\t\t\t\t\t\t<name class="species">$6<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>/;
		
		# Genus status species (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:\(|)\?(?:\)|))( )((?:|[[:upper:]])[[:lower:]\-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="status">$4<\/name>\n\t\t\t\t\t\t<name class="species">$6<\/name>\n\t\t\t\t\t\t<name class="paraut">$8<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>/;
		
		
		
		# Genus species (Paraut) Author, status:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(, )(comb\. nov\.)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<name class="status">$12<\/name>/;
		
		
		# Without status:
		# Genus species Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?!sensu)[[:lower:]\-]+)( )(([[:upper:]]|auct\.:(?:| )|auct:(?:| )|auct\. non [[:upper:]\p{Ll}\- &'\.]+: |auct\. non \([[:upper:]\p{Ll}\- &'\.]+\) [[:upper:]\p{Ll}\- &'\.]+: )[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>/;
		# Genus species (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>/;
		# Genus species auct. non (Paraut) Author, sans double point et non suivi du nom d'auteur correct:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )(auct\. non \([[:upper:]\p{Ll}\- &'\.]+\) [[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>/;
		
		
		# Genus Species Author:
		s/(^)([[:upper:]][a-zœ-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:upper:]][[:lower:]\-]+)( )(([[:upper:]]|auct\.:(?:| )|auct:(?:| )|auct\. non [[:upper:]\p{Ll}\- &'\.]+: )[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>/;
		# Genus Species (Paraut) Author:
		s/(^)([[:upper:]][a-zœ-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:upper:]][[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t<name class="author">$10<\/name>/;
		
		
		
		# Genus species:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?!sensu)[[:lower:]\-]+)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="species">$4<\/name>/;
		
		
		# Genus:
		# Genus Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+)( )(([[:upper:]]|auct\.:(?:| )|auct:(?:| )|auct\. non [[:upper:]\p{Ll}\- &'\.]+: |auct\. non \([[:upper:]\p{Ll}\- &'\.]+\) [[:upper:]\p{Ll}\- &'\.]+: )[[:upper:]\p{Ll}\- &'\.]+|L\.)($)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>/;
		
		# Genus (Paraut) Author:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)($)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="paraut">$5<\/name>\n\t\t\t\t\t\t<name class="author">$8<\/name>/;
		
		# Genus Author status:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+)( )((?:[[:upper:]]|auct\.:(?:| )|auct:(?:| )|auct\. non [[:upper:]\p{Ll}\- &'\.]+: |auct\. non \([[:upper:]\p{Ll}\- &'\.]+\) [[:upper:]\p{Ll}\- &'\.]+: )[[:upper:]\p{Ll}\- &'\.]+|L\.)(, )(nom\. cons\.)($)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="status">$6<\/name>/;
		# Genus status:
		s/(^)([[:upper:]][a-z-]+|[[:upper:]]+)( )(sensu (?:[[:upper:]][[:lower:]]+|[[:upper:]]+\.))($)/\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t<name class="status">$4<\/name>/;
		
		
		
		# Pour indiques les genres indique seulement avec la (les) premiere lettre:
		s/(<name class=")(genus)(">[[:upper:]]\.<\/name>)/$1genus abbreviation$3/;
		
		
		# Autres:
		# Status:
		s/( )(<\/name>)(\(\?\))(\.)/$2\n\t\t\t\t\t\t<name class="status">$3<\/name>/;
		s/( )(<\/name>)(\(non .+)/$2\n\t\t\t\t\t\t<name class="status">$3<\/name>/;
		s/( )(<\/name>)(\(p\.p\.(?:| \?)\))/$2\n\t\t\t\t\t\t<name class="status">$3<\/name>/;
		s/(<\/name>)((?:|,) )((?:sensu|p\.p\.|comb\. nov\.|stat\. nov\.|nom\. altern\.|nom\. cons\.|nom\. nud\.|nom\. in sched\.|nom\. in obs\.|\(nomen in sched\.\)\.|sp\. nov\.).*)/$1\n\t\t\t\t\t\t<name class="status">$3<\/name>/;
		s/( )(nom\. cons\.|(?:comb|sp|var)\. nov\.)(<\/name>)/$3\n\t\t\t\t\t\t<name class="status">$2$3/;
		
		
		
		# Noms vernaculaires:
		s/(^)([[:upper:]]\w+)($)/\t\t\t\t\t\t<name class="vernacular">$2<\/name>/;
		
		
		# Deplace un point suivant </name>:
		s/(<\/name>)(\.)/$2$1/;
		
		# Annees suivant un nom taxonomique (sans reference):
		s/(<\/name>)(\()(\d\d\d\d)(\)(?:\.|))($)/$1\n\t\t\t\t\t\t<name class="year">$3<\/name>/;
		
		# Statuts non-atomise:
		s/(<\/name>)(, )(var\. nov\.)/$1\n\t\t\t\t\t\t<name class="status">$3<\/name>/;
		
		# editeurs:
		s/(<name class="author">)(.+?)( in )(.+?)(<\/name>)/$1$2$5\n\t\t\t\t\t\t\t<refPart class="editors">$4<\/refPart>/g;
		
		 
		
	}
	
	# Atomisation des Types:
	# Atomisation base sur le format des types.
	# NameTypes:
	elsif (/\t+<nameType/) {
	
		if (/Espèce type|ESPÈCE·TYPE|ESPÈCE-TYPE|ESPÉCE-TYPE|ESPÉCE TYPE|ESPÈCES-SYNTYPES|Type du genre|Type|Lectotype|GENRE-TYPE/) {
			
			# Lectotypes:
			# Espèce-type (lectotype):
			s/(<nameType)(>(?:Espèce-type \(lectotype\)|Lectotype):)/$1 typeStatus="lectotype"$2/;
			
			
			# TODO: FIX BELOW to use nom class="basionym" instead:
			# Accepted names:
			
			# Tags de base:
			# Entre parentheses:
			s/( \(| \[)(= .+)((?:\)|\])(?:|\.))/\n\t\t\t\t\t\t<acceptedName>$2<\/acceptedName>/;
			# Suivant virgule:
			s/(, )(= .+)/\n\t\t\t\t\t\t<acceptedName>$2<\/acceptedName>/;
			
			# Atomisation:
			
			# Genus species (Paraut) Author:
			s/(<acceptedName>)(= )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(<\/acceptedName>)/$1\n\t\t\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t\t\t<name class="genus">$3<\/name>\n\t\t\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t\t\t<name class="author">$9<\/name>\n\t\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t$10/;
			
			# Genus species Author:
			s/(<acceptedName>)(= )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:lower:]\-]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)(<\/acceptedName>)/$1\n\t\t\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t\t\t<name class="genus">$3<\/name>\n\t\t\t\t\t\t\t\t<name class="species">$5<\/name>\n\t\t\t\t\t\t\t\t<name class="author">$7<\/name>\n\t\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t$8/;
			
			# Genus Author:
			s/(<acceptedName>)(= )([[:upper:]][a-z-]+|[[:upper:]]+)( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)(<\/acceptedName>)/$1\n\t\t\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t\t\t<name class="genus">$3<\/name>\n\t\t\t\t\t\t\t\t<name class="author">$5<\/name>\n\t\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t$6/;
			

			
			# NameTypes Atomisation:
			
			# Format: Type species: Genus species (Paraut) Author, typeNotes (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESP(?:È|E|É)CES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(, )(.+?)( \()(.+)( )(\d+|s\.n\.)(\))(\.$|$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$12 (<gathering><collector>$14<\/collector><fieldNum>$16<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>/;
			
			# Format: Type species: Genus species Author, typeNotes (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESP(?:È|E|É)CES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(, )(.+?)( \()(.+)( )(\d+|s\.n\.)(\))(\.$|$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$8 (<gathering><collector>$10<\/collector><fieldNum>$12<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>/;
			
			# Format: Type species: Genus species, typeNotes (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESP(?:È|E|É)CES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)(, )(.+?)( \()(.+)( )(\d+|s\.n\.)(\))(\.$|$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$6 (<gathering><collector>$8<\/collector><fieldNum>$10<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>/;
			
			
			# Format: Type species: Genus species (Paraut) Author (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESP(?:È|E|É)CES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)( \()(.+)( )(\d+|s\.n\.)(\))($|\.$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>(<gathering><collector>$12<\/collector><fieldNum>$14<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>/;
			
			# Format: Type species: Genus species Author (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESP(?:È|E|É)CES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)( \()(.+)( )(\d+|s\.n\.)(\))(\.$|$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>(<gathering><collector>$8<\/collector><fieldNum>$10<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>/;
			
			# Format: Type species: Genus species (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESPÈ(?:È|E|É)ES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( \()(.+)( )(\d+|s\.n\.)(\))($|\.$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>(<gathering><collector>$6<\/collector><fieldNum>$8<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>/;
			
			
			# Format: Type species: Genus species Author, typeNotes
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESP(?:È|E|É)CES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(, )(.+?)(\.$|$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$8<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>/;
			
			# Format: Type species: Genus species, typeNotes
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESP(?:È|E|É)CES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)(, )(.+?)(\.$|$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$6<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>/;
			
			# Format: Type species: Genus species (Paraut) Author, typeNotes
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESP(?:È|E|É)CES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(, )(.+?)(\.$|$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$12<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>/;
			
			
			# Format: Type species: Genus species Author
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESP(?:È|E|É)CES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)($|\.$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			
			# Format: Type species: Genus species
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESP(?:È|E|É)CES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)($|\.$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			
			# Format: Type species: Genus species (Paraut) Author
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |Lectotype: |TYPE: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: |ESP(?:È|E|É)CE·TYPE: |ESP(?:È|E|É)CES-SYNTYPES: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)($|\.$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			
			
			# Format: Type genus: Genus Author, typeNotes
			s/(Type genus: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(, )(.+?)($|\.$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$6<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>/;
			
			# Format: Type genus: Genus Author
			s/(Type genus: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)($|\.$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			
			
			# If followed by accepted name:
			
			# Format: Type species: Genus species (Paraut) Author, typeNotes (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(, )(.+?)( \()(.+)( )(\d+|s\.n\.)(\))(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$12 (<gathering><collector>$14<\/collector><fieldNum>$16<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>$18/;
			
			# Format: Type species: Genus species Author, typeNotes (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(, )(.+?)( \()(.+)( )(\d+|s\.n\.)(\))(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$8 (<gathering><collector>$10<\/collector><fieldNum>$12<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>$14/;
			
			# Format: Type species: Genus species, typeNotes (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)(, )(.+?)( \()(.+)( )(\d+|s\.n\.)(\))(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$6 (<gathering><collector>$8<\/collector><fieldNum>$10<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>$12/;
			
			
			# Format: Type species: Genus species (Paraut) Author (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)( \()(.+)( )(\d+|s\.n\.)(\))(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>(<gathering><collector>$12<\/collector><fieldNum>$14<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>$16/;
			
			# Format: Type species: Genus species Author (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)( \()(.+)( )(\d+|s\.n\.)(\))(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>(<gathering><collector>$8<\/collector><fieldNum>$10<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>$12/;
			
			# Format: Type species: Genus species (Collector Fieldnum)
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du (?:|sous-)genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( \()(.+)( )(\d+|s\.n\.)(\))(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>(<gathering><collector>$6<\/collector><fieldNum>$8<\/fieldNum><\/gathering>)<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>$10/;
			
			
			# Format: Type species: Genus species Author, typeNotes
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(, )(.+?)(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$8<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>$9/;
			
			# Format: Type species: Genus species, typeNotes
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)(, )(.+?)(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$6<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>$7/;
			
			# Format: Type species: Genus species (Paraut) Author, typeNotes
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(, )(.+?)(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$12<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>$13/;
			
			
			# Format: Type species: Genus species Author
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>$7/;
			
			# Format: Type species: Genus species
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>$5/;
			
			# Format: Type species: Genus species (Paraut) Author
			s/(Esp(?:e|è)ce(?: |-)type(?:| \(lectotype\)): |(?:Esp(?:e|è)ce t|T)ype du genre: |Type: |TYPE: |Lectotype: |LECTOTYPE: |ESP(?:È|E|É)CE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )((?:|[[:upper:]])[[:lower:]\-]+)( )(\()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\))( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\n\t\t\t\t\t\t<acceptedName>)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="species">$4<\/name>\n\t\t\t\t\t\t\t<name class="paraut">$7<\/name>\n\t\t\t\t\t\t\t<name class="author">$10<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>$11/;
			
		}
		elsif (/Type genus/) {
		
		}
		else {
		}
		# Ajoute les tags au nameTypes divergents:
		s/(<nameType>(?!\n\t\t\t\t\t\t<nom class="nametype"(?: typeStatus="lectotype"|)>))(.+)/$1\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus"><\/name>\n\t\t\t\t\t\t\t<name class="species"><\/name>\n\t\t\t\t\t\t\t<name class="author"><\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>$2/;
		
		# Change l'attribut "class" des genus abbrevies:
		s/(<name class=")(genus)(">[[:upper:]]\.<\/name>)/$1genus abbreviation$3/g;
	
	
	}
	
	# SpecimenTypes:
	elsif (/\t+<specimenType/) {
		
		if (/Type:|Neotype:|Type locality:|Type de l'espèce:|Type de la variété|Typ\.:|LECTOTYPE|NÉOTYPE|NEOTYPE|SYNTYPE|TYPE/) {
		
			
			
			# Format: Type: Locality, Collector, Fieldnum (CollectionAndType).:
			s/(Type: |Typ\.: |Neotype: |HOLOTYPE(?:|:|\*:|S\*:) |LECTOTYPE(?:|:|\*:|S\*:) |N(?:É|E)OTYPE(?:|:|\*:|S\*:) |SYNTYPES(?:|:) |TYPE(?:|:|S:|\*:|S\*:) )([[:upper:]][[:upper:]\p{Ll}\- &'\.,]+)(, )([[:upper:][:lower:], \.&-]+?)((?:|,|\.) )((?:|n° )(?:\d+|s\.n\.|sans numéro|\d+[[:upper:]]|[[:upper:]]\d+))( )(\([A-Za-z !-;]+\))(\.)($)/<gathering>$1<locality class="locality">$2<\/locality><collector>$4<\/collector><fieldNum>$6<\/fieldNum><collectionAndType>$8<\/collectionAndType><\/gathering>$9<\/specimenType>/;
			
			# Format: Type: Locality, Collector (CollectionAndType).:
			s/(Type: |Typ\.: |Neotype: |HOLOTYPE(?:|:|\*:|S\*:) |LECTOTYPE(?:|:|\*:|S\*:) |N(?:É|E)OTYPE(?:|:|\*:|S\*:) |SYNTYPES(?:|:) |TYPE(?:|:|S:|\*:|S\*:) )([[:upper:]][[:upper:]\p{Ll}\- &'\.,]+)(, )([[:upper:][:lower:], \.&-]+?)( )(\([A-Za-z !-;]+\))(\.)($)/<gathering>$1<locality class="locality">$2<\/locality><collector>$4<\/collector><collectionAndType>$6<\/collectionAndType><\/gathering>$7<\/specimenType>/;
			
			# Format: Collector Fieldnum.:
			s/(Type: |Typ\.: |Neotype: |HOLOTYPE(?:|:|\*:|S\*:) |LECTOTYPE(?:|:|\*:|S\*:) |N(?:É|E)OTYPE(?:|:|\*:|S\*:) |SYNTYPES(?:|:) |TYPE(?:|:|S:|\*:|S\*:) )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+?)((?:|,) )((?:|n° )(?:\d+|s\.n\.|sans numéro|\d+[[:upper:]]|[[:upper:]]\d+))(\.)($)/<gathering>$1<collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5<\/specimenType>/;
			
			# Format: Type locality: Locality; type not designated:
			s/(<specimenType)(>Type locality: )([[:upper:][:lower:], ]+)(; )(type not designated)(\.)($)/$1 unknown="true"$2<gathering><locality class="">$3<\/locality><collectionAndType>$5<\/collectionAndType><\/gathering>$6<\/specimenType>/;
			
			# Format: type not designated:
			s/(<specimenType)(>Type: |Typ\.: |Neotype: |HOLOTYPE(?:|:|\*:|S\*:) |LECTOTYPE(?:|:|\*:|S\*:) |N(?:É|E)OTYPE(?:|:|\*:|S\*:) |SYNTYPES(?:|:) |TYPE(?:|:|S:|\*:|S\*:) )(not designated)((?:\.|))($)/$1 unknown="true"$2<gathering><collectionAndType>$3<\/collectionAndType><\/gathering>$4<\/specimenType>/;
			
			
		}
				
		# Holotypes:
		elsif (/(Holotype)/) {
			# Format: Holotype: Collector FieldNum, Locality (CollectionAndType).:
			s/(Holotype(?:|.+?): )(.+)((?:|,) )((?:|n° )(?:\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+))(, )(.+)( )(\(.+\))(\.)($)/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><locality class="">$6<\/locality><collectionAndType>$8<\/collectionAndType><\/gathering>$9<\/specimenType>/;
			
			# Format: Holotype: Collector FieldNum, (CollectionAndType), Locality.:
			s/(Holotype(?:|.+?): )(.+)((?:|,) )((?:|n° )(?:\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+))(, )(\(.+\))(, )(.+)(\.)($)/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><collectionAndType>$6<\/collectionAndType><locality class="">$8<\/locality><\/gathering>$9<\/specimenType>/;
			
			# Format: Holotype: Collector FieldNum (CollectionAndType).:
			s/(Holotype(?:|.+?): )(.+)((?:|,) )((?:|n° )(?:\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+))( )(\(.+\))(\.)($)/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><collectionAndType>$6<\/collectionAndType><\/gathering>$7<\/specimenType>/;
			
			# Format: Holotype: Collector FieldNum, Locality.:
			s/(Holotype(?:|.+?): )(.+)((?:|,) )((?:|n° )(?:\d+|s\.n\.|\d+[[:upper:]]|[[:upper:]]\d+))(, )(.+)(\.)($)/$1<gathering><collector>$2<\/collector><fieldNum>$4<\/fieldNum><locality class="locality">$6<\/locality><\/gathering>$7<\/specimenType>/;
			
			
		}
		else {
		}
		
		# Ajoute les tags au specimenTypes divergents:
		# Types multiples:
		s/(<specimenType>(?:T|Synt)ypes(?:|:) )(.+)/$1<gathering><locality class="locality"><\/locality><collector><\/collector><fieldNum><\/fieldNum><collectionAndType><\/collectionAndType><\/gathering><gathering><locality class="locality"><\/locality><collector><\/collector><fieldNum><\/fieldNum><collectionAndType><\/collectionAndType><\/gathering>$2<\/specimenType>/;
		# Indication de syntypes:
		s/(<specimenType)(>Syntypes )/$1 typeStatus="syntype"$2/;
		
		# Un Type:
		s/(<specimenType(?:| typeStatus="(?:holo|lecto|syn|neo)type"| lang="la"| typeStatus="holotype" lang="la")>(?!<gathering>))(.+)/$1<gathering><locality class="locality"><\/locality><collector><\/collector><fieldNum><\/fieldNum><collectionAndType><\/collectionAndType><\/gathering>$2<\/specimenType>/;
		
		
		# Localitees dans les types:
		
		# Regions + Pays:
		s/(<locality class=")(">)(Andes|(?:A|a)rchipel (?:antillais|de la Sonde|indo-malais|Malais)|baie de Biafra|Bengale|Canaries|Deng Deng|Fernando(?:-| )Po|Fernan-Vaz|Formose|Fouta-Djalon|Haut-Zambèse|(?:B|b)as-Katanga|(?:haut |)Katanga|(?:haut |)Mbomou|Lac Nyassa|les îles du golfe de Guinée|(?:G|g)olfe de Guinée|(?:I|î)les (?:du Cap(?:-| )Vert|Molu(?:s|)ques|Philippines)|(?:I|î)le du Prince|Indes orientales|Indochine|Java|Loango|Luzon|Mascareignes|May(?:o|u)mbe congolais|May(?:o|u)mbe|Ndendé|Ngounyé|Niari|Nouvelle-Calédonie|Nyanga|Oubangui-Chari|fleuve Oubangui|Oubangui|péninsule indienne|(?:P|p)lateaux (?:Batékés|des Cataractes)|Polynésie|Pyrénées|région (?:baya de Kundé|d'Eséka|de Booué|de Boukoko|de Brazzaville|de Fernan Vaz à l'embouchure de l'Ogoué|de forêt pélohygrophile d'Abong-Mbang et de Lomié|de Franceville|de Lastoursville|de Lomié|de Mamfe|de Sibiti|de Tchibanga|de Yaoundé|des Grands Lacs|du Cap|du lac Moero)|région Indo-malaise|Tchibanga|Rhodésie du Nord|Sibérie|Stanley-Pool|Tanganyika|Victoria|(?:île de |)Zanzibar|Allemagne|(?:Nord |N\. de l'|Sud de l')Angola|Angola du Nord|Angola|Arabie|Birmanie|Bourbon|Brésil|Cambodge|(?:sud-ouest du |Sud-Est |(?:E|e)st du )Cameroun|Cameroun (?:(?:ex-|)britannique|occidental|oriental)|Cameroun|Casamance|République Centrafrique|Centrafrique|Ceylan|Chili|Chine (?:du Sud|méridionale)|Chine|Comores|(?:l'embouchure du|Bas|moyen bassin du|Moyen|République Démocratique du|Sud Est)(?:-| )Congo|(?:|Nord Est du )Congo(?:(?:-| |)(?:Brazzaville|Kinshasa)| oriental| équatorial| occidental)|(?:l'est du |)Congo ex(?:-| )(?:B|b)elge|Congo (?:(?:B|b)elge|Fr\.|français|Portugais)|République Congolaise|(?:nord du |les deux |République du |)Congo|C(?:o|ô)te(?:-| )d(?:'|’)Ivoire|Dahomey|Egypte|Espagne|Ethiopie|Fidji|(?:NE|sud) du Gabon|(?:Nord|SE|Sud) Gabon|Gabon|Gambie|Ghana|Nouvelle-Guinée|Guinée (?:(?:E|é)quatoriale|espagnole|ex(?:-| )française)|nord de la Guinée|Guinée|(?:Iles |)Hawa(?:ï|ii)|Indes|Inde|Indonésie|Japon|Kasai|Kenya|Laos|Lib(?:é|e)ria|Madagascar|Maghreb|Malacca|Indo-Malaisie|Malaisie|Mascarègnes|Maurice|Mauritanie|Mayombé|Mélanésie|Mexico|Micronésie|(?:M|m)onts de Cristal|Mozambique|Natal|(?:Est de la|Sud|S\.|sud-est du|Sud Ouest de la) Nig(?:e|é)ri(?:e|a)|Nig(?:e|é)ria (?:du (?:S|s)ud|méridional(?:|e)|oriental(?:|e))|Nig(?:e|é)ria|Niger|la Nouvelle-Zélande|Nouvelle-Zélande|Ouganda|Papouasie|Pays Batéké|Péninsule Malaise|Philippines|plateau de l'Adamaoua|Principe|République (?:C|c)entrafricaine|RCA|R\.C\.A\.|Rhodésie|S(?:a|â|ã)o Tomé|(?:sud du|Sud) Sénégal|Sénégal|Seychelles|Siam|Sierra(?:-| )L(?:e|é)one|(?:République du |)S(?:|o)udan|Sri Lanka|Taïwan|Tanzanie|Tchad|Thaïlande|Togo|Transva(?:|a)l|Uganda|Cap Vert|Cap|Viêtnam|Yémen|Zaïre|Zambie)/$1region$2$3/g;
		
		
		
		# Separe les Pays des regions:
		s/(<locality class=")(region)(">)(Allemagne|Angola|Arabie|Birmanie|Bourbon|Brésil|Cambodge|Cameroun|République Centrafrique|Centrafrique|Ceylan|Chili|Chine|Comores|(?:les deux |République du |République Démocratique du|)Congo(?: ex(?:-| )belge|(?:-| |)Kinshasa|)|Côte(?:-| )d(?:'|’)Ivoire|Dahomey|Egypte|Espagne|Ethiopie|Fidji|Gabon|Gambie|Ghana|Guinée(?: (?:E|é)quatoriale| espagnole| ex(?:-| )française|)|îles Philippines|Indes|Inde|Indonésie|Japon|Kenya|Laos|Lib(?:é|e)ria|Madagascar|Malacca|Malaisie|Maurice|Mauritanie|Mexico|Micronésie|Mozambique|Niger|Nig(?:e|é)ri(?:e|a)|la Nouvelle-Zélande|Ouganda|Philippines|République (?:C|c)entrafricaine|RCA|R\.C\.A\.|Rhodésie|Sao Tomé|Sénégal|Seychelles|Siam|Sierra(?:-| )L(?:e|é)one|(?:République du |)Soudan|Sri Lanka|Tanzanie|Tchad|Thaïlande|Togo|Transvaal|Uganda|Viêtnam|Yémen|Zaïre|Zambie)/$1country$3$4/g;
		
		
		# Dates dans les types:
		s/(\d|\d\d)(\.)(\d|\d\d)(\.)(\d\d\d\d)/<dates><day>---$1<\/day><month>--$3<\/month><year>$5<\/year><\/dates>/g;
		
		
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
		
		
		# Sous-collections sans dates:
		s/(\()((?:(?:|j\. |v\. |fin (?:|de )|bout\. )f(?:r|l)\.(?:| ♂| ♀| ⚥| p\.p\.| juv\.| courts| longs| immat\.)|bois|(?:|j\. )bout(?:|ons|\.)|fir\.|fr\. (?:non|presque) mûrs|galles|path\.|plant(?:\.|ule)|fig\.|fil\.|fll\.|gall\.|galles|gr(?:\.|aine(?:|s))|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.|♂|♀|fl\. avec fr\.)(?:, | et |, et | ou | )(?:(?:|j\. |v\. |fin (?:|de )|bout\. )f(?:r|l)\.(?:| ♂| ♀| p\.p\.| juv\.| courts| longs|, gr\.(?:|, bois))|bois|bout(?:|ons|\.)|fir\.|fr\. non mûrs|gall\.|galles|path\.|st(?:é|e)r\.|♂|♀|gr\.))(\))/$1<subCollection>$2<\/subCollection>$3/g;
		
		s/(\()((?:|j\. |v\. |fin (?:|de )|bout\. )f(?:r|l)\.(?:| ♂| ♀| ⚥| p\.p\.| juv\.| courts| longs| immat\.)|bois|(?:|j\. )bout(?:|ons|\.)|fir\.|fr\. (?:non|presque) mûrs|gall\.|galles|gr(?:\.|aine(?:|s))|path\.|plant(?:\.|ule)|fig\.|fil\.|fll\.|gr\.|(?:j\. |)pl\.|rej\.|st\.|st(?:é|e)r\.|♂|♀)(\))/$1<subCollection>$2<\/subCollection>$3/g;
		
		
		# Separe information collectionAndType de la localite si neccessaire:
		s/(<locality class="(?:.+?)">.+?)(, )((?:holo|iso|neo|syn)-[[:upper:]](?:[[:upper:]](?:[[:upper:]]|)|)(?:\!(?:.+?|)|\.|))(<\/locality>)/$1$4<collectionAndType>$3<\/collectionAndType>/;
		
		
	}
	
	
	# Description atomisation:
	if (/\t\t\t<feature class="description">|\t\t\t<feature class="description" lang="la">/) {
	
		# Insert first and last character tag:
		s/(^)(\t\t\t<feature class="description">|\t\t\t<feature class="description" lang="la">)(.+)(<\/feature>$)/$1$2\n\t\t\t\t<char class="">$3<\/char>\n\t\t\t$4/;
		
		# Insert remaining character tags:
		# Character split:
		s/((?<! ca)(?<!\(ca)\. |(?<! ca)\.<br \/>)([[:upper:]]|\d+-\d+ [[:lower:]])/$1<\/subChar><\/char>\n\t\t\t\t<char class="">$2/g;
		# Subcharacter split #1:
		s/(: |; )/$1<\/subChar>\n\t\t\t\t\t<subChar class="">/g;
		
		# For further subdivision of the description, see atom2.pl
		
		
		# Removes excess <subChar> tags:
		s/(<char class="">.+?)(<\/subChar>)/$1/g;
		# Put the </char> tag on a separate line whenever it is preceded by a </subChar> tag:
		s/(<\/subChar>)(<\/char>)/$1\n\t\t\t\t$2/g;
		# Inserts missing </subChar> tags at end of descriptions:
		s/(subChar class="">.+?(?!\n))(<\/char>)/$1<\/subChar>\n\t\t\t\t$2/;
		
		
		
		# Habit:
		s/(<(?:subC|c)har class=")(">)((?:Root-c|C|Large woody c|Large or medium woody c|Large or small woody c|Small or large c|Delicate c|Stout herbaceous annual c|Tall c|Terrestrial c)limber(?:|s)|(?:C|Ground c)reeper(?:|s)|Deciduous|Dioecious|Monoecious|(?:H|General h)abit|(?:Branching h|H|Terrestrial or epilithic h|Aquatic h|Creeping h|Diffuse h|Erect h|Glabrous h|Large h|Prostrate h|Pubescent h|Weak h)erb|(?:L|Climbing l|Slender l|Tall l)iana|(?:Evergreen t|Large t|Small (?:evergreen |)t|Large to small t|Small or big t|Small to medium-sized t|Medium-sized to big t|Medium to tall t|Tall t|T)ree(?:|s)|(?:Leafy s|Subs|S|Erect s|Climbing s|Scandent(?: or creeping|) s|Scrambling s|Small s|Terrestrial, monopodial s)hrub(?:|s)|Perennial(?:|s)|(?:A|Submerged a)nnual(?:|s)|(?:Glabrous, foliaceous p|Leafy (?:parasitic |)p|Rather (?:large|small(?:-leaved|)) p|Scandent p|Slender p|Small p|Sparsely branched p|Stout (?:brittle |)p)lant(?:|s)|Epiphytic|(?:Small|Large||Medium-sized|Medium-sized epiphytic|Terrestrial) fern(?:|s)|(?:A|a|Small a)quatic plants|Carnivorous|Evergreen|(?:Evergreen m|M)angrove-like|(?:Evergreen m|M)angrove|(?:Semiparasitic m|M)istletoes|(?:Leafy p|P)arasites|Terrestrial|Canopy epiphyte|Fruticose|Polymorphous|Suffrutescent|Suffruticose|(?:Branched v|Glabrous v|V)ine|Woody climber)/$1habit$2$3/g;
			
		# various:
		s/(<(?:subC|c)har class=")(">)(acumen)/$1acumen$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)nnul(?:us|i))/$1annulus cells$2$3/g;
		s/(<(?:subC|c)har class=")(">)(antherozoids)/$1antherozoids$2$3/g;
		s/(<(?:subC|c)har class=")(">)(baculae)/$1baculae$2$3/g;
		s/(<(?:subC|c)har class=")(">)(basal pair)/$1basal pair$2$3/g;
		s/(<(?:subC|c)har class=")(">)(peltate blades)/$1peltate blades$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ature capsule(?:|s))/$1mature capsules$2$3/g;
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
		s/(<(?:subC|c)har class=")(">)((?:P|p)etiolate lea(?:f|ves))/$1petiolate leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)essile lea(?:f|ves))/$1sessile leaves$2$3/g;
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
		s/(<(?:subC|c)har class=")(">)((?:R|r)achid(?:|es))/$1rachides$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r)(?:h|)achis(?:|es))/$1rachises$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)inna-rachises)/$1pinna-rachises$2$3/g;
		s/(<(?:subC|c)har class=")(">)(Rhizome scales)/$1rhizome scales$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r)hizome)/$1rhizome$2$3/g;
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
			
		
		
		s/(<(?:subC|c)har class=")(">)(Anatomy)/$1anatomy$2$3/g;
		s/(<(?:subC|c)har class=")(">)(Stem anatomy)/$1stem anatomy$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)hoot apex)/$1shoot apex$2$3/g;
		s/(<(?:subC|c)har class=")(">)(apex and base)/$1apex and base$2$3/g;
		s/(<(?:subC|c)har class=")(">)(apex)/$1apex$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)reolation)/$1areolation$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:O|o|commonly o)pposite|terminal or axillary|(?:|completely )included)/$1arrangement$2$3/g; # Arrangements (various)
		s/(<(?:subC|c)har class=")(">)((?:A|a)x(?:e|i)s of raceme(?:|s))/$1axes of racemes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)x(?:e|i)s)/$1axes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)edian ax(?:e|i)s)/$1median axes$2$3/g;
		s/(<(?:subC|c)har class=")(">)(base)/$1base$2$3/g;
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
		s/(<(?:subC|c)har class=")(">)((?:C|c)ross section)/$1cross section$2$3/g;
		s/(<(?:subC|c)har class=")(">)(outer edge)/$1outer edges$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:U|u)nicellular glands|(?:G|g)lands|glandulation)/$1glands$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:N|n)ectar glands)/$1nectar glands$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:G|g)round tissue)/$1ground tissue$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:H|h|Stellate h|\d+-celled glandular h|Blackish h)airs|(?:|stems strigose or |densely )tomentose|(?:|partly |minutely |sparsely |densely |sparsely to densely brown |densely brown |shortly brown |outside and inside )pube(?:scent|rulous|rulent)|glabr(?:ous|escent)|(?:|appressed brown |densely brown appressed )velutinous|(?:P|p)lant hairy|trichomes|inflorescence-axes puberulent)/$1hairs$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nner vascular ring)/$1inner vascular ring$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)ntervenium)/$1intervenium$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaf trichomes)/$1leaf hairs$2$3/g;
		s/(<(?:subC|c)har class=")(">)(Lamina|lamina)/$1lamina$2$3/g;
		s/(<(?:subC|c)har class=")(">)(Fertile lamina|fertile lamina)/$1fertile lamina$2$3/g;
		s/(<(?:subC|c)har class=")(">)(Sterile lamina|sterile lamina)/$1sterile lamina$2$3/g;
		s/(<(?:subC|c)har class=")(">)(Apical lamina|apical lamina)/$1apical lamina$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaflets)/$1leaflets$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)pical leaflet(?:|s))/$1apical leaflets$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)asal leaflet(?:|s))/$1basal leaflets$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:D|d)istal leaflet(?:|s))/$1distal leaflets$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)edial leaflet(?:|s))/$1medial leaflets$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)erminal leaflet(?:|s))/$1terminal leaflets$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:U|u)ltimate leaflets)/$1ultimate leaflets$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaf axes)/$1leaf axes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaf sheath)/$1leaf sheath$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaf twigs)/$1leaf twigs$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)imple lea(?:f|ves))/$1simple leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ompound leaves of juvenile plants)/$1juvenile plants$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ompound leaves)/$1compound leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaves of climbing stems)/$1climbing stem leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaves of short stems)/$1short stem leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaves of tall stems)/$1tall stem leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l|Devoid of l)ea(?:f|ves))/$1leaves$2$3/g; # Leaves
		s/(<(?:subC|c)har class=")(">)((?:B|b)asal rosette leaves)/$1basal rosette leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)auline leaves)/$1cauline leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)limbing leaves)/$1climbing leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)loating leaves)/$1floating leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)ntermediate leaves)/$1intermediate leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)ubmer(?:s|g)ed leaves)/$1submerged leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ower leaves)/$1lower leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:E|e)mer(?:s|g)ed leaves)/$1emerged leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ature leaves)/$1mature leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:U|u)nifoliate leaves)/$1unifoliate leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)imb(?:s|))/$1limbs$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m|the m)argin(?:|s))/$1margins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:H|h)yaline margin(?:|s))/$1hyaline margins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaf blade margin(?:|s))/$1leaf blade margins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaf blade(?:|s))/$1leaf blades$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ower leaf blade(?:|s))/$1lower leaf blades$2$3/g;
		s/(<(?:subC|c)har class=")(">)(fragrant)/$1odor$2$3/g;
		s/(<(?:subC|c)har class=")(">)(Red anthocyanin pigments)/$1pigments$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:U|u)pper ridge)/$1upper ridge$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s|Narrow s)cales)/$1scales$2$3/g;
		s/(<(?:subC|c)har class=")(">)(basal scales)/$1basal scales$2$3/g;
		s/(<(?:subC|c)har class=")(">)(large scales)/$1large scales$2$3/g;
		s/(<(?:subC|c)har class=")(">)(small scales)/$1small scales$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)cape bract(?:S|))/$1scape bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)cape sheath(?:S|))/$1scape sheaths$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)cape(?:s|))/$1scapes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)etoliar sheath(?:|s))/$1petiolar sheaths$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s|the s)heath(?:|s))/$1sheaths$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:D|d)orsal side of sheath(?:|s))/$1dorsal side of sheaths$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)oral scales)/$1soral scales$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s|the s)clerenchyma strands)/$1sclerenchyma strands$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:E|e)xtraxylary sclerenchyma)/$1extraxylary sclerenchyma$2$3/g;
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
		s/(<(?:subC|c)har class=")(">)((?:H|h)igher order veins and areolation)/$1higher order veins and areolation$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:H|h)igher order vein(?:ation|s))/$1higher order veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)ntermarginal veins)/$1intermarginal veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ateral veins)/$1lateral veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ongitudinal veins)/$1longitudinal veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)ennate veins)/$1pennate veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ain veins)/$1main veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)idvein)/$1midveins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)rimary (?:vein |)and secondary ve(?:i|)n(?:ation|s))/$1primary and secondary veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)rimary vein)/$1primary veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s|\d+-\d+ pairs of s|\d+-\d+\(-\d+\) pairs of s)econdary veins)/$1secondary veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)(secondary and tertiary ve(?:ins|nation))/$1secondary and tertiary veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)ubmarginal veins)/$1submarginal veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:V|v)essels)/$1vessels$2$3/g;
		
		
		
		s/(<(?:subC|c)har class=")(">)((?:A|a)(?:ch|k)enes)/$1akenes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)lbumen)/$1albumen$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)ndroecium)/$1androecium$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)ndrogynophore)/$1androgynophore$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)ndrophore)/$1androphore$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)nthophore)/$1anthophore$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)nther(?:|s))/$1anthers$2$3/g; # Flowers
		s/(<(?:subC|c)har class=")(">)((?:S|s)terile anther(?:|s))/$1sterile anthers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)nthocarp(?:|s))/$1anthocarps$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)ppendage(?:s|))/$1appendages$2$3/g;
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
		s/(<(?:subC|c)har class=")(">)((?:M|m)ature berr(?:y|ies))/$1mature berries$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)err(?:y|ies))/$1berries$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b|Leaf b)lade(?:|s))/$1blade$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)econdary bracteole(?:|s))/$1secondary bracteoles$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)racteole(?:|s))/$1bracteoles$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b|sessile wart-like b)rachyblast(?:|s))/$1brachyblasts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)asal bracts)/$1basal bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ommon bracts)/$1common bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)loral bracts)/$1floral bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)oliose bracts)/$1foliose bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nflorescence bracts)/$1inflorescence bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nterfloral bracts)/$1interfloral bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nvolucral bracts)/$1involucral bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ateral bracts)/$1lateral bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ower bracts)/$1lower bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)eduncular bracts)/$1peduncular bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)rimary bract(?:|s))/$1primary bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)robract(?:|s))/$1probracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)taminate bracts)/$1staminate bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)terile bract(?:s|))/$1sterile bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)ubtending bracts)/$1subtending bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:U|u)ltimate bracts)/$1ultimate bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ract IV)/$1bract IV$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ract III)/$1bract III$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ract II)/$1bract II$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ract I)/$1bract I$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)racts and bracteoles)/$1bracts and bracteoles$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ract(?:|s))/$1bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)(branching)/$1branching$2$3/g; # Habit
		s/(<(?:subC|c)har class=")(">)((?:I|i)nflorescence branches)/$1inflorescence branches$2$3/g; # Branches
		s/(<(?:subC|c)har class=")(">)((?:U|u)ltimate branches)/$1ultimate branches$2$3/g; # Branches
		s/(<(?:subC|c)har class=")(">)((?:Y|y)oung branches)/$1juvenile branches$2$3/g; # Branches
		s/(<(?:subC|c)har class=")(">)((?:B|b|Short b)ranches)/$1branches$2$3/g; # Branches
		s/(<(?:subC|c)har class=")(">)((?:U|u)ltimate branchlets)/$1ultimate branchlets$2$3/g; # Branches
		s/(<(?:subC|c)har class=")(">)((?:Y|y)oung branchlets)/$1juvenile branchlets$2$3/g; # Branches
		s/(<(?:subC|c)har class=")(">)((?:B|b)ranchlets)/$1branchlets$2$3/g; # Branches
		s/(<(?:subC|c)har class=")(">)((?:A|a)xillary bud(?:|s))/$1axillary buds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:E|e)xtra-axillary bud(?:|s))/$1extra-axillary buds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)loral bud(?:|s))/$1floral buds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)lower bud(?:|s))/$1flower buds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaf bud(?:|s))/$1leaf buds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ature bud(?:|s))/$1mature buds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)erminal bud(?:|s))/$1terminal buds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ud(?:|s))/$1buds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)uttresses)/$1buttresses$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)alyculus)/$1calyculus$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)alyx lobes)/$1calyx lobes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)alyx)/$1calyx$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)arpellate bracts)/$1carpellate bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)arpellate flowers)/$1carpellate flowers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)arpellate pedicels)/$1carpellate pedicels$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)arpel(?:s|))/$1carpels$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)arpophore)/$1carpophore$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)aruncle)/$1caruncle$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)asal cataphylls)/$1basal cataphylls$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ataphylls)/$1cataphylls$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)incinni)/$1cincinni$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c|longest c)ilia)/$1cilia$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c|with c|many c|without c|no c)olleters)/$1colleters$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)olumn)/$1column$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:c|with a c|with an apical c)oma)/$1coma$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)entral column)/$1central column$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)onnective)/$1connective$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)orms)/$1corms$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)orolla)/$1corolla$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ature corolla)/$1mature corolla$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:O|o)pen corolla)/$1open corolla$2$3/g;
		s/(<(?:subC|c)har class=")(">)(antipetalous corona lobes)/$1antipetalous corona lobes$2$3/g;
		s/(<(?:subC|c)har class=")(">)(alternipetalous corona lobes)/$1alternipetalous corona lobes$2$3/g;
		s/(<(?:subC|c)har class=")(">)(alternating corona lobes)/$1alternating corona lobes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c|small c)orona lobes)/$1corona lobes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c|with a c)orona)/$1corona$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)otyledons)/$1cotyledons$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ruit cupule)/$1fruit cupule$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)upule)/$1cupule$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)yme(?:s|))/$1cymes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ruiting cymule(?:s|))/$1fruiting cymules$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:U|u)ltimate cymule(?:s|))/$1ultimate cymules$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ymule(?:s|))/$1cymules$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:(?:W|w)ithout c|C|c)ystoliths)/$1cystoliths$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:|trunk )\d+-\d+ (?:|c)m dbh|trunk to \d+ cm dbh)/$1dbh$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:D|d|longitudinally d|Not d|not d)ehisc(?:ent|ing))/$1dehiscence$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:D|d)ichasi(?:um|a))/$1dichasia$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:D|d|occasionally with d|hair-filled d|with or without d|without d)omatia)/$1domatia$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eaf(?:-| )domatia)/$1leaf domatia$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)uft(?:-| )domatia)/$1tuft domatia$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:D|d)ots)/$1dots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:Baccate d|D|d)rupe(?:|s))/$1drupes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:N|n)ectary(?:-| )disc)/$1nectary disc$2$3/g;
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
		s/(<(?:subC|c)har class=")(">)((?:(?:S|s)tamen f|F|f)ilament(?:|s))/$1filaments$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)laps)/$1flaps$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)carious flaps)/$1scarious flaps$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)lowering stem(?:s|))/$1flowering stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:V|v)egetative stem(?:s|))/$1vegetative stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)lowering)/$1flowering$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)lowers numberus|many-flowered)/$1flower number$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b|In b|in b)isexual flower(?:|s))/$1bisexual flowers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f|in f)emale flower(?:|s)|Female ‘flower(?:|s)’)/$1female flowers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ateral flower(?:|s))/$1lateral flowers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m|in m)ale flower(?:|s)|Male ‘flower(?:|s)’)/$1male flowers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ature flower(?:|s))/$1mature flowers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:O|o)pen flower(?:|s))/$1open flowers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:U|u)ppermost flower(?:|s))/$1uppermost flowers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:The f|All f|often numerous f|F|f)lower(?:|s)|‘Flowers’)/$1flowers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)oramen)/$1foramen$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f|With two f)ringed wing(?:|s))/$1fringed wings$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ruiting pedicel(?:|s))/$1fruiting pedicel$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ruit pedicel(?:|s))/$1fruit pedicels$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ruiting perianth)/$1fruiting perianth$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)apsular fruit(?:|s))/$1capsular fruits$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:D|d)rupriceous fruit(?:|s))/$1drupriceous fruits$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)alse fruit(?:|s))/$1false fruits$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)mmature fruit(?:|s)|(?:Y|y)oung fruit(?:|s))/$1juvenile fruits$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ature fruit(?:|s)|(?:R|r)ipe fruit(?:|s))/$1mature fruits$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:B|b)road-winged fruit(?:|s))/$1broad-winged fruits$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:N|n)arrow-winged fruit(?:|s))/$1narrow-winged fruits$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ruit(?:|s))/$1fruits$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:G|g)ermination)/$1germination$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nterstaminal glands)/$1interstaminal glands$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:W|w|the w)axy gland(?:|s|ular spots)|(?:N|n)odal glands|hypogynous glands)/$1glands$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:G|g|no g|few g|lacking g)lands)/$1glands$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:G|g)lomerules)/$1glomerules$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:G|g)rain)/$1grain$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:G|g)rowth rings)/$1growth rings$2$3/g; # Wood
		s/(<(?:subC|c)har class=")(">)((?:G|g)ynoecium)/$1gynoecium$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a|in a)pocarpous gynoeci(?:um|a))/$1apocarpous gynoecium$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s|in s)yncarpous gynoeci(?:um|a))/$1syncarpous gynoecium$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nternal hairs)/$1hairs$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:H|h)air bases|dark dots \(corky hair bases\))/$1hair bases$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:primary h|H|h)austeri(?:a|um))/$1hausteria$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:H|h)eads)/$1heads$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:H|h)eight)/$1height$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ower hypanthium(?!.+?upper hypanthium))/$1lower hypanthium$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:U|u)pper hypanthium)/$1upper hypanthium$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)ower h|H|h)ypanthium)/$1hypanthium$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:H|h)ypodermis)/$1hypodermis$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)seudo(?:|-)hypodermis)/$1pseudohypodermis$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)ndument(?:|um))/$1indumentum$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)emale inflorescence(?:|s))/$1female inflorescences$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ale inflorescence(?:|s))/$1male inflorescences$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:Female and bisexual i|I|i)nflorescence(?:|s))/$1inflorescences$2$3/g; # Inflorescences
		s/(<(?:subC|c)har class=")(">)(rhachis of inflorescence)/$1rhachis of inflorescence$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nfructescence(?:|s))/$1infructescences$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nternal bristles)/$1internal bristles$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:U|u)pper internodes)/$1upper internodes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:Y|y)oung internodes)/$1young internodes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nternodes)/$1internodes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:|usually )with an interpetiolar ridge)/$1interpetiolar ridge$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nvolucre(?:|s))/$1involucres$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:J|j)uvenile leaves)/$1juvenile leaves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:J|j)uvenile plant(?:|s)|(?:Y|y)oung plant(?:|s))/$1juvenile plants$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:J|j)uvenile part(?:|s)|(?:Y|y)oung(?:|est) part(?:|s))/$1juvenile parts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l|producing white l|copious white l)atex)/$1latex$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)enticels|(?:|not |sparsely to densely |often sparsely |rarely |pale )lenticellate)/$1lenticels$2$3/g; # Bark
		s/(<(?:subC|c)har class=")(">)((?:L|l|the l)id)/$1lid$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l|the l|no l)igul(?:a|e))/$1ligula$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l|the l)ip)/$1lip$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ocules)/$1locules$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ericarp(?:|s))/$1mericarps$2$3/g;
		s/(<(?:subC|c)har class=")(">)(\d+-merous)/$1merosity$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)esocarp(?:|s))/$1mesocarps$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m|the m)idrib)/$1midrib$2$3/g; # Leaves
		s/(<(?:subC|c)har class=")(">)((?:M|m)ilk(?:| )sap)/$1milk sap$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m|the m)onocarps)/$1monocarps$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m|the m)outh)/$1mouth$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)itcher mouth)/$1pitcher mouth$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:N|n)ectar(?:ies|y))/$1nectaries$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:N|n)euter flowers)/$1neuter flowers$2$3/g; # Flowers
		s/(<(?:subC|c)har class=")(">)((?:N|n)erves)/$1nerves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)ntermediate nerves)/$1intermediate nerves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ateral nerves)/$1lateral nerves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ongitudinal nerves)/$1longitudinal nerves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)ennate nerves)/$1pennate nerves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:N|n)odes)/$1nodes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:N|n)utlet(?:s|))/$1nutlets$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:N|n)ut(?:s|))/$1nuts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:O|o|with o)chrea)/$1ochrea$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:O|o)stiole)/$1ostiole$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:The o|Rudimentary o|O|o)var(?:y|ies))/$1ovary$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:O|o|several o|many o|\d+ o)vule(?:|s))/$1ovules$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)anicle(?:s|))/$1panicles$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)apillae|(?:P|p)apillose)/$1papillae$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)taminate pedicel(?:|s))/$1staminate pedicels$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p|male and female flowers with slender p)edicel(?:|s))/$1pedicels$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p|(?:C|c)ommon p)eduncle bract(?:|s))/$1peduncle bracts$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p|(?:C|c)ommon p)eduncle(?:|s)|(?:Ep|ep|P|p)edunculate)/$1peduncle$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)onnate part of the peduncle(?:|s))/$1connate part of the peduncle$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ree part of th peduncle(?:|s))/$1free part of the peduncle$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)artial peduncle(?:|s))/$1partial peduncles$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)econdary peduncle(?:|s))/$1secondary peduncles$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p|dry p)ericarp)/$1pericarp$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)emale perianth)/$1female perianth$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ale perianth)/$1male perianth$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p|\d+-\d+ p)erianth(?:-| )segments)/$1perianth segments$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)erianth(?:-| )tube)/$1perianth tube$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)erianth)/$1perianth$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p|the p)eristome)/$1peristome$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p|(?:T|t)he p)etal(?:|s))/$1petals$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)eriderm)/$1periderm$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:slender p|P|p)etiole(?:|s))/$1petiole$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)etiolule(?:|s))/$1petiolule$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)hyllotaxy)/$1phyllotaxy$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)hyllode(?:s|))/$1phyllodes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)istillate flower(?:|s))/$1pistillate flowers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)istillate inflorescence(?:|s))/$1pistillate inflorescences$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)istillode)/$1pistillode$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:(?:R|r)udimentary p|P|p)istil)/$1pistil$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)itcher(?:|s))/$1pitchers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nner pitcher(?:|s))/$1inner pitchers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)ntermediate pitcher(?:|s))/$1intermediate pitchers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ower pitcher(?:|s))/$1lower pitchers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ower and intermediate pitcher(?:|s))/$1lower and intermediate pitchers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:O|o)uter pitcher(?:|s))/$1outer pitchers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:U|u)nopened pitcher(?:|s))/$1unopened pitchers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:U|u)pper pitcher(?:|s))/$1upper pitchers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:Y|y)oung pitcher(?:|s))/$1juvenile pitchers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)lacenta)/$1placenta$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)mmature pollen)/$1immature pollen$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)ollen)/$1pollen$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)ollination)/$1pollination$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)rojection)/$1projection$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)rophyll(?:|um))/$1prophyllum$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)seudanthi(?:a|um))/$1pseudanthia$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)seudohilum)/$1pseudohilum$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r)aceme(?:|s))/$1racemes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r)adicle)/$1radicle$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r)ays)/$1rays$2$3/g; # Bark, Wood
		s/(<(?:subC|c)har class=")(">)((?:R|r)eceptacle)/$1receptacle$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r)esting buds)/$1resting buds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r)eticulation(?:|s))/$1reticulation$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r)etinacula)/$1retinacula$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r|each r)hipidium)/$1rhipidium$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r)oot system|(?:T|t)aproot(?:|s)|fibrous-rooted)/$1root system$2$3/g; 
		s/(<(?:subC|c)har class=")(">)((?:R|r)oot(?:|s))/$1roots$2$3/g; # Roots
		s/(<(?:subC|c)har class=")(">)((?:A|a)dventitious roots)/$1adventitious roots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:basal e|E|e)picortical root(?:|s))/$1epicortical roots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)rimary root(?:|s))/$1primary roots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:|knee-shaped )pneumatophore roots)/$1pneumatophore roots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r)osette)/$1rosettes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:R|r)ostrum)/$1rostrum$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)amara(?:|s))/$1samaras$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)cars of(?:| the) leaves|(?:L|l)eaf scars)/$1leaf scars$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)cars of the petioles)/$1petiole scars$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)cars of the stipules|(?:S|s)tipule scars)/$1stipule scars$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:O|o)il cell(?:|s))/$1secretory structures$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)eedling(?:|s))/$1seedlings$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)eed(?:|s)|\d+-seeded)/$1seeds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ature seed(?:|s))/$1mature seeds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:I|i)mmature seed(?:|s))/$1immature seeds$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)epal(?:|s))/$1sepals$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ateral sepal(?:|s))/$1lateral sepals$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:O|o)uter sepal(?:|s))/$1outer sepals$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)hoot(?:s| ))/$1shoots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)limbing shoots)/$1climbing shoots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:G|g)enerative shoot(?:|s))/$1generative shoots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:H|h)orizontal shoot(?:|s))/$1horizontal shoots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)hort(?:-| )shoots)/$1short shoots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:V|v)ertical shoot(?:|s))/$1vertical shoots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:Y|y)oung shoots)/$1juvenile shoots$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)padix)/$1spadix$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)pathe)/$1spathe$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)pathal sheath)/$1spathal sheath$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ature spike(?:|s))/$1mature spikes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:head-like s|S|s)pike(?:|s))/$1spikes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s|with s)pine(?:|s))/$1spines$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)pur(?:|s))/$1spurs$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)quamulae intravaginales)/$1squamulae intravaginales$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)talk(?:|s))/$1stalks$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ertile stamen(?:|s))/$1fertile stamens$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)tamen(?:|s))/$1stamens$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)taminal column)/$1staminal column$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)taminate flower(?:|s))/$1staminate flowers$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)taminate inflorescence(?:|s))/$1staminate inflorescences$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s|minutes s)taminode(?:|s))/$1staminodes$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:A|a)bove ground stem(?:|s))/$1above ground stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:Y|y)oung(?:er|) stem(?:|s))/$1juvenile stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)tem(?:|s))/$1stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:C|c)limbing stem(?:|s))/$1climbing stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ateral stem(?:|s))/$1lateral stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eafy stem(?:|s))/$1leafy stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ive stem(?:|s))/$1live stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ain stem(?:|s))/$1main stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:O|o)lder stem(?:|s))/$1older stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)econd stem(?:|s))/$1second stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)hort stem(?:|s))/$1short stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)all stem(?:|s))/$1tall stems$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)tigma(?:|s))/$1stigma$2$3/g;
		s/(<(?:subC|c)har class=")(">)(stilt-roots)/$1stilt-roots$2$3/g; # Habit
		s/(<(?:subC|c)har class=")(">)((?:S|s)tipule-like appendages)/$1stipule-like appendages$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:P|p)seudostipules)/$1pseudostipules$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:small s|S|s)tipules)/$1stipules$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)tolon(?:|s))/$1stolons$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s|short s)tyle head)/$1style head$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s|the s)tyle(?:|s))/$1style$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)ynandrium)/$1synandrium$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)egmen)/$1tegmen$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)endril(?:|s))/$1tendrils$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)epals)/$1tepals$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)ower tepals)/$1lower tepals$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)esta)/$1testa$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)hecae)/$1thecae$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)horns)/$1thorns$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:S|s)tipular thorns)/$1stipular thorns$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)hyrses)/$1thyrses$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)ip)/$1tip$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)orus)/$1torus$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)runk)/$1trunk$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:staminal t|T|t)ube)/$1tube$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ature tube)/$1tube$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t|No t)urion)/$1turion$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l)eafy twigs)/$1leafy twigs$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:O|o)lder twigs)/$1older twigs$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:Y|y)oung(?:est|) twigs)/$1young twigs$2$3/g; # Twigs
		s/(<(?:subC|c)har class=")(">)((?:T|t)wigs)/$1twigs$2$3/g; # Twigs
		s/(<(?:subC|c)har class=")(">)((?:U|u)tricle)/$1utricles$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:V|v)alves)/$1valves$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:V|v)ernation)/$1vernation$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:pinnate v|obscure v||V|v)e(?:i|)nation|at base (?:sub-|)\d-veined|pinnately veined)/$1veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:L|l|basal l)ateral vein(?:|s))/$1lateral veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:T|t)ertiary(?:| and smaller) ve(?:nation|ins))/$1tertiary veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:Q|q)uaternary ve(?:nation|ins))/$1quaternary veins$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:W|w)ing)/$1wings$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:W|w)ood)/$1wood$2$3/g; # Wood
		s/(<(?:subC|c)har class=")(">)((?:S|s)apwood)/$1sapwood$2$3/g;
		s/(<(?:subC|c)har class=")(">)((?:H|h)eartwood)/$1heartwood$2$3/g;
		
		
		
		# classes covering various things:
		s/(<(?:subC|c)har class=")(">)((?:O|o|commonly o)pposite|terminal or axillary|(?:|completely )included|adnate to)/$1arrangement$2$3/g; # Arrangements
		s/(<(?:subC|c)har class=")(">)((?:|mid-)green|olivaceous|white|yellow|red|blue|(?:|dark |greenish|greenish \(dark\) )brown|black|purple|pink)(, )/$1appearance$2$3$4/g; # Appearance (color + texture, sometimes other information too)
		s/(<(?:subC|c)har class=")(">)(Dispersal)/$1dispersal$2$3/g; # Dispersal
		s/(<(?:subC|c)har class=")(">)((?:C|c)olour|olivaceous|(?:|mid-)green|white|yellow|red|blue|(?:|dark |greenish |greenish \(dark\) )brown|black|purple|pink)/$1colour$2$3/g; # Only colour
		s/(<(?:subC|c)har class=")(">)((?:|mostly )salverform|infundibuliform|campanulate|rotate|urceolate|actinomorphic|zygomorphic|wide at base|ovoid\.|(?:|fusiform or )linear|narrowed towards)/$1shape$2$3/g; # Shapes
		s/(<(?:subC|c)har class=")(">)(coriaceous|papery)/$1texture$2$3/g; # Textures
		
		
	}
	
	# Specimen atomisation ver. 1:
	elsif (/\t\t\t\t<gathering>/) {
		
		
		# WOOD SPECIMENS atomisation:
		if (/\t\t\t\t<gathering>.+Uw/) {
			
			# Inserts additional <gathering> tags:
			s/(; (?!diam\.))/<\/gathering>$1<gathering>/g;
			s/(\.)( )(Brazil|Guyana|Suriname|French Guiana)/$1<\/gathering>; <gathering>$3/g;
			
			# Inserts gatheringGroup mark-up:
			s/(\t\t\t\t)(<gathering>.+?: )((?:Brazil|Guyana|Suriname|French Guiana): )(.+<\/gathering>)($)/$1<gatheringGroup geoscope="">$3$2$4<\/gatheringGroup>/;
			s/(; )(<gathering>)((?:Brazil|Guyana|Suriname|French Guiana): )/<\/gatheringGroup>$1<gatheringGroup geoscope="">$3$2/g;
			
			s/(<gatheringGroup geoscope=")(">Brazil)/$1brazil$2/;
			s/(<gatheringGroup geoscope=")(">Guyana)/$1guyana$2/;
			s/(<gatheringGroup geoscope=")(">French Guiana)/$1french guiana$2/;
			s/(<gatheringGroup geoscope=")(">Suriname)/$1suriname$2/;
			
			# Species name mark-up:
			s/(<gathering>)([[:upper:][:lower:]\. \(\)&]+)(: )/$1<fullName rank="species">$2<\/fullName>$3/;
			# Change to subspecies:
			s/(<fullName rank=")(species">[[:upper:][:lower:] \.]+?subsp\.)/$1sub$2/g;
			# Clavija lancifolia Desf. subsp. lancifolia
			
			# Alternative field number mark-up:
			# Format starts with = Uw
			s/( = )(Uw \d+)((?:\.|)<\/gathering>)/$1<alternativeFieldNum>$2<\/alternativeFieldNum>$3/g;
			# Format starts with (Uw
			s/(\()(Uw \d+)(((?:; diam\. \d(?:\.\d+|) cm|)\)(?:\.|))<\/gathering>)/$1<alternativeFieldNum>$2<\/alternativeFieldNum>$3/g;
			
			# Collector and collection number mark-up:
			# AlternativeFieldNum format starts with = Uw
			s/(<gathering>|: )([[:upper:][:lower:] &\.-]+)( )(\d+)( = <alternativeFieldNum>)/$1<collector>$2<\/collector>$3<fieldNum>$4<\/fieldNum>$5/g;
			# AlternativeFieldNum format starts with (Uw
			s/(<gathering>|: )([[:upper:][:lower:] &\.-]+)( )(\d+)( \(<alternativeFieldNum>)/$1<collector>$2<\/collector>$3<fieldNum>$4<\/fieldNum>$5/g;

			
			
		}
		
		
		# COMPLETE SPECIMEN LIST atomisation:
		
		# Inserts additional <gathering> tags:
		s/((?<!<\/gathering>)(?<!<\/gatheringGroup>); (?!diam\.))/<\/gathering>$1<gathering>/g;
		
		# Mark up species names:
		s/( \()([[:upper:]][[:lower:]]+ [[:lower:]]+(?:(?: \((?:(?:[[:upper:]]\.)+ |)[[:upper:]][[:lower:]\. &]+\)|)(?: (?:[[:upper:]]\.)+|) [[:upper:]][[:lower:]\.]+|))(\)(?: — [A-Z][A-Z](?:\?|)|)<\/gathering>)/$1<fullName rank="species">$2<\/fullName>$3/g;
		
		# Mark up subspecies names:
		s/( \()([[:upper:]][[:lower:]]+ [[:lower:]]+ [[:upper:][:lower:]\. ]+ subsp\. [[:lower:]]+(?: \([[:upper:][:lower:]\. ]+\) [[:upper:][:lower:]\. ]+|))(\)<\/gathering>)/$1<fullName rank="subspecies">$2<\/fullName>$3/g;
		s/( \()([[:upper:]][[:lower:]]+ [[:lower:]]+ subsp\. [[:lower:]]+(?: \([[:upper:][:lower:]\. ]+\) [[:upper:][:lower:]\. ]+|))(\)<\/gathering>)/$1<fullName rank="subspecies">$2<\/fullName>$3/g;
		
		# Mark up varieties names:
		s/( \()([[:upper:]][[:lower:]]+ [[:lower:]]+ (?:\([[:upper:][:lower:]\. ]+\) |)[[:upper:][:lower:]\. ]+ var\. [[:lower:]]+(?: (?:\([[:upper:][:lower:]\. ]+\) |)[[:upper:][:lower:]\. ]+|))(\)<\/gathering>)/$1<fullName rank="variety">$2<\/fullName>$3/g;
		s/( \()([[:upper:]][[:lower:]]+ [[:lower:]]+ var\. [[:lower:]]+(?: (?:\([[:upper:][:lower:]\. ]+\) |)[[:upper:][:lower:]\. ]+|))(\)<\/gathering>)/$1<fullName rank="variety">$2<\/fullName>$3/g;
		
		
		# Check Uw not being matched in script below !!!!!!!!!!!!
		
		if (/\(<fullName rank="(?:(?:sub|)species|variety)">[[:upper:]][[:lower:]]+ [[:lower:]]+(?: (?:\([[:upper:][:lower:]\. ]+\) |)[[:upper:][:lower:]\. ]+ (?:subsp|var)\. [[:lower:]]+ \([[:upper:][:lower:]\. ]+\) [[:upper:][:lower:]\. ]+|(?: \((?:(?:[[:upper:]]\.)+ |)[[:upper:]][[:lower:]\.]+\)|)(?: (?:[[:upper:]]\.)+|) [[:upper:]][[:lower:]\.]+|)<\/fullName>\)(?!Uw)/) {
			
			
			# Collection numbers:
			s/(<gathering>(?:[[:upper:][:lower:], \.&-]+|))((?:[[:upper:]](?:-| |)|)\d+(?:[[:upper:]]|)(?:(?:, (?:[[:upper:]](?:-| |)|)\d+(?:[[:upper:]]|))+|)|s\.n\.)( \(<fullName|(?: |)=)/$1<fieldNum>$2<\/fieldNum>$3/g;
			# Alternative collection numbers:
			s/(<\/fieldNum>(?: |) = )([[:upper:]]+(?: |)\d+)( \()/$1<alternativeFieldNum>$2<\/alternativeFieldNum>$3/g;
			
			# Fixes missed prefixes:
			s/([[:upper:]](?:[[:upper:]]+|)(?:-| |))(<fieldNum>)(\d+)/$2$1$3/g;
			
			
			# Collectors:
			s/(<gathering>)([[:upper:][:lower:], \.&-]+)(, <fieldNum)/$1<collector>$2<\/collector>$3/;
			
			
		}
		
		# BETA VERSION:
		# gatheringGroups in older vols:
		# Wipes locality tags off gatheringGroup information and moves closing gathering tag to correct position:
		s/( — )(<locality class="">)([[:upper:]][[:upper:]])(<\/locality>)(<\/gathering>)/$5$1$3/;
		
		# Inserts gatheringGroup tags for each area:
		# Brazil:
		s/(^\t\t\t\t<gathering>.+?<\/gathering> — BR)/\t\t\t\t<gatheringGroup geoscope="brazil">\n$1\n\t\t\t\t<\/gatheringGroup>/;
		# French Guiana:
		s/(^\t\t\t\t<gathering>.+?<\/gathering> — FG)/\t\t\t\t<gatheringGroup geoscope="french guiana">\n$1\n\t\t\t\t<\/gatheringGroup>/;
		# Guyana:
		s/(^\t\t\t\t<gathering>.+?<\/gathering> — GU)/\t\t\t\t<gatheringGroup geoscope="guyana">\n$1\n\t\t\t\t<\/gatheringGroup>/;
		# Suriname:
		s/(^\t\t\t\t<gathering>.+?<\/gathering> — SU)/\t\t\t\t<gatheringGroup geoscope="suriname">\n$1\n\t\t\t\t<\/gatheringGroup>/;
		# Venezuela:
		s/(^\t\t\t\t<gathering>.+?<\/gathering> — VE)/\t\t\t\t<gatheringGroup geoscope="venezuela">\n$1\n\t\t\t\t<\/gatheringGroup>/;
	
		
		
		# OLD STUFF:
		# For one collection on a single line:
		
		# Marks up all collections of the format "Collector, A.B., 34 (Species name)":
		# s/^(\t\t\t\t<gathering>)([[:upper:]][[:upper:][:lower:]\- \.,&]+?|[[:upper:]]+ \([[:upper:][:lower:], ]+\)|(?:(?:I|i)ndigenous|(?:u|U)nknown|(?:w|W)ithout) col(?:lector|l\.|\.))(, |, in [[:upper:]]+ )((?:\d+|\d+[A-Za-z]|\d+=[[:upper:]]+ \d+|s\.n\.)(?:, \d+|, \d+[A-Za-z]|, \d+=[[:upper:]]+ \d+|, s\.n\.|)+)( \()([[:upper:]][[:lower:]]+ [[:lower:]]+)(\)<\/gathering>)$/$1<collector>$2<\/collector>$3<fieldNum>$4<\/fieldNum>$5<fullName rank="species">$6<\/fullName>$7/;
		# Marks up all collections of the format "Collector, A.B. (Species name)":
		# s/^(\t\t\t\t<gathering>)([[:upper:]][[:upper:][:lower:]\- \.,&]+?|[[:upper:]]+ \([[:upper:][:lower:], ]+\)|(?:(?:I|i)ndigenous|(?:u|U)nknown|(?:w|W)ithout) col(?:lector|l\.|\.))(, \()([[:upper:]][[:lower:]]+ [[:lower:]]+)(\)<\/gathering>)$/$1<collector>$2<\/collector>$3<fullName rank="species">$4<\/fullName>$5/;
		
		
		# For multiple collections on a single line
		
		# DON'T COPY OVER AUTHOR!!!! CHANGE SCRIPT FOR SIMPLIFICATION!
		
		# Fanshawe, D.B., 2450=FD 5186 (Phytolacca rivinoides)
		# 1) Marks up line start; all collections of the format "Collector, A.B., 34 (Species name); ":
		# s/^(\t\t\t\t<gathering>)([[:upper:]][[:upper:][:lower:]\- \.,&]+?|[[:upper:]]+ \([[:upper:][:lower:], ]+\)|(?:(?:I|i)ndigenous|(?:u|U)nknown|(?:w|W)ithout) col(?:lector|l\.|\.))(, |, in [[:upper:]]+ )((?:\d+|\d+[A-Za-z]|\d+=[[:upper:]]+ \d+|s\.n\.)(?:, \d+|, \d+[A-Za-z]|, \d+=[[:upper:]]+ \d+|, s\.n\.|)+)( \()([[:upper:]][[:lower:]]+ [[:lower:]]+)(\))(; )/$1<collector>$2<\/collector>$3<fieldNum>$4<\/fieldNum>$5<fullName rank="species">$6<\/fullName>$7<\/gathering>$8<gathering><collector>$2<\/collector>, /;
		
		# 2) Subsequent collections mark up:
		# s/(; <gathering>)(<collector>(?:[[:upper:]][[:upper:][:lower:]\- \.,&]+?|[[:upper:]]+ \([[:upper:][:lower:], ]+\)|(?:(?:I|i)ndigenous|(?:u|U)nknown|(?:w|W)ithout) col(?:lector|l\.|\.))<\/collector>)(, |, in [[:upper:]]+ )((?:\d+|\d+[A-Za-z]|\d+=[[:upper:]]+ \d+|s\.n\.)(?:, \d+|, \d+[A-Za-z]|, \d+=[[:upper:]]+ \d+|, s\.n\.|)+)( \()([[:upper:]][[:lower:]]+ [[:lower:]]+)(\))(; )/$1$2$3<fieldNum>$4<\/fieldNum>$5<fullName rank="species">$6<\/fullName>$7<\/gathering>$8<gathering>$2, /;
		# 2)a) More subsequent collections mark up:
		# s/(; <gathering>)(<collector>(?:[[:upper:]][[:upper:][:lower:]\- \.,&]+?|[[:upper:]]+ \([[:upper:][:lower:], ]+\)|(?:(?:I|i)ndigenous|(?:u|U)nknown|(?:w|W)ithout) col(?:lector|l\.|\.))<\/collector>)(, |, in [[:upper:]]+ )((?:\d+|\d+[A-Za-z]|\d+=[[:upper:]]+ \d+|s\.n\.)(?:, \d+|, \d+[A-Za-z]|, \d+=[[:upper:]]+ \d+|, s\.n\.|)+)( \()([[:upper:]][[:lower:]]+ [[:lower:]]+)(\))(; )/$1$2$3<fieldNum>$4<\/fieldNum>$5<fullName rank="species">$6<\/fullName>$7<\/gathering>$8<gathering>$2, /;
		
		# 3) Closing collection mark up:
		# s/(; <gathering>)(<collector>(?:[[:upper:]][[:upper:][:lower:]\- \.,&]+?|[[:upper:]]+ \([[:upper:][:lower:], ]+\)|(?:(?:I|i)ndigenous|(?:u|U)nknown|(?:w|W)ithout) col(?:lector|l\.|\.))<\/collector>)(, |, in [[:upper:]]+ )((?:\d+|\d+[A-Za-z]|\d+=[[:upper:]]+ \d+|s\.n\.)(?:, \d+|, \d+[A-Za-z]|, \d=[[:upper:]]+ \d+|, s\.n\.|)+)( \()([[:upper:]][[:lower:]]+ [[:lower:]]+)(\)<\/gathering>)($)/$1$2$3<fieldNum>$4<\/fieldNum>$5<fullName rank="species">$6<\/fullName>$7/;
		
		
		# AlternativeFieldNum: Does not work properly.
		# s/(<\/fieldNum>)(=)([[:upper:]]+ \d+)(<\/fieldNum>)/$1$4$2<alternativeFieldNum>$3<\/alternativeFieldNum>/g;
		
		# END OLD STUFF
		
		# Moves things like "in LBB" to collector:
		s/(<\/collector>)(, in [[:upper:]]+)( )/$2$1$3/g;

	}
	
	# Specimen atomisation ver. 2 (left-over specimens):
	if (/^<gathering>/) {
		
		# Inserts additional <gathering> tags:
		s/(; )/<\/gathering>$1<gathering>/g;
		
		# Swaps closing dot and closing gathering tag:
		s/(\))(\.)(<\/gathering>)/$1$3$2/;
		
		# CollectionAndType:
		s/(\()([[:upper:] ,?]+)(\))/$1<collectionAndType>$2<\/collectionAndType>$3/g;
		
		# Alternative collection number mark-up:
		# Alternative collector + collection number:
		s/( = )([[:upper:][:lower:] &\.-]+)( )(\d+)/$1<alternativeCollector>$2<\/alternativeCollector>$3<alternativeFieldNum>$4<\/alternativeFieldNum>/g;
		# Alternative collector:
		s/(\(=)([[:upper:][:lower:] &\.-]+)(\))/$1<alternativeCollector>$2<\/alternativeCollector>$3/g;
		# Alternative collection number:
		s/(\(= )([[:upper:]][[:upper:]] \d+)(\))/$1<alternativeFieldNum>$2<\/alternativeFieldNum>$3/g;
		
		# Collector and collection number:
		s/(<gathering>[[:upper:][:lower:] &\.\d,—'’:-]+, |<gathering>)([[:upper:][:lower:] &\.-]+)( )(\d+(?:[[:upper:]]|[[:lower:]]|, \d+|)|s\.n\.)( \((?:= <alternativeFieldNum>|<collectionAndType>))/$1<collector>$2<\/collector>$3<fieldNum>$4<\/fieldNum>$5/g;
		
		# Locality:
		s/(<gathering>)([[:upper:][:lower:] &\.\d,—'’:-]+)(, )/$1<locality class="locality">$2<\/locality>$3/g;
		
		# Inserts tabs at start of each line:
		s/^(<gathering>)/\t\t\t\t\t$1/;
		
		# Changes position of brackets near collectionAndType:
		s/(\()(<collectionAndType>)/$2$1/g;
		s/(<\/collectionAndType>)(\))/$2$1/g;
		
		
	}
	
	
	# Distribution Atomisation:
	elsif (/\t\t\t\t<string><subHeading>Distribution:<\/subHeading>/) {
		
		
		# Global:
		s/((?:nearly c|C)osmopolitan|Neotropical regions|Neotropics|(?:(?:T|t)ropical and subtropical (?:areas|regions) of the (?:Old and |)|)New World(?:s|)(?: tropics(?: and subtropics|)|)|(?:New and |)Old World(?:s|)(?: tropics and subtropics|)|Paleotropics|(?:P|p)antropical(?: and subtropical|)|pansubtropical|tropic(?:al|s) and subtropic(?:al|s) (?:regions |)of the New and Old Worlds|temperate zones of both hemispheres|(?:Northern|Southern) Hemisphere|worldwide)/<distributionLocality class=\"world\">$1<\/distributionLocality>/g;
		
		
		# Oceanic Regions:
		s/(Caribbean(?: region|)|Pacific islands|Polynesia)/<distributionLocality class=\"oceanic region\">$1<\/distributionLocality>/g;
		
		
		# Continental Regions + continents:
		s/((?:NE |tropical |)Australia|(?:tropical and southern |NE |(?:S|s)outh(?:ern|) |Tropical |(?:tropical |)W |West |)Africa|(?:C(?:entral|) |C (?:and|to) (?:northern |)S |Latin |(?:(?:tropical |)Central and |northern |(?:Tropical and sub|T|t)ropical |)South |(?:(?:continental|(?:N|n)orthern|northeastern|tropical) |)S |(?:tropical and sub|)(?:T|t)ropical (?:and temperate |)|)America|(?:(?:E |)tropical |Southeast |)Asia|Indo-Pakistan subcontinent)/<distributionLocality class=\"continental region\">$1<\/distributionLocality>/g;
		
		# Separates the continents from the continental regions:
		s/(<distributionLocality class=")(continental region)(">)((?:South |S |North |N |)America|Australia|Africa|Asia)(<\/distributionLocality>)/$1continent$3$4$5/g;
		
		
		# Regions + Countries:
		s/((?:western |)Amazonian basin|Amazon region|E and central Amazon|(?:western part of Brazilian |)Amazonia(?!n)|secondary forests outside the Amazonian region|(?:W to the foothills of the |)Andes(?: Mts\.|)|Angola|(?:Greater |Lesser |)Antilles|Arabia|(?:Central |north-central |northern |)Argentin(?:a|e)|Bahamas|Bahama Islands|Bangladesh|Belize|(?:Amazonian |Andes of northern |central |north-eastern |south to |N |)Bolivia|Borneo|(?:(?:central to eastern |northern parts of |)Amazonian |eastern central |(?:western and |)(?:N|n)orthern (?:half of |)|northeast |north(?:-|)western |(?:eastern and |)southern |southeastern |(?:E|e)astern |N |NE |W |E |S |(?:Western catchment of |lower |)Amazon river-basin (?:in|of) |)Brazil|Burma|(?:lower |whole |)Amazon river-basin|southern California|Ceylon|(?:southern |)Chile|(?:S |)China|(?:Pacific coast of |(?:E|e)astern |NE |SE |(?:extreme |)S |)Colombia|(?:north of |)Costa Rica|Cuba|Cuyuni-Mazaruni Region|Dominican Republic|(?:Amazonian (?:lowlands of |)|eastern |)Ecuador|Gran Sabana|Guatemala|Guinea Bissau|Guinea|Guyana-Venezuela border|(?:central and coastal |)French Guiana|(?:SW |)Guianas|Venezuelan Guayana|Guayana Highlands|(?:western |S |)Guyana|Hispaniola|Honduras|(?:W |)India|Indomalaysia|Indo-Malayan region|Jamaica|Loreto|Los Llanos|Oso Peninsula|Pacific Islands|Pakaraima Mts\.|(?:East|West) Indies|Madagascar|Malay Peninsula|Malaysia|(?:lowland tropics in |)Malesia|(?:Central |C |northern |(?:S|s)outhern |NW |western |(?:E and |)S |)Mexico|Micronesia|Nepal|Nicaragua|(?:(?:U|u)pper |)Orinoco R\.|Panama|(?:north-eastern|NW) Pará|(?:N |)Paraguay|(?:Amazonian |eastern |northern |extreme N |NE |E |)Peru|Upper Potaro|Rio Branco|Rio Madeira|Río Negro|Senegal|Serra do Sol|Sierra Leone|(?:(?:S|s)outh(?:ern|) |Coastal areas of )Florida|Sri Lanka|Sumatra|(?:N |)Suriname|Tobago|Trinidad|(?:(?:S|s)outhern |southwestern |SW |)United States|Uruguay|(?:northeastern |south(?:ern|) and eastern |southern |)U\.S\.A(?:\.|)|Venezuelan Amazon|(?:Amazonian |Guayana Highlands (?:in|of) |(?:E|e)astern |northern |northern and eastern |(?:Central and |)S |SE |NW |W |Upper Amazonian forests of |Llanos of |)Venezuela)/<distributionLocality class=\"region\">$1<\/distributionLocality>/g;
		
		# Separates the countries from the regions:
		s/(<distributionLocality class=")(region)(">)(Arabia|Argentin(?:a|e)|Bahamas|Bahama Islands|Bangladesh|Bolivia|Brazil|Burma|Ceylon|Colombia|Costa Rica|Ecuador|French Guiana|Guyana|India|Honduras|Madagascar|Malaysia|Mexico|Micronesia|Nicaragua|Panama|Paraguay|Peru|Senegal|Sierra Leone|Sri Lanka|Suriname|U\.S\.A(?:\.|)|Venezuela)(<\/distributionLocality>)/$1country$3$4$5/g;
		
		
		# State:
		s/(Acre|Amap(?:r|)(?:a|á)|Amazonas|Bahia|Bol(?:í|i)var|Ceará|Chiapas|Florida|Lara|Maranhão|Mat(?:t|)o Grosso|Minas Gerais|Oaxaca|Parana|Pa(?:r|)rá|Pernambuco|Portuguesa|Rio Grande do Sul|Rondônia|(?:Terr. |)Roraima|Santa Catarina|Tocantins|Tráchira|Veracruz)/<distributionLocality class=\"state\">$1<\/distributionLocality>/g;
		
		
		# Territory:
		s/(Puerto Rico)/<distributionLocality class=\"territory\">$1<\/distributionLocality>/g;
		
		
		# Provinces:
		s/(Annobon|Cabinda|Cuanza|Estuaire|Galápagos|Jujuy|Kasaï|Lunda)/<distributionLocality class=\"province\">$1<\/distributionLocality>/g;
		
		
		# Localities:
		s/(Benin|Bertoua|Bipindi|Brazzaville|Calabar|Campo|Conakry|Douala|Ebolowa|Franceville|Gold-Coast|Golungo Alto|Kinshasa|Kribi|Lastoursville|Libreville|Mayumba|Moanda|Mouila|Moloundou|Ndikiniméki|(?:chutes de l'|moyen )Ogooué|Pointe-Noire|Port-Gentil|San-Thomé|Sapoba|Sibiti|Stanleyville|Yaoundé|Yangambi|Yokadouma)/<distributionLocality class=\"locality\">$1<\/distributionLocality>/g;
		
		
		# Other:
		s/(Nyassaland|lacs du Bas-Ogooué)/<distributionLocality class=\"other\">$1<\/distributionLocality>/g;
		
		
		# Removes tags when a region or province is based on a city name:
		s/(<distributionLocality class="region">[[:upper:][:lower:] ]+)(<distributionLocality class="state">)(Florida|California)(<\/distributionLocality>)/$1$3/g;
		
		
		# Marks up doubtful localities:
		s/(<distributionLocality class=".+?")(>[[:upper:][:lower:] ]+)(<\/distributionLocality>)(\?)/$1 doubtful="true"$2$4$3/g;
		
		
		# puts back newline removed with previous script:
		s/(^)(\t\t\t<feature class="distribution">)/$1$2\n/;
		
	}
	
	
	# Habitat atomisation (needs improvement):
	elsif (/\t\t\t\t<string><subHeading>Habitat:<\/subHeading>/) {
		
		# Habitat tags:
		s/(\t\t\t\t<string><subHeading>Habitat:<\/subHeading> )(.+?)(<\/string>)/$1<habitat>$2<\/habitat>$3/;
		
		# Altitudes:
		# single altitude + certain ranges:
		s/((?:|from sea level (?:up |)to |up to |above |\d )\d+ m(?!m))/<altitude>$1<\/altitude>/g;
		
		# more ranges:
		s/(above |between |from (?:near |)sea level to (?:over |)|up to |(?:|\d |between )\d+(?:-| (?:up |)to | and ))(<altitude>)/$2$1/g;
		
		# estimations:
		s/((?:±|ca\.) )(<altitude)(>)/$2 estimate="true"$3$1/g;
		
	}
	
	
	# Phenology:
	elsif (/\t\t\t\t<string><subHeading>Phenology:<\/subHeading>/) {
		
		
		# Both:
		# Months:
		s/(Collected in flower and fruit (?:from|in) |Flowering and fruiting in |Flowering and fruiting )([[:upper:][:lower:] &,\.-]+)(\.)/$1<lifeCyclePeriods class="both"><dates><fullDate>$2<\/fullDate><\/dates><\/lifeCyclePeriods>$3/;
		# Throughout the year:
		s/(Collected in flower and fruit (?:from|in) |(?:Apparently f|F)lowering and fruiting |; probably flowering and fruiting )(most months of the year|throughout (?:most of |)(?:the |)year)(\.)/$1<lifeCyclePeriods class="both"><dates><fullDate>$2<\/fullDate><\/dates><\/lifeCyclePeriods>$3/;
		
		
		# Flowering periods:
		# Months:
		s/(Collected in flower in |Collected in flower |Flowering (?:mainly |)in |Flowering from |Flowering |Flowers reported )([[:upper:][:lower:] &,\.-]+?)(\.|;|, (?:and |)in fruit|, and fruiting in )/$1<lifeCyclePeriods class="flowering"><dates><fullDate>$2<\/fullDate><\/dates><\/lifeCyclePeriods>$3/;
		# Throughout the year:
		s/(Collected in flower |Flowering )(throughout the year)(\.|;)/$1<lifeCyclePeriods class="flowering"><dates><fullDate>$2<\/fullDate><\/dates><\/lifeCyclePeriods>$3/;
		
		# Fruiting periods:
		# Months:
		s/(Collected in fruit in |, (?:and |)in fruit in |, in fruit |, and fruiting in |; in fruit in |; in fruit |; (?:probably |)fruiting in |; fruiting |Fruiting |fruits reported )([[:upper:][:lower:] &,\.-]+)(\.)/$1<lifeCyclePeriods class="fruiting"><dates><fullDate>$2<\/fullDate><\/dates><\/lifeCyclePeriods>$3/;
		# Throughout the year:
		s/(, (?:and |)in fruit in |; fruiting )(throughout the year)(\.)/$1<lifeCyclePeriods class="fruiting"><dates><fullDate>$2<\/fullDate><\/dates><\/lifeCyclePeriods>$3/;
		
		
	}
	
	
	# Vernacular names:
	elsif (/\t\t\t\t<string><subHeading>Vernacular name(?:s|):<\/subHeading>/) {
		
		# Adds opening tags <vernacularNames>:
		s/(<\/subHeading>)(?: |)/$1<vernacularNames>\n\t\t\t\t\t<vernacularName>/g;
		# Adds closing tags </vernacularNames>:
		s/((?:\.|;|,)(?:<\/string>|<br \/>))/<\/vernacularName>\n\t\t\t\t<\/vernacularNames>$1/g;
		
		# Inserts first subHeading:
		s/(<vernacularName>)((?:French Guiana|Guyana|Suriname):)( )/<subHeading>$2<\/subHeading>\n\t\t\t\t\t$1/;
		# Inserts other subHeadings (if required):
		s/(\. )((?:French Guiana|Guyana|Suriname):)( )/<\/vernacularName>\n\t\t\t\t\t<subHeading>$2<\/subHeading>\n\t\t\t\t\t<vernacularName>/g;
		
		# Separates vernacular names (needs work):
		s/(; )/<\/vernacularName>\n\t\t\t\t\t<vernacularName>/g;
		
		# Adds tags to local languages:
		s/(\()(Akawaio|Macushi Amerindian|Ar(?:a|o)w(?:ak|\.)|Boni|Car(?:ib(?:\.|)|\.)|Cr(?:e|é)ole|(?:Suriname |)Dutch|English|Galibi|Portuguese Guyanese|Hindi|Javan(?:ese|)|Karib|Malay|Mawayan|Ndjuka|Oyampi|Palikur|Saramacca(?:n|)|Sar\.|Sranan(?:g|)|Taki-taki|Tirio|Wai Wai|Warrau|(?:translation of |)Waya(?:m|)pi|Way(?:â|ã)pi|Wayana)(\)|,)/$1<localLanguage>$2<\/localLanguage>$3/g;
		# Adds tags to local languages when followed by a collector name + number (also fixes wrong split):
		s/(\()(Akawaio|Macushi Amerindian|Ar(?:a|o)w(?:ak|\.)|Boni|Car(?:ib(?:\.|)|\.)|Cr(?:e|é)ole|(?:Suriname |)Dutch|English|Galibi|Portuguese Guyanese|Hindi|Javan(?:ese|)|Karib|Malay|Mawayan|Ndjuka|Oyampi|Palikur|Saramacca(?:n|)|Sar\.|Sranan(?:g|)|Taki-taki|Tirio|Wai Wai|Warrau|Waya(?:m|)pi|(?:translation of |)Way(?:â|ã)pi|Wayana)(<\/vernacularName>\n\t\t\t\t\t<vernacularName>)/$1<localLanguage>$2<\/localLanguage>; /g;
		
		# For doubtful languages:
		s/(<localLanguage)(>.+?)(<\/localLanguage>)((?: |)\?)/$1 doubtful="true"$2$4$3/g;
		
		# Add start and end tags to each line with vernacular names (bracket version):
		s/(<vernacularName>)(.+?)( \()/$1<name class="vernacular">$2<\/name>$3/g;
		# Add start and end tags to each line with vernacular names (no bracket version):
		s/(<vernacularName>|\), )([[:lower:], '-]+)(<\/vernacularName>)/$1<name class="vernacular">$2<\/name>$3/g;
		
		# Intermediary tags after curved bracket:
		s/(<vernacularName><name class="vernacular">.+?\))(, )([[:upper:][:lower:] ]+)( \()/$1$2<name class="vernacular">$3<\/name>$4/g;
		# Intermediary tags:
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		# More intermediary tags:
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		s/(<name class="vernacular">[[:lower:] '\/\-]+)(, )/$1<\/name>$2<name class="vernacular">/g;
		
		
		# Puts newline back in place:
		s/(^)(\t\t\t<feature class="vernacular">)/$1$2\n/;
		# Puts newline back in place after <br />:
		s/(<br \/>)/$1\n\t\t\t/;
	
	}
	
	
	print OUT $_; 
}

close IN;
close OUT;