README for Flore du Gabon scripts

================================================================================
CONTENTS:

I. Introduction
II. Requirements and syntax used
III. Running order for Flore du Gabon scripts
IV. Additional scripts
V. Licensing

================================================================================

I. Introduction

The Flore_du_Gabon_scripts.zip ZIP file contains the Perl scripts that were used to add 
mark-up to Flore du Gabon. These scripts were created while doing the actual 
production work for Flore du Gabon, and so evolved along the way.

Unfortunately, the comments in the scripts are mostly in French.


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

1)	nettoyeur.pl (clean-up)
2)	reparocr.pl (OCR fixing)

At this point, insert empty lines between taxa.

3)	pubtags_fr.pl (first and last publication and taxon tags, metadata base 
	tags)
4)	taxontags_fr.pl (other taxon tags)
5)	clestags.pl (keys)
6)	planches.pl (figures)
7)	notesbaspages.pl (footnotes)

At this point, manually insert tags for tables, lists and line breaks and 
remove newlines after line breaks in descriptions and distributions.

8)	featuresfr.pl (basic feature tags) 

(If many descriptions are missed by the previous script, consider adding the 
basic description mark-up before running the next script)

9)	nomenclaturefr.pl (nomenclature, types)

At this point, manually insert other feature tags including string tags and 
headings , etc.

10)	atomiseur.pl (atomisation, step 1: nomenclature, types, distribution data, 
	vernacular names, descriptions, etc.)
11)	annotationsfr.pl (annotations)
12)	entities.pl (special symbols)

Proofread the whole document.

================================================================================

IV. Additional scripts

atomprepa.pl (a preparation script used on some volumes)
figurl_fr.pl (adds figure URLs to a mostly marked up file)


================================================================================

V. Licensing

The Flore du Gabon mark-up scripts and this README are licensed under a 
Creative Commons Attribution-ShareAlike 3.0 Unported license.

You are free to use these scripts for your own purposes under the above license,
but please credit the author appropriately.


Copyright Thomas Hamann 2013-2014

================================================================================