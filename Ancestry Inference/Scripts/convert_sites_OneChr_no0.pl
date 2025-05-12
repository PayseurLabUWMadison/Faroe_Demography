#!/usr/bin/perl -w

#To convert from bp to cM
my $exportable = ">post_conversion.txt";
        open OUTFILE, $exportable;

$mapfilename = "one_chr_map.txt";
unless (open (MAPFILE, $mapfilename)) {
        print "Could not open file $mapfilename!\n";
        exit;
}
my @map_file = <MAPFILE>;

# Convert Map to a hash
my %maphash;
my $name;
my @map_coordinates;
for ( @map_file ) {
  chomp;
  my @row = split /,/, $_;
  $name = $row[2] unless $row[2] eq '';
  $maphash{$name} = $row[3];
  push @map_coordinates, $row[2];
}

close MAPFILE;

$sitefilename = "pre_conversion.txt";
unless (open (SITEFILE, $sitefilename)) {
        print "Could not open file $sitefilename!\n";
        exit;
}
my @site_file = <SITEFILE>;
        close SITEFILE;

foreach $site_file (@site_file) {
        my $site = $site_file;
        chomp $site;
        #print "site:$site\nsite_file:$site_file\n";
        my $upper_lim;
        my $lower_lim;
        foreach $map_coordinates (@map_coordinates) {
                my $coordinate = $map_coordinates ;
                #print "Map coordinate: $coordinate\tSite: $site\n";
                unless ($coordinate eq 'NA') {
                        if($coordinate >= $site) {
                                #print "higher\n";
                                $upper_lim = $coordinate;
                                last;
                        } else {
                                #print "lower\n";
                                $lower_lim = $coordinate;
                        }

                } else {
                        $upper_lim = 'NA' ;
                        $lower_lim = 'NA' ;
                }
        }

        # Determine the position of this site
        unless ($upper_lim) {
                #print "STOP";
                $upper_lim = 'NA' ;
                #$apple=<STDIN>;
        }

        unless ( $lower_lim eq 'NA' || $upper_lim eq 'NA' ) {
                unless ( $maphash{$lower_lim} eq 'NA' || $maphash{$upper_lim} eq 'NA' || $lower_lim eq 'NA' || $upper_lim eq 'NA' ) {
                        if ($lower_lim == $upper_lim) {
                                # NOTE : This should not happen in this new version of this script, but it is here just in case
                                #print "$site\n$lower_lim\t$maphash{$lower_lim}\n$upper_lim\t$maphash{$upper_lim}\n";
                                #$apple=<STDIN>;
                                $M_position = "SKIP" ;
                        } else {

                                $map_distance_full = $upper_lim - $lower_lim ;
                                $map_distance_toSite = $upper_lim - $site ;
                                $cM_distance = $maphash{$upper_lim} - $maphash{$lower_lim} ;
                                #print "Map Distance: $map_distance_full \tcM Distance: $cM_distance\tMap Distance to Site: $map_distance_toSite\n";

                                $position_percentage = $map_distance_toSite / $map_distance_full ;
                                $cM_change = $position_percentage * $cM_distance ;
                                $cM_position = $maphash{$upper_lim} - $cM_change ;
                                $M_position = $cM_position/100 ;

                                #print "Position percentage: $position_percentage\tcM Change: $cM_change\tcM Position: $cM_position\tM Position: $M_position\n" ;

                                #$apple=<STDIN>;
                        }
                } else {
                        $M_position = "SKIP" ;
                }
        } else {
                $M_position = "SKIP" ;
        }

        # print to the outfile
        unless ($M_position eq "SKIP") {
                print OUTFILE "$site\t$M_position\n" ;
        }
}

close OUTFILE;
