#!/usr/bin/perl

use strict;
use warnings;

use PDF::CreateSimple;

my $pdfFile = PDF::CreateSimple->new(test.pdf);

$pdfFile->addNewPage;
$pdfFile->drawText(´Example text´, ´Verdana´, 12, 400, 200, ´black´);

$pdfFile->closeFile;
