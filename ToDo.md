# ToDo

- Download .biom files from https://portal.hmpdacc.org/search/f?filters=%7B%22op%22:%22and%22,%22content%22:%5B%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22cases.study_name%22,%22value%22:%5B%22MOMS-PI%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_format%22,%22value%22:%5B%22Biological%20Observation%20Matrix%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_matrix_type%22,%22value%22:%5B%2216s_community%22%5D%7D%7D%5D%7D&facetTab=files&pagination=%7B%22files%22:%7B%22from%22:0,%22size%22:20,%22sort%22:%22file_name.raw:asc%22%7D%7D locally
    - See help/instructions 
    - Try small batch first
- Go through the vignette of https://bioconductor.org/packages/release/data/experiment/html/HMP16SData.html - Bioconductor version of HMP16SData
- Read in some .biom files using https://www.bioconductor.org/packages/release/bioc/html/biomformat.html - package to read .biom files
- Clone and understand https://github.com/waldronlab/HMP16SData - code for the HMP16SData package


## Questions

- Why `HMP16SData` splits the data into `V13` and `V35` objects?
- Why ExperimentalHub?
- Where to get basic phenotypic information about the HMP2 data, besides downloadable metadata?
- Can we do more than .biom files, e.g., process .fastq, is it worth it?