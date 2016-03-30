README for Flora Malesiana scripts

================================================================================
CONTENTS:

I. Introduction
II. Requirements and syntax used
III. Running order for Flora Malesiana scripts
IV. Bugfix scripts
V. Additional script
VI. Licensing

================================================================================

I. Introduction

The Flora_Malesiana_scripts.zip ZIP file contains the Perl scripts that were 
used to add mark-up to Flora Malesiana. These scripts were created while doing 
the actual production work for Flora Malesiana, and so evolved along the way.


================================================================================

II. Requirements and syntax used

The scripts are written in the Perl language and make liberal use of Perl's 
regular expression capabilities. They require a recent version of Perl 5 with 
Unicode support (version 5.16 or later should work).

Scripts are run from the Windows Command Prompt (or Mac OS X Terminal or 
whatever Unix/Linux shell you wish to use) using the following syntax:

perl [script name] [input XML file] [output XML file]


================================================================================

II. Running order for Flora Malesiana scripts

This was the running order for the Perl scripts for Flora Malesiana:

1)	filecleaner.pl (clean-up)
2)	ocrfix.pl (fixing OCR-errors)

At this point, insert empty lines between taxa.

3)	pubtags.pl (first and last publication and taxon tags, metadata base tags)
4)	taxontags.pl (other taxon tags)
5)	keytags.pl (keys)

At this point, manually insert tags for tables, lists and line breaks (see 
FlorML reference.doc) and remove newlines after line breaks in descriptions 
and distributions. 

6)	footnotes.pl (footnotes) 
7)	featbasics.pl (features) 

(If many descriptions are missed by the previous script, consider adding the 
basic description mark-up before running the next script) 

8)	figures.pl (figures) 
9)	nombasics.pl (basic nomenclature tags) 
10)	characters.pl (character atomisation in descriptions) 
11)	nomatomizer.pl (nomenclature atomisation) 
12)	atomizer.pl (new script for all remaining atomisation, incl. distributions) 
13)	entities.pl (special symbols)

(Compared to old mark-up scripts, several FM scripts have been merged into one; 
order improved for better efficiency)

Proofread the whole document.


================================================================================

IV. Bugfix scripts

Two sets of bugfix scripts were created. These are run over proofread files and 
are described below:

1)
serfixA.pl
serfixB.pl
(run in A, B order)

These two scripts fix a bug in the citation and reference atomisation code that
causes publication series and volume numbers to be marked up incorrectly as
volume and issue numbers (respectively).


2)
parautfixA.pl 
parautfixB.pl
(run in A, B order) 

These were created to fix an issue with the mark-up of the nomenclature in older 
Flora Malesiana volumes (approximate publication dates 1950-1980). These volumes 
use a non-standardtext format for the "auct. non NOT_THIS_AUTHOR: THAT_AUTHOR"-
construction, which was marked up incorrectly by the atomisation script because 
it was not discernable from another text format commonly used in nomenclature.


================================================================================

V. Additional script

figurl_fr.plx (adds figure URLs to a mostly marked up file)


================================================================================

VI. Licensing

The Flora Malesiana mark-up scripts and this README are licensed under a 
Creative Commons Attribution-ShareAlike 3.0 Unported license.

You are free to use these scripts for your own purposes under the above license,
but please credit the author appropriately.


Copyright Thomas Hamann 2010-2016

================================================================================