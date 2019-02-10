## generate_meta.sh README

**Overview**

This script takes two csv files as input (disease GSE numbers, control GSE numbers) and returns a metadata tsv file with a list of samples and created filenames. An example of the output format is given at the bottom of this document. Type 1 indicates a control sample, and type 2 indicates a disease sample. Example input CSVs can be found in the directory.

**Usage**

1. Set the variables in `generate_meta.sh`

   * disease = [path to disease csv]
   * control = [path to control csv]
   * out = [path to output file]

2. Make sure generate_meta.sh has run permissions

   ```bash
   chmod +x generate_meta.sh
   ```

3. Run the script

   ```bash
   ./generate_meta.sh
   ```

   

The two input csv files are just comma-seperated lists of the control and disease GSM numbers. These are generated in R once the correct GSM numbers are identified.

**Output Format**

Below is an example of what the output file will look like.

Sample	Filename	Type

XXXXX	GSMXXXXX.CEL.gz	1

XXXXY	GSMXXXXY.CEL.gz	1

...

YXYYY	GSMYXYYY.CEL.gz	2

**Required Packages**

```
argparse
```

