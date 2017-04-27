#!/usr/bin/env Rscript

# Non-parametric test for significant correlation 
# of two variables within a subject, using multiple subjects
# 
# usage: 
# Rscript xy.subject.test.r x-input.txt x-column-header y-input.txt y-column-header subject-map.txt subject-column-header nperms
# 
# example:
#
# Rscript xy.subject.test.r map-subset-no-soylent.txt TFAT taxa/otutable-subset-n50000-s10-norm_L6-transpose.txt "k__Bacteria;p__Bacteroidetes;c__Bacteroidia;o__Bacteroidales;f__Prevotellaceae;g__Prevotella" map-subset-no-soylent.txt UserName 999

args <- commandArgs(trailing=TRUE)

x <- read.table(args[1], sep='\t',head=TRUE, row=1,check=F,comment='')

y <- read.table(args[3], sep='\t',head=TRUE, row=1,check=F,comment='')

subject <- read.table(args[5], sep='\t',head=TRUE, row=1,check=F,comment='')

# ensure all data tables have the same rows
ix <- intersect(rownames(x), intersect(rownames(y), rownames(subject)))
x <- x[ix,]
y <- y[ix,]
subject <- subject[ix,]

x <- x[,args[2]]
y <- y[,args[4]]
subject <- subject[,args[6]]

nperms <- as.numeric(args[7])

## Permuation based test to see if different from random
# Using a permutation test and a groupwise average of the test statistic of the spearman correlation, we find clinical relevance but not significance.
# y is the dependent variable
# x is the independent variable
# x and y were measured together multiple times in each subject
# subject is the subject ID for each measurement (multiple measurements have the same subject ID)
"xy.subject.test" <- function(x, y, subject, nperms=999){


	obs <- -mean(sapply(split(1:length(y), subject), 
	         function(ixx) if(length(ixx) < 3) 0 else cor.test(x[ixx], y[ixx], method='spear',exact=FALSE)$statistic))

	estimate <- mean(sapply(split(1:length(y), subject), 
	         function(ixx) if(length(ixx) < 3) 0 else cor(x[ixx], y[ixx], method='spear')))

	mc.stats <- -replicate(nperms,mean(sapply(split(1:length(y), subject), 
	                                           function(ixx) if(length(ixx) < 3) 0 else cor.test(x[ixx], sample(y[ixx]), method='spear',exact=FALSE)$statistic)))

	pval <- mean(c(obs,mc.stats) >= obs)
	return(list(pval=pval, estimate=estimate))
}

result <- xy.subject.test(x,y,subject, nperms)
cat('p-value:',result$pval,'\n')
cat('Mean correlation:',result$estimate,'\n')
