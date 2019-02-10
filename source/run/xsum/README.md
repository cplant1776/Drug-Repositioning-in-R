## run_template.sh README

**Overview**

This is the workhorse script for the entire project. See [the main readme](https://github.com/cplant1776/drug_repositioning) for a an explanation of what the script accomplishes. Essentially, this attempts to create a [connectivity map](https://www.broadinstitute.org/connectivity-map-cmap) to find potential new uses for drugs. We feed it disease and control samples, attempt to find which expressions are up-regulated by the disease, and find drugs/treatments that are known to down-regulate those same expressions. We implemented two versions using different similarity scoring algorithms:

1. [Kolmogorov-Smirnov test (K-S Test)](https://en.wikipedia.org/wiki/Kolmogorov%E2%80%93Smirnov_test#Two-sample_Kolmogorov%E2%80%93Smirnov_test)
2. [eXtreme Sum (Xsum)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4278345/)

**Usage**

1. Set the variables in `run_template.sh` for the targeted disease

   * lincslevel4 = [path to [LINCS Level 4 data](http://www.lincsproject.org/LINCS/tools/workflows/find-the-best-place-to-obtain-the-lincs-l1000-data) (.gctx)]
   * file_landmarkGenes = [path to landmark genes data (.xlsx)]
   * datadir = [path to directory where output is placed]
   * file_metadata = [path to metadata for samples (.csv)]
   * name_anno_lib_disease = [[platform annotation library](https://bioconductor.org/packages/3.8/data/annotation/)]
   * outRDS = [name of output RDS file (.rds)]
   *  logs = [name of run log output file (.txt)]

   

2. Make sure run_template.sh has run permissions

   ```bash
   chmod +x run_template.sh
   ```

3. Run the script. I **HIGHLY RECOMMEND** running it from a [Screen](https://linuxize.com/post/how-to-use-linux-screen/) and detaching because it takes so long to run on the server. If you don't, then all progress will be lost if the SSH connection is interrupted.

   ```bash
   screen -S session_name
   ./generate_meta.sh
   ```

   

The two input csv files are just comma-seperated lists of the control and disease GSM numbers. These are generated in R once the correct GSM numbers are identified.

**Output**

The script outputs a R data structure (.rds) that is meant to be passed through post-processing before it is useful. [See the post-processing subdirectory for details](https://github.com/cplant1776/drug_repositioning/post-processing).

**Required Packages**

```
affy, annotate, argparse, hgu133plus2.db, limma, parallel, rhdf5, samr, xlsx
```
