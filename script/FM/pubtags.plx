#!/usr/bin/perl
# pubtags.plx
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
print OUT "<publication xmlns:xsi=\"http://www\.w3\.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"\">\n\t<metaData>\n\t\t<defaultMediaUrl>http://wp5\.e-taxonomy\.eu/media/flora-malesiana/</defaultMediaUrl>\n\t</metaData>\n\t<treatment>\n\t\t<taxon>\n";

while (<IN>) {
	# Prints all non-empty lines to file:
	# if (!/^\s*$/) {
		print OUT $_;
	#}
}

# Appends the accompanying closing tags:
print OUT "\n\t\t</taxon>\n\t</treatment>\n</publication>";

close IN;
close OUT;

