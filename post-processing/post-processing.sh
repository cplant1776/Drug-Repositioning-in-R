# set inst.csv location (LINCS Level 4)
inst_dir='path/to/inst.csv'
# set irrelevant treatment location
irrelevant_dir='path/to/irrelevant.csv'

# copy Rscript to all subdirectories:
for d in */; do cp post-processing.R "$d"; done

# run Rscript in all subdirectories that do not already have a tsv file:
for dir in ./*
do
	(cd "$dir" && if [ ! -f *.tsv ]; then Rscript post-processing.R -n "$inst_dir" -L "$irrelevant_dir"; fi)
done
