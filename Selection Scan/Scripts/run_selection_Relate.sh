#!/bin/bash

for i in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19; do
        /relate/bin/RelateSelection --mode Frequency -i Norway_Nosloy_Sandoy_relate_output_popsize_Nolsoy_forSelection_autosomes_Nolsoy_${i} -o Nosloy_${i}_freq
        /relate/bin/RelateSelection --mode Selection -i Nosloy_${i}_freq -o Nosloy_${i}_sel
        /relate/bin/RelateSelection --mode Quality -i Norway_Nosloy_Sandoy_relate_output_popsize_Nolsoy_forSelection_autosomes_Nolsoy_${i} -o Nosloy_${i}_qual

        /relate/bin/RelateSelection --mode Frequency -i Norway_Nosloy_Sandoy_relate_output_popsize_Sandoy_forSelection_autosomes_Sandoy_${i} -o Sandoy_${i}_freq
        /relate/bin/RelateSelection --mode Selection -i Sandoy_${i}_freq -o Sandoy_${i}_sel
        /relate/bin/RelateSelection --mode Quality -i Norway_Nosloy_Sandoy_relate_output_popsize_Sandoy_forSelection_autosomes_Sandoy_${i} -o Sandoy_${i}_qual

        /relate/bin/RelateSelection --mode Frequency -i Norway_Nosloy_Sandoy_relate_output_popsize_Norway_forSelection_autosomes_Norway_${i} -o Norway_${i}_freq
        /relate/bin/RelateSelection --mode Selection -i Norway_${i}_freq -o Norway_${i}_sel
        /relate/bin/RelateSelection --mode Quality -i Norway_Nosloy_Sandoy_relate_output_popsize_Norway_forSelection_autosomes_Norway_${i} -o Norway_${i}_qual

        /relate/bin/RelateSelection --mode Frequency -i Norway_Nosloy_Sandoy_relate_output_popsize_Faroe_forSelection_autosomes_Faroe_${i} -o Faroe24_${i}_freq
        /relate/bin/RelateSelection --mode Selection -i Faroe24_${i}_freq -o Faroe24_${i}_sel
        /relate/bin/RelateSelection --mode Quality -i Norway_Nosloy_Sandoy_relate_output_popsize_Faroe_forSelection_autosomes_Faroe_${i} -o Faroe24_${i}_qual
done
