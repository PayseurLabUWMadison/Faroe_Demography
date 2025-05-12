#!/usr/bin/perl -w

#To build chromosome maps
#Use Sandoy samples (FSa) as an example 
@indv = qw/ FSa1 FSa10 FSa11 FSa12 FSa16 FSa2 FSa20 FSa21 FSa4 FSa6 FSa7 FSa9 /;

@chr = @ARGV;
foreach $chr (@chr){
        foreach $indv (@indv) {
                my $title = $indv ;
                $gimufilename = "$title.posterior";
                unless (open (GIMUFILE, $gimufilename)) {
                        print "Could not open file $gimufilename!\n";
                        exit;
                }

                my @gigamuga_file = <GIMUFILE>;
                close GIMUFILE;

                my @map;
                my @map95;
                foreach $gigamuga_file(@gigamuga_file) {
                        my $thing = $gigamuga_file;
                        my @something = split /\t/, $thing;
                        my @map_line;
                        my @map95_line;
                        push (@map_line, $something[1]);
                        push (@map95_line, $something[1]);

                        if ($something[4] =~ /,/g) {
                                push (@map_line, "Ancestry");
                        } elsif ($something[4] >= $something[3] && $something[4] >= $something[2]) {
                                push (@map_line, "22");
                        } elsif ($something[3] >= $something[4] && $something[3] >= $something[2]){
                                push (@map_line, "12");
                        } elsif ($something[2] >= $something[4] && $something[2] >= $something[3]){
                                push (@map_line, "11");
                        }

                        if ($something[3] =~ /,/g) {
                                push (@map95_line, "Ancestry");
                        } elsif ($something[4] > .95) {
                                push (@map95_line, "22");
                        } elsif ($something[3] > .95){
                                push (@map95_line, "12");
                        } elsif ($something[2] > .95){
                                push (@map95_line, "11");
                        } else {
                                push (@map95_line, "amb");
                        }

                        my $map_line1 = join ",", @map_line;
                        push (@map, "$map_line1\n");

                        my $map95_line1 = join ",", @map95_line;
                        push (@map95, "$map95_line1\n");

                }

                my $title2 = "WG_chr" . $chr . "_" . $indv ;    #MDA:"MDA" . $chr . "_" . $indv
                $exportables = ">$title2.map.csv";
                        open OUTFILE, $exportables;

                print OUTFILE @map;
                close OUTFILE;

                $exportables2 = ">$title2.map95.csv";
                        open OUTFILE, $exportables2;
                        
                print OUTFILE @map95;
                close OUTFILE;
        }
}
