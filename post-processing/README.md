## post-processing.sh Readme
**Overview**
This script will perform post-processing on all RDS files in the immediate subdirectories. Post processing involves:

1. Mapping treatment IDs to drug names (found in inst.csv from LINCS Level 4)
2. Filtering out irrelevant treatments (found in irrelevant.csv)
3. Returning tsv files with the top-scoring up and down regulated drugs and their scores
4. Graphing the raw distribution of scores as well as graphing the distribution of the top-scoring down-regulated drugs

**Usage**

1. Make sure that the targeted RDS files are located in their own subdirectory beneath where the script is located

2. Set paths to LINCS Level 4 and irrelevant treatment CSV files in `post-processing.sh`

3. Ensure generate_meta.sh has run permissions

   ```bash
   chmod +x post-processing.sh
   ```

4. Run the script

   ```bash
   ./post-processing.sh
   ```

**Run the shell script in the directory above where the RDS file it located.** It will first copy the post-processing R-script to each subdirectory. Next, it will check each subdirectory and run the script if there is no TSV file. Because the script can take over a minute to complete for each RDS, it was important to make sure it did not run on results that had already been processed.

**Required Packages**

```
plyr, ggplot2, data.table, argparse
```
