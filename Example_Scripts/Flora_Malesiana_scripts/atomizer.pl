#!/usr/bin/perl
# atomizer.pl
# Atomize literature and other remaining features (distribution, ecology/habitat, etc.) as far as possible.
use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	# TODO: 
	
	# 1) Handling of l.c. and ibid. buggy (don't know why, maybe OCR errors?), FIX.
	
	# 2) Author name mark-up:
	# - Modify author name mark-up to break at first comma, to prevent part of publication names to be seen as author names. 
	# - Also make this so author name mark-up is ONLY performed when the comma is present.
	# - AUTHOR NAMES are in ALL CAPS (plus dots, dashes, ampersands)
	# IMPORTANT: Maybe not, only goes wrong in some cases. Investigate those cases.
	
	# 3) Edition number/volume number split sometimes fails, FIX.
	
	# 4) Volume/Series differentiation sometimes fails, FIX.
	
	# 5) Handling of author names of inline literature references sometimes fails. FIX.
	
	
	
	
	# Nomenclature citations:
	
	# Fixing taxon statusses that were accidentally marked up as literature:
	s/(<citation class="publication">)(comb\. nov\.|stat\. nov\.|nom\. nov\.)(<\/citation>)/<name class="status">$2<\/name>/;
	
	# Fixing page numbers followed by dots:
	s/(\d)(\.)(<\/citation>)/$1$3/g;
	# Fixing edition number with no space between the abbreviation and the number:
	s/( ed\.)(\d)/$1 $2/g;
	
	
	
	
	# Removing "in" from publication citations that have different author than taxon author:
	# s/(<citation class="(publication)">)( in )([[:upper:]])/$1$4/;
	
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
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )((?<!ed\. )\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$9<\/refPart>\n\t\t\t\t\t\t$10/;
	
	# Format: Pubname ed. # (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )((ed\. |edition )\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$10<\/refPart>\n\t\t\t\t\t\t$11/;
	
	# Format: Pubname ed. #, Volume (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )((ed\. |edition )\d+)(, )(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$12<\/refPart>\n\t\t\t\t\t\t$13/;
	
	# Format: Pubname Volume, Issue (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(I|II|III|IV|V|VI|VII|VIII|IX|X|\d+)(, )(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$11<\/refPart>\n\t\t\t\t\t\t$12/;
	
	
	
	# Author present:
	# Format: Author, Pubname (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.]+)(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$9<\/refPart>\n\t\t\t\t\t\t$10/;

	# Format: Author, Pubname Volume (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.]+)(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )((?<!ed\. )\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$11<\/refPart>\n\t\t\t\t\t\t$12/;

	# Format: Author, Pubname ed. # (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.]+)(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )((ed\. |edition )\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$12<\/refPart>\n\t\t\t\t\t\t$13/;
	
	# Format: Author, Pubname ed. #, Volume (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.]+)(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )((ed\. |edition )\d+)(, )(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$10<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$12<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$14<\/refPart>\n\t\t\t\t\t\t$15/;
	
	# Format: Author, Pubname Volume, Issue (Year) Details:
	s/(<citation class="(usage|publication)">)([[:upper:]][A-Z\p{Ll}\- &\.]+)(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(I|II|III|IV|V|VI|VII|VIII|IX|X|\d+)(, )(\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$11<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$13<\/refPart>\n\t\t\t\t\t\t$14/;
	
	
	
	# Partial split of left-overs:
	
	# Ending on: , New ed. (Year) Details:
	s/(<citation class="(?:usage|publication)">)(.+)( |, )(new ed\.(?:| \d+))( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$8<\/refPart>\n\t\t\t\t\t\t\t$9/;
	# Ending on: Edition (Year) Details:
	s/(<citation class="(?:usage|publication)">)(.+)( |, )((?:ed\. |edition )\d+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$8<\/refPart>\n\t\t\t\t\t\t\t$9/;
	# Ending on: (Year) Details:
	s/(<citation class="(?:usage|publication)">)(.+)( \()(\d\d\d\d)(\) )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$6<\/refPart>\n\t\t\t\t\t\t$7/;
	# Ending on: (Year):
	s/(<citation class="(?:usage|publication)">)(.+)( \()(\d\d\d\d)(\))(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t$6/;
	
	# Ending on l.c. Details, with author preceding l.c.:
	s/(<citation class="(?:usage|publication)">)([[:upper:]][[:lower:]]+)(, )(l\.c\. )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$5<\/refPart>\n\t\t\t\t\t\t$6/;
	# Ending on l.c. Details, without author preceding l.c.:
	s/(<citation class="(?:usage|publication)">)(l\.c\. )(.+)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$3<\/refPart>\n\t\t\t\t\t\t$4/;
	
	# Ending on l.c.</citation>, with AUTHOR preceding l.c.:
	s/(<citation class="(?:usage|publication)">)([[:upper:]\. ]+)(, )(l\.c\.)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="">$4<\/refPart>\n\t\t\t\t\t\t$5/;
	
	# l.c. only, without anything preceding or following it:
	s/(<citation class="(?:usage|publication)">)(l\.c\.|ll\.cc\.)(<\/citation>)/$1\n\t\t\t\t\t\t\t<refPart class="">$2<\/refPart>\n\t\t\t\t\t\t$3/;
	
	

	
	# Further split of left-overs:
	
	# Starting with: Author Pubname:
	s/((?<!<\/refPart>\n\t\t\t\t\t\t\t)<refPart class="(?:pubname|)">(?!J\.))(Bl\.|King|(?:[[:upper:]]\. & |)[[:upper:]][[:upper:]\.& -]+?(?:f\.|))((?:,|) )((?:J\.|in (?:DC\. |)|)[[:upper:]][[:lower:]\.].+?<\/refPart>)(\n)/<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4$5/g;
	# Authors whose name starts with J.:
	s/((?<!<\/refPart>\n\t\t\t\t\t\t\t)<refPart class="(?:pubname|)">)(J\. J\. SMITH)((?:,|) )((?:J\.|in (?:DC\. |)|)[[:upper:]][[:lower:]\.].+?<\/refPart>)(\n)/<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4$5/g;
	
	
	# Starting with: Editor Pubname Volume (explicit Editor names):
	s/(<refPart class="(?:pubname|)">)((?: |)in )((?:Ait\.|Armitage & Burley|B\. & H\.|Back\.(?: & Bakh\.f\.|)|Banks & Sol\.|Beck|Bél\.|Benn\. & Brown|Bennett & R\.Br\.|Benth\. & Hook\.(?: |)f\.|Bory|BTH\.|Campbell|P\.S\.Chiu|Chowdhury & Ghosh|DC\.|Dallimore & Jackson|Delessert|Desv\.|De Vriese|Duperrey|E\. & P\.|Elmer|Engl(?:\.|er)|Fang|Fedde|Ferguson & Muller|Flinders|Forbes|Freyc\.|Gibbs|Graham|Hara|Hook\.(?:(?: |)f\.|)|HOOK\.|Houlston & Moore|Humbert|Hutch\.(?: & Dalz\.|)|Jacquem\.|K\. & V\.|K\.SCH\. & LAUT\.|K\.(?: |)Sch\. & (?:Hollr\.|Laut\.)|(?:Lauterb. & |)K\.Schum\.|Kiew et al\.|König & Sims|Koord\.|Kosterm\.|Lamb(?:\.|ert)|Lamk(?:\.|)|Laness\.|M\.H\.Lecomte|Leunis|Linn\.|Loudon|Masamune|Merr\.|Metcalfe|Meyen|Miq\.|Moritzi|Muller-Stoll & Mädel|Nakai & Honda|Perkins|Schrad\.|Seem\.|Stickman|Sw\.|Treseder|Trimen|Praglowski|R\. & S\.|R\.Br\.|Rech\.|Redoute|Rees|Rendle|Roxb\.|ROXB\.|Sarg(?:\.|ent)|Van Houtte|Vaughan c\.s\.|Wall\.|Walp\.|Whitmore|Willd\.|Willis|Womersley|Young & Seigler|Zoll\.)(?: \(ed(?:s|)\.\)|))((?:,|) )(.+?)( )((?<!ed\. )\d+<\/refPart>)(\n)/<refPart class="editors">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$7$8/g;
	# Starting with: Editor Pubname (explicit Editor names):
	s/(<refPart class="(?:pubname|)">)((?: |)in )((?:Ait\.|Armitage & Burley|B\. & H\.|Back\.(?: & Bakh\.f\.|)|Banks & Sol\.|Beck|Bél\.|Benn\. & Brown|Bennett & R\.Br\.|Benth\. & Hook\.(?: |)f\.|Bory|BTH\.|Campbell|P\.S\.Chiu|Chowdhury & Ghosh|DC\.|Dallimore & Jackson|Delessert|Desv\.|De Vriese|Duperrey|E\. & P\.|Elmer|Engl(?:\.|er)|Fang|Fedde|Ferguson & Muller|Flinders|Forbes|Freyc\.|Gibbs|Graham|Hara|Hook\.(?:(?: |)f\.|)|HOOK\.|Houlston & Moore|Humbert|Hutch\.(?: & Dalz\.|)|Jacquem\.|K\. & V\.|K\.SCH\. & LAUT\.|K\.(?: |)Sch\. & (?:Hollr\.|Laut\.)|(?:Lauterb. & |)K\.Schum\.|Kiew et al\.|König & Sims|Koord\.|Kosterm\.|Lamb(?:\.|ert)|Lamk(?:\.|)|Laness\.|M\.H\.Lecomte|Leunis|Linn\.|Loudon|Masamune|Merr\.|Metcalfe|Meyen|Miq\.|Moritzi|Muller-Stoll & Mädel|Nakai & Honda|Perkins|Schrad\.|Seem\.|Stickman|Sw\.|Treseder|Trimen|Praglowski|R\. & S\.|R\.Br\.|Rech\.|Redoute|Rees|Rendle|Roxb\.|ROXB\.|Sarg(?:\.|ent)|Van Houtte|Vaughan c\.s\.|Wall\.|Walp\.|Whitmore|Willd\.|Willis|Womersley|Young & Seigler|Zoll\.)(?: \(ed(?:s|)\.\)|))((?:,|) )(.+?<\/refPart>)(\n)/<refPart class="editors">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5$6/g;
	# Starting with: Author Editor:
	s/(<refPart class="author">(?:Bl\.|[[:upper:]\.& -]+(?:f\.|)|[[:upper:]][[:upper:][:lower:]\.& -]+(?:f\.|)))((?: |)in )((?:Ait\.|Armitage & Burley|B\. & H\.|Back\.(?: & Bakh\.f\.|)|Banks & Sol\.|Beck|Bél\.|Benn\. & Brown|Bennett & R\.Br\.|Benth\. & Hook\.(?: |)f\.|Bory|BTH\.|Campbell|P\.S\.Chiu|Chowdhury & Ghosh|DC\.|Dallimore & Jackson|Delessert|Desv\.|De Vriese|Duperrey|E\. & P\.|Elmer|Engl(?:\.|er)|Fang|Fedde|Ferguson & Muller|Flinders|Forbes|Freyc\.|Gibbs|Graham|Hara|Hook\.(?:(?: |)f\.|)|HOOK\.|Houlston & Moore|Humbert|Hutch\.(?: & Dalz\.|)|Jacquem\.|K\. & V\.|K\.SCH\. & LAUT\.|K\.(?: |)Sch\. & (?:Hollr\.|Laut\.)|(?:Lauterb. & |)K\.Schum\.|Kiew et al\.|König & Sims|Koord\.|Kosterm\.|Lamb(?:\.|ert)|Lamk(?:\.|)|Laness\.|M\.H\.Lecomte|Leunis|Linn\.|Loudon|Masamune|Merr\.|Metcalfe|Meyen|Miq\.|Moritzi|Muller-Stoll & Mädel|Nakai & Honda|Perkins|Praglowski|R\. & S\.|R\.Br\.|Rech\.|Redoute|Rees|Rendle|Roxb\.|ROXB\.|Sarg(?:\.|ent)|Schrad\.|Seem\.|Stickman|Sw\.|Treseder|Trimen|Van Houtte|Vaughan c\.s\.|Wall\.|Walp\.|Whitmore|Willd\.|Willis|Womersley|Young & Seigler|Zoll\.)(?: \(ed(?:s|)\.\)|)(?:(?:,|) |)<\/refPart>\n)/$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="editors">$3/g;
	
	
	
	# Split off notes following details:
	s/(<refPart class="details">.+?)(\([[:upper:][:lower:]\.' ,-]+\))(<\/refPart>)/$1$3\n\t\t\t\t\t\t\t<refPart class="notes">$2$3/g;
	
	
	# Split of specific publications that are annoying:
	# J. As. Soc. Beng.:
	s/(<refPart class="(?:pubname|)">(?:Pl\. |)J\. As\. Soc\. Beng\.)( )(\d+)(, )(i|ii|I|II)(<\/refPart>)/$1$6\n\t\t\t\t\t\t\t<refPart class="volume">$3$6\n\t\t\t\t\t\t\t<refPart class="part">$5$6/;
	# Nat. Pfl. Fam.:
	s/(<refPart class="(?:pubname|)">Nat\. Pfl\. Fam\.)( )(ed\. \d+)(, )(\d+b)(<\/refPart>)/$1$6\n\t\t\t\t\t\t\t<refPart class="edition">$3$6\n\t\t\t\t\t\t\t<refPart class="volume">$5$6/;
	# Nat. Pfl. Fam. Nachtr.:
	s/(<refPart class="(?:pubname|)">Nat\. Pfl\. Fam\.)( )(Nachtr\.)(<\/refPart>)/$1$4\n\t\t\t\t\t\t\t<refPart class="appendix">$3$4/;
	
	
	
	# Adds proper class to unidentified journals
	s/(<refPart class=")(">(?:(?:Pl\. |)J\. As\. Soc\. Beng\.|Nat\. Pfl\. Fam\.)<\/refPart>)/$1pubname$2/;
	
	
	
	
	# Reference & Literature sections:
	
	unless (/<name|<citation|citation>/) {
		
		# Split out reference sections with specific headings:
		if (/(<references><(subH|h)eading>)(Additional selected references|Reference|References|Literature|General literature|REFERENCES|References and Remarks|Sources)((|:)<\/(subH|h)eading>)/) {
			# Add in first reference tag:
			s/(<\/(?:subH|h)eading>)/$1<reference>/;
			# Add in last reference tag:
			s/(\.|\))(<\/references>)/<\/reference>$2/;
			# Split references verion 1:
			s/(\. — )/<\/reference><reference>/g;
			# Split references version 2:
			s/(; )/<\/reference><reference>/g;
			
			
			# Atomization of these sections:
			# Split on year:
			# Bracket version:
			s/( \()(\d\d\d\d(?:|[[:lower:]]))(\))/\n\t\t\t\t\t\t\t<refPart class="year">$2<\/refPart>/g;
			# Comma version:
			s/(, )(\d\d\d\d(?:|[[:lower:]]))(,)/\n\t\t\t\t\t\t\t<refPart class="year">$2<\/refPart>/g;
			
			
			# Split off details:
			s/(<\/refPart>)( )(.+?)(<\/reference>)/$1\n\t\t\t\t\t\t\t<refPart class="details">$3<\/refPart>$4/g;
			
			# Split off notes following details:
			s/(<refPart class="details">.+?)(\([[:upper:][:lower:]\. ,-]+\))(<\/refPart>)/$1$3\n\t\t\t\t\t\t\t<refPart class="notes">$2$3/g;
			
			# Split off volume:
			s/((?<!ed\. )\d+|\d\d\d\d-\d\d\d\d)(\n\t\t\t\t\t\t\t<refPart class="year">)/\n\t\t\t\t\t\t\t<refPart class="volume">$1<\/refPart>$2/g;
			
			
			# Split off authors:
			# Older volumes:
			s/(<reference>)([[:upper:]][[:upper:]\., &-]+(?: c\.s\.| et al\.|f\.|))( in )/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>$3/g;
			s/(<reference>)([[:upper:]][[:upper:]\., &-]+(?: c\.s\.| et al\.|f\.|))(, )/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>/g;
			
			# Newer volumes:
			s/(<reference>)(.+?, .+? & .+?|.+?, .+?(, .+)+? & .+?)(, )/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>/g;
			s/(<reference>)(.+?, .+?)(, )/$1\n\t\t\t\t\t\t\t<refPart class="author">$2<\/refPart>/g;
			
			
			# Split off pubname:
			s/(<refPart class="author">.+?<\/refPart>|<reference>)((?:[[:upper:]]|(?: |)in ).+?)((?:<\/reference><\/references><\/string>|<\/reference><reference>|)\n)/$1\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>$3/g;
			
			
			# Split off editors preceding pubname (explicit naming of editors):
			s/(<refPart class="pubname">)((?: |)in )((?:B\. & H\.|Beck|Campbell|Cauwet-Marc & Carbonnier|DC\.|E\. & P\.|Engler|Ferguson & Muller|Flinders|Graham|Harborne & Swain|Heywood|Hook\.|Metcalfe|Muller-Stoll & Mädel|Vaughan c\.s\.|Willis|Young & Seigler)(?: \(ed(?:s|)\.\)|))((?:,|) )(.+?<\/refPart>|<reference>)(\n)/<refPart class="editors">$3<\/refPart>\n\t\t\t\t\t\t\t$1$5$6/g;
			# Split off editors preceding pubname (non-explicit naming of editors):
			s/(<refPart class="pubname">)([[:upper:]\. ]+(?: c\.s\.|) \(ed(?:s|)\.\))(, )(.+?<\/refPart>|<reference>)(\n)/<refPart class="editors">$2<\/refPart>\n\t\t\t\t\t\t\t$1$4$5/g;
			
			# Split off edition:
			s/(<refPart class="pubname">[[:upper:][:lower:]\. ]+(?:, |))(ed\. \d+|\d(?:st|nd|rd|th) ed\.)(?:(?:,|) |,|)(<\/refPart>)(\n)/$1$3\n\t\t\t\t\t\t\t<refPart class="edition">$2$3$4/g;
			
			
			
			
			# Split pubtitle and pubname:
			s/(<refPart class="author">.+?<\/refPart>)([[:upper:]].+?)(\. )(.+?)(\n)/$1\n\t\t\t\t\t\t\t<refPart class="pubtitle">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>$5/g;
			
			
			# Split off section information:
			s/(<refPart class="pubname">.+?)((?<!Trav\. )(?:S|s)ect\..+?)(<\/refPart>)(\n)/$1$3\n\t\t\t\t\t\t\t<refPart class="section">$2$3$4/g;
			
			# Split off series information:
			s/(<refPart class="pubname">.+?)((?:S|s)(?:e|é)r\. (?:\d|[[:upper:]]).+?)(<\/refPart>)(\n)/$1$3\n\t\t\t\t\t\t\t<refPart class="series">$2$3$4/g;
			
			# Split off appendices:
			s/(<refPart class="pubname">.+?)(Suppl\.)(?:(?:,|) |,|)(<\/refPart>)(\n)/$1$3\n\t\t\t\t\t\t\t<refPart class="appendix">$2$3$4/g;
			
			
			
			# Split off l.c. + details:
			s/(<\/refPart>)(l\.c\.)( )(.+?)(<\/reference>)/$1\n\t\t\t\t\t\t\t<refPart class="">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$4<\/refPart>$5/g;
			
			
			# Split off notes following details:
			s/(<refPart class="details">.+?)(\([[:upper:][:lower:]\.' ,-]+\))(<\/refPart>)/$1$3\n\t\t\t\t\t\t\t<refPart class="notes">$2$3/g;
			
			
			
			# Put closing reference tag on separate line:
			s/(<\/refPart>)(<\/reference>)/$1\n\t\t\t\t\t\t$2/g;
			
			
			# Fixing wrongly atomised exceptions:
			# Author + pubname wrongly recognised as only pubname:
			s/(<refPart class="pubname">)(Baumann-Bodenheim|Beccari|Behnke|Brass|Dilcher & Dolph|Eyde & Tseng|Grushvitzky|H\. J\. Lam|Ridley|Steup)(?:, )(.+?<\/refPart>)/<refPart class="author">$2<\/refPart>\n\t\t\t\t\t\t\t$1$3/g;
			# Author + pubname wrongly recognised as only author:
			s/(<refPart class="author">)(Bui Ngoc-Sanh|Davis|Docters van Leeuwen|Frodin|Halle & Oldeman)(?:, )(.+?<\/refPart>)/$1$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$3/g;
			
			
			
			
			
			
			
		}
		
		else {
		
		
		# Reference list with references marked with <reference> manually prior to running script:
		
		# Format: <reference>Author, Initials, Pubname Volume (Year) Pages:
		s/(^)(<reference>)([[:upper:]][[:lower:]]+, [[:upper:]][[:upper:]\. &-]+(?: et al\.|))((?:,|) )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(\d+)( \()(\d\d\d\d)(\) )((?:\d+-|)\d+(?:(?:, \d+)+|))( \[|\]|;|,|\)|\.)/$1\t\t\t\t\t\t$2\n\t\t\t\t\t\t\t<refPart class="author">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$11<\/refPart>\n\t\t\t\t\t\t$12/;
		
		
		
		
		# Minor fix:
		s/(\.)(<\/reference>)/$2/;
		
		
		
		# References in text lacking specific headings marking them as references:
		
		# For script-writer reference only; author name matching:
		# Author, Author-Author: 
		# ([[:upper:]]\p{Ll}\-\.]+)+
		# A. Author:
		# ([[:upper:]]\p{Ll}\-\.]+)+ ([[:upper:]]\p{Ll}\-\.]+)+
		# Author & Author:
		# ([[:upper:]]\p{Ll}\-\.]+)+ & ([[:upper:]]\p{Ll}\-\.]+)+
		# Author name finder, all author name formats (Author, Author-Author, A. Author, Author & Author):
		# ([[:upper:]]\p{Ll}\-\.]+)+(| (?:[[:upper:]]\p{Ll}\-\.]+)+| & (?:[[:upper:]]\p{Ll}\-\.]+)+(?:| (?:[[:upper:]]\p{Ll}\-\.]+)+))
		
		
		
		# Format: AUTHOR, Pubname, Edition, Year, Pages:
		s/([[:upper:]][[:upper:]\. &-]+(?: et al\.|))(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)(, )((?:E|e)d\. \d+)(, )(\d\d\d\d)(, )((?:\d+-|)\d+(?:(?:, \d+)+|))( \[|\]|;|,|\))/<references><reference>\n\t\t\t\t\t\t\t<refPart class="author">$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="edition">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$9<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$10/g;
		
		
		# Format: AUTHOR, Pubname Volume, Year, Pages:
		s/([[:upper:]][[:upper:]\. &-]+(?: et al\.|))(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(\d+)(, )(\d\d\d\d)(, )((?:\d+-|)\d+(?:(?:, \d+)+|))( \[|\]|;|,|\))/<references><reference>\n\t\t\t\t\t\t\t<refPart class="author">$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$9<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$10/g;
		
		# Format: AUTHOR, Pubname Volume (Year) Pages (notes):
		s/([[:upper:]][[:upper:]\. &-]+(?: et al\.|))((?:,|) )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(\d+)( \()(\d\d\d\d)(\) )((?:\d+-|)\d+(?:(?:, \d+)+|))( \()([[:upper:][:lower:] -]+)(?:\))(;|\.| )/<references><reference>\n\t\t\t\t\t\t\t<refPart class="author">$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="notes">$11<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$12/g;
		
		# Format: AUTHOR, Pubname Volume (Year) Pages:
		s/([[:upper:]][[:upper:]\. &-]+(?: et al\.|))((?:,|) )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(\d+)( \()(\d\d\d\d)(\) )((?:\d+-|)\d+(?:(?:, \d+)+|))( \[|\]|;|,|\)|\.)/<references><reference>\n\t\t\t\t\t\t\t<refPart class="author">$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$9<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$10/g;
		
		
		# Format: Author, Pubname Volume (Year) Details:
		s/(([[:upper:]]\p{Ll}\-\.]+)+(| (?:[[:upper:]]\p{Ll}\-\.]+)+| & (?:[[:upper:]]\p{Ll}\-\.]+)+(?:| (?:[[:upper:]]\p{Ll}\-\.]+)+)))(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( )(\d+)( \()(\d\d\d\d)(\) )(.+?)( \[|\]|;)/<references><reference>\n\t\t\t\t\t\t\t<refPart class="author">$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$9<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$11<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$12/;
		
		
		
		# Format: AUTHOR, Pubname, Year, Pages:
		s/([[:upper:]][[:upper:]\. &-]+(?: et al\.|))(, )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)(, )(\d\d\d\d)(, )((?:\d+-|)\d+(?:(?:, \d+)+|))( \[|\]|;|,|\))/<references><reference>\n\t\t\t\t\t\t\t<refPart class="author">$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$7<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$8/g;
		
		# Format: AUTHOR, Pubname (Year) Pages (notes):
		s/([[:upper:]][[:upper:]\. &-]+(?: et al\.|))((?:,|) )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( \()(\d\d\d\d)(\) )((?:\d+-|)\d+(?:(?:, \d+)+|))( \()([[:upper:][:lower:] -]+)(?:\))(\.| )/<references><reference>\n\t\t\t\t\t\t\t<refPart class="author">$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$7<\/refPart>\n\t\t\t\t\t\t\t<refPart class="notes">$9<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$10/g;
		
		# Format: AUTHOR, Pubname (Year) Pages:
		s/([[:upper:]][[:upper:]\. &-]+(?: et al\.|))((?:,|) )([[:upper:]][A-Z\p{Ll}\- &\.\(\)]+)( \()(\d\d\d\d)(\) )((?:\d+-|)\d+(?:(?:, \d+)+|))( \[|\]|;|,|\)|\.| )/<references><reference>\n\t\t\t\t\t\t\t<refPart class="author">$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$7<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$8/g;
		
		# Newer volumes (explicit author names):
		
		# Format: (Author, Pubname Volume, Year: Details):
		s/(\((?:see |))(Boorsma|Gresshoff|Jebb|McRae et al\.|Myers et al\.|Prance|Schneider|Whitmore)(, )([[:upper:]][A-Z\p{Ll}\- \.\(\)]+)( )(\d+)(, )(\d\d\d\d)(: )(.+?)( \[|\]|;|\))/$1<references><reference>\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$10<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$11/g;
		
		# Format: (Author, Pubname, Year: Details):
		s/(\((?:see |))(Jebb|McRae et al\.|Myers et al\.|Prance|Whitmore)(, )([[:upper:]][A-Z\p{Ll}\- \.\(\)]+)(, )(\d\d\d\d)(: )(.+?)( \[|\]|;|\))/$1<references><reference>\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pubname">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$8<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$9/g;
		
		
		
		
		# Older volumes:
		
		
		# Format: Pubname Series, Volume, Year, Pages:
		s/(\((?:(?:C|c)f\. |))([[:upper:]][A-Z\p{Ll}\- \.\(\)]+?)( )(I|II)(, )(\d+)(, )(\d\d\d\d)(, )((?:\d+-|)\d+(?:(?:, \d+)+|))( \[|\]|;|,|\))/$1<references><reference>\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="series">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$10<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$11/g;
		
		# Format: Pubname Volume,Issue, Year, Pages:
		s/(\((?:(?:C|c)f\. |))([[:upper:]][A-Z\p{Ll}\- \.\(\)]+?)( )(\d+)(,(?: |))(\d+)(, )(\d\d\d\d)(, )((?:\d+-|)\d+(?:(?:, \d+)+|))( \[|\]|;|,|\))/$1<references><reference>\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$8<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$10<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$11/g;
		# Format: Pubname Volume,Issue, Year:
		s/(\((?:(?:C|c)f\. |))([[:upper:]][A-Z\p{Ll}\- \.\(\)]+?)( )(\d+)(,(?: |))(\d+)(, )(\d\d\d\d)( \[|\]|;|,|\))/$1<references><reference>\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="issue">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$8<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$9/g;
		
		# Format: Pubname Volume, Year, Pages:
		s/(\((?:(?:C|c)f\. |))([[:upper:]][A-Z\p{Ll}\- \.\(\)]+?)( )(\d+)(, )(\d\d\d\d)(, )((?:\d+-|)\d+(?:(?:, \d+)+|))( \[|\]|;|,|\))/$1<references><reference>\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$8<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$9/g;
		
		# Format: Pubname Year, Pages:
		s/(\((?:(?:C|c)f\. |))([[:upper:]][A-Z\p{Ll}\- \.\(\)]+?)( )(\d\d\d\d)(, )((?:\d+-|)\d+(?:(?:, \d+)+|))( \[|\]|;|,|\))/$1<references><reference>\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="pages">$6<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$7/g;
		
		
		# Newer volumes:
		# Format: Pubname Volume (Year) Details:
		s/([[:upper:]][A-Z\p{Ll}\- \.\(\)]+)( )(\d+)( \()(\d\d\d\d)(\) )(.+?)( \[|\]|;)/<references><reference>\n\t\t\t\t\t\t\t<refPart class="pubname">$1<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$3<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$5<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$7<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$8/;
		
		# Format: (Pubname Volume, Year: Details):
		s/(\((?:see |))([[:upper:]][A-Z\p{Ll}\- \.\(\)]+)( )(\d+)(, )(\d\d\d\d)(: )(.+?)( \[|\]|;|\))/$1<references><reference>\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$6<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$8<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$9/g;
		
		# Format: (Pubname, Year: Details):
		s/(\((?:see |))([[:upper:]][A-Z\p{Ll}\- \.\(\)]+)(, )(\d\d\d\d)(: )(.+?)( \[|\]|;|\))/$1<references><reference>\n\t\t\t\t\t\t\t<refPart class="pubname">$2<\/refPart>\n\t\t\t\t\t\t\t<refPart class="year">$4<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$6<\/refPart>\n\t\t\t\t\t\t<\/reference><\/references>$7/g;
		
		
		
		# Adding in author for references between brackets following author name:
		# ALL CAPS author name version:
		s/([[:upper:]][[:upper:]\. &-]+(?: et al\.|C\.S\.|))( \()(<references><reference>)/$1$2$3\n\t\t\t\t\t\t\t<refPart class="author">$1<\/refPart>/g;
		# Normal version (explicit author names due to chance of grabbing taxon names or other stuff instead...):
		s/(De Jussieu|J\.R\. & G\. Forster|Linnaeus|Miers|Mori et al\.|Payens)( \((?:see |))(<references><reference>)/$1$2$3\n\t\t\t\t\t\t\t<refPart class="author">$1<\/refPart>/g;
		
		
		}
	
		
	}
	else {
	}
	
	
	
	# Splitting out literature details:
	
	# Status:
	s/(, )((?:p\.|p\. )p\.(?:.+?|)|excl\. .+|non .+|for .+|nom\. (?:illeg(?:it|)\.(?:.+?|)|inval\.|cons\.|nud\.|rej(?:ic|)\.|superfl\.|syn\.)|incl\. (?:f|ssp|spp|var)\..+?|nomen(?:, in sched\.|\.|.+?|)|in obs\.|in syn(?:on|)\.|pr(?:\.|o) syn\.|pro (?:nomen|parte|specim|stirp).+?|quae est.+?|quoad (?:nomen|specim|typum|.+?)(?:\.|)|sphalma(?: .+?|))(?:\.(?: |)|(?:,|) |,|)(<\/refPart>)/<\/refPart>\n\t\t\t\t\t\t\t<refPart class="status">$2$3/g;
	
	
	# Details trailing references:
	s/(<\/reference><\/references>)(, )((?:f(?:ig|)\.|map(?:s|)|no|pl\.|t(?:ab|)\.) .+?|(?:biblio.+?|f(?:ig|)\.|illus\.|pl\.|t(?:ab|)\.|tt\.)|\d+ (?:fig(?:s|)|map(?:s|)|pl)\.(?:.+?|))(\)|\.|;)/\t<refPart class="details">$3<\/refPart>\n\t\t\t\t\t\t$1$4/g;
	# Actual details:
	s/(, )((?:f(?:ig|)\.|map(?:s|)|no|pl\.|t(?:ab|)\.) .+|(?:biblio.+?|f(?:ig|)\.|illus\.|pl\.|t(?:ab|)\.|tt\.)|\d+ (?:fig(?:s|)|map(?:s|)|pl)\.(?:.+?|))(<\/refPart>)/<\/refPart>\n\t\t\t\t\t\t\t<refPart class="details">$2$3/g;
	
	# Ending dot removal if ending on a digit:
	s/(\d+)(\.(?: |)|(?:,|) |,|)(<\/refPart>)/$1$3/g;
	
	# Only a single page, two pages or a page-range:
	s/(<refPart class=")(details)(">)(\d+|\d+ & \d+|\d+-\d+)(?: |)(<\/refPart>)/$1pages$3$4$5/g;
	# Multiple pages or page ranges:
	s/(<refPart class=")(details)(">)((?:\d+, |\d+-\d+(?:, | & ))+(?:\d+|\d+-\d+))(?: |)(<\/refPart>)/$1pages$3$4$5/g;
	
	# Remove eventual spaces or commas in front of closing refPart tag:
	s/((?:,|) |,)(<\/refPart>)/$2/g;
	
	
	# Removing closing and opening <references> tags when references follow each other:
	s/(<\/reference>)(<\/references>; <references>)(<reference>)/$1$3/g;
	
	
	# Fixes:
	# Pubnames with volume number following that has n. preceding the number:
	s/(<refPart class="pubname">.+?)( )(n\.)(<\/refPart>\n\t\t\t\t\t\t\t<refPart class="volume">)(\d+)/$1$4$3 $5/g;
	
	
	
	# Distribution Atomisation:
	if (/\t\t\t\t<string><(?:subH|h)eading>(?:Distr(?:\.|ibution)(?:\.(?: |)|)|DISTRIBUTION)<\/(?:subH|h)eading>/) {
		
		
		
		# Global:
		s/(Antarctic|(?:nearly c|C)osmopolitan|Neotropical regions|(?:N|n)eotropic(?:al|s)|(?:(?:T|t)ropical and subtropical (?:areas|regions) of the (?:Old and |)|)New World(?:s|)(?: tropics(?: and subtropics|)|)|(?:New and |)Old World(?:s|)(?: tropics and subtropics|)|Paleotropics|(?:P|p)antropic(?:al|s)(?: and (?:-|)subtropic(?:al|s)|)|pansubtropic(?:al|s)|tropic(?:al|s) and subtropic(?:al|s) (?:regions |)of the New and Old Worlds|temperate zones of both hemispheres|northern temperate regions|(?:(?:eastern |)Old|New) World(?: tropics|)|(?:(?:N|n)orthern|(?:S|s)outhern|N\.|S\.) (?:H|h)emisphere|worldwide)/<distributionLocality class=\"world\">$1<\/distributionLocality>/g;
		
		# Oceanic Regions:
		s/(Caribbean(?: region|)|(?:trans-|)Pacific(?: islands|)|Polynesia)/<distributionLocality class=\"oceanic region\">$1<\/distributionLocality>/g;
		
		
		# Continental Regions + continents:
		s/((?:N(?:\.|) |NE(?:\.|) |SE(?:\.|) |E(?:\.|) |Eastern |Indo(?:-|)|tropical |eastern |western |northern |southern |)Australia|Australasia|(?:Central |continental |tropical and southern |NE(?:\.|) |N(?:\.|) |S(?:\.|) |(?:S|s)outh(?:ern| & Central|) |(?:T|t)ropical |(?:tropical |)W(?:\.|) |West |East |eastern |western |northern |)Africa(?:n highlands|)|(?:(?:South and |)C(?:entral|\.|) |C(?:\.|) (?:and|to) (?:northern |)S(?:\.|) |Latin |(?:(?:tropical |)Central and |northern |(?:Tropical and sub|T|t)ropical |)South |(?:(?:continental|(?:N|n)orthern|northeastern|tropical) |)S(?:\.|) |(?:tropical and sub|)(?:T|t)ropical (?:and temperate |)|North |NE(?:\.|) |)America(?:n highlands|)|(?:(?:E(?:\.|) |sub|)tropical |SE(?:\.|) |NE(?:\.|) |E(?:\.|) |W(?:\.|) |S(?:\.|) |N(?:\.|) |Northeast |Southeast |East |eastern |western |northern |southern |)Asia|(?:(?:E(?:\.|) |sub|)tropical |SE(?:\.|) |NE(?:\.|) |E(?:\.|) |W(?:\.|) |S(?:\.|) |N(?:\.|) |Northeast |Southeast |East |eastern |western |northern |southern |)Europe|Indo-Pakistan subcontinent)/<distributionLocality class=\"continental region\">$1<\/distributionLocality>/g;
		
		# Separates the continents from the continental regions:
		s/(<distributionLocality class=")(continental region)(">)((?:South |S(?:\.|) |North |N(?:\.|) |)America|Australia|Africa|Asia|Europe)(<\/distributionLocality>)/$1continent$3$4$5/g;
		
		
		# Regions + Countries:
		s/(Admiralty(?: Is(?:land(?:s|)|\.)| Group)|Afghanistan|Alor|(?:western |)Amazonian basin|Amazon region|E(?:\.|) and central Amazon|(?:western part of Brazilian |)Amazonia(?!n)|secondary forests outside the Amazonian region|Ambon|Anambas Is\.|Andaman(?: Is(?:\.|lands)|s|)|(?:W(?:\.|) to the foothills of the |)Andes(?: Mts\.|)|Angola|(?:Greater |Lesser |)Antilles|Arabia|(?:Central |north-central |northern |)Argentin(?:a|e)|Arnhem Land|Aru Is(?:\.|lands)|Assam|Atjeh|Babar|Bahamas|Bahama Islands|Balabac|Bali|Bancalan I\.|Banda|Bangladesh|Banka|Banks Is(?:\.|land)|Basilan|Batanta Is(?:\.|land)|Batjan|Batudaka Is(?:\.|land)|Bawean|Belize|Bengal|Bhutan|Biak Is(?:\.|land)|Biliran|Billiton|Bintulu|Bisaya Islands|Bismarck(?: Arch(?:\.|ipelago)|s)|Bohol|(?:Amazonian |Andes of northern |central |north-eastern |south to |N(?:\.|) |)Bolivia|Bonin Island|(?:N(?:\.|) |NE(?:\.|) |SE(?:\.|) |W(?:\.|) |)Borneo|(?:Mt\. |)Bougainville|(?:(?:central to eastern |northern parts of |)Amazonian |eastern central |(?:western and |)(?:N|n)orthern (?:half of |)|northeast |north(?:-|)western |(?:eastern and |)southern |southeastern |(?:E|e)astern |N(?:\.|) |NE(?:\.|) |W(?:\.|) |E(?:\.|) |S(?:\.|) |(?:Western catchment of |lower |)Amazon river-basin (?:in|of) |)Brazil|Brunei|Bukit Raya|Bukit Timah|Bunguran|(?:N(?:\.|) |S(?:\.|) |Southern |Northern |Peninsular |Lower |Upper |)Burma(?!nniaceae)(?!nnia)|Buru|Buton I(?:s|)(?:\.|land)|(?:lower |whole |)Amazon river-basin|Cagayan Sulu|southern California|Cambodia|Cameron Highlands|Carolines|Caroline Islands|(?:NE(?:\.|) |N(?:\.|) |S(?:\.|) |SE(?:\.|) |SW(?:\.|) |Central |southern half of |)Celebes|(?:SE |)Ceram|Ceylon|(?:southern |)Chile|(?:S |SE(?:\.|) |SW(?:\.|) |South |S(?:\.|) |Indo-|)China|Christmas Is(?:\.|land)|(?:Pacific coast of |(?:E|e)astern |NE(?:\.|) |SE(?:\.|) |(?:extreme |)S |)Colombia|Comores|Cook Is\.|(?:north of |)Costa Rica|Cuba|Cuyuni-Mazaruni Region|D’Entrecasteaux Islands|Dominican Republic|(?:Amazonian (?:lowlands of |)|eastern |western |)Ecuador|Efate|Enggano|England|Ethiopia|Fiji(?: Islands|)|(?:W |)Flores|Formosa|G\. Leuser Nat\. Res\.|Gajo(?: L|l)and(?:en|s)|Goodenough Island|Gran Sabana|Guadalcanal|Guam|Guinaras|Guatemala|Guinea Bissau|Guinea|Guyana-Venezuela border|(?:central and coastal |)French Guiana|(?:SW |)Guianas|Venezuelan Guayana|Guayana Highlands|(?:western |S(?:\.|) |)Guyana|Halmahera|(?:tropical W(?:\.|) |E(?:\.|) |)Himalaya(?:s| region|)|Hispaniola|Honduras|Honshu|Hong(?:k| K)ong|(?:W(?:\.|) |NE(?:\.|) |S(?:\.|) |SW(?:\.|) |South |)India|(?:East|West) Indies|Indochina|Indomalaysia|Indo-Malaya(?:n region|)|Indonesia|Irano-Turanian regions|(?:NW |)Irian Jaya|Israel|Jamaica|(?:S |)Japan(?!ese)|Japen Is(?:\.|land)|(?:W(?:\.|) |E(?:\.|) |East |West(?: & Central|) |(?:West and |)Central |)Java|Jolo|Kai Is(?:\.|lands)|(?:NE(?:\.|) |E(?:\.|) |SE(?:\.|) |W(?:\.|) |Central |)Kalimantan|Kangean Is(?:\.|land)|Kapit|Kedah|Kelantan|Key Is(?:\.|lands)|Kolombangara|Korea|Kyushu|Landak|Langkawi(?: Is(?:\.|land)|)|Laos|Leyte|Lihir Island|Lingga Is\.|Lizard Is\.|Lombok|Lord How Is(?:\.|land)|Loreto|Los Llanos|Louisiade Is(?:\.|lands)|(?:S |(?:S|s)outh(?:ern|) |(?:N|n)orth(?:ern|) |)Luzon|(?:NE(?:\.|) |)Madagascar|Madura|(?:W |)Malay Peninsula|Malaya|(?:W(?:\.|) |(?:Northern |Southern |Eastern |Western |)Peninsular |)Malaysia|(?:E |W(?:\.|) |East(?:ern|) |Indo(?:-|)|(?:W|w)est(?:ern|) |lowland tropics in |)Malesia(?!n)|Manado|Manggarai|Manokwari|Manus Is(?:\.|land)|Marianas(?: Is(?:\.|lands)|)|Mauritius|Medan|the Mediterranean|Melanesia|Mentawi Is(?:\.|lands)|(?:Central |C |northern |(?:S|s)outhern |NW(?:\.|) |western |(?:E and |)S |)Mexico|Micronesia|Minahassa|Minahasa|(?:eastern |)Mindanao|Mindoro|Misima I\.|Misool|(?:N\. |S\. |)Moluccas|Morotai|Mts (?:Malabar|Merbabu)|Myanmar|Natuna Is(?:\.|land)|Negros|Nepal|New Britain|(?:W |E(?:\.|) |NE(?:\.|) |SE(?:\.|) |(?:NW\. |Northern |Western |Eastern |)Papua |NW\. |Northern |West(?:ern|) |)New Guinea|New Hanover|New Hebrides|New Ireland|New South Wales|New Zealand|Nias I\.|Nicaragua|(?:Andaman & |)Nicobar Is(?:\.|lands)|Norfolk I(?:s|)(?:\.|land)|Obi Is(?:\.|land)|(?:(?:U|u)pper |)Orinoco R\.|Oso Peninsula|Pacific (?:area|Islands)|Padang Highlands|Pakaraima Mts\.|Pakistan|Palau|Palawan|Panama|Panay|Panching|(?:N(?:\.|) |)Paraguay|Patagonia|Penang|Perlis|(?:(?:northern |)Amazonian |eastern |northern |extreme N |NE(?:\.|) |E(?:\.|) |)Peru|(?:Central & S. |)Philippines|Upper Potaro|Pulau Tioman|(?:NE(?:\.|) |N(?:\.|) |)Queensland|Rapa|Rio Branco|Rio Madeira|Río Negro|Riouw Archipelago|Riouw-Lingga Islands|Roma|Rossel I\.|Rota|Rotuma Is(?:\.|land)|(?:S\. |)R(?:i|y)u(?: |)k(?:i|y)u Is(?:(?:l|)\.|lands)|Sabah|Saint Helena|Saipan|Salawati|Samar|Samoa|Santa Cruz Is(?:\.|land)|Sarawak|Schouten Is(?:\.|land)|Senegal|(?:W |)Sepik|Serra do Sol|Seychelles|Siam|Sibolangit|Sibuyan|Sierra Leone|Shikoku|Sikkim|Simalur(?: Is(?:\.|land)|)|(?:(?:S|s)outh(?:ern|) |Coastal areas of )Florida|Singapore|Sino-Himalayan region|Society Is\.|Solomon(?:s| Islands| Is\.)|Sri Lanka|Sudest Is(?:\.|land)|(?:SE |)Sulawesi|Sula Is(?:\.|lands)|Sulu Arch(?:\.|ipelago)|Sulu Is(?:\.|lands)|(?:NE(?:\.|) |SE(?:\.|) |N(?:\.|) |S(?:\.|) |Central |Northern |)Sumatra|Sumba(?:wa|)|Lesser Sunda Is(?:\.|lands)|Surigao|(?:N |)Suriname|Tahiti|Talaud(?: Is(?:\.|lands)|)|Taiwan|Tanimbar (?:& Kei |)Is(?:\.|lands)|Kei Is\.|Tasmania|Tawitawi|Tenasserim|Ternate|(?:N(?:\.|) |S(?:\.|) |E(?:\.|) |North |Peninsular |)Thailand|Ticao|Timor|(?:Botel |)Tobago|Tonga|Tonkin|Trinidad|(?:(?:S|s)outhern |southwestern |SW(?:\.|) |)United States|Uruguay|(?:northeastern |south(?:ern|) and eastern |southern |)U\.S\.A(?:\.|)|(?:eastern |)U\.S\.S\.R\.|Vanuatu|Venezuelan Amazon|(?:Amazonian |Guayana Highlands (?:in|of) |(?:E|e)astern |northern |northern and eastern |(?:Central and |)S |SE(?:\.|) |NW(?:\.|) |W(?:\.|) |Upper Amazonian forests of |Llanos of |northern |)Venezuela|(?:N |S(?:\.|) |)Vietnam|Waigeo Is(?:\.|land)|Wetar|Woodlark Is(?:\.|land)|Yapen|Yemen)/<distributionLocality class=\"region\">$1<\/distributionLocality>/g;
		
		# Separates the countries from the regions:
		s/(<distributionLocality class=")(region)(">)(Afghanistan|Arabia|Argentin(?:a|e)|Bahamas|Bahama Islands|Bangladesh|Belize|Bengal|Bhutan|Bolivia|Brazil|Brunei|Burma|Cambodia|Ceylon|Chile|China|Colombia|Comores|Costa Rica|Ecuador|England|Ethiopia|Fiji(?: Islands|)|French Guiana|Guyana|Honduras|India|Indonesia|Israel|Japan|Korea|Laos|Madagascar|Malaysia|Mauritius|Mexico|Micronesia|Myanmar|Nepal|New Hebrides|New Zealand|Nicaragua|Pakistan|Palau|Panama|Paraguay|Peru|Philippines|Samoa|Senegal|Seychelles|Siam|Sierra Leone|Singapore|Solomon(?:s| Islands)|Sri Lanka|Suriname|Thailand|U\.S\.A(?:\.|)|U\.S\.S\.R\.|Vanuatu|Venezuela|Vietnam|West Indies|Yemen)(<\/distributionLocality>)/$1country$3$4$5/g;
		
		
		# State:
		s/(Acre|Amap(?:r|)(?:a|á)|Amazonas|Bahia|Bol(?:í|i)var|Ceará|Chiapas|Florida|Hawaii|Johore|Lara|Malacca|Maranhão|Maryland|Mat(?:t|)o Grosso|Minas Gerais|Negri Sembilan|Oaxaca|Pahang|Parana|Pa(?:r|)rá|Perak|Pernambuco|Portuguesa|Rio Grande do Sul|Rondônia|(?:Terr. |)Roraima|Santa Catarina|Selangor|Tocantins|Tráchira|T(?:e|)rengganu|Veracruz)/<distributionLocality class=\"state\">$1<\/distributionLocality>/g;
		
		
		# Territory:
		s/(Annam|Puerto Rico)/<distributionLocality class=\"territory\">$1<\/distributionLocality>/g;
		
		
		# Provinces:
		s/(Agusan Prov\.|Annobon|Cabinda|Camiguin de Mindanao|Catanduanes|Cape Province|Cebu|Cuanza|Estuaire|Fujian|Galápagos|Guangdong|Guangxi|Guizhou|Hainan|Hunan|Ilocos Norte Prov\.|Jiangxi|Jujuy|Kalteng(?: Prov(?:\.|ince)|)|Kasaï|Kwangsi|Kwangtung|Kweichou|Lanao(?: Prov(?:\.|ince)|)|Lunda|Madang(?: Prov(?:\.|ince)|)|Milne Bay(?: Prov(?:\.|ince)|)|Morobe(?: Prov(?:\.|ince)|)|Setchuan|Yunnan|Zambales Province)/<distributionLocality class=\"province\">$1<\/distributionLocality>/g;
		
		# Districts:
		s/((?:Kapit|Keningau|Lundu|Miri|Sorong) Distr\.)/<distributionLocality class=\"district\">$1<\/distributionLocality>/g;
		
		
		# Localities:
		s/(Asahan|Cabadbaran|Chawng|Chittagong|Darwin|Djambi|Sylhet|G\. Pueh|G\. Sago|Mt(?:s|) (?:Apo|Ardjuno|Banajao|Bangeta|Batulanteh|Bellenden-Ker|Biang|Buduk Rakik|Cameroun|Capella|Dayman|Dempo|Dieng|Dingalang|Dulit|Giluwe|Gitinggiting|Goliath|Hori|Idjen|Iraya|Kambuno|Kasian|Katanglad|Kawi|Kerintji|Kinabalu|Lamongan|Lawu|Lewis|Liang Ga-gang|Malabar|Ma(?:t|)tang|Mulu|Murud|Nettoti|Nokilalaki|Ophir|Palimasan|Papandayan|Piapi|Poi|Polis|Poroka|Pulgar|Raja|Ranaka|Sago|Salhutu|Shungol|Sibela|Silam|Sinabung|Singalang|Smeru|Suckling|Surakarta|Talawe|Tapulao|Tengger|Wilis)|Kapuas|Kinabalu|Kota Belud|Laut Tador|Idenburg River|Menado|San Cristobal|Malaita|Moulmein|Khasia Hills|Korinchi Peak|G\. Mulu National Park|Padang|Palembang|Surabaya)/<distributionLocality class=\"locality\">$1<\/distributionLocality>/g;
		
		
		# Other:
		s/(Nyassaland|lacs du Bas-Ogooué|New Caledonia|Taliabu)/<distributionLocality class=\"other\">$1<\/distributionLocality>/g;
		
		
		# Removes tags when a region or province is based on a city name:
		s/(<distributionLocality class="region">[[:upper:][:lower:] ]+)(<distributionLocality class="state">)(Florida|California)(<\/distributionLocality>)/$1$3/g;
		
		
		# Marks up doubtful localities:
		s/(<distributionLocality class=".+?")(>[[:upper:][:lower:] ]+)(<\/distributionLocality>)(\?)/$1 doubtful="true"$2$4$3/g;
		s/(\?)(<distributionLocality class=".+?")(>[[:upper:][:lower:] ]+)(<\/distributionLocality>)/$1$2 doubtful="true"$3$4/g;
		
		# puts back newline removed with previous script:
		s/(^)(\t\t\t<feature class="distribution">)/$1$2\n/;
		
		
		# Removes double closing tags:
		s/(<\/distributionLocality>)(<\/distributionLocality>)/$1/g;
		
		
	}
	
	
	# Habitat atomisation (needs improvement):
	elsif (/\t\t\t\t<string><(?:subH|h)eading>(?:(?:Ecol(?:\.|ogy)|Habitat)(?: & Ecology|)(?:\.|)|HABITAT AND ECOLOGY|ECOLOGY)<\/(?:subH|h)eading>/) {
		
		# Habitat tags:
		s/(\t\t\t\t<string><(?:subH|h)eading>(?:(?:Ecol(?:\.|ogy(?:\.|))|Habitat)(?: & Ecology|)|HABITAT AND ECOLOGY|ECOLOGY)<\/(?:subH|h)eading> )(.+?)(<\/string>)/$1<habitat>$2<\/habitat>$3/;
		
		# Altitudes:
		# single altitude + certain ranges:
		s/((?:from sea(?:-| |)level (?:up |)to |from |(?:from (?:the |)lowland(?:s|) |sometimes |(?:L|l)owland forest(?:,|) |)(?:up |)to |above |\d |)(?:(?:±|c(?:a|)\.) |)\d+(?:(?: |)\(-\d+\)|)(?: |)m(?!m))/<altitude>$1<\/altitude>/g;
		
		# more ranges:
		s/(above |between |from sea(?:-| |)level to (?:over |)|up to |(?:\(\d+-\)(?: |)|\d |between |)\d+(?:-| (?:up |)to | and )|sea(?:-| |)level |at low to medium altitudes, )(<altitude>)/$2$1/g;
		
		# estimations:
		s/((?:±|c(?:a|)\.) )(<altitude)(>)/$2 estimate="true"$3$1/g;
		s/(<altitude)(>)((?:±|c(?:a|)\.) )/$1 estimate="true"$2$3/g;
		
		# Non-numerical:
		s/((?:(?:(?:mainly|usually) at |)low(?: and medium|)|medium|high) (?:altitude|elevation)(?:s|)|at sea(?:-| |)level)/<altitude>$1<\/altitude>/;
		s/((?:(?:Usually in |)l|L)owland (?:rain(?:-|)|)forest(?:s|)|lowland|montane (?:rain(?:-|)|)forest(?:s|))/<altitude>$1<\/altitude>/g;
		
		
		# Fixes no space between numbers and unit:
		s/(\d)(m<\/altitude>)/$1 $2/;
		
		# Fixes closing altitude tag inside brackets when opening altitude tag is outside brackets:
		s/(<altitude>.+\(.+)(<\/altitude>)((?:\?|)\))/$1$3$2/;
		
		
		# Removes certain cases of double altitude tags:
		s/(<\/altitude>)(.+?)(<altitude>)/$2/g;
		s/(<altitude>.+?)(<altitude>)/$1/g;
		s/(<\/altitude>)(.+?<\/altitude>)/$2/g;
		
		
		# Phenology (needs work due to unstable formats used in flora text):
		
		# Find location(s) for starting and ending tags:
		# Opening tags:
		# Flowering and fruiting (combined periods):
		s/(Flowering and fruiting in |Flowering and fruiting |Fl\.(?: |)fr\. )/$1<lifeCyclePeriods class="flowering and fruiting"><dates><fullDate>/;
		# Start Flowering:
		s/(\. Fl(?:owering(?: in|)|\.) (?!fr\.)(?!Java))/$1<lifeCyclePeriods class="flowering"><dates><fullDate>/;
		# Start Fruiting:
		s/(\. Fr(?:uiting(?: in|)|\.) )/$1<lifeCyclePeriods class="fruiting"><dates><fullDate>/;
		# Opening and closing tags (closing tags for preceding part only):
		# Continuation flowering:
		s/((?:\.|); fl(?:owering(?: in|)|\.) )/<\/fullDate><\/dates><\/lifeCyclePeriods>$1<lifeCyclePeriods class="flowering"><dates><fullDate>/;
		# Continuation fruiting:
		s/((?:\.|); fr(?:uiting(?: in|)|\.) )/<\/fullDate><\/dates><\/lifeCyclePeriods>$1<lifeCyclePeriods class="fruiting"><dates><fullDate>/;
		# All other closing tags:
		s/(<lifeCyclePeriods class=".+?"><dates><fullDate>[[:upper:][:lower:]\., -]+(?:Jan(?:\.|)|Feb(?:r|)(?:\.|)|Mar(?:\.|)|Apr(?:\.|)|May|Jun(?:e|(?:\.|))|Jul(?:y|(?:\.|))|Aug(?:\.|)|Sep(?:t|)(?:\.|)|Oct(?:\.|)|Nov(?:(?:\.|)|)|Dec(?:\.|)))(\.(?:.+?|)(?:<\/habitat><\/string>|<br \/>))/$1<\/fullDate><\/dates><\/lifeCyclePeriods>$2/;
		s/(<lifeCyclePeriods class=".+?"><dates><fullDate>[[:upper:][:lower:]\., -]+)(\.(?:<\/habitat><\/string>|<br \/>))/$1<\/fullDate><\/dates><\/lifeCyclePeriods>$2/;
		
		# Resolves issue with double closing tags:
		s/(<\/fullDate><\/dates><\/lifeCyclePeriods>)([[:upper:][:lower:], \.]+<\/fullDate><\/dates><\/lifeCyclePeriods>)/$2/;
		
		
		
		
		# Converts single months into proper date format:
		s/(<dates>)(<fullDate>)(Jan(?:\.|uary|))(<\/fullDate>)(<\/dates>)/$1<month>--01<\/month>$5/g;
		s/(<dates>)(<fullDate>)(Feb(?:r|)(?:\.|uary|))(<\/fullDate>)(<\/dates>)/$1<month>--02<\/month>$5/g;
		s/(<dates>)(<fullDate>)(Mar(?:\.|ch|))(<\/fullDate>)(<\/dates>)/$1<month>--03<\/month>$5/g;
		s/(<dates>)(<fullDate>)(Apr(?:\.|il|))(<\/fullDate>)(<\/dates>)/$1<month>--04<\/month>$5/g;
		s/(<dates>)(<fullDate>)(May)(<\/fullDate>)(<\/dates>)/$1<month>--05<\/month>$5/g;
		s/(<dates>)(<fullDate>)(Jun(?:\.|e|))(<\/fullDate>)(<\/dates>)/$1<month>--06<\/month>$5/g;
		s/(<dates>)(<fullDate>)(Jul(?:\.|y|))(<\/fullDate>)(<\/dates>)/$1<month>--07<\/month>$5/g;
		s/(<dates>)(<fullDate>)(Aug(?:\.|ust|))(<\/fullDate>)(<\/dates>)/$1<month>--08<\/month>$5/g;
		s/(<dates>)(<fullDate>)(Sep(?:t|)(?:\.|ember|))(<\/fullDate>)(<\/dates>)/$1<month>--09<\/month>$5/g;
		s/(<dates>)(<fullDate>)(Oct(?:\.|ober|))(<\/fullDate>)(<\/dates>)/$1<month>--10<\/month>$5/g;
		s/(<dates>)(<fullDate>)(Nov(?:\.|ember|))(<\/fullDate>)(<\/dates>)/$1<month>--11<\/month>$5/g;
		s/(<dates>)(<fullDate>)(Dec(?:\.|ember|))(<\/fullDate>)(<\/dates>)/$1<month>--12<\/month>$5/g;
		
		
	}
	
	# Collections in figures:
	if (/<figure/) {
	
		s/(ABANG MUAS|ACHMAD|AMPURIA|ANDERSON|bb\.|BACKER|Bakhuizen van den Brink|BALGOOY|(?:van |)Balgooy|BOERLAGE|BON|BRASS(?: & MEIJER DREES|)|Brass|BROOKE|BRUN|Bryce|BSIP|BUJANG|BUNG PHENG|B(?:ü|u)nnemeijer|BUNNEMEYER|BUWALDA|BW|BYRNES|CARR|CLEMENS|Cockburn|CONKLIN|Craven & Schodde|CUMING|DOCTERS VAN LEEUWEN|Donk|ELMER|Ernst|Escritor|FB|FRI|GARRETT|HALLIER(?:(?: |)f\.|)|Hennipman|HEURN|Holttum|HOOGERWERF|HOOGLAND(?: & PULLEN|)|G\. F\. Hose|JAAG|JACOBS|Jacobs|JUNGHUHN|KOORDERS|KOSTERMANS(?: C\.S\.| & (?:ANTA|KUSWATA|VAN WOERDEN)|)|Kostermans|KRUYFF|Kunstler|LAJANGAH|Lörzing|Matthew|MEIJER|MUJIN|MURTHY & ASHTON|N\. BORNEO FOR\. DEP\.|NGF|(?:van |)Ooststroom|P\. S\. Shim|Philipson|Piggott|POSTHUMUS|Pulle|RIDLEY|Ridsdale|SAN|SANTOS|Schlechter|Schodde|SF|SINCLAIR|Sinclair|(?:VAN ROYEN & |)SLEUMER|SMYTHIES|Soekma|(?:VAN |)STEENIS|(?:van |)Steenis|STEINER|(?![[:upper:]])S|TEYSMANN|Verheijen|Wallich|WEBER|WINCKEL|Winckel|Yapp|ZIPPELIUS)( )((?:A |BRUN |bb\. |BSIP |FB |FRI |HB |NGF |S |SAN |SF |)\d+|s\.n\.)/<gathering><collector>$1<\/collector><fieldNum>$3<\/fieldNum><\/gathering>/g;
		
	}
	
	

	print OUT $_;
}

close IN;
close OUT;