#!/usr/bin/perl -w
# uvi - vi a file without changing its access times
  
$file = shift or die "usage: uvi filename\n";
($atime, $mtime) = (stat($file))[8,9];
system($ENV{EDITOR} || "vi", $file);
utime($atime, $mtime, $file) or die "couldn't restore $file to orig times: $!";
