#!/usr/bin/perl

use strict;
use warnings;
use PDF::API2;

use constant mm => 25.4/72;
use constant in => 1/72;
use constant pt => 1;

my $pdf;
if ( $^O =~ /darwin/i) {    # Mac
    $pdf = PDF::API2->new(-file => '/Users/roy/temp/test3.pdf');
}
elsif ( $^O =~ /win32/i) {  # Windoos
    $pdf = PDF::API2->new(-file => 'D:\\temp\\test3.pdf');
}
elsif ( $^O =~ /cygwin/i) { # Cygwin
    $pdf = PDF::API2->new(-file => '/cygdrive/d/temp/test3.pdf');
}
elsif ( $^O =~ /linux/i) {  # Linux
    $pdf = PDF::API2->new(-file => '/home/roy/temp/test3.pdf');
}
else {
    die "Cannot create output file: $!\n";
}


my %info = $pdf->info(
    'Author'        => "Roy Prins",
    'CreationDate'  => "D:20060227000000+01'00'",
    'ModDate'       => "D:YYYYMMddhhmmssOHH'mm'",
    'Creator'       => "pdftest03.pl",
    'Producer'      => "Innervate Services B.V.",
    'Title'         => "PDF test 01",
    'Subject'       => "PDFGenerator",
    'Keywords'      => "Perl PDF"
);


my $page = $pdf->page;
   $page->mediabox('A4'); #$page->mediabox(210/mm, 297/mm);
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


my $text = $page->text;
   $text->font( $font{'Helvetica'}{'Bold'}, 18/pt );
   $text->fillcolor('white');
   $text->translate(25/mm, 265/mm);
   $text->text('Innervate Services PDF Creator');


my $line1 = $page->gfx;
   $line1->strokecolor('red');
   $line1->move(20/mm, 257/mm );	# van x,y
   $line1->line(190/mm, 257/mm );	# naar x,y
   $line1->stroke;


my $imagefile = $pdf->image_png('logo.png');	#193 x 43
$page->gfx->image($imagefile, 165/mm, 250/mm, 19.3/mm, 4.3/mm);
#$page->gfx->image($pdf->image_png('logo.png'), 165/mm, 250/mm, 19.3/mm, 4.3/mm);


my $line2 = $page->gfx;
   $line2->strokecolor('darkgrey');
   $line2->move(20/mm, 245/mm );	# van x,y
   $line2->line(190/mm, 245/mm );	# naar x,y
   $line2->stroke;


my $line3 = $page->gfx;
   $line3->strokecolor('darkgrey');
   $line3->move(105/mm, 245/mm );	# van x,y
   $line3->line(105/mm, 20/mm );	# naar x,y
   $line3->stroke;


$pdf->save;
$pdf->end();

