#!/usr/bin/perl
# literature.plx
# Atomize literature as far as possible.
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {


	# Nomenclature citations:
	
	# Fixing taxon statusses that were accidentally marked up as literature:
	s/(<citation class="publication">)(comb\. nov\.|stat\. nov\.|nom\. nov\.)(<\/citation>)/<name class="status">$2<\/name>/;
	
	# Fixing page numbers followed by dots:
	s/(\d)(\.)(<\/citation>)/$1$3/g;
	# Fixing edition number with no space between the abbreviation and the number:
	s/( ed\.)(\d)/$1 $2/g;
	
	
	
	
	# Removing "in" from publication citations that have different author than taxon author:
	s/(<citation class="(publication)">)( in )([[:upper:]])/$1$4/;
	
	# Citations:
	
	# No author and pubname present:
	# Format: (Year) Details:
	s/(<citation class="(?:usage|publication)">)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="year">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$5<\/refPart>\n\t\t\t\t\t\t$7/;
	# Format: Volume (Year):
	s/(<citation class="(?:usage|publication)">)(\d+)( \()(\d\d\d\d)(\) )(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="volume">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t$6/;
	# Format: Volume (Year) Details:
	s/(<citation class="(?:usage|publication)">)(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="volume">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$6<\/refPart>\n\t\t\t\t\t\t$7/;
	# Format: Edition (Year) Details:
	s/(<citation class="(?:usage|publication)">)((?:ed\. |edition )\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="edition">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$6<\/refPart>\n\t\t\t\t\t\t$7/;
	# Format: Edition, Volume (Year) Details:
	s/(<citation class="(?:usage|publication)">)((?:ed\. |edition )\d+)(, )(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="edition">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$8<\/refPart>\n\t\t\t\t\t\t$9/;
	
	
	
	# No author present:
	# Format: Pubname (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$7<\/refPart>\n\t\t\t\t\t\t$8/;
	
	# Format: Pubname Volume (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$9<\/refPart>\n\t\t\t\t\t\t$10/;
	
	# Format: Pubname ed. # (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )((ed\. |edition )\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$10<\/refPart>\n\t\t\t\t\t\t$11/;
	
	# Format: Pubname ed. #, Volume (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )((ed\. |edition )\d+)(, )(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$12<\/refPart>\n\t\t\t\t\t\t$13/;
	
	# Format: Pubname Volume, Issue (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(I|II|III|IV|V|VI|VII|VIII|IX|X|\d+)(, )(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$11<\/refPart>\n\t\t\t\t\t$12/;
	
	
	
	
	
	# Author present:
	# Format: Author, Pubname (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.]+)(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$9<\/refPart>\n\t\t\t\t\t\t$10/;

	# Format: Author, Pubname Volume (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.]+)(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$11<\/refPart>\n\t\t\t\t\t\t$12/;

	# Format: Author, Pubname ed. # (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.]+)(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )((ed\. |edition )\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$12<\/refPart>\n\t\t\t\t\t\t$13/;
	
	# Format: Author, Pubname ed. #, Volume (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.]+)(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )((ed\. |edition )\d+)(, )(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$12<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$14<\/refPart>\n\t\t\t\t\t\t$15/;
	
	# Format: Author, Pubname Volume, Issue (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.]+)(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(I|II|III|IV|V|VI|VII|VIII|IX|X|\d+)(, )(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$11<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$13<\/refPart>\n\t\t\t\t\t$14/;
	
	
	
	# Partial split of left-overs:
	
	# Ending on: , New ed. (Year) Details:
	s/(<citation class="(?:usage|publication)">)(.+)( |, )(new ed\.(?:| \d+))( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$8<\/refPart>\n\t\t\t\t\t\t$9/;
	# Ending on: Edition (Year) Details:
	s/(<citation class="(?:usage|publication)">)(.+)( |, )((?:ed\. |edition )\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$8<\/refPart>\n\t\t\t\t\t\t$9/;
	# Ending on: (Year) Details:
	s/(<citation class="(?:usage|publication)">)(.+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$6<\/refPart>\n\t\t\t\t\t$7/;
	# Ending on: (Year):
	s/(<citation class="(?:usage|publication)">)(.+)( \()(\d\d\d\d)(\))(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t$6/;
	
	
	
	# Reference & Literature sections:
	
	# References in text lacking specific headings marking them as references:
	unless (/<name|<citation|citation>/) {
		
		# Split out reference sections with specific headings:
		if (/(<references><(subH|h)eading>)(Reference|References|Literature|REFERENCES)((|:)<\/(subH|h)eading>)/) {
			# Add in first reference tag:
			s/(<\/(?:subH|h)eading>)/$1<reference>/;
			# Add in last reference tag:
			s/(\.)(<\/references>)/<\/reference>$2/;
			# Split references verion 1:
			s/(\. — )/<\/reference><reference>/g;
			# Split references version 2:
			s/(; )/<\/reference><reference>/g;
			
			
			# Atomization of these sections:
			# Split on year:
			s/( \()(\d\d\d\d(?:|[[:lower:]]))(\))/\n\t\t\t\t\t\t\t<refPart class="year">$2<\/refPart>/g;
			# Split off details:
			s/(<\/refPart>)( )(.+?)(<\/reference>)/$1\n\t\t\t\t\t\t\t<refPart class="details">$3<\/refPart>$4/g;
			# Split off volume:
			s/(\d+)(\n\t\t\t\t\t\t\t<refPart class="year">)/\n\t\t\t\t\t\t\t<refPart class="volume">$1<\/refPart>$2/g;
			# Split off authors:
			s/(<reference>)(.+?, .+? & .+?|.+?, .+?(, .+)+? & .+?)(, )/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>/g;
			s/(<reference>)(.+?, .+?)(, )/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>/g;
			# Split pubtitle and pubname:
			s/(<refPart class="author">.+?<\/refPart>)([[:upper:]].+?)(\. )(.+?)(\n)/$1\n\t\t\t\t\t\t\t<refPart class="pubtitle">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>$5/g;
			
			
			# Put closing reference tag on separate line:
			s/(<\/refPart>)(<\/reference>)/$1\n\t\t\t\t\t\t$2/g;
		}
		
		else {
		
		# For reference only; author name matching:
		# Author, Author-Author: 
		# ([[:upper:]]\p{Ll}\-\.]+)+
		# A. Author:
		# ([[:upper:]]\p{Ll}\-\.]+)+ ([[:upper:]]\p{Ll}\-\.]+)+
		# Author & Author:
		# ([[:upper:]]\p{Ll}\-\.]+)+ & ([[:upper:]]\p{Ll}\-\.]+)+
		# Author name finder, all author name formats (Author, Author-Author, A. Author, Author & Author):
		# ([[:upper:]]\p{Ll}\-\.]+)+(| (?:[[:upper:]]\p{Ll}\-\.]+)+| & (?:[[:upper:]]\p{Ll}\-\.]+)+(?:| (?:[[:upper:]]\p{Ll}\-\.]+)+))
			
		# Format: Author, Pubname Volume (Year) Details:
		s/(([[:upper:]]\p{Ll}\-\.]+)+(| (?:[[:upper:]]\p{Ll}\-\.]+)+| & (?:[[:upper:]]\p{Ll}\-\.]+)+(?:| (?:[[:upper:]]\p{Ll}\-\.]+)+)))(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(\d+)( \()(\d\d\d\d)(\) )(.+?)( \[|\]|;)/<references><reference>\n\t\t\t\t\t\t\t<refPart class="author">$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$11<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$12/;
		
		# Format: Pubname Volume (Year) Details:
		s/([[:upper:]][A-Z\p{Ll}\- \.\(\)]+)( )(\d+)( \()(\d\d\d\d)(\) )(.+?)( \[|\]|;)/<references><reference>\n\t\t\t\t\t\t\t<refPart class="pubname">$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$7<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$8/;
		}
	
		
	}
	else {
	}
	
	# Splitting out literature details:
	
	# Status:
	
	s/(, )((p\.|p\. )p\.|excl\. .+|non .+|for .+|nom\. illeg\.|in obs\.)(<\/refPart>)/<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">$2$4/g;
	
	
	# Actual details:
	s/(, )((f\.|pl\.|t\.) .+)(<\/refPart>)/<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$2$4/g;
	
	
	# Ending dot removal if ending on a digit:
	s/(\d+)(\.)(<\/refPart>)/$1$3/g;
	
	# Only a single page or a page-range:
	s/(<refPart class=")(details)(">)(\d+|\d+-\d+)(<\/refPart>)/$1pages$3$4$5/g;
	# Multiple pages or page ranges:
	s/(<refPart class=")(details)(">)((\d+, |\d+-\d+, )+(\d+|\d+-\d+))(<\/refPart>)/$1pages$3$4$7/g;
	
	# Remove eventual spaces in front of closing refPart tag:
	s/( )(<\/refPart>)/$2/g;

	
	
	
	

	print OUT $_;
}

close IN;
close OUT;