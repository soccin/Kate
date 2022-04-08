require(patchwork)
require(tidyverse)
require(openxlsx)

db=readRDS("proj_Kate_DataTable0.rds")

counts=db$Counts

sample.counts=counts %>%
    gather(Gene,Count,5:ncol(counts)) %>%
    select(-Run) %>%
    group_by(sample_category,Sample,Gene) %>%
    summarize(Sample.Counts=sum(Count))

sample.totals=sample.counts %>% filter(Gene=="Total") %>% select(Sample,Sample.Total=Sample.Counts)

dd=sample.counts %>%
    filter(Gene!="Total") %>%
    left_join(sample.totals) %>%
    left_join(db$GeneLen) %>%
    mutate(RPKM.Sample=Sample.Counts/((Sample.Total/1e6)*(Length/1e3))) %>%
    mutate(sample_category=factor(sample_category,levels=c("PDAC.DP","Pre.Tumor.SP","PDAC.SP")))

pg0=dd %>% ggplot(aes(sample_category,RPKM.Sample,fill=Gene)) + theme_light(base_size=14) + scale_fill_brewer(palette="Dark2") + scale_x_discrete(guide = guide_axis(angle=45))

pDebug=pg0 + geom_boxplot(outlier.color="darkred",outlier.size=4,outlier.shape=18) + geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.9)) + facet_wrap(~Gene)

pdf(file="proj_Kate_v4_DEBUG.pdf",width=11,height=8.5)
print(pDebug)
dev.off()

outlier.eGFP=dd %>% group_by(sample_category,Gene) %>% mutate(Rank=rank(-RPKM.Sample)) %>% filter(Gene=="eGFP" & Rank==1)

write.xlsx(c(list(Outlier.eGFP=outlier.eGFP,Data=dd),db),"proj_Kate_DataTable1_v4.xlsx")

pg1=pg0 + geom_boxplot(outlier.shape=NA) + geom_point(position = position_jitterdodge(seed = 1, dodge.width = 0.1)) + facet_wrap(~Gene)

pg0b=filter(dd,Gene!="Clp1") %>% ggplot(aes(sample_category,RPKM.Sample,fill=Gene)) + theme_light(base_size=14) + scale_fill_brewer(palette="Dark2") + scale_x_discrete(guide = guide_axis(angle=45))
pg1b=pg0b + geom_boxplot(outlier.shape=NA) + facet_wrap(~Gene) + ylim(0,.3)

pdf(file="proj_Kate_v4a.pdf",width=11,height=8.5)
print(pg1)
print(pg1b)
dev.off()

