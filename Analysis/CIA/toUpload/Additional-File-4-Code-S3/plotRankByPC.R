# functions for plotting the presence/absence and intensity plots
# for visualizing influence on variation by PC

# workflow: 
# starting with a data frame of object projections on PCs,
# call getDistances() to turn projections into distances from origin
# call getDeciles or getTenths on distances to find rank indexes of objects by PC
#  getDeciles ranks by population density
#  getTenths ranks by "range", i.e. distance
# call plotPASD or plotIntensity to plot data frame of rank indexes
# or call makePCVisualizationPlot on projections to perform complete workflow in one step
#
# call makeCumulativeVariancePlot to create the associated cumulative variance explained plot

#rm(list=ls())
library(RColorBrewer)
library(colorspace)
getDistances <- function(df) {
  # takes a data frame of object projections
  # returns a new data frame with distances
  # by number of PCs used
  nr <- nrow(df)
  nc <- ncol(df)
  distances <- data.frame(abs(df[,1]))
  rownames(distances) <- rownames(df)
  for (i in 2:nc) {
    distances[,i] <- sqrt(rowSums((df[,1:i])^2))
  }
  colnames(distances) <- paste("distanceUsing", 1:nc, sep="")
  return(distances)
}

getDeciles <- function(df) {
  # takes a data frame of distances
  # by number of PCs used
  # returns a new data frame with decile indexes
  nr <- nrow(df)
  nc <- ncol(df)
  dec <- data.frame(rep(0,nr))
  rownames(dec) <- rownames(df)
  for (i in 1:nc) {
    ar<-rank(df[,i],ties.method = "first")
    dec[,i] <- cut(ar, quantile(ar,0:10/10), include.lowest=TRUE, labels=FALSE) # [),[), ...,[),[]
  }
  colnames(dec) <- paste("decileUsing", 1:nc, sep="")
  return(dec)
}

getTenths <- function(df) {
  # takes a data frame of distances
  # by number of PCs used
  # returns a new data frame with tenth indexes
  nr <- nrow(df)
  nc <- ncol(df)
  tenths <- data.frame(rep(0,nr))
  rownames(tenths) <- rownames(df)
  for (i in 1:nc) {
    ar<-rank(df[,i],ties.method = "first")
    tenths[,i] <- cut(ar, 10, include.lowest=TRUE, labels=FALSE) # [),[), ...,[),[]
  }
  colnames(tenths) <- paste("tenthUsing", 1:nc, sep="")
  return(tenths)
}

getRankLiers <- function(df, rank) {
 # takes a data frame of rank indexes and a rank of interest (1:10)
 # returns a new data frame with 
 #  number of times in the rank
 #  max pcs used in rank

 nr <- nrow(df)
 nc <- ncol(df)

 liers <- data.frame(tally = rowSums(df[,] == rank))
 liers$lastOne <- 0

 for (i in 1:nrow(liers)) {
   ones <- which(df[i,] == rank)
   if (length(ones) > 0) {
    liers$lastOne[i] <- tail(ones, n=1)
   }
   else {
    liers$lastOne[i] <- 0
   }
 }

 return(liers)
}

plotPASD <- function(df, rank, covar=NULL, covarColors=NULL) {
  # takes a data frame of rank indexes and a rank and plots presence/absence

    # get dimensions
  nc <- ncol(df)
  liers <- getRankLiers(df,rank)
  nr <- nrow(liers)
  
  # Sorting:
  if (is.null(covar)) { 
    # if no covariates are provided, sort distances by largest number of PCs used, then by sum of all times 
    # used in a combination of PCs and assign one color
    liers$covar <- as.factor(rep("No covariates supplied", nr))
    numLevels <- 1
    covarColors <- c("blue")
    #order by max pcs in the decile/tenth, then sum of decile/tenth indicators
    liers <- liers[order(liers$lastOne, liers$tally),]
  }
  else {
    # if covariates are provided, assign up to 8 covariate colors.  Then order by covariates; then sort distances by
    # largest number of PCs used, then by sum of all times used in a combination of PCs 
    liers$covar <- as.factor(covar)
    numLevels <- nlevels(liers$covar)
    if (is.null(covarColors)) {
      if(numLevels > 8) {
        stop("Plot can only accomodate coloring up to 8 covar levels.")
      }
      covarColors <- brewer.pal(numLevels, "Dark2")
      #covarColors <- rainbow(numLevels)
    }
    #order by covar, then max pcs in the decile, then sum of decile indicators
    liers <- liers[order(liers$covar, liers$lastOne, liers$tally),]
  }
  
  liers <- liers[liers$tally > 0,]
  nr <- nrow(liers)

    # need to reverse order of groups, but not within groups
  # if (! is.null(covar)) {
  #  liers <- liers[order(nr:1),] #invert row order for printing
  # } 
  
  # get the range for the x and y axis
  xrange <- c(1,nc)
  yrange <- c(1,nr)
  
  # set up the plot
  plot(xrange, yrange, type="n",  yaxt="n", ylim=yrange, xaxt="n", xlab="", ylab="") 
  axis(1, at = seq(1, nc, by = 10))
  
  # Plotting
  for (j in 1:nr) {
    for (x in 1:nc) {
      if (df[row.names(liers)[j], x] == rank) {
        points(x, j, pch=15, col=covarColors[liers$covar[j]])
      }   
      else {
        points(x, j, pch=15, col="gray96")
      }   
    }  
  }
  
  # for (i in 1:numLevels) {
  #   points(x=5, y=nr+(2*i), pch=15, col=covarColors[i])
  #   text(x=7, y=nr+(2*i), labels=rev(levels(liers$covar))[i], pos=4)
  # }
  legend("top", legend=levels(liers$covar), col=covarColors, pch=15, inset=c(0,-0.015), xpd=TRUE, horiz=TRUE, bty="n")
  
  axis(2, at=1:nr, labels=row.names(liers), col.axis="blue", las=2, cex.axis=0.7)
}

plotIntensity <- function(df, covar=NULL, covarColors=NULL, plotOrder=NULL) {
  # takes a data frame of ranks indexes and plots them by intensity
  
  # get dimensions
  nc <- ncol(df)
  nr <- nrow(df)
  sums <- rowSums(df[,])
  
  if (is.null(covar)) {
    df$covar <- as.factor(rep("No covariates supplied", nr))
    numLevels <- 1
    #covarColors <- c("blue")
    
  }
  else {
    df$covar <- as.factor(covar)
    numLevels <- nlevels(df$covar)
    if (is.null(covarColors)) {
      if(numLevels > 8) {
        stop("Plot can only accomodate coloring up to 8 covar levels.")
      }
      covarColors <- brewer.pal(numLevels, "Dark2")
    }
  }
  
  if (is.null(plotOrder)) {
   # order by covar, then desc decile/tenth of max pcs, then decile/tenth sum
   plotOrder <- order(df$covar,-df[,nc], sums)
  } 
  df <- df[plotOrder,]

  # need to reverse order of groups, but not within groups
  # if (! is.null(covar)) {
  #  df <- df[order(nr:1),] #invert row order for printing
  # }
  
  # get the range for the x and y axis
  xrange <- c(1,nc)
  #yrange <- c(1,nr+(2*numLevels))
  yrange <- c(1,nr)
  
  # set up color intensity levels
  # need unique color for each covar level
  # and 10 levels of intensity for each color
  colorIntensity <- data.frame(matrix(rep("", 10*numLevels), nrow=numLevels), stringsAsFactors = FALSE)
  if (is.null(covar)){
    colorIntensity[1,]=sequential_hcl(10, h = 264, c = c(90, 90), l = c(95, 20), power =0.8)
  }
  else {
    for (i in 1:numLevels) {
      covarRgb <- col2rgb(covarColors[i])/255
      colorIntensity[i,] <- rgb(covarRgb[1], covarRgb[2], covarRgb[3], alpha=(1:10 / 10))
    }
  }


  # set up the plot
  plot(xrange, yrange, type="n",  yaxt="n", ylim=yrange, xaxt="n", xlab="", ylab="") 
  axis(1, at = seq(1, nc, by = 10))

  # plot data
  for (j in 1:nr) {
    for (x in 1:nc) {
      points(x, j, pch=15, col=colorIntensity[df$covar[j], df[j, x]])
    }  
  }
  
  # add covar labels
  #for (i in 1:numLevels) {
  #  points(x=5, y=nr+(2*i), pch=15, col=covarColors[i])
  #  text(x=7, y=nr+(2*i), labels=rev(levels(df$covar))[i], pos=4)
  #}
  verticalOffset = 1/nr
  legend("top", legend=levels(df$covar), col=covarColors, pch=15, inset=c(0,-verticalOffset), xpd=TRUE, horiz=TRUE, bty="n")
  
  axis(2, at=1:nr, labels=row.names(df), col.axis="blue", las=2, cex.axis=0.7)
  
  return(plotOrder)
}

makePCVisualizationPlot <- function(projections, type="presence", byRank="decile", atRank=1, plotTitle=NULL, 
                                    xLabel="Number of PCs used", yLabel="Object", covar=NULL, covarColors=NULL,
                                    plotOrder=NULL, breaks=NULL) {
  # takes a data frame of projections and plots them according to parameters
  
  # check params
  if (!is.null(covar) & nrow(projections) != length(covar)) {
    stop("Covariate vector length must match number of objects.")
  }
  if (!is.null(covar) & !is.null(covarColors) & length(unique(covar)) != length(covarColors)) {
    stop("Covariate color vector length must match number of covariate levels.")
  }
  
  if (! type %in% c("presence","intensity")) {
    stop("Parameter 'type' must be 'presence' or 'intensity'")
  }
  
  if (! byRank %in% c("decile","tenth")) {
    stop("Parameter 'byRank' must be 'decile' or 'tenth'")
  }
  
  # get distances by number of PCs from projections
  mdistances <- getDistances(projections)
  
  # get rank indexes
  if (byRank=="decile") {
    rankIndexes <- getDeciles(mdistances)
    rankDescription <- "Decile"
  }
  else {
    rankIndexes <- getTenths(mdistances)
    rankDescription <- "Range"
  }
  
  # make plot
  newOrder <- NULL
  if (type=="presence") {
    plotPASD(rankIndexes, atRank, covar, covarColors)
    if (is.null(plotTitle)) {
      plotTitle <- paste(rankDescription, "-", atRank, " presence by number of PCs used", sep="")
    }
  }
  else {
    newOrder <- plotIntensity(rankIndexes, covar, covarColors, plotOrder)
    if (is.null(plotTitle)) {
      plotTitle <- paste(rankDescription, " intensity by number of PCs used", sep="")
    }
  }
  
  # add titles and axis labels
  if (is.null(xLabel)) {
    xLabel <- "Number of PCs used"
  }
  if (is.null(yLabel)) {
    yLabel <- "Object"
  }
  title(plotTitle, xlab=xLabel, ylab=yLabel)
  if (! is.null(breaks)) {
   abline(v=breaks)
  }  
  return(newOrder)
}

makeCumulativeVariancePlot <- function(eigenValues, numPCs) {
  plot(c(1,numPCs), c(0,1), xaxt="n", type="n", main="", ylab="Cumulative Variance Explained", xlab="Eigen Vector Rank")
  axis(1, at=c(1,seq(11, numPCs, 10)))
  points(cumsum(eigenValues[1:numPCs]/sum(eigenValues)))
}

# Counts to Props takes an OTU table and returns a table with proportions of each taxon for each sample composition
CountstoProps<-function(OTU){
  cols<-ncol(OTU)
  den<-rowSums(OTU)
  den<-1/den
  Props = sweep(OTU,1,den,FUN="*")
  colnames(Props)<-colnames(OTU)
  rownames(Props)<-rownames(OTU)
  return(Props)
}

# evaluates if proportions of taxa in 2 tables grew (+1), shrank(-1), or did not change(0) from time1 to time2
TestDiffs<-function(Props1, Props2, CL=.8){
  cols<-ncol(Props1)
  shiftValue<-rep(0, cols)
  for(i in 1:cols){
    tDiff<-t.test(Props2[,i], Props1[,i], paired=TRUE,  conf.level = CL)
    if(tDiff$conf.int[2]<0){
      shiftValue[i] <- -1     
    } else {
      if(tDiff$conf.int[1]>0){
        shiftValue[i] <- 1  
      } else {
        shiftValue[i] <- 0     
      }
    }
  }
  names(shiftValue)<-colnames(Props1)
  return(shiftValue)
}


plotIntensityCountsdiff <- function(df, df2, counts, counts2, title) {
  
  # get dimensions
  nc <- ncol(df)
  nr <- nrow(df)
  sums <- rowSums(df[,])
  
  # order by covar, then desc decile/tenth of max pcs, then decile/tenth sum
  plotOrder <- order(-df[,nc], sums)
  df <- df[plotOrder,]
  
  # get the range for the x and y axis
  xrange <- c(1,nc)
  yrange <- c(1,3*nr)
  
  # set up color intensity levels
  # need baseline plus 2 colors for above/below baseline
  # and 10 levels of intensity for each color
  colorIntensity <- data.frame(matrix(rep("", 30), nrow=3), stringsAsFactors = FALSE)

  colorIntensity[1,] <- sequential_hcl(10, h = 260, c = c(10, 0), l = c(90, 30), power = 1.5)  #gray

  # use this if "after" is more spread out
  colorIntensity[2,] <- sequential_hcl(10, h = 280, c = c(70, 40), l = c(90, 30), power = 1.5) #purple
  
  # use this if "after" is less spread out
  colorIntensity[3,] <- sequential_hcl(10, h = 100, c = c(80, 40), l = c(90, 30), power = 1.5) #green
  
  # set up the plot
  plot(xrange, yrange, type="n",  yaxt="n", ylim=yrange, xaxt="n", xlab="", ylab="", main=title) 
  axis(1, at = seq(1, nc, by = 10))
  
  # plot data
  for (j in 1:nr) {
    rname = rownames(df)[j]
    range1 = max(counts[,rname]) - min(counts[,rname])
    range2 = max(counts2[,rname]) - min(counts2[,rname])
    ypos = 3*j - 2
    for (x in 1:nc) {
      if (range1 <= range2) {
        points(x, ypos, pch=15, col=colorIntensity[2, df2[rname, x]])
      }
      else {
        points(x, ypos, pch=15, col=colorIntensity[3, df2[rname, x]])  
      }
      points(x, ypos+1, pch=15, col=colorIntensity[1, df[j, x]])
    }  
  }
  
  axis(2, at=seq(2, 3*nr, by=3), labels=row.names(df), col.axis="blue", las=2, cex.axis=0.7)
  
}



plotIntensityPropsdiff <- function(df, df2, counts, counts2, title, plotOrder=NULL) {
  
  # get dimensions
  
  nc <- ncol(df)
  nr <- nrow(df)
  sums <- rowSums(df[,])
  
  props1<-CountstoProps(counts)
  props2<-CountstoProps(counts2)
  
  shiftValues<-TestDiffs(props1, props2)
  
  # order by covar, then desc decile/tenth of max pcs, then decile/tenth sum
  if (plotOrder == NULL) {
   plotOrder <- order(-df[,nc], sums)
  } 
  df <- df[plotOrder,]
  
  # get the range for the x and y axis
  xrange <- c(1,nc)
  yrange <- c(1,3*nr)
  
  # set up color intensity levels
  # need baseline plus 2 colors for above/below baseline
  # and 10 levels of intensity for each color
  colorIntensity <- data.frame(matrix(rep("", 30), nrow=3), stringsAsFactors = FALSE)
  
  colorIntensity[1,] <- sequential_hcl(10, h = 0, c = c(0, 0), l = c(85, 15), power = 1)  #gray
  
  # use this if "after" is more spread out
  colorIntensity[2,] <- sequential_hcl(10, h = -3, c = c(20, 80), l = c(90, 30), power = .7) #red
  
  # use this if "after" is less spread out
  colorIntensity[3,] <- sequential_hcl(10, h = 203, c = c(10, 80), l = c(90, 20), power = .5) #blue
  
  # set up the plot
  plot(xrange, yrange, type="n",  yaxt="n", ylim=yrange, xaxt="n", xlab="", ylab="", main=title) 
  axis(1, at = seq(1, nc, by = 10))
  
  # plot data
  for (j in 1:nr) {
    rname = rownames(df)[j]
    ypos = 3*j - 2
    for (x in 1:nc) {
      if (shiftValues[rname] == 1) {
        points(x, ypos, pch=15, col=colorIntensity[2, df2[rname, x]])
      }
      else if (shiftValues[rname] == -1){
        points(x, ypos, pch=15, col=colorIntensity[3, df2[rname, x]])  
      }
      else {
        points(x, ypos, pch=15, col=colorIntensity[1, df2[rname, x]])
      }
      points(x, ypos+1, pch=15, col=colorIntensity[1, df[j, x]])
    }  
  }
  
  axis(2, at=seq(2, 3*nr, by=3), labels=row.names(df), col.axis="blue", las=2, cex.axis=0.7)
  
}

# 
# # test commands
# md <- getDistances(Prop.pca$co)
# mdec1 <- getDeciles(md[1:25,])
# mdec2 <- getDeciles(md[26:50,])
# rownames(mdec2) <- rownames(mdec1)
# counts1 <- OTU_Counts[1:25,]
# counts2 <- OTU_Counts[26:50,]
# 
# #plotPASD(mrng[1:50,], 1)
# 
# 
# old.par <- par(no.readonly=TRUE)
# par(oma = c(8, 20, 1,20))
# png(filename="testStack.png",
#     type="cairo",
#     units="in",
#     width=18,
#     height=max(ceiling(0.25 * nrow(Prop.pca$co)), 7),
#     pointsize=16,
#     res=96)
# par(mar=c(5,12,4,8)+0.1,mgp=c(8,1,0))
# plotIntensity2(mdec1, mdec2, counts1, counts2, "test stacks")
# #makePCVisualizationPlot(Prop.pca$l1[1:50,], type="intensity", atRank=1, byRank="decile", covar=data$Ethnic_Group[1:50], breaks=c(2,25,35,50))
# #makePCVisualizationPlot(Prop.pca$l1[1:50,], type="presence", atRank=1, byRank="decile", covar=NULL, breaks=c(2,25,35,50))
# dev.off()
# par(old.par)


# mrng <- getTenths(md)
# 
# dForRangeTest <- data.frame(d1=c(2,22,32,42,52), d2=c(53,43,33,13,3), d3=c(4,4,4,44,44), d4=c(11,111,11,111,11))
# getTenths(dForRangeTest)
#  
# plotPASD(mdec[1:50,], 1, covar=data$Ethnic_Group[1:50])
# plotPASD(mrng[1:50,], 1, covar=data$Ethnic_Group[1:50])
# plotPASD(mrng[1:50,], 1, covar=NULL)
# plotIntensity(mdec[200:250,], covar=data$Nugent_Category[200:250])
# plotIntensity(mrng[1:50,])


#makePCVisualizationPlot(Prop.pca$l1[1:50,], type="intensity", atRank=1, byRank="decile", covar=data$Ethnic_Group[1:50], breaks=c(2,25,35,50))
# makePCVisualizationPlot(Prop.pca$l1[1:50,], type="intensity", byRank="decile", covar=data$Ethnic_Group[1:50])
# makePCVisualizationPlot(Prop.pca$l1[1:50,], type="presence", atRank=1, byRank="tenth", covar=data$Ethnic_Group[1:50])
# makePCVisualizationPlot(Prop.pca$l1[1:50,], type="intensity", byRank="tenth", covar=data$Ethnic_Group[1:50])
