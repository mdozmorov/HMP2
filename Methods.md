# Methods

All publicly available data were downloaded from the Human Microbiome Project Data Portal (https://portal.hmpdacc.org/) on 11/09/2018. Specifically, "Project: Integrative Human Microbiome Project" was selected, followed by the selection of the study ("MOMS-PI" - Multi-Omics Microbiome Study - Pregnancy Initiative, "IBDMBD" - Inflammatory Bowel Disease Multi-Omics Data, "T2D" - Type 2 Diabetes Mellitus). Subsequent filters were applied to obtain "16s_community" data in the form of BIOM files, "host_cytokine" data in text format, sample annotation files. The data were downloaded using Aspera client v.3.8.1. BIOM files were processed using the `biomformat` v.1.10.0 R package and custom scripts to convert the data into the `phyloseq` object.

## Downloading data https://portal.hmpdacc.org

- Install Aspera client to download files
    - Register your `username` and `password` at https://www.hmpdacc.org/hmp/register/ (approval takes time)
    - Aspera instructions: https://www.hmpdacc.org/hmp/resources/download.php
    - Download `Aspera cli` for your OS from https://downloads.asperasoft.com/en/downloads/62
        - Mac: Download `ibm-aspera-cli-3.9.0.1326.6985b21-mac-10.7-64-release`, `chmod +x`, run it, it will install `ascp` command line tool
        - Per instructions, add Aspera path to `.bash_profile`: `export PATH=/Users/mdozmorov/Applications/Aspera\ CLI/bin:$PATH`; for Linux: `export PATH=/home/mdozmorov/.aspera/cli/bin:$PATH`
    - Clone https://github.com/ihmpdcc/hmp_client, `bin/manifest2ascp.py` from here will be used to create Aspera download script
        - Generic example: `./manifest2ascp.py --manifest=hmp_cart_t2d_june_12_2017.tsv --user=username --password=password --ascp_path=/path/to/ascp/bin/ascp --ascp_options="-l 200M" > ascp-commands.sh`
        - 16S: `./hmp_client/bin/manifest2ascp.py --manifest=data/hmp_cart_41c0aca569.tsv --user=mdozmorov --password=FNEMHgvf --ascp_path=/Users/mdozmorov/Applications/Aspera\ CLI/bin/ascp --ascp_options="-l 200M" > ascp-commands_biom_16S.sh`; for Linux `python2 hmp_client/bin/manifest2ascp.py --manifest=data/hmp_cart_41c0aca569.tsv --user=mdozmorov --password=FNEMHgvf --ascp_path=/home/mdozmorov/.aspera/cli/bin/ascp --ascp_options="-l 200M" > ascp-commands_biom_16S.sh`
            - In `ascp-commands_biom_16S`, replace `Aspera CLI` to `Aspera\ CLI`
            - `chmod +x ascp-commands_biom_16S.sh` and `./ascp-commands_biom_16S.sh` will download files into `ptb` folder. 11/09/2018
       - host_cytokine: `./hmp_client/bin/manifest2ascp.py --manifest=data/hmp_cart_b10350603.tsv --user=mdozmorov --password=FNEMHgvf --ascp_path=/Users/mdozmorov/Applications/Aspera\ CLI/bin/ascp --ascp_options="-l 200M" > ascp-commands_biom_host_cytokine.sh`


## T2D notes

- https://portal.hmpdacc.org, select "Data", Samples/Projects: "Integrative Human Microbiome Project", Samples/Studies: "T2D"
- Files/Matrix Type: "16s_community" selects 1,418 `.biom` files
- Files/Matrix Type: "wgs_community", "host_cytokine", "host_transcriptome", "microb_metatranscriptome" - not available
- Files/Format: "FASTQ" - 6,208 files
- Files/Format: "raw" - 6,161 files

## IBDMBD notes

- https://portal.hmpdacc.org, select "Data", Samples/Projects: "Integrative Human Microbiome Project", Samples/Studies: "IBDMBD"
- Files/Matrix Type: "16s_community" selects 86 `.biom` files. But Files/Format: "Biological Observation Matrix" (also, Files/Type: "abundance_matrix") selects 1,466 `.biom` files
- Files/Matrix Type: "wgs_community" selects 1,380 `.biom` files. 
- Files/Type: "wgs_raw_seq_set" selects 1,388 `.tar` files
- Files/Matrix Type: "host_cytokine", "host_transcriptome", "microb_metatranscriptome" - not available
- Files/Format: "FASTQ" - 2,686 files
- Files/Format: "raw" - 6,161 files
