#!/usr/bin/perl
# IAK Declaratie formulier generator
# PDF cošrdinaten zijn X ,Y
# Startend vanaf links onder
# Positie meten: zoom formulier op ware grootte en meet vanaf documentrand links onder
# Tip: printen heeft geen zin ivm met marges


use strict;
use warnings;
use PDF::API2;

use constant mm => 25.4/72;
use constant in => 1/72;
use constant pt => 1;

### Variables
my $leegForm = "template.pdf";
my $newForm  = "declaratie.pdf"; 
my $formulier;
my %font;
my $invulveld;
my $gironummer   = "6242134";
my $verzekerdenr = "0001102395";
my $polisnr      = "3072666200086";
my $naam         = "R.A.J. Prins";
my $adres        = "De Vliet 10";
my $pcplaats     = "5583 GK Waalre";
my $telefoonnr   = "040-7074855";
my $gebdatum     = "05-06-1976";
my $valuta       = "EUR";
my $initialen     = "RP";


### Functions
sub vulin {
   my $text = $_[0];
   my $posx = $_[1];
   my $posy = $_[2];
   my $msg  = $_[3];

   if ($msg ne "") {
      print "   - $msg\n";
   } else {
      print "   - Custom data: $text\n";
   }
   $invulveld->translate($posx/mm, $posy/mm);
   $invulveld->text($text);
}


### Main logic

print "================================================================================\n";
print "IAK Declaratie formulier generator\n";
print "================================================================================\n\n";

print "Taken :\n";

print "- Openen van leeg declaratie formulier $leegForm\n";
$formulier = PDF::API2->open($leegForm) or die "Kan bestand $leegForm niet openen:$!\n";

print "- Aanmaken nieuw declaratie bestand $newForm\n";
$formulier->saveas($newForm);

print "- Openen van bestand $newForm\n";
$formulier = PDF::API2->open($newForm);

print "- Configureren van lettertypes\n";
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

print "Nieuw declaratieformulier greed.\n\n";

print "Invullen van gegevens:\n";
$invulveld = $formulier->openpage(1)->text;
$invulveld->font( $font{'Helvetica'}{'Roman'}, 11/pt );
$invulveld->fillcolor('black');

### Vaste gegevens
vulin($gironummer, 51, 99, "Giro nummer");
vulin($verzekerdenr, 51, 83, "Verzekerdenummer");
vulin($naam, 127, 99, "Naam");
vulin($adres, 127, 91, "Adres");
vulin($pcplaats, 127, 83, "Postcode/woonplaats");
vulin($telefoonnr, 125, 10, "Telefoonnummer");

### Declaratie gegevens
# regel 1
vulin("10335/287197", 11, 50, "Faktuurnummer");
vulin($initialen, 71, 50, "Initialen");
vulin($gebdatum, 82, 50, "Geboorde datum");
vulin($valuta, 113, 50, "Valuta");
vulin("151", 125, 50, "Bedrag");
vulin("60", 146, 50, "Centen");
vulin("X", 157, 50, "Aan mij overmaken");


### Declaratie totalen
vulin("1", 47, 16, "Totaal aantal nota's: 1");
vulin("151", 125, 16, "Totaal bedrag");
vulin("60", 146, 16, "Centen");
vulin("07-10-2009", 47, 9, "Dagtekening");


### Over and out
print "\nOpslaan en sluiten bestand $newForm\n";
$formulier->update;
$formulier->end();


print "Gereed.\n";


