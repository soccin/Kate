#!/bin/bash

BAM=$1

BASE=$(basename ${BAM/.bam/})

case $BASE in
    *Pre*)
        group="Pre.Tumor.SP"
        ;;
    *DP*)
        group="PDAC.DP"
        ;;
    *SP*)
        group="PDAC.SP"
        ;;
    *)
        echo UNKNOWN $BASE
        exit
esac

TOTAL=$(samtools view -F 2048 -q 30 $BAM | fgrep -v "XA:Z:" | cut -f1 | sort -S 2g | uniq | wc -l)

echo "$BASE $group $TOTAL" | tr " " "\t" >${BAM/.bam/__total.txt}

samtools view -F 2048 -q 30 -h $BAM \
  | fgrep -v "XA:Z:" \
  | samtools view -Sb - \
  | bedtools coverage -a genome/contigs/targetB.bed -b - >${BAM/.bam/__cov.txt}

