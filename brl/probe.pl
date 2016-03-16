#!/usr/bin/perl

use strict;
use warnings;


# variables
my $srcdir;
my $pattern;
my @files;
my $spoolfile;


# logic
sub probe {
    opendir(DIR, $_[0]);
    @files = grep(/$_[1]$/i, readdir(DIR));
    closedir(DIR);
   
    foreach my $file (@files) {
        my $dir = $_[0];
        my $counter = 0;
        print OUT "$file\n";

        open(IN, "< $dir\\$file") || die "Cannot open file $file: $!\n";
        while (<IN>) {
            chomp $_;
            s/\/\/.*//;
            if (/^\#include/i) {
                s/\#include//;
                s/\"//g;
                s/\ //g;
                ++$counter;
                print OUT "|__$_\n";
                deepprobe("$dir\\$_");
            }
        }

        close(IN);        
        ($counter > 0) ? print OUT "\\_Number of includes: $counter\n\n" : print OUT "\\_No includes in this file\n\n"; 
    }
    
}


sub deepprobe {
    my $i = 0;
    my $deepfile = $_[0];
    open(IN2, "< $deepfile") || die "Cannot open file $deepfile: $!\n";
    while (<IN>) {
        chomp $_;
        s/\/\/.*//;
        if (/^\#include/i) {
            s/\#include// ;
            s/\"//g ;
            ++$i;
            print OUT "   |__$_\n";
        }
    }
    close(IN2);
}



# main
print "\n*** BRL Source probe ***\n\n";
print "This tool will scan all .prj files from BRL source directory ..\\Ofwr.sys\\msg\n";
print "and displayes all included .mod files.\n\n";
print "Please make sure to enter all data correctly.\n";

#First argument is source directory of BRL msg files. If not defined, ask for it.
if (! defined $ARGV[0]) {
    print "\nEnter full path name to source directory (incl. msg) :\n> ";
    $srcdir = <STDIN>;
} else {
    $srcdir = $ARGV[0] ;
}

if ($^O =~ /win32/i) {
    $srcdir =~ s/\\/\\\\/g;
}
    
chomp($srcdir);

if (-d $srcdir) { 
    print "Using $srcdir as source directory.\n";
} else {
    print "Error: directory $srcdir does not exit.\nExiting...\n";
    exit;
}


#Second argument is spool filename. If not defined, ask for it.
if (! defined $ARGV[1]) {
    print "\nNo spool file defined. Press RETURN to use default or enter new file name.\n> ";
    $spoolfile = <STDIN>;
    chomp($spoolfile);
    if ($spoolfile eq "") {
        print "\nNo spoolfile defined. Using result.txt as default\n";
       $spoolfile = "result.txt";
    } else {
        print "\nUsing $spoolfile as spoolfile.\n";
    }
}

$pattern = ".prj";
# Alleen voor testen!!!
#$srcdir = "C:\\Data\\Projects\\BRL\\Ofwr.sys\\msg";

print "Probing started...";

open(OUT, "> $srcdir\\$spoolfile");
probe($srcdir, $pattern);
close(OUT);

print " done.\nPlease see file $srcdir\\$spoolfile for results.\n";
