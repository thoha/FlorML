#!/usr/bin/perl
# filecleaner.pl
# filecleaner removes all unwanted characters from a plain text (UTF-8) version of a flora chapter. 
# By unwanted we mean stuff like double or triple spaces (or worse), spaces before dots, commas, 
# colons, semi-colons, newline characters, exclamation marks, question marks, and closing brackets, 
# spaces at the start of lines and in front of the first word in brackets, as well as double newlines 
# with no contents (or worse). It also replaces tab-characters by spaces (actually, it starts with this).
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, ">$destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Replaces all tab-characters with spaces:
	s/\t/ /g;
	# Replaces space-like whitespace (that isn't a space character) by proper spaces:
	s/ / /g;
	# Replaces floating dots by proper spaces:
	s/·|•/ /g;
	# Replaces 'wrong' hyphens by proper hyphens:
	s/–|−|­|Ð/-/g;
	# Replaces all hyphens that are both preceded and trailed by a space by long dashes preceded and trailed by a space:
	s/ - / — /g; 
	# Replaces wrong hyphens in figure references:
	s/^― Fig\./— Fig\./;
	# Removes the leading space(s) from a variety of unwanted combinations:
	s/( +)( |\.|,|:|;|\!|\]|\)|\n)/$2/g;
	# Removes multiple dots:
	s/\.+/./g;
	# Removes multiple commas:
	s/,+/,/g;
	# Removes multiple colons:
	s/:+/:/g;
	# Removes multiple semi-colons:
	s/;+/;/g;
	# Removes commas before dots:
	s/(,)(\.)/$2/g;
	# Removes the trailing spaces and dots behind two types of brackets:
	s/(\(|\[)( +|\.+)/$1/g;
	# Removes empty sets of brackets:
	s/(\(|\[)(\)|\])//g;
	# Removes whitespace at beginning of line:
	s/^\s+//;
	# Removes whitespace at end of line:
	s/\s+$/\n/;
	
	# Inserts space after colons and semi-colons if it's missing:
	s/(:|;)([[:upper:][:lower:]0-9])/$1 $2/g;
	
	# Replaces extra wide headings by normal headings:
	s/C(?: |)u(?: |)(?:l|I|1|i)(?: |)t(?: |)u(?: |)r(?: |)e(?: |) (?: |)a(?: |)n(?: |)d(?: |) (?: |)u(?: |)s(?: |)e/Culture and use/;
	
	s/C(?: |)u(?: |)(?:l|I|1|i)(?: |)t(?: |)u(?: |)r(?: |)e/Culture/;
	
	s/D(?: |)i(?: |)s(?: |)t(?: |)r(?: |)i(?: |)b(?: |)u(?: |)t(?: |)i(?: |)o(?: |)n/Distribution/;
	
	s/E(?: |)c(?: |)o(?: |)l(?: |)o(?: |)g(?: |)y/Ecology/;
	
	s/E(?: |)t(?: |)y(?: |)m(?: |)o(?: |)l(?: |)o(?: |)g(?: |)y/Etymology/;
	
	s/P(?: |)h(?: |)e(?: |)n(?: |)o(?: |)l(?: |)o(?: |)g(?: |)y/Phenology/;
	
	s/P o l l i n a t i o n & e c o l o g y/Pollination & ecology/;
	
	s/L a t i n d i a g n o s i s/Latin diagnosis/;
	
	s/C(?: |)l(?: |)a(?: |)s(?: |)s(?: |)i(?: |)f(?: |)i(?: |)c(?: |)a(?: |)t(?: |)i(?: |)o(?: |)n/Classification/;
	
	s/T(?: |)e(?: |)r(?: |)m(?: |)i(?: |)n(?: |)o(?: |)l(?: |)o(?: |)g(?: |)y (?: |)a(?: |)n(?: |)d (?: |)m(?: |)e(?: |)a(?: |)s(?: |)u(?: |)r(?: |)e(?: |)m(?: |)e(?: |)n(?: |)t(?: |)s/Terminology and measurements/;
	
	s/M(?: |)a(?: |)t(?: |)e(?: |)r(?: |)i(?: |)a(?: |)(?:l|I|1|i) (?: |)s(?: |)t(?: |)u(?: |)d(?: |)i(?: |)e(?: |)d/Material studied/;
	s/S(?: |)e(?: |)(?:l|I|1|i)(?: |)e(?: |)c(?: |)t(?: |)e(?: |)d (?: |)s(?: |)p(?: |)e(?: |)c(?: |)i(?: |)m(?: |)e(?: |)n(?: |)s/Selected specimens/;
	s/S(?: |)e(?: |)(?:l|I|1|i)(?: |)e(?: |)c(?: |)t(?: |)e(?: |)d (?: |)s(?: |)p(?: |)e(?: |)c(?: |)i(?: |)m(?: |)e(?: |)n/Selected specimen/;
	s/S(?: |)p(?: |)e(?: |)c(?: |)i(?: |)m(?: |)e(?: |)n(?: |)s (?: |)e(?: |)x(?: |)a(?: |)m(?: |)i(?: |)n(?: |)e(?: |)d/Specimens examined/;
	s/S(?: |)p(?: |)e(?: |)c(?: |)i(?: |)m(?: |)e(?: |)n (?: |)e(?: |)x(?: |)a(?: |)m(?: |)i(?: |)n(?: |)e(?: |)d/Specimen examined/;
	s/S(?: |)p(?: |)e(?: |)c(?: |)i(?: |)m(?: |)e(?: |)n(?: |)s (?: |)s(?: |)t(?: |)u(?: |)d(?: |)i(?: |)e(?: |)d/Specimens studied/;
	s/S(?: |)p(?: |)e(?: |)c(?: |)i(?: |)m(?: |)e(?: |)n (?: |)s(?: |)t(?: |)u(?: |)d(?: |)i(?: |)e(?: |)d/Specimen studied/;
	s/S(?: |)t(?: |)u(?: |)d(?: |)i(?: |)e(?: |)d/Studied/;
	s/E(?: |)x(?: |)a(?: |)m(?: |)i(?: |)n(?: |)e(?: |)d (?: |)s(?: |)p(?: |)e(?: |)c(?: |)i(?: |)m(?: |)e(?: |)n(?: |)s/Examined specimens/;
	s/E(?: |)x(?: |)a(?: |)m(?: |)i(?: |)n(?: |)e(?: |)d (?: |)s(?: |)p(?: |)e(?: |)c(?: |)i(?: |)m(?: |)e(?: |)n/Examined specimen/;
	s/F(?: |)e(?: |)r(?: |)t(?: |)i(?: |)(?:l|I|1|i)(?: |)e (?: |)s(?: |)p(?: |)e(?: |)c(?: |)i(?: |)m(?: |)e(?: |)n(?: |)s (?: |)e(?: |)x(?: |)a(?: |)m(?: |)i(?: |)n(?: |)e(?: |)d/Fertile specimens examined/;
	s/F(?: |)e(?: |)r(?: |)t(?: |)i(?: |)(?:l|I|1|i)(?: |)e (?: |)s(?: |)p(?: |)e(?: |)c(?: |)i(?: |)m(?: |)e(?: |)n (?: |)e(?: |)x(?: |)a(?: |)m(?: |)i(?: |)n(?: |)e(?: |)d/Fertile specimen examined/;
	
	s/U(?: |)s(?: |)e(?: |)s/Uses/;
	s/U(?: |)s(?: |)e/Use/;
	s/E(?: |)c(?: |)o(?: |)n(?: |)o(?: |)m(?: |)i(?: |)c (?: |)u(?: |)s(?: |)e(?: |)s/Economic uses/;
	s/E(?: |)c(?: |)o(?: |)n(?: |)o(?: |)m(?: |)i(?: |)c (?: |)u(?: |)s(?: |)e/Economic use/;
	
	s/V(?: |)e(?: |)r(?: |)n(?: |)a(?: |)c(?: |)u(?: |)(?:l|I|1|i)(?: |)a(?: |)r (?: |)n(?: |)a(?: |)m(?: |)e(?: |)s/Vernacular names/;
	s/V(?: |)e(?: |)r(?: |)n(?: |)a(?: |)c(?: |)u(?: |)(?:l|I|1|i)(?: |)a(?: |)r (?: |)n(?: |)a(?: |)m(?: |)e/Vernacular name/;
	
	s/L(?: |)i(?: |)t(?: |)e(?: |)r(?: |)a(?: |)t(?: |)u(?: |)r(?: |)e/Literature/;
	
	s/R(?: |)e(?: |)m(?: |)a(?: |)r(?: |)k(?: |)s/Remarks/;
	s/R(?: |)e(?: |)m(?: |)a(?: |)r(?: |)k/Remark/;
	s/N(?: |)o(?: |)t(?: |)e(?: |)s/Notes/;
	s/N(?: |)o(?: |)t(?: |)e/Note/;
	s/T a x o n o m i c n o t e s/Taxonomic notes/;
	
	s/S(?: |)u(?: |)b(?: |)d(?: |)i(?: |)v(?: |)i(?: |)s(?: |)i(?: |)o(?: |)n/Subdivision/;
	
	s/N(?: |)e(?: |)w (?: |)s(?: |)y(?: |)n(?: |)o(?: |)n(?: |)y(?: |)m(?: |)s/New synonyms/;
	s/N(?: |)e(?: |)w (?: |)s(?: |)y(?: |)n(?: |)o(?: |)n(?: |)y(?: |)m/New synonym/;
	s/N(?: |)e(?: |)w (?: |)s(?: |)p(?: |)e(?: |)c(?: |)i(?: |)e(?: |)s/New species/;
	s/N(?: |)e(?: |)w (?: |)c(?: |)o(?: |)m(?: |)b(?: |)i(?: |)n(?: |)a(?: |)t(?: |)i(?: |)o(?: |)n(?: |)s/New combinations/;
	s/N(?: |)e(?: |)w (?: |)c(?: |)o(?: |)m(?: |)b(?: |)i(?: |)n(?: |)a(?: |)t(?: |)i(?: |)o(?: |)n/New combination/;
	s/N(?: |)e(?: |)w (?: |)n(?: |)a(?: |)m(?: |)e(?: |)s/New names/;
	s/N(?: |)e(?: |)w (?: |)n(?: |)a(?: |)m(?: |)e/New name/;
	
	s/L(?: |)e(?: |)c(?: |)t(?: |)o(?: |)t(?: |)y(?: |)p(?: |)i(?: |)f(?: |)i(?: |)c(?: |)a(?: |)t(?: |)i(?: |)o(?: |)n(?: |)s/Lectotypifications/;
	s/L(?: |)e(?: |)c(?: |)t(?: |)o(?: |)t(?: |)y(?: |)p(?: |)i(?: |)f(?: |)i(?: |)c(?: |)a(?: |)t(?: |)i(?: |)o(?: |)n/Lectotypification/;
	s/N(?: |)e(?: |)w (?: |)t(?: |)y(?: |)p(?: |)i(?: |)f(?: |)i(?: |)c(?: |)a(?: |)t(?: |)i(?: |)o(?: |)n(?: |)s/New typifications/;
	s/N(?: |)e(?: |)w (?: |)t(?: |)y(?: |)p(?: |)i(?: |)f(?: |)i(?: |)c(?: |)a(?: |)t(?: |)i(?: |)o(?: |)n/New typification/;
	s/N(?: |)e(?: |)o(?: |)t(?: |)y(?: |)p(?: |)i(?: |)f(?: |)i(?: |)c(?: |)a(?: |)t(?: |)i(?: |)o(?: |)n(?: |)s/Neotypifications/;
	s/N(?: |)e(?: |)o(?: |)t(?: |)y(?: |)p(?: |)i(?: |)f(?: |)i(?: |)c(?: |)a(?: |)t(?: |)i(?: |)o(?: |)n/Neotypification/;
	
	
	
	# Prints all non-empty lines to file (comment out the loop itself if you want empty lines too):
	if (!/^\s*$/) {
		print OUT $_;
	}
}

close IN;
close OUT;