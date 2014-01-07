#!/usr/bin/perl

use warnings;
use strict;
use Cwd;

my $pwd="/home/drcc/CCB/ROI_SVR_FC";
my @censors=("censorMSIT");

my @dirs=<$pwd/*>;

foreach my $dir (sort @dirs)
{
    if((-d $dir ) and ($dir =~ m/CCB(\w*)_scan(\d+)_(\d+)/))
    {
        my $ff="CCB$1"."_scan$2"."_$3";
        print "$dir => $ff\n";

        my $dset="MSIT";
        foreach my $censor (@censors)
        {
                open(OFILE,">$ff"."_$censor"."_$dset"."_rep_msit_part.sh") or die "could not open $ff"."_$censor"."_$dset"."_rep_msit_part.sh for writing";
                print OFILE "export PATH=/home/drcc/netspace/afni_bin:\$PATH\n"; 
                print OFILE "export AFNI_COMPRESSOR=GZIP\n";
                print OFILE "cd $dir\n"; 
                print OFILE "time $pwd/calc_rep_msit.sh \${PWD} > $ff"."_$censor"."_$dset"."_rep_msit_part.log 2>&1\n";
                close(OFILE);
                chmod 0755, "$ff"."_$censor"."_$dset"."_rep_msit_part.sh";

                open(PFILE,">$ff"."_$censor"."_$dset"."_rep_msit_part.pbs") or die "could not open $ff"."_$censor"."_$dset"."_rep_msit_part.pbs for writing";

                print PFILE "#!/bin/sh\n";
                print PFILE "### Job name\n";
                print PFILE "#PBS -N $ff"."_$censor"."_$dset\n";
                print PFILE "### Declare job non-rerunable\n";
                print PFILE "#PBS -r n\n";
                print PFILE "# request resources\n";
                #print PFILE "#PBS -l walltime=200:00:00,nodes=1:ppn=32\n";
                print PFILE "#PBS -l walltime=200:00:00\n";
                print PFILE "#PBS -l nodes=1:ppn=2\n";
                print PFILE "### Output files\n";
                print PFILE "### Output files\n";
                print PFILE "#PBS -e $ff"."_$censor"."_$dset"."_rep_msit.err\n";
                print PFILE "#PBS -o $ff"."_$censor"."_$dset"."_rep_msit.log\n";
                print PFILE "### Mail to user\n";
                print PFILE "#PBS -m ae\n";
                print PFILE "#PBS -M drcc\@vt.edu\n";
                print PFILE "# Access group, queue, and accounting project\n";
                print PFILE "#PBS -W group_list=athena\n";
                print PFILE "#PBS -q athena_q\n";
                print PFILE "#PBS -A athena\n";
                print PFILE "### address to send mail to\n";
                print PFILE "# This job's working directory\n";
                print PFILE "echo Working directory is \$PBS_O_WORKDIR\n";
                print PFILE "cd \$PBS_O_WORKDIR\n";
                print PFILE "echo Running on host `hostname`\n";
                print PFILE "echo PBS job id is \$PBS_JOBID\n";
                print PFILE "echo Time is `date`\n";
                print PFILE "echo Directory is `pwd`\n";
                print PFILE "# Run your executable\n";
                print PFILE "$pwd/$ff"."_$censor"."_$dset"."_rep_msit_part.sh\n";
                print PFILE "#wait for everthing to finish\n";
                print PFILE "wait";
                close PFILE;
       } 
    }
}
