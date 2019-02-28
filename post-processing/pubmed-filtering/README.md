## term_overlap.py Readme

**Overview**
This Python script is for finding common words between two search terms in PubMed abstracts. The file queries PubMed for abstracts relating to each term independently, filters out provided stop words from each set, performs a word frequency count on the remaining words, and then finds the overlap between the two term sets. Output is three text files: the overlap list, the frequency count for drug term, and the frequency count for disease term.

**Usage**

```bash
python3 term_overlap.py [term1] [term2] [# of top terms]
```

##### Example

```bash
python3 term_overlap.py trprostinil huntington 500
```

This will perform queries on the terms "treprostinil" and "huntington" and then find the overlap in the 500 most frequent words of each terms' set. In this case, there are 36 words in the overlap (prints to terminal). If you want to list ALL overlapping terms, enter 'all' as the 3rd argument.

To add stopwords, simply add the words (one per line) to `stopwords.txt`

**Problems and Potential Improvements**
The largest issue currently faced is the stopwords list. The original stopwords list was created by querying 1000 random PubMed abstracts and performing a word frequency count on them. However, a lot of irrelevant terms still make it through the filter and time is too short to create a better list.

As an alternative to this scripts approach, I began looking into existing medical term databases. Rather than removing irrelevant words, the idea would be to compare words to those listed in the medical database' lexicon such that the results would only have medically relevant terms. To that end, I contacted UMLS Metathesaurus about getting access to their lexicon, but it looks like they will not respond until after the project is over.

**Requirements**

#### Packages

```
Biopython, Counter, operator, csv, re, sys
```

##### Python Version

```
Python 3.X
```



