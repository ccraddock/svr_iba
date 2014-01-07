#!/usr/bin/perl

use warnings;
use strict;
use Cwd;

my $pwd="/home/ccraddock/resting_state/nihtwins/SVR_analy";

my @dirs=<$pwd/*>;

foreach my $dir (sort @dirs)
{
    print "$dir\n";
    if((-d $dir ) and ($dir =~ m/(\d+)/))
    {
        open(OFILE,">$1_svrfc_stats.sh") or die "could not open $1_svrfc_stats.sh for writing";
        print OFILE "export LDPATH=/usr/local/lib:/usr/lib/mysql:/usr/lib64/mysql:/usr/lib/qt-3.3/lib:/usr/lib64/qt-3.3/lib:/usr/lib/qt4/lib:/usr/lib64/qt4/lib64:/lib:/lib64:/usr/lib:/usr/lib64:/lib/i686:/lib/i686/nosegneg:\n"; 
        print OFILE "export PATH=/home/ccraddock/netspace/afni_bin:\$PATH\n"; 
        print OFILE "export AFNI_COMPRESSOR=GZIP\n";
        print OFILE "cd $dir\n"; 
        print OFILE "./fc_svr_stats.pl > $1_svrfc_stats.log 2>&1\n";
        close(OFILE);
        chmod 0755, "$1_svrfc_stats.sh";
    }
}
