options(stringsAsFactors = FALSE)
library(dplyr)
library(readr)
library(MDmisc)

fileNameIn1  <- "data/hmp_cart_metadata_26015b0c41.tsv" # MOMS-PI
fileNameIn2  <- "data.T2D/hmp_cart_metadata_12019e21a0.tsv" # T2D
fileNameIn3  <- "data.IBD/hmp_cart_metadata_35c73e52bd.tsv" # IBD

mtx1 <- read_tsv(fileNameIn1)
mtx2 <- read_tsv(fileNameIn2)
mtx3 <- read_tsv(fileNameIn3)

# Overlap between sample IDs - None
Venn3(mtx1$sample_id, mtx2$sample_id, mtx3$sample_id, names = c("MOMS-PI", "T2D", "IBD"))
# Overlap between subject IDs - None
Venn3(mtx1$subject_id, mtx2$subject_id, mtx3$subject_id, names = c("MOMS-PI", "T2D", "IBD"))
