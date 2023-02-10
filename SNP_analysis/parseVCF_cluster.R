#!/usr/bin/env Rscript

#File Name    : parseVCF_cluster.R
#Author       : Alaric D'Souza, alaric.dsouza@wustl.edu
#Created On   : Wed Jun  5 02:05:20 CDT 2019
#Last Modified: Wed Jun  5 02:05:26 CDT 2019
#Description  :  Takes in table from parseVCF_cluster.R and outputs distances between isolates
#Usage: parseVCF_cluster.R <inputfile path (VCF)> <outputfile path (TXT)>


#read in arguments from command line
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)!=2) {
  stop("Incorrect number of arguments supplied. Usage: parseVCF_cluster.R <inputfile path (VCF)> <outputfile path (TXT)>", call.=FALSE)
}

#install and load required package
#install.packages("vcfR")
#library("vcfR",lib.loc="/opt/apps/labs/gdlab/software/awd-scripts/1.0/Rlibs")
library("vcfR")

#set input and output files from command line arguments
infile <- args[1]
outfile <- args[2]

#read in vcf file
vcf<-read.vcfR(infile)

#extract genotype information
gt<-extract.gt(vcf, 
               element = "GT", 
               mask = FALSE, 
               as.numeric = FALSE, 
               return.alleles = FALSE, 
               IDtoRowNames = TRUE, 
               extract = TRUE, 
               convertNA = TRUE)

#set NA positions to 0/0 in gt matrix
gt[is.na(gt)]<-"0/0"

#change from dipload to haploid format
gtParsed<-substr(gt,1,1)

#write out variant tables
write.table(t(gtParsed),
              outfile,
              sep="\t",
              quote=F)

