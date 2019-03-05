# ToDo

- For 16S, Project Name IS Integrative Human Microbiome Project  AND Study Name IS MOMS-PI  AND File Format IS Biological Observation Matrix  AND File Matrix Type IS 16s_community. 
    - https://portal.hmpdacc.org/search/f?filters=%7B%22op%22:%22and%22,%22content%22:%5B%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22cases.study_name%22,%22value%22:%5B%22MOMS-PI%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22cases.project_name%22,%22value%22:%5B%22Integrative%20Human%20Microbiome%20Project%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_format%22,%22value%22:%5B%22Biological%20Observation%20Matrix%22%5D%7D%7D,%7B%22op%22:%22in%22,%22content%22:%7B%22field%22:%22files.file_matrix_type%22,%22value%22:%5B%2216s_community%22%5D%7D%7D%5D%7D&facetTab=files&pagination=%7B%22files%22:%"7B%22from%22:0,%22size%22:20,%22sort%22:%22file_name.raw:asc%22%7D%7D
    - What is "Type"? It has "abundance_matrix" entry, selects

- IBD data has non-Greengenes IDs, like "IP8BSoli" "UncTepi3" "Unc004ii" "Unc00re8" "Unc018j2" "Unc04u81" "Unc58370" "Unc05fip". What are they?

- For cytokine data, what is the difference between "Type:cytokine" (all files are 0 size and have "empty suffix") and "Matrix Type:host_cytokine"?

- Would we use "Matrix Type:wgs_community", Metaphlan2 analysis? "microb_metatranscriptome"?  What is the difference between the two?

- "host_lipidomic"? 


- For cytokines, "Recode "OOR <" and "OOR >" as -2 and -1" - add to documentation

## Compositional data analysis

- `ALDEx2` R package - a compositional data analysis tool that uses Bayesian methods to infer technical and statistical errors. Works with RNA-seq, microbiome, and other compositional data. Distinction between absolute counts and compositional data. Counts are converted to probabilities by Monte Carlo sampling (128 by default) from the Dirichlet distribution with a uniform prior. Centered log-ratio transformation, clr - divide by the geometric mean. https://bioconductor.org/packages/release/bioc/html/ALDEx2.html
    - Fernandes, Andrew D., Jennifer Ns Reid, Jean M. Macklaim, Thomas A. McMurrough, David R. Edgell, and Gregory B. Gloor. “Unifying the Analysis of High-Throughput Sequencing Datasets: Characterizing RNA-Seq, 16S RRNA Gene Sequencing and Selective Growth Experiments by Compositional Data Analysis.” Microbiome 2 (2014): 15. https://doi.org/10.1186/2049-2618-2-15.