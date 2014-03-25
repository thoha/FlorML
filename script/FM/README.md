README for Flora Malesiana scripts
==================================

Introduction
===============

This folder contains the Perl scripts that were used to add 
mark-up to Flora Malesiana. These scripts were created while doing the actual 
production work for Flora Malesiana, and so evolved along the way.

Requirements and syntax used
================================

The scripts are written in the Perl language and make liberal use of Perl's 
regular expression capabilities. They require a recent version of Perl 5 with 
Unicode support (version 5.16 or later should work).

Scripts are run from the Windows Command Prompt (or Mac OS X Terminal or 
whatever Unix/Linux shell you wish to use) using the following syntax:

 `perl <script name> <input XML file> <output XML file>`

Running order for Flora Malesiana scripts
=============================================

This was the running order for the Perl scripts for Flora Malesiana:

# `filecleaner.plx` (clean-up)
# `ocrfix.plx` (OCR fixing)
# At this point, insert empty lines between taxa.
# `pubtags.plx` (first and last publication and taxon tags, metadata base tags)
# `taxontags.plx` (other taxon tags)
# `keytags.plx` (keys)
# At this point, manually insert tags for tables, lists and line breaks and remove newlines after line breaks in descriptions and distributions.
# `features.plx` (features)
# `footnotes.plx` (footnotes)
# `figures.plx` (figures)
# `descriptions.plx` (basic tags for descriptions)
# `characters.plx` (character atomisation in descriptions)
# `taxontitles.plx` (taxontitles)
# `nomenclature.plx` (basic nomenclature tags)
# `nomatomizer.plx` (nomenclature atomisation)
# `literature.plx` (literature atomisation)
# `annotations.plx` (author comments/annotations)
# `entities.plx` (special symbols)

Additional script
=====================

`figurl_fr.plx` (adds figure URLs to a mostly marked up file)

Licensing
============

The Flora Malesiana mark-up scripts and this README are licensed under a 
Creative Commons Attribution-ShareAlike 3.0 Unported license.


Copyright Thomas Hamann 2014