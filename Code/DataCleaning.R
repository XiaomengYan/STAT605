# Data Set
## Description
## 127 SNe Ia from PAIRITEL, CfA3, Carnegie Supernova Project and the literature.
## CSP photometric data:

######## customer set ###########
rawpath <- "../Data/CSP_Kevin/"
outpath <<- "../Data/CSP_BVRI/"
#################################


###################################################################
##Procedure to deal with third release dataset
rawfile <- list.files(rawpath)
SNeDF <- data.frame(matrix(0,ncol = 2,nrow = length(rawfile)))
colnames(SNeDF)<- c("SN","z")
options(digits=10)
for(SNIndex in 1:length(rawfile)){
  print(SNIndex)
  # Get the supernova file name
  SNeFile <- paste0(rawpath,rawfile[SNIndex])
  # Read the raw data (without removing "#")
  SNe_Lines <- readLines(SNeFile)
  SNeName <- unlist(strsplit(SNe_Lines[1],split = " "))[1]
  Redshift <- unlist(strsplit(SNe_Lines[1],split = " "))[2]
  SNeDF[SNIndex,] <- c(SNeName,Redshift)
  write.table(SNe_Lines[1],file = paste0(outpath,SNeName,"_CSP_main.txt"),quote = FALSE,row.names = FALSE,col.names = FALSE)
  Locfilter <- grep("filter",SNe_Lines)
  EntireFilterName <- c("filter B","filter V0","filter V1","filter V","filter r","filter i")
  for(j in EntireFilterName){
    ExactFilterLoc <- which(SNe_Lines[Locfilter]== j)
    if(length(ExactFilterLoc) == 0)
    {
      next()
    }
    else if(ExactFilterLoc == length(Locfilter))
    {
      ExactFilterReponse <- SNe_Lines[Locfilter[ExactFilterLoc]:length(SNe_Lines)]
    }
    else{
      ExactFilterReponse <- SNe_Lines[Locfilter[ExactFilterLoc]:(Locfilter[ExactFilterLoc+1]-1)]
    }
    write.table(ExactFilterReponse,file = paste0(outpath,SNeName,"_CSP_main.txt"),row.names = FALSE,quote = FALSE,col.names = FALSE,append = TRUE)
  }
}

write.csv("../Data/CSP_Kevin_Summary.csv",x = SNeDF,row.names = FALSE)
