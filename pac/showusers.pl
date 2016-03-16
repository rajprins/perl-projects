#!/usr/bin/perl

use strict;
use warnings;

my @userdata;

unless (-r "/etc/passwd") { 
   die "Cannot open password file: $!\n";
}

open PW, "< /etc/passwd";

while (<PW>) {
   chomp ;
   @userdata = split /\:/, $_;
   if ($userdata[6] eq "/sbin/nologin") {
      <PW>
   } else {
      print "$userdata[0]\n";
   }
}

