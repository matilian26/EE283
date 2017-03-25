#!/bin/bash

FILES=/bio/lillyl1/EE283/Bioinformatics_Course/data/od_rawdata/*/DNAseq/*SANGER.fq.gz
for f in $FILES
do
    mv $f "$(dirname $(dirname "$f"))/DNAseq.SANGER"
done
