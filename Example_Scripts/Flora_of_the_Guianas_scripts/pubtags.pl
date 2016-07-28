#!/usr/bin/perl
# pubtags.pl
# Pre- and appends the first and last XML tags to a file.
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

# Prepends the first XML tags required by the FM XML scheme:
print OUT "<publication xmlns:xsi=\"http://www\.w3\.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"\" xmlns:mods=\"http://www\.loc\.gov/mods/v3\" lang=\"en\">\n\t<metaData>\n\t\thttp://media\.e-taxonomy\.eu/flora-guianas/</defaultMediaUrl>\n\t\t<mods:mods>\n\t\t\t<mods:titleInfo>\n\t\t\t\t<mods:title></mods:title>\n\t\t\t\t<mods:partNumber></mods:partNumber>\n\t\t\t\t<mods:partName></mods:partName>\n\t\t\t</mods:titleInfo>\n\t\t\t<mods:name type=\"personal\">\n\t\t\t\t<mods:namePart></mods:namePart>\n\t\t\t\t<mods:affiliation></mods:affiliation>\n\t\t\t</mods:name>\n\t\t\t<mods:originInfo>\n\t\t\t\t<mods:publisher></mods:publisher>\n\t\t\t\t<mods:dateIssued></mods:dateIssued>\n\t\t\t</mods:originInfo>\n\t\t\t<mods:identifier></mods:identifier>\n\t\t</mods:mods>\n\t</metaData>\n\t<treatment>\n\t\t<taxon>\n";

while (<IN>) {
	# Prints all lines to file:
		print OUT $_;
}

# Appends the accompanying closing tags:
print OUT "\n\t\t</taxon>\n\t</treatment>\n</publication>";

close IN;
close OUT;

