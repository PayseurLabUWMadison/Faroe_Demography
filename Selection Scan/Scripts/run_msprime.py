import tskit
import msprime
import numpy as np
import random
import math
import allel
import os
import sys

# Generating neutral distributions for summary statistics

# Parmaeter names to be replaced with the estimates from best GATK model without inbreeding
TWMISC = msprime.Demography()
# Mainland population size
TWMISC.add_population(name="A", initial_size=Ne_Mainland)
# Island population size
TWMISC.add_population(name="B", initial_size=Ne_Island)
# Ancestral population size, same as mainland population size
TWMISC.add_population(name="C", initial_size=Ne_Ancestral)
# Migration from mainland to island, backward in time
TWMISC.set_migration_rate(source="A", dest="B", rate=m1)
# Migration from island to mainland, backward in time
TWMISC.set_migration_rate(source="B", dest="A", rate=m2)
# Island population size change at time T1
TWMISC.add_population_parameters_change(time=T1, population="B", initial_size=Ne_Colonization)
# Island colonization at time T2 (Island population split from mainland (ancestral) population)
TWMISC.add_population_split(time=T2, derived=["A", "B"], ancestral="C")
# Ancestral population size change at time T3
TWMISC.add_population_parameters_change(time=T3, population="C", initial_size=Ne_Ancestral)

stats = []
seed = sys.argv[1]
# len to be replaced with the average bp length of the bin (Four bins)
regionLen = len

# rep to be replaced with the number of replicates
for x in range(0, rep):
    ts = msprime.sim_ancestry(
        samples={"A": 4, "B": 12},
        demography=TWMISC,
        recombination_rate=5e-9,
        sequence_length=regionLen,
        random_seed=x+1+int(seed)*rep)

    mutated_ts = msprime.sim_mutations(ts, rate=5e-9, random_seed=x+1+int(seed)*rep)

    with open("output.vcf", "w") as vcf_file:
            mutated_ts.write_vcf(vcf_file)

    file_size = os.path.getsize("output.vcf")
    if file_size > 370:
        with open('output.vcf', mode='r') as vcf:
            callset = allel.read_vcf('output.vcf')

        genotype = callset['calldata/GT']
        genotype_main = genotype[:,0:4]
        genotype_island = genotype[:,4:16]
        gt = allel.GenotypeArray(genotype)
        gt_main = allel.GenotypeArray(genotype_main)
        gt_island = allel.GenotypeArray(genotype_island)

        ac_main = gt_main.count_alleles()
        ac_island = gt_island.count_alleles()
        pos = callset['variants/POS']

        # Number of segregating sites
        seg_main = ac_main.count_segregating()
        seg_island = ac_island.count_segregating()

        if ac_main.n_alleles == 2:
            # Number of singletons
            sing_main = ac_main.count_singleton(allele=1) + ac_main.count_singleton(allele=0)
        else:
            sing_main = 0
        if ac_island.n_alleles == 2:
            sing_island = ac_island.count_singleton(allele=1) + ac_island.count_singleton(allele=0)
        else:
            sing_island = 0

        pi_main = allel.sequence_diversity(pos, ac_main, start=0, stop=regionLen)
        pi_island = allel.sequence_diversity(pos, ac_island, start=0, stop=regionLen)
        theta_main = allel.watterson_theta(pos, ac_main, start=0, stop=regionLen)
        theta_island = allel.watterson_theta(pos, ac_island, start=0, stop=regionLen)
        tajima_main = allel.tajima_d(ac_main, min_sites=3)
        tajima_island = allel.tajima_d(ac_island, min_sites=3)

        # Fst Hudson formula
        num, den = allel.hudson_fst(ac_main, ac_island)
        fst_hud = np.sum(num) / np.sum(den)

        stats.append([regionLen, pi_main, pi_island, theta_main, theta_island, tajima_main, tajima_island, fst_hud, seg_main, seg_island, sing_main, sing_island])

    else:
        pi_main = 0
        pi_island = 0
        theta_main = 0
        theta_island = 0
        tajima_main = 1000
        tajima_island = 1000
        fst_avg = 1000
        fst_hud = 1000
        seg_main = 0;
        seg_island = 0
        sing_main = 0
        sing_island = 0

        stats.append([regionLen, pi_main, pi_island, theta_main, theta_island, tajima_main, tajima_island, fst_avg, fst_hud, seg_main, seg_island, sing_main, sing_island])

outfile = "msprime_output_file.txt"
stats_np = np.array(stats)
np.savetxt(outfile, stats_np, delimiter="\t")
