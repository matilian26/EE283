#!/bin/bash
#$ -N align_RNA
#$ -q abio,bio,free64
#$ -pe make 8 
#$ -R y
#$ -t 1-38

while read dir; do
    chmod a+x $dir
done <SCGB.directories.txt

source_folder='/bio/lillyl1/ATACseq/processed_data/A4_ED_Rep2'
partialpathtofile=`head -n $SGE_TASK_ID SCGB.files.txt | tail -n 1`
dest_folder='/pub/public-www/lillyl1'

chmod a+r $source_folder/$partialpathtofile
mkdir -p $dest_folder/$(dirname $partialpathtofile)
ln -s $source_folder/$partialpathtofile $dest_folder/$partialpathtofile
