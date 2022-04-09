# Project Kate

Simple copy number analysis pipeline of transgenic elements

A hybrid genome of mm10 with the sequence elements for eGFP and mKate was made and then index for BWA. The raw fastq files were retrieved from SRA (see FASTQ/MANIFEST_MD5 for a full list with signatures). The samples were first mapped to the hybrid genome using bwa and then counts of reads mapping to the two trans-elements (eGFP and mKate) along with genes Clp1 and Trp53 were collected using bedtools coverage. Reads were filtered to remove supplementary alignments, those marked with alternative hits (XA:Z: bwa flag) and those with a MAPQ < 30. The resulting coverage files where then processed with R scripts to normalize the counts to RPKM values and then plot the distribution of normalized coverage by gene and sample type.

