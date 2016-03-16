#!/usr/bin/perl 

use strict;
use Tk;
use Tk::ProgressBar;

# Declare a window, some frames, and some vars
my $window = MainWindow->new(-title => 'System Monitor', -background => 'black');
my $memUsage;
my $swapUsage;
my ($prog1, $prog2);

my $topFrame= $window->Frame(-bg=>'black')->pack(-side =>'top');
my $hiFrame = $window->Frame(-bg=>'black')->pack(-side =>'top');
my $loFrame = $window->Frame(-bg=>'black')->pack(-side => 'bottom');
                                                
my $listf1 = $hiFrame->Frame(-bg=>'black')->pack(-side => 'left');
my $listf2 = $hiFrame->Frame(-bg=>'black')->pack(-side => 'right');

my $progf1 = $loFrame->Frame(-bg=>'black')->pack(-side => 'left');
my $progf2 = $loFrame->Frame(-bg=>'black')->pack(-side => 'right');
my $progf3 = $loFrame->Frame(-bg=>'black')->pack(-side => 'left');

#A text box in the top most frame displays the hostname, OS, and OS Version
my $title = $topFrame->Text(-width    => 20,
                                 -height=> 1,
                                 -bg    => 'black',
                                 -fg    => 'yellow',
                                 -relief=> 'flat',
                                 -insertborderwidth=>0,
                                 -highlightbackground=> 'black',
                                 )->pack(-side => 'left');
# Place a Listbox in the left side of the middle frame to use as labels                                 
my $labelList = $listf1->Listbox(-width    => 15,
                                 -height=> 4,
                                 -bg    => 'black',
                                 -fg    => 'yellow',
                                 -relief=> 'flat',
                                 #-insertborderwidth=>0,
                                 -highlightbackground=> 'black',
                                 )->pack(-side => 'left');
# Fill the Listbox with the labels                                
$labelList->insert('end',
                    "System Load:",
                    "System Up:",
                    "Processes:",
                    "Total Users");

# Place a list box in the right side of the middle frame to display data                    
my $dataList = $listf2->Listbox(-width    => 15,
                                 -height=> 4,
                                 -bg    => 'black',
                                 -fg    => 'yellow',
                                 -relief=> 'flat',
                                 #-insertborderwidth=>0,
                                 -highlightbackground=> 'black',
                                 )->pack(-side => 'left');

# Place a list box in the right side of the bottom left frame for labels                                 
my $memLabelList=$progf1->Listbox(-width=> 15,
                                 -height=> 2,
                                 -bg    => 'black',
                                 -fg    => 'yellow',
                                 -relief=> 'flat',
                                 #-insertborderwidth=>0,
                                 -highlightbackground=> 'black',
                                 )->pack(-side => 'left');
# Fill the list with labels                                 
$memLabelList->insert('end',
                        "Memory Used:",
                        "Swap Used:");

# Place a Listbox in the bottom right frame for number data          
my $memList = $progf2->Listbox(-width=> 15,
                                 -height=> 2,
                                 -bg    => 'black',
                                 -fg    => 'yellow',
                                 -relief=> 'flat',
                                 #-insertborderwidth=>0,
                                 -highlightbackground=> 'black',
                                 )->pack(-side => 'right');
                                 
# Call the subroutine for the first time
&drawvals;
# Wait 5 seconds then run the subroutine again for ever
$progf3->repeat(5000,\&drawvals);

# Create a progress bar in the top fo the bottom middle
# frame that shows amount of Used Memory
$prog1 = $progf3 ->ProgressBar(    -relief    => 'flat',
                                -resolution => 0,
                                -gap    => 0,
                                -from    => 0,
                                -to        => 100,
                                -anchor    => 'e',
                                -blocks    =>    10,
                                -bg        => 'black',
                                -colors => [0,'green',50,'yellow',80,'red'],
                                -variable=> \$memUsage,
                              )->pack(-side    => 'top', -pady => 3);
                             
# Create a progress bar in the bottom of the bottom middle
# frame to show the amout of Swap Used. 
$prog2 = $progf3 ->ProgressBar(    -relief    => 'flat',
                                -resolution => 0,
                                -gap    => 0,
                                -from    => 0,
                                -to        => 100,
                                -anchor    => 'e',
                                -blocks    =>    10,
                                -bg        => 'black',
                                -colors => [0,'green',50,'yellow',80,'red'],
                                -variable=> \$swapUsage,
                              )->pack(-side    => 'bottom', -pady => 3);
                             
# Tk's main event loop
MainLoop;

# This subroutine sets the values for Used Mem and Used Swap,
# as well as clearing and filling in the Listboxes with the
# correct data
sub drawvals{
    my %values = &vals;
    my $useMem = $values{totMem} - $values{freeMem};
    
    $swapUsage = ($values{useSwap}/$values{totSwap})*100;
    $memUsage  = ($useMem/$values{totMem})*100;
    $dataList->delete('0.0', 'end');
    $title->delete('0.0', 'end');
    $title->insert('end',"$values{host} - $values{OS} $values{OSVer}", 'yellow');
    
    $dataList->insert('end',"$values{load}");
    $dataList->insert('end',"$values{uptime}");
    $dataList->insert('end',"$values{process}");
    $dataList->insert('end',"$values{numUsers}");
    
    $memList->delete('0.0', 'end');
    $memList->insert('end', "${useMem}M of $values{totMem}M");
    $memList->insert('end', "$values{useSwap}M of $values{totSwap}M");
    
    
}
    

# This subroutine gathers the data to be displayed            
sub vals{

    my @top;
    my $proc;
    my @memInfo;
    my ($real, $rFree, $sUse, $sFree);
    my $version;
    my $load;
    my @upArray;
    my @tUp;
    my $uptime;
    my $name; 
    my $line;
    my $t;
    my $user;
    my %unique;
    my @who;  
    my $numUsers;
    my $swap;
    my %vals;

    # Get the version number of the OS, if solaris change the 5 to a 2
    # Also get the hostname using uname -n
    ($name, $version) = split ' ',(`uname -nr`);                
    if($^O =~ /solaris/){ ($version eq 5.5.1) ? ($version = 2.5.1)
                                              : ($version -= 3)}
    # Run top and collect the output
    @top = `top -n 1 2>/dev/null`;        
    chomp($name);            
    # Get a list of the users
    @who = `who`;                         
    
    # Store users in a hash, might add a listing of users to disp
    # in the future                                 
    foreach $line (@who){                 
        $user = (split ' ', $line)[0];    
                                      
        if(!$unique{$user}){              
            $unique{$user} = 1;           
        }                                 
           else {                            
            $unique{$user}++;             
        }                                 
    }
                                         
    # Get uptime and system load from the uptime command                               
    @upArray =  split ',', `uptime`;      
    $t = `uptime`;                        
    $t =~ /load average.*:\s+(\S+),/;
    $load = $1;
    @tUp = split ' ', $upArray[0];        
    $uptime = "@tUp[scalar(@tUp)-2] @tUp[scalar(@tUp)-1]";

    # Process top to get the number of processes, as well as the Memory
    # and Swap levels                                  
    foreach $line (@top){                 

        if($line =~ /\d*?\sprocesses/){   
               $proc = (split ' ', $line)[0];
        }
        elsif($line =~ /^Memory/i){       
            ($t, $line) = split ':', $line;
            @memInfo = split ',', $line;  
        
            $real = $memInfo[0];          
            $real =~ s/^\s*(\d+[KM]).*$/$1/;
            $real =~ s/[MK]//g;           
                                      
            $rFree = $memInfo[1];
            if($rFree =~ /\dK/i){         
                $rFree =~ s/^\s*(\d+[KM]).*$/$1/;
                $rFree =~ s/[MK]//g;  
                $rFree = int($rFree/1024);
            } 
            else {
                $rFree =~ s/^\s*(\d+[KM]).*$/$1/;
                $rFree =~ s/[MK]//g;      
            }
    
            $sUse = $memInfo[2];
            if($sUse =~ /\d+K/i){
                $sUse =~ s/^\s*(\d+[KM]).*$/$1/;
                $sUse =~ s/[MK]//g;
                $sUse = int($sUse/1024);  
            }
            else {
                $sUse =~ s/^\s*(\d+[KM]).*$/$1/;
                $sUse =~ s/[MK]//g;       
            }                             
        
            chomp($sFree = $memInfo[3]);         
            if($sFree =~ /\d+K/i){
                $sFree =~ s/^\s*(\d+[KM]).*$/$1/;
                $sFree =~ s/[MK]//g;
                $sFree = int($sFree/1024);
            }
            else {
                $sFree =~ s/^\s*(\d+[KM]).*$/$1/;
                $sFree =~ s/[MK]//g;
            }
        }   
    }

    # Count the number of unique users
    # NOTE: This is due to(at least on my workstation at work)
    #        each instance of a term counting as a user in who.
    #        Oddly enough, finger behaves this way at my work as
    #        well, a finger on me produces as many entries as terms
    #        That I have open
    foreach $user(keys %unique){
        $numUsers++;
    }
    $swap = $sUse + $sFree;
    
    # Place the values in a hash
    %vals =(host     => $name,
            OS        => $^O,
            OSVer    => $version,
            load    => $load,
            uptime    => $uptime,
            process    => $proc,
            totMem    => $real,
            freeMem    => $rFree,
            totSwap    => $swap,
            useSwap    => $sUse,
            numUsers=> $numUsers,
            );

    return %vals;
}
