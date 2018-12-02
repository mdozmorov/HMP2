# 16S rRNA Sequencing Data from the HMP2 project

* [Files](#files)
* [URLs](#urls)
  * [Data](#data)
  * [Software](#software)


## Files

- `EDA_iHMP2_Broad.Rmd` - Exploratory data analysis of Broad's HMP2 data, self-contained download and analysis. https://ibdmdb.org/tunnel/public/summary.html - iHMP2 data from Broad. 11/24/2018

- `EDA_MOMS-PI.Rmd` - Exploratory data analysis of MOMS-PI data, http://vmc.vcu.edu/resources/momspi - MOMS-PI proof of principle datasets, files downloaded with `scripts/download_moms-pi.sh`, [POP1 Dataset](http://vmc.vcu.edu/static/downloads/MOMS-PI_POP1.zip), 11/05/2018

- `EDA_biom.Rmd` - Exploratory data analysis of `.biom` files downloaded with `scripts/ascp-commands.sh` from https://portal.hmpdacc.org/ - data portal. [Files to download](https://portal.hmpdacc.org/search/f?filters=%7B%22op%22:%22and%22,%22content%22:%5B%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22cases.study_name%22,%22value%22:%5B%22MOMS-PI%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_format%22,%22value%22:%5B%22Biological%20Observation%20Matrix%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_matrix_type%22,%22value%22:%5B%2216s_community%22%5D%7D%7D%5D%7D&facetTab=files&pagination=%7B%22files%22:%7B%22from%22:0,%22size%22:20,%22sort%22:%22file_name.raw:asc%22%7D%7D), 11/09/2018

- `Methods.md` - Methods notes
- `ToDo.md` - current todos

- `data`
    - `biom_nonreadable.tsv` - 62 nonreadable `.biom` files, created in `EDA_biom.Rmd::problemFiles`
    - `hmp_cart_1c572b0ab.tsv` - manifest for first three files
    - `hmp_cart_metadata_b53a6441a.tsv` - metadata for first three files
    - `hmp_cart_41c0aca569.tsv` - manifest for all 9,170 files, 11/09/2018
    - `hmp_cart_metadata_26015b0c41.tsv` - metadata for all 9,170 files, 11/09/2018
    - `downloaded_ascp.txt` - list of 9,170 files downloaded with `ascp-commands.sh`, 11/09/2018

- `scripts`
    - `convert_biom2json.sh` - convert biom files to json format. Not working on "merlot" cluster
    - `download_moms-pi.sh` - download MOMS-PI data from http://vmc.vcu.edu/resources/momspi
    - `ascp-commands.sh` - download `.biom`files from https://portal.hmpdacc.org, creates `ptb` folder, 11/09/2018
    - `ascp-commands_biom_nonreadable.sh` - download nonreadable `.biom` files, listed in `data/biom_nonreadable.tsv`

## URLs

### Data

- dbGAP controlled access for HMP2: [phs001523.v1.p1](https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=phs001523.v1.p1#authorized-requests-section).
- http://hmp2-data.stanford.edu/ - iHMP2 Prediabetic Data from Stanford. Mixture of raw and processed sample data. No description, data selection seem random. Not analyzed.

### Software

- https://bioconductor.org/packages/release/data/experiment/html/HMP16SData.html - Bioconductor version of HMP16SData
- https://github.com/waldronlab/HMP16SData - code for the HMP16SData package
- https://github.com/biocore/American-Gut - American Gut open-access data and IPython notebooks, >400Mb, .biom files
- https://www.bioconductor.org/packages/release/bioc/html/biomformat.html - package to read .biom files
- QIIME installation, http://qiime.org/install/install.html

### Misc

- BioC 2019: Where Software and Biology Connect, call for abstract. http://bioc2019.bioconductor.org/call-for-abstracts