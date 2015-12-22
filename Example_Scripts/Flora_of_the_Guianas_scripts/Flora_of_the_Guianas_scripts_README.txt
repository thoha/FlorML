README for Flora of the Guianas scripts - scripts will be added by the end of March 2016

================================================================================
CONTENTS:

I. Introduction
II. Requirements and syntax used
III. Running order for Flore du Gabon scripts
IV. Licensing

================================================================================

I. Introduction

The Flora_of_the_Guianas_scripts.zip ZIP file contains the Perl scripts that were 
used to add mark-up to Flora of the Guianas. These scripts were created while 
doing the actual production work for Flora of the Guianas, and so evolved along 
the way.

These scripts were developed by combining the Flora Malesiana and Flore du Gabon 
scripts.


================================================================================

II. Requirements and syntax used

The scripts are written in the Perl language and make liberal use of Perl's 
regular expression capabilities. They require a recent version of Perl 5 with 
Unicode support (version 5.16 or later should work).

Scripts are run from the Windows Command Prompt (or Mac OS X Terminal or 
whatever Unix/Linux shell you wish to use) using the following syntax:

perl [script name] [input XML file] [output XML file]


================================================================================

II. Running order for Flore du Gabon scripts

This was the running order for the Perl scripts for Flore du Gabon:

1)	filecleaner.pl (clean-up)
2)	ocrfix.pl (OCR fixing)

At this point, insert empty lines between taxa.

3)	pubtags.pl (first and last publication and taxon tags, metadata base 
	tags)
4)	taxontags.pl (other taxon tags)
5)	keytags.pl (keys)
6)	figures.pl (figures + gathering information in figures)
7)	footnotes.pl(footnotes)

At this point, manually insert tags for tables, lists and line breaks and 
remove newlines after line breaks in descriptions and distributions.

8)	featbasics.pl (basic feature tags) 

At this point, manually insert other feature tags including string tags and 
headings (see FlorML reference.doc), etc. Furthermore, if many descriptions 
are missed by the previous script, consider adding the basic description 
mark-up before running the next script. 

9)	nombasics.pl (basic nomenclature, types tags)
10)	atomizer.pl (atomize as much data as possible)
11)	entities.pl (special symbols)
	
Proofread the whole document a first time.

12)	atom2.pl (additional atomisation of descriptions)
13)	namefinder.pl (finds remaining names in text)

Proofread the whole document a second time.

================================================================================

IV. Licensing

The Flora of the Guianas mark-up scripts and this README are licensed under a 
Creative Commons Attribution-ShareAlike 3.0 Unported license.


Copyright Thomas Hamann 2015

================================================================================