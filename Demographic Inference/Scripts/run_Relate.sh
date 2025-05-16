#!/bin/bash

for i in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19; do
        /relate/scripts/PrepareInputFiles/PrepareInputFiles.sh --haps Norway_Nosloy_Sandoy_${i}.haps --sample Norway_Nosloy_Sandoy.sample --ancestor ${i}_polarized.fa -o Norway_Nosloy_Sandoy_relate_input_${i}
        gunzip Norway_Nosloy_Sandoy_relate_input_${i}.haps.gz
        /relate/bin/Relate --mode All -m 5e-9 -N 10000 --haps Norway_Nosloy_Sandoy_relate_input_${i}.haps --sample Norway_Nosloy_Sandoy.sample --map genetic_map_Norway_Nosloy_Sandoy_${i}.txt --seed 1 -o Norway_Nosloy_Sandoy_relate_output_${i}
done
