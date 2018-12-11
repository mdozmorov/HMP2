library(HMP16SData)
library(phyloseq)
library(magrittr)
library(ggplot2)
library(tibble)
library(dplyr)
library(dendextend)
library(circlize)
library(curatedMetagenomicData)
library(gridExtra)
library(cowplot)
library(readr)
library(haven)

library(HMP16SData)
browseVignettes("HMP16SData")
## Load data from V1-3 variable region of 16S rRNA gene for 
## Human Microbiome Project
x = V13()
dim(x)
colData(x)
table(x$RUN_CENTER)
assay(x)
summary(colSums(assay(x)))
class(x)
rowData(x)
names(metadata(x))

select(x, x$HMP_BODY_SUBSITE=="Vaginal Introitus")
x2 <- subset(x, select = HMP_BODY_SUBSITE == "Vaginal Introitus" & RUN_CENTER == "WUGC")


V35_stool <-
  V35() %>%
  subset(select = HMP_BODY_SUBSITE == "Stool" & RUN_CENTER == "WUGC")

help(package="HMP16SData")

ps <- as_phyloseq(x2)
GPUF <- UniFrac(ps)

GloPa.pcoa = ordinate(ps, method="PCoA", distance=GPUF)
plot_scree(GloPa.pcoa, "Scree plot for Vaginal Introitus, UniFrac/PCoA")

## curatedMetagenomicData
curatedMetagenomicData()
zeller <- curatedMetagenomicData(c("ZellerG_2014.metaphlan_bugs_list.stool", "ZellerG_2014.pathabundance_relab.stool"), dryrun = FALSE)

library(MultiAssayExperiment)
mae <- MultiAssayExperiment(zeller, colData = pData(zeller[[1]]))
wf <- wideFormat(mae, colDataCols = "study_condition")

## Demonstrate ExperimentList for multiple studies
el <- curatedMetagenomicData("*metaphlan*", dryrun = FALSE) #all metaphlan profiles
explist <- MultiAssayExperiment::MultiAssayExperiment(el)
rownames(explist)
intersectRows(explist)
rownames(el[[1]])[2]
explist["k__Viruses", ]
