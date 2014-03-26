SEPARATION OF CONCERNS
======================
The suggested replacement API follows roughly the MVC design pattern
(http://en.wikipedia.org/wiki/Model-view-controller). The Model
layer (Bio::FlorML::Model) contains object representations of the 
complex types in the FlorML schema. 

Instances of these objects will be streamed through lazy evaluation from the 
input data, with container objects (more deeply nested elements) instantiating 
the appropriate contained objects as needed. 

This gives the advantage that the Model can be manipulated and traversed 
from within the View layer, (Bio::FlorML::View) which should use a 
templating system to generate FlorML or whichever other representation 
is needed. An example of a different view, made possible by traversing the
same model objects in a different template, might be to export selected
data to [*.obo](http://www.geneontology.org/GO.format.obo-1_2.shtml) format
for further refinement in an ontology editor such as 
[Protege](http://protege.stanford.edu/).

The basic idea is that in the end statements such as the following 
become possible in the [template](http://www.template-toolkit.org/):

    <!-- here the template manipulates a Bio::FlorML::Model::Feature 
         object to insert properties of the object (the class name,
         the heading, the description string into FlorML attributes 
         and text nodes -->
    <feature class="[% feature.class %]">
        <heading>[% feature.heading %]</heading>
        <string>[% feature.string %]</string>
        <references>
            <subHeading>References:</subHeading>
            
            <!-- Bio::FlorML::Model::Feature object instantiates
                 Bio::FlorML::Model::Reference objects as they are 
                 read from the cleaned, tokenized data stream -->
            [% FOREACH ref = feature.references %]
                <reference>
                    <refPart class="author">[% ref.author %]</refPart>
                    <!-- etc. -->
                </reference>
            [% END %]
        </references>
    </feature>

To orchestrate and enable the pipeline to go from raw OCR text to valid
FlorML as generated through the API, the Controller layer 
(Bio::FlorML::Controller) performs pre-processing and data extraction. 
At least the following services should be provided:

1. OCRCleaner - has a stream-based interface to correct frequently-
encountered mistakes in optical character recognition.
2. Tokenizer - has a stream-based interface that produces words or
phrases to be processed downstream.
3. CorpusBuilder - generates word lists from the input data to learn
key terms and phrases (e.g. names of countries or taxa) that need to
be recognized in the input data and can be contributed to ontology 
development.
4. Factory - creates Model objects, a simple wrapper around constructors
in the Model namespace, can be configured to automatically instantiate
subclasses that correspond to the focal flora (e.g. ::FM, or ::FdG).

TEST DRIVEN DEVELOPMENT
=======================
By separating the data processing logic, the presentation logic and the
domain logic and modularizing them into reusable code, they now become
testable using Perl's unit testing system. This should become a routine
so that functioning of the API as advertised can be verified automatically,
including, for example, using continuous integration systems such as 
Jenkins or Travis. Testing should include best practice compliance testing
with perlcritic, and documentation validity and code coverage tests.

FOLDER STRUCTURE
================
    /lib
        /Bio
            /FlorML
                  /Model/ (modules for the Model layer)
                  /View/ (modules for the View layer)
                  /Controller/ (modules for the Controller layer)
    /script (simple driver scripts)
    /t (unit tests)
    /templates (templating input files)
    /data (input OCR)
    /conf (configuration files)
