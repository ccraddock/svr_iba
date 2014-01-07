#!/usr/bin/perl

use warnings;
use strict;
use Cwd;

my $pwd="/home/drcc/CCB/ROI_SVR_FC2";
my @censors=("censor1","censor2","censor3","censor4","censor5");

#my @dirs=<$pwd/*>;

my @dirs=("/home/drcc/CCB/ROI_SVR_FC2/CCB002_scan1_20100602/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB008_scan1_20100611/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB009_scan1_20100611/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB011_scan1_20100616/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB012_scan1_20100618/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB013_scan1_20100622/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB014_scan1_20100625/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB015_scan1_20100709/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB016_scan1_20100713/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB017_scan1_20100713/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB018_scan1_20100719/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB021_scan1_20100721/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB023_scan1_20100721/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB024_scan1_20100722/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB025_scan1_20100722/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB026_scan1_20100722/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB028_scan1_20100723/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB033_scan1_20100817/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB035_scan1_20100914/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB036_scan1_20101216/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB038_scan1_20101001/",
          "/home/drcc/CCB/ROI_SVR_FC2/CCB040_scan1_20101129/");

open(START, ">start_rep_new.sh" ) || die "Could not open start_rep_new.sh";

foreach my $dir (sort @dirs)
{
    if((-d $dir ) and ($dir =~ m/CCB(\w*)_scan(\d+)_(\d+)/))
    {
        my $ff="CCB$1"."_scan$2"."_$3";
        print "$dir => $ff\n";

        my $dset="REST";
        foreach my $censor (@censors)
        {
                open(OFILE,">$ff"."_$censor"."_$dset"."_rep_part.sh") or die "could not open $ff"."_$censor"."_$dset"."_rep_part.sh for writing";
                #print OFILE "export PATH=/home/drcc/netspace/afni_bin:\$PATH\n"; 
                #print OFILE "export AFNI_COMPRESSOR=GZIP\n";
                print OFILE "source ~/.bashrc\n";
                print OFILE "cd $dir\n"; 
                print OFILE "time $pwd/calc_rep.sh \${PWD} $censor > $ff"."_$censor"."_$dset"."_rep_part.log 2>&1\n";
                close(OFILE);
                chmod 0755, "$ff"."_$censor"."_$dset"."_rep_part.sh";

                open(PFILE,">$ff"."_$censor"."_$dset"."_rep_part.pbs") or die "could not open $ff"."_$censor"."_$dset"."_rep_part.pbs for writing";

                print PFILE "#!/bin/sh\n";
                print PFILE "### Job name\n";
                print PFILE "#PBS -N $ff"."_$censor"."_$dset\n";
                print PFILE "### Declare job non-rerunable\n";
                print PFILE "#PBS -r n\n";
                print PFILE "# request resources\n";
                #print PFILE "#PBS -l walltime=200:00:00,nodes=1:ppn=32\n";
                print PFILE "#PBS -l walltime=2:00:00\n";
                print PFILE "#PBS -l nodes=1:ppn=1\n";
                print PFILE "### Output files\n";
                print PFILE "### Output files\n";
                print PFILE "#PBS -e $ff"."_$censor"."_$dset"."_rep.err\n";
                print PFILE "#PBS -o $ff"."_$censor"."_$dset"."_rep.log\n";
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
                print PFILE "$pwd/$ff"."_$censor"."_$dset"."_rep_part.sh\n";
                print PFILE "#wait for everthing to finish\n";
                print PFILE "wait";
                close PFILE;
                print START "qsub $ff"."_$censor"."_$dset"."_rep_part.pbs\n";
       } 
    }
}

close(START);
