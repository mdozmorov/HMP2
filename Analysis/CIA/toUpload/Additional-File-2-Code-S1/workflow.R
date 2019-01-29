organizeCovariateColumns <- function(inputMatrix, covarColNums, covarColNames, doRenumber, doRename) {
  
  cnLen<-length(covarColNames)
  inputMatrix<-as.data.frame(inputMatrix)
  # does the column renaming and rearrangement
  if (doRenumber) {
    inputMatrix <- cbind(inputMatrix[, covarColNums], inputMatrix[, -covarColNums]) }
  if (doRename) {
    covDat<-as.data.frame(inputMatrix[, 1:cnLen])
    colnames(covDat) <- covarColNames
    inputMatrix<-data.frame(covDat, (inputMatrix[, -(1:cnLen)]))}
  return(inputMatrix)
}

# numCov is the number of covariates; 
# dataSet is the ade4 output you are working with. It has k covariates and some number of taxa
# the program assumes that dataSet has column and row names
# out is the mapping file

mapFiler<-function(numCov, dataSet, fileName){

  # only printing covars
  dataSet = dataSet[,1:numCov]

  #unfactorize
  for (i in 1:numCov) {
    dataSet[,i] = as.character(unlist(dataSet[,i]))
  }
  
  rowCount = length(dataSet[,1])
  dataSet$SampID = seq(1, rowCount)
  numCov = numCov + 1
  
  SID<-as.vector(row.names(dataSet)) #get rownames

  # do column header 
  headerRow = paste(c("#SampleID\tBarCodeSequence\tLinkerPrimerSequence", names(dataSet)), collapse="\t")

  fileConn<-file(fileName)
  writeLines(headerRow, fileConn)
  close(fileConn)
  out = rep("", rowCount)
  for (i in 1:rowCount) {
    name = paste(SID[i], "\t \t \t", sep="")
    covars = paste(dataSet[i,], collapse="\t")
    plus = paste(name, covars, sep="")
    out[i] = plus
  }
  
  write.table(out, file=fileName, append=T, row.names=F, col.names=F, quote=F)
}

ade4ToEmperor <- function(ade4Out, outputF, scaling=NULL, 
                           type = c("samples", "species")){
  
  #Define default scalings
  if(is.null(scaling)){
    if (type == "samples") {scaling <- "l1"}
    else if (type == "species"){scaling <- "co"} 
  }

  if (type == "samples"){ 
      if(scaling == "li") {tableF = ade4Out$li}
      else  {tableF = ade4Out$l1}
  }
  
  if (type == "species"){
      if(scaling == "c1") {tableF = ade4Out$c1}
      else  {tableF = ade4Out$co}
  }

  #define SVD outputs
  eigF = ade4Out$eig   
  eigPF = eigF/sum(eigF)
  
  #Check number of eigenvectors agree in eigF, eigPF, tableF
  N_F <- length(eigF)
  N_PF <- length(eigPF)
  N_tableF <- dim(tableF)[2]
  
  #Keep the smallest number of eigenvalues in analysis
  Nkeep <- min(N_F, N_PF, N_tableF)
  
  #Format eigenvalues
  eigF <- eigF[1:Nkeep]
  E2 <- matrix(eigF,  dimnames = NULL) #remove headers
  nColE<-dim(E2)[1]  #ncols 
  E2<-rbind(E2, "\n")
  E3<-toString(E2) #makes a string object
  E4<-gsub(",", "\t", E3) #removes all commas and replaces them with tabs
  E5<-gsub(" ", "", E4) #removes any space
  E6<-gsub("\t\n", "\n", E5) 
  
  # 2) handles proportions file
  #EigProp <- read.csv(eigPF)
  #EP1 <- as.matrix(EigProp[-1])  #Test is a data frame-> matrix and remove index
  #EP2 <- matrix(EP1, dimnames = NULL) #remove headers
  eigPF <- eigPF[1:Nkeep]
  EP2 <- matrix(eigPF, dimnames = NULL) #remove headers
  nColEP<-dim(EP2)[1]  #ncols 
  EP2<-rbind(EP2, "\n")
  EP3<-toString(EP2) #makes a string object
  EP4<-gsub(",", "\t", EP3) #removes all commas and replaces them with tabs
  EP5<-gsub(" ", "", EP4) #removes any space
  EP6<-gsub("\t\n", "\n", EP5) 
  
  # 3) handles table file
  #Table <- read.csv(tableF)
  #P1 <- as.matrix(Table)  #Table is a data frame
  tableF <- tableF[,1:Nkeep]
  Table <- cbind(rownames(tableF), tableF)
  #P1 <- as.matrix(tableF)  #Table is a data frame
  #P2 <- matrix(P1, ncol = ncol(P1), dimnames = NULL) #remove headers
  P2 <- Table
  nRow<-dim(P2)[1]  #nrows need this later
  nCol<-dim(P2)[2]-1  #ncols need this later
  NL<-rep("\n", nRow) #each row must end in "new line" 
  P3<-cbind(P2, NL) #data frame with newline at end or each row
  P3<-t(P3) #preparation for string 
  P4<-toString(P3) #makes a string object
  P5<-gsub(",", "\t", P4) #removes all commas and replaces them with tabs
  P6<-gsub(" ", "", P5) #removes any space
  P7<-gsub("\t\n\t", "\n", P6) 
  P8<-gsub("\t\n", "\n", P7) 
  
  # 4) creates formatted output file
  sink(outputF)
  cat("Eigvals\t"); cat(nColE); cat("\n")
  cat(E6);cat("\n")
  cat("Proportion explained\t"); cat(nColEP); cat("\n")
  cat(EP6); cat("\n")
  cat("Species\t"); cat("0\t"); cat("0\n")
  cat("\n");
  cat("Site\t"); cat(nRow); cat("\t"); cat(nCol); cat("\n")
  cat(P8); cat("\n")
  cat("Biplot\t"); cat("0\t"); cat("0\n")
  cat("\n");
  cat("Site constraints\t"); cat("0\t"); cat("0\n")
  sink()  
}

createSpeciesMappingFile <- function(taxaInfo, fileName) {
  #unfactorize
  for (i in 1:ncol(taxaInfo)) {
   taxaInfo[,i] = as.character(unlist(taxaInfo[,i]))
  }
  
  # do column header 
  headerRow = paste(c("#SampleID\tBarCodeSequence\tLinkerPrimerSequence", names(taxaInfo)[-1]), collapse="\t")
  

  fileConn<-file(fileName)
  writeLines(headerRow, fileConn)
  close(fileConn)
  taxaInfoPlus = rep("", nrow(taxaInfo))
  for (i in 1:nrow(taxaInfo)) {
    sp_name = paste(taxaInfo[i,1], "\t \t \t", sep="")
    covars = paste(taxaInfo[i,-1], collapse="\t")
    plus = paste(sp_name, covars, sep="")
    taxaInfoPlus[i] = plus
  }
  
  write.table(taxaInfoPlus, file=fileName, append=T, row.names=F, col.names=F, quote=F)
}


# The function sortAndMapHandsFree takes the data frame (inputMatrix) and the dudi.pca object (ade4Out) and scaling ("li" or "l1").
# It requires file names for the mapping file and eigenvector file outputs.
# The output objects are for use in Emperor.
# It is not interactive.  In addition to the data frame and dudi.pca object, it also requires 
#   the locations of the columns of the covariates : e.g.  covarColNums=c(1, 3, 8)
#   the names of the covariates: e.g. covarColNames=c("cov1", "cov2", "cov3") (default assumes they're already named)
# The default scaling for samples is "l1".  An alternative choice is "li".
# The default scaling for species is "co".  An alternative choice is "c1".

sortAndMapHandsFree <- function(inputMatrix, covarColNums = 0, 
                      covarColNames = c(), ade4Out, eigenScaling=NULL,
                      type = c("species", "samples"), 
                      mappingFile, eigenFile, 
                      filteredTaxa=NULL,biplotFile=NULL) {
  
  if (type == "samples") {
   doRename = (length(covarColNames > 0))
   doRenumber = ! all(covarColNums == seq(1, max(covarColNums)))
   organized <- organizeCovariateColumns(inputMatrix, covarColNums, covarColNames, doRenumber, doRename)
   reorderedList = list(numberOfCovariates=length(covarColNums), orderedData=organized)
   mapFiler(reorderedList$numberOfCovariates, reorderedList$orderedData, mappingFile)
   ade4ToEmperor(ade4Out, eigenFile, eigenScaling, type)
   if (! is.null(filteredTaxa )) {
     makeBiPlotFile(filteredTaxa,biplotFile)
   }
  }
  else {
   createSpeciesMappingFile(inputMatrix, mappingFile)
   ade4ToEmperor(ade4Out, eigenFile, eigenScaling, type)
  }
  
  
  #Error check for sample names matching dudi output
  if (type == "samples"){
    if (! all(rownames(inputMatrix) == rownames(ade4Out$tab))) {
      print("Mismatched rownames in inputMatrix and ade4Out$tab.  You must fix this in order for the output to work in Emperor!")
    }
  }
}

makeBiPlotFile <- function(filteredTaxa,biplotFile) {
  filteredTaxa = t(filteredTaxa)
  topRow = c("# Constructed from OTU file")
  headerRow = c("#OTU ID", colnames(filteredTaxa))
  tworows = paste(topRow, paste(headerRow, collapse="\t"), sep="\n")
  
  fileConn<-file(biplotFile)
  writeLines(tworows, fileConn)
  close(fileConn)
  
  colnames(filteredTaxa) <- NULL
  
  batch1 = filteredTaxa[-nrow(filteredTaxa),]
  batch2 = tail(filteredTaxa, 1)
  
  write.table(batch1, biplotFile, append = TRUE, quote = FALSE, sep = "\t",
              eol = "\n", na = "NA", dec = ".", row.names = TRUE,
              col.names = FALSE)  
  
  write.table(batch2, biplotFile, append = TRUE, quote = FALSE, sep = "\t",
              eol = "", na = "NA", dec = ".", row.names = TRUE,
              col.names = FALSE)  
  
}
