use Proc::ProcessTable;

    $t = new Proc::ProcessTable;  

    foreach $p (@{$t->table}) {
            # note that we will also kill "xinetd" and all processes
            # whose command line contains "inetd"
        kill 9, $p->pid if $p->cmndline =~ 'inetd';
    }