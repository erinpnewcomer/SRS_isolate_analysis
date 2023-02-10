# SNP analysis pipeline

This analysis is done using snippy https://github.com/tseemann/snippy

# Core genome SNP distances
1. Run snippy-multi to produce commands for all isolates to your reference.
* copy paste the runme.sh file contents into s00_snippy_core.sh
2. s00_snippy_core.sh
* Runs the actual SNP calculations.
3. s01_parseVCF.sh/parseVCF_cluster.R
* Parses the VCF file to a more usable format by running parseVCF_cluster.R
4. s02_pairwiseDistances.sh
* Uses the parsed VCF file to make an organized tab-delimited file of iso1  iso2  SNPdistance
