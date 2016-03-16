use Win32::IProc "FULLPATH"; 
$pobj = new Win32::IProc;

$pobj->EnumProcesses(\@processlist) or 
  die "Unable to get process list:$!\n";

foreach $process (@processlist){
  print "\n",$process->{ProcessName},
        "\n",('=' x length($process->{ProcessName})),"\n";
  
  $pobj->GetProcessModules($process->{ProcessId},\@modules,FULLPATH);
  print join("\n",map {lc $_->{ModuleName}} @modules),"\n";
  
 }