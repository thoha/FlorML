#!/usr/bin/perl
# nomenclaturefr.plx
# Ajoute les tags de nomenclature et de types (le plus possible)

use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
		# Option tag <taxon> (pour vol. 38+):
		s/(\t\t<taxon>)/$1\n\t\t\t<nomenclature>\n\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">/;
	if (/^(?!\t*<)(?![[:upper:]].+\.<br \/>$)(?![[:upper:]].+<\/string>$)(?!.+xmlns:xsi)/) {
		
		# Enlve l'etoile devant le numero (Vol. 5bis):
		s/(^)(\*)/$1/;
		
		
		# Debut de nomenclature:
		# Option debut avec numero:
		s/(^\d+(?:| bis)\. )/\t\t\t<nomenclature>\n$1/;
		
		
		# Option tag <taxon> (pour vol. 38+):
		s/(\t\t<taxon>)/$1\n\t\t\t<nomenclature>\n\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">/;
		
		
		# Special 5bis: Option debut avec numero point numero (ex. "60.1"):
		# s/(^\d+\.\d+(?: |a|b|c|d|e|f|\. ))/\t\t\t<nomenclature>\n$1/;
		
		# Option debut avec numero Romain ou lettre:
		# s/(^(?:I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|XXI|XXII|XXIII|XXIV|XXV|a|b|c|d|e|f|\(\d+(?:| bis| ter))\. )/\t\t\t<nomenclature>\n$1/;
		
		# Option debut avec ORDRE + numero Romain:
		# s/(^ORDRE (?:I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|XXI|XXII|XXIII|XXIV|XXV)\. )/\t\t\t<nomenclature>\n$1/;
		
		# Autres options de debut:
		# s/(^(?:(?:V|v)ar|(?:S|s)ubsp|fa)\. )/\t\t\t<nomenclature>\n$1/;
		# s/(^Variété )/\t\t\t<nomenclature>\n$1/;
		# s/(^[[:upper:]]+(?:CEAE|CEÆ))/\t\t\t<nomenclature>\n$1/;
		# s/(^[[:upper:]]+(?:EAE|EÆ))/\t\t\t<nomenclature>\n$1/;
		# s/(^(?:DIOSPYROS|LÉGUMINEUSE|SOUS-FAMILLE DES ).+)/\t\t\t<nomenclature>\n$1/;
		
		
		# Noms acceptes:
		# Chiffre, numero Romain ou lettre:
		# s/(^)(\t\t\t<nomenclature>\n)(\d+(?:| bis| ter)|I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|XXI|XXII|XXIII|XXIV|XXV|a|b|c|d|e|f|\(\d+(?:| bis| ter))(\. )(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t<num>$3<\/num>\n$5$6/;
		# Special 5bis: numero point numero + lettre (ex. "60.1a"):
		# s/(^)(\t\t\t<nomenclature>\n)(\d+\.\d+(?:a|b|c|d|e|f))(\. )(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t<num>$3<\/num>\n$5$6/;
		# Special 5bis: numero point numero (ex. "60.1"):
		# s/(^)(\t\t\t<nomenclature>\n)(\d+\.\d+)( |\. )(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t<num>$3<\/num>\n$5$6/;
		# Familles:
		# s/(^)(\t\t\t<nomenclature>\n)([[:upper:]]+(?:CEAE|CEÆ))(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n$3$4/;
		# s/(^)(\t\t\t<nomenclature>\n)([[:upper:]]+(?:CEAE|CEÆ))($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n$3$4/;
		# Sous-familles etc.:
		# s/(^)(\t\t\t<nomenclature>\n)([[:upper:]]+(?:EAE|EÆ))(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n$3$4/;
		# s/(^)(\t\t\t<nomenclature>\n)([[:upper:]]+(?:EAE|EÆ))($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n$3$4/;
		# s/(^)(\t\t\t<nomenclature>\n)(SOUS-FAMILLE DES [[:upper:]]+(?:EAE|EÆ))($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n$3$4/;
		# ORDRES:
		# s/(^)(\t\t\t<nomenclature>\n)(ORDRE )(I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV|XVI|XVII|XVIII|XIX|XX|XXI|XXII|XXIII|XXIV|XXV)(\. )(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n\t\t\t\t\t\t<num>$4<\/num>\n$3$6$7/;
		# Varietes et sous-especes etc.:
		# s/(^)(\t\t\t<nomenclature>\n)((?:V|v)ar|(?:S|s)ubsp)(\. )(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n$3$4$5$6/;
		# s/(^)(\t\t\t<nomenclature>\n)(Variété)(.+)($)/$2\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="accepted">\n$3$4$5/;
		
		
		# Enleve le trait apres le numero/la lettre dans certains cas:
		s/(<\/num>\n)(— )/$1/;
		# Enleve les parentheses dans certains cas:
		s/(<num>)(\()(\d+(?:| bis| ter)<\/num>)(\n.+?)(\))(\n\t\t\t\t\t<\/nom>)/$1$3$4$6/;
		
		# Synonymes heterotypiques:
		
		# Synonymes incertains:
		# Avec espace entre statut et nom:
		s/(^)((?:|≡ |= |- |— )\?)( )(.+)($)/\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>\n\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="synonym">\n$1\t\t\t\t\t\t\t<name class="status">?<\/name>\n$4$5/;
		# Sans espace entre statut et nom:
		s/(^)((?:|≡ |= |- |— )\?)(.+)($)/\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>\n\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="synonym">\n$1\t\t\t\t\t\t\t<name class="status">?<\/name>\n$3$4/;
		
		# Non-synonymes:
		s/(^)(≠ )(.+)($)/\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>\n\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="synonym">\n\t\t\t\t\t\t\t<name class="status">non<\/name>\n$1$3$4/;
		s/(^)(≠)(.+)($)/\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>\n\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="synonym">\n\t\t\t\t\t\t\t<name class="status">non<\/name>\n$1$3$4/;
		
		# Synonymes:
		s/(^)((?:≡|=|-|—) )(.+)($)/\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>\n\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="synonym">\n$1$3$4/;
		s/(^)((?:≡|=|-|—))(.+)($)/\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>\n\t\t\t\t<homotypes>\n\t\t\t\t\t<nom class="synonym">\n$1$3$4/;
		
		# Synonymes homotypiques:
		s/(\t\t\t\t\t<nom class="synonym">\n)(.+?)( - )/$1$2\n\t\t\t\t\t<\/nom>\n\t\t\t\t\t<nom class="synonym">\n/;
		
		
		# Basionymes:
		s/(\. — )(BASIONYME: )(.+)/\n\t\t\t\t\t<\/nom>\n\t\t\t\t\t<nom class="basionym">\n\t\t\t\t\t\t<name class="note">$2<\/name>\n$3/;
		
		
		
		# Separe les citations et les noms taxonomiques:
		s/(\t\t\t\t\t<nom class="(?:synonym|basionym|homonym|accepted)">\n(?:|\t\t\t\t\t\t<name class="note">.+?<\/name>\n))(.+?)(, )(.+)/$1$2\n$4/g;
		
		
		
	}
	# Insere les tags nomenclature de fin:
	elsif (/^\t\t\t<feature class="description">/) {
		s/(^)(\t\t\t<feature class="description">)/\t\t\t\t\t<\/nom>\n\t\t\t\t<\/homotypes>\n\t\t\t<\/nomenclature>\n$1$2/;
	}
	else {
	}
	
	# Types:
	
	# Types sur lignes separees:
	
	# NameTypes:
	s/(^)(Type du genre|Esp(?:è|e)ce type du genre|Esp(?:è|e)ce(?: |-)type|ESP(?:È|E)CE-TYPE|ESP(?:È|E)CE·TYPE|GENRE-TYPE)((?:\.|:) )(.+)($)/\t\t\t\t\t<nameType>$2$3$4/;
	# Nametypes lectotypes:
	s/(^)(Type du genre|Esp(?:è|e)ce type du genre|Esp(?:è|e)ce(?: |-)type)( \(lectotype\))((?:\.|:) )(.+)($)/\t\t\t\t\t<nameType typeStatus="lectotype">$2$3$4$5/;
	
	# SpecimenTypes:
	s/(^)((?:Le (?:T|t)|T)ype(?:|s)|TYPE)(.+)($)/\t\t\t\t\t<specimenType>$2$3/;
	# Holotypes:
	s/(^)(Holotype|HOLOTYPE)(.+)($)/\t\t\t\t\t<specimenType typeStatus="holotype">$2$3/;
	# Lectotypes:
	s/(^)(Lectotype|LECTOTYPE)(.+)($)/\t\t\t\t\t<specimenType typeStatus="lectotype">$2$3/;
	# Neotypes:
	s/(^)(Neotype|N(?:E|É)OTYPE)(.+)($)/\t\t\t\t\t<specimenType typeStatus="neotype">$2$3/;
	# Syntypes:
	s/(^)(Syntype|SYNTYPE)(.+)($)/\t\t\t\t\t<specimenType typeStatus="syntype">$2$3/;
	
	
	# SpecimenTypes en Latin:
	s/(^)(Typ\.)(.+)($)/\t\t\t\t\t<specimenType lang="la">$2$3/;
	
	# Types suivant literature:
	
	# SpecimenTypes:
	s/(\.)( — )(TYPE(?:|\*):)(.+)/\n\t\t\t\t\t<specimenType>$3$4/;
	s/(\.)( — )(Type:)(.+)/\n\t\t\t\t\t<specimenType>$3$4/;
	# Holotypes:
	s/(\.)( — )(HOLOTYPE(?:|\*):)(.+)/\n\t\t\t\t\t<specimenType typeStatus="holotype">$3$4/;
	# Lectotypes:
	s/(\.)( — )(LECTOTYPE(?:|\*):)(.+)/\n\t\t\t\t\t<specimenType typeStatus="lectotype">$3$4/;
	# Neotypes:
	s/(\.)( — )(NEOTYPE(?:|\*):)(.+)/\n\t\t\t\t\t<specimenType typeStatus="neotype">$3$4/;
	# Syntypes:
	s/(\.)( — )(SYNTYPE(?:|\*):)(.+)/\n\t\t\t\t\t<specimenType typeStatus="syntype">$3$4/;
	
	
	
	
	
	
	print OUT $_;
}

close IN;
close OUT;