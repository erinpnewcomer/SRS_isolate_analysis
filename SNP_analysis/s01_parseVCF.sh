#!/bin/bash
#===============================================================================
#
# File Name    : s01_parseVCF.sh
# Description  : This script will parse merged vcf files
# Usage        : sbatch s01_parseVCF.sh
# Author       : Alaric D'Souza
# Version      : 1.2
# Created On   : Tue Jun  4 04:35:21 CDT 2019
# Last Modified: 2023-02-10
# Modified By  : Erin Newcomer
#===============================================================================
#
#Submission script for HTCF
#SBATCH --time=0-00:00:00 # days-hh:mm:ss
#SBATCH --job-name=parseMergedVCF
#SBATCH --cpus-per-task=1
#SBATCH --mem=30G
#SBATCH --output=slurm_out/parse_mergedVCF/z2_parse_%a.out
#SBATCH --error=slurm_out/parse_mergedVCF/z2_parse_%a.out

eval $( spack load --sh /7anzvct )

#basedir if you want
basedir="$PWD"
indir="${basedir}"
outdir="${basedir}/d10_snippy"

echo "Started: `date`"
echo "Host: `hostname`"

echo "Threads: ${SLURM_CPUS_PER_TASK}"

#start debug mode (will send commands to outfile)
set -x

Rscript parseVCF_cluster.R ${indir}/core.vcf ${outdir}/core_snps_parsed.txt 

#save error code for command
RC=$?
#exit debug mode
set +x

#output if job was successful
if [ $RC -eq 0 ]
then
  echo "Job completed successfully"
else
  echo "Error Occurred!"
  exit $RC
fi

