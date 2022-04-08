#!/bin/bash

ln -s /juno/res/mix/Cache/2021-11-04/Kentsis/SRACache
ln -s /home/socci/Work/Users/KentsisA/TakaoS/ExternalData_2110/SRA/sra-tools

cat info/sra.dump.annotations.nick.20220223.txt  | fgrep -v filename | cut -f2,3 | xargs -n 2 ./srr2fastq.sh

#
# Need to make mm10+eGFP+mKate genome and target file
#

ln -s /opt/common/CentOS_6/fastx_toolkit/fastx_toolkit-0.0.13 fbin

find FASTQ/ | fgrep .gz | xargs -n 1 bsub -o LSF/ -J BWA_$$ -n 8 -W 59 ./mapBWA.sh

bSync BWA_$$

find out | fgrep .bam | fgrep -v .bai | xargs -n 1 bsub -o LSF.COUNT/ -J COUNT_$$ -n 3 -W 59 ./countGenome.sh

bSync COUNT_$$

Rscript --no-save loadData.R
