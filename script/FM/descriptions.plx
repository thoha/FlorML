#!/usr/bin/perl
# descriptions.plx
# Adds mark-up to descriptions.
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {

	# Not sections of text starting with <, a digit, or ALL-CAPS text, or text containing a <br /> or </li>:
	
	# Not lines starting with < (aka a XML tag), a digit, or ALL CAPS, or ending on <br />, </li> or </string>:
	if (/^(?!\t*<)(?!\d)(?![[:upper:]][[:upper:]]+)(?![[:upper:]].+\.(<br \/>|<\/li>)$)(?![[:upper:]].+<\/string>$)/) {
		# Match list of keywords that usually only occur in descriptions:
		if (/(Capsule(?:|s) (?:ovoid|with)|Caudex|Climber(?:|s) |dioecious|Dioecious(?: marine plants|\.)|endocarpous beak|(?:Pistillate|Staminate|Male|Female) flowers|(?:Female|Male) ‘flower(?:|s)’|(?:F|f)rond|glabrous|Habit|(?:Annual|glaucous|mat-forming|perennial|Perennial|taller|tufted|viscid) herb(?:|s)|Leaf bud(?:|s)|Leaves (?:membranous|chartaceous|opposite|beneath|with)|monoecious|(?:p|P|Male p)edicel(?:|s) \d+(?:-| mm)|(?:p|P)erianth|(?:P|p)innae |pinnules|(?:P|p)itchers|Pseudo(?:|-)hypodermis|spathal sheath|(?:S|s)tipe|(?:s|S)trobil(?:i|us)|(?:both|Both|lower|lower leaf|Lower leaf|upper|upper leaf|Upper leaf) surface(?:|s)|Tree \d+(?:-|—)|Treelet|(?:V|v)eins)/) {
			# Insert basic feature mark-up for descriptions:
			s/(^)([[:upper:]].+)($)/$1<feature class="description"><char class="">$2<\/char><\/feature>/;
		}
		else {
		}
	}
	else {
	}
	print OUT $_;
}

close IN;
close OUT;