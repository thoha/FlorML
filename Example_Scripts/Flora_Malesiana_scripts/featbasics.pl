#!/usr/bin/perl
# featbasics.pl
# Adds basic mark-up to features.

# TODO (Feb 17, 2015): Implement mark-up of Latin descriptions

use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {

	# Features with (sub-)headings basic mark-up:
	
	
	# Acknowledgements:
	s/(^)(Acknowledgement(?:s|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="acknowledgements">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Anatomy:
	s/(^)(Anat(?:omy|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="anatomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Anatomy)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="anatomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(ANATOMY)($)/$1\t\t\t<feature class="anatomy">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	
	# Bibliographical notes:
	s/(^)(Bibliographical note(?:s|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="bibliographical notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Chemotaxonomy:
	s/(^)(Chemotaxonomy\.|Phytochem(?:istry|)\.|Phytochemistry & Chemotaxonomy\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="phytochemo">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Phytochemistry|Phytochemistry & Chemotaxonomy|Chemical compounds)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="phytochemo">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(PHYTOCHEMISTRY)($)/$1\t\t\t<feature class="phytochemo">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	
	# Collection notes:
	s/(^)(Notes for collectors\.|Collecting & preservation\.)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="collection notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Conservation:
	s/(^)(Conservation(?: status|))( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="conservation">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	
	
	# Cultivation:
	s/(^)(Cult(?:ivation|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="cultivation">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Cultivation)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="cultivation">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(CULTIVATION)($)/$1\t\t\t<feature class="cultivation">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	
	# Chromosomes:
	s/(^)(Chromosome(?:s| number(?:s|))\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="cytology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Chromosome(?:s| number(?:s|)))( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="cytology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(CHROMOSOMES)($)/$1\t\t\t<feature class="cytology">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Cytology:
	s/(^)(Cytol(?:ogy|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="cytology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Cytology)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="cytology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(CYTOLOGY|KARYOLOGY(?: AND HYBRIDIZATION|))($)/$1\t\t\t<feature class="cytology">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	
	# Dispersal:
	s/(^)(Dispersal\.|Disp\.|Genesis\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="dispersal">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Distributions:
	s/(^)(Distr(?:ibution|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="distribution">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Distribution)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="distribution">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)((?:ECOLOGY AND |)DISTRIBUTION)($)/$1\t\t\t<feature class="distribution">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Ecology:
	s/(^)(Ecol(?:ogy|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="ecology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Ecology)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="ecology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(ECOLOGY)($)/$1\t\t\t<feature class="ecology">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Habitat:
	s/(^)(Habitat)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="habitat">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(HABITAT)($)/$1\t\t\t<feature class="habitat">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Habitat & Ecology:
	s/(^)(Habitat & Ecology)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="habitatecology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(HABITAT (?:AND|&) ECOLOGY)($)/$1\t\t\t<feature class="habitatecology">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Embryology:
	s/(^)(Embryol(?:ogy|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="embryology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Ethnobotany:
	# HEADING-only:
	s/(^)(ETHNOBOTANY)($)/$1\t\t\t<feature class="ethnobotany">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Field notes:
	s/(^)(Field note(?:s|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="field notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Field note(?:s|))( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="field notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	
	
	# Floral biology:
	s/(^)(Flo(?:ral|wer)(?:-| )biology\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="floral biology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Fossils:
	s/(^)(Fossil(?:s| record(?:s|))\.|Pal(?:a|)eobotany\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="fossils">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Fossils)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="fossils">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(FOSSIL(?:S| RECORD))($)/$1\t\t\t<feature class="fossils">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	
	# Seeds:
	s/(^)(Seeds)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="seeds">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# Fruits and Seeds:
	s/(^)(Fruits and Seeds)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="fruits and seeds">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	
	# Galls:
	s/(^)(Galls\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="galls">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Hybridization:
	s/(^)(Hybrid(?:i(?:s|z)ation|s)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="hybrids">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Morphology:
	s/(^)(Morph(?:ology|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="morphology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Morphology)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="morphology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(MORPHOLOGY(?: AND CHARACTERS|))($)/$1\t\t\t<feature class="morphology">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Morphology and Anatomy:
	s/(^)(Morphology (?:&|and) Anatomy\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="morphology and anatomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(ANATOMY AND MORPHOLOGY|MORPHOLOGY AND ANATOMY)($)/$1\t\t\t<feature class="morphology and anatomy">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Morphology and Taxonomy:
	s/(^)(Morphology (?:&|and) Taxonomy)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="morphology and taxonomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	
	# Flower anatomy:
	s/(^)(Flo(?:ral|wer) anat(?:omy|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="flower anatomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	# Flower morphology:
	s/(^)(Flo(?:ral|wer) morph(?:ology|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="flower morphology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Flo(?:ral|wer) morphology)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="flower morphology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	
	# Gametophyte morphology:
	# HEADING-only:
	s/(^)(GAMETOPHYTE)($)/$1\t\t\t<feature class="gametophyte morphology">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Leaf anatomy:
	s/(^)(Leaf anatomy)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="leaf anatomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	
	# Reproductive morphology:
	# HEADING-only:
	s/(^)(REPRODUCTIVE MORPHOLOGY)($)/$1\t\t\t<feature class="reproductive morphology">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Seedling morphology:
	s/(^)(Seedlings)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="seedling morphology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	
	# Vegetative anatomy:
	s/(^)(Vegetative (?:A|a)nat(?:omy|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="vegetative anatomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Vegetative Anatomy)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="vegetative anatomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	
	# Vegetative morphology:
	s/(^)(Vegetative morph(?:ology|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="vegetative morphology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	# Wood anatomy:
	s/(^)(Wood(?: |-|)(?:A|a)nat(?:omy|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="wood anatomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Wood anatomy)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="wood anatomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(WOOD ANATOMY)($)/$1\t\t\t<feature class="wood anatomy">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	
	# Wood ot timber properties:
	s/(^)((?:Timber|Wood) properties\.|Properties of wood\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="timber properties">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	# Myrmecophyly:
	s/(^)(Myrmecophyly\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="ants">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Notes:
	s/(^)(Note(?:s|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Note(?:s|))( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="notes">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(NOTE(?:S|))($)/$1\t\t\t<feature class="notes">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	
	# Palynology:
	s/(^)(Palyn(?:ology|)\.|Pollen morphology\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="palynology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Palynology|Pollen morphology)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="palynology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(POLLEN MORPHOLOGY)($)/$1\t\t\t<feature class="palynology">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Parasitism:
	s/(^)(Parasitism\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="parasitism">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Phylogeny:
	s/(^)(Phylog(?:eny|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="phylogeny">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Pollination:
	s/(^)(Pollinat(?:ion|ors)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="pollination">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Pollination)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="pollination">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	
	
	# Pollination and dispersal
	# HEADING-only:
	s/(^)(POLLINATION AND DISPERSAL)($)/$1\t\t\t<feature class="pollination and dispersal">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	
	# Spores:
	s/(^)(Spores\.)( .+(?:\.|<br \/>|:))($)/$1\t\t\t<feature class="spores">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;	
	
	
	# Systematics:
	s/(^)(Syst(?:ematics|)\.)( .+(?:\.|<br \/>|:))($)/$1\t\t\t<feature class="systematics">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	# Taxonomy:
	s/(^)(Taxon(?:omy|)\.|Nomencl\.|Affinity\.)( .+(?:\.|<br \/>|:))($)/$1\t\t\t<feature class="taxonomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Taxonom(?:y|ic position))( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="taxonomy">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(TAXONOMY)($)/$1\t\t\t<feature class="taxonomy">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Taxonomy and Phylogeny:
	s/(^)(Taxonomy and Phylogeny)( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="taxonomy and phylogeny">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(TAXONOMY AND AFFINITY)($)/$1\t\t\t<feature class="taxonomy and phylogeny">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	# Typification:
	s/(^)(Typification\.)( .+(?:\.|<br \/>|:))($)/$1\t\t\t<feature class="typification">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Teratology:
	s/(^)(Terat(?:ology|)\.)( .+(?:\.|<br \/>|:))($)/$1\t\t\t<feature class="teratology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	
	# Terminology:
	s/(^)((?:Terminology|Explanation of some terms)\.)( .+(?:\.|<br \/>|:))($)/$1\t\t\t<feature class="terminology">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	# Uses:
	s/(^)(Uses\.|Econ\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="uses">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)(Uses(?: & Note|))( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="uses">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	# HEADING-only:
	s/(^)(USES)($)/$1\t\t\t<feature class="uses">\n\t\t\t\t<string><heading>$2<\/heading><\/string>\n\t\t\t<\/feature>/;
	
	
	# Commercial names:
	s/(^)((?:Commercial|Trade) name(?:s|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="commercial names">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	
	# Vernacular names:
	s/(^)(Vern(?:acular(?: name(?:s|)|)|)\.)( .+(?:\.|<br \/>))($)/$1\t\t\t<feature class="vernacular">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$3<\/string>\n\t\t\t<\/feature>/;
	s/(^)((?:Common|(?:Malesian v|V)ernacular) name(?:s|))( —)(.+(?:\.|<br \/>))($)/$1\t\t\t<feature class="vernacular">\n\t\t\t\t<string><subHeading>$2<\/subHeading>$4<\/string>\n\t\t\t<\/feature>/;
	
	
	
	# References/Literature sections basic mark-up:
	
	# Sections starting with ALL-CAPS heading:
	s/(^)(REFERENCES)($)/$1\t\t\t\t<references><heading>$2<\/heading>/;
	
	# Sections starting with a subheading:
	s/(^)((?:Reference(?:s|)|(?:L|General l)iterature(?: \(selected references only\)|)):)( )(.+)($)/$1\t\t\t\t<references><subHeading>$2<\/subHeading>$4<\/references>$5/;
	
	# Inline sections:
	s/( — )((?:Literature|Reference(?:s|)):|Liter\.)( )(.+?)(<\/string>|<br \/>|\n)/\n\t\t\t\t<references><subHeading>$2<\/subHeading>$4<\/references>$5/;
	
	
	# Diagnoses:
	
	if (/^(?!\t+)(?!<)(?!Fig\. \d+)(?!.+xmlns:xsi)/) {
		
		s/(^)(Frutex|Fruticulus|Stipulae)(.+)($)/$1\t\t\t<feature class="diagnosis" lang="la">\n\t\t\t\t<string>$2$3<\/string>\n\t\t\t<\/feature>/;
		
	}
	
	# Descriptions:
	
	if (/^(?!\t+)(?!<)(?!Fig\. \d+)(?!.+xmlns:xsi)/) {
		
		s/(^)((?:Minute a|A)quatic(?:s|)|Usually small, glabrous bushes|(?:Acaulescent|Annual|Annual or perennial|Branching|Bulbous|Climber|Cormogenous|Creep(?:er|ing)|Diffuse(?:, pubescent|)|Erect(?: to decumbent| or scrambling|, suffrutescent| prickly)|(?:Acaulescent g|G)labrous(?:, well branched|)|Hairy|Large|Low, weak|Low-growing diffuse|Narrowly taprooted|(?:Erect p|P)erennial (?:erect|)|Prostrate(?:, weedy|, erect or rarely, climbing,|)|Pubescent(?: or glabrous, unarmed|)|Rhizomatous|Slender(?:, erect|)|Spreading to erect perennial|Stout|Terrestrial|Tufted|Weak|(?:Spr(?:awling|eading) to ascending w|W)oody) herb(?:s|)|Herbs(?: or subshrubs|, shrubs or (?:lianas|(?:rarely |)trees))|(?:Prostrate hairy h|Small glabrous h|Stemless h|H)erb(?:s|)|(?:Predominantly s|S)ucculent|(?:Tall l|L)iana(?:s|) or (?:climbing|scandent) shrub(?:s|)|(?:Climbing l|Woody l|L)iana(?: or climber|)|(?:Low|Slender(?: woody|)|Woody) climber|(?:A s|(?:A|Una)rmed s|Aromatic(?:, glabrous|) s|(?:A b|B)ushy s|Dwarf s|Erect prickly s|Large s|Leafy(?: parasitic|) s|Little-branched s|(?:Very l|L)ow s|Mangrove(?:-like|) s|Scandent or creeping s|Scrambling(?: or trailing|) s|Sprawling s|Small s|\(Sub\)s|Unders|Woody s|(?:Large s|S)candent s|Simple-stemmed s|Slender s|S)hrub(?:s|)|Subshrub(?:s|)|Flowering shoots|(?:Glabrous v|Twining v|Woody v|V)ine(?:s|)|(?:(?:A|Una)rmed t|(?:A b|B)ig t|(?:B|Unb)uttressed t|(?:Spreading c|C)anopy t|Crooked t|(?:Briefly d|D)eciduous t|Glabrate t|High t|Large t|Majestic columnar t|Medium-sized t|\(Shrub to\) t|Slender t|Small(?: bushy| to large|, glabrous|) t|Sparsely branched t|Spreading t|Straggling t|T)ree(?:s|)|(?:Annual or p|P)erennial|(?:Ac|C)aulescent|(?:(?:Diffusely b|(?:Delicate, percurrent, m|M)uch b|B)ranched|(?:Dichotomous, |Small, )erect|(?:(?:Usually r|R)ather l|L)arge|Large(?:,|) glabrous|(?:Densely l|Rather small, l|L)eafy(?: parasitic| to squamate|)|(?:Rather leggy, p|P)ercurrent|Scandent|Medium(?:-| )sized|Slender(?:-stemmed|)|(?:A r|R)ather small-leaved|(?:Rather s|S)mall(?:, leafless|)|(?:Rather coarse, s|Delicate, s|Stout, s|S)parsely branch(?:ed|ing)(?:, smooth|)|Squamate|Stout(?:, brittle|)|Woody) plant|Semiparasitic mistletoes|Annual|(?:Inflorescence b|B)ranches|Branchlets|Caespitose|Deciduous|Echlorophyllous|Evergreen|Glabrous|Habit, rhizome morphology|Indumentum|Internodes|(?:Often large, l|L)eafy(?:, glabrous|) parasites|Phyllodes|Plants (?:to|with|mostly dichotomous|percurrent|sparsely branched|submersed)|Rhizome|Scrambler|Stem(?:s|) (?:erect|short|(?:rather |)stout|(?:more or less |)terete|tufted)|Stipes|Suffrutescent|Rather small ferns|Ultimate parts|Epicortical roots|Glumes|Roots(?: partly|) fibrous|Spikelets|Trunk|Very small and delicate species|Young (?:shoots|stems))(.+)($)/$1\t\t\t<feature class="description">$2$3<\/feature>/;
		
		
		
		# More descriptions mark-up:
		if (/^(?!\t+)(?!<)(?!Lomaria)(?!Blechnum)(?!Hopea)(?!Pinnae redactae)(?!Caudex erectus)(?!\d\.)(?!\d\d\.)(?!.+xmlns:xsi)/) {
		
			s/^(.+?(?:bathyphylls|branch-systems|coralliform|curving fingers|deciduous|dioecious|dome-shaped|dorsal outline|dryobalanoid(?:,| )|epiphytic(?!a)|evergreen|flushes|well-grown fronds|herbaceous|Hypanthium|lower internodes|jointed|laminar|lanceolate| liana|mericarps|monoecious|ovate|perennial|pinkish|pubescent|quadrangular |rachis-branches|rhizomatous|rosette(?:s|)|short-boled|single-trunked|spike-like|striate|sympodial|taproot|tomentose|treelet|tuberiform|umbelliformous|velvety|Fruit unknown).+?)$/\t\t\t<feature class="description">$1<\/feature>/;
			
			s/^((?:Auricles|Axillary buds|Bathyphylls|Bulb|Caudex|(?:Overhanging c|C)limber|Corolla|Cupule|Cymes|Decumbent|Dioecious|Echlorophyllose|Epiphytic|Epilithic|Erect|Flowering stems|(?:Simple f|Sterile f|F)ronds|Habit |Inflorescence(?:s|)|(?:Basal l|L)eaves|Monoecious|Nodal glands|Peduncle|Perigone|Petiolar gland|Petiole with a sheath|Pinnae|(?:Semip|P)rostrate|Raceme(?:s|)|(?:Main r|R)achis|Saprophytic|Scales o(?:f|n) |Scandent|Stembase|Stipe|Stipules|Stoloniferous|Suffruticose|Terrestrial|Tubers|Twigs|Umbel|Unarmed|Underground|Virgate|Well-grown fronds|Young (?:branches|twigs|plant))(?!\.).+?)$/\t\t\t<feature class="description">$1<\/feature>/;
			
			
		}
		
	}
	
	
	
	print OUT $_; 
}

close IN;
close OUT;