#!/usr/bin/perl
# figures.plx
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
	elsif (/ — (Fig\. |Figs\. |Map |Maps |Plate |Plates )/) {
		# Simple figure reference formats that do not require splitting of figure references:
		# Marks up figure references of the format " — Fig. 1.":
		s/( — )(Fig\. |Map |Plate )(\d+)(\.)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>/g;
		# Marks up figure references of the format " — Fig. 1; Map 1.":
		s/( — )(Fig\. )(\d+)(; )((?:Map|Plate) )(\d+)(\.)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num>$4<\/figureRef>\n\t\t\t<figureRef ref="">$5<num>$6<\/num>$7<\/figureRef>/g;
		
		# Marks up figure references of the formats " — Fig. 1a.", " — Fig. 1a-c.":
		s/( — )(Fig\. |Figs\. |Map |Maps |Plate |Plates )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(\.)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>/g;
		# Marks up figure references of the format " — Fig. 1a; Map 1.", "Fig. 1a-c; Map 1.":
		s/( — )(Fig\. |Figs\. )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(; )((?:Map|Plate) )(\d+)(\.)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>\n\t\t\t<figureRef ref="">$6<num>$7<\/num>$8<\/figureRef>/g;
		# Marks up figure references of the format "" — Fig. 1a; Map 1a.", "Fig. 1a-c; Map 1a-c." and all mixes:
		s/( — )(Fig\. |Figs\. )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(; )((?:Map|Plate) )(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]])(\.)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>\n\t\t\t<figureRef ref="">$6<num>$7<\/num><figurePart>$8<\/figurePart>$9<\/figureRef>/g;
		
		# Marks up figure references of the format " — Fig. 1a, c, f.", " — Fig. 1a-c, f-h.", and all mixes:
		s/( — )(Fig\. |Figs\. |Map |Maps |Plate |Plates )(\d+)(([[:lower:]]|[[:lower:]]-[[:lower:]])(, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(\.)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>\.<\/figureRef>/g;
		# Marks up figure references of the format " — Fig. 1a, c, f; Map 1.", " — Fig. 1a-c, f-h; Map 1.", and all mixes:
		s/( — )(Fig\. |Figs\. )(\d+)((?:[[:lower:]]|[[:lower:]]-[[:lower:]])(?:, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(; )((?:Map|Plate) )(\d+)(\.)/\n\t\t\t<figureRef ref="">$2<num>$3<\/num><figurePart>$4<\/figurePart>$5<\/figureRef>\n\t\t\t<figureRef ref="">$6<num>$7<\/num>$8<\/figureRef>/g;
		
		# Complicated (so to speak) reference formats that do require splitting of figure references:
		if (/ — (Figs\.|Fig\.) \d+(,|-|[[:lower:]];|[[:lower:]],|[[:lower:]]-[[:lower:]];)/) {
			# Puts figure line of formats mentioned one line earlier on separate line:
			s/( — )(Fig(?:|s)\. )(.+)(\.)($)/\n\t\t\t<figureRef ref="">Fig\. <num>$3<\/num>$4<\/figureRef>$5/;
			# Splits individual figures, using look-ahead as security check:
			s/(\d+)(, )(?=\d+)/$1<\/num>\.<\/figureRef>\n\t\t\t<figureRef ref="">Fig\. <num>/g;
			# Splits figures with references to figureparts:
			s/(\d+)([[:lower:]]|[[:lower:]]-[[:lower:]]|([[:lower:]]|[[:lower:]]-[[:lower:]])(, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(; )(?=\d+)/$1$2<\/num>\.<\/figureRef>\n\t\t\t<figureRef ref="">Fig\. <num>/g;
			# Marks up figureparts:
			s/(<figureRef ref="">Fig. <num>\d+)([[:lower:]]|[[:lower:]]-[[:lower:]]|([[:lower:]]|[[:lower:]]-[[:lower:]])(, [[:lower:]]|, [[:lower:]]-[[:lower:]])+)(<\/num>\.<\/figureRef>)/$1<figurePart>$2<\/figurePart>$5/g;
		}

	}
	
	else {
	}
	print OUT $_;
}

close IN;
close OUT;