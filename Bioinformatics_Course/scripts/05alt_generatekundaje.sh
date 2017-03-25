#!/bin/bash
#$ -N generate_kundage
#$ -q bio
#$ -t 1-24

$prefix=`head -n $SGE_TASK_ID ATACseq.prefixes.txt | tail -n 1`

echo "bds atac.bds -species dm6 -species_file ~/bio/lillyl1/ATACseq/KundajePipelineRefs/ -nth 8 -bwt2_idx /bio/lillyl1/ATACseq/KundajePipelineRefs/dm6/bowtie2_index/dm6.fa -fastq1_1 ${prefix}_F.fq.gz -fastq1_2 ${prefix}_R.fq.gz -out_dir /bio/lillyl1/ATACseq/processed_data/A4_ED_Rep2/ -gensz dm -chrsz /bio/lillyl1/ATACseq/KundajePipelineRefs/dm6/dm6.chrom.sizes -no_ataqc TRUE -title A4_ED_Rep2" >>kundaje_atac_code.txt


