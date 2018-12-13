# Data download

## Downloading data https://portal.hmpdacc.org

- Install Aspera client to download files
    - Register your `username` and `password` at https://www.hmpdacc.org/hmp/register/ (approval takes time)
    - Download `Aspera cli` for your OS from https://downloads.asperasoft.com/en/downloads/62
        - Mac: Download `ibm-aspera-cli-3.9.0.1326.6985b21-mac-10.7-64-release`, `chmod +x`, run it, it will install `ascp` command line tool
        - Per instructions, add Aspera path to `.bash_profile`: `export PATH=/Users/mdozmorov/Applications/Aspera\ CLI/bin:$PATH`; for Linux: `export PATH=/home/mdozmorov/.aspera/cli/bin:$PATH`
    - Clone https://github.com/ihmpdcc/hmp_client, `bin/manifest2ascp.py` from here will be used to create Aspera download script
        - Generic example: `./manifest2ascp.py --manifest=hmp_cart_t2d_june_12_2017.tsv --user=username --password=password --ascp_path=/path/to/ascp/bin/ascp --ascp_options="-l 200M" > ascp-commands.sh`
        - Real example: `./hmp_client/bin/manifest2ascp.py --manifest=data/hmp_cart_41c0aca569.tsv --user=mdozmorov --password=FNEMHgvf --ascp_path=/Users/mdozmorov/Applications/Aspera\ CLI/bin/ascp --ascp_options="-l 200M" > ascp-commands.sh`; for Linux `python2 hmp_client/bin/manifest2ascp.py --manifest=data/hmp_cart_41c0aca569.tsv --user=mdozmorov --password=FNEMHgvf --ascp_path=/home/mdozmorov/.aspera/cli/bin/ascp --ascp_options="-l 200M" > ascp-commands.sh`
            - In `ascp-commands.sh`, replace `Aspera CLI` to `Aspera\ CLI`
            - `chmod +x ascp-commands.sh` and `./ascp-commands.sh` will download files into `ptb` folder. 11/09/2018
    - Aspera instructions: https://www.hmpdacc.org/hmp/resources/download.php



