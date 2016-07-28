#!/usr/bin/perl
# atomiseur.plx
# Atomise la nomenclature, les types, les citations, et les descriptions
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

# Make this "atomizer.plx" for all atomization (literature(done), citations(done), nomenclature, types)?


my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Insere les tags de fin de toutes les features:
	# Descriptions:
	# s/(^)(\t\t\t<feature class="description">)(.+)($)/$1$2$3<\/feature>/;
	
	# Autres features:
	# s/(^)(\t\t\t<feature class=".+)(<string>)(.+)($)/$1$2$3$4<\/string><\/feature>/;
	
	# Remove hashes (and this) before above two rules after running script to up first two volumes 1 version number
	
	
	# References/Bibliographie:
	
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
		
		
# Option spéciale:		
		#:</heading> Carter (1960)</reference><reference>Haynes et al. (1998), Symoens & Billiet (1975)
		
	}
	
	
	
	
	# Toutes les lignes qui ne commencent pas avec <, ou ne finissent pas sur <br /> ou </string>, ou ne sont pas le doctype:
	if (/^(?!\t*<)(?![[:upper:]].+\.<br \/>$)(?![[:upper:]].+:<br \/>$)(?![[:upper:]].+<\/td>$)(?![[:upper:]].+<\/li>$)(?![[:upper:]].+<\/string>$)(?![[:upper:]].+<\/feature>$)(?!.+xmlns:xsi)/) {
		
		# Bibliographies longues (vol. 38+):
		s/(^)(BIBLIOGRAPHIE)($)/\t<textSection type="bibliography">\n\t\t<references>\n\t\t\t<heading>$2<\/heading>/;
		
		
		# Volume 5bis:
		# Auteur (Annee). — Titre etc. — Editeurs — Maison d'edition
		s/(^)(- )([[:upper:]]+.+)( \()(\d\d\d\d)(\)\. — )(.+)( — )([[:upper:]].+\(Ed(?:|s)\.\))( — )([[:upper:]].+\.)($)/$1\t\t\t\t\t\t<reference>\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="editors">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$11<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		# Auteur (Annee). — Titre — Journal, Serie, Volume (Partie): Pages
		s/(^)(- )([[:upper:]]+.+)( \()(\d\d\d\d)(\)\. — )(.+)( — )([[:upper:]].+)(, )(s(?:é|e)r\. \d+)(, )(\d+)(\()(\d+)(\): )(\d+-\d+)(\.)($)/$1\t\t\t\t\t\t<reference>\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$11<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$13<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$15<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$17<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		# Auteur (Annee). — Titre — Journal, Serie, Volume: Pages
		s/(^)(- )([[:upper:]]+.+)( \()(\d\d\d\d)(\)\. — )(.+)( — )([[:upper:]].+)(, )(s(?:é|e)r\. \d+)(, )(\d+)(: )(\d+-\d+)(\.)($)/$1\t\t\t\t\t\t<reference>\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$11<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$13<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$15<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		# Auteur (Annee). — Titre — Journal Volume (Partie): Pages
		s/(^)(- )([[:upper:]]+.+)( \()(\d\d\d\d)(\)\. — )(.+)( — )([[:upper:]].+)( )(\d+)(\()(\d+)(\): )(\d+-\d+)(\.)($)/$1\t\t\t\t\t\t<reference>\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$11<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$13<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$15<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		# Auteur (Annee). — Titre — Journal Volume: Pages
		s/(^)(- )([[:upper:]]+.+)( \()(\d\d\d\d)(\)\. — )(.+)( — )([[:upper:]].+)( )(\d+)(: )(\d+-\d+)(\.)($)/$1\t\t\t\t\t\t<reference>\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$11<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$13<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		
		# Auteur (Annee). — Titre, Volume: Pages — Maison d'edition
		s/(^)(- )([[:upper:]]+.+)( \()(\d\d\d\d)(\)\. — )([[:upper:]].+)(, )(vol\. (?:I|II|III|IV|V|VI|VII|VIII|IX|X|\d+)(?:|\.)(?:|(?:|,) .+))(: )(\d+ pp\.)( — )([[:upper:]].+)(\.)($)/$1\t\t\t\t\t\t<reference>\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$11<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$13<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		# Auteur (Annee).  — Titre: Pages — Maison d'edition
		s/(^)(- )([[:upper:]]+.+)( \()(\d\d\d\d)(\)\. — )([[:upper:]].+)(: )((?:\d+ pp|\d+-\d+)\.)( — )([[:upper:]].+)(\.)($)/$1\t\t\t\t\t\t<reference>\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$11<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		
		# Volume 38+:
		
		
		# Auteur Annee. Titre. Editeurs, Journal Volume: Pages. Maison d'edition, Location.
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]))(\. )(.+?)(\. In )([[:upper:]].+\((?:E|e|é)d(?:|s)(?:|\.)\))(, )([[:upper:][:lower:] \.].+)( )(\d+)(: )(\d+-\d+)(\. )([[:upper:][:lower:] ]+)(, )([[:upper:][:lower:]]+)(\.)($)/$1\t\t\t\t\t\t<reference>\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="editors">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$12<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$14<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$16<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publocation">$18<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		# Auteur Annee. Titre. Editeurs, Journal: Pages. Maison d'edition, Location.
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]))(\. )(.+?)(\. In )([[:upper:]].+\((?:E|e|é)d(?:|s)(?:|\.)\))(, )([[:upper:][:lower:] \.].+)(: )(\d+-\d+)(\. )([[:upper:][:lower:] ]+)(, )([[:upper:][:lower:]]+)(\.)($)/$1\t\t\t\t\t\t<reference>\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="editors">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$12<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$14<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publocation">$16<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		
		# Auteur Annee. Titre. Journal Volume(Issue): Pages
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]))(\. )(.+?)(\. )([[:upper:][:lower:] \.].+)( )(\d+)(\()(\d+)(\): )(\d+-\d+)(\.)($)/$1\t\t\t\t\t\t<reference id="">\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$12<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$14<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		# Auteur Annee. Titre. Journal Volume: Pages
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]))(\. )(.+?)(\. )([[:upper:][:lower:] \.].+)( )(\d+)(: )(\d+-\d+)(\.)($)/$1\t\t\t\t\t\t<reference id="">\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$12<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		
		# Auteur Annee. Titre. Journal Volume: Pages. Maison d'edition, Location.
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]))(\. )(.+?)(\. )([[:upper:][:lower:] \.].+)( )(\d+)(: )(\d+-\d+)(\. )([[:upper:][:lower:] ]+)(, )([[:upper:][:lower:]]+)(\.)($)/$1\t\t\t\t\t\t<reference id="">\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$12<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$14<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publocation">$16<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		# Auteur Annee. Titre. Journal: Pages. Maison d'edition, Location.
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]))(\. )(.+?)(\. )([[:upper:][:lower:] \.].+)(: )(\d+-\d+)(\. )([[:upper:][:lower:] ]+)(, )([[:upper:][:lower:]]+)(\.)($)/$1\t\t\t\t\t\t<reference id="">\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubtitle">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$12<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publocation">$14<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		# Auteur Annee. Titre de livre. Maison d'edition, Location.
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]))(\. )([[:upper:][:lower:] \.].+)(\. )([[:upper:][:lower:] -]+)(, )([[:upper:][:lower:]-]+)(\.)($)/$1\t\t\t\t\t\t<reference id="">\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publocation">$10<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		# Auteur Annee. Titre de livre. Maison d'edition.
		s/(^)([[:upper:][:lower:] \.&,-]+)( )(\d\d\d\d(?:|[[:lower:]]))(\. )([[:upper:][:lower:] \.].+)(\. )([[:upper:][:lower:] -]+)(\.)($)/$1\t\t\t\t\t\t<reference id="">\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="publisher">$8<\/refPart>\n\t\t\t\t\t\t<\/reference>/g;
		
		
	
		
	}
	
	
	
	# La nomenclature et les citations sont:
	# Toutes les lignes qui ne commencent pas avec <, ou ne finissent pas sur <br /> ou </string>, ou ne sont pas le doctype:
	if (/^(?!\t*<)(?![[:upper:]].+\.<br \/>$)(?![[:upper:]].+:<br \/>$)(?![[:upper:]].+<br \/>$)(?![[:upper:]].+<\/td>$)(?![[:upper:]].+<\/li>$)(?![[:upper:]].+<\/string>$)(?![[:upper:]].+<\/feature>$)(?!.+xmlns:xsi)/) {
		
		# Citations:
		if (/: | — |l\.c\.|I\.c\.|loc\. cit\.|Monandr\. Pl\.|Bot\. Reg\.|Gén\. Pl\.|F\.T\.A\.| Éd\. |Hook\. (?:|f\. )Ic\. Pl\.|mss\./) {
			# Insere les tag de debut de citation et de fin de citation:
			s/(^)((?:[[:upper:]]|dans |in |cf\.|l\.c\.|I\.c\.|loc\. cit\.|cat\. Talb\. Nig\.|mss\.)(?:.+|))($)/\t\t\t\t\t\t<citation class="publication">$2<\/citation>/;
			
			# Divise plusieurs citations qui se suivent:
			s/(\.)( — )/$1<\/citation>\n\t\t\t\t\t\t<citation class="usage">/g;
			s/(; )/<\/citation>\n\t\t\t\t\t\t<citation class="usage">/g;
			
			
			# Atomisation des citations:
			
			# Elimination de "Dans" pour uniformiser certaines citations:
			# s/(<citation class="(?:usage|publication)">)((?:Dans|dans|In|in) )/$1/g;
			# Elimination de "dans" pour uniformiser certaines citations:
			# s/(<citation class="(?:usage|publication)">)(.+?)( (?:dans|in) )/$1$2, /g;
			
			# 5bis:
			# Fin de citation: (Annee): Pages
			s/(<citation class="(?:usage|publication)">)(.+?)( \()(\d\d\d\d|\d\d\d\d-\d\d\d\d|\d\d\d\d-\d\d)(\): )(\d+-\d+|\d+, \d+|\d+|[IVXCML]+)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			
			# Autres volumes:
			# Fin de citation: Pages (Annee)
			s/(<citation class="(?:usage|publication)">)(.+?)(: )(\d+-\d+|\d+ et \d+|\d+(?:, \d+)+|\d+|[IVXCML]+|\d+ p\.p\.)( \()(\d\d\d\d|\d\d\d\d-\d\d\d\d|\d\d\d\d-\d\d)(\))/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			# Fin de citation: Pages Details (Annee)
			s/(<citation class="(?:usage|publication)">)(.+?)(: )(\d+-\d+|\d+ et \d+|\d+(?:, \d+)+|\d+|[IVXCML]+)( |, )(.+?)( \()(\d\d\d\d|\d\d\d\d-\d\d\d\d|\d\d\d\d-\d\d)(\))/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			
			# Fin de citation: Details (Annee)
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|:) )((?:fig|f|(?:|Obs\. et )(?:T|t)ab|(?:P|p)l|t|op)\. (?:\d+|\d+ et \d+|\d+, (?:fig|f|(?:|Obs\. et )(?:T|t)ab|(?:P|p)l|t|op)\. (?:\d+|\d+-\d+|[[:lower:]])|[XIV]+)(?:|[[:upper:]]))( \()(\d\d\d\d|\d\d\d\d-\d\d\d\d|\d\d\d\d-\d\d)(\))/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			
			# Fin de citation: Pages Details
			s/(<citation class="(?:usage|publication)">)(.+?)(: )(\d+-\d+|\d+, \d+|\d+)( |, )((?:fig|tab|t|Pl)\. \d+|.+?)(<\/citation>)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">$7/g;
			
			# Fin de citation: Pages
			s/(<citation class="(?:usage|publication)">)(.+?)(: )(\d+-\d+|\d+, \d+|\d+)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			# Citation: l.c. (Annee):
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|:) )(\()(\d\d\d\d|\d\d\d\d-\d\d\d\d|\d\d\d\d-\d+)(\))/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">/g;
			
			
			
			
			
			# Debut de citation: Nom de Publication, Serie ser., Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:\de|[IVXCML]+\.) (?:sér|ser)\.|n\. s(?:|ér|er)\. Bot\.|Bot\. S(?:|ér)\.))((?:|,) )((?:t\. |)\d+|[IVXCML]+)((?:|,) )((?:|n° )\d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$8$9/g;
			
			# Debut de citation: Nom de Publication, Serie ser., Volume
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:(?:\de|[IVXCML]+\.) (?:sér|ser|série)\.|n\. s(?:|ér|er)\. Bot\.)|(?:sér|ser|série)\. \d+(?:|[[:upper:]]|[[:lower:]])))((?:|,) )((?:t\. |)\d+|[IVXCML]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6$7/g;
			
			# Debut de citation: Nom de Publication, Volume, série Serie,
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )(\d+)(, )(série \d)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$6$7/g;
			
			
			
			
			# Debut de citation: Nom de Publication, ed. Edition, Volume
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:ed|éd)\.|(?:ed|éd)\. (?:\d+|[IVXCML]+)))(, |,| )(\d+(?:|b)|[IVXCML]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6$7/g;
			
			
			# Debut de citation: Nom de Publication, ed. Edition
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:e|\.) (?:é|e|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4$5/g;
			
			
			# Debut de citation: ed. Edition, Volume
			s/(<citation class="(?:usage|publication)">)((?:\d+ (?:ed|éd)\.|(?:ed|éd)\. (?:\d+|[IVXCML]+)))((?:|,)(?:| ))(\d+|[IVXCML]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="edition">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4$5/g;
			
			
			
			
			
			# Debut de citation: Auteur, Nom de Publication, Serie ser., Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d(?:e|°)|[IVXCML]+(?:\.|e)) (?:(?:(?:s|S)ér|(?:s|S)er|S)\.|(?:S|s)(?:e|é)rie)\.|n\. s(?:|ér|er)\. Bot\.|n\. s(?:|ér|er)\.|Bot\. S\.ser\. B|(?:S|s)(?:é|e)r\. (?:\d+(?:|[[:upper:]]|[[:lower:]])|[IVXCML]+)))((?:|,) )((?:t\. |)\d+|[IVXCML]+)((?:|,) )((?:|n° )\d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$10$11/g;
			
			# Debut de citation: Auteur, Nom de Publication, Serie ser., Volume
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d(?:e|°)|[IVXCML]+(?:\.|e)) (?:(?:(?:s|S)ér|(?:s|S)er|S)\.|(?:S|s)(?:e|é)rie)\.|n\. s(?:|ér|er)\. Bot\.|n\. s(?:|ér|er)\.|Bot\. S\.|ser\. B|(?:S|s)(?:é|e)r\. (?:\d+(?:|[[:upper:]]|[[:lower:]])|[IVXCML]+)))((?:|,) )((?:t\. |)\d+|[IVXCML]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8$9/g;
			
			# Debut de citation: Auteur, Nom de Publication, Serie ser.
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\de|[IVXCML]+\.) (?:sér|ser)\.|n\. s(?:|ér|er)\. Bot\.|Bot\. S\.|(?:sér|ser)\. \d+))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$6$7/g;
			
			# Debut de citation: Auteur, Nom de Publication, Volume, App. appendix
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:t\. |)\d+|[IVXCML]+)((?:,|(?:|,) ))((?:(?:A|a)pp|(?:S|s)uppl)\.(?:| (?:\d+|[IVXCML]+)))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="appendix">$8$9/g;
			
			# Debut de citation: Auteur, Nom de Publication, App. appendix
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:A|a)pp|(?:S|s)uppl)\.(?:| (?:\d+|[IVXCML]+)))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="appendix">$6$7/g;
			
			# Debut de citation: Auteur, Nom de Publication, ed. Edition, Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))((?:|,) )(\d+)((?:,|(?:|,) ))((?:|n° |fasc\. |Mém\. )(?:\d+|[IVXCML]+))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$10$11/g;
			
			# Debut de citation: Auteur, Nom de Publication, Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:t\. |)\d+|[IVXCML]+)((?:,|(?:|,) ))((?:|n° |no |fasc\. |Mém\. )(?:\d+(?:|[[:lower:]])|[IVXCML]+))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$8$9/g;
			
			# Debut de citation: Auteur, Nom de Publication, ed. Edition, Volume
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))(,(?:| ))(\d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8$9/g;
			
			
			# Debut de citation: Auteur, Nom de Publication, ed. Edition, Volume(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))((?:|,) )(\d+)((?:| )\()(\d+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$10$12/g;
			
			# Debut de citation: Auteur, Nom de Publication, ed. Edition(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))((?:| )\()(\d+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$8$10/g;
			
			# Debut de citation: Auteur, Nom de Publication, Volume(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )(\d+|[IVXCML]+)((?:| )\()(\d+|\d+-\d+|[IVXCML]+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$8$10/g;
			
			# Debut de citation: Nom de Publication, ed. Edition, Volume(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))((?:|,) )(\d+)((?:| )\()(\d+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$8$10/g;
			
			# Debut de citation: Nom de Publication, ed. Edition(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:\d+|[IVXCML]+)(?:|e|re) (?:e|é|É|E)d\.|(?:e|é|É|E)d\. (?:\d+|[IVXCML]+)))((?:| )\()(\d+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$6$8/g;
			
			# Debut de citation: Nom de Publication, Volume(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )(\d+)((?:| )\()(\d+(?:| [[:lower:]])|[IVXCML]+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$6$8/g;
			
			
			# Debut de citation: Nom de Publication, Volume, App. appendix
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:t\. |)\d+|[IVXCML]+)((?:,|(?:|,) ))((?:(?:A|a)pp|(?:S|s)uppl)\.(?:| (?:\d+|[IVXCML]+)))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="appendix">$6$7/g;
			
			
			# Debut de citation: Auteur, Nom de Publication vol. Volume
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)( |, )((?:vol\.|n°) \d+|[[:upper:]]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6$7/g;
			
			# Debut de citation: Auteur, Nom de Publication, Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)((?:|,) )(\d+)(, )(\d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$8$9/g;
			
			
			# Debut de citation: Nom de Publication, t. Volume, fasc. Issue
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:t\.|tome|no) \d+)((?:,|(?:|,) ))((?:fasc\.|fascicule) \d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$6$7/g;
			
			
			# Debut de citation: Auteur, Nom de Publication Volume
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)( |, )(\d+(?:|a)|[[:upper:]]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6$7/g;
			
			
			
			
			# Debut de citation: Nom de Publication, Volume, Issue
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:|t\. )(?:\d+|[IVXCML]+))((?:,|(?:|,) ))((?:|n° |fasc\. |Mém\.)\d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$6$7/g;
			
			# Debut de citation: Nom de Publication Edition
			s/(<citation class="(?:usage|publication)">)(.+?)( |, )(Éd\. \d+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4$5/g;
			
			# Debut de citation: Nom de Publication, Volume
			s/(<citation class="(?:usage|publication)">)(.+?)((?:|,) )((?:(?:vol\.|n°|t\.) |)\d+|[IVXCML]+)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4$5/g;
			
			
			
			
			# Debut de citation: Auteur, Nom de Publication
			s/(<citation class="(?:usage|publication)">)(.+?)(, )(.+?)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4$5/g;
			
			
			# Debut de citation: Nom de Publication Volume(Partie)
			s/(<citation class="(?:usage|publication)">)(.+?)( |, )(\d+|[[:upper:]]+)(\()(\d+)(\))(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="part">$6$8/g;
			
			
			
			# Debut de citation: Nom de Publication
			s/(<citation class="(?:usage|publication)">)(.+?)(<\/refPart>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2$3/g;
			
			
			
			# Debut de citation: Auteur, mss.
			s/(<citation class="(?:usage|publication)">)([[:upper:]]+)(, )(mss\..+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t$5/g;
			
			# Debut de citation: mss. etc.
			s/(<citation class="(?:usage|publication)">)(mss\..+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t$3/g;
			
			# Citation: mss.
			s/(<citation class="(?:usage|publication)">)(mss\.)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t$3/g;
			
			
			
			
			# Details:
			s/(<refPart class=")(status)(">)(, |)((?:P(?:l\.|L)|fig\.|tab\.) \d+)(?:|\.)(<\/citation>)/$1details$3$5<\/refPart>\n\t\t\t\t\t\t<\/citation>/g;
			
			
			
			# Auteurs non-reconnus:
			s/(<refPart class="pubname">)(Alston(?:|\.)|Aubr(?:\.|éville)|A\. Chev\.|Chevalier\.|KEAY, Hutch\. et Dal(?:z|)\.|Engl(?:\.|ler) (?:|u\. |und |et )Prantl|Engl\.|Hack\.|Benth\. and Hook\. f\.|Hook\. f\.|Keay|(?:VAILL\. ex |)L\.|Linnaeus|Linn(?:é|É|\.)|LINN\.||Mart(?:\.|ius)|Exell et Mendonça|Louis et Mullenders|OLIV\.|Pellegrin|Rosc\.|Schnell\.|Desf\. ex Steud\.|WILLD\.)((?:|,) )(.+?)(<\/refPart>)/<refPart class="author">$2$5\n\t\t\t\t\t\t\t$1$4$5/g;
			
			# Statuts non-reconnus:
			s/(<refPart class=")(details)(">)((?:|\()(?:p\.p\.|nomen)(?:|\))(?:|\.))(<\/refPart>)/$1status$3$4$5/g;
			s/(<refPart class="status">)(\()(p\.p\.|nomen)(\)(?:|\.))(<\/refPart>)/$1$3$5/g;
			
			# Series non-reconnues:
			s/(, )(sér\. \d+)(<\/refPart>)/$3\n\t\t\t\t\t\t\t<refPart class="series">$2$3/g;
			
			
			
			# Elimination de l'espace juste apres le tag de statut et insertion du tag de fermeture pour le statut:
			s/(<refPart class="status">)((?:|\.|,) )(.+?)(<\/citation>)/$1$3<\/refPart>\n\t\t\t\t\t\t$4/g;
			# Elimination de statuts vides:
			s/\t\t\t\t\t\t\t<refPart class="status">(?:|\.(?:| )|;)<\/citation>/\t\t\t\t\t\t<\/citation>/g;
			s/\t\t\t\t\t\t\t<refPart class="status">(?:|\.(?:| )|;)($)/\t\t\t\t\t\t<\/citation>/g;
			
			# Repare nom., clav.:
			s/(<refPart class=")(details|status)(">nom(?:\.|en))(,)( clav\.<\/refPart>)/$1status$3 in$5/g;
			
			# Editeurs:
			s/(<refPart class=")(pubname)(">)(in )(.+?)(, )(.+?)/$1editors$3$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$7/g;
			s/(<refPart class=")(author)(">)(in )/$1editors$3/g;
			s/(<refPart class="author">)(.+?)( in )(.+?)(<\/refPart>)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="editors">$4$5/g;
			
			
			# Repare noms taxonomiques accidentalement reconnus comme une citation:
			s/(\t\t\t\t\t\t<citation class="publication">)([[:upper:]][[:lower:]]+(?:|\.) (?:|[[:lower:]]+ )auct\. non .+)(<\/citation>)/$2/;
			s/(\t\t\t\t\t\t<citation class="publication">)([[:upper:]]+(?:|\.) (?:|[[:lower:]]+ )auct\. non .+)(<\/citation>)/$2/;
			
			# Repare <refPart class="pubname">AUTEUR, PUBLICATION</refPart>:
			s/(<refPart class=")(pubname)(">.+?)(, )(FWTA|Ann. Mus. Congo, Bot.|Us. Pl. W. Trop. Afr.)(<\/refPart>)/$1author$3$6\n\t\t\t\t\t\t\t$1$2">$5$6/g;
			
			
			
			
		}
		
		
		# Corrections dans les references/citations:
		# abbreviation "n.s.":
		s/(<refPart class=")(pubname)(">n\.(?:| )s\.<\/refPart>)/$1series$3/g;
		
		
		
		# (References aux) Illustrations:
		
		# Enleve les parentheses si necessaire:
		s/(^)(\()(P(?:L|l)\. (?:\d+|[IVXCM]+))((?:|\.)\)(?:|\.))/$3/;
		
		# Reference a une illustration + numero, parties, page
		s/(^)(P(?:L|l)\. )(\d+|[IVXCM]+)(, )(\d+-\d+|\d+, \d+)(, p.+)($)/$1\t\t\t<figureRef ref="ID_">$2<num>$3<\/num><figurePart>$5<\/figurePart><\/figureRef>/;
		
		# Reference a une illustration + numero, parties, page
		s/(^)(P(?:L|l)\. )(\d+|[IVXCM]+)(, )(\d+-\d+|\d+, \d+)(\.)($)/$1\t\t\t<figureRef ref="ID_">$2<num>$3<\/num><figurePart>$5<\/figurePart><\/figureRef>/;
		
		# Reference a une illustration + numero, page
		s/(^)(P(?:L|l)\. )(\d+|[IVXCM]+)(, p.+)($)/$1\t\t\t<figureRef ref="ID_">$2<num>$3<\/num><\/figureRef>/;
		
		# Reference a une illustration + numero (normal ou Romain)
		s/(^)(P(?:L|l)\. )(\d+|[IVXCM]+)(\.|)($)/$1\t\t\t<figureRef ref="ID_">$2<num>$3<\/num><\/figureRef>/;
		
		
		
		# Nomenclature:
		
		# Basionymes:
		s/(^)(\t\t\t\t\t\t)(<citation class="publication">)(Bas\.: )([[:upper:]][[:lower:]]+)( )([[:lower:]]+)( )(.+?)(<\/citation>)/$2<basionym>$4\n\t\t\t\t\t\t\t<name class="genus">$5<\/name>\n\t\t\t\t\t\t\t<name class="species">$7<\/name>\n\t\t\t\t\t\t\t<name class="genus">$9<\/name>\n\t\t\t\t\t\t<\/basionym>/g;
		
		
		
		# Division:
		# Division (exception):
		s/(^)(PTÉRIDOPHYTES)($)/\t\t\t\t\t\t<name class="division">$2<\/name>/;
		
		
		# Ordre:
		# Ordre (exception):
		s/(^)(ORDRE)( )(FILICALES|LYCOPODIALES|MARATTIALES|OPHIOGLOSSALES|PSILOTALES|SCITAMINALES|SÉLAGINELLALES)($)/\t\t\t\t\t\t<name class="rank">$2<\/name>\n\t\t\t\t\t\t<name class="order">$4<\/name>/;
		s/(^)(SCITAMINALES)($)/\t\t\t\t\t\t<name class="order">$2<\/name>/;
		
		
		
		
		# Sous-famille:
		# Famille subfamilyrank Sous-famille Auteur:
		s/(^)([[:upper:]][a-z-]+ace(?:ae|æ))( )((?:sous |sub)fam\.)( )([[:upper:]][a-z-]+e(?:ae|æ))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="infrank">$4<\/name>\n\t\t\t\t\t\t<name class="subfamily">$6<\/name>\n\t\t\t\t\t\t<name class="infraut">$8<\/name>/;
		# SOUS-FAMILLE DES XXX:
		s/(^)(SOUS-FAMILLE DES)( )([[:upper:]]+)($)/\t\t\t\t\t\t<name class="infrank">$2<\/name>\n\t\t\t\t\t\t<name class="subfamily">$4<\/name>/;
		
		
		
		# Famille:
		# Famille (Paraut) Auteur (annee):
		s/(^)([[:upper:]][A-Za-z-]+(?:ACEAE|aceae|BELLIFERAE))( \()([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(\) )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( \()(\d\d\d\d)(\))/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="paraut">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>\n\t\t\t\t\t\t<name class="year">$8<\/name>/;
		# Famille Auteur (annee):
		s/(^)([[:upper:]][A-Za-z-]+(?:ACEAE|aceae|BELLIFERAE))( )((?:[[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)( \()(\d\d\d\d)(\))/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<name class="year">$6<\/name>/;
		# Famille Auteur:
		s/(^)([[:upper:]][a-z-]+aceae)( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="author">$4<\/name>/;
		# Famille (status) Auteur:
		s/(^)([[:upper:]][a-z-]+aceae)( )(\(p\.p\.\))( )(([[:upper:]]|auct\.:|auct:)[[:upper:]\p{Ll}\- &'\.]+)/\t\t\t\t\t\t<name class="family">$2<\/name>\n\t\t\t\t\t\t<name class="status">$4<\/name>\n\t\t\t\t\t\t<name class="author">$6<\/name>/;
		# Famille (sans rien derriere):
		s/(^)([[:upper:]][a-z-]+(?:aceae|ineae))($)/\t\t\t\t\t\t<name class="family">$2<\/name>/;
		# FAMILLE (sans rien derriere):
		s/(^)([[:upper:]]+(?:ACEÆ|ACEAE))($)/\t\t\t\t\t\t<name class="family">$2<\/name>/;
		
		# Famille (exception):
		s/(^)(AIZOAC|AMARANTHAC|BALANITAC|CANNAC|CARYOPHYLLAC|CHÉNOPODIAC|GRAMIN|LAURAC|MARANTAC|MONIMIAC|MUSAC|MYRISTICAC|MYRTAC|NYCTAGINAC|PHYTOLACCAC|POLYGONAC|PORTULACAC|RUTAC|STRÉLITZIAC|THYMÉLÉAC|ZINGIBÉRAC|ZYGOPHYLLAC)(ÉES)($)/\t\t\t\t\t\t<name class="family">$2EAE<\/name>/;
		
		
		
		
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
		
		
		# Repare certaines varietes improprement atomisees:
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
			
			
			# Accepted names:
			
			# Tags de base:
			# Entre parentheses:
			s/( \()(= .+)(\)(?:|\.))/\n\t\t\t\t\t\t<acceptedName>$2<\/acceptedName>/;
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
			s/(GENRE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)(, )(.+?)($|\.$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t\t<typeNotes>\n\t\t\t\t\t\t\t<string>$6<\/string>\n\t\t\t\t\t\t\<\/typeNotes>\n\t\t\t\t\t<\/nameType>/;
			
			# Format: Type genus: Genus Author
			s/(GENRE-TYPE: )([[:upper:]][a-z-]+|[[:upper:]](?:|[[:lower:]]+)\.)( )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+)($|\.$)/\n\t\t\t\t\t\t<nom class="nametype">$1\n\t\t\t\t\t\t\t<name class="genus">$2<\/name>\n\t\t\t\t\t\t\t<name class="author">$4<\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>/;
			
			
			
			
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
		s/(<nameType>(?!\n\t\t\t\t\t\t<nom class="nametype">))(.+)/$1\n\t\t\t\t\t\t<nom class="nametype">\n\t\t\t\t\t\t\t<name class="genus"><\/name>\n\t\t\t\t\t\t\t<name class="species"><\/name>\n\t\t\t\t\t\t\t<name class="author"><\/name>\n\t\t\t\t\t\t<\/nom>\n\t\t\t\t\t<\/nameType>$2/;
		
		# Change l'attribut "class" des genus abbrevies:
		s/(<name class=")(genus)(">[[:upper:]]\.<\/name>)/$1genus abbreviation$3/g;
	
	
	}
	
	# SpecimenTypes:
	elsif (/\t+<specimenType/) {
		
		if (/Type:|Type de l'espèce:|Type de la variété|Typ\.:|LECTOTYPE|NÉOTYPE|NEOTYPE|SYNTYPE|TYPE/) {
		
			
			
			# Format: Type: Collector FieldNum, Locality (CollectionAndType).:
			s/(Type(?:| de l'espèce| de la variété): |Typ\.: |HOLOTYPE(?:|:|\*:|S\*:) |LECTOTYPE(?:|:|\*:|S\*:) |N(?:É|E)OTYPE(?:|:|\*:|S\*:) |SYNTYPES(?:|:) |TYPE(?:|:|S:|\*:|S\*:) )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+?)((?:|,|:) )((?:|n° )(?:\d+|s\.n\.|sans numéro|\d+[[:upper:]]|[[:upper:]]\d+))((?:|,|\.) )(.+?)( )(\([A-Za-z !-;]+\))(\.)($)/<gathering>$1<collector>$2<\/collector><fieldNum>$4<\/fieldNum><locality class="locality">$6<\/locality><collectionAndType>$8<\/collectionAndType><\/gathering>$9<\/specimenType>/;
			
			# Format: Type: Collector FieldNum, (CollectionAndType), Locality.:
			s/(Type(?:| de l'espèce| de la variété): |Typ\.: |HOLOTYPE(?:|:|\*:|S\*:) |LECTOTYPE(?:|:|\*:|S\*:) |N(?:É|E)OTYPE(?:|:|\*:|S\*:) |SYNTYPES(?:|:) |TYPE(?:|:|S:|\*:|S\*:) )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+?)((?:|,|:) )((?:|n° )(?:\d+|s\.n\.|sans numéro|\d+[[:upper:]]|[[:upper:]]\d+))((?:|,) )(\([A-Za-z !-;]+\))((?:|,|\.) )(.+)(\.)($)/<gathering>$1<collector>$2<\/collector><fieldNum>$4<\/fieldNum><collectionAndType>$6<\/collectionAndType><locality class="locality">$8<\/locality><\/gathering>$9<\/specimenType>/;
			
			# Format: Type: Collector FieldNum (CollectionAndType).:
			s/(Type(?:| de l'espèce| de la variété): |Typ\.: |HOLOTYPE(?:|:|\*:|S\*:) |LECTOTYPE(?:|:|\*:|S\*:) |N(?:É|E)OTYPE(?:|:|\*:|S\*:) |SYNTYPES(?:|:) |TYPE(?:|:|S:|\*:|S\*:) )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+?)((?:|,) )((?:|n° )(?:\d+|s\.n\.|sans numéro|\d+[[:upper:]]|[[:upper:]]\d+))( )(\([A-Za-z !-;]+\))(\.)($)/<gathering>$1<collector>$2<\/collector><fieldNum>$4<\/fieldNum><collectionAndType>$6<\/collectionAndType><\/gathering>$7<\/specimenType>/;
			
			# Format: Type: Collector FieldNum, Locality.:
			s/(Type(?:| de l'espèce| de la variété): |Typ\.: |HOLOTYPE(?:|:|\*:|S\*:) |LECTOTYPE(?:|:|\*:|S\*:) |N(?:É|E)OTYPE(?:|:|\*:|S\*:) |SYNTYPES(?:|:) |TYPE(?:|:|S:|\*:|S\*:) )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+?)((?:|,) )((?:|n° )(?:\d+|s\.n\.|sans numéro|\d+[[:upper:]]|[[:upper:]]\d+))((?:\.|,) )(.+)(\.|)($)/<gathering>$1<collector>$2<\/collector><fieldNum>$4<\/fieldNum><locality class="locality">$6<\/locality><\/gathering>$7<\/specimenType>/;
			
			
			# Format: Type: Collector Locality, Fieldnum (CollectionAndType).:
			s/(Type(?:| de l'espèce| de la variété): |Typ\.: |HOLOTYPE(?:|:|\*:|S\*:) |LECTOTYPE(?:|:|\*:|S\*:) |N(?:É|E)OTYPE(?:|:|\*:|S\*:) |SYNTYPES(?:|:) |TYPE(?:|:|S:|\*:|S\*:) )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+?)((?:,|:|) )(.+?)((?:|,|\.) )((?:|n° )(?:\d+|s\.n\.|sans numéro|\d+[[:upper:]]|[[:upper:]]\d+))( )(\([A-Za-z !-;]+\))(\.)($)/<gathering>$1<collector>$2<\/collector><locality class="locality">$4<\/locality><fieldNum>$6<\/fieldNum><collectionAndType>$8<\/collectionAndType><\/gathering>$9<\/specimenType>/;
			
			# Format: Type: Collector Locality (CollectionAndType).:
			s/(Type(?:| de l'espèce| de la variété): |Typ\.: |HOLOTYPE(?:|:|\*:|S\*:) |LECTOTYPE(?:|:|\*:|S\*:) |N(?:É|E)OTYPE(?:|:|\*:|S\*:) |SYNTYPES(?:|:) |TYPE(?:|:|S:|\*:|S\*:) )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+?)((?:,|:|) )(.+?)( )(\([A-Za-z !-;]+\))(\.)($)/<gathering>$1<collector>$2<\/collector><locality class="locality">$4<\/locality><collectionAndType>$6<\/collectionAndType><\/gathering>$7<\/specimenType>/;
			
			# Format: Collector Fieldnum.:
			s/(Type(?:| de l'espèce| de la variété): |Typ\.: |HOLOTYPE(?:|:|\*:|S\*:) |LECTOTYPE(?:|:|\*:|S\*:) |N(?:É|E)OTYPE(?:|:|\*:|S\*:) |SYNTYPES(?:|:) |TYPE(?:|:|S:|\*:|S\*:) )([[:upper:]][[:upper:]\p{Ll}\- &'\.]+?)((?:|,) )((?:|n° )(?:\d+|s\.n\.|sans numéro|\d+[[:upper:]]|[[:upper:]]\d+))(\.)($)/<gathering>$1<collector>$2<\/collector><fieldNum>$4<\/fieldNum><\/gathering>$5<\/specimenType>/;
			
			
		
			
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
		s/(<specimenType>(?:T|Synt)ypes(?:|:) )(.+)/$1<gathering><collector><\/collector><fieldNum><\/fieldNum><locality class="locality"><\/locality><collectionAndType><\/collectionAndType><\/gathering><gathering><collector><\/collector><fieldNum><\/fieldNum><locality class="locality"><\/locality><collectionAndType><\/collectionAndType><\/gathering>$2<\/specimenType>/;
		# Indication de syntypes:
		s/(<specimenType)(>Syntypes )/$1 typeStatus="syntype"$2/;
		
		# Un Type:
		s/(<specimenType(?:| typeStatus="(?:holo|lecto|syn)type"| lang="la"| typeStatus="holotype" lang="la")>(?!<gathering>))(.+)/$1<gathering><collector><\/collector><fieldNum><\/fieldNum><locality class="locality"><\/locality><collectionAndType><\/collectionAndType><\/gathering>$2<\/specimenType>/;
		
		
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
	
	
	
	# Atomisation des Descriptions:
	elsif (/\t\t\t<feature class="description"|\t\t\t<feature class="description" lang="la">>/) {
		# Insere le premier et le dernier tag pour charactere:
		s/(^)(\t\t\t<feature class="description">|\t\t\t<feature class="description" lang="la">)(.+)(<\/feature>$)/$1$2\n\t\t\t\t<char class="">$3<\/char>\n\t\t\t$4/;
		# Insere les autres tags pour characteres:
		s/(\. |\.<br \/>)([[:upper:]]|\d+-\d+ [[:lower:]])/$1<\/subChar><\/char>\n\t\t\t\t<char class="">$2/g;
		s/(: |; )/$1<\/subChar>\n\t\t\t\t\t<subChar class="">/g;
		
		# Enleve les tags <subChar> en trop:
		s/(<char class="">.+?)(<\/subChar>)/$1/g;
		# Insere les tags </subChar> manquant:
		# A faire
		# Place le tag </char> sur une ligne separee quand il est precede par un tag </subChar>:
		s/(<\/subChar>)(<\/char>)/$1\n\t\t\t\t$2/g;
		
		
		# Trouve des characteres specifiques, insere la categorie correspondante:
		s/(<(?:subC|c)har class=")(">)((?:|l')acumen)/$1acumen$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)ppareil aérien)/$1aerial parts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L'a|A|(?:|un )a)kène(?:|s)|(?:A|a)chaine(?:|s))/$1akenes$2$3/;
		s/(<(?:subC|c)har class=")(">)(ces fourmis)/$1ants$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)réole(?:|s) costale(?:|s))/$1costal areoles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)réole(?:|s) secondaires(?:|s))/$1secondary areoles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L'a|a|A|une a|\d+-\d+ rangées d'a)réole(?:|s))/$1areoles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L'al'a||A|a)ndrocée(?:|s) rudimentaire(?:|s))/$1rudimentary androecium$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L'al'a||A|a)ndrocée(?:|s))/$1androecium$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g)ynandrophore)/$1gynandrophore$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)ndrophore)/$1androphore$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)ndrogynophore)/$1androgynophore$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)nneau du sporange)/$1annulus$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:grandes a|Grandes a|petites a|Petites a|a|A|l'a|\d+ a|Les a)nth(?:è|é|e)r(?:|e)(?:|s))/$1anthers$2$3/;
		s/(<(?:subC|c)har class=")(">)(Extrémité de la fronde)/$1frond apex$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Extrémité|sommet) du limbe)/$1lamina apex$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Extrémité|sommet) de l'ovaire)/$1ovary apex$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Extrémité|sommet) de la penne)/$1pinnae apex$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:|l')(?:A|a)nthocarpe)/$1anthocarp$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)pex|extrémité|(?:S|s|Le s)ommet)/$1apex$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a|Pas d'a)rille)/$1aril$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)rticle(?:|s) du rachis)/$1rachis articles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a|\d+ à \d+ a)rticles)/$1articles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a|les a)uricules)/$1auricules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:ces a|a|A)xe(?:|s) epicotylé(?:|s))/$1epicotyle axes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:ces a|a|A)xe(?:|s) pubérulent(?:|s))/$1hairy axes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:ces a|a|A)xe(?:|s) hypocotylé(?:|s))/$1hypocotyle axes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)xe(?:|s) de l'inflorescence(?:|s))/$1inflorescence axes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:ces a|a|A)xe(?:|s) principa(?:l|ux))/$1main axes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:ces a|a|A)xes secondaires)/$1secondary axes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:ces a|a|A)xes tertiaires)/$1tertiary axes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)xe(?:|s))/$1axes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:T|t)ranche|(?:S|s)ection(?:| oblique)) de l'écorce(?:|s))/$1bark section$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Les é|L'é|e|E|é|É|Ê)corce des rameaux)/$1shoot bark$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Les é|L'é|e|E|é|É|Ê|Vieille é)corce(?:|s))/$1bark$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ase du limbe)/$1lamina base$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ases des racèmes)/$1raceme base$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ase des (?:tiges|chaumes))/$1stem base$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ase du tronc)/$1trunk base$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ase)/$1base$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)aie)/$1berries$2$3/;
		s/(<(?:subC|c)har class=")(">)(Dernières bifurcation(?:|s))/$1final bifurcations$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b|la b)ifurcation(?:|s))/$1bifurcations$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Les b|Grandes b|B|b|\d+ b)ractéole(?:|s)|préfeuilles \(bractéoles\))/$1bracteoles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:b|Petites b|B)ractée(?:|s) abaxiale(?:|s))/$1abaxial bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:b|Petites b|B)ractée(?:|s) adaxiale(?:|s))/$1adaxial bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:b|Petites b|B)ractée(?:|s) extérieure(?:|s))/$1outer bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:b|Petites b|B)ractée(?:|s) interne(?:|s))/$1inner bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nvolucres)/$1involucral bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:b|Petites b|B)ractée(?:|s) fertile(?:|s))/$1fertile bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:b|Petites b|B)ractée(?:|s) inférieure(?:|s))/$1lower bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:b|Petites b|B)ractée(?:|s) stérile(?:|s))/$1sterile bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:b|Petites b|B)ractée(?:|s) supérieure(?:|s))/$1upper bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g)randes bractée(?:|s))/$1large bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p|Les p)etites bractée(?:|s))/$1small bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:b|Petites b|B|\d+ b|Les b|Nombreuses b|)ractée(?:|s)|(?:P|p)réfeuilles)/$1bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:b|de petites b|Petites b|B|Une b)ractée(?:|s))/$1bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ranches latérales)/$1lateral branches$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ranches secondaires)/$1secondary branches$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:B|b)ranches|(?:R|r)amifications) tertiaires)/$1tertiary branches$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ranches)/$1branches$2$3/;
		s/(<(?:subC|c)har class=")(">)(Contour de l'ensemble des ramifications latérales)/$1lateral branching outline$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)amifications latérales)/$1lateral branching$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)amifications ultimes)/$1ultimate branching$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)amifications)/$1branching$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)oies)/$1bristles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ourgeon terminal)/$1apical buds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)outon(?: floral|s floraux))/$1flower buds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:J|j)eune(?:|s) bouton(?:|s))/$1juvenile buds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ourgeons et jeunes rameaux)/$1buds and juvenile shoots$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b|Absence de b|Présence d(?:e|'un) b|Large b)ourgeon(?:|s)|(?:B|b|les b|Petit(?:|s) b)outon(?:|s))/$1buds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:B|b)ulbe(?:|s))/$1bulbs$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c|Petits c)ontreforts)/$1plank buttresses$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Le c|c|C)allus)/$1callus$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:H|h)ypantho-calice(?:|s))/$1hypantho-calyx$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Le c|C|c|Les c|Court c)alice(?:|s))/$1calyx$2$3/;
		s/(<(?:subC|c)har class=")(">)(cambium)/$1cambium$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:La c|c|C)apsule avortée(?:|s))/$1aborted capsules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:La c|c|C|rarement c)apsule)/$1capsules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:la c|c|C|Aucun c)arène)/$1carina$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c|Des c)arpellodes)/$1carpellodes$2$3/;
		s/(<(?:subC|c)har class=")(">)(Jeunes carpelles)/$1juvenile carpels$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:le(?:|s) c|Les c|Chaque c|C|c)arpelle(?:|s)|(?:|\d-)\d+ carpelle(?:|s))/$1carpels$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:c|C)arpophore)/$1carpophores$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:la c|c|C)aroncule|(?:S|s)trophiole)/$1caruncle$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:c|C)aryopse)/$1caryopsis$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)es c|c|C)ataphylles)/$1cataphylls$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:c|C)audicule(?:|s))/$1caudicules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:c|C)auliflorie)/$1cauliflory$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ellules épidermiques)/$1epidermal cells$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ellules hypodermiques)/$1hypodermal cells$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:N|n|Les n)ombre(?:|s) chromosomique(?:|s))/$1chromosomes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:O|o)nglet(?:|s))/$1claws$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)linandrium)/$1clinandrium$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)a c|c|C)ollerette)/$1collars$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)a c|c|C)olumelle)/$1columella$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c|(?:L|l)a c)ouleur|(?:c|C|La c)oloration|(?:T|t)einte)/$1colour$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)a c|c|C)olonne|(?:G|g)ynost(?:e|è)me)/$1column$2$3/;
		s/(<(?:subC|c)har class=")(">)(Pied de la colonne)/$1column foot$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)(?:e|é)doconnectif)/$1pedoconnective$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:le c|c|C)onnectif)/$1connective$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)rognon(?:|s))/$1cores$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:La c|c|C|(?:P|p)etite c)orolle)/$1corolla$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:c|C)orme(?:|s))/$1corms$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:c|C)osta)/$1costae$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:c|C)ostulae)/$1costules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c|gros c|\d+ c|les c)otylédons)/$1cotyledons$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:c|C)rête(?:|s))/$1cristates$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)remière couronne)/$1first crown$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:D|d)euxième couronne)/$1second crown$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)roisième couronne)/$1third crown$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ouronne|(?:C|c|La c|Large c|petite c)ime|(?:H|h)ouppier)/$1crown$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)upule)/$1cupule$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ycle staminodial externe)/$1inner staminodial cycle$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ycle externe)/$1outer cycle$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ycle interne)/$1inner cycle$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c|le c)ylindre central)/$1central cylinder$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c|Deux c)ymes)/$1cymes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c|Les c|\d c)ymules)/$1cymules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:D|d|La d)éhiscen(?:t|ce))/$1dehiscence$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:D|d)épression sommitale)/$1apical depression$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:D|d)imensions|taille)/$1dimensions$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:D|d|Le d)isque)/$1disk$2$3/;
		s/(<(?:subC|c)har class=")(">)(Etages de frondes)/$1frond distance$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:D|d)ivisions du périanthe)/$1perianth divisions$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:D|d)ivisions)/$1divisions$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:D|d|(?:L|l|D|d)es d|(?:P|p)etites d)omaties)/$1domatia$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Ces d|Les d|D|d)rupe(?:|s))/$1drupes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:e|E)ctexine)/$1ectexine$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:e|E)mbryon)/$1embryo$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e)ndocarpe)/$1endocarp$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e|l'e)ndosperme)/$1endosperm$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e)nveloppe)/$1envelope$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|É|e|é)quateur)/$1equator$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|É|e|é)picarpe)/$1epicarp$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e|é)pichile)/$1epichile$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e|é)piderme)/$1epidermis$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e)uphylles)/$1euphylls$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:e|E|avec une e)xine)/$1exine$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e)xocarpe)/$1exocarp$2$3/;
		s/(<(?:subC|c)har class=")(">)(Jeunes extrémités)/$1juvenile extremities$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e)xtrémités)/$1extremities$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e|l'e)xsud(?:â|a)t)/$1exudates$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ibres)/$1fibres$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)igues)/$1figs$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f|Le f|(?:\d+-|)\d+ f)ilet(?:|s)|(?:F|f)ilament(?:|s))/$1filaments$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)hair(?:|e))/$1flesh$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)leur(?:|s) axillaire(?:|s))/$1axillary flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)leur(?:|s) basale(?:|s))/$1basal flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)leur(?:|s) centrale(?:|s))/$1central flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)leur(?:|s) solitaire(?:|s))/$1flower arrangement$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)leur(?:|s) à galle(?:|s))/$1gall-bearing flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)leur(?:|s) hermaphrodite(?:|s)|(?:Les f|F|f)leurs ☿|Plantes à fleurs hermaphrodites)/$1hermaphrodite flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f|les f|(?:D|d)ans les f)leur(?:|s) (?:♀|femelle(?:|s))|(?:La f|F|f)leur(?:|s) (?:femelle|pistillée)(?:|s))/$1female flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)leur(?:|s) inférieure(?:|s))/$1lower flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f|(?:D|d)ans les f)leur(?:|s) ♂|(?:F|f|(?:L|l)es f)leur(?:|s) m(?:â|a)le(?:|s)|Dans les fleurs mâles|(?:La f|F|f)leur(?:|s) (?:mâle|staminée)(?:|s))/$1male flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)leurs à graine(?:|s))/$1seed-bearing flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f|Les f)leur(?:|s) stérile(?:|s))/$1sterile flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)leur(?:|s) supérieure(?:|s))/$1upper flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nflorescence(?:|s) (?:femelles|♀))/$1female inflorescences$2$3/;
		s/(<(?:subC|c)har class=")(">)(jeunes inflorescence(?:|s))/$1juvenile inflorescences$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nflorescence(?:|s) (?:m(?:â|a)les|♂))/$1male inflorescences$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nflorescence(?:|s) élémentaire(?:|s))/$1elementary inflorescences$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nflorescence(?:|s) paniculée(?:|s))/$1paniculated inflorescences$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nflorescence(?:|s) secondaire(?:|s))/$1secondary inflorescences$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)leurs fasciculées|(?:F|f)ascicules|Glomérules|(?:(?:L|l|S)es i|I|i|L'i|Grande(?:|s) i|Petite(?:|s) i)nflorescence(?:|s))/$1inflorescences$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)es f|F|f|la f|(?:P|p|nombreuses p)etites f|(?:Deux|Trois) f)leur(?:|s)|De \d+ à \d+ f)/$1flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)lis latéraux)/$1lateral folds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:f|F)euillage)/$1foliage$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:f|F|la f)oliole(?:|s) abaxiale(?:|s))/$1abaxial folioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:f|F|la f)oliole(?:|s) adaxiale(?:|s))/$1adaxial folioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:f|F|la f)oliole(?:|s) basale(?:|s))/$1basal folioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:f|F|la f)oliole(?:|s) centrale(?:|s))/$1central folioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:f|F|la f)oliole(?:|s) inférieure(?:|s))/$1lower folioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:f|F|la f)oliole(?:|s) latérale(?:|s))/$1lateral folioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:f|F|la f)oliole(?:|s) principale(?:|s))/$1main folioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:f|F|la f)oliole(?:|s) médiane(?:|s))/$1main folioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:f|F|la f)oliole(?:|s) supérieure(?:|s))/$1upper folioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:f|F|la f)oliole(?:|s) terminale(?:|s))/$1terminal folioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)es f|La f|F|f|\d+-\d+ f|\d+-\d+ paires de f)oliole(?:|s))/$1folioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)oramen(?:|s))/$1foramens$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ronde(?:|s) assimilatrice(?:|s))/$1assimilating fronds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)(?:euille|ronde)(?:|s) collectrice(?:|s) d'humus)/$1humus collecting fronds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ronde(?:|s) fertile(?:|s))/$1fertile fronds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ronde(?:|s) jeune(?:|s))/$1juvenile fronds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ronde(?:|s) adulte(?:|s))/$1mature fronds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ronde(?:|s) végétative(?:|s))/$1vegetative fronds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ronde(?:|s))/$1fronds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)aux fruit(?:|s))/$1false fruits$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ruits à galle(?:|s))/$1gall-bearing fruits$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:J|j)eune(?:|s) fruit(?:|s)|(?:F|f)ruit(?:|s) juv(?:e|é)nile(?:|s))/$1juvenile fruits$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ruit(?:|s) mûr(?:|s))/$1mature fruits$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)es f|(?:L|l)e f|F|f|Gr(?:and(?:|s)|os) f|Petit(?:|s) f)ruit(?:|s))/$1fruits$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)unicule(?:|s))/$1funicles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)illon(?:|s))/$1furrows$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:g|G)amétophyte(?:|s))/$1gametophytes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:g|G)ermination)/$1germination$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:\d+|\d+-\d+) g|g|G|Les g|(?:U|u)ne g|(?:nombreuses|quelques|de très|très) (?:petites |)g|(?:P|p)as de g)lande(?:|s))/$1glands$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:g|G|une g|chaque g|les g)lomérule(?:|s) de fleurs ♂)/$1male flower glomerules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:g|G|une g|chaque g|les g)lomérule(?:|s) inférieure(?:|s))/$1lower glomerules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:g|G|une g|chaque g|les g)lomérule(?:|s))/$1glomerules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|(?:L|l)a g|Deux g)lumellule(?:|s))/$1glumellules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:H|h)ile)/$1hilum$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l|Appareil végétatif montrant des fils de l)atex)/$1latex$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|(?:L|l)a g)lumelle de la fleur inférieure)/$1lower flower lemma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|(?:L|l)a g)lumelles de la fleur supérieure)/$1upper flower lemma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|(?:L|l)a g)lumelle(?:|s) inférieure(?:|s))/$1lower lemma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|(?:L|l)a g)lumelle(?:|s) supérieure(?:|s))/$1upper lemma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|(?:L|l)a g)lumelle(?:|s) fertile(?:|s))/$1fertile lemma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|(?:L|l)a g)lumelle(?:|s))/$1lemma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|(?:L|l)a g)lume(?:|s) inférieure(?:|s))/$1lower glumes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|(?:L|l)a g)lume(?:|s) supérieure(?:|s))/$1upper glumes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|(?:Les d|D)eux g)lume(?:|s))/$1glumes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Le g|G|g)ynécée)/$1gynoecium$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)rbuscule|(?:Grand(?:|s) a|A|Petit(?:|s) a|Très grand(?:|s) a)rbre(?:|s)|(?:Sous-a|A|a)rbuste|(?:Sous-a|A)rbrisseau(?:|x)|Bulbe(?:|s)|(?:Petit (?:e|é)|E|É)piphyte|(?:Petites f|F)ougères (?:arborescentes|aquatiques|(?:|généralement |souvent )(?:é|e)piphytes|herbacées|très primitives|terrestres)|(?:L|Petite(?:|s) l|Grande(?:|s) l|Forte(?:|s) l)iane(?:|s)|(?:(?:G|Très g)rande(?:|s) h|Petite(?:|s) h|H)erbe(?:|s)|Herbacée(?:|s)|Plante(?:|s) (?:annuelle(?:|s)|buissonnante(?:|s)|émergeante(?:|s)|épiphyte(?:|s)|flottante(?:|s)|herbacée(?:|s)|holoparasite(?:|s)|lianoïde(?:|s)|ligneuse(?:|s)|parasite(?:|s)|pérenne(?:|s)|plus robuste(?:|s)|rampante(?:|s)|robuste(?:|s)|terrestre(?:|s))|Rhizome\.|Rhizome (?:ascendant|cespiteux|court|(?:|court, )dressé|filiforme|mince|rameux|ramifié|(?:|courtement |lâchement |(?:|épais, |très )longuement )rampant)|Partie dressée de la plante|(?:Espèce a|A)nnuelle(?:|s)|(?:Probablement p|P)érenne(?:|s)|Espèce très variable|(?:P|p)ort (?:arbustif|très variable))/$1habit$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p|cette p)ubescence|(?:(?:L|l)es p|P|p|Présence (?:|fréquente )de p|Pas de p|longs p)oils|(?:P|p)ilosité)/$1hairs$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:H|h|Petit h)amulus)/$1hamulus$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:H|h)auteur)/$1height$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:H|h|(?:P|p)as d'h)étérostylie)/$1heterostyly$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c|Les c)rochet(?:|s))/$1hooks$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:H|h|Présence d'h)ydathodes)/$1hydathodes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:H|h)ypanth(?:e|ium))/$1hypanthium$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:H|h)ypochile)/$1hypochile$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:H|h)ypocotyle)/$1hypocotyles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L'i|l'i|I|i)nd(?:u|û)ment)/$1indumentum$2$3/;
		s/(<(?:subC|c)har class=")(">)(Indusie(?:|s))/$1indusia$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i|L'i)nfru(?:|s)tescence(?:|s))/$1infructescences$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nnovations extravaginales)/$1extravaginal innovations$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nnovations infravaginales)/$1infravaginal innovations$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i|Les i)nnovations)/$1innovations$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:t|T|leur t)égument(?:|s))/$1integument$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)seudo-involucre(?:|s))/$1pseudo-involucres$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i)nvolucre(?:|s))/$1involucres$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:I|i)sthme(?:|s))/$1isthmus$2$3/;
		s/(<(?:subC|c)har class=")(">)(Joints)/$1joints$2$3/;
		s/(<(?:subC|c)har class=")(">)(Jeunes extrémités)/$1juvenile parts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:K|k)apok)/$1kapok$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)e l||l|L)abelle)/$1labellum$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l)imbe(?:|s) fertile(?:|s))/$1fertile lamina$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l)imbe(?:|s) jeune(?:|s))/$1juvenile lamina$2$3/;
		s/(<(?:subC|c)har class=")(">)(jeunes limbes)/$1juvenile lamina$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)arge(?:|s) du limbe)/$1lamina margins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)e(?:|s) l|le l|L|l)imbe(?:|s))/$1lamina$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)euilles axillaires)/$1axillary leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)euille(?:|s)s fertile(?:|s))/$1fertile leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)euilles intermédiaires)/$1intermediary leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Très j|J|j)eunes feuill(?:age|es))/$1juvenile leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)euilles latérales des branches principales)/$1main branches lateral leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)euilles latérales des ramifications ultimes)/$1ultimate branching lateral leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)euilles latérales)/$1lateral leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Les f|F|f)euilles (?:adultes|âgées))/$1mature leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)euilles médianes)/$1median leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)euilles de la tige principale)/$1primary stem leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)es f|F|f|Petites f|Grandes f)euille(?:|s)|\d+ à \d+ f)/$1leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l)emm(?:a|e|es|as) fertile(?:|s))/$1fertile lemma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l)emm(?:a|e|es|as) inférieure(?:|s))/$1lower lemma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l)emm(?:a|e|es|as) stérile(?:|s))/$1sterile lemma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l|(?:L|l)a l)emm(?:a|e|es|as))/$1lemma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:nombreuses l|l)enticelles)/$1lenticels$2$3/;
		s/(<(?:subC|c)har class=")(">)(Gaine et ligule)/$1sheath and ligula$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:l|L)igule)/$1ligula$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:la l|l|L)èvre abaxiale)/$1abaxial lip$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:la l|l|L)èvre adaxiale)/$1adaxial lip$2$3/;
		s/(<(?:subC|c)har class=")(">)(lèvre)/$1lip$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:l|L)obe(?:|s) central)/$1central lobes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:l|L)obe(?:|s) latéraux)/$1lateral lobes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:l|L)obe(?:|s) médian)/$1median lobes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:l|L)obe(?:|s) postérieur)/$1posterior lobes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:l|L)obe(?:|s) sépalaire)/$1sepal lobes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:l|les l|L|\d+(?:|-\d+) l)obe(?:|s))/$1lobes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:chaque l|l|Les l|les l|L|(?:|\d+-)\d+ l)oge(?:|s))/$1locules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:l|les l|L|(?:D|d)eux l|Deux petites l|\d+ l|Pas de l)odicule(?:|s))/$1lodicules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:l|L)omentum)/$1lomentum$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m|La m|Les m)arge(?:|s)|(?:B|b)ord(?:|s))/$1margins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m|chaque m)éricarpe(?:|s))/$1mericarps$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ésocarpe inférieur)/$1lower mesocarp$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ésocarpe supérieur)/$1upper mesocarp$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ésocarpe(?:|s))/$1mesocarps$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ésophylle(?:|s))/$1mesophylls$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)onades|Pollen simple)/$1monads$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ucilage endocarpique)/$1endocarpic mucilage$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)ucilage)/$1mucilage$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:N|n|(?:D|d)es n)ectaire(?:|s))/$1nectaries$2$3/;
		s/(<(?:subC|c)har class=")(">)(Le premier entren(?:oe|œ)ud)/$1first internode$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:J|j)eunes entre(?:|-)n(?:oe|œ)uds)/$1juvenile internodes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e|\d+(?:|-\d+) e)ntre(?:|-)n(?:oe|œ)uds)/$1internodes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:N|n)(?:oe|œ)uds)/$1nodes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:O|o)chréa(?:|s))/$1ochreas$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:|l')(?:A|a)lbumen)/$1other secretions$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Les f|F|f)ollicule(?:|s))/$1ovarian follicles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L'O|l'o|O|o)percule)/$1operculum$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L'O|l'o|L'o|O|o)stiole(?:|s))/$1ostiole$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)hambre(?:|s) épigyne(?:|s))/$1epigynous ovary$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L'O|l'o|L'o|O|o|Les o)vaire(?:|s))/$1ovary$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:\d+|\d+(?:-| à )\d+) o|O|o|(?:D|d)eux o|(?:S|s)ix o|(?:N|n)ombreux o|(?:P|p)lusieurs o|(?:U|u)n o|un seul o|\(\d+-\)\d+\(-\d+\) o)vule(?:|s))/$1ovules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p|(?:L|l)a p)al(?:é|e)a)/$1palea$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p|(?:Très g|G)rande p)anicule(?:|s))/$1panicles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)ausses papilles)/$1false papilla$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)apilles)/$1papilla$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p|(?:P|p)as de p|(?:P|p)résence de p|(?:A|a)bsence de p)araphyses)/$1paraphyses$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)arenchyme)/$1parenchyma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f|très exceptionnellement f)ausse(?:|s) cloison(?:|s))/$1false partitions$2$3/;
		s/(<(?:subC|c)har class=")(">)(P(?:ièc|arti)es aériennes)/$1aerial parts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)artie rameuse)/$1branched parts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)artie fertile)/$1fertile parts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)artie(?:|s) verte(?:|s))/$1green parts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)ppareil végétatif)/$1vegetative parts$2$3/;
		s/(<(?:subC|c)har class=")(">)(P(?:ièc|arti)es externes)/$1outer parts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)es p|(?:L|l)e p|p|P|Longs p)édicell(?:é|e)(?:|s))/$1pedicels$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:le p|p|P|(?:P|p)as de p|Petit(?:|s) p)édoncule(?:|s))/$1peduncle$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p|Le p)érianthe)/$1perianth$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p|Le p)éricarpe)/$1pericarp$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l)iège du rhytidome)/$1periderm$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)érigone)/$1perigone$2$3/;
		s/(<(?:subC|c)har class=")(">)(Canal périspermatique)/$1perisperm canal$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)étales internes)/$1inner petals$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)étales externes)/$1outer petals$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|Un g)rand p(?:é|e)tale)/$1large petals$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:\d+|\d+-\d+|Cinq|(?:L|l)es \d+) pétale(?:|s)|(?:P|p|Les p)(?:e|é)tale(?:|s))/$1petals$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:La p|p|P)arties calleuses et non calleuses du pétiole)/$1callous and non-callous parts of the petiole$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:La p|p|P)artie calleuse du pétiole)/$1callous part of the petiole$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:La p|p|P)artie non calleuse du pétiole)/$1non-callous part of the petiole$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Long p|p|P|Le(?:|s) p)(?:é|e)tiole(?:|s))/$1petiole$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Courts p|P|p|le p)étiolule(?:|s))/$1petiolule$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)halange(?:|s) staminale(?:|s))/$1staminal phalanges$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)ileus)/$1pileus$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)remière paire de pennes)/$1first pair of pinnae$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)enne(?:|s) fertile(?:|s))/$1fertile pinnae$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)enne(?:|s) latérale(?:|s))/$1lateral pinnae$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)enne(?:|s) moyenne(?:|s))/$1middle pinnae$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)enne(?:|s) inférieure(?:|s))/$1lower pinnae$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)enne(?:|s) supérieure(?:|s))/$1upper pinnae$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)enne(?:|s) stérile(?:|s))/$1sterile pinnae$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P|la p)enne(?:|s) terminale(?:|s))/$1terminal pinnae$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P|\d+-\d+ paires de p)enne(?:|s))/$1pinnae$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)remière pinnule inférieure)/$1first lower pinnule$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)innules fertile(?:|s))/$1fertile pinnules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)innules stérile(?:|s))/$1sterile pinnules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)innule(?:|s))/$1pinnules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P|Le p|pas de p)istillode)/$1pistillode$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P|Le p)istil)/$1pistil$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)onctuations intervasculaires)/$1intervessel pits$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)lacentation)/$1placentation$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P|(?:U|u)n p)lacenta)/$1placenta$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)lantes (?:|monoïques ou )dioïques)/$1plant sexuality$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g|Petite(?:|s) g|(?:G|g)rand(?:|e)(?:|s) g|(?:F|f)orte(?:|s) g|(?:L|l)ongue(?:|s) g)ousse(?:|s))/$1legume pods$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)olyades|Pollen composé)/$1polyads$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P|(?:G|g)rain(?:|s) de p)ollen)/$1pollen$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)ollinie)/$1pollinium$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)réfloraison)/$1prebloom$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e|é|de simples é)pine(?:|s)|(?:A|a)iguillon(?:|s))/$1prickles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)rothalle)/$1prothallium$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:J|j)eunes pseudobulbe(?:|s))/$1juvenile pseudobulbs$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)seudobulbe(?:|s))/$1pseudobulbs$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)ulpe)/$1fruit pulp$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)acème(?:|s) secondaire(?:|s))/$1secondary racemes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Longs r|Nombreux r|R|r|De \d+ à \d+ r)ac(?:è|é|e)me(?:|s)|Grappes)/$1racemes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:le r|Le r|r|R|Court r)achis)/$1rachises$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:r|R|à r)adicule)/$1radicle$2$3/;
		s/(<(?:subC|c)har class=")(">)(dernières ramification)/$1last ramification$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:r|R)amification pseudosympodiale)/$1pseudosympodial ramification$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:r|R)amification)/$1ramification$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:r|R)amule(?:|s) ultimes)/$1ultimate ramules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:r|R)amule(?:|s))/$1ramules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:r|R)ayons)/$1rays$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r|Le r)éceptacle)/$1receptacle$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r|Le r|fin r)éticul(?:e|um))/$1reticulum$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:r|R)hizome(?:|s))/$1rhizomes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:r|R)hizophore(?:|s) ventraux)/$1ventral rhizophores$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:r|R)hizophore(?:|s))/$1rhizophores$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:r|R|Le r)hytidome)/$1rhytidome$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ôte(?:|s))/$1ribs$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a|\d+ à \d+ a)rête)/$1ridges$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r|Nombreuses r)acine(?:|s))/$1roots$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)estes du rostellum)/$1rostellum remains$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)ostellum)/$1rostellum$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)ostre(?:|s))/$1rostrum$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)amare(?:|s))/$1samaras$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)ubier)/$1sapwood$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:É|E|é|e)cailles du rhizome)/$1rhizome scales$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:É|E|é|e)caille(?:|s))/$1scales$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:H|h)ampe(?:|s) florale(?:|s)|(?:H|h)ampe(?:|s))/$1floral scapes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)icatrice(?:|s))/$1scars$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)chizocarpe(?:|s))/$1schizocarps$2$3/;
		s/(<(?:subC|c)har class=")(">)(Section transversale médiane)/$1median transversal section$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:S|s)ection|(?:C|c)oupe) transversale)/$1transversal section$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)lantule(?:|s))/$1seedlings$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:L|l)es g|G|g|(?:L|l)a g|(?:G|g)rosse(?:|s) g|(?:P|p|Nombreuses p)etite(?:|s) g|Nombreuses g)raine(?:|s)|(?:\d+|\d+-\d+) graine(?:|s)|\d+ noyaux)/$1seeds$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)egment(?:|s))/$1segments$2$3/;
		s/(<(?:subC|c)har class=")(">)(Restes des sépales)/$1sepal remains$2$3/;
		s/(<(?:subC|c)har class=")(">)(\d+ sépales|(?:S|s|Les s)épale(?:|s) dorsal)/$1dorsal sepals$2$3/;
		s/(<(?:subC|c)har class=")(">)(\d+ sépales|(?:S|s|Les s)épale(?:|s) latéraux)/$1lateral sepals$2$3/;
		s/(<(?:subC|c)har class=")(">)(\d+ sépales|(?:S|s|Les s)épale(?:|s))/$1sepals$2$3/;
		s/(<(?:subC|c)har class=")(">)(Séparation gaine-ligule)/$1sheath-ligula separation$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g)aine(?:|s) fol(?:|i)aire(?:|s))/$1leaf sheaths$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:G|g)aine(?:|s))/$1sheaths$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r|longs r)ameaux florifères)/$1floriferous shoots$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)ameaux inflorescentiels)/$1inflorescence shoots$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:J|j|(?:T|t)rès j)eune(?:|s) rameau(?:|x)|Rameau(?:|x) jeune(?:|s))/$1juvenile shoots$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)ameaux latéraux)/$1lateral shoots$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:V|v)ieux rameau(?:|x)|Rameau(?:|x) âgé(?:|s))/$1old shoots$2$3/;
		s/(<(?:subC|c)har class=")(">)(rameaux plus âgés)/$1older shoots$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)etits rameaux)/$1small shoots$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r|(?:L|l)es r)ameaux)/$1shoots$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)oboles|Pas de soboles)/$1soboles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m|le m)acrosore(?:|s))/$1macrosori$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s|Les s)ore(?:|s))/$1sori$2$3/;
		s/(<(?:subC|c)har class=")(">)(Spathe-bractée adaxiale)/$1adaxial spathe-bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)pathéole(?:|s))/$1spatheoles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)pathe(?:|s))/$1spathe$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:É|E|e|é)pillet(?:|s) fertile(?:|s))/$1fertile spikelets$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:É|E|e|é)pillet(?:|s) sessile(?:|s))/$1sessile spikelets$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:É|E|e|é)pillet(?:|s) pédicell(?:e|é)s)/$1pedicel spikelets$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:É|E|e|é|Paires d'é)pillet(?:|s))/$1spikelets$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:É|E|e|é)pi(?:|s) mâle(?:|s))/$1male spikes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:É|E|e|é)pi(?:|s) terminal(?:|s))/$1terminal spikes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Un à trois f|F)aux épis)/$1false spikes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:É|E|e|é)pi(?:|s))/$1spikes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)acrosporange(?:|s))/$1macrosporangia$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)égasporange(?:|s))/$1megasporangia$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m|les m)icro(?:| )sporange(?:|s))/$1microsporangia$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s|\d+-\d+ paires de s)porange(?:|s))/$1sporangia$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)porophylle(?:|s) dorsaux)/$1dorsal sporophylls$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)porophylle(?:|s) ventraux)/$1ventral sporophylls$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)porophylle(?:|s))/$1sporophylls$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)porophyte(?:|s))/$1sporophytes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)acrospore(?:|s))/$1macrospores$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)(?:e|é)gapore(?:|s) et microspore(?:|s))/$1megaspores and microspores$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)(?:e|é)gaspore(?:|s))/$1megaspores$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)icrospore(?:|s))/$1microspores$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)pore(?:|s))/$1spores$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e|É|é)peron(?:|s))/$1spurs$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e|É|é|Les é)tamines internes)/$1inner stamens$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e|É|é|Les é)tamines externes)/$1outer stamens$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:|\d+ )(?:(?:L|l)es (?:é|e)|é|É|E)tamine(?:|s) fertile(?:|s))/$1fertile stamens$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:|\d+ )(?:(?:L|l)es (?:é|e)|é|É|E)tamine(?:|s) longue(?:|s))/$1long stamens$2$3/;
		s/(<(?:subC|c)har class=")(">)(La 6e étamine)/$1sixth stamen$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:|\d+ )(?:(?:L|l)es (?:é|e)|é|É|E)tamine(?:|s) courte(?:|s))/$1short stamens$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:|\d+ )(?:(?:L|l)es (?:é|e)|é|É|E)tamine(?:|s) stérile(?:|s))/$1sterile stamens$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:|Normalement )\d+ étamines|(?:(?:(?:L|l)es |l'|L')é|é|É|E|(?:(?:T|t)rois|(?:S|s)ix) é|(?:\d+ ou \d+|\d+-\d+|\d+ \(-\d+\)) é)tamine(?:|s))/$1stamens$2$3/;
		s/(<(?:subC|c)har class=")(">)(Le deuxième staminode externe)/$1second outer staminode$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Un s|S|Un, deux s|Un seul s)taminode(?:|s) externe(?:|s)|Pas de staminodes externes)/$1outer staminodes$2$3/;
		s/(<(?:subC|c)har class=")(">)(Staminode(?:|s) interne(?:|s))/$1inner staminodes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:\d+|\d+-\d+) staminodes|(?:S|s|le s|(?:d|l|D|L)es s|Deux s|Pas de s)taminode(?:|s))/$1staminodes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)timanodes latéraux)/$1lateral stimanodes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)telidi(?:a|um))/$1stelidia$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)ige(?:|s) florifère(?:|s))/$1floriferous stems$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)ige(?:|s) (?:adulte(?:|s)|âgée(?:|s)))/$1mature stems$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:J|j|(?:L|l)es j|Les très jeunes t)eune(?:|s) tige(?:|s)|tiges jeunes)/$1juvenile stems$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)ige(?:|s) feuillée(?:|s))/$1leafy stems$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)ige(?:|s) principales|(?:C|c)haumes principales)/$1primary stems$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)ige(?:|s) stérile(?:|s))/$1sterile stems$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)ige(?:|s)|(?:C|c)haumes)/$1stems$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)tigmaphore(?:|s))/$1stigmaphores$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s|un seul s|Le s|\d+ s)tigmate(?:|s)|Style à stigmate)/$1stigma$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:s|S)tipe(?:|s))/$1stipes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l)igne stipulaire)/$1stipule scars$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:s|S|Grandes s)tipules)/$1stipules$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)ouche)/$1stock$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)tolon(?:|s))/$1stolons$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:N|n)oyau(?:|x))/$1stones$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:O|o)rganes pérennes)/$1perennial organs$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:O|o)rganes de réserve)/$1storage organs$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l)anière(?:|s) marginale(?:|s))/$1marginal strips$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)trobile(?:|s) femelle(?:|s))/$1female strobili$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)trobile(?:|s) mâle(?:|s))/$1male strobili$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)trobile(?:|s))/$1strobili$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)tylopode(?:|s))/$1stylopodia$2$3/;
		s/(<(?:subC|c)har class=")(">)(Surface inférieure du limbe)/$1lamina lower surfaces$2$3/;
		s/(<(?:subC|c)har class=")(">)(surface(?:|s) abaxiale(?:|s))/$1abaxial surfaces$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f|L(?:a|es) f|Surf)ace(?:|s) inférieure(?:|s))/$1lower surfaces$2$3/;
		s/(<(?:subC|c)har class=")(">)(la surface extérieure)/$1outer surfaces$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f|L(?:a|es) f|Surf)ace(?:|s) supérieure(?:|s))/$1upper surfaces$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f|L(?:a|es) f|Surf)ace(?:|s)|(?:S|s)urface(?:|s))/$1surfaces$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Long s|Court s|S|s|les s|Le s|le s)tyle(?:|s)|(?:|\d+ ou )\d+ style(?:|s))/$1style$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:s|S)yncarpe(?:|s))/$1syncarps$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t|avec un t)ectum)/$1tectum$2$3/;
		s/(<(?:subC|c)har class=")(">)(Denticules|(?:D|d|Les d)ents)/$1teeth$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t|La t)egula)/$1tegula$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:V|v)rille(?:|s))/$1tendrils$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|)épales des fleurs ♂)/$1male flower tepals$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|)épales externes)/$1outer tepals$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|)épales internes)/$1inner tepals$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:|\d+ )(?:T|t)épale(?:|s))/$1tepals$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)esta|(?:T|t)est )/$1testa$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t|La t)exture)/$1texture$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)hèques)/$1thecae$2$3/;
		s/(<(?:subC|c)har class=")(">)(Gorge)/$1throat$2$3/;
		s/(<(?:subC|c)har class=")(">)(Diamètre du tronc)/$1trunk diameter$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t|Le t|le t)ronc|(?:F|f|Le f)ût)/$1trunk$2$3/;
		s/(<(?:subC|c)har class=")(">)(Touffes denses de tiges robustes)/$1stem tufts$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)ubercule(?:|s))/$1tubercles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t|Le t|le t)ube)/$1tube$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:J|j)eunes ramilles)/$1juvenile twigs$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)amilles)/$1twigs$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:O|o)mbelles)/$1umbels$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:V|v)alve vides)/$1empty valves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:V|v|Chaque v)alve)/$1valves$2$3/;
		s/(<(?:subC|c)har class=")(">)(système vasculaire)/$1vascular system$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:|pas de )(?:F|f)ausse(?:|s) nervure(?:|s) marginale(?:|s))/$1marginal false veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:|pas de |Présence de )(?:F|f)ausse(?:|s) nervure(?:|s))/$1false veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:N|n)ervure(?:|s) libre(?:|s))/$1free veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:N|n|\d+ à \d+ paires de n)ervures (?:latérales secondaires|secondaires latérales))/$1secondary lateral veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:grandes n|Les n|n|N|nombreuses n)ervures latérales)/$1lateral veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:V|v)eines longitudinales)/$1longitudinal veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:|pas de )(?:N|n)ervure(?:|s) marginale(?:|s))/$1marginal veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:N|n|La n|Pas de n)ervure(?:|s) médiane(?:|s)|(?:V|v)eine médiane)/$1median veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:N|n)ervure(?:|s) pennée(?:|s))/$1pennate veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:N|n)ervure(?:|s) primaire(?:|s)|nervures principales)/$1primary veins$2$3/;
		s/(<(?:subC|c)har class=")(">)(réseau quaternaire)/$1quaternary veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:(?:D|L)es n|N|n|\d+-\d+ n|une paire de n)ervures secondaires|\d+(?:|-\d+) paires de nervures secondaires|Nervation secondaire|nervures II)/$1secondary veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:réseau des n|n)ervures tertiaires|(?:R|r)éseau tertiaire|nervation tertiaire)/$1tertiary veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:V|v)eines transversales)/$1transversal veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:n|N|(?:U|u)ne (?:|seule )n)ervure(?:|s)|(?:La n|N|n)ervation|(?:|à \d+ ou |\d+ à |Environ )\d+ nervures|(?:\d+-|env\. |)\d+ paires de nervures)/$1veins$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:N|n|fine n|réseau de n|pas de n)ervilles|(?:F|f)in réseau)/$1veinlets$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:V|v)oile)/$1velamen$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e|é)léments vasculaires)/$1vessels$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:V|v|(?:L|l)a v|Grande v)iscidie)/$1viscidia$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p|Les p|les p)aroi(?:|s))/$1wall$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)ile(?:|s))/$1wings$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:V|v|les deux v)erticille(?:|s))/$1whorls$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:Le(?:|s) b|B|b|Vieux b)ois)/$1wood$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)oupe du bois)/$1wood section$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)lan ligneux)/$1wood structure$2$3/;
		
		
		# Descriptions Latines:
		s/(<(?:subC|c)har class=")(">)((?:B|b)racteae)/$1bracts$2$3/;
		s/(<(?:subC|c)har class=")(">)(Bracteolae)/$1bracteoles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)alyx)/$1calyx$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)orolla)/$1corolla$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:C|c)ymae)/$1cymes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:N|n)ucleo)/$1cores$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:D|d)iscus)/$1disk$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:D|d)rupae)/$1drupes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:E|e)ndocarpio)/$1endocarp$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:A|a)equatore)/$1equator$2$3/;
		s/(<(?:subC|c)har class=")(">)(Herbaceus|Herba (?:erecta|fere|foliis|rigida|robusta)|Caules foliosae|Arbor|Arbuscula|Liana|Rhizomate tenui)/$1habit$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:H|h)emicapsula)/$1hemicapsules$2$3/;
		s/(<(?:subC|c)har class=")(">)(Flo(?:s|res))/$1flowers$2$3/;
		s/(<(?:subC|c)har class=")(">)(Fructus)/$1fruits$2$3/;
		s/(<(?:subC|c)har class=")(">)(Spica(?:|e)|(?:I|i)nflorescentia|(?:I|i)nflorescentiae)/$1inflorescences$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l)abellum)/$1labellum$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l)amina)/$1lamina$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:F|f)olia)/$1leaves$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:L|l)igula)/$1ligula$2$3/;
		s/(<(?:subC|c)har class=")(">)(Stamina lobo centrali)/$1central lobes$2$3/;
		s/(<(?:subC|c)har class=")(">)(Corolla lobis)/$1corolla lobes$2$3/;
		s/(<(?:subC|c)har class=")(">)(Lobi)/$1lobes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)esocarpio infero)/$1lower mesocarps$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)esocarpio supero)/$1upper mesocarps$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:M|m)esocarpio)/$1mesocarps$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:O|o)varium)/$1ovary$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)etala)/$1petals$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)etiol(?:a|um))/$1petioles$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:p|P)ileo)/$1pileus$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:P|p)innis)/$1pinnae$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)eceptacul(?:a|um))/$1receptacle$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)epala)/$1sepals$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:R|r)amuli)/$1shoots$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)ori)/$1sori$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)tamina)/$1stamens$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)taminodium externe)/$1outer staminodes$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:S|s)tipulae)/$1stipules$2$3/;
		s/(<(?:subC|c)har class=")(">)(Paginae)/$1surfaces$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:s|S)yncarpium)/$1syncarps$2$3/;
		s/(<(?:subC|c)har class=")(">)((?:T|t)ubio)/$1tube$2$3/;
		
		
		
	}
	
	# Atomisation des Distributions:
	elsif (/\t\t\t<feature class="distribution">/) {
		
		# Niveau global:
		s/((?:P|p)resque cosmopolite|(?:C|c)osmopolite|l'ensemble de la zone tropicale|régions chaudes du (?:globe|monde entier)|les deux hémisphères|(?:R|r)égions chaudes et tempérées (?:chaudes du globe|du monde entier)|règions plus ou moins chaudes du globe|régions tempérées (?:de l'hémisphère nord|et chaudes|et intertropicales du globe|et tropicales du monde entier)|régions tempérées|(?:R|r)égions tropicales(?: de l'ancien et du nouveau monde| de l'ancien monde| du globe| du monde entier| du monde| et subtropicales (?:de l'ancien monde|des deux hémisphères)| et subtropicales)|régions subtropicales et tempérées de l'hémisphère Sud|(?:autres|tous les) pays chauds|pantropical et subtropical|(?:P|p)antropical(?:e|)|toute la surface du globe|Tropiques (?:de l'(?:A|a)ncien (?:M|m)onde|des deux mondes)|zones (?:à climat aride|tropicales de l'ancien monde)|zones tempérées Nord|hémisphère (?:nord|sud)|toutes les régions tropicales)/<distributionLocality class=\"world\">$1<\/distributionLocality>/g;
		
		
		# Regions oceaniques:
		s/(Océanie tropicale|Océanie|Pacifique|le pourtour de la mer Méditerranée|Méditerranée|autour de l'Océan Indien|mer Rouge)/<distributionLocality class=\"oceanic region\">$1<\/distributionLocality>/g;
		
		
		# Regions continentales + continents:
		s/((?:côte (?:occidentale|orientale)|régions (?:chaudes et tempérées|intertropicales|tropicales)) (?:d|de l)'Afrique|Afrique (?:au Sud du tropique du Cancer|australe et orientale|(?:A|a)ustrale|(?:C|c)entrale|continentale|de l'Est|de l'Ouest|du sud-est|du (?:S|s)ud|équatoriale occidentale|équatoriale|et îles africaines|tropicale (?:ou|et) (?:australe|méridionale|subtropicale)|tropicale(?:-| )occidentale|(?:inter|)tropicale(?:, occidentale et orientale| et australe| et orientale|)|occidentale et (?:centrale|équatoriale|orientale)|(?:O|o)ccidentale tropicale|(?:O|o)ccidentale|(?:O|o)rientale(?: portugaise|, centrale et occidentale| et australe)|(?:O|o)rientale)|(?:l'Est|l'Ouest|Sud-Ouest) (?:A|a)fricain|Afrique|(?:côte orientale|régions littorales) d’Amérique|Amérique (?:du (?:S|s)ud|méridionale|tropicale (?:du Sud| et subtropicale)|centrale et australe|centrale|tropicale)|Amérique|(?:sud|régions tropicales) (?:de l|d)'Asie|Asie (?:du sud-est|tropicale)|Asie|Nord-Ouest de l'Australie|Australie (?:du Nord|tropicale)|Australie|Australasie|Europe|Extrême-Orient|région méditerranéenne)/<distributionLocality class=\"continental region\">$1<\/distributionLocality>/g;
		
		# Separe les continents des regions continentales:
		s/(<distributionLocality class=")(continental region)(">)(Afrique|Amérique(?: du (?:S|s)ud|)|Asie|Australie|Europe)(<\/distributionLocality>)/$1continent$3$4$5/g;
		
		# Exception: Afrique du Sud:
		s/(<distributionLocality class=")(continental region)(">)(Afrique du (?:S|s)ud)(<\/distributionLocality>)/$1country$3$4$5/g;
		
		
		# Regions + Pays:
		s/(Andes|(?:A|a)rchipel (?:antillais|de la Sonde|indo-malais|Malais)|baie de Biafra|Bengale|Bioko|Canaries|Deng Deng|Fernando(?:-| )Po|Fernan-Vaz|Formose|Fouta-Djalon|Haut-Zambèse|(?:B|b)as-Katanga|(?:haut |)Katanga|(?:haut |)Mbomou|Lac Nyassa|les îles du golfe de Guinée|(?:G|g)olfe de Guinée|(?:I|î)les (?:du Cap(?:-| )Vert|Molu(?:s|)ques|Philippines)|(?:I|î)le du Prince|Indes orientales|Indochine|Java|Loango|Luzon|Mascareignes|Massif du Chaillu|May(?:o|u)mbe congolais|May(?:o|u)mbe|Ndendé|Ngounyé|Niari|Nouvelle-Calédonie|Nyanga|Oban|Oubangui-Chari|fleuve Oubangui|Oubangui|péninsule indienne|(?:P|p)lateaux (?:Batékés|des Cataractes)|Polynésie|Pyrénées|région (?:baya de Kundé|d'Eséka|de Booué|de Boukoko|de Brazzaville|de Fernan Vaz à l'embouchure de l'Ogoué|de forêt pélohygrophile d'Abong-Mbang et de Lomié|de Franceville|de Lastoursville|de Lomié|de Mamfe|de Sibiti|de Tchibanga|de Yaoundé|des Grands Lacs|du Cap|du lac Moero)|région Indo-malaise|Tchibanga|Rhodésie du Nord|Sibérie|Stanley-Pool|Tanganyika|Usambara|Victoria|(?:île de |)Zanzibar|Allemagne|(?:Nord |N\. de l'|Sud de l')Angola|Angola du Nord|Angola|Arabie|Argentine|Bénin|Birmanie|Bolivie|Bourbon|Brésil|Burkina Faso|Burundi|Cambodge|(?:sud-ouest du |Sud-Est |(?:E|e)st du |(?:S|s)ud )Cameroun|Cameroun (?:(?:ex-|)britannique|occidental|oriental)|Cameroun|Casamance|République Centrafrique|Centrafrique|Ceylan|Chili|Chine (?:du Sud|méridionale)|Chine|Colombie|Comores|(?:l'embouchure du|Bas|moyen bassin du|Moyen|République Démocratique d(?:e|u)|Sud Est)(?:-| )Congo|(?:|Nord Est du )Congo(?:(?:-| |)(?:Brazzaville|Kinshasa)| oriental| équatorial| occidental)|(?:l'est du |)Congo ex(?:-| )(?:B|b)elge|Congo (?:(?:B|b)elge|Fr\.|français|Portugais)|République Congolaise|(?:nord du |les deux |République du |)Congo|C(?:o|ô)te(?:-| )d(?:'|’)Ivoire|Dahomey|Egypte|Espagne|(?:É|E)thiopie|Fidji|(?:Est|NE|sud) du Gabon|(?:Nord|SE|Sud) Gabon|Gabon|Gambie|Ghana|Nouvelle-Guinée|Guinée(?: |-)Bissau|Guinée (?:(?:E|É|é)quatoriale|espagnole|ex(?:-| )française)|nord de la Guinée|Guinée|(?:Iles |)Hawa(?:ï|ii)|Indes|Inde|Indonésie|Japon|Kasai|Kenya|Kivu|Laos|Lib(?:é|è|e)ria|Madagascar|Maghreb|Malacca|Indo-Malaisie|Malaisie|Malawi|Mali|Mascarègnes|Maurice|Mauritanie|Mayombé|Mélanésie|Mexico|Micronésie|(?:M|m)onts de Cristal|Mozambique|Natal|(?:Est de la|Sud|S\.|sud-est du|Sud Ouest de la) Nig(?:e|é)ria|Nig(?:e|é)ria (?:du (?:S|s)ud|méridional(?:|e)|oriental(?:|e))|Nig(?:e|é)ri(?:e|a)|Niger|la Nouvelle-Zélande|Nouvelle-Zélande|Ouganda|Panama|Papouasie|Pays Batéké|Péninsule Malaise|Pérou|Philippines|plateau de l'Adamaoua|Principe|République (?:C|c)entrafricaine|RCA|R\.C\.A\.|République sudafricaine|Rhodésie|Rwanda|S(?:a|â|ã)o Tom(?:e|é)|(?:sud du|Sud) Sénégal|Sénégal|Seychelles|Siam|Sierra(?:-| )L(?:e|é)one|(?:République du |)S(?:|o)udan|Sri Lanka|Ta(?:i|ï)wan|Tanzanie|Tchad|Thaïlande|Togo|Transva(?:|a)l|Uganda|USA|Cap Vert|Cap|Venezuela|Viêtnam|Yémen|Zaïre|Zambie|Zimbabwe)/<distributionLocality class=\"region\">$1<\/distributionLocality>/g;
		
		# Separe les Pays des regions:
		s/(<distributionLocality class=")(region)(">)(Allemagne|Angola|Arabie|Argentine|Bénin|Birmanie|Bolivie|Bourbon|Brésil|Burkina Faso|Burundi|Cambodge|Cameroun|République Centrafrique|Centrafrique|Ceylan|Chili|Chine|Colombie|Comores|(?:les deux |République du |République Démocratique d(?:e|u) |)Congo(?: ex(?:-| )belge|(?:-| |)Kinshasa|)|Côte(?:-| )d(?:'|’)Ivoire|Dahomey|Egypte|Espagne|(?:É|E)thiopie|Fidji|Gabon|Gambie|Ghana|Guinée(?: |-)Bissau|Guinée(?: (?:E|É|é)quatoriale| espagnole| ex(?:-| )française|)|îles Philippines|Indes|Inde|Indonésie|Japon|Kenya|Laos|Lib(?:é|e)ria|Madagascar|Malacca|Malaisie|Malawi|Mali|Maurice|Mauritanie|Mexico|Micronésie|Mozambique|Niger|Nig(?:e|é)ri(?:e|a)|la Nouvelle-Zélande|Ouganda|Pérou|Philippines|République (?:C|c)entrafricaine|RCA|R\.C\.A\.|République sudafricaine|Rhodésie|Rwanda|S(?:a|â|ã)o Tom(?:e|é)|Sénégal|Seychelles|Siam|Sierra(?:-| )L(?:e|é)one|(?:République du |)Soudan|Sri Lanka|Tanzanie|Tchad|Thaïlande|Togo|Transvaal|Uganda|USA|Venezuela|Viêtnam|Yémen|Zaïre|Zambie|Zimbabwe)(<\/distributionLocality>)/$1country$3$4$5/g;
		
		
		# Departements:
		s/(Kouilou|Réunion)/<distributionLocality class=\"department\">$1<\/distributionLocality>/g;
		
		
		# Districts:
		s/(District forestier central|Haut-Uele|Ituri|Kwango)/<distributionLocality class=\"district\">$1<\/distributionLocality>/g;
		
		
		# Provinces:
		s/(Annobon|Cabinda|Cuanza|Estuaire|Haut-Ogooué|Kasaï|Lunda|Moyen-Ogooué|Ngounié|Ogooué-Ivindo|Ogooué-Lolo|Ogooué-Maritime|province (?:du Bénin|de Calabar)|Woleu-Ntem)/<distributionLocality class=\"province\">$1<\/distributionLocality>/g;
		
		
		# Localitees:
		s/(Benin|Bertoua|Bipindi|Brazzaville|Calabar|Campo|Conakry|Douala|Ebolowa|Franceville|Gold-Coast|Golungo Alto|Kinshasa|Kribi|Lastoursville|Libreville|Mayumba|Moanda|Mouila|Moloundou|Ndikiniméki|(?:chutes de l'|moyen )Ogooué|Pointe-Noire|Port-Gentil|San-Thomé|Sapoba|Sibiti|Stanleyville|Yaoundé|Yangambi|Yokadouma)/<distributionLocality class=\"locality\">$1<\/distributionLocality>/g;
		
		
		# Autres:
		s/(Nyassaland|lacs du Bas-Ogooué)/<distributionLocality class=\"other\">$1<\/distributionLocality>/g;
		
		
		# Enleve tags quand une region ou province est donnee base sur le nom d'une ville:
		s/(<distributionLocality class="(?:province|région)">(?:province|région) de )(<distributionLocality class="locality">)(Benin|Bertoua|Brazzaville|Calabar|Conakry|Douala|Franceville|Gold-Coast|Golungo Alto|Kribi|Lastoursville|Libreville|Mayumba|Moanda|Mouila|Moloundou|Ndikiniméki|(?:chutes de l'|moyen )Ogooué|Pointe-Noire|Port-Gentil|San-Thomé|Sibiti|Stanleyville|Yaoundé|Yokadouma)(<\/distributionLocality>)/$1$3/g;
		
		
		# Remet la nouvelle ligne enleve avec le script precedant:
		s/(^)(\t\t\t<feature class="distribution">)/$1$2\n/;
		
		
	
	}
	
	elsif (/<habitat>|<locality class=".+?">/) {
		# Atomisation des Habitats:
		
		# Ajoute les tags d'altitude aux habitats:
		# altitude unique:
		s/((?:|\d )\d+ m(?!m))/<altitude>$1<\/altitude>/g;
		
		
		# "jusqu'a", rangees, etc.:
		s/(entre |jusqu'à |(?:|\d |entre )\d+(?:-| à | et ))(<altitude>)/$2$1/g;
		
		# estimations d'altitude:
		s/(± )(<altitude)(>)/$2 estimate="true"$3$1/g;
		
		
	
	}
	
	
	# Atomisation des Noms vernaculaires:
	elsif (/\t\t\t<feature class="vernacular">/) {
		
		# Ajoute le tag ou les tags d'ouverture <vernacularNames>:
		s/(<\/subHeading>)(?: |)/$1<vernacularNames>\n\t\t\t\t\t<vernacularName>/g;
		# Ajoute le ou les tags de fermeture </vernacularNames>:
		s/((?:\.|;|,)(?:<\/string>|<br \/>))/<\/vernacularName>\n\t\t\t\t<\/vernacularNames>$1/g;
		
		# Separe les noms vernaculaires:
		s/(; )/<\/vernacularName>\n\t\t\t\t\t<vernacularName>/g;
		
		# Ajoute les tags aux langues locales:
		s/( \(| — |, | et |dial\. |dialecte(?:s|) )((?:A|a)djumba|(?:A|a)kélé|(?:A|a)mbamba|(?:A|a)mbèdè|(?:À|A|a)pindji|(?:B|b)abouté|(?:B|b)adjoué|(?:B|b)ad(?:o|)uma|(?:B|b)agielli|(?:B|b)ak(?:è|é)k(?:è|é)|(?:B|b)ak(?:è|é)l(?:è|é)|(?:B|b)ak(?:é|i)li|(?:B|b)akoko|(?:B|b)ako(?:-|)ta|(?:B|b)akwélé|(?:B|b)akwiri|(?:B|b)alèlè|(?:B|b)al(?:e|è)ngi|(?:B|b)a(?:-|)lumbu|(?:B|b)amenda|(?:B|b)amoun|(?:B|b)an-zabi|(?:B|b)anda et autres|(?:B|b)anda, Oubangui|(?:B|b)an(?:|d)zabi|(?:B|b)apounou|(?:B|b)ap(?:a|u)nu|Bas-Gabon|(?:B|b)assa|(?:B|b)atanga|(?:B|b)atehangui|(?:B|b)atéké|(?:B|b)ava(?:-|)rama|(?:B|b)avili de Loango|(?:B|b)avili|(?:B|b)a(?:-|)vov(?:è|é)|(?:B|b)avumbu|(?:B|b)av(?:|o)ung(?:|o)u|(?:B|b)awumpfu|(?:B|b)ayaka|(?:B|b)aya|(?:B|b)avove|(?:B|b)ékési|(?:B|b)enga|(?:B|b)(?:è|é|e)s(?:è|é|e)ki|(?:B|b)enzabi|(?:B|b)ibaya|(?:B|b)ipind(?:i|e)|(?:B|b)osyèba|(?:B|b)o(?:b|v)ili|(?:B|b)oulou|(?:C|c)ommercial|(?:D|d)jinn|(?:D|d)ouala|(?:D|d)zimou|(?:E|e|é)shira(?: t|-T)andu|(?:E|É)schira|(?:E|É|e|é)chira|(?:É|E|e|é)s(?:-|)hira|(?:É|E|e|é)wondo|(?:F|f)ang de l'Estuaire|(?:F|f)ang du Fernan-Vaz|(?:F|f)ang du lac Ayem|(?:F|f)ang de Libreville|(?:F|f)ang de la côte|(?:F|f)ang du Como ou du Rio Muni|(?:F|f)ang|(?:F|f)oulbé|(?:F|f)ulfuldé|(?:G|g)aloa|(?:G|g)orumba|(?:i|I)duma|(?:i|I)véa|(?:I|i)vilis|(?:I|i)vili|(?:K|k)aka|(?:K|k)épéré|(?:K|k)ota|(?:K|k)ouilou|(?:L|l)oan(?:-|)go|(?:L|l)umbo|(?:M|m)'bethen|(?:M|m)abéa|(?:M|m)aduma|(?:M|m)a(?:-|s|)sang(?:u|o)|(?:M|m)azangu|(?:M|m)baka|(?:M|m)bimou|(?:M|m)in(?:-|)dum(?:a|u)|misogo|mitsogo de Sindara ou de Mouila|(?:M|m)it(?:-|)so(?:|-)g(?:|h)o|(?:M|m)pong(?:o|)ué|(?:M|m)pongw(?:é|è|e) de Libreville|(?:M|m)pongw(?:é|è|e)|(?:M|m)psongwè|(?:M|m)uni|(?:M|m)unzali|(?:M|m)yenè|(?:N|n)anga (?:E|e)boko|(?:N|n)djolé|(?:N|n)go(?:w|v)(?:è|é)|(?:N|n)gowé|(?:N|n)(?:'|)komi|(?:N|n)z(?:e|é|a)bi|(?:O|o)bamba|(?:O|o)kondè|(?:O|o)(?:|u)r(?:o|)un(?:|-)g(?:o|)u|(?:O|o)vongu|(?:P|p)ahouin du Como|(?:P|p)ahouin|(?:P|p)apunu|(?:P|p)euhl|(?:P|p)ygmée (?:bibaya de Ndingue|bibaya|bagielli)|(?:P|p)(?:|o)un(?:|o)u|(?:P|p)ové|(?:S|s)ang(?:u|o)|(?:S|s)éké|(?:S|s)ikiani|(?:S|s)imba|(?:T|t)chibanga|(?:T|t)éké|(?:U|u)rungu|(?:V|v)ili|(?:V|v)ungu|(?:w|W)andzi|(?:Y|y)aound(?:e|é)|(?:Y|y)ombi(?![[:lower:]])|anciens colons|nom commercial (?:|originaire )d(?:e|u) (?:bas Cameroun|Côte(?:-| )d'Ivoire|Nigeria)|nom commercial|nom pilote|nom pilot|(?:A|a)llem\.|(?:A|a)ngl\.|(?:A|a)ng|(?:E|e)n\.|(?:E|e)n|(?:E|e)sp\.|(?:E|e)sp|(?:F|f)r\.|(?:F|f)r|(?:P|p)ort\.)/$1<localLanguage>$2<\/localLanguage>/g;
		
		# Indique si la langue n'est par sure:
		s/(<localLanguage)(>.+?)(<\/localLanguage>)((?: |)\?)/$1 doubtful="true"$2$4$3/g;
		
		# Ajoute les tags de nom de debut et fin a chaque ligne avec nom(s) vernaculaire(s):
		s/(<vernacularName>)(.+?)( \()/$1<name class="vernacular">$2<\/name>$3/g;
		# Tags intermediaires:
		s/(<vernacularName><name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		# Encore plus de tags intermediaires:
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		s/(<name class="vernacular">.+?)(, | et )([[:upper:]]|[[:lower:]])/$1<\/name>$2<name class="vernacular">$3/g;
		
		# Option alternative:
		s/(« )([[:upper:]][[:lower:]]+)( »)/$1<name class="vernacular">$2<\/name>$3/g;
		
		
		
		# Remet la nouvelle ligne enleve avec le script precedant:
		s/(^)(\t\t\t<feature class="vernacular">)/$1$2\n/;
		# Remet la nouvelle ligne apres les <br />:
		s/(<br \/>)/$1\n\t\t\t/;
	
	}
	
	else {
	}
	
	# Remet la nouvelle ligne:
	s/(^)(\t\t\t<feature class="(?:cytology|ecology|flower anatomy|habitat|habitatecology|morphology|notes|taxonomy|uses)">)(\t)/$1$2\n$3/;
	
	
	print OUT $_;
}

close IN;
close OUT;