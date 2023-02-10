#!/usr/bin/env python3

"""
File Name    : calcSampleDist.py
Author       : Alaric D'Souza, alaric.dsouza@wustl.edu
Created On   : Wed Jun  5 02:06:27 CDT 2019
Last Modified: Wed Jun  5 02:06:37 CDT 2019

Description  :  Takes in table from parseVCF_cluster.R and outputs distances between isolates

Usage: calcSampleDist.py <input dir> <output dir>
"""
#import packages
import sys
from itertools import combinations

def getvarpos(vardict,samp1,samp2):
    """This calculates the distance between two samples in the gt dictionary.
    """
    return sum([1 for gt1,gt2 in zip(vardict[samp1],vardict[samp2]) if gt1!=gt2])

def calculateDistances(vardict):
    """This function calculates the pairwise distances for all samples in the gt dictionary
    """
    return [[samples[0],samples[1],str(getvarpos(vardict,samples[0],samples[1]))] for samples in list(combinations(vardict.keys(),2))]


def main(infile,outfile):
    #read input file to dictionary
    with open(infile,"r") as f:
        header=f.readline()
        vardict={item[0]:item[1:] for item in [line.strip().split() for line in f.readlines()]}
    #write table of pairwise distances between samples
    with open(outfile,"w+") as f:
        f.write("sample1\tsample2\tdistance\n")
        f.write("\n".join(["\t".join(line) for line in calculateDistances(vardict)]))

if __name__ == "__main__":
    print(sys.argv)
    if len(sys.argv) == 3:
        main(sys.argv[1],sys.argv[2])
    else:
        sys.stderr.write("Error: Invalid number of parameters\n")
        sys.exit(1)

