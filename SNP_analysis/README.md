# SNP analysis pipeline

This analysis is done using snippy https://github.com/tseemann/snippy

# Core genome SNP distances
1. Run snippy-multi to produce commands for all isolates to your reference.
* snippy-multi requires an input.tab file that has a line for every sample and contains the sample name and filepaths to forward and reverse reads. You can make that file easily using a while loop:
```
while read line; do echo ${line}$'\t'$(readlink -f ${line}_FW_clean.fastq)$'\t'$(readlink -f ${line}_RV_clean.fastq)>>input.tab; done<samplelist.txt
```
* Open a screen, load up an interactive session, and load up snippy using:
```
eval $( spack load --sh miniconda3 )
conda activate /ref/gdlab/software/envs/snippy

# Run snippy-multi
snippy-multi input.tab --ref <reffile.fasta> >> runme.sh
```
* copy paste the runme.sh file contents into s00_snippy_core.sh
2. s00_snippy_core.sh
* Runs the actual SNP calculations.
3. s01_parseVCF.sh/parseVCF_cluster.R
* Parses the VCF file to a more usable format by running parseVCF_cluster.R
4. s02_pairwiseDistances.sh/calcSampleDist.py
* Uses the parsed VCF file to make an organized tab-delimited file of iso1  iso2  SNPdistance
