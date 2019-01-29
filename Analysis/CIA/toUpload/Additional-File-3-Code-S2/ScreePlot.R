#setwd("~/Work/MicroBiome/Normalization/Code")

# screePlot makes plot of ordered eigenvalues to show percent of variance explained
# by the variables.  
# Inputs: 
#   First.pca is an ade4 ordination object
#   breaks is a vector of breakpoints (in percents (0, 100)) for the screeplot that 
#   define intervals showing percent of variance explained.  The largest percent 
#   entered in the vector will be considered the percent greater than which no 
#   further cumulative variance will be calculated for the eigen values.  Example of 
#   vector: c(25, 50, 75, 95)
#   mainTitle is optional text which will be appended to the title text which describes 
#   the percent of variance explained.  Example: "Covariance PCA"

screePlot = function(First.pca, breaks, mainTitle=NULL) {
  library(Hmisc) # for all.is.numeric
  library(ggplot2) # for plotting
  
  isNum<-all.is.numeric(breaks) #tests that the elements are all numeric
  uBreaks<-unique(breaks) # removes duplicates
  uBLength<-length(uBreaks)  # vector length without duplicates
  orderedBreaks<-sort(uBreaks) # orders the regions
  
  outRange<-length(uBreaks[uBreaks > 100]) + length(uBreaks[uBreaks <= 0]) #checks that the values are between zero and 100
  inrange<-(1-outRange>0)
  
  if (!isNum | !inrange ){
    stop("There's something wrong with the vector of values you entered.")
  } 
  
  numBreaks = length(orderedBreaks)
  eigenVariance <- 100 * First.pca$eig/sum(First.pca$eig)
  cumulativeVariance <- cumsum(eigenVariance)
  threshold = max(orderedBreaks)
  cutoffIndex = which(cumulativeVariance == threshold)
  if (length(cutoffIndex) == 0) {
    cutoffIndex <- min(which(cumulativeVariance > threshold))
  } 
  cumulativeVarianceKeep <- cumulativeVariance[1:cutoffIndex]
  
  Ind <- which(orderedBreaks < cumulativeVarianceKeep[1])
  if (length(Ind)>0 ){
    orderedBreaks <- orderedBreaks[-Ind]
  }
  
  VarExplained <- rep(0, cutoffIndex)
  VarExplained[which(cumulativeVarianceKeep < orderedBreaks[1])] <- paste("Less than ", orderedBreaks[1], "%", sep="")
  
  nb<-numBreaks - 2
  for (i in 1:nb){
    a<-orderedBreaks[i]
    b<-orderedBreaks[i+1]  
    VarExplained[which((cumulativeVarianceKeep >=a) & (cumulativeVarianceKeep < b))] <- paste(a, "%",  " to <", b, "%", sep="")
  }
  
  VarExplained[which(cumulativeVarianceKeep >= orderedBreaks[nb+1])] <- paste(orderedBreaks[nb+1], "% to ", threshold,"%", sep="")
  
  VarExplained <- factor(VarExplained, levels = unique(VarExplained))

  # number of eigenvalue per bin
  x_Breaks <- c(cumsum(table(VarExplained)))
  x_Labels <- c(as.character(cumsum(table(VarExplained))))
  
  plot_colors <- rainbow(numBreaks)
  df <- data.frame(1:cutoffIndex, First.pca$eig[1:cutoffIndex], cumulativeVarianceKeep, VarExplained) 
  names(df) <- c("Rank",  "Value", "CumulativePercent", "VarExplained")
  if (is.null(mainTitle)) {
    mainTitle = ""
  }
  else {
    mainTitle = paste(mainTitle,"\n", sep="")
  }
  mainTitle = paste(mainTitle, "Largest", cutoffIndex, "of", length( First.pca$eig), "Eigenvalues\n Explain ",threshold,"Percent of Total Variance" )
  #Plot Eigenvalues
  p <- ggplot(df, aes(x = Rank, y = Value, fill = VarExplained)) +
    ggtitle(mainTitle) +
    ylab("Eigenvalue") +
    geom_bar(stat = "identity") + theme(panel.grid.minor = element_line(size=0.5))+
    scale_x_continuous("Rank of Eigenvalue",
                       limits = c(0,max(x_Breaks)+1),
                       breaks = x_Breaks, labels = x_Labels ) +
    theme(axis.text.x = element_text( face="italic", size = 12)) +
    scale_fill_manual(name = "Variance Explained",
                      values = plot_colors, breaks=levels(VarExplained)) + theme_bw() + 
    theme( legend.position=c(.8,.7))
    
  return(p)
}  

#Plot ordination using ggplot, inputs ade4 object
PlotPCA <- function(Res.pca, Env_Var=NULL,axes = c(1,2), color=NULL, 
                    shape=NULL, UN= NULL, plot_type = c("species", "samples") ){
  
  percvar <- round((100 * Res.pca$eig/sum(Res.pca$eig))[axes],2)
  
  #Extract  scores data
  if (plot_type == "samples") {
    df <- data.frame(Res.pca$l1[,axes])
  }
  if (plot_type == "species") {
    df <- data.frame(Res.pca$co[,axes])
  }
  #UN is provided if phyloseq is used for ordination
  if(!is.null(UN)){
    df <- data.frame(UN[,axes])
  }
  #Save df names
  df_Names <- names(df)
  
  if(!is.null(Env_Var)){
    
    if(!is.null(color)){
      Var_Col <- which(names(Env_Var) == color)
      df <- data.frame(df, Env_Var[,Var_Col])
      names(df) <- c(df_Names,color)}
    
    if (!is.null(shape)) {
      Var_Shape <- which(names(Env_Var) == shape)
      df <- data.frame(df, Env_Var[,Var_Shape])
      names(df)[ncol(df) ]<- shape
    }
    
  }#end if not null Env_Var
  
  x = colnames(df)[1]
  y = colnames(df)[2]
  
  ord_map = aes_string(x = x, y = y, color = color, shape = shape, 
                       na.rm = TRUE)
  
  p <- ggplot(df, ord_map) + geom_point(na.rm = TRUE)
  
  #Add percent var explained by axes on plot
  strivar = as(c(p$label$x, p$label$y), "character")
  strivar = paste0(strivar, "   [", percvar, "%]")
  p = p + xlab(strivar[1]) + ylab(strivar[2])
  
  return(p)
}

#################################################################################
#The following two functions CalcDivOrig() and  CalcDissimil() that is 
#used inside CalcDivOrig()
#calculate eucledian distance from the origin 
#based on several principal components information, and then project those points 
#onto the 2dim plot. Also, taxa labels are structured so that lengthy names 
#do not show on the plot, but just the numbers are plotted, and label info 
#is saved separately
##################################################################################
#Inputs:
#1. x - a multiple coinertia object of type  mcia() function output of made4 package
#   set x = NULL id ade4 object is used 
#2. type = "samples" the sample (rows) projection on PC, 
#       "species" - taxa (column) projections
#3. PrVar - percent of variation you with to explain by N components used for
    #calculating distance from origin (or between coinertia vectors)
#4. p - a ggplot object, plot to which you wish to add labels to
#5. Quant  - Distance Quantile on (0,1) that you wish the points plotted to exceed
#   e.g Quant = 0.9 will label all points on the plot with 
#   distance from the origin (or between two data sets in coinertia) that exceed 0.9th quantile
#   larger distance quantile corresponds to larger distance away from the origin

#7. plot_axes = c(1,2) - axes used in the plot that you add points to 
#8. size - size of the points (labels on teh plot)
#9. LabType - "Name" will put original variable names (not advised for long taxa names)
#           -"Order" will put numbers corresponding to the 
#             variable's order (row number in the PC components data set used for plot)
#10. Ordin - if x is NULL then ordination of type ade4 object must be provided, 
#   otherwise if x is used for plotting, then set Ordin to NULL
#11. DataType - just the type of data you have on teh plot, e.g. taxa or samples
#   this is just to keep track of what you plot in the labels info matrix
#   this  variable is not used in any important code lines 
#   and the choice of this variable will not affect the program

CalcDivOrig <- function(x,type = c("samples", "species"), PrVar, p = NULL, Quant = NULL,
                        plot_axes = c(1,2), size = 3, LabType = c("Name", "Order"),
                        Ordin = NULL, DataType = "Taxa") {
  
  
  if(!is.null(x)){
    
    ndata <- length(x$coa)
    
    if (type == "samples"){
      #Synthetic variables sample scores
      syn <- x$mcoa$SynVar     
      
      #Save names of of reference (synthetic)  axes
      Tabl <- names(syn)
      
      #Combine into one data frame with information which table data comes from
      TableNames <- data.frame(rep(1,dim(syn)[1]), rep("Synthetic", dim(syn)[1]))
      names(TableNames)<- c("Table", "Data")
      df <- data.frame(syn, TableNames)
      rownames(df) <- rownames(syn)
      co = syn
    }#end if type == "samples"
    
    if (type == "species"){
      #species scores
      co <- x$mcoa$Tco
      #Save names of Tables (taxa, lipids, cytokines) variables columns
      Tabl <-names(co) 
      
      #Combine into one data frame with information which table data comes from
      Table <- data.frame(as.numeric(x$mcoa$TC$"T"))
      names(Table) <- "Table"
      z <- data.frame(rep(1:length(names(x$coa))), names(x$coa))
      names(z)<- c("Table", "Data")
      TableNames <- merge(x=Table, y = z, by = 'Table', all=T) 
      df <- data.frame(co, TableNames)
    }#end if type == "species"
    
    #Eigenvalues contribution to variance explained
    Eig <- x$mcoa$pseudoeig
    Eig_P <- Eig/sum(Eig)
    
    #Number of components kept for the analysis
    Nkeep <- dim(co)[2]
  }#end if (!is.null(x))
  
  if(!is.null(Ordin)){
    
    if (type == "samples"){
      #Normalized sample scores
      df1 <- data.frame(Ordin$l1)     
      
      #Save names of reference (synthetic) variables columns
      Tabl <- names(df1)
      
      #Combine into one data frame with information which table data comes from
      TableNames <- data.frame(rep(1,dim(df1)[1]), rep(DataType, dim(df1)[1]))
      names(TableNames)<- c("Table", "Data")
      df <- data.frame(df1, TableNames)
      rownames(df) <- rownames(df1)
      
    }#end if type == "samples"
    
    if (type == "species"){
      #Normalized species scores
      df1 <- data.frame(Ordin$co)     
      
      #Save names of reference (synthetic) variables columns
      Tabl <- names(df1)
      
      #Combine into one data frame with information which table data comes from
      TableNames <- data.frame(rep(1,dim(df1)[1]), rep(DataType, dim(df1)[1]))
      names(TableNames)<- c("Table", "Data")
      df <- data.frame(df1, TableNames)
      rownames(df) <- rownames(df1)
    }#end if type == "species"
    
    #Eigenvalues contribution to variance explained
    Eig <- Ordin$eig
    Eig_P <- Eig/sum(Eig)
    
    #Number of components kept for the analysis
    Nkeep <- dim(df1)[2]
    
  }#end if(!is.null(Ordin))
  #Now, for each individual's score, we create a table of eucledian distances
  #from the synthetic (reference) axes with number of axes selection based on 
  #User specified proportion of variance explained by the first n eigenvalues
  
  Comp <- min(which(cumsum(Eig_P) > PrVar))
  NComp <- min(Comp, Nkeep)
  
  #let the user know that the number of components kept in the analysis cannot 
  #explain specified proportion of variance  
  if(Comp > Nkeep){
    Pr <- 100*round(cumsum(Eig_P)[Nkeep],2)
    print(paste("The number of components chosen for analysis explains ", Pr, "% of total
                inertia, which is less than desired. Please choose at least ", Comp, " eigenvectors to keep 
                while running MCIA.", sep = ""))
  }
  
  #Calculate distance away from 0
  yy <- (df[ ,Tabl[1:NComp]])^2
  Dist <- data.frame(sqrt(apply(yy, 1, sum))) 
  #if(!is.null(x)){rownames(Dist) <- substring(rownames(Dist), 2)}
  names(Dist) <- "Dist"
  #Combine with table names
  Div <-  data.frame(Dist, TableNames)  
  Dis <- CalcDissimil( Dist = Div, df = df[ ,Tabl[plot_axes]], LengthVar = "Dist", 
                       Quant = Quant, p =p, LabType = LabType, size = size)
  
  #Now add information on distance from the origin and corresponding quantile 
  #based on the two PCA axes used on the plot
  
  yy <- (df[ ,Tabl[plot_axes]])^2
  Dist <- data.frame(sqrt(apply(yy, 1, sum))) 
  #if(!is.null(x)){rownames(Dist) <- substring(rownames(Dist), 2)}
  names(Dist) <- "Dist"
  #Combine with table names
  Div2 <-  data.frame(Dist, TableNames)  
  Dis2 <- CalcDissimil( Dist = Div2, df = df[ ,Tabl[plot_axes]], LengthVar = "Dist", 
                       Quant = Quant, p =NULL, LabType = LabType, size = NULL)
  CNames <- which(names(Dis2$Dissimilarity) %in% c("Dist", "DistQuant"))
  Dissimilarity2 <- Dis2$Dissimilarity[,CNames]
  names(Dissimilarity2) <- paste(names(Dissimilarity2), "_2PC", sep = "")
  #Combine the two results
  Dissimilarity <- cbind(Dis$Dissimilarity, Dissimilarity2)
  p <- Dis$p
  #Match labels larger than specified quantile on all PC's with info 
  #which quantile this point corresponds to on 2 PC's
  Labels <- cbind(Dis$Labels, Dissimilarity2[Dis$Labels$Label,])
  return(list(Dissimilarity = Dissimilarity, p = p, Labels = Labels))
  }  

CalcDissimil <- function( Dist, df, LengthVar = "Dist", Quant = NULL, p =NULL, 
                          LabType = c("Name", "Order"),  size = 3){
  
  Length <- Dist[,which(colnames(Dist) == LengthVar)]
  
  #Arrange distances into quantiles
  Quantiles <- unique(sort(c(seq(0,1,0.25), seq(0,1, 0.1))))
  Summary <- quantile(Length, probs = Quantiles)
  
  #Create a vector with information what quanlite each row belongs to
  DistQuant <- rep(NA, length(Length))
  
  #Fill in the rest of quantiles
  for (i in 1:(length(Summary)-1)){
    Ind <- Length >=Summary[i] & Length < Summary[i+1]
    #browser()
    DistQuant[Ind] <- Quantiles[i] 
    if(i == (length(Summary)-1)) {DistQuant[Length >= Summary[i+1]] <- Quantiles[i+1]} 
  }
  #Combine distance data with quanlite information 
  Dissimilarity <- data.frame(Dist, DistQuant)
  #Dissimilarity <- Dissimilarity[order(Dissimilarity$DistQuant), ]
  Labels <- NULL
   
  if(!is.null(p)){
    #Put labels on plot corresppnding to samples or species with largest quantile
    QPlot <- quantile(Length, probs = Quant)
    Ind  <- which(Length >= QPlot)
    Labels <- rownames(Dist)[Ind]
    Labels <- data.frame(Labels, Ind)
    names(Labels) <- c("Name", "Label")
    df2 <- data.frame(df[Ind,], Labels)
    
    if(LabType == "Name"){ Lab = Labels$Name}
    if(LabType == "Order"){ Lab = Labels$Label}
    #Put labels on the plot using numbers 
    p <- p + annotate("text", x = df2[,1], y = df2[,2], label = Lab, size = size)
  }
  return(list(p=p, Dissimilarity = Dissimilarity, Labels = Labels))
}

####################################################
#Little function to calculate quantiles of a vector x
####################################################

CalcQuant <- function(x, Quantiles){
  Summary <- quantile(x, probs = Quantiles)
  
  #Create a vector with information what quanlite each row belongs to
  DistQuant <- rep(NA, length(x))
  
  #Fill in the rest of quantiles
  for (i in 1:(length(Summary)-1)){
    Ind <- x >=Summary[i] & x < Summary[i+1]
    #browser()
    DistQuant[Ind] <- Quantiles[i] 
    if(i == (length(Summary)-1)) {DistQuant[x >= Summary[i+1]] <- Quantiles[i+1]} 
  }
  
  return(cbind(x, DistQuant))
}

#############################################################
#Paul's classification of predominant taxa
###########################################################
# Construct CSTs based on predominant taxon   
predominantCST <- function(mydata, prop4type = 0.3) {	
  # normalize to proportions	
  mydata <- sweep(mydata,1,rowSums(mydata), "/") 	
  
  mytypes <- apply(mydata,1,which.max)	
  # get row/col of max proportions	
  maxpropind <- matrix(c(1:nrow(mydata),mytypes), ncol=2)	
  maxprop <- mydata[maxpropind]	
  mytypenames <- colnames(mydata)[mytypes] 	
  mytypenames[maxprop < 0.3] <- "No Type"	
  mytypenames	
}	

############################################################
#Get top taxa on first PC's
############################################################
GetTopNPC <- function(PC, n, Diff = 0.1){
  PCAbs <- abs(PC)
  #Values
  PCSort1 <-  apply(PCAbs, 2, function(x) {sort.int(x, decreasing = TRUE, index.return = FALSE)})
  #Indexes
  PCSort2 <-  apply(PCAbs, 2, function(x) {
    y <- sort.int(x, decreasing = TRUE, index.return = TRUE)
    y$ix
  })
  #PC Bact
  PCBact <- matrix(rownames(PCAbs), nrow = nrow(PCAbs), ncol = ncol(PCAbs))
  colnames(PCBact) <- colnames(PCAbs)
  for ( i in 1:ncol(PCBact)){
    PCBact[,i] <- PCBact[,i][PCSort2[,i]]
  }
  
  #Get bacteria with top x - 0.1 loadings 
  Ind <- apply(PCSort1, 2, function(x) {x > max(x) - Diff})
  LargeLoad <- apply(Ind, 2, function(x) {a <- which(x, arr.ind = TRUE)
                                          max(a)
  })
  LargeLoadBact <- list()
  for ( i in 1:ncol(PCBact)){
    LargeLoadBact[[i]] <- PCBact[1:LargeLoad[i],i]
  }
  
  #Top n bact
  TopBactPC <- apply(PCBact, 2, function(x){x[1:n]})
  TopValPC <- apply(PCSort1, 2, function(x){x[1:n]})
  
  return(list(TopBactPC = TopBactPC, TopValPC = TopValPC, LargeLoadBact = LargeLoadBact))
}
