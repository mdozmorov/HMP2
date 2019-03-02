library(dplyr)
options(stringsAsFactors = FALSE)

# Make taxonomy table
green <- read.table("data/gg_13_5_taxonomy.txt.gz", sep = "\t")
# Get taxonomy column
mtx_tax_table <- as.character(green$V2)
# Split the combined strings, and combine them into data frame
mtx_tax_table <- sapply(mtx_tax_table, function(x) strsplit(x, "; ")) %>% unname %>% do.call(rbind, .)

# A function to take column i, extract taxa level prefix, return unique prefixes
# Made for sanity check - each column should return only one taxa level ID
check_taxa_level <- function(mtx_tax_table, i) {
  sapply(mtx_tax_table[, i], function(x) strsplit(x, "__")[[1]][1]) %>% unname %>% unique
}
# Actually do sanity check - should be single letters corresponding to
# Kingdom   Phylum          Class          Order          Family          Genus        Species
for (i in 1:ncol(mtx_tax_table)) {
  check_taxa_level(mtx_tax_table = mtx_tax_table, i) %>% print
}

# A function to take a column and remove taxa level prefix from it
prune_taxa_level <- function(column) {
  sapply(column, function(x) strsplit(x, "__")[[1]][2]) %>% unname
}
# Actually remove prefixes from the columns
mtx_tax_table <- apply(mtx_tax_table, 2, function(x) prune_taxa_level(x))

# Attach column and row names
colnames(mtx_tax_table) <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species") # Fixed names
rownames(mtx_tax_table) <- green$V1 # Greengene IDs
mtx_tax_table[1:5, 1:5]

save(mtx_tax_table, file = "data/gg_13_5_taxonomy.rda")
