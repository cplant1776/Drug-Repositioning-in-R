## Drug Repositioning in R Using Gene Expressions

This project contains scripts we used in an attempt to practice [Drug Repositioning](https://www.sciencedirect.com/topics/medicine-and-dentistry/drug-repositioning): the process of using FDA-approved drugs for new purposes to lower R&D time and risk. It makes extensive use of Bash scripting and R and was intended for use in a Linux environment. The repository was never meant for use outside of our group's project, and as such it was not designed for easy use by third-parties. Still, readme files are included for each piece of the project.

## Motivation

This project was part of a semester-long special topics course in R. The objective of the course was to teach the students the fundamentals of R by using it to complete a project. 

My group of four chose to explore [Drug Repositioning](https://www.sciencedirect.com/topics/medicine-and-dentistry/drug-repositioning) as our project. Drug Repositioning is the process of trying to find new applications for drugs that have already been approved for clinical use. In doing so, pharmaceutical companies could save ~three years of R&D costs, because the drugs have already passed the first phase of clinical trials. 

For example, Pfizer's Sildenafil was originally studied for use in hypertension and angina pectoris. It failed its objective during Phase I clinical trials, but was found effective for treating erectile disfunction. Viagra made its way to the market shortly after.

We took a two-pronged approach to drug repositioning:

1. Myself and another member focused on using publicly-available gene expression data [similar to this study](https://www.ncbi.nlm.nih.gov/pubmed/17008526/) for Drug Repositioning, **which is what this repository contains**
2. The other two members of the group used a [Genome-wide association study (GWAS)](https://en.wikipedia.org/wiki/Genome-wide_association_study) approach, [similar to this study](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5724196/)

## The Process

### Overview

Our approach was to create a [connectivity map](https://www.ncbi.nlm.nih.gov/pubmed/17008526) and then do manual research on the most promising drugs/treatments in an attempt to confirm the validity of the results.

Steps:

1. Curate appropriate disease and control gene expression data from [the Gene Expression Omnibus (GEO)](https://www.ncbi.nlm.nih.gov/geo/) for a target disease
2. Use similarity algorithms (we tested with both [the Kolmogorov-Smirnov Test](https://en.wikipedia.org/wiki/Kolmogorov%E2%80%93Smirnov_test) and the [eXtreme Sum](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4278345/)) to find gene expression similarity. The goal is to determine which gene expressions are up and down regulated by the disease/drug
3. Compare the expression profiles. Which drugs most closely down-regulate genes that are up-regulated by a disease, or vice versa?
4. Filter out irrelevant results
5. Rank drugs by viability
6. Do manual research into the most promising candidates to test the validity of the results

### How it Played Out

The reality played out quite similar to the steps outlined above. We gathered appropriate samples for a disease, ran it through the pipeline on a powerful server, then manually researched to verify the validity of the results.

Validation came in a few forms. The strongest indicator of success was when we found that our drug candidate had already been discovered and was being used for treatment of the disease. Failing that, we delved deeper into PubMed in an attempt to find any similar biological mechanisms between our target disease and the drug's current treatment disease. To cut down on manual labor, I [created a script to query PubMed extracts searching for overlapping terms]("https://github.com/cplant1776/Drug-Repositioning-in-R/post-processing/pubmed filtering"). Given more time, a process utilizing natural language processing would have been ideal.

## Usage

1. [Generate a metadata file to pass to the script](https://github.com/cplant1776/Drug-Repositioning-in-R/pre-processing/metadata)
2. [Pass the samples and metadata through the script](https://github.com/cplant1776/Drug-Repositioning-in-R/source/run/)
3. [Run the results through post-processing](https://github.com/cplant1776/Drug-Repositioning-in-R/post-processing)
4. Check the results for validity

## Results

We had time to run ten different diseases through the pipeline. Of those, two were undeniably successful because we found that the drug candidate had already been repurposed for the target disease. Five did not have an obvious connection because the connection had not been directly researched, but had suggestions in other research that a connection might exist. These results are stretching a bit, but not outright wrong. 

Three of the diseases found an odd connection that could be a legitimate find, or could just be coincidence/model error. For example, for Fanconi Anaemia ( a hereditary bone-marrow disease), several estrogen receptor regulators showed up in the top results for both similarity algorithms. We could find no information suggesting why this might be the case.