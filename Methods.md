# Data download

## https://portal.hmpdacc.org

- Install Aspera client to download files
    - Register your `username` and `password` at https://www.hmpdacc.org/hmp/register/ (approval takes time)
    - Download `Aspera cli` for your OS from https://downloads.asperasoft.com/en/downloads/62
        - Mac: Download `ibm-aspera-cli-3.9.0.1326.6985b21-mac-10.7-64-release`, `chmod +x`, run it, it will install `ascp` command line tool
        - Per instructions, add Aspera path to `.bash_profile`: `export PATH=/Users/mdozmorov/Applications/Aspera\ CLI/bin:$PATH`
    - Clone https://github.com/ihmpdcc/hmp_client, `bin/manifest2ascp.py` from here will be used to create Aspera download script
        - Generic example: `./manifest2ascp.py --manifest=hmp_cart_t2d_june_12_2017.tsv --user=username --password=password --ascp_path=/path/to/ascp/bin/ascp --ascp_options="-l 200M" > ascp-commands.sh`
        - Real example: `./hmp_client/bin/manifest2ascp.py --manifest=data/hmp_cart_41c0aca569.tsv --user=mdozmorov --password=FNEMHgvf --ascp_path=/Users/mdozmorov/Applications/Aspera\ CLI/bin/ascp --ascp_options="-l 200M" > ascp-commands.sh`
            - In `ascp-commands.sh`, replace `Aspera CLI` to `Aspera\ CLI`
            - `chmod +x ascp-commands.sh` and `./ascp-commands.sh` will download files into `ptb` folder. 11/09/2018
    - Aspera instructions: https://www.hmpdacc.org/hmp/resources/download.php


- Add first three files to cart, download their Manifest and metadata. [Files to download](https://portal.hmpdacc.org/search/f?filters=%7B%22op%22:%22and%22,%22content%22:%5B%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22cases.study_name%22,%22value%22:%5B%22MOMS-PI%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_format%22,%22value%22:%5B%22Biological%20Observation%20Matrix%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_matrix_type%22,%22value%22:%5B%2216s_community%22%5D%7D%7D%5D%7D&facetTab=files&pagination=%7B%22files%22:%7B%22from%22:0,%22size%22:20,%22sort%22:%22file_name.raw:asc%22%7D%7D)
    - `data/hmp_cart_1c572b0ab.tsv` - manifest for first three files
    - `data/hmp_cart_metadata_b53a6441a.tsv` - metadata for first three files
