use PDF;

$pdf=PDF->new ;
$pdf=PDF->new(filename);

$result=$pdf->TargetFile( filename );

print "is a pdf file\n" if ( $pdf->IsaPDF ) ;
print "Has ",$pdf->Pages," Pages \n";
print "Use a PDF Version  ",$pdf->Version ," \n";
print "and it is crypted  " if ( $pdf->IscryptedPDF) ;
print "filename with title",$pdf->GetInfo("Title"),"\n";
print "and with subject ",$pdf->GetInfo("Subject"),"\n";
print "was written by ",$pdf->GetInfo("Author"),"\n";
print "in date ",$pdf->GetInfo("CreationDate"),"\n";
print "using ",$pdf->GetInfo("Creator"),"\n";
print "and converted with ",$pdf->GetInfo("Producer"),"\n";
print "The last modification occurred ",$pdf->GetInfo("ModDate"),"\n";
print "The associated keywords are ",$pdf->GetInfo("Keywords"),"\n";

my (startx,starty, endx,endy) = $pdf->PageSize ($page) ;