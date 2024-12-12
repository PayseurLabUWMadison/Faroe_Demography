#!/bin/bash

infilename=$(echo "$(basename "$1")" | head -n 1 | cut -f1 -d".")
outfilename=$(echo $infilename | head -n 1 | cut -f 1-3 -d"_")
# echo $outfilename
sm=$(echo "$(basename "$1")" | head -n 1 | cut -f1 -d"_")
header=$(zcat $1 | head -n 1)
id=$(echo $header | head -n 1 | cut -f 1-3 -d":" | sed 's/@//' | sed 's/:/_/g')
lane=$(echo $header | head -n 1 | cut -f4 -d":")
# echo "Read Group @RG\tID:$id.$lane\tPU:$id.$lane.$sm\tSM:$sm\tLB:library"_"$sm\tPL:ILLUMINA"

bwa-mem2-directory/bwa-mem2 mem -M -t 4 \
-R $(echo "@RG\tID:$id.$lane\tPU:$id.$lane.$sm\tSM:$sm\tLB:library"_"$sm\tPL:ILLUMINA") \
mm10-directory/mm10.fa \
$1 $2 | samtools sort -O bam -o ${outfilename}_adapterTrimmed.bam
