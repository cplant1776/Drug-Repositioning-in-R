#!/usr/bin/env Rscript

#input sources and define output
suppressPackageStartupMessages(library("argparse"))
parser <- ArgumentParser(description="")
parser$add_argument("-d", action="store", dest="disease", required=TRUE, help="Disease Samples")
parser$add_argument("-m", action="store", dest="control", required=TRUE, help="Control Samples")
parser$add_argument("-n", action="store", dest="out", required=TRUE, help="Output filename")
args <- parser$parse_args()

#read actual values from files
disease = read.csv(args$disease, header=F)
control = read.csv(args$control, header=F)
output = args$out

#convert data frame to 1-row vectors
disease = as.character(unlist(disease))
control = as.character(unlist(control))

#generate filename values
disease_filenames = paste0(disease, ".CEL.gz")
disease_filenames = paste0("GSM", disease_filenames)

control_filenames = paste0(control, ".CEL.gz")
control_filenames = paste0("GSM", control_filenames)

#merge control and disease samples/filenames into one vector
Sample = c(control, disease)
Filename = c(control_filenames, disease_filenames)

#initialize empty vector Type
Type = vector(mode = "numeric", length = 0 )

#fill in Type vector
for(element in Sample)
{
	if(element %in% control) #if control, type 1
	{
		Type = c(Type,1)
	}
	else #else is disease, type 2
	{
		Type = c(Type, 2)
	}
}

#combine vectors into matrix and transpose it
result = rbind(Sample, Filename, Type)
result = t(result)

#export to csv file
write.table(result, file = output, quote = FALSE, sep = '\t', row.names = F)
