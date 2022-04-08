require(tidyverse)
require(fs)
require(openxlsx)

files=dir_ls("out/",recurs=T,regex="cov.txt")

ff=files

xx=map(ff,read_tsv,col_names=F) %>%
    bind_rows(.id="PATH") %>%
    mutate(Cell=basename(PATH) %>% gsub("__cov.*","",.)) %>%
    mutate(Sample=gsub(".sc\\d+","",Cell)) %>%
    mutate(Group=gsub(".Tumor\\d+","",Sample)) %>%
    select(-PATH) %>%
    rename(Count=X5) %>%
    rename(Gene=X4)

totals=map(gsub("cov","total",ff),read_tsv,col_names=c("Cell","TAG","Total")) %>% bind_rows %>% select(-TAG)

counts=xx %>% select(Sample,Cell,Gene,Count) %>% spread(Gene,Count)

counts=left_join(counts,totals)

manifest=read_tsv("info/sra.dump.annotations.20220223.txt")

counts=left_join(counts,manifest,by=c(Cell="sample_name")) %>%
    select(sample_category,Sample,Cell,Run,everything()) %>%
    select(-filename)

geneLen=xx %>% select(Gene,Length=X7) %>% distinct

db=list(Counts=counts,GeneLen=geneLen,RAW=xx,Totals=totals)

saveRDS(db,"proj_Kate_DataTable0.rds",compress=T)
