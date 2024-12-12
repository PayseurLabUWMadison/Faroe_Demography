1. Pair-end 150bp sequencing reads were generated using Illumina NovaSeq 6000 technology
2. Reads were aligned using bwa mem2
3. Followed GATK best practices to process alignment files, call and filter variants
4. Variants were called for each population separately, and were then merged variants together for all populations
5. Missing genotypes were identified and filled in using GATK --all-sites option for each population
