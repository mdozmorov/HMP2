# ToDo

- IBD data has non-Greengenes IDs, like "IP8BSoli" "UncTepi3" "Unc004ii" "Unc00re8" "Unc018j2" "Unc04u81" "Unc58370" "Unc05fip". What are they?

- For cytokines, "Recode "OOR <" and "OOR >" as -2 and -1" - add to documentation

## Compositional data analysis

- `ALDEx2` R package - a compositional data analysis tool that uses Bayesian methods to infer technical and statistical errors. Works with RNA-seq, microbiome, and other compositional data. Distinction between absolute counts and compositional data. Counts are converted to probabilities by Monte Carlo sampling (128 by default) from the Dirichlet distribution with a uniform prior. Centered log-ratio transformation, clr - divide by the geometric mean. https://bioconductor.org/packages/release/bioc/html/ALDEx2.html
    - Fernandes, Andrew D., Jennifer Ns Reid, Jean M. Macklaim, Thomas A. McMurrough, David R. Edgell, and Gregory B. Gloor. “Unifying the Analysis of High-Throughput Sequencing Datasets: Characterizing RNA-Seq, 16S RRNA Gene Sequencing and Selective Growth Experiments by Compositional Data Analysis.” Microbiome 2 (2014): 15. https://doi.org/10.1186/2049-2618-2-15.