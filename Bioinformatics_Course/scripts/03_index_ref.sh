#!/bin/bash
#$ -N index
#$ -q class8-intel,bio,free64
#$ -t 1-4

module load enthought_python/7.3.2
module load bwa/0.7.8
module load samtools/1.3
module load bcftools/1.3
module load gatk/2.4-7
module load picard-tools/1.87
module load java/1.7
module load bowtie2/2.2.7

`head -n $SGE_TASK_ID 03_index_ref_commands.txt | tail -n 1`
