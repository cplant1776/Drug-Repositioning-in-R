#!/usr/bin/env Rscript

options(echo=TRUE)

suppressPackageStartupMessages(library("argparse"))
parser <- ArgumentParser(description="")
parser$add_argument("-g", action="store", dest="landmarkGenes", required=TRUE, help="Landmark genes")
parser$add_argument("-d", action="store", dest="datadir", required=TRUE, help="Directory for raw CEL files")
parser$add_argument("-m", action="store", dest="metadata", required=TRUE, help="metadata file for the disease")
parser$add_argument("-n", action="store", dest="annolib", required=TRUE, help="Annotation library name")
parser$add_argument("-L", action="store", dest="lincs", required=TRUE, help="LINCS level 4 data file")
parser$add_argument("-o", action="store", dest="outFile", required=TRUE, help="Output file")
args <- parser$parse_args()

# Main boday
file_landmarkGenes <- args$landmarkGenes
datadir <- args$datadir
file_metadata <- args$metadata
name_anno_lib_disease <- args$annolib
lincslevel4 <- args$lincs
outFile <- args$outFile

# Load Packages
suppressPackageStartupMessages(library(affy))
suppressPackageStartupMessages(library(limma))
suppressPackageStartupMessages(library(name_anno_lib_disease, character.only=TRUE))
suppressPackageStartupMessages(library(hgu133plus2.db))
suppressPackageStartupMessages(library(annotate))
suppressPackageStartupMessages(library(xlsx))
suppressPackageStartupMessages(library(parallel))

landmarkGenes <- read.xlsx(file=file_landmarkGenes, sheetIndex=1)[,'Gene.Symbol']
metadata <- read.table(file_metadata, header=T)
sampleNames <- metadata[,"Sample"]
filenames <- metadata[,"Filename"]
ab=ReadAffy(filenames=filenames, celfile.path=datadir, sampleNames=sampleNames)
eset=rma(ab, verbose=F)
DiseaseID=featureNames(eset)
DiseaseSymbol=toupper(getSYMBOL(DiseaseID, name_anno_lib_disease))
GenesDisease <- intersect(DiseaseSymbol, landmarkGenes) # disease genes

suppressPackageStartupMessages(library(rhdf5)) # drug
DrugID = gsub(' ', '', h5read(lincslevel4, name='0/META/ROW/id'))
DrugSymbol=getSYMBOL(as.vector(DrugID), 'hgu133plus2.db')
GenesDrug <- intersect(DrugSymbol, landmarkGenes) # drug genes

commonGenes <- intersect(GenesDisease, GenesDrug)
str(GenesDrug)
str(commonGenes)
matchGeneDisease <- DiseaseSymbol[!is.na(match(DiseaseSymbol, commonGenes))] # disease query
matchGeneDisease
IndexDisease <- names(matchGeneDisease)
exprsDisease <- do.call(rbind, by(exprs(eset)[IndexDisease,], matchGeneDisease, colMeans))[commonGenes,]
str(exprsDisease)

suppressPackageStartupMessages(library(samr))
sampleType <- metadata[,'Type']
resDisease<-SAM(x=exprsDisease, y=sampleType, resp.type='Two class unpaired', genenames=commonGenes, geneid=commonGenes)
queryDisease <- rep(0, length(commonGenes))
names(queryDisease) <- commonGenes
if (resDisease$siggenes.table$ngenes.up > 0) {
  queryDisease[resDisease$siggenes.table$genes.up[,'Gene Name']] <- 1
}
if (resDisease$siggenes.table$ngenes.lo > 0) {
  queryDisease[resDisease$siggenes.table$genes.lo[,'Gene Name']] <- -1
}

matchGeneDrug <- DrugSymbol[!is.na(match(DrugSymbol, commonGenes))] # drug zscore
IndexDrug <- names(matchGeneDrug)

drugNames <- gsub(' ', '', h5read(lincslevel4, name='0/META/COL/id'))
matrix_run <- matrix(seq_along(drugNames), nrow=86) # 15443 * 86 = 1328098

source("my_connectivity_score.R")
result <- do.call(c, mclapply(seq_len(ncol(matrix_run)), function(indexrun) {
  indexVector <- matrix_run[,indexrun]
  cat(indexVector[1], '\n')

  drugZscores <- h5read(lincslevel4, index=list(NULL, indexVector), name = "/0/DATA/0/matrix")
  H5close()
  rownames(drugZscores) <- DrugID
  colnames(drugZscores) <- drugNames[indexVector]

  connectivities <- sapply(seq_len(ncol(drugZscores)), function(indexCol) {
    drugZscore <- drugZscores[,indexCol]
    experimentDrug <- unlist(tapply(drugZscore[IndexDrug], matchGeneDrug, mean))[commonGenes]
    score <-  my_connectivity_score(experimentDrug, queryDisease)
    names(score) <- colnames(drugZscores)[indexCol]
    score
  })
  rm(drugZscores); gc()
  connectivities
}, mc.cores=25))

# make new directory in results
dir_name = substr(outFile, 1, nchar(outFile)-4)
res_directory = paste("../../results/", dir_name, sep="")
dir.create(res_directory)

# save RDS to new directory
fpath = paste(res_directory, "/", outFile, sep="")
saveRDS(data.frame(result), file=fpath)

