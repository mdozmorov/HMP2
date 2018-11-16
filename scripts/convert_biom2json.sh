#!/bin/bash
#PBS -V
#PBS -l nodes=1:ppn=2
#PBS -l mem=8000MB
#PBS -M mdozmorov@vcu.edu
#PBS -N biom2json
#PBS -j oe

cd $PBS_O_WORKDIR

# Go to the folder with .biom files
# Make sure QIIME is installed, http://qiime.org/install/install.html
export PATH=/home/mdozmorov/miniconda2/bin:$PATH
# Activate qiime environment `source activate qiime1`
source activate qiime1
# Run actual conversion
for file in *.biom; do biom convert -i $file -o test.biom  --table-type="OTU table" --to-json && mv test.biom $file; done
# Deactivate qiime environment `source deactivate`
source deactivate
