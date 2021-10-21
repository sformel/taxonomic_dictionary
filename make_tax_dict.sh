#!/bin/bash

mkdir tax_files
cd tax_files

#Get latest taxonomy from the Genome Taxonomy Database (GTDB)
#I wasn't able to figure out a way to use wildcards, so you can check to see if
#it's the latest version if you're stressing about it.

wget https://data.gtdb.ecogenomic.org/releases/latest/ar122_taxonomy.tsv
wget https://data.gtdb.ecogenomic.org/releases/latest/bac120_taxonomy.tsv

#Get taxonomy from Global Biodiversity Information Facility (GBIF).  Not sure if this is 
#always where the latest one will live.
wget -O https://hosted-datasets.gbif.org/datasets/backbone/col-names.txt.gz | gunzip -c > col-names.txt

#Get National Center for Biotechnology Information (NCBI) taxonomy
wget https://ftp.ncbi.nih.gov/pub/taxonomy/new_taxdump/new_taxdump.zip
unzip new_taxdump.zip

#Process
cut -f 2 ar122_taxonomy.tsv | cut -d ';' -f 1,2,3 | tr -d 'd_pc' | tr ';' '\n' | sort | uniq > tax.dic
cut -f 2 bac120_taxonomy.tsv | cut -d ';' -f 1,2,3 | tr -d 'd_pc' | tr ';' '\n' | sort | uniq >> tax.dic
cut -d '|' -f 2 names.dmp | cut -d ' ' -f 1,2 | tr -d '\t"()?' | tr ' ' '\n' | tr -d "'" | sort | uniq >> tax.dic
cut -f 4 col-names.txt | tr ' ' '\n' | tr -d "'\t()?" | sort | uniq >> tax.dic

cat tax.dic | sort | uniq > Taxa_Dictionary.dic

#Mac
cp Taxa_Dictionary.dic /Users/$(whoami)/Library/Group\ Containers/*\.Office/

#Windows - not tested
#copy Taxa_Dictionary.dic C:\Users\whoami\AppData\Roaming\Microsoft\UProof

cd ..
rm -r tax_files

#If MS Word was left open, restart to have changes take effect
