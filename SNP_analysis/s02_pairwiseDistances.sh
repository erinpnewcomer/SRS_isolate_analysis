#!/bin/bash
#===============================================================================
#
# File Name    : s02_pairwiseDistances.sh
# Description  : This script will calculated pairwise SNP distances from parsed VCF files.
# Usage        : sbatch s02_pairwiseDistances.sh 
# Author       : Alaric D'Souza
# Version      : 1.1
# Created On   : Tue Jun  4 04:35:21 CDT 2019
# Last Modified: Fri Feb  10 12:01:06 CDT 2023
# Modified By  : Erin Newcomer
#===============================================================================
#
#Submission script for HTCF
#SBATCH --time=0-00:00:00 # days-hh:mm:ss
#SBATCH --job-name=pairwiseDistances
#SBATCH --cpus-per-task=1
#SBATCH --array=1
#SBATCH --mem=8G
#SBATCH --output=slurm_out/pairwiseDistances/z_pairwiseDist_%a.out
#SBATCH --error=slurm_out/pairwiseDistances/z_pairwiseDist_%a.err

eval $( spack load --sh  python@3.9.12 )

#basedir if you want
basedir="${PWD}"
indir="${basedir}/d10_snippy"
outdir="${basedir}/d10_snippy"

echo "Started: `date`"
echo "Host: `hostname`"

echo "Threads: ${SLURM_CPUS_PER_TASK}"

#start debug mode (will send commands to outfile)
set -x

python3 calcSampleDist.py ${indir}/core_snps_parsed.txt ${outdir}/core_pairwise_dist.txt

#save error code for command
RC=$?
#exit debug mode
set +x

#output if job was successful
if [ $RC -eq 0 ]
then
  echo "Job completed successfully"
else
  echo "Error Occured!"
  exit $RC
fi
