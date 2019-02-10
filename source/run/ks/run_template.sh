#!/usr/bin/env bash
# vim: set noexpandtab tabstop=2:

lincslevel4='Your lincs location'
file_landmarkGenes='Your landmark genes location'

datadir='Your dataset CEL file directory'
file_metadata='Your dataset metadata location'
name_anno_lib_disease='Your platform annotation library'

outRDS='Your output RDS file name'
logs='Your run log text file name'

echo step1
nohup time Rscript multicore_kstest.R -g "$file_landmarkGenes" -d "$datadir" -m "$file_metadata" -n "$name_anno_lib_disease" -L "$lincslevel4" -o "$outRDS" &> "$logs" &
echo step2
wait $!
echo finish
