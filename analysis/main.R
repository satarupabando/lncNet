script.dir <- function() {
  # from http://stackoverflow.com/a/16046056
  dirname(sys.frame(1)$ofile)
}

### Start with project dir, and helper functions
projectDir <- normalizePath(file.path(script.dir(), ".."))
getFullPath <- function(subpath){ file.path(projectDir, subpath) }

homeFolder <- path.expand("~")
getDataFile <- function(subpath){file.path(homeFolder, "data", subpath)}

getFullPlotPath <- function(subpath){ file.path(plotFolder, subpath) }
getDropboxPath <- function(subpath){ file.path(dataFolder, subpath) }


exportAsTable <- function(df, file){ write.table(df,file=file,quote=FALSE, row.names=FALSE,sep="\t") }
clear <- function(save.vec=c()){ ls.vec <- ls(globalenv());del.vec <-setdiff(ls.vec,c(save.vec,"clear")); rm(list=del.vec,pos=globalenv())}
readInTable <- function(file) read.table(file=file,stringsAsFactors=FALSE,header=TRUE)


# setup libs
# install if needed from http://stackoverflow.com/a/4090208
list.of.packages <- c(
  "ggplot2",
  "ROCR", # http://cran.r-project.org/web/packages/ROCR/index.html
  "glmnet", # http://cran.r-project.org/web/packages/glmnet/glmnet.pdf
  "randomForest", #http://cran.at.r-project.org/web/packages/randomForest/randomForest.pdf
  "doParallel",
  "foreach",
  "mboost",
  "vcd", # mosaicpl
  "C50", # kuhn:411
  "mda", # fda, kuhn:362
  "gam",
  "reshape2", # needed for melt
  "MASS",
  "devtools" # for github installs
)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

if (!"gbm" %in% installed.packages()) {
  install_url("http://cran.r-project.org/src/contrib/Archive/gbm/gbm_2.0-8.tar.gz")
}

#install_github("harrysouthworth/gbm")

#load libs
lapply(list.of.packages, function(lib){
  library(lib, character.only=TRUE)
})

calcNumCores <- function(){
  numCores <- detectCores()
  if(numCores > 8){
    numCores <- numCores / 2
  } else if(numCores == 1){
    numCores <- 1
  } else {
    numCores <- numCores - 1
  }
  cat("using", numCores, "cores")
  return(numCores)
}
#registerDoParallel(calcNumCores())
registerDoParallel(10)

## load in other libs
source(getFullPath("analysis/dataInput.R"))
source(getFullPath("analysis/plotResults.R"))