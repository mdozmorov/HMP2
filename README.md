# 16S rRNA Sequencing Data from the HMP2 project

* [Files](#files)
* [URLs](#urls)

## Files

- `Methods.md` - Methods notes
- `ToDo.md` - current todos

- `data`
    - `hmp_cart_1c572b0ab.tsv` - manifest for first three files
    - `hmp_cart_metadata_b53a6441a.tsv` - metadata for first three files


## URLs

- https://www.hmpdacc.org/hmp/, https://portal.hmpdacc.org/ - data portal. [Files to download](https://portal.hmpdacc.org/search/f?filters=%7B%22op%22:%22and%22,%22content%22:%5B%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22cases.study_name%22,%22value%22:%5B%22MOMS-PI%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_format%22,%22value%22:%5B%22Biological%20Observation%20Matrix%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_matrix_type%22,%22value%22:%5B%2216s_community%22%5D%7D%7D%5D%7D&facetTab=files&pagination=%7B%22files%22:%7B%22from%22:0,%22size%22:20,%22sort%22:%22file_name.raw:asc%22%7D%7D)
    - dbGAP controlled access: [phs001523.v1.p1](https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=phs001523.v1.p1#authorized-requests-section)
- https://bioconductor.org/packages/release/data/experiment/html/HMP16SData.html - Bioconductor version of HMP16SData
- https://github.com/waldronlab/HMP16SData - code for the HMP16SData package
- https://github.com/biocore/American-Gut - American Gut open-access data and IPython notebooks, >400Mb, .biom files
- https://www.bioconductor.org/packages/release/bioc/html/biomformat.html - package to read .biom files
