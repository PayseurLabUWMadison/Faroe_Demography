#!/bin/bash

# Generating gvcf file with GATK HaplotypeCaller
gatk --java-options "-Xmx8g" HaplotypeCaller -R mm10.fa -I sample_nodup.bam -O sample.g.vcf.gz -ERC GVCF

# Combining gvcf files for samples in the same population
gatk CombineGVCFs -R mm10.fa --variant sample1.g.vcf.gz --variant sample2.g.vcf.gz -O pop.g.vcf.gz

# Calling genotypes
gatk --java-options "-Xmx8g" GenotypeGVCFs -R mm10.fa -V pop.g.vcf.gz -O pop_variants.vcf.gz

# Filtering variants
gatk VariantFiltration -V pop_variants.vcf.gz -filter "QD < 2.0" --filter-name "QD2" -filter "SOR > 3.0" --filter-name "SOR3" -filter "FS > 60.0" --filter-name "FS60" -filter "MQ < 40.0" --filter-name "MQ40" -filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" -O pop_variants_filtered.vcf.gz

# Removing indels and SNPs which didn't pass the filter
bcftools view --exclude-types indels --max-alleles 2 -f PASS pop_variants_filtered.vcf.gz -O z -o pop_variants_filtered_passed.vcf

# Filling in missing genotypes
gatk --java-options “-Xmx8g” GenotypeGVCFs --use-jdk-inflater true --use-jdk-deflater true --all-sites --intervals pop_missing_sites.list -R mm10.fa -V pop.g.vcf.gz -O pop_missing_genotypes.vcf.gz

# Merging original SNPs with missing SNPs
java -jar picard.jar GatherVcfs I=pop_variants_filtered_passed.vcf.gz I=pop_missing_genotypes_filtered_passed.vcf.gz O=pop_all_bialleleic_snps.vcf.gz
