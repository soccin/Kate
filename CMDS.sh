#!/bin/bash

# R
#   R scripting front-end version 4.1.2 (2021-11-01)

#
# Need to make mm10+eGFP+mKate genome and target file for BWA
#

find FASTQ/ | fgrep .gz | xargs -n 1 ./mapBWA.sh

find out | fgrep .bam | fgrep -v .bai | xargs -n 1 ./countGenome.sh

Rscript --no-save loadData.R
Rscript --no-save analysisGenome.R

