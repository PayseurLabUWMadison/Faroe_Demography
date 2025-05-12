#!/bin/bash

# Script to integrate the reference map into the panel file with linear interpolation
# Read in the input
CHR=$1
PANEL=$2
PANEL2=$(echo $(basename $PANEL) | sed 's/_noMap//g' )

# Make a one chromosome file
grep "^$CHR," ../../ready_cox_map.txt > one_chr_map.txt

# integrate the files
cut -f2 $PANEL | sed 's/\t0*/\t/' > pre_conversion.txt
perl convert_sites_OneChr_no0.pl
awk '{$1=sprintf("%09d",$1);print $1"\t"$2 }' post_conversion.txt | sort -n | awk '{print $0"\t"$2-p}{p=$2}' > post_conversion_2.txt

# Add line to replace 0s with scaled differences (Cannot add at earlier conversion step because it changes the map)
awk '{if ($3==0) print $0"\t"0.000000001 ; else print $0"\t"$3}' post_conversion_2.txt > post_conversion_3.txt
awk 'NR==FNR {h[$1] = $4; next} {$7=h[$2]; print $0}' post_conversion_3.txt $PANEL | sed 's/  / SKIP /g' | grep -v "SKIP" > $PANEL2
