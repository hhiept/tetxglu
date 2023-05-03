#!/bin/bash
#SBATCH --partition=p_waksman_0
#SBATCH --job-name=hisat2
#SBATCH --nodes=1
#SBATCH --ntasks=3
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4000
#SBATCH --time=12:00:00
#SBATCH --output=hisat2.slurm.%N.%j.out
#SBATCH --error=hisat2.slurm.%N.%j.err
#SBATCH --export=ALL

set -x

cd /scratch/hht25/gse101/trim/fastq_trim/paired/
idx=/home/hht25/src/hisat2/bdgp6_source/genome.fa
ids=/home/hht25/src/hisat2/ids
mkdir -p bam


module purge

source ~/Programs/miniconda3/etc/profile.d/conda.sh
conda activate bioinfo

hisat2 --version


cat $ids | parallel --delay 0.2 -j $SLURM_NTASKS "hisat2 -p 8 -q -x $idx --novel-splicesite-outfile bam/{}_novel.splice.out.txt --rna-strandness RF -1 {}_1_paired.fq.gz -2 {}_2_paired.fq.gz -S bam/{}_paired.sam"

echo 'hisat2 completed!'

wait

samtools --version

cat $ids | parallel --delay 0.2 -j 9 "samtools sort bam/{}_paired.sam > bam/{}_paired.bam"

wait

cat $ids | parallel --delay 0.2 -j 9 "samtools index bam/{}_paired.bam"


echo 'sort and index completed!'





