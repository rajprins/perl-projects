#!/usr/bin/perl

use strict;
use warnings;
use PDF::API2;

use constant mm => 25.4/72;
use constant in => 1/72;
use constant pt => 1;

my $formulier;
my $invulveld;
my %font;
my $leeg     = "Formulier3a.pdf";
my $ingevuld = "Formulier3b.pdf";

print ">> Openen van bestand $leeg\n";
$formulier = PDF::API2->open($leeg) or die "Kan bestand $leeg niet openen:$!\n";

print ">> Aanmaken nieuw bestand $ingevuld\n";
$formulier->saveas($ingevuld);

print ">> Openen van bestand $ingevuld\n";
$formulier = PDF::API2->open($ingevuld);

print ">> Configureren van lettertypes\n";
%font = (
   Helvetica => {
      Bold   => $formulier->corefont('Helvetica-Bold',    -encoding => 'latin1'),
      Roman  => $formulier->corefont('Helvetica',         -encoding => 'latin1'),
      Italic => $formulier->corefont('Helvetica-Oblique', -encoding => 'latin1'),
   },
   Times => {
      Bold   => $formulier->corefont('Times-Bold',        -encoding => 'latin1'),
      Roman  => $formulier->corefont('Times',             -encoding => 'latin1'),
      Italic => $formulier->corefont('Times-Italic',      -encoding => 'latin1'),
   },
);


print ">> Invullen van gegevens:\n";
$invulveld = $formulier->openpage(1)->text;
$invulveld->font( $font{'Helvetica'}{'Roman'}, 9/pt );
$invulveld->fillcolor('black');

#Kenteken
print "   - kenteken\n";
$invulveld->translate(156/mm, 162/mm);
$invulveld->text('AU-TO-01');

#Laadgegevens
print "   - hoeveelheid\n";
$invulveld->translate(177/mm, 143/mm);
$invulveld->text('30000');

print "   - aankomst datum\n";
$invulveld->translate(47/mm, 90/mm);
$invulveld->text('03-04-2006');

print "   - aankomst tijd\n";
$invulveld->translate(68/mm, 90/mm);
$invulveld->text('09:21');

print "   - kg Tarra\n";
$invulveld->translate(80/mm, 90/mm);
$invulveld->text('kg Tarra');
$invulveld->translate(96/mm, 90/mm);
$invulveld->text('11721');

print "   - einddatum\n";
$invulveld->translate(47/mm, 76/mm);
$invulveld->text('03-04-2006');

print "   - eindtijd\n";
$invulveld->translate(68/mm, 76/mm);
$invulveld->text('10:59');

print "   - kg Bruto\n";
$invulveld->translate(80/mm, 76/mm);
$invulveld->text('kg Bruto');
$invulveld->translate(96/mm, 76/mm);
$invulveld->text('41836');

print ">> Opslaan en sluiten bestand $ingevuld\n";
$formulier->update;
$formulier->end();


print "Gereed.\n";
