README for Flora Malesiana scripts
==================================

CONTENTS:
=========

I. Introduction
II. Requirements and syntax used
III. Running order for Flora Malesiana scripts
IV. Additional script
V. Licensing

I. Introduction
===============

This folder contains the Perl scripts that were used to add 
mark-up to Flora Malesiana. These scripts were created while doing the actual 
production work for Flora Malesiana, and so evolved along the way.

II. Requirements and syntax used
================================

The scripts are written in the Perl language and make liberal use of Perl's 
regular expression capabilities. They require a recent version of Perl 5 with 
Unicode support (version 5.16 or later should work).

Scripts are run from the Windows Command Prompt (or Mac OS X Terminal or 
whatever Unix/Linux shell you wish to use) using the following syntax:

 `perl <script name> <input XML file> <output XML file>`

II. Running order for Flora Malesiana scripts
=============================================

This was the running order for the Perl scripts for Flora Malesiana:

1)	filecleaner.plx (clean-up)
2)	ocrfix.plx (OCR fixing)

At this point, insert empty lines between taxa.

3)	pubtags.plx (first and last publication and taxon tags, metadata base tags)
4)	taxontags.plx (other taxon tags)
5)	keytags.plx (keys)

At this point, manually insert tags for tables, lists and line breaks and 
remove newlines after line breaks in descriptions and distributions.

6)	features.plx (features)
7)	footnotes.plx (footnotes)
8)	figures.plx (figures)
9)	descriptions.plx (basic tags for descriptions)
10)	characters.plx (character atomisation in descriptions)
11)	taxontitles.plx (taxontitles)
12)	nomenclature.plx (basic nomenclature tags)
13)	nomatomizer.plx (nomenclature atomisation)
14)	literature.plx (literature atomisation)
15)	annotations.plx (author comments/annotations)
16)	entities.plx (special symbols)

IV. Additional script
=====================

figurl_fr.plx (adds figure URLs to a mostly marked up file)

V. Licensing
============

The Flora Malesiana mark-up scripts and this README are licensed under a 
Creative Commons Attribution-ShareAlike 3.0 Unported license.


Copyright Thomas Hamann 2014