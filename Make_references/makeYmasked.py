#!/usr/bin/python3
import re

# replace inputReference with either a reference genome or reference transcriptome
filepath = "inputReference.cdna.all.fa" 
# replace Output with how you want to name the output reference genome or reference transcriptome
newFile = open("Output.cdna.all.Ymasked.fa","w+")

with open(filepath, 'r') as oldFile:
    checkpoint1 = False  # checkpoint is false to begin with, only true when hits the Y chr
    for line in oldFile:  # loop through lines in fasta file
        if "chromosome:Sscrofa11.1:Y" in line: # The PARs may be noted with PAR in the transcript name
            checkpoint1 = True  # checkpoint1 is true when you reach the Y chr
        elif line.startswith(">"):
            checkpoint1 = False  # turn off replacements for lines that start with >, but not >Y

        if checkpoint1:
            newLine = re.sub(r"[ACGT]", "N", line)  # modify line to replace ACGT with N
        else:
            newLine = line  # don't modify line
        newFile.write(newLine)
newFile.close()
