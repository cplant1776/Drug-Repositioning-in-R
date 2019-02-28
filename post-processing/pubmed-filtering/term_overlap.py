from Bio import Entrez
from collections import Counter
import operator
import csv
import re
import sys

# Run example
# python3 term_overlap.py [drug term] [disease term] [# of top terms to compare from each]

def fetch_abstracts(term):
	# search
	search_handle = Entrez.esearch(db="pubmed", term=term, retmax=1000, usehistory="y")
	search_results = Entrez.read(search_handle)
	search_handle.close()

	webenv = search_results["WebEnv"]
	query_key = search_results["QueryKey"]

	# fetch
	fetch_handle = Entrez.efetch(db="pubmed", rettype="abstract",retmode="text",retmax=1000, webenv=webenv, query_key=query_key)
	abstracts = fetch_handle.read()
	fetch_handle.close()
	return abstracts

def filter_abstracts(data, stopwords):
	# remove non-alphanumeric characters
	data = data.lower()
	data = data.split()
	x = []
	for word in data:
		x.append(re.sub("[^a-zA-Z]+", "", word))
	# remove single characters
	x = [i for i in x if len(i)>1] 
	# remove stopwords
	result = ' '.join([word for word in x if word not in stopwords])
	return result

def count_words(result, out_file):
	result = result.split()
	counts = Counter(result)
	sorted_counts = sorted(counts.items(), key=operator.itemgetter(1), reverse=True)

	with open(out_file,'w') as out:
		csv_out=csv.writer(out)
		csv_out.writerow(['Word','Frequency'])
		for row in sorted_counts:
			csv_out.writerow(row)
	top_words = [x[0] for x in sorted_counts]
	return top_words


# get input drug & disease terms
drug_term = sys.argv[1]+"[abstract]"
disease_term = sys.argv[2]+"[abstract]"
num_to_compare = sys.argv[3] # if 'all', compares any and all overlap

Entrez.email = "c1188589@trbvn.com"
out_file_name = "overlap_"+sys.argv[1]+"_"+sys.argv[2]
output_file = open(out_file_name,"w")
stopword_file = open("stopwords.txt","r")

# get stopword list
my_stopwords = stopword_file.read()
my_stopwords = my_stopwords.split()

# search abstracts
drug_data = fetch_abstracts(drug_term)
disease_data = fetch_abstracts(disease_term)

# filter data for symbols/stopwords/etc.
drug_results = filter_abstracts(drug_data, my_stopwords)
disease_results = filter_abstracts(disease_data, my_stopwords)

# count word frequency and write to file
drug_count = count_words(drug_results,'wc_drug.csv')
disease_count = count_words(disease_results,'wc_disease.csv')

# take num_to_compare most frequent words from each and find overlap
if num_to_compare.isnumeric():
	top_drug_count = drug_count[0:int(num_to_compare)]
	top_disease_count = disease_count[0:int(num_to_compare)]
elif num_to_compare=='all':
	top_drug_count = drug_count
	top_disease_count = disease_count
else:
	print("3rd argument not a number or 'all'")

overlap = [word for word in top_drug_count if word in top_disease_count]
print(len(overlap))

out = '\n'.join(overlap)
output_file.write(out)
