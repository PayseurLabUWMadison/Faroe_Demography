1. Pair-end 150bp sequencing reads were generated using Illumina NovaSeq 6000 technology
2. Reads were aligned using bwa-mem2
3. PCR/Optical duplicates were removed using Picard
5. Variants were called for each population separately, and were then merged variants together for all populations
   gatk --java-options "-Xmx8g" HaplotypeCaller \
   -R mm39.fa \
   -I ${sample}_dedup.bam \
   -O ${sample}.g.vcf.gz \
   -ERC GVCF

   
   
   gatk --java-options "-Xmx8g" GenotypeGVCFs \
   -R mm39.fa \
   -V ${population}.g.vcf.gz \
   -O variants_D1_1.vcf.gz
7. Missing genotypes were identified and filled in using GATK --all-sites option for each population
