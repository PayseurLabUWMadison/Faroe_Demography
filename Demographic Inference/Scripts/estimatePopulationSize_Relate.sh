#!/bin/bash

for i in {1..100}; do
        /software/relate/scripts/EstimatePopulationSize/EstimatePopulationSize.sh -i Norway4_Nosloy8_Sandoy12_relate_output_norway_nolsoy_autosomes_2gensPerYear_NorwayNolsoy --first_chr 1 --last_chr 19 -m 5e-9 --poplabels norway_nolsoy.poplabels --years_per_gen 0.5 --bins 0,6,0.1 --num_iter 10 --seed ${i} -o Norway4_Nosloy8_Sandoy12_relate_popsize_norway_nolsoy_seed${i}_autosomes_2gensPerYear &
        /software/relate/scripts/EstimatePopulationSize/EstimatePopulationSize.sh -i Norway4_Nosloy8_Sandoy12_relate_output_norway_sandoy_autosomes_2gensPerYear_NorwaySandoy --first_chr 1 --last_chr 19 -m 5e-9 --poplabels norway_sandoy.poplabels --years_per_gen 0.5 --bins 0,6,0.1 --num_iter 10 --seed ${i} -o Norway4_Nosloy8_Sandoy12_relate_popsize_norway_sandoy_seed${i}_autosomes_2gensPerYear &
        /software/relate/scripts/EstimatePopulationSize/EstimatePopulationSize.sh -i Norway4_Nosloy8_Sandoy12_relate_output_nolsoy_sandoy_autosomes_2gensPerYear_NolsoySandoy --first_chr 1 --last_chr 19 -m 5e-9 --poplabels nolsoy_sandoy.poplabels --years_per_gen 0.5 --bins 0,6,0.1 --num_iter 10 --seed ${i} -o Norway4_Nosloy8_Sandoy12_relate_popsize_nolsoy_sandoy_seed${i}_autosomes_2gensPerYear &
done
