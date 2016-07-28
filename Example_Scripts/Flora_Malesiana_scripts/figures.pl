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
	if (/^(Fig\.|Map|Plate) \d+(\.|:) /) {
		# Basic figure mark-up:
		s/(^)((?:Fig\.|Map|Plate) )(\d+)(\. |: )(.+)(\.)($)/\t\t\t<figure id=\"\" type=\"\">$2<num>$3<\/num>$4<figureLegend>$5$6<\/figureLegend><\/figure>/;
		
		# Gatherings mark-up:
		# Finds part of text featuring gatherings:
		if (/\(([[:lower:]]-|[[:lower:]]:|[[:lower:]], ).+\)\.<\/figureLegend><\/figure>$/) {
			# Adds mark-up by matching figure parts (3 options), collector name, space, field number, separator:
			s/([[:lower:]]-[[:lower:]]: |[[:lower:]]: |([[:lower:]], )+([[:lower:]]: ))([A-Za-z &,]+)( )(\d+|s\.n\.)(;|\))/$1<gathering><collector>$4<\/collector><fieldNum>$6<\/fieldNum><\/gathering>$7/g;
			# For those gatherings with localities present:
			s/([[:lower:]]-[[:lower:]]: |[[:lower:]]: |([[:lower:]], )+([[:lower:]]: ))([A-Za-z &,]+)( )(\d+|s\.n\.)((, )([A-Za-z &,]+))(;|\))/$1<gathering><collector>$4<\/collector><fieldNum>$6<\/fieldNum><locality class="locality">$9<\/locality><\/gathering>$10/g;
		}
		else {
		}
	}
	
	
	# References to figures:
	
	# In anything but nomenclature (or other unmarked up text), references, or figures:
	elsif (/(?!<references>)(?!<figureLegend)(<feature|<string>|<\/string>|<br \/>|<text>|<td>)/) {
		
		
		# Complicated (so to speak) reference formats that do require splitting of figure references, e.g. "(Fig. 1e, 6f, 8e-f)":
		# Base mark-up:
		s/( |\()(Fig\. |Figs\. )([[:lower:]0-9, ;-]+)(\.|\)|, )/$1<figureRef ref="">Fig\. <num>$3<\/num><\/figureRef>$4/g;
		# Splits individual figures, with or without references to figureParts, using look-ahead as security check:
		s/(Fig\. <num>)(\d+(?:[[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+|))(, )(?=\d+)/$1$2<\/num><\/figureRef>$3<figureRef ref="">Fig\. <num>/g;
		s/(Fig\. <num>)(\d+(?:[[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+|))(, )(?=\d+)/$1$2<\/num><\/figureRef>$3<figureRef ref="">Fig\. <num>/g;
		s/(Fig\. <num>)(\d+(?:[[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+|))(, )(?=\d+)/$1$2<\/num><\/figureRef>$3<figureRef ref="">Fig\. <num>/g;
		s/(Fig\. <num>)(\d+(?:[[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+|))(, )(?=\d+)/$1$2<\/num><\/figureRef>$3<figureRef ref="">Fig\. <num>/g;
		s/(Fig\. <num>)(\d+(?:[[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+|))(, )(?=\d+)/$1$2<\/num><\/figureRef>$3<figureRef ref="">Fig\. <num>/g;
		# Above code uses quick 'n dirty repetition to get things done. The places where more than five sequential figure references of the format given occur are very rare...
		# Marks up figureparts:
		s/(<figureRef ref="">Fig\. <num>\d+)([[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(<\/num>)(<\/figureRef>(?:\.|\)|, ))/$1$3<figurePart>$2<\/figurePart>$4/g;
		
		
		
		# Marks up figure references of the format " — Fig. 1a, c, f; Map 1.", " — Fig. 1a-c, f-h; Map 1.", and all mixes:
		s/( |\()(Fig\. |Figs\. )(\d+)((?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(; )((?:Map|Plate) )(\d+)(\.|\)|, )/$1<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart><\/figureRef>$5<figureRef ref="">$6<num>$7<\/num><\/figureRef>$8/g;
		# Marks up figure references of the format " — Fig. 1a, c, f.", " — Fig. 1a-c, f-h.", and all mixes:
		s/( |\()(Fig\. |Figs\. |Map |Maps |Plate |Plates )(\d+)((?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(\.|\)|, )/$1<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart><\/figureRef>$5/g;
		
		
		# Marks up figure references of the format " Fig. 1a; Map 1.", " Fig. 1a-c; Map 1.":
		s/( |\()(Fig\. |Figs\. )(\d+)([[:lower:]]-[[:lower:]]|[[:lower:]])(; )((?:Map|Plate) )(\d+)(\.|\)|, )/$1<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart><\/figureRef>$5<figureRef ref="">$6<num>$7<\/num><\/figureRef>$8/g;
		# Marks up figure references of the format " Fig. 1a; Map 1a.", " Fig. 1a-c; Map 1a-c." and all mixes:
		s/( |\()(Fig\. |Figs\. )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(; )((?:Map|Plate) )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(\.|\)|, )/$1<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart><\/figureRef>$5<figureRef ref="">$6<num>$7<\/num><figurePart>$8<\/figurePart><\/figureRef>$9/g;
		
		# Marks up figure references of the format " Fig. 1; Map 1.":
		s/( |\()(Fig\. |Figs\. )(\d+)(; )((?:Map|Plate) )(\d+)(\.|\)|, )/$1<figureRef ref="">$2<num>$3<\/num><\/figureRef>$4<figureRef ref="">$5<num>$6<\/num><\/figureRef>$7/g;
		
		
		# Marks up figure references of the formats " Fig. 1a.", " Fig. 1a-c.":
		s/( |\()(Fig\. |Figs\. |Map |Maps |Plate |Plates )(\d+)([[:lower:]]-[[:lower:]]|[[:lower:]])(\.|\)|, )/$1<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart><\/figureRef>$5/g;
		
		# Marks up figure references of the format " Fig. 1":
		s/( |\()(Fig\. |Figs\. |Map |Plate )(\d+)/$1<figureRef ref="">$2<num>$3<\/num><\/figureRef>/g;
		
		
		# Moves figureRefs at end of descriptions out of descriptions - MAY NEED WORK:
		s/( — )(<figureRef ref="">.+?)(<\/feature>)/$3\n\t\t\t$2/;
		
		
	}
	
	
	
	# Figure references near end of nomenclature:
	
	# This loop skips text that was marked up previously:
	if (/^(?!\t*<)(?!.+(<br \/>|<\/li>)$)(?!.+<\/string>$)(?!.+<\/char>$)(?!.+<\/feature>$)(?!.+xmlns:xsi)/) {
		
		# Complicated (so to speak) reference formats that do require splitting of figure references, e.g. "(Fig. 1e, 6f, 8e-f)":
		# Base mark-up:
		s/( — )(Fig\. |Figs\. )([[:lower:]0-9, ;-]+)(\.|, )/\n\t\t\t<figureRef ref="">Fig\. <num>$3<\/num><\/figureRef>/g;
		# Splits individual figures, with or without references to figureParts, using look-ahead as security check:
		s/(Fig\. <num>)(\d+(?:[[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+|))(, )(?=\d+)/$1$2<\/num><\/figureRef>\n\t\t\t<figureRef ref="">Fig\. <num>/g;
		s/(Fig\. <num>)(\d+(?:[[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+|))(, )(?=\d+)/$1$2<\/num><\/figureRef>\n\t\t\t<figureRef ref="">Fig\. <num>/g;
		s/(Fig\. <num>)(\d+(?:[[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+|))(, )(?=\d+)/$1$2<\/num><\/figureRef>\n\t\t\t<figureRef ref="">Fig\. <num>/g;
		s/(Fig\. <num>)(\d+(?:[[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+|))(, )(?=\d+)/$1$2<\/num><\/figureRef>\n\t\t\t<figureRef ref="">Fig\. <num>/g;
		s/(Fig\. <num>)(\d+(?:[[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+|))(, )(?=\d+)/$1$2<\/num><\/figureRef>\n\t\t\t<figureRef ref="">Fig\. <num>/g;
		# Above code uses quick 'n dirty repetition to get things done. The places where more than five sequential figure references of the format given occur are very rare...
		# Marks up figureparts:
		s/(<figureRef ref="">Fig\. <num>\d+)([[:lower:]]|[[:lower:]]-[[:lower:]]|(?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(<\/num>)(<\/figureRef>)/$1$3<figurePart>$2<\/figurePart>$4/g;
		
		
		
		# Marks up figure references of the format " — Fig. 1a, c, f; Map 1.", " — Fig. 1a-c, f-h; Map 1.", and all mixes:
		s/( — )(Fig\. |Figs\. )(\d+)((?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(; )((?:Map|Plate) )(\d+)(\.|, )/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>\n\t\t\t<figureRef ref="">$6<num>$7<\/num><\/figureRef>/g;
		# Marks up figure references of the format " — Fig. 1a, c, f.", " — Fig. 1a-c, f-h.", and all mixes:
		s/( — )(Fig\. |Figs\. |Map |Maps |Plate |Plates )(\d+)((?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(\.|, )/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart><\/figureRef>/g;
		
		
		# Marks up figure references of the format "" — Fig. 1a; Map 1a.", "Fig. 1a-c; Map 1a-c." and all mixes:
		s/( — )(Fig\. |Figs\. )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(; )((?:Map|Plate) )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(\.|, )/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>\n\t\t\t<figureRef ref="">$6<num>$7<\/num><figurePart>$8<\/figurePart><\/figureRef>/g;
		# Marks up figure references of the format " — Fig. 1a; Map 1.", "Fig. 1a-c; Map 1.":
		s/( — )(Fig\. |Figs\. )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(; )((?:Map|Plate) )(\d+)(\.|, )/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>\n\t\t\t<figureRef ref="">$6<num>$7<\/num><\/figureRef>/g;
		# Marks up figure references of the formats " — Fig. 1a.", " — Fig. 1a-c.":
		s/( — )(Fig\. |Figs\. |Map |Maps |Plate |Plates )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(\.|, )/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart><\/figureRef>/g;
		
		
		# Marks up figure references of the format " — Fig. 1; Map 1.":
		s/( — )(Fig\. |Figs\. |Map |Plate )(\d+)(; )((?:Map|Plate) )(\d+)(\.|, )/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>\n\t\t\t<figureRef ref="">$5<num>$6<\/num><\/figureRef>/g;
		# Marks up figure references of the format " — Fig. 1.":
		s/( — )(Fig\. |Figs\. |Map |Plate )(\d+(?:—\d+|))(\.|, )/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><\/figureRef>/g;
		# — Fig. 1—2.
	}
	
	
	
	
	else {
	}
	print OUT $_;
}

close IN;
close OUT;