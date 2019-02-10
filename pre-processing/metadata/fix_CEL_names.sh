# This command should remove excess characters from CEL file names in the same working directory
# eg. GSM101010_unneeded_info37.CEL.gz --> GSM101010.CEL.gz

# Notes: This will act on all files that start with "GSM" in the directory.
# It will replace the files it affects, so I would make sure there is a
# backup copy incase the naming scheme encountered does not work with the command.

for i in GSM*; do mv $i ${i/_*./.CEL.}; done;
