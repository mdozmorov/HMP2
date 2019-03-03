# 16S rRNA Sequencing Data from the HMP2 project

* [Files](#files)
* [URLs](#urls)
  * [Data](#data)
  * [Software](#software)


## Files

- `Methods.md` - Methods notes
- `ToDo.md` - current todos

### 16S

- [Samples/Studies: MOMS-PI, Files/Format: "Biological Observation Matrix", Files/Matrix Type: "16s_community" - selects 9170 files](https://portal.hmpdacc.org/search/f?filters=%7B%22op%22:%22and%22,%22content%22:%5B%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22cases.study_name%22,%22value%22:%5B%22MOMS-PI%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_format%22,%22value%22:%5B%22Biological%20Observation%20Matrix%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_matrix_type%22,%22value%22:%5B%2216s_community%22%5D%7D%7D%5D%7D&facetTab=files&pagination=%7B%22files%22:%7B%22from%22:0,%22size%22:20,%22sort%22:%22file_name.raw:asc%22%7D%7D), Downloaded 11/09/2018

- `preprocess_biom_16S.Rmd` - extracting data from `.biom` files downloaded with `scripts/ascp-commands_16S.sh` from https://portal.hmpdacc.org/. Outputs `mtx_biom_data_all_ID_merged.xlsx`

- `EDA_biom_16S.Rmd` - Exploratory data analysis of `.biom` files. Uses `mtx_biom_data_all_ID_merged.xlsx`. Creates R object `data/hmp2_biom_16S_momspi.rda` containing `mtx_biom_data` count object and `mtx_metadata` annotation object

- `preprocess_phyloseq_16S.Rmd` - Creates phyloseq object from `data/hmp2_biom_16S_momspi.rda` and saves it to `data/hmp2_phyloseq_16S_momspi.rda` containing `mtx_phyloseq_16S` phyloseq object

- `Analysis_biom_16S.Rmd` - Loads `mtx_phyloseq_16S` phyloseq object from `data/hmp2_phyloseq_16S_momspi.rda`

- `read_ibd_t2d_biom.rda` - Make phyloseq objects for T2D and IBD data from biom files

- `preprocess_T2D_16S.Rmd` - HMP2Data T2D BIOM processing

## host_cytokine

- [Samples/Studies: MOMS-PI, Files/Matrix Type: "host_cytokine" - selects 872 files](https://portal.hmpdacc.org/search/f?filters=%7B%22op%22:%22and%22,%22content%22:%5B%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22cases.study_name%22,%22value%22:%5B%22MOMS-PI%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_matrix_type%22,%22value%22:%5B%22host_cytokine%22%5D%7D%7D%5D%7D&facetTab=files&pagination=%7B%22files%22:%7B%22from%22:0,%22size%22:20,%22sort%22:%22file_name.raw:asc%22%7D%7D), Downloaded 11/09/2018

- `preprocess_biom_cytokines.Rmd` - extracting data from cytokine files downloaded with `scripts/ascp-commands_cytokines.sh` from https://portal.hmpdacc.org/. Outputs `mtx_cytokine_data_all_ID_merged.xlsx`

- `EDA_cytokines.Rmd` - Exploratory data analysis of cytokine files. Uses `mtx_cytokine_data_all_ID_merged.xlsx`. Creates R object `data/hmp2_cytokine_momspi.rda` containing `mtx_cytokine_data` count object and `mtx_metadata` annotation object

## Misc

- `EDA_iHMP2_Broad.Rmd` - Exploratory data analysis of Broad's HMP2 data, self-contained download and analysis. https://ibdmdb.org/tunnel/public/summary.html - iHMP2 data from Broad. 11/24/2018

- `EDA_MOMS-PI.Rmd` - Exploratory data analysis of MOMS-PI data, http://vmc.vcu.edu/resources/momspi - MOMS-PI proof of principle datasets, files downloaded with `scripts/download_moms-pi.sh`, [POP1 Dataset](http://vmc.vcu.edu/static/downloads/MOMS-PI_POP1.zip), 11/05/2018


- `Analysis`
    - `EDA_biom_16S_122118.Rmd` - Analysis of the original `phyloseq` object from `hmp2_phyloseq_16S_momspi_KS.rda` with NAs replaced by zeros. ES, 12-21-2018.
    - `EDA_biom_16S_122123.Rmd` - Analysis of the `hmp2_phyloseq_16S_momspi.rda` `phyloseq` object created 12-23-2018 by `preprocess_phyloseq_16S.Rmd`, NAs replaced by zeros. Summarized the data by genus and saves it as `hmp2_phyloseq_16S_momspi_genus.rda` object. MD, 12-23-2018.

- `data`
    - `gg_13_5_taxonomy.txt.gz` - Greengenes taxonomy, downloaded from http://greengenes.secondgenome.com/downloads/database/13_5, 03-02-2019
    - `biom_nonreadable.tsv` - 63 nonreadable `.biom` files, created in `preprocess_biom_16S.Rmd::problemFiles`
    - `downloaded_ascp.txt` - list of files downloaded with `ascp-commands_biom_16S.sh`, 11/09/2018

    - `hmp_cart_b10350603.tsv` - manifest for all 872 cytokine `.txt` files, 12/13/2018
    - `hmp_cart_metadata_1e3cf1e9c1.tsv` - metadata for all 872 cytokine `.txt` files, 12/13/2018
    - `hmp2_phyloseq_16s_T2D.rda` - phyloseq object for T2D data
    - `hmp2_phyloseq_16s_ibd.rda` - phyloseq object for IBD data

- `data.MOMS-PI`
    - `ascp-commands_biom_16S_MOMS-PI.sh` - download 9170 16S BIOM files, Project Name IS Integrative Human Microbiome Project  AND Study Name IS IBDMDB  AND File Format IS Biological Observation Matrix  AND File Matrix Type IS 16s_community, 03-02-2019
    - `hmp_cart_16d395b515.tsv` - manifest, 03-0e-2019
    - `hmp_cart_metadata_4568fb1008.tsv` - metadata, 03-03-2019

- `data.T2D`
    - `ascp-commands_biom_16S_T2D.sh` - download 2308 16S BIOM files, Project Name IS Integrative Human Microbiome Project  AND Study Name IS IBDMDB  AND File Format IS Biological Observation Matrix  AND File Matrix Type IS 16s_community, 03-02-2019
    - `hmp_cart_9df8de87d3.tsv` - manifest, 03-03-2019
    - `hmp_cart_metadata_44df19f9ef.tsv` - metadata, 03-03-2019

- `data.IBD`
    - `ascp-commands_biom_16S_IBD.sh` - download 572 16S BIOM files, Project Name IS Integrative Human Microbiome Project  AND Study Name IS IBDMDB  AND File Format IS Biological Observation Matrix  AND File Matrix Type IS 16s_community, 03-03-2019
    - `hmp_cart_2246151709.tsv` - manifest, 03-03-2019
    - `hmp_cart_metadata_14ca36907.tsv`- metadata, 03-03-2019
    - `hmp_cart_2bcd863c2e.tsv` - manifest, 12-25-2018
    - `hmp_cart_metadata_35c73e52bd.tsv` - metadata, 12-25-2018

- `scripts`
    - `greengenes.R` - process `data/gg_13_5_taxonomy.txt.gz` into `mtx_tax_table` object. 03-02-2019
    - `ascp-commands_biom_16S.sh` - download 16S `.biom` files into `ptb` folder, 11/09/2018
    - `ascp-commands_biom_16S_nonreadable.sh` - download nonreadable `.biom` files, listed in `data/biom_nonreadable.tsv`
    
    - `ascp-commands_biom_host_cytokine.sh` - download host_cytokine `.txt` files into `ptb` folder, 12/13/2018
    
    - `convert_biom2json.sh` - convert biom files to json format. Not working on "merlot" cluster
    - `download_moms-pi.sh` - download MOMS-PI data from http://vmc.vcu.edu/resources/momspi
    - `phyloseq_analysis.R` - phyloseq analysis vignette code
    - `EDA_Greengenes.Rmd` - Associating biom IDs with Greengene taxonomy
    - `EDA_manifests.R` - Testing for overlap among samples from MOMS-PI, T2D, and IBD studies - none.

## URLs

### Data

- dbGAP controlled access for HMP2: [phs001523.v1.p1](https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=phs001523.v1.p1#authorized-requests-section).
    - Curtis Huttenhower: BioProject PRJNA476195, dbGaP phs001626. A manuscript with methods description, "Multi'omics Detail the Gut Microbial Ecosystem in 2 Inflammatory Bowel Disease", [Dropbox download link](https://www.dropbox.com/s/nhloprbetszkda5/322196_1_merged_1536386292.pdf?dl=0). Questions about data to be addressed to Cesar Arze, carze@hsph.harvard.edu
- http://hmp2-data.stanford.edu/ - iHMP2 Prediabetic Data from Stanford. Mixture of raw and processed sample data. No description, data selection seem random. Not analyzed.
- Human Microbiome Data in phyloseq format, http://joey711.github.io/phyloseq-demo/HMP_import_example.html
- https://www.dropbox.com/sh/omnsii1km3nwycs/AABbDRYsyGEZzQEeVO6fdYj7a?dl=0

### Software

- https://bioconductor.org/packages/release/data/experiment/html/HMP16SData.html - Bioconductor version of HMP16SData
- https://github.com/waldronlab/HMP16SData - code for the HMP16SData package
- https://github.com/biocore/American-Gut - American Gut open-access data and IPython notebooks, >400Mb, .biom files
- https://www.bioconductor.org/packages/release/bioc/html/biomformat.html - package to read .biom files
- QIIME installation, http://qiime.org/install/install.html

### Misc

- BioC 2019: Where Software and Biology Connect, call for abstract. http://bioc2019.bioconductor.org/call-for-abstracts

## Papers

- Schiffer, Lucas, Rimsha Azhar, Lori Shepherd, Marcel Ramos, Ludwig Geistlinger, Curtis Huttenhower, Jennifer B Dowd, Nicola Segata, and Levi Waldron. “HMP16SData: Efficient Access to the Human Microbiome Project through Bioconductor,” August 29, 2018. https://doi.org/10.1101/299115. - HMP16SData - SummarizedExperiment of 16S sequencing data (counts) for V13 and V35 variable regions with clinical annotations (visit number, sex, run center, body site, and body subsite) and an option to attach controlled access clinical annotations. Compatible with phyloseq. https://bioconductor.org/packages/release/data/experiment/html/HMP16SData.html

- Griffith, Jocelyn C, and Xochitl C Morgan. “Invited Commentary: Improving Accessibility of the Human Microbiome Project Data through Integration with R/Bioconductor.” American Journal of Epidemiology, January 10, 2019. https://doi.org/10.1093/aje/kwz007. - Commentary to the HMP16Sdata package. Challenges in data processing and analysis, sparsity, normalization, batch effect.


