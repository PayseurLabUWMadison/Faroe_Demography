#!/usr/bin/perl -w

#To count switches
#open the file
#Use Sandoy samples (FSa) as an example
@indv = qw/ FSa1 FSa10 FSa11 FSa12 FSa16 FSa2 FSa20 FSa21 FSa4 FSa6 FSa7 FSa9 /;

@chr = @ARGV ;
my @title_row;
push (@title_row, "Indv");
push (@title_row, "Chr");
push (@title_row, "Set");
push (@title_row, "Switch_count");
push (@title_row, "Av_SNPS_btwn_switches");
push (@title_row, "Av_distance_btwn_switches");

my $major_title = join ",", @title_row;
push (@major_table, "$major_title\n");
my @all_distance_distributions_full;
my @all_count_distributions_full;
my @all_switches_full;
my @all_distance_distributions_95;
my @all_count_distributions_95;
my @all_switches_95;

foreach $chr (@chr) {
        my $exportable = ">$chr.WGdistributions.txt"; #MDA
        open OUTFILE, $exportable;
        print OUTFILE "Chr\tIndv\tSet\tSwitches\tType\tDistributions\n";

        #count switches using method one
        foreach $indv (@indv) {
                my $title = "WG_chr" . $chr . "_" . $indv ;     #MDA: "MDA" . $chr . "_" . $indv
                $gimufilename = "$title.map.csv";

                unless (open (GIMUFILE, $gimufilename)) {
                        print "Could not open file $gimufilename!\n";
                        exit;
                }

                my @gigamuga_file = <GIMUFILE>;
                close GIMUFILE;

                print OUTFILE "$chr\t$indv\tFull_Set\t";
                my $first = 0;
                my $switches = 0;
                my $SNPs_btwn_switches = 1;
                my $first_Snp = 0;
                my $last_Snp = 0;
                my $distance_btwn_switches = 0;
                my @distance_distribution;
                my @count_distribution;
                my @switches;

                foreach $gigamuga_file (@gigamuga_file) {
                        my $thing = $gigamuga_file;
                        my @something = split /,/, $thing;

                        if ($something[1] =~ /Ancestry/) {
                                next;
                        } elsif ($something[1] eq $first) {     #matches previous
                                $last_Snp = $something[0];                      #don't count a switch
                                $SNPs_btwn_switches ++;                         #do count a number of SNPs between switches
                        } elsif ($something[1] ne $first) {             #does not match previous
                                if ($first == 0) {
                                        $first = $something[1];
                                        $first_Snp = $something[0];
                                } elsif (abs($something[1] - $first) > 10) {
                                        $switches += 2;                         #count 2 switches
                                        $last_Snp = $something[0];
                                        $distance_btwn_switches = $last_Snp - $first_Snp; #push counts from the block onto an array
                                        push (@distance_distribution, "$distance_btwn_switches");
                                        push (@count_distribution, "$SNPs_btwn_switches");

                                        chomp $first;
                                        $switch_row = $indv . "," . $first_Snp . "," . $last_Snp . "," . $first . "," . $distance_btwn_switches . "," . $SNPs_btwn_switches ;
                                        push(@switches, $switch_row);

                                        $distance_btwn_switches = 0;
                                        $SNPs_btwn_switches = 1;
                                        $first = $something[1];
                                        $first_Snp = $something[0];

                                }       else {
                                        $switches ++;                   #count a switch
                                        $last_Snp = $something[0];
                                        $distance_btwn_switches = $last_Snp - $first_Snp; #push counts from the block onto an array
                                        push (@distance_distribution, "$distance_btwn_switches");

                                        chomp $first;
                                        push (@count_distribution, "$SNPs_btwn_switches");
                                        $switch_row = $indv . "," . $first_Snp . "," . $last_Snp . "," . $first . "," . $distance_btwn_switches . "," . $SNPs_btwn_switches ;
                                        push(@switches, $switch_row);

                                        $distance_btwn_switches = 0;
                                        $SNPs_btwn_switches = 1;
                                        $first = $something[1];
                                        $first_Snp = $something[0];
                                }
                        }
                }

                my $av_SBS = average(@count_distribution);
                my $av_DBS = average(@distance_distribution);
                print OUTFILE "$switches\t";
                print OUTFILE "bp\t@distance_distribution\n";
                print OUTFILE "$chr\t$indv\tFull_Set\t$switches\t";
                print OUTFILE "snp\t@count_distribution\n";

                my @table_row;
                push (@table_row, "$indv");
                push (@table_row, "$chr");
                push (@table_row, "Full_set");
                push (@table_row, "$switches");
                push (@table_row, "$av_SBS");
                push (@table_row, "$av_DBS");

                my $major_row = join ",", @table_row;
                push (@major_table, "$major_row\n");
                push (@all_distance_distributions_full, @distance_distribution);
                push (@all_count_distributions_full, @count_distribution);
                push (@all_switches_full, @switches);

        }

        #count switches using method two
        foreach $indv (@indv) {
                my $title = "WG_chr" . $chr . "_" . $indv ;     #MDA:  "MDA" . $chr . "_" . $indv
                $gimufilename1 = "$title.map95.csv";

                unless (open (GIMUFILE1, $gimufilename1)) {
                        print "Could not open file $gimufilename1!\n";
                        exit;
                }

                my @gigamuga_file1 = <GIMUFILE1>;
                close GIMUFILE1;

                print OUTFILE "$chr\t$indv\tSet_95\t";

                my $first = 0;
                my $switches = 0;
                my $SNPs_btwn_switches = 1;
                my $first_Snp = 0;
                my $last_Snp = 0;
                my $distance_btwn_switches = 0;
                my @distance_distribution;
                my @count_distribution;
                my @switches;

                foreach $gigamuga_file1 (@gigamuga_file1) {
                        my $thing = $gigamuga_file1;
                        my @something = split /,/, $thing;

                        if ($something[1] =~ /Ancestry/) {
                                next;
                        } elsif ($something[1] =~ /amb/) {
                                next;
                        } elsif ($something[1] eq $first) {     #matches previous
                                $last_Snp = $something[0];                      #don't count a switch
                                $SNPs_btwn_switches ++;                         #do count a number of SNPs between switches
                        } elsif ($something[1] ne $first) {             #does not match previous
                                if ($first == 0) {
                                        $first = $something[1];
                                        $first_Snp = $something[0];

                                } elsif (abs($something[1] - $first) > 10) {
                                        $switches += 2;                         #count 2 switches
                                        $last_Snp = $something[0];
                                        $distance_btwn_switches = $last_Snp - $first_Snp; #push counts from the block onto an array
                                        push (@distance_distribution, "$distance_btwn_switches");
                                        push (@count_distribution, "$SNPs_btwn_switches");

                                        chomp $first;
                                        $switch_row = $indv . "," . $first_Snp . "," . $last_Snp . "," . $first . "," . $distance_btwn_switches . "," . $SNPs_btwn_switches ;
                                        push(@switches, $switch_row);

                                        $distance_btwn_switches = 0;
                                        $SNPs_btwn_switches = 1;
                                        $first = $something[1];
                                        $first_Snp = $something[0];

                                } else {
                                        $switches ++;                                           #count a switch
                                        $last_Snp = $something[0];
                                        $distance_btwn_switches = $last_Snp - $first_Snp; #push counts from the block onto an array
                                        push (@distance_distribution, "$distance_btwn_switches");
                                        push (@count_distribution, "$SNPs_btwn_switches");

                                        chomp $first;
                                        $switch_row = $indv . "," . $first_Snp . "," . $last_Snp . "," . $first . "," . $distance_btwn_switches . "," . $SNPs_btwn_switches ;
                                        push(@switches, $switch_row);

                                        $distance_btwn_switches = 0;
                                        $SNPs_btwn_switches = 1;
                                        $first = $something[1];
                                        $first_Snp = $something[0];
                                }
                        }
                }

                my $av_SBS = average(@count_distribution);
                my $av_DBS = average(@distance_distribution);

                print OUTFILE "$switches\t";
                print OUTFILE "bp\t@distance_distribution\n";
                print OUTFILE "$chr\t$indv\tSet_95\t$switches\t";
                print OUTFILE "snp\t@count_distribution\n";

                my @table_row;
                push (@table_row, "$indv");
                push (@table_row, "$chr");
                push (@table_row, "Set_95");
                push (@table_row, "$switches");
                push (@table_row, "$av_SBS");
                push (@table_row, "$av_DBS");

                my $major_row = join ",", @table_row;
                push (@major_table, "$major_row\n");
                push (@all_distance_distributions_95, @distance_distribution);
                push (@all_count_distributions_95, @count_distribution);
                push (@all_switches_95, @switches);
        }
}

close OUTFILE;

$export_table = ">Switch_count_table_WG.csv";   #MDA
open OUTFILE, $export_table;
print OUTFILE @major_table;
close OUTFILE;

$export_distributions_bp_f = ">Block_lengths_bp_WG_full.txt";   #MDA
open OUTFILE, $export_distributions_bp_f;

my $a_d_d_f = join "\n", @all_distance_distributions_full;
print OUTFILE $a_d_d_f;
close OUTFILE;

$export_distributions_snp_f = ">Block_lengths_snp_WG_full.txt"; #MDA
open OUTFILE, $export_distributions_snp_f;
my $a_c_d_f = join "\n", @all_count_distributions_full;
print OUTFILE $a_c_d_f;
close OUTFILE;

$export_distributions_bp_95 = ">Block_lengths_bp_WG_95.txt";    #MDA
open OUTFILE, $export_distributions_bp_95;
my $a_d_d_95 = join "\n", @all_distance_distributions_95;
print OUTFILE $a_d_d_95;
close OUTFILE;

$export_distributions_snp_95 = ">Block_lengths_snp_WG_95.txt";  #MDA
open OUTFILE, $export_distributions_snp_95;
my $a_c_d_95 = join "\n", @all_count_distributions_95;
print OUTFILE $a_c_d_95;
close OUTFILE;

$export_switches_full = ">Switches_WG_full.txt";
open OUTFILE, $export_switches_full;
my $s_t_full = join "\n", @all_switches_full;
print OUTFILE $s_t_full;
close OUTFILE;

$export_switches_95 = ">Switches_WG_95.txt";
open OUTFILE, $export_switches_95;
my $s_t_95 = join "\n", @all_switches_95;
print OUTFILE $s_t_95;
close OUTFILE;

################################################################################
#SUBROUTINES#
################################################################################

sub average {
        @array = @_;
        my $sum = 0;
        my $count = 0;

        foreach $array (@array) {
                $sum = $sum + $array;
                $count++;
        }

        unless ($count == 0) {
                return $sum/$count;
        } else {
                return 0;
        }
}
