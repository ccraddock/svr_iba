#!/usr/bin/perl -w

use warnings;
use strict;
use Cwd;
use File::Basename;

my $pwd=getcwd;
my ($n,$p,$e)=fileparse($pwd);

my %conc=();
my %rep_conc=();
my %corr=();
my %rep_corr=();

my $mysubjid=$n;

print "Calculating statistics for $n\n";

for( my $i=0;$i<10;$i++)
{
    my @preds=<*$i.1D.1D>;

    foreach my $pred ( sort @preds )
    {
        if( $pred =~ m/swnmrda.*_pred_(\d+)_(\w+)_(\d+).1D.1D/ )
        {
            if( $i != $3 )
            {
                print "Some weird error occured, $i <> $3\n";
            }
            else
            {
                my $subjid=$1."_$2";
                #print "$pred = ($subjid,$3)\n";

                ### Calculate prediction accuracy:
                # the name of the file that we want to compare
                # the current file with
                my $true_tc="$p/$subjid/swnmrda$subjid"."_rest_TCs_$i.1D";
                if( -f $true_tc )
                {
                    #print "Comparing to $true_tc\n";
                    my $tst=`1ddot -terse -conc $pred $true_tc`;
                    my @resp=split(/\n/,$tst);
                    @resp=split(/\s+/,$resp[0]);
                    $conc{$subjid}{$i}=$resp[2];
                    if( $subjid eq "8003202_JC" )
                    {
                        print "ICN $i: sibling conc $resp[2]\n";
                    }

                    $tst=`1ddot -terse -demean $pred $true_tc`;
                    @resp=split(/\n/,$tst);
                    @resp=split(/\s+/,$resp[0]);
                    $corr{$subjid}{$i}=$resp[2];
                    if( $subjid eq "8003202_JC" )
                    {
                        print "ICN $i: sibling corr $resp[2]\n";
                    }
                }
                else
                {
                    #print "Could not find $true_tc\n";
                }

                ### Calculate reproducibility
                # the name of our W file
                my $my_W="swnmrda$mysubjid"."_rest_w_$i+tlrc";

                if( -f $my_W.".BRIK.gz" )
                { 
                    # the name of the file that we want to compare
                    # the current file with
                    my $other_W="$p/$subjid/swnmrda$subjid"."_rest_w_$i+tlrc";
                    if( -f $other_W.".BRIK.gz" )
                    {
                        #print "Comparing $my_W to $other_W\n";
                        my $tst=`3ddot -doconc $my_W $other_W`;
                        chomp( $tst );
                        $rep_conc{$subjid}{$i}=$tst;
                        if( $subjid eq "8003202_JC" )
                        {
                            print "ICN $i: sibling rep conc $tst\n";
                        }
    #
                        my $tst=`3ddot -demean $my_W $other_W`;
                        chomp( $tst );
                        $rep_corr{$subjid}{$i}=$tst;
                        if( $subjid eq "8003202_JC" )
                        {
                            print "ICN $i: sibling rep corr $tst\n";
                        }
                    }
                    else
                    {
                        #print "Could not find $other_W\n";
                    }
                }
                else
                {
                    #print "Could not find $true_tc\n";
                }
            }
        }
        else
        {
            print "$pred was not parsed\n";
        }
    }
}

my @subjids=sort( keys %conc );

open( CSVFILE, "> $mysubjid.csv" ) or die "Could not open $mysubjid.csv for writing: $!\n";
print CSVFILE "PACC Concordance\n";
foreach my $subjid (@subjids)
{
    if( exists $conc{$subjid} )
    {
        print CSVFILE "$subjid";
        for( my $i=0;$i<10;$i++ )
        {
            if( exists $conc{$subjid}{$i} )
            {
                print CSVFILE ",$conc{$subjid}{$i}";
            }
            else
            {
                print CSVFILE ",";
            }
        }
        print CSVFILE "\n";
    }
}
print CSVFILE "\n\nPACC Correlation\n";
foreach my $subjid (@subjids)
{
    if( exists $corr{$subjid} )
    {
        print CSVFILE "$subjid";
        for( my $i=0;$i<10;$i++ )
        {
            if( exists $corr{$subjid}{$i} )
            {
                print CSVFILE ",$corr{$subjid}{$i}";
            }
            else
            {
                print CSVFILE ",";
            }
        }
        print CSVFILE "\n";
    }
}

print CSVFILE "\n\nRep Concordance\n";
foreach my $subjid (@subjids)
{
    if( exists $rep_conc{$subjid} )
    {
        print CSVFILE "$subjid";
        for( my $i=0;$i<10;$i++ )
        {
            if( exists $rep_conc{$subjid}{$i} )
            {
                print CSVFILE ",$rep_conc{$subjid}{$i}";
            }
            else
            {
                print CSVFILE ",";
            }
        }
        print CSVFILE "\n";
    }
}

print CSVFILE "\n\nRep Correlation\n";
foreach my $subjid (@subjids)
{
    if( exists $rep_corr{$subjid} )
    {
        print CSVFILE "$subjid";
        for( my $i=0;$i<10;$i++ )
        {
            if( exists $rep_corr{$subjid}{$i} )
            {
                print CSVFILE ",$rep_corr{$subjid}{$i}";
            }
            else
            {
                print CSVFILE ",";
            }
        }
        print CSVFILE "\n";
    }
}

close( CSVFILE );
