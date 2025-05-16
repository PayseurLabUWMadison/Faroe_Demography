#!/bin/bash

for i in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19; do
        /relate/bin/RelateFileFormats --mode GenerateSNPAnnotations --haps Norway_Nosloy_Sandoy_chr6_${i}.haps --sample Norway_Nosloy_Sandoy.sample --poplabels Norway_Nosloy_Sandoy.poplabels --ancestor ${i}_polarized.fa --mut Norway_Nosloy_Sandoy_relate_output_${i}.mut -o Norway_Nosloy_Sandoy_relate_output_${i} &
done
