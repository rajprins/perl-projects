#!/usr/bin/perl

use strict;
use warnings;
use PDF::API2;
use PDF::CreateSimple;

my $pdf = PDF::API2->new;

my $font = $pdf->corefont('Helvetica-Bold');

my $page = $pdf->page;
   $page->mediabox('A4');

my $gfx = $page->gfx;
   $gfx->textlabel(200, 700, $font, 20, 'Hello World!');

   $pdf->saveas('D:\\temp\\test2.pdf');
   $pdf->end();
