#!/bin/bash
#SBATCH --partition=p_waksman_0
#SBATCH --job-name=trimmomotic
#SBATCH --nodes=1
#SBATCH --ntasks=3
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2000
#SBATCH --time=12:00:00
#SBATCH --output=AXXC.slurm.%N.%j.out
#SBATCH --error=AXXC.slurm.%N.%j.err
#SBATCH --export=ALL

set -x

cd /scratch/hht25/gse101/fastq_raw

ids_trim=/home/hht25/src/trimmomatic/ids_trim
ids=/home/hht25/src/trimmomatic/ids

module purge

source ~/Programs/miniconda3/etc/profile.d/conda.sh
conda activate bioinfo

echo 'trimmomatic version'

trimmomatic -version


cat $ids_trim | parallel --delay 0.2 -j $SLURM_NTASKS "trimmomatic PE -threads 8 -phred33 -trimlog trim.log {}02_1.fq.gz {}02_2.fq.gz {}02_1_paired.fq.gz {}02_1_unpaired.fq.gz {}02_2_paired.fq.gz {}02_2_unpaired.fq.gz ILLUMINACLIP:/home/hht25/src/trimmomatic/Novogene-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36"

cat $ids_trim | parallel --delay 0.2 -j $SLURM_NTASKS "trimmomatic PE -threads 8 -phred33 -trimlog trim.log {}03_1.fq.gz {}03_2.fq.gz {}03_1_paired.fq.gz {}03_1_unpaired.fq.gz {}03_2_paired.fq.gz {}03_2_unpaired.fq.gz ILLUMINACLIP:/home/hht25/src/trimmomatic/Novogene-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36"

cat $ids_trim | parallel --delay 0.2 -j $SLURM_NTASKS "trimmomatic PE -threads 8 -phred33 -trimlog trim.log {}01_L1_1.fq.gz {}01_L1_2.fq.gz {}01_L1_1_paired.fq.gz {}01_L1_1_unpaired.fq.gz {}01_L1_2_paired.fq.gz {}01_L1_2_unpaired.fq.gz ILLUMINACLIP:/home/hht25/src/trimmomatic/Novogene-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36"

cat $ids_trim | parallel --delay 0.2 -j $SLURM_NTASKS "trimmomatic PE -threads 8 -phred33 -trimlog trim.log {}02_L1_1.fq.gz {}02_L1_2.fq.gz {}02_L1_1_paired.fq.gz {}02_L1_1_unpaired.fq.gz {}02_L1_2_paired.fq.gz {}02_L1_2_unpaired.fq.gz ILLUMINACLIP:/home/hht25/src/trimmomatic/Novogene-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36"

cat $ids_trim | parallel --delay 0.2 -j $SLURM_NTASKS "trimmomatic PE -threads 8 -phred33 -trimlog trim.log {}01_1.fq.gz {}01_2.fq.gz {}01_1_paired.fq.gz {}01_1_unpaired.fq.gz {}01_2_paired.fq.gz {}01_2_unpaired.fq.gz ILLUMINACLIP:/home/hht25/src/trimmomatic/Novogene-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36"

echo 'trimmomatic completed!'

wait

mkdir -p fastqc_trim

fastqc -V

cat $ids | parallel --delay 0.2 -j $SLURM_NTASKS "fastqc -o fastqc_trim {}_1_paired.fq.gz {}_2_paired.fq.gz {}_1_unpaired.fq.gz {}_2_unpaired.fq.gz"

echo 'fastqc_trim completed!'






