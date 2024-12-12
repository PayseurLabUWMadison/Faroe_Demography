#!/bin/bash

java -Xmx20g -jar /picard/build/libs/picard.jar MarkDuplicates \
INPUT=/bamfile-directory/${sample}.bam \
OUTPUT=/dedup-bamfile-directory/${sample}_dedup.bam \
METRICS_FILE=/dedup-bamfile-directory/${sample}_duplicate.metrics \
REMOVE_DUPLICATES=true \
ASSUME_SORTED=true TMP_DIR=/tmp_${sample}/ \
MAX_RECORDS_IN_RAM=500000 \
VALIDATION_STRINGENCY=LENIENT
