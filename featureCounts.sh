#!/bin/bash
#SBATCH --partition=p_waksman_0
#SBATCH --job-name=featureCounts
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=5000
#SBATCH --time=12:00:00
#SBATCH --output=featurecount.slurm.%N.%j.out
#SBATCH --error=featurecount.slurm.%N.%j.err
#SBATCH --export=ALL


module purge

source ~/Programs/miniconda3/etc/profile.d/conda.sh
conda activate bioinfo

set -x

featureCounts -v

featureCounts -T 24 -p -t exon -g gene_id -s 2 --extraAttributes gene_name -a Drosophila_melanogaster.BDGP6.28.100.gtf -o sum_count.txt WT01_paired.bam WT02_paired.bam WT03_paired.bam AXXC01_paired.bam AXXC02_paired.bam AXXC03_paired.bam YRA01_paired.bam YRA02_paired.bam YRA03_paired.bam



