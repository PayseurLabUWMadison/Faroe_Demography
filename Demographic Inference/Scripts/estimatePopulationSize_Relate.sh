#!/bin/bash

for i in {1..100}; do
        /software/relate/scripts/EstimatePopulationSize/EstimatePopulationSize.sh -i Norway4_Nosloy8_Sandoy12_relate_output --first_chr 1 --last_chr 19 -m 5e-9 --poplabels norway_nolsoy_sandoy.poplabels --pop_of_interest Norway,Nolsoy --years_per_gen 0.5 --bins 0,6,0.1 --num_iter 10 --seed ${i} -o Norway4_Nosloy8_Sandoy12_relate_popsize_norway_nolsoy_seed${i}_autosomes &
        /software/relate/scripts/EstimatePopulationSize/EstimatePopulationSize.sh -i Norway4_Nosloy8_Sandoy12_relate_output --first_chr 1 --last_chr 19 -m 5e-9 --poplabels norway_nolsoy_sandoy.poplabels --pop_of_interest Norway,Sandoy --years_per_gen 0.5 --bins 0,6,0.1 --num_iter 10 --seed ${i} -o Norway4_Nosloy8_Sandoy12_relate_popsize_norway_sandoy_seed${i}_autosomes &
        /software/relate/scripts/EstimatePopulationSize/EstimatePopulationSize.sh -i Norway4_Nosloy8_Sandoy12_relate_output --first_chr 1 --last_chr 19 -m 5e-9 --poplabels norway_nolsoy_sandoy.poplabels --pop_of_interest Nolsoy,Sandoy --years_per_gen 0.5 --bins 0,6,0.1 --num_iter 10 --seed ${i} -o Norway4_Nosloy8_Sandoy12_relate_popsize_nolsoy_sandoy_seed${i}_autosomes &
done
