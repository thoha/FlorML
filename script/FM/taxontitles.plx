#!/usr/bin/perl
# taxontitles.plx
# Marks up taxontiles of specific format and headings directly related to taxa.
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Not lines starting with < or ending on a <br /> or </string>:
	if (/^(?!\t*<)(?!.+(\.|\)|:)(<br \/>|<\/li>)$)(?!.+<\/string>$)/) {
		
		
		# Specific taxon-related headings:
		s/(^)(DOUBTFUL )(.+)/\t\t\t<heading>$2$3<\/heading>/;
		s/(^)(Probably hybrids:)($)/\t\t\t<heading>$2<\/heading>/;
		
		# Taxontitles:
		s/(^)([[:upper:]][[:upper:]]+)(.+)($)/\t\t\t<taxontitle>$2$3<\/taxontitle>/;
		s/(^)((?:Section|Subgenus|Tribe) )(.+)($)/\t\t\t<taxontitle>$2$3<\/taxontitle>/;
		
		# For species taxontitles, if no separate species taxontitles are present, comment out:
		s/(^)(\d+|[[:lower:]])(\. )(.+)($)/\t\t\t<taxontitle num="$2">$4<\/taxontitle>/;
		
		
		# Adds footnoteRef markup if reference to footnote is present in taxontitle:
		s/(\t\t\t<taxontitle>.+)([0-9]+|\*)(<\/taxontitle>)/$1<footnoteRef ref="">$2<\/footnoteRef>$3/;
		
		# Splits out writer (and eventual footnotes) if present:
		s/(<taxontitle>)(.+)(\()(.+)(\))(.*)(<footnoteRef ref="">)([0-9]+|\*)(<\/footnoteRef>)(<\/taxontitle>)/$1$2$10\n\t\t\t<writer>$3$4$5$6$7$8$9<\/writer>/;

	
	
	}
	else {
	}
	print OUT $_;
}

close IN;
close OUT;