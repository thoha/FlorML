#!/usr/bin/perl
# atom2.pl
# Atomizes characters further

use warnings;
use strict;
use utf8;
use open ':encoding(utf8)';

my $source = shift @ARGV;
my $destination = shift @ARGV;

open IN, $source or die "Can't read source file $source: $!\n";
open OUT, "> $destination" or die "can't write on file $destination: $!\n";

while (<IN>) {
	
	# Description atomisation, step 2:
	
	
	# quick fixes to improve mark-up of numeric data:
	# Removes unwanted spaces:
	s/(\(\d+-\))( )(\d+)/$1$3/g;
	s/(\d+)( )(\(-\d+\))/$1$3/g;
	
	
	
	if (/^\t\t\t\t\t<subChar class="/) {
		
		# Splitting off subcharacters of subcharacters:
		s/(, )((?:the |)(?:acumen|albumen|(?:lower|upper|nearly sessile) anthers|anther thecae|anthers|appendage(?:s|)|apex and base|apex|aril|bark|blade|body|(?:secondary|tertiary) bracteoles|(?:floral |scape |)bracts|(?:fertile|lateral) branches|branchlets|calyculus|cocci|(?:anther |)connective|connectival horns|corolla|cotyledons|cystoliths|base|embryo|endosperm|(?:basal|lacking|with (?:few |)) epicortical roots|in female flower|female flowers|filament(?:s|)|floriferous part|flowers|funicle|(?:primary) haustorium|(?:fertile |)internodes|leaf margin and lower midrib|leaflets|limb|(?:lower |upper )lip|(?:free portion of |anterior |calyx |corolla |inferior |inner |lateral |middle |outer |posterior |remaining |superior |)lobe(?:s|)|margin(?:s|)|marginal cells|midvein|nodes|(?:endo|exo|meso|peri|sarco)carp|ovary|ovule(?:s|)|pedicels|(?:dyad |triad |)peduncle(?:s|)|perianth|perisperm|petals|petiole(?:s|)|pollen|pseudostaminodia|pseudostipe|individual racemes|rachis|radicle|retinacula|rhizome|scale leaves|secondary veins|seeds|(?:inner|outer|perianth) segments|(?:outer |inner |)sepal(?:s|)|septa|large spikes|staminal pockets|staminode(?:s|)|(?:fertile|older|straight) stem(?:s|)|stigma(?:s|)|stipe|style(?:s|)(?:, if present,|)|(?:lower|upper|inner|outer|adaxial|abaxial) surface|tepals|testa|thecae|throat|tube|twigs|valves|lateral veins|(?:primary|secondary|tertiary) vein(?:s|)|(?:tertiary |)venation|(?:external|outer|inner|internal) wall(?:s|)|wing(?:s|)) )/$1\n\t\t\t\t\t\t<subChar class="">$2/g;
		
		
		# Inserts closing tags:
		s/(\t\t\t\t\t\t<subChar class="">[[:lower:] ,\.;\d+\(\)\/&-]+)(\n|<\/subChar>\n)/$1<\/subChar>$2/g;
		
		# Inserts newline at closing tag of parent subcharacter:
		s/(<\/subChar>)(<\/subChar>)/$1\n\t\t\t\t\t$2/;
		
		
		# Measurements:
		# Diameter:
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m (?:in |)diam(?:\.|eter))/<subChar class="diameter">$1<\/subChar>/g;
		# Height:
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m (?:tall(?!er)|high(?!er)))/<subChar class="height">$1<\/subChar>/g;
		# Length:
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m long(?!er))/<subChar class="length">$1<\/subChar>/g;
		# Thickness:
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m thick(?!er))/<subChar class="thickness">$1<\/subChar>/g;
		# Width:
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m (?:wide(?!r)|broad(?!er)))/<subChar class="width">$1<\/subChar>/g;
		
		# Dimensions (surfaces, sections, etc.):
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)(?: (?:c|m|µ|)m|) (?:x|×) |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)(?: (?:c|m|µ|)m|) (?:x|×) (?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m)/<subChar class="dimensions">$1<\/subChar>/g;
		
		
		# Remainder of dimensions (where it is unknown what dimension is exactly meant):
		s/((?<![>\)\d\.-])(?<!\(\d\) )(?<!\(\d-\) )(?<!\(\d\.\d\) )(?<!\(\d\.\d-\) )(?<! x )(?<! × )(?<!>about )(?<!>± )(?<!>ca\. )(?<!>to )(?<!>up to )(?<!>&lt; )(?<!>&lt;)(?<!>less than )(?<!>&gt; )(?<!>&gt;)(?<!>greater than )(?:up to |(?<!>up )to |about |± |ca\. |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m(?![[:lower:]]))/<subChar class="">$1<\/subChar>/g;
		
		
	}
	
	
	if (/^\t\t\t\t<char class="/) {
		
		# Splitting off additional subcharacters of characters:
		s/(, )((?:the |)(?:acumen|albumen|(?:lower|upper|nearly sessile) anthers|anther thecae|anthers|appendage(?:s|)|apex and base|apex|aril|bark|blade|body|(?:secondary|tertiary) bracteoles|(?:floral |scape |)bracts|(?:fertile|lateral) branches|branchlets|calyculus|cocci|(?:anther |)connective|connectival horns|corolla|cotyledons|cystoliths|base|embryo|endosperm|(?:basal|lacking|with (?:few |)) epicortical roots|in female flower|female flowers|filament(?:s|)|floriferous part|flowers|funicle|(?:primary) haustorium|(?:fertile |)internodes|leaf margin and lower midrib|leaflets|limb|(?:lower |upper )lip|(?:free portion of |anterior |calyx |corolla |inferior |inner |lateral |middle |outer |posterior |remaining |superior |)lobe(?:s|)|margin(?:s|)|marginal cells|midvein|nodes|(?:endo|exo|meso|peri|sarco)carp|ovary|ovule(?:s|)|pedicels|(?:dyad |triad |)peduncle(?:s|)|perianth|perisperm|petals|petiole(?:s|)|pollen|pseudostaminodia|pseudostipe|individual racemes|rachis|radicle|retinacula|rhizome|scale leaves|secondary veins|seeds|(?:inner|outer|perianth) segments|(?:anterior |posterior |outer |inner |)sepal(?:s|)|septa|large spikes|staminal pockets|staminode(?:s|)|(?:fertile|older|straight) stem(?:s|)|stigma(?:s|)|stipe|style(?:s|)(?:, if present,|)|(?:lower|upper|inner|outer|adaxial|abaxial) surface|tepals|testa|thecae|throat|tube|twigs|valves|lateral veins|(?:primary|secondary|tertiary) vein(?:s|)|(?:tertiary |)venation|(?:external|outer|inner|internal) wall(?:s|)|wing(?:s|)) )/$1\n\t\t\t\t\t<subChar class="">$2/g;
		
		# Inserts closing tags:
		s/(\t\t\t\t\t<subChar class="">[[:lower:] ,\.;\d+\(\)\/&-]+)(\n|<\/subChar>\n|<\/char>\n)/$1<\/subChar>$2/g;
		
		# Inserts newline at closing tag of parent subcharacter:
		s/(<\/subChar>)(<\/char>)/$1\n\t\t\t\t$2/;
		
		
		# Measurements:
		# Diameter:
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m (?:in |)diam(?:\.|eter))/<subChar class="diameter">$1<\/subChar>/g;
		# Height:
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m (?:tall(?!er)|high(?!er)))/<subChar class="height">$1<\/subChar>/g;
		# Length:
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m long(?!er))/<subChar class="length">$1<\/subChar>/g;
		# Thickness:
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m thick(?!er))/<subChar class="thickness">$1<\/subChar>/g;
		# Width:
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m (?:wide(?!r)|broad(?!er)))/<subChar class="width">$1<\/subChar>/g;
		
		# Dimensions (surfaces, sections, etc.):
		s/((?:up to |to |about |± |ca\. |&lt;(?: |)|less than |&gt;(?: |)|greater than |)(?:(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)(?: (?:c|m|µ|)m|) (?:x|×) |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)(?: (?:c|m|µ|)m|) (?:x|×) (?:\(\d+(?:\.\d+|)-\)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m)/<subChar class="dimensions">$1<\/subChar>/g;
		
		# Remainder of dimensions (where it is unknown what dimension is exactly meant):
		s/((?<![>\)\d\.-])(?<!\(\d\) )(?<!\(\d-\) )(?<!\(\d\.\d\) )(?<!\(\d\.\d-\) )(?<! x )(?<! × )(?<!>about )(?<!>± )(?<!>ca\. )(?<!>to )(?<!>up to )(?<!>&lt; )(?<!>&lt;)(?<!>less than )(?<!>&gt; )(?<!>&gt;)(?<!>greater than )(?:up to |(?<!>up )to |about |± |ca\. |)(?:\(\d+(?:\.\d+|)(?:-|)\)(?: |)|)\d+(?:\.\d+|)(?:-\d+(?:\.\d+|)(?:\(-\d+(?:\.\d+|)\)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|)|(?: |)\((?:-|)\d+(?:\.\d+|)\)|) (?:c|m|µ|)m(?![[:lower:]]))/<subChar class="">$1<\/subChar>/g;
		
		
	}
	
	# Characters:
	s/(<(?:subC|c)har class=")(">)((?:the |)acumen)/$1acumen$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)albumen)/$1albumen$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)anther thecae)/$1thecae$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)anthers)/$1anthers$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)appendage(?:s|))/$1appendages$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)apex and base)/$1apex and base$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)apex)/$1apex$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)aril)/$1aril$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)bark)/$1bark$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)blade)/$1blade$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)body)/$1body$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)secondary bracteoles)/$1secondary bracteoles$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)scape bracts)/$1scape bracts$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)floral bracts)/$1floral bracts$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)bracts)/$1bracts$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)fertile branches)/$1fertile branches$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)lateral branches)/$1lateral branches$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)branchlets)/$1branchlets$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)calyculus)/$1calyculus$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)cocci)/$1cocci$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)(?:anther |)connective)/$1connective$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)corolla)/$1corolla$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)cotyledons)/$1cotyledons$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)cystoliths)/$1cystoliths$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)base)/$1base$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)embryo)/$1embryo$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)endocarp)/$1endocarp$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)endosperm)/$1endosperm$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)epicortical roots)/$1epicortical roots$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)exocarp)/$1exocarp$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)filament(?:s|))/$1filaments$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)fertile internodes)/$1fertile internodes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)flower(?:s|))/$1flowers$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)funicle(?:s|))/$1funicles$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)internodes)/$1internodes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)lower lip)/$1lower lip$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)upper lip)/$1upper lip$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)leaflets)/$1leaflets$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)limb)/$1limbs$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)lobe)/$1lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)anterior lobe)/$1anterior lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)calyx lobe)/$1calyx lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)corolla lobe)/$1corolla lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)free portion of lobe)/$1free portion of lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)inner lobe)/$1inner lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)lateral lobe)/$1lateral lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)(?:inferior|lower) lobe)/$1lower lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)middle lobe)/$1middle lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)outer lobe)/$1outer lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)posterior lobe)/$1posterior lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)remaining lobe)/$1remaining lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)(?:superior|upper) lobe)/$1upper lobes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)margin(?:s|))/$1margins$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)marginal cells)/$1marginal cells$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)mesocarp)/$1mesocarp$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)midvein)/$1midveins$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)nodes)/$1nodes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)ovar(?:ies|y))/$1ovary$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)ovule(?:s|))/$1ovules$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)pedicel(?:s|))/$1pedicels$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)dyad peduncle(?:s|))/$1dyad peduncle$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)triad peduncle(?:s|) and pedicel(?:s|))/$1triad peduncles and pedicels$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)triad peduncle(?:s|))/$1triad peduncle$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)peduncle(?:s|))/$1peduncles$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)perianth segments)/$1perianth segments$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)perianth)/$1perianth$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)pericarp)/$1pericarp$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)perisperm)/$1perisperm$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)petals)/$1petals$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)petiole)/$1petiole$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)pollen)/$1pollen$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)rachis with a distal process)/$1processes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)pseudostaminodia)/$1pseudostaminodia$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)pseudostipe)/$1pseudostipes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)primary haustorium)/$1primary haustorium$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)rachis)/$1rachises$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)radicle)/$1radicle$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)retinacula)/$1retinacula$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)rhizome)/$1rhizome$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)sarcocarp)/$1sarcocarp$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)seeds)/$1seeds$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)inner segments)/$1inner segments$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)outer segments)/$1outer segments$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)anterior sepal(?:s|))/$1anterior sepals$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)inner sepal(?:s|))/$1inner sepals$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)outer sepal(?:s|) and posterior sepal)/$1outer and posterior sepals$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)outer sepal(?:s|))/$1outer sepals$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)posterior sepal(?:s|))/$1posterior sepals$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)sepal(?:s|))/$1sepals$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)septa)/$1septa$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)staminal pocket(?:s|))/$1staminal pockets$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)staminode(?:s|))/$1staminodes$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)fertile stems)/$1fertile stems$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)older stem(?:s|))/$1mature stems$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)stigma)/$1stigma$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)stipe)/$1stipe$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)style)/$1style$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)abaxial surface)/$1abaxial surfaces$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)adaxial surface)/$1adaxial surfaces$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)inner surface)/$1inner surfaces$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)lower surface)/$1lower surfaces$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)outer surface)/$1outer surfaces$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)upper surface)/$1upper surfaces$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)tepals)/$1tepals$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)testa)/$1testa$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)thecae)/$1thecae$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)throat)/$1throat$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)tube)/$1tube$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)valves)/$1valves$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)primary vein(?:s|))/$1primary veins$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)secondary vein(?:s|))/$1secondary veins$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)tertiary ve(?:i|)n(?:ation|s))/$1tertiary veins$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)ve(?:i|)n(?:ation|s))/$1veins$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)(?:external|outer) wall(?:s|))/$1outer walls$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)(?:internal|inner) wall(?:s|))/$1inner walls$2$3/g;
	s/(<(?:subC|c)har class=")(">)((?:the |)wing(?:s|))/$1wings$2$3/g;
	
	
	# Fixes:
	s/(expanded <subChar class=")[a-z -]+(">to )/$1$2/;
	
	
	# Missed "to"s in dimensions:
	s/(to )(<subChar class="(?:depth|height|length|width)">)/$2$1/g;
	
	
	
	
	# Counts:
	
	if (/^\t+<(?:subC|c)har/) {
		
		# Merosity:
		s/(?<!<subChar class="merosity">)(?<!\d-)((?:\d-|\d- or (?:mostly |)|\(\d+-\)|)\d-(?:\(\d+-\)|)merous)/<subChar class="merosity">$1<\/subChar>/g;
		
		
		# Series:
		s/((?:\d- or |)\d-seriate(?:, rarely 1-seriate| \(occasionally 3-seriate\)|)|(?:\d or |)\d series)/<subChar class="series">$1<\/subChar>/g;
		
		
		# Paired plant parts:
		
		# Anther pairs:
		s/(anthers (?:coherent |)in )(\d+ pairs)/$1<subChar class="anther pair number">$2<\/subChar>/g;
		
		# Bract pairs:
		s/((?:\(\d+-\)|)\d+(?:-\d+(?:(?: |)\(-\d+\)|)|\(-\d+\)|) pairs)( of bracts)/<subChar class="bract pair number">$1<\/subChar>$2/g;
		# (1-)2(-3) pairs of bracts
		
		# Sterile cataphyll pairs:
		s/((?:(?:to |)\d+(?:-\d+(?:\(-\d+\)|)| or \d+|-several|)|a) (?:crowded |small |very low |)pair(?:s|))( of (?:intercalary, |)sterile cataphylls)/<subChar class="sterile cataphyll pair number">$1<\/subChar>$2/g;
		s/(sterile cataphylls )(\d+(?:-\d+| or \d+(?:\(\d+\)|)|) pair(?:s|))/$1<subChar class="sterile cataphyll pair number">$2<\/subChar>/g;
		
		# Fertile cataphyll pairs:
		s/((?:(?:to |)\d+(?:-\d+(?:\(-\d+\)|)| or \d+|)|a) (?:crowded |small |very low |)pair(?:s|))( of fertile cataphylls)/<subChar class="fertile cataphyll pair number">$1<\/subChar>$2/g;
		# Cataphyll pairs:
		s/((?:(?:to |)\d+(?:-\d+(?:\(-\d+\)|)| or \d+|)|a) (?:crowded |small |very low |)pair(?:s|))( of (?:(?:prominent, yellowish |)basal |(?:very acute |)intercalary |short, brownish, tubular |)cataphylls)/<subChar class="cataphyll pair number">$1<\/subChar>$2/g;
		s/(basal cataphylls (?:of lateral branches |rather small, |))((?:usually |mostly |)\d+(?:-\d+| or \d+(?:\(\d+\)|)|) pair(?:s|))/$1<subChar class="cataphyll pair number">$2<\/subChar>/g;
		
		# Foliage leave pairs:
		s/(\d+ pair)( of foliage leaves)/<subChar class="foliage leaf pair number">$1<\/subChar>$2/g;
		
		# Dyad pairs:
		s/(\d+(?:-\d+(?: \(-\d+\)|)|) pairs)( of dyads)/<subChar class="dyad pair number">$1<\/subChar>$2/g;
		
		
		# Leaflet pairs:
		s/(leaflets )((?:\d+-|)\d+(?:\(-\d+\)|) pairs)/$1<subChar class="leaflet pair number">$2<\/subChar>/g;
		
		
		# Triad pairs:
		s/((?:(?:about |ca\. |)\d+(?:-\d+(?: \((?:-|)\d+\)|)| or \d+|(?: |)\(\d+\)|)|a|(?:one|two|three|four|five)(?: or more|)) pair(?:s|))( of (?:evenly spaced |sessile |)triads)/<subChar class="triad pair number">$1<\/subChar>$2/g;
		s/(triads (?:sessile, |))((?:usually |mostly |)\d+(?:-\d+| or \d+(?:\(\d+\)|)|) pair(?:s|))/$1<subChar class="triad pair number">$2<\/subChar>/g;
		
		# Raceme pairs:
		s/((?:\d+|several)(?:-\d+(?: \(-\d+\)|)|) lateral pairs)( of racemes)/<subChar class="lateral raceme pair number">$1<\/subChar>$2/g;
		
		
		# Scape bract pairs:
		s/((?:S|s)cape bract(?:s) )((?:\(\d+-\)|)\d+(?:-\d+(?:\(-\d+\)|)|\(-\d+\)| or \d+| to few|)(?: equidistant|) pairs)/$1<subChar class="scape bract pair number">$2<\/subChar>/g;
		s/((?:\(\d+-\)|)\d+(?:-\d+(?:\(-\d+\)|)|\(-\d+\)| or \d+| to few|) pairs)( of scape bracts)/<subChar class="scape bract pair number">$1<\/subChar>$2/g;
		# (1-)2-3(-4) pairs of scape bracts
		
		# Secondary vein pairs:
		s/(secondary veins )((?:\(\d+-\)(?: |)|)\d+(?:-\d+(?:(?: |)\(-\d+\)|)|\(-\d+\)|) pairs)/$1<subChar class="secondary vein pair number">$2<\/subChar>/g;
		s/(secondary vein)( )(pairs)( )((?:\(\d+-\)(?: |)|)\d+(?:-\d+(?:(?: |)\((?:-|)\d+\)|)|\((?:-|)\d+\)|))/$1s$2<subChar class="secondary vein pair number">$5$4$3<\/subChar>/g;
		s/((?:\(\d+-\)|)\d+(?:-\d+(?:(?: |)\(-\d+\)|)|) pairs)( of secondary veins)/<subChar class="secondary vein pair number">$1<\/subChar>$2/g;
		
		
		# Sterile bract pairs:
		s/((?:\d|a) (?:low |)pair(?:s|))( of sterile bracts)/<subChar class="sterile bract pair number">$1<\/subChar>$2/g;
		
		
		# Teeth number pairs:
		s/((?:\d+-|)\d+)( pairs of teeth)/<subChar class="teeth pair number">$1<\/subChar>$2/g;
		
		
		
		# Others:
		
		
		# Angle number:
		s/((?:\d+- or |)\d+-angled)/<subChar class="angle number">$1<\/subChar>/g;
		
		
		# Anther number:
		s/(\d+(?:-\d+| or \d+|))( anther(?:s|))/<subChar class="anther number">$1<\/subChar>$2/g;
		
		
		# Appendage number:
		s/(appendage(?:s|) )(\d+(?:-\d+| or \d+|\(\d+\)| or more|))/$1<subChar class="appendage number">$2<\/subChar>/g;
		
		
		
		# Apical bristle number:
		s/(\d+)( (?:retrorse |)apical bristles)/<subChar class="apical bristle number">$1<\/subChar>$2/g;
		
		
		# Awn number:
		s/(\d+(?:-\d+|))( (?:retrorse (?:hook-like |)|apical hooked |)awns)/<subChar class="awn number">$1<\/subChar>$2/g;
		
		
		# Bract and bracteole number:
		s/(\d+(?:-\d+| or \d+|))( bract(?:s|) (?:and|or) bracteole(?:s|))/<subChar class="bract and bracteole number">$1<\/subChar>$2/g;
		
		# Bracteole number:
		s/(\d+(?:-\d+| or \d+|))( bracteole(?:s|))/<subChar class="bracteole number">$1<\/subChar>$2/g;
		s/(bracteoles )(\d+(?:-\d+| or \d+|\(\d+\)| or more|))/$1<subChar class="bracteole number">$2<\/subChar>/g;
		s/((?:\d+-(?: or |)|)\d+-bracteolate)/<subChar class="bracteole number">$1<\/subChar>/g;
		
		# Bract number:
		s/((?:\d+- or |)\d+-bracteate)/<subChar class="bract number">$1<\/subChar>/g;
		s/(\d+(?:-\d+| or \d+|))( bract(?:s|)(?!eole))/<subChar class="bract number">$1<\/subChar>$2/g;
		s/(bracts )(\d+(?:-\d+| or \d+|\(\d+\)| or more|))/$1<subChar class="bract number">$2<\/subChar>/g;
		
		
		# Branch number:
		s/((?:\d+- or |)\d+-branched)/<subChar class="branch number">$1<\/subChar>/g;
		
		
		# Carpel number:
		s/((?:\d+- or |)\d+(?:\((?:-|)\d+\)|)-carpellate)/<subChar class="carpel number">$1<\/subChar>/g;
		s/((?:\(\d+\)(?: |)|)\d+(?:-\d+|)(?:(?: |)\((?:-|)\d+\)| or \d+| or more|))( (?:connate |)carpel(?:s|))/<subChar class="carpel number">$1<\/subChar>$2/g;
		s/(carpels )(\d+(?:-\d+| or \d+|\(\d+\)| or more|))(?!-ovuled)/$1<subChar class="carpel number">$2<\/subChar>/g;
		# (2)3-5(6) carpels
		
		# Cataphyll number:
		s/((?:basal |)cataphylls )(\d+(?:-\d+| or \d+|\(\d+\)|))/$1<subChar class="cataphyll number">$2<\/subChar>/g;
		
		
		# Cell number:
		s/((?:\(\d+\) |)\d+(?:-\d+| or \d+| or more|))(-celled)/<subChar class="cell number">$1<\/subChar>$2/g;
		
		
		# Cotyledon number:
		s/((?:\(\d+\) |)\d+(?:-\d+| or \d+| or more|))( (?:large, fleshy |)cotyledon(?:s|))/<subChar class="cotyledon number">$1<\/subChar>$2/g;
		s/(cotyledon(?:s|) )(\d+(?:-\d+| or \d+|\(\d+\)|))/$1<subChar class="cotyledon number">$2<\/subChar>/g;
		
		
		# Division number:
		s/((?:ca\. |)\d+(?:-\d+| or \d+|))( division(?:s|))/<subChar class="division number">$1<\/subChar>$2/g;
		
		
		# Dyad number:
		s/(umbel of )(\d+)( dyads)/$1<subChar class="dyad number per umbel">$2<\/subChar>$3/g;
		
		
		# Epicortical root number:
		s/(\d+(?:-\d+| or \d+|))( (?:stout, unbranched |)epicortical roots)/<subChar class="epicortical root number">$1<\/subChar>$2/g;
		
		
		# Flower number:
		# Per bract:
		s/(flower(?:s|) )((?:mostly (?:to |)|to |\(\d+\)|)\d+(?:-\d+(?:\(\d+\)|)| or \d+|\(\d+\)|))( per (?:fertile |)bract)/$1<subChar class="flower number per bract">$2<\/subChar>$3/g;
		s/((?:mostly (?:to |)|to |\(\d+\)|)\d+(?:-\d+(?:\(\d+\)|)| or \d+|\(\d+\)|))( flowers per (?:fertile |)bract)/<subChar class="flower number per bract">$1<\/subChar>$2/g;
		s/(each fertile bract with )(\d+(?:-\d+(?:\(\d+\)|)| or \d+|\(\d+\)|))( flowers)/$1<subChar class="flower number per bract">$2<\/subChar>$3/g;
		
		# Per cluster:
		s/((?:F|f)lower(?:s|) )((?:mostly (?:to |)|to |\(\d+(?:-|)\)|)\d+(?:-\d+(?:\((?:-|)\d+\)|)| or \d+|\((?:-|)\d+\)|))( per (?:multibracteolate |)cluster)/$1<subChar class="flower number per cluster">$2<\/subChar>$3/g;
		
		# Per fascicle:
		s/((?:F|f)lower(?:s|) )((?:mostly (?:to |)|to |\(\d+(?:-|)\)|)\d+(?:-\d+(?:\(\d+\)|)| or \d+|\(\d+\)|) in a fascicle)/$1<subChar class="flower number per fascicle">$2<\/subChar>/g;
		
		# Per inflorescence:
		s/((?:\d+-(?: to |)|few-|)(?:\d+(?:\(-\d+\)|)|few|many|several)-flowered)((?:, epedunculate|) inflorescences)/<subChar class="flower number per inflorescence">$1<\/subChar>$2/g;
		s/(Inflorescence(?:s|) )((?:\d+-(?: to |)|few-|)(?:\d+(?:\(-\d+\)|)|few|many|several)-flowered)/$1<subChar class="flower number per inflorescence">$2<\/subChar>/g;
		s/((?:F|f)lower(?:s|) )((?:\d+-(?: to |)|few-|)(?:\d+(?:\(-\d+\)|)|few|many|several))( per inflorescence)/$1<subChar class="flower number per inflorescence">$2<\/subChar>$3/g;
		
		# Per internode:
		s/(flower(?:s|) )((?:mostly (?:to |)|to |\(\d+\)|)\d+(?:-\d+(?:\(\d+\)|)| or \d+|\(\d+\)|) per (?:fertile |)internode)/$1<subChar class="flower number per internode">$2<\/subChar>/g;
		
		# Per raceme:
		s/((?:\d+-(?: to |)|few-|)(?:\d+(?:\(-\d+\)|)|few|several)-flowered)((?:, epedunculate|) raceme)/<subChar class="flower number per raceme">$1<\/subChar>$2/g;
		
		
		# Per spike:
		s/(flower(?:s|) )((?:mostly (?:to |)|to |\(\d+\)|)\d+(?:-\d+(?:\(\d+\)|)| or \d+|\(\d+\)|) per (?:fertile |)spike)/$1<subChar class="flower number per spike">$2<\/subChar>/g;
		s/(\d+-flowered)( spikes)/<subChar class="flower number per spike">$1<\/subChar>$2/g;
		s/(\d+)( flowers)( or more)( per spike)/<subChar class="flower number per spike">$1$3<\/subChar>$2$4/g; # "or more" is moved here
		s/(large spikes bearing )((?:to |)(?:ca\. |)\d+)( flowers)/$1<subChar class="flower number per spike">$2<\/subChar>$3/g;
		
		# Normal:
		s/(class="flowers">(?:with |often |))((?:± |)(?:\d+-|\(\d+-\)|\d+ or |)\d+(?: or many|-\d+|)|numerous)( (?:ebracteolate |)flowers)/$1<subChar class="flower number">$2<\/subChar>$3/g;
		s/((?:± |ca\. |)(?:\d+-(?: to |)|few-(?: to |)|\(\d+-\)|)(?:\d+(?:\(-\d+\)|)|few|many|several)-flowered)/<subChar class="flower number">$1<\/subChar>/g;
		s/((?:± |)(?:(?:\(\d+-\)|)\d+-(?: to |)|few-(?: to |)|)(?:\d+(?:\(-\d+\)|)|few|many|several))( flowers)/<subChar class="flower number">$1<\/subChar>$2/g;
		s/((?:F|f)lower(?:s|) )((?:ca\. |mostly (?:to |)|to |\(\d+\)|)\d+(?:-\d+(?:\(\d+\)|)| or \d+|\(\d+\)| to (?:numerous|several)|))/$1<subChar class="flower number">$2<\/subChar>/g;
		
		# Additional flowers:
		s/(\d+(?:-\d+| or \d+|))( additional flower(?:s|))/<subChar class="additional flower number">$1<\/subChar>$2/g;
		
		# Pistillate flowers:
		s/((?:P|p)istillate flower(?:s|) )((?:mostly (?:to |)|to |\(\d+\)|)\d+(?:-\d+(?:\(\d+\)|)| or \d+|\(\d+\)| to (?:numerous|several)|))/$1<subChar class="pistillate flower number">$2<\/subChar>/g;
		
		# Staminate flowers:
		s/((?:S|s)taminate flower(?:s|) )((?:mostly (?:to |)|to |\(\d+\)|)\d+(?:-\d+(?:\(\d+\)|)| or \d+|\(\d+\)| to (?:numerous|several)|)|(?:(?:a |)few|several) to numerous)/$1<subChar class="staminate flower number">$2<\/subChar>/g;
		
		
		
		# Fruit number:
		# Per bract:
		s/(fruit(?:s|) )((?:mostly (?:to |)|to |\(\d+\)|)\d+(?:-\d+(?:\(\d+\)|)| or \d+|\(\d+\)|) (?:above|per) (?:each |)fertile bract)/$1<subChar class="fruit number per bract">$2<\/subChar>/g;
		
		
		# Gland number:
		s/((?:\d+ or |\(\d+\)|\d+-)\d+)((?: discrete| separate or connate nectariferous|) glands)/<subChar class="gland number">$1<\/subChar>$2/g;
		
		# Inflorescence number:
		# Per axil:
		s/(har class="(?:inflorescences|racemes|spikes)".+?)((?:mostly |usually |)\d+(?:-\d+|-several|))((?: inflorescences|) per (?:foliar |leaf |)axil)/$1<subChar class="inflorescence number per axil">$2<\/subChar>$3/g;
		
		# Normal:
		s/((?:I|i)nflorescence(?:s|) )((?:usually |)\d+(?:-\d+| or \d+|\(\d+\)|))/$1<subChar class="inflorescence number">$2<\/subChar>/g;
		
		
		# Internode number:
		# Fertile internode number:
		s/(fertile internode(?:s|) )((?:mostly |usually |)(?:\(\d+\)|)\d+(?:-\d+(?:\(\d+\)|)| or \d+|\(\d+\)|))/$1<subChar class="fertile internode number">$2<\/subChar>/g;
		s/(\d+(?:-\d+| or \d+|))( fertile internode(?:s|))/<subChar class="fertile internode number">$1<\/subChar>$2/g;
		
		# Sterile internode number:
		s/(sterile internode(?:s|) )((?:usually |)\d+(?:-\d+| or \d+|\(\d+\)|))/$1<subChar class="sterile internode number">$2<\/subChar>/g;
		s/(\d+(?:-\d+| or \d+|))( sterile internode(?:s|))/<subChar class="sterile internode number">$1<\/subChar>$2/g;
		
		# Internode number:
		s/(\d+(?:-\d+| or \d+|))( (?:percurrent |)internode(?:s|))/<subChar class="internode number">$1<\/subChar>$2/g;
		
		
		# Leaflet number:
		s/(leaflets )((?:\d+-|\(\d+\)(?: |)|)\d+(?:-\d+| or \d+|(?: |)\(\d+\)|))/$1<subChar class="leaflet number">$2<\/subChar>/g;
		
		
		
		# Lip number:
		s/((?:\d+- or |sometimes |)\d+-lipped)/<subChar class="lip number">$1<\/subChar>/g;
		
		
		# Lobe number:
		s/((?:\d+-(?: or | to |)|)\d+(?:\((?:-|)\d+\)|)-lobed)/<subChar class="lobe number">$1<\/subChar>/g;
		s/((?:\d+ or |\(\d+\)|)\d+)((?: equal or unequal|) lobes)/<subChar class="lobe number">$1<\/subChar>$2/g;
		s/(lobes )(\d+(?:-\d+| or \d+|\(\d+\)|))/$1<subChar class="lobe number">$2<\/subChar>/g;
		
		
		# Locule number:
		s/((?:presumedly |)(?:\(\d+-\)|)\d+(?:-\d+|- (?:and|to) \d+|(?:-\d+|)(?: |)\((?:rarely-|)(?:-|)\d+\)|)-locul(?:a(?:r|te)|ed))/<subChar class="locule number">$1<\/subChar>/g;
		s/(\d+(?:- and \d+|(?: |)\(\d+\)|, \d, or numerous|))( locules)/<subChar class="locule number">$1<\/subChar>$2/g;
		s/(locules )(\d+(?:- and \d+|(?: |)\(\d+\)|, \d, or numerous|))/$1<subChar class="locule number">$2<\/subChar>/g;
		
		
		# Marginal cell number:
		s/(marginal cells )((?:ca\. |)\d+(?:-\d+| or \d+|))/$1<subChar class="marginal cell number">$2<\/subChar>/g;
		
		
		# Mericarp number:
		s/((?:M|m)ericarps )(\d+(?:- and \d+|(?: |)\(\d+\)|, \d, or numerous|))/$1<subChar class="mericarp number">$2<\/subChar>/g;
		
		
		# Monocarp number:
		s/((?:\d+ or |\(\d+\)|)\d+(?:\((?:-|)\d+\)|)|single)((?: basally connate,|) monocarp(?:s|))/<subChar class="monocarp number">$1<\/subChar>$2/g;
		# 1(-2)  monocarps
		
		# Ovule number:
		# per carpel:
		s/(ovule(?:s|) (?:usually |))(\d+(?:-\d+| or \d+|) per carpel)/$1<subChar class="ovule number per carpel">$2<\/subChar>/g;
		
		# per locule:
		s/(ovule(?:s|) (?:usually |))(\d+(?:-\d+| or \d+|\(-\d+\)|) (?:in each|per) locule)/$1<subChar class="ovule number per locule">$2<\/subChar>/g;
		s/((?:\d+-|)\d+)((?: collateral| superposed|) ovule(?:s|) (?:in each|per) locule)/<subChar class="ovule number per locule">$1<\/subChar>$2/g;
		
		# Normal:
		s/(\d+-ovul(?:ate|ed))/<subChar class="ovule number">$1<\/subChar>/g;
		s/((?:\d+-|)\d+)((?: usually anatropous|) ovule(?:s|))/<subChar class="ovule number">$1<\/subChar>$2/g;
		s/(ovule(?:s|) (?:usually |))(\d+(?:-\d+| or \d+|)|numerous)/$1<subChar class="ovule number">$2<\/subChar>/g;
		
		
		# Partition number:
		s/(\d+(?:-\d+| or \d+|))( (?:incomplete |)partitions)/<subChar class="partition number">$1<\/subChar>$2/g;
		
		
		# Perianth segment number:
		s/(\d+(?:-\d+| or \d+|))( (?:minute, caducous |)perianth segments)/<subChar class="perianth segment number">$1<\/subChar>$2/g;
		s/(perianth segments )(\d+)/$1<subChar class="perianth segment number">$2<\/subChar>/g;
		
		# Petal number:
		s/(petals )((?:\(\d+-\)|)\d+(?:-\d+| or \d+|)(?:\(-\d+\)|))/$1<subChar class="petal number">$2<\/subChar>/g;
		s/(\d+(?:-\d+| or \d+|))((?: connate|) petals)/<subChar class="petal number">$1<\/subChar>$2/g;
		
		
		# Petal and stamen number:
		s/(petals and stamens )(\d+(?:-\d+| or \d+|))/$1<subChar class="petal and stamen number">$2<\/subChar>/g;
		
		
		# Pistil number:
		s/((?:P|p)istil(?:s|) )(\d+(?:-\d+| or \d+|))/$1<subChar class="pistil number">$2<\/subChar>/g;
		
		# Pollen:
		# Pollen sacs:
		s/(\d+(?:-\d+| or \d+|))( inner pollen sacs)/<subChar class="inner pollen sac number">$1<\/subChar>$2/g;
		s/(\d+(?:-\d+| or \d+|))( outer pollen sacs)/<subChar class="outer pollen sac number">$1<\/subChar>$2/g;
		s/(\d+(?:-\d+| or \d+|))( (?:minute |)pollen sacs)/<subChar class="pollen sac number">$1<\/subChar>$2/g;
		s/(pollen sacs )(\d+(?:-\d+| or \d+|))/$1<subChar class="pollen sac number">$2<\/subChar>/g;
		
		# Aperture number:
		s/(\d+(?:-\d+| or \d+|))( aperturate)/<subChar class="pollen aperture number">$1<\/subChar>$2/g;
		
		
		# Prophylls:
		s/(\d+(?:-\d+| or \d+|))( prophylls)/<subChar class="prophyllum number">$1<\/subChar>$2/g;
		
		
		# Rib number:
		s/((?:\d+-(?: to |)|)\d+-(?:costulate|ribbed))/<subChar class="rib number">$1<\/subChar>/g;
		s/(\d+(?:-\d+| or \d+|))((?: longitudinal shallow|) ribs)/<subChar class="rib number">$1<\/subChar>$2/g;
		
		
		# Ridge number:
		s/((?:\d+-|)\d+-ridged)/<subChar class="ridge number">$1<\/subChar>/g;
		s/(ridge(?:s|) )(\d+)/$1<subChar class="ridge number">$2<\/subChar>/g;
		
		
		# Row number:
		s/(\d+(?:-\d+| or \d+|))( row(?:s|))/<subChar class="row number">$1<\/subChar>$2/g;
		
		
		# Scape number:
		s/((?:S|s)capes )(\d+(?:-\d+| or \d+| to few|))/$1<subChar class="scape number">$2<\/subChar>/g;
		
		
		# Scape bract number:
		s/((?:S|s)cape bract(?:s) )(\d+(?:-\d+| or \d+| to few|))/$1<subChar class="scape bract number">$2<\/subChar>/g;
		
		
		# Seed number:
		# Per locule:
		s/((?:S|s)eed(?:s|) )(\d+)( per locule)/$1<subChar class="seed number per locule">$2<\/subChar>$3/g;
		# Normal:
		s/((?:(?:\d-|)\d+|one)-seeded)/<subChar class="seed number">$1<\/subChar>/g;
		s/((?:(?:ca\. |)\d-|)\d+)( seeds)/<subChar class="seed number">$1<\/subChar>$2/g;
		s/((?:S|s)eed(?:s|) )(numerous|(?:\d+-|)\d+(?:-many|-numerous| or \d+|))/$1<subChar class="seed number">$2<\/subChar>/g;
		
		
		# Sepal number:
		s/((?:S|s)epals )((?:\(\d+(?:-|)\)(?: |)|)\d+(?:-\d+|\(-\d+\)| or \d+|))/$1<subChar class="sepal number">$2<\/subChar>/g;
		s/((?:\(\d+(?:-|)\)(?:-|)|)\d+(?:-\d+| or \d+|(?:-|)\(\d+\)|))(?: free| fused| unequal|)( sepals)/<subChar class="sepal number">$1<\/subChar>$2/g;
		# (3)-5-(7) free sepal
		
		# Segment number:
		s/((?:\d+-(?: or |)|)\d+(?:\(\d+(?:-\d+|)\)|)-partite)/<subChar class="segment number">$1<\/subChar>/g;
		
		
		# Spike number:
		s/((?:S|s)pike(?:s|) )((?:ca\. |mostly |)(?:\(\d+(?:-|)\)|)(?:\d+ or |\d+-|)\d+(?:\(-\d+\)|))/$1<subChar class="spike number">$2<\/subChar>/g;
		s/((?:ca\. |mostly |)(?:\(\d+(?:-|)\)|)(?:\d+ or |\d+-|)\d+(?:\(-\d+\)|))( spikes)/<subChar class="spike number">$1<\/subChar>$2/g;
		
		# Staminode number:
		s/(\d+(?:-\d+| or \d+|))( staminodes)/<subChar class="staminode number">$1<\/subChar>$2/g;
		s/((?:S|s)taminode(?:s|) )((?:ca\. |)(?:\(\d+(?:-|)\)|)(?:\d+ or |\d+-|)\d+(?:\(-\d+\)|))/$1<subChar class="staminode number">$2<\/subChar>/g;
		
		
		# Stamen number:
		s/(\d+(?:-\d+| or \d+|))( stamens)/<subChar class="stamen number">$1<\/subChar>$2/g;
		s/((?:S|s)tamen(?:s|) )((?:usually |ca\. |)(?:\(\d+(?:-(?:\d+|)|)\)(?: |)|\(\d+, \d+\)(?: |)|)(?:\d+ or |\d+-|)\d+(?:(?: |)\((?:-|)\d+\)|-many|))/$1<subChar class="stamen number">$2<\/subChar>/g;
		
		
		# Stigmatic lobe number:
		s/(\d+(?:-\d+| or \d+|))( stigmatic lobe(?:s|))/<subChar class="stigmatic lobe number">$1<\/subChar>$2/g;
		s/((?:S|s)tigmatic lobe(?:s|) )((?:ca\. |)(?:\(\d+-\)|)(?:\d+ or |\d+-|)\d+)/$1<subChar class="stigmatic lobe number">$2<\/subChar>/g;
		
		
		# Stigma number:
		s/(\d+(?:-\d+| or \d+|))( stigma(?:s|))/<subChar class="stigma number">$1<\/subChar>$2/g;
		s/((?:S|s)tigma(?:s|) )((?:ca\. |usually |)(?:\(\d+-\)|)(?:\d+ or |\d+-|)\d+)/$1<subChar class="stigma number">$2<\/subChar>/g;
		
		
		# Style number:
		s/((?:S|s)tyle(?:s|) )((?:\(\d+-\)|)\d+(?:-numerous|-\d+|))/$1<subChar class="style number">$2<\/subChar>/g;
		
		
		# Sulcus number:
		s/(\d+(?:-\d+| or \d+|))(-sulcate)/<subChar class="sulcus number">$1$2<\/subChar>/g;
		s/(\d+(?:-\d+| or \d+|))( sulc(?:us|i))/<subChar class="sulcus number">$1<\/subChar>$2/g;
		s/((?:S|s)ulc(?:us|i) )((?:ca\. |)(?:\(\d+-\)|)(?:\d+ or |\d+-|)\d+)/$1<subChar class="sulcus number">$2<\/subChar>/g;
		
		
		# Teeth number:
		# Per side:
		s/((?:\d+-|\(\d+-\)|)\d+)( teeth per side)/<subChar class="teeth number per side">$1<\/subChar>$2/g;
		
		# Normal:
		s/((?:\d+-(?: or |)|\(\d+-\)|)\d+(?:\(-\d+\)|)-(?:dent(?:icul|)ate|t(?:ee|oo)thed))/<subChar class="teeth number">$1<\/subChar>/g;
		
		
		# Thecae number:
		s/((?:\d+- or |)\d+-thecous)/<subChar class="thecae number">$1<\/subChar>/g;
		
		# Tepal number:
		s/(\d+(?:-\d+| or \d+|))( tepal(?:s|))/<subChar class="tepal number">$1<\/subChar>$2/g;
		s/((?:T|t)epals )((?:\(\d+(?:-| or|)\)|)(?: |)\d+(?:-\d+| or \d+|\(-\d+\)|))/$1<subChar class="tepal number">$2<\/subChar>/g;
		# (3 or) 4
		
		# Triad number:
		# Per umbel:
		s/(umbel of )(\d+)( triads)/$1<subChar class="triad number per umbel">$2<\/subChar>$3/g;
		# Normal:
		s/((?:at least |)\d+(?:-\d+|))( (?:sessile |)triads)/<subChar class="triad number">$1<\/subChar>$2/g;
		
		
		# Undulation number:
		s/((?:\d+- or |\d+-(?: to |)|)(?:\d+|several)-undulate)/<subChar class="undulation number">$1<\/subChar>/g;
		
		
		# Valve number:
		s/((?:\d+- or |\d+-(?: to |)|)(?:\d+|several)-valved)/<subChar class="valve number">$1<\/subChar>/g;
		s/((?:\d+- or |\d+-(?: to |)|)(?:\d+|several))( valves)/<subChar class="valve number">$1<\/subChar>$2/g;
		
		
		# Vein number:
		s/((?:\d+- or |\d+-(?: to |)|)(?:\d+|several)-veined(?: from base|))/<subChar class="vein number">$1<\/subChar>/g;
		
		# Secondary vein number:
		# Per side:
		s/(secondary veins )((?:\d+-|)\d+(?:-\d+(?:\(-\d+\)|)|\(-\d+\)|))( (?:on each|per) side)/$1<subChar class="secondary vein number per side">$2<\/subChar>$3/g;
		
		
		# Whorl number:
		s/((?:\d+-|)\d+-whorled)/<subChar class="whorl number">$1<\/subChar>/g;
		s/((?:(?:\d+-|\d+ or |)\d+|two) whorls)/<subChar class="whorl number">$1<\/subChar>/g;
		s/(whorls )(\d+(?:-\d+| or \d+|))/$1<subChar class="whorl number">$2<\/subChar>/g;
		
		
		# Wing number:
		s/((?:\d+-|)\d+-winged)/<subChar class="wing number">$1<\/subChar>/g;
		s/(\d+(?:-\d+| or \d+|))( (?:thin |)wings)/<subChar class="wing number">$1<\/subChar>$2/g;
		
		
		
	}
	
	
	
	# Method used for colors seems to work fine :) Still need to rewrite some things.
	# Further atomisation, originally for pilot study (Hester), now for all remaining vols.:
	
	if (/^\t+<(?:subC|c)har/) {
		
		# Colours:
		# Finding first colour-related word in line:
		s/(har class="(?:[a-z -]+|)">.+? )((?:becoming |deep |drying |dull |inside |)(?:bright(?:er|) |dark(?:er|) |dull(?:er|)|entirely |light(?:er|) |pale(?:r|) |pastel |rich(?:er|) |waxy |)(?:aquamarine|azure|black(?:ish|)|blu(?:e|ish)|brown(?:ish|)|champagne|chrome|colo(?:u|)red|colo(?:u)rful|cream(?:ish|)|crimson|cyan|discolorous|dull|ferrugin(?:e|)ous|gold(?:en|ish|)|green(?:ish|)|gr(?:a|e)y(?:ish|)|indigo|(?:metallic-|)iridescent|lavender|lilac|lustrous|magenta|maroon|nitid|olive|orang(?:e|ish)|pink(?:ish|)|purpl(?:e|ish)|(?:brick |wine-|)red(?:dish|)|rose|rufous|scarlet|silver(?:ish|)|straw-colo(?:u|)red|tan(?:ish|)|transparent|turquoise|variously colored|vermillion|violet|whit(?:e|ish)|yellow(?:ish|))(?: |\.|,|;|:|-))/$1<subChar class="colour">$2/g;
		# Collecting remaining colour-related words in line:
		s/(<subChar class="colour">(?:.+|)(?:aquamarine|azure|black(?:ish|)|blu(?:e|ish)|brown(?:ish|)|champagne|chrome|colo(?:u|)red|colo(?:u)rful|cream(?:ish|)|crimson|cyan|discolorous|dull|ferrugin(?:e|)ous|gold(?:en|ish|)|green(?:ish|)|gr(?:a|e)y(?:ish|)|indigo|(?:metallic-|)iridescent|lavender|lilac|lustrous|magenta|maroon|nitid|olive|orang(?:e|ish)|pink(?:ish|)|purpl(?:e|ish)|(?:brick |wine-|)red(?:dish|)|rufous|rose|scarlet|silver(?:ish|)|straw-colo(?:u|)red|tan(?:ish|)|transparent|turquoise|variously colored|vermillion|violet|whit(?:e|ish)|yellow(?:ish|))(?:-dotted|-tinged| base| (?:on|when) dry(?:ing|)| in fruit| at maturity| markings| (?:in|out)side| upon drying| in dry state|))(?!\n)/$1<\/subChar>/g;
		
		
		# Growth form:
		# Finding first growth form-related word in line:
		s/(har class="(?:[a-z -]+|)">.+? )((?:more or less |occasionally |slightly |some(?:times|what) |usually |)(?:clambering|creeping|erect|multi(?:-|)stemmed|nodding|parted|pendent|recurved|repent|scandent|sprawling|spreading)(?!, smooth calyculus\.)(?! leaves)(?: |\.|,|;|:|-))/$1<subChar class="growth form">$2/g;
		# Collecting remaining growth form-related words in line:
		s/(<subChar class="growth form">(?:.+|)(?:clambering|creeping|erect|multi(?:-|)stemmed|nodding|parted|pendent|recurved(?: in upper 1\/2 or 1\/3 only|)|repent|scandent|sprawling|spreading))(?!\n)/$1<\/subChar>/g;
		
		
		# Hairs:
		# Finding first hair-related word in line:
		s/(har class="(?:[a-z -]+|)">.+? )((?:above |appressed(?: |-)|basally |both surfaces |(?:outside |sparsely to |)densely |dorsally |fairly |inside |lacking |minutely |more or less |mostly |nearly |often |outside |rather |short |slightly |softly |somewhat |sparingly |(?:above |)sparsely |strongly |very |weakly |)(?:appressed|canescent|cili(?:ol|)ate|cinereous|<subChar class="colour">ferrugin(?:e|)ous|furfuraceous|glabr(?:ate|escent|ous)|hair(?:less|s|y)|hirsute|hirtellous|hispid(?:ulous|)|lanate|lanose|lepidote|pilos(?:e|ulous)|(?:hirto-|)puberul(?:ent|ous)|(?:appressed |)pubescent|<subChar class="colour">rufous|sericeous|strig(?:ill|)ose|(?:hirto(?:us|)-|)toment(?:ellous|(?:ul|)ose)|trichome(?:s|)|velutinous|villo(?:se|sulous|us)|wooly)(?: |\.|,|;|:|-|<))/$1<subChar class="hairs">$2/g;
		# Collecting remaining hair-related words in line:
		s/(<subChar class="hairs">(?:.+|)(?:appressed|canescent|cili(?:ol|)ate|cinereous|ferrugin(?:e|)ous|furfuraceous|glabr(?:ate|escent|ous)|hair(?:less|s|y)|hirsute|hirtellous|hispid(?:ulous|)|lanate|lanose|lepidote|pilos(?:e|ulous)|(?:hirto-|)puberul(?:ent|ous)|(?:appressed |)pubescent|rufous|sericeous|strig(?:ill|)ose|(?:hirto(?:us|)-|)toment(?:ellous|(?:ul|)ose)|trichome(?:s|)|velutinous|villo(?:se|sulous|us)|wooly)(?: above| at (?:apex|base)| (?:in|out)side| on both surfaces| on exterior|  on lower half| when mature| without|))(?!\n)/$1<\/subChar>/g;
		
		
		# Margin type:
		# Finding first margin type-related word in line:
		s/(har class="margins">.+? )((?:fairly |minutely |more or less |nearly |often |rather |short |slightly |softly |somewhat |sparsely |very |± |)(?:(?:sub|)crenate|(?:sub|)crenulate|(?:sub|)dentate|(?:sub|)entire|(?:sub|)erose|(?:sub|)lacerate|(?:sub|)serrate|(?:sub|)serrulate|(?:sub|)sinuate|(?:sub|)spinose|(?:sub|)undulate)(?: |\.|,|;|:|-))/$1<subChar class="margin type">$2/g;
		# Collecting remaining margin type-related words in line:
		s/(<subChar class="margin type">(?:.+|)(?:(?:sub|)crenate|(?:sub|)crenulate|(?:sub|)dentate|(?:sub|)entire|(?:sub|)erose|(?:sub|)lacerate|(?:sub|)serrate|(?:sub|)serrulate|(?:sub|)sinuate|(?:sub|)spinose|(?:sub|)undulate))(?!\n)/$1<\/subChar>/g;
		
		
		
		# Position:
		# Finding first position-related word in line:
		s/(har class="(?:[a-z -]+|)">.+? )((?:both |former in |mostly |nearly |(?:in uppermost leaf axils, |)not (?:truly |)|)(?:(?:supra-|)axillary(?: only(?:\?|)|)|cauliflorous|distal|lateral|pendulous|ramiflorous|terminal)(?! corky)(?! horn)(?: |\.|,|;|:|-))/$1<subChar class="position">$2/g;
		# Collecting remaining position-related words in line:
		s/(<subChar class="position">(?:.+|)(?:(?:supra-|)axillary(?: only(?:\?|)|)|cauliflorous|distal|lateral|pendulous|ramiflorous|terminal)(?: and in nearby axils| and at older nodes|))(?!\n)/$1<\/subChar>/g;
		
		# Questionable cases, removal of character class:
		s/(<subChar class=")(position)(">.+?<\/subChar> (?:branch|flower|groups|inflorescence|leaves|ligule|ones|pair|raceme))/$1$3/;
		
		
		
		
		# Shape:
		# Finding first shape-related word in line:
		s/(har class="(?:[a-z -]+|)">.+? )((?:broadly |deeply |irregularly |more or less |mostly |narrowly |nearly |obliquely |obtusely |short |slightly |somewhat |strongly |usually |varying from |widely |)(?:acicular|(?:sub|)acuminate|(?:sub|\(sub\)|)acute|ampliate|angled|(?:sub|)angular|(?:sub|)apiculate|(?:a|)symmetrical|attenuate|auriculate|(?:sub|)campanulate|canaliculate|(?:sub|)capitate|(?:sub|)carinate|(?:semi|sub|)circular|(?:sub|)clavate|(?:tri|)coccate|(?:lenticular-|)cochleate|(?:sub|)concave|(?:ob|)conic(?:al|)|connate|(?:sub|)cordate|cordiform|cuboidal|cucullate|(?:sub|)cuneate|cup-shaped|cupuliform|cuspidate|(?:sub|)cylindric(?:al|)|decurrent|deltate|deltoid|divaricate|dome-like|(?:ob|sub|)ellip(?:soid|tic(?:al|))|(?:sub|)elongate(?:d|)|(?:sub|)falcate|filiform|flat(?:tened|tish|)|folded|funnel(?:form|-shaped)|fusiform|(?:semi|sub|trigono-|turbinate-|)globose|(?:sub|)globular|gutter-shaped|(?:sub|)hexagonal|hippocrepiform|infundibuliform|(?:(?:linear-|)ob|\(ob\)|wide-|)lance(?:olate|)|lanciform|lenticular|ligulate|(?:sub|)linear|lineate|mucronate|(?:sub|)oblique|(?:sub|)oblong(?:oid|)|obtuse|(?:cochleate-|sub|)orbicula(?:r|te)|(?:(?:sub|)ob|\(ob\)|lance-|)ovate|(?:ob|sub|)ovoid|(?:sub|)paniculate|pentagonal|pulvinate|pyriform|(?:sub|)quadrangular|(?:sub|)quadrate|racemiform|(?:ir|)regular|(?:sub|)rhomb(?:ate|ic)|(?:lenticular-|sub|)reniform|retuse|rotundate|(?:sub|)round(?:ed|)|sagittate|salver(?:form|-shaped)|slender|(?:sub|)spat(?:h|)ulate|(?:sub|)spheric(?:al|)|striate|submarginate|subulate|(?:sub|)terete|(?:sub|)thyrsiform|(?:sub|)triangular|trigonous|truncate|tubular|unguiculate|urceolate|winged)(?: |\.|,|;|:|-))/$1<subChar class="shape">$2/g;
		# Collecting remaining shape-related words in line:
		s/(<subChar class="shape">(?:.+|)(?:acicular|(?:sub|)acuminate|(?:sub|\(sub\)|)acute|ampliate|angled|(?:sub|)angular|(?:sub|)apiculate|(?:a|)symmetrical|attenuate|auriculate|(?:sub|)campanulate|canaliculate|(?:sub|)capitate|(?:sub|)carinate|(?:semi|sub|)circular|(?:sub|)clavate|(?:tri|)coccate|(?:lenticular-|)cochleate|(?:sub|)concave|(?:ob|)conic(?:al|)|connate|(?:sub|)cordate|cordiform|cuboidal|cucullate|(?:sub|)cuneate|cup-shaped|cupuliform|cuspidate|(?:sub|)cylindric(?:al|)|decurrent|deltate|deltoid|divaricate|dome-like|(?:ob|sub|)ellip(?:soid|tic(?:al|))|(?:sub|)elongate(?:d|)|(?:sub|)falcate|filiform|flat(?:tened|tish|)|folded|funnel(?:form|-shaped)|fusiform|(?:semi|sub|trigono-|turbinate-|)globose|(?:sub|)globular|gutter-shaped|(?:sub|)hexagonal|hippocrepiform|infundibuliform|(?:(?:linear-|)ob|\(ob\)|wide-|)lance(?:olate|)|lanciform|lenticular|ligulate|(?:sub|)linear|lineate|mucronate|(?:sub|)oblique|(?:sub|)oblong(?:oid|)|obtuse|(?:cochleate-|sub|)orbicula(?:r|te)|(?:(?:sub|)ob|lance-|)ovate|(?:ob|sub|)ovoid|(?:sub|)paniculate|pentagonal|pulvinate|pyriform|(?:sub|)quadrangular|(?:sub|)quadrate|racemiform|(?:ir|)regular|(?:sub|)rhomb(?:ate|ic)|(?:lenticular-|sub|)reniform|retuse|rotundate|(?:sub|)round(?:ed|)|sagittate|salver(?:form|-shaped)|slender|(?:sub|)spat(?:h|)ulate|(?:sub|)spheric(?:al|)|striate|submarginate|subulate|(?:sub|)terete|(?:sub|)thyrsiform|(?:sub|)triangular|trigonous|truncate|tubular|unguiculate|urceolate|winged)(?: at (?:apex(?: and base|)|base(?: and apex|))| just below inflorescence|))(?!\n)/$1<\/subChar>/g;
		
		
		# Texture:
		# Finding first texture-related word in line:
		s/(har class="(?:[a-z -]+|)">.+? )((?:fairly |minutely |more or less |often |rather |slightly |somewhat |very |)(?:bullate|(?:sub|)carnose|chartaceous|(?:sub|)coriaceous|crustaceous|crustose|fleshy|granula(?:r|te)|leathery|membran(?:ace|)ous|papery|papyraceous|rough(?:ened|)|rugose|scabrous|scaly|scrobiculate|s(?:m|)ooth|stiff|tuberculate|viscidous|(?:semi-|sub|)woody|wrinkled)(?: |\.|,|;|:|-))/$1<subChar class="texture">$2/g;
		# Collecting remaining texture-related words in line:
		s/(<subChar class="texture">(?:.+|)(?:bullate|(?:sub|)carnose|chartaceous|(?:sub|)coriaceous|crustaceous|crustose|fleshy|granula(?:r|te)|leathery|membran(?:ace|)ous|papery|papyraceous|rough(?:ened|)|rugose|scabrous|scaly|scrobiculate|s(?:m|)ooth|stiff|tuberculate|viscidous|(?:semi-|sub|)woody|wrinkled)(?: at base| on both surfaces|))(?!\n)/$1<\/subChar>/g;
		
		
		
		# Other stuff:
		# Fused parts with numerical info:
		s/(fused for )(\d\/\d-\d\/\d of total length)/<subChar class="fusion">$1<subChar class="relative distance">$2<\/subChar><\/subChar>/g;
		# fused for 1/2-3/4 of total length
		
		# Relative dimension info:
		s/((?:about|) \d+\/\d+ as long as the [a-z]+)/<subChar class="relative dimensions">$1<\/subChar>/g;
		# about 2/3 as long as the petals
		
	}
	
	
	
	s/(<\/subChar>)(\))/$2$1/g;
	
	
	
	# Marks up elevations in gatherings:
	if (/^\t\t\t\t\t<gathering>/) {
		
		s/((?:alt|elev)\. )(\d+(?:-\d+|) m)/$1<altitude>$2<\/altitude>/g;
		s/(\d+(?:-\d+|) m)( (?:alt|elev)\.)/<altitude>$1<\/altitude>$2/g;
		
		
		
	}
	
	
	
	print OUT $_; 
}

close IN;
close OUT;