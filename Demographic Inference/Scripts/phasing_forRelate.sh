#!/bin/bash

for i in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19; do
        java -Xmx24g -jar beagle.06Aug24.a91.jar gt=Nolsoy8_${i}.vcf map=map_3pops_${i}_beagle.txt out=Nolsoy8_${i}_beagle
        java -Xmx24g -jar beagle.06Aug24.a91.jar gt=Sandoy12_${i}.vcf map=map_3pops_${i}_beagle.txt out=Sandoy12_${i}_beagle
        java -Xmx24g -jar beagle.06Aug24.a91.jar gt=Norway4_${i}.vcf map=map_3pops_${i}_beagle.txt out=Norway4_${i}_beagle
done
