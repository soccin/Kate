#!/bin/bash

CHECK_BWA=$(which bwa 2> /dev/null)
if [ "$CHECK_BWA" == "" ]; then
    module load bwa
fi

#GENOME=genome/genomeKate.fa
#GENOME=/juno/depot/assemblies/M.musculus/mm10/index/bwa/0.7.12/mm10.fasta
GENOME=/juno/work/bic/socci/Work/Users/BaslanT/Kate/genome/mm10_eGFP_mKate/mm10_eGFP_mKate.fa
GTAG=$(basename ${GENOME/.fa*/})

FASTQ=$1
BASE=$(basename $FASTQ | sed 's/.fastq.gz//')
#STAG=$(echo $BASE | sed 's/LOH.//' | sed 's/Tumor[0-9].//' | sed 's/.sc.*$//')
SAMPLE=$(echo $BASE | sed 's/_L00.*//')
SID=$(echo $SAMPLE | sed 's/.sc.*//')

ODIR=out/$GTAG/$SID/$SAMPLE
mkdir -p $ODIR

zcat $FASTQ \
    | ./fbin/fastx_trimmer -Q 33 -f 51 - \
    | bwa mem -t 8 -R "@RG\tID:"${SAMPLE}"\tSM:"${SAMPLE} $GENOME - \
    | samtools sort --threads 3 -m 1G - \
    > $ODIR/${SAMPLE}.bam
 
samtools index $ODIR/${SAMPLE}.bam
