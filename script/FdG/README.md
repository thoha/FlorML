README for Flore du Gabon scripts
=================================

Introduction
===============

This folder contains the Perl scripts that were used to add 
mark-up to Flore du Gabon. These scripts were created while doing the actual 
production work for Flore du Gabon, and so evolved along the way.

Unfortunately, the comments in the scripts are mostly in French.

Requirements and syntax used
================================

The scripts are written in the Perl language and make liberal use of Perl's 
regular expression capabilities. They require a recent version of Perl 5 with 
Unicode support (version 5.16 or later should work).

Scripts are run from the Windows Command Prompt (or Mac OS X Terminal or 
whatever Unix/Linux shell you wish to use) using the following syntax:

 `perl <script name> <input XML file> <output XML file>`

Running order for Flore du Gabon scripts
============================================

This was the running order for the Perl scripts for Flore du Gabon:

1. `nettoyeur.plx` (clean-up)
2. `reparocr.plx` (OCR fixing). At this point, insert empty lines between taxa.
3. `pubtags_fr.plx` (first and last publication and taxon tags, metadata base tags)
4. `taxontags_fr.plx` (other taxon tags)
5. `clestags.plx` (keys)
6. `planches.plx` (figures)
7. `notesbaspages.plx` (footnotes)
    At this point, manually insert tags for tables, lists and line breaks and remove
    newlines after line breaks in descriptions and distributions.
8. `featuresfr.plx` (basic feature tags) 
    (If many descriptions are missed by the previous script, consider adding the basic
    description mark-up before running the next script)
9. `nomenclaturefr.plx` (nomenclature, types)
    At this point, manually insert other feature tags including string tags and headings,
    etc.
10. `atomiseur.plx` (atomisation, step 1: nomenclature, types, distribution data, 
    vernacular names, descriptions, etc.)
11. `annotationsfr.plx` (annotations)
12. `entities.plx` (special symbols)

Additional scripts
======================

`atomprepa.plx` (a preparation script used on some volumes)
`figurl_fr.plx` (adds figure URLs to a mostly marked up file)

Licensing
============

The Flore du Gabon mark-up scripts and this README are licensed under a 
Creative Commons Attribution-ShareAlike 3.0 Unported license.


Copyright Thomas Hamann 2014


