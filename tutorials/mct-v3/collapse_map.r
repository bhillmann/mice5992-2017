#!/usr/bin/env Rscript
#
# usage:
# collapse_map.r map.txt columnname output.txt
#

args <- commandArgs(trail=T)
m <- read.table(args[1], sep='\t', head=T,row=1,check=F,comment='')

column <- strsplit(args[2],',')[[1]]

if(!(all(column %in% colnames(m)))) stop(paste("Column",paste(column,collapse=','),"not in mapping file headers."))

if(length(column) == 1){
  collapse.by <- m[,column]
} else if(length(column) >= 2){
  collapse.by <- interaction(as.list(m[,column]))
}

m2 <- sapply(1:ncol(m),function(j) {splitx <- split(m[,j],collapse.by); if(class(m[,j]) == "numeric") sapply(splitx,function(xx) mean(xx[!is.na(xx)])) else sapply(splitx,function(xxx) names(sort(table(as.character(xxx)),decreasing=TRUE))[1])}); colnames(m2) <- colnames(m)

sink(args[3]); cat('#SampleID\t'); write.table(m2,sep='\t',quote=F); sink(NULL)
