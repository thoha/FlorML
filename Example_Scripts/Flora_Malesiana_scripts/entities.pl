#!/usr/bin/perl
# entities.pl
# Replaces all non-webpage compatible symbols with their respective entities
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# Replaces all ampersands by their entity version:
	s/&/&amp;/g;
	# Replaces all greater-than symbols by their entity version:
	s/ > / &gt; /g;
	s/ >> / &gt;&gt; /g;
	# Replaces all smaller-than symbols by their entity version:
	s/ < / &lt; /g;
	s/ << / &lt;&lt; /g;
	# Replaces all greater or equal symbols by their entity version:
	s/ => / =&gt; /g;
	s/ >= / &gt;= /g;
	# Replaces all smaller or equal symbols by their entity versions:
	s/ =< / =&lt; /g;
	s/ <= / &lt;= /g;
	# Replaces all <> by their entity versions:
	s/ <> / &lt;&gt; /g;
	# Replaces all >< by their entity versions:
	s/ >< / &gt;&lt; /g;

		print OUT $_;

}

close IN;
close OUT;