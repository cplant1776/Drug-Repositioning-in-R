#!/usr/bin/env bash
# vim: set noexpandtab tabstop=2:

disease='sample_disease_input.csv' #disease list
control='sample_control_input.csv' #control list
out='metadata.csv' #output file

Rscript generate_meta.R -d "$disease" -m "$control" -n "$out"
