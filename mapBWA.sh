#!/bin/bash

#
# fastx_trimmer is from
#   http://hannonlab.cshl.edu/fastx_toolkit/
#   Part of FASTX Toolkit 0.0.13 by A. Gordon (gordon@cshl.edu)
#
# bwa
#   Program: bwa (alignment via Burrows-Wheeler transformation)
#   Version: 0.7.17-r1188
#   Contact: Heng Li <lh3@sanger.ac.uk>
#
# samtools
#   Program: samtools (Tools for alignments in the SAM format)
#   Version: 1.9 (using htslib 1.9)
#

CHECK_BWA=$(which bwa 2> /dev/null)
if [ "$CHECK_BWA" == "" ]; then
    module load bwa
fi

GENOME=./genome/mm10_eGFP_mKate/mm10_eGFP_mKate.fa
GTAG=$(basename ${GENOME/.fa*/})

FASTQ=$1
BASE=$(basename $FASTQ | sed 's/.fastq.gz//')
SAMPLE=$(echo $BASE | sed 's/_L00.*//')
SID=$(echo $SAMPLE | sed 's/.sc.*//')

ODIR=out/$GTAG/$SID/$SAMPLE
mkdir -p $ODIR

zcat $FASTQ \
    | ./bin/fastx_trimmer -Q 33 -f 51 - \
    | bwa mem -t 8 -R "@RG\tID:"${SAMPLE}"\tSM:"${SAMPLE} $GENOME - \
    | samtools sort --threads 3 -m 1G - \
    > $ODIR/${SAMPLE}.bam
 
samtools index $ODIR/${SAMPLE}.bam
