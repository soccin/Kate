#!/bin/bash

#
# samtools
#   Program: samtools (Tools for alignments in the SAM format)
#   Version: 1.9 (using htslib 1.9)
#
# bedtools
#   Version:   v2.27.1
#   About:     developed in the quinlanlab.org and by many contributors worldwide.
#   Docs:      http://bedtools.readthedocs.io/
#   Code:      https://github.com/arq5x/bedtools2
#   Mail:      https://groups.google.com/forum/#!forum/bedtools-discuss
#

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
  | bedtools coverage -a genome/targetB.bed -b - >${BAM/.bam/__cov.txt}

