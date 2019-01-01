# ToDo

- Compare and understand HMP2 data from different sources

## John

- Go through the vignette of https://bioconductor.org/packages/release/data/experiment/html/HMP16SData.html - Bioconductor version of HMP16SData
- Clone and understand https://github.com/waldronlab/HMP16SData - code for the HMP16SData package
- Read in some .biom files using https://www.bioconductor.org/packages/release/bioc/html/biomformat.html - package to read .biom files

## For the joint meeting

- The MOMS-PI data and the phyloseq objects are ready. The data will be in a form of a matrix and a phyoseq object - any other data format suggestions?
- How do we release MOMS-PI, T2D, and IBD data - in one package? These studies are non-overlapping.
- Unreadable biom files - going to contact Cesar Arze, carze@hsph.harvard.edu
- Only MOMS-PI has a substantial number of cytokine data. Is it worth it to make a MultiAssayExperiment object? 
    - Broad (https://ibdmdb.org/tunnel/public/summary.html) has relatively well-organized datasets amenable for integration. Need expert interpretation, it is currently unclear what column/row IDs are.
- Analysis question: What kind of filtering/normalization we should do? There is a wide variety of library sizes (column totals), from 2 to 1501486 - some filtering/normalization should be done. Same for taxa counts (row totals), many rows are completely zeros, some have median count of 1, some - ~2000, and a maximum is 3222950. Consequently, variability across columns and rows varies a lot, from 0 to ~46K-71K. 