#!/bin/bash
#$ -N SNP_call
#$ -q abio,bio,free64
#$ -pe make 8 
#$ -R y
#$ -t 1-4

module load bwa/0.7.8
module load samtools/1.3
module load bcftools/1.3
module load enthought_python/7.3.2
module load java/1.7
module load gatk/2.4-7
module load picard-tools/1.87
module load bowtie2/2.2.7
module load tophat/2.1.0
module load bamtools/2.3.0        # bamtools merge is useful
module load freebayes/0.9.21      # fasta_generate_regions.py is useful
module load vcftools/0.1.15

# find /bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/aligned_data -name "DNAseq" > DNAseq.RG.directories.txt

ref="/bio/lillyl1/Classes/EE283/Bioinformatics_Course/ref/dm6.fa"
input_dir=`head -n $SGE_TASK_ID DNAseq.RG.directories.txt | tail -n 1`
output_dir=$(echo $input_dir | sed 's/aligned_data/analyzed_data/')

mkdir -p "$output_dir"

java -d64 -jar /data/apps/picard-tools/1.87/MergeSamFiles.jar $(printf 'I=%s ' $input_dir/*.RG.bam) SO=coordinate AS=true O=$output_dir/merged.bam
samtools index $output_dir/merged.bam
java -d64 -Xmx128g -jar /data/apps/gatk/2.4-7/GenomeAnalysisTK.jar -T RealignerTargetCreator -nt 8 -R $ref -I $output_dir/merged.bam --minReadsAtLocus 4 -o $output_dir/merged.intervals
java -d64 -Xmx20g -jar /data/apps/gatk/2.4-7/GenomeAnalysisTK.jar -T IndelRealigner -R $ref -I $output_dir/merged.bam -targetIntervals $output_dir/merged.intervals -LOD 3.0 -o $output_dir/merged-realigned.bam
java -d64 -Xmx128g -jar /data/apps/gatk/2.4-7/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt 8 -R $ref -I $output_dir/merged-realigned.bam -gt_mode DISCOVERY -stand_call_conf 30 -stand_emit_conf 10 -o $output_dir/rawSNPS-Q30.vcf
java -d64 -Xmx128g -jar  /data/apps/gatk/2.4-7/GenomeAnalysisTK.jar -T UnifiedGenotyper -nt 8 -R $ref -I $output_dir/merged-realigned.bam -gt_mode DISCOVERY -glm INDEL -stand_call_conf 30 -stand_emit_conf 10 -o $output_dir/inDels-Q30.vcf
java -d64 -Xmx20g -jar /data/apps/gatk/2.4-7/GenomeAnalysisTK.jar -T VariantFiltration -R $ref -V $output_dir/rawSNPS-Q30.vcf --mask $output_dir/inDels-Q30.vcf --maskExtension 5 --maskName InDel --clusterWindowSize 10 --filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterName "BadValidation" --filterExpression "QUAL < 30.0" --filterName "LowQual" --filterExpression "QD < 5.0" --filterName "LowVQCBD" --filterExpression "FS > 60" --filterName "FisherStrand" -o $output_dir/Q30-SNPs.vcf
cat $output_dir/Q30-SNPs.vcf | grep 'PASS\|^#' > $output_dir/pass.SNPs.vcf
cat $output_dir/inDels-Q30.vcf | grep 'PASS\|^#' > $output_dir/pass.inDels.vcf
# it I want to display in SCGB I have to bgzip and tabix (part of samtools), see lecture 4
# oddly bgzip is not the same as gzip and tabix is only for indexing bgzip, and SCGB can only deal with bgzip
# the reasons behind this are discussed in the Buffalo book (but basically bgzip indexes on several defined columns)
# may as well run this now
bgzip -c $output_dir/pass.SNPs.vcf >$output_dir/pass.SNPs.vcf.gz
tabix -p vcf $output_dir/pass.SNPs.vcf.gz
bgzip -c $output_dir/pass.inDels.vcf >$output_dir/pass.inDels.vcf.gz
tabix -p $output_dir/pass.inDels.vcf.gz
