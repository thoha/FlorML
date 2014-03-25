#!/usr/bin/perl
# footnotes.plx
# Marks up footnotes
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Adds footnote markup to footnotes:
	s/(^\*+\)|^\d+\))(.+\.$)/\t\t\t<footnote id=""><footnoteString>$1$2<\/footnoteString><\/footnote>/g;
	# prints lines to file:
	print OUT $_;
}

close IN;
close OUT;