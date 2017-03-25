#!/bin/bash
#$ -N update_phredscores
#$ -q class8-intel,bio,free64,abio
#$ -t 1-24

filename=$(head -n $SGE_TASK_ID DNAseq.files.txt | tail -n 1)
mkdir -p $(dirname $(dirname $filename))/DNAseq.SANGER
/bio/lillyl1/Classes/EE283/programs/seqtk/seqtk seq -Q64 -V $(readlink $filename) | gzip -c > $(echo $filename | sed 's/DNAseq/DNAseq.SANGER/')
