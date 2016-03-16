#!/usr/bin/perl

use strict;
use warnings;
use PDF::API2;

use constant mm => 25.4/72;
use constant in => 1/72;
use constant pt => 1;

my $pdf;
if ( $^O =~ /darwin/i) {
    $pdf = PDF::API2->new(-file => '/Users/roy/temp/test1.pdf');
}
elsif ( $^O =~ /win32/i) {
    $pdf = PDF::API2->new(-file => 'D:\\temp\\test1.pdf');
}
elsif ( $^O =~ /cygwin/i) {
    $pdf = PDF::API2->new(-file => '/cygdrive/d/temp/test1.pdf');
}
elsif ( $^O =~ /linux/i) {
    $pdf = PDF::API2->new(-file => '/home/roy/temp/test1.pdf');
}
else {
    die "Cannot create output file: $!\n";
}


my %info = $pdf->info(
    'Author'        => "Roy Prins",
    'CreationDate'  => "D:20060227000000+01'00'",
    'ModDate'       => "D:YYYYMMddhhmmssOHH'mm'",
    'Creator'       => "pdftest01.pl",
    'Producer'      => "Innervate Services B.V.",
    'Title'         => "PDF test 01",
    'Subject'       => "PDFGenerator",
    'Keywords'      => "Perl PDF"
);
#print "Author: $info{Author}\n";

my $page = $pdf->page;

#$page->mediabox(210/mm, 297/mm);
$page->mediabox('A4');
$page->bleedbox(5/mm, 5/mm, 205/mm, 292/mm);
$page->cropbox(20/mm, 20/mm, 190/mm, 277/mm); 

my %font = (
   Helvetica => {
      Bold   => $pdf->corefont('Helvetica-Bold',    -encoding => 'latin1'),
      Roman  => $pdf->corefont('Helvetica',         -encoding => 'latin1'),
      Italic => $pdf->corefont('Helvetica-Oblique', -encoding => 'latin1'),
   },
   Times => {
      Bold   => $pdf->corefont('Times-Bold',        -encoding => 'latin1'),
      Roman  => $pdf->corefont('Times',             -encoding => 'latin1'),
      Italic => $pdf->corefont('Times-Italic',      -encoding => 'latin1'),
   },
);

my $box = $page->gfx;
$box->fillcolor('darkblue');
$box->rect(20/mm, 257/mm, 190/mm, 20/mm); 
$box->fill;

my $line = $page->gfx;
$line->strokecolor('red');
$line->move(20/mm, 257/mm );
$line->line(190/mm, 257/mm );
$line->stroke;

my $text = $page->text;
$text->font( $font{'Helvetica'}{'Bold'}, 18/pt );
$text->fillcolor('white');
$text->translate(25/mm, 265/mm);
$text->text('Innervate Services PDF Creator');

$pdf->save;
$pdf->end();


