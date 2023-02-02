#!/bin/bash
#===============================================================================
# Name         : s00_trimmomatic.sh
# Description  : This script will run trimmomatic on samples in parallel
# Usage        : sbatch s00_trimmomatic.sh
# Author       : Erin Newcomer, erin.newcomer@wustl.edu
# Version      : 1
# Created On   : 2021_09_23
# Modified On  : Thu Sep 23 10:20:27 CDT 2021
#===============================================================================
#
#Submission script for HTCF
#SBATCH --job-name=trimmomatic
#SBATCH --array=1-8
#SBATCH --mem=8G
#SBATCH --output=slurm_out/trimmomatic/z_trim_%a.out
#SBATCH --error=slurm_out/trimmomatic/z_trim_%a.out

eval $( spack load --sh trimmomatic )

adapt="/opt/apps/trimmomatic/0.38/adapters/NexteraPE-PE.fa"
basedir="/scratch/gdlab/path/to/dir"
indir="${basedir}/d00_rawreads"
outdir="${basedir}/d01_cleanreads"

mkdir -p ${outdir}

export JAVA_ARGS="-Xmx8000M"

# samplelist.txt contains a list of all file names
sample=`sed -n ${SLURM_ARRAY_TASK_ID}p ${basedir}/samplelist.txt`

# R1 = fwd and R2 = rev
# P = paired, UP = unpaired
set -x
time java -jar $TRIMMOMATIC_HOME/trimmomatic-0.38.jar \
    PE \
    -phred33 \
    -trimlog \
    ${outdir}/Paired_${sample}_trimlog.txt \
    ${indir}/${sample}_R1.fastq \
    ${indir}/${sample}_R2.fastq \
    ${outdir}/${sample}_FW_clean.fastq \
    ${outdir}/${sample}_FW_clean_UP.fastq \
    ${outdir}/${sample}_RV_clean.fastq \
    ${outdir}/${sample}_RV_clean_UP.fastq \
    ILLUMINACLIP:${adapt}:2:30:10:1:true \
    SLIDINGWINDOW:4:20 \
    LEADING:10 \
    TRAILING:10 \
    MINLEN:60
RC=$?
set +x

# combine unpaired reads into a single fastq
cat ${outdir}/${sample}_FW_clean_UP.fastq ${outdir}/${sample}_RV_clean_UP.fastq > ${outdir}/${sample}_UP_clean.fastq
rm ${outdir}/${sample}_FW_clean_UP.fastq
rm ${outdir}/${sample}_RV_clean_UP.fastq 

if [ $RC -eq 0 ]
then
  echo "Job completed successfully"
else
  echo "Error Occurred!"
  exit $RC
fi
