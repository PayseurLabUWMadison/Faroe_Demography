#!/bin/bash

# Ancestry call by ancestry_hmm
echo "Starting Run" >> PROGRESS_FS.log
date >> PROGRESS_FS.log

for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 ; do
        echo "Starting $c" >> PROGRESS_FS.log
        date >> PROGRESS_FS.log
        # mkdir chr$c
        cd chr$c

        bcftools view -r chr$c All_Samples.vcf.gz -s {Target Population Samples} --max-alleles 2 --exclude-types indels | bcftools view -i 'F_MISSING<0.5' > chr$c.target.plinkready.vcf
        bcftools view -r chr$c All_Samples.vcf.gz -s {Source Population1 Samples} --max-alleles 2 --exclude-types indels | bcftools view -i 'F_MISSING<0.5' > chr$c.AL.plinkready.vcf
        bcftools view -r chr$c All_Samples.vcf.gz -s {Source Population2 Samples} --max-alleles 2 --exclude-types indels | bcftools view -i 'F_MISSING<0.5' > chr$c.MC.plinkready.vcf
        bcftools view -r chr$c All_Samples.vcf.gz -s {Source Population3 Samples} --max-alleles 2 --exclude-types indels | bcftools view -i 'F_MISSING<0.5' > chr$c.CR.plinkready.vcf
        bcftools view -r chr$c All_Samples.vcf.gz -s {Source Population4 Samples} --max-alleles 2 --exclude-types indels | bcftools view -i 'F_MISSING<0.5' > chr$c.TP.plinkready.vcf

        for set in 0 1 2 3 ; do

                if [[ $set == 0 ]] ; then
                        MUS="AL"
                        DOM="MC"
                elif [[ $set == 1 ]] ; then
                        MUS="CR"
                        DOM="TP"
                elif [[ $set == 2 ]] ; then
                        MUS="CR"
                        DOM="MC"
                elif [[ $set == 3 ]] ; then
                        MUS="AL"
                        DOM="TP"
                fi


                mkdir Target_Set$set
                cp ../integrate_cox_map_no0.sh ../convert_sites_OneChr_no0.pl ../make_map_target.pl ../count_switches_target.pl Target_Set$set/
                cd Target_Set$set/

                echo "Making panel file for target $c set $set" >> PROGRESS_FS.log
                date >> PROGRESS_FS.log

                grep -v '^#' ../chr$c.${DOM}.plinkready.vcf | awk 'BEGIN {print "rsID\tposition\tAllele1\tAllele2"} {printf $1 $2 "\t" sprintf("%09d", $2) "\t" $4 "\t" $5 ; for(i=10;i<=NF;i++)printf "\t" $i; print ""}' | sed 's/:[0-9\.,|_
A-Za-z]*//g' | sed 's/\//\t/g' | grep -v ',' | grep -v '\.' | awk -v chr="$c" '{allele0=0;allele1=0; for(i=5; i<=NF; i++) if($i==0){allele0 += 1} else if($i==1){allele1+=1}; print chr "-" $2 "-" $3 "-" $4 "-0\t" allele0 "\t" allele1 } ' >
 chr$c.${DOM}.txt
                grep -v '^#' ../chr$c.${MUS}.plinkready.vcf | awk 'BEGIN {print "rsID\tposition\tAllele1\tAllele2"} {printf $1 $2 "\t" sprintf("%09d", $2) "\t" $4 "\t" $5 ; for(i=10;i<=NF;i++)printf "\t" $i; print ""}' | sed 's/:[0-9\.,|_
A-Za-z]*//g' | sed 's/\//\t/g' | grep -v ',' | grep -v '\.' | awk -v chr="$c" '{allele0=0;allele1=0; for(i=5; i<=NF; i++) if($i==0){allele0 += 1} else if($i==1){allele1+=1}; print chr "-" $2 "-" $3 "-" $4 "-0\t" allele0 "\t" allele1 } ' >
 chr$c.${MUS}.txt
                join -j1 <(sort chr$c.${DOM}.txt) <(sort chr$c.${MUS}.txt) > chr$c.panel.txt
                grep -v '^#' ../chr$c.target.plinkready.vcf | awk -v chr="$c" '{printf chr "-" sprintf("%09d", $2) "-" $4 "-" $5 "-0" ; for(i=10;i<=NF;i++)printf "\t" $i; print "" }' | sed 's/\t[^:\t]*:/\t/g' | sed 's/:[^\t]*\t/\t/g' | se
d 's/:[^\t]*$//g' | sed 's/,/\t/g' > chr$c.target.txt
                join -j1 <(sort chr$c.panel.txt) <(sort chr$c.target.txt) > chr$c.all.1.txt
                sed 's/-/ /g' chr$c.all.1.txt | awk '{printf $1 "\t" $2 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t0" ; for(i=10;i<=NF;i++)printf "\t" $i; print ""}' > chr$c.all.2.txt
                awk '!($3==0 && $5==0)' chr$c.all.2.txt | awk '!($4==0 && $6==0)' > ${DOM}_${MUS}_target_noMap.panel

                bash integrate_cox_map_no0.sh $c ${DOM}_${MUS}_target_noMap.panel

                cp ../../Target.sample ${DOM}_${MUS}_target.sample

                echo "Starting Ancestry Inference for target $c Set $set" >> PROGRESS_FS.log
                date >> PROGRESS_FS.log

                ../../src/ancestry_hmm -i ${DOM}_${MUS}_target.panel -s ${DOM}_${MUS}_target.sample -a 2 0.5 0.5 -p 0 100000 0.5 -p 1 5000 0.5
                perl make_map_target.pl $c
                perl count_switches_target.pl $c
                Rscript ../../merge_Target_WG_all_map_files.R $c
                cd ..

        done

        # Union Set

        echo "Starting target chr $c Union " >> PROGRESS_FS.log
        date >> PROGRESS_FS.log

        mkdir Target_Set4/
        cp ../count_switches_target.pl ../make_union_map_3_target.R Target_Set4/
        cd Target_Set4/

        echo "Making Union Map Files" >> PROGRESS_FS.log
        date >> PROGRESS_FS.log

        Rscript make_union_map_3_target.R $c

        echo "Counting Switches" >> PROGRESS_FS.log
        date >> PROGRESS_FS.log

        perl count_switches_target.pl $c
        Rscript ../../merge_Target_WG_all_map_files.R $c

        cd ..



        # go to next chromosome
        cd ..
done
