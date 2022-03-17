

"""#!/bin/bash
#SBATCH --job-name=HISAT_BrainCortex_snakemake # Job name
#SBATCH -o slurm.%j.out                # STDOUT (%j = JobId)
#SBATCH -e slurm.%j.err                # STDERR (%j = JobId)
#SBATCH --mail-type=END,FAIL           # notifications for job done & fail
#SBATCH --mail-user=kcolney@asu.edu # send-to address
#SBATCH -n 12
#SBATCH -t 96:00:00
##SBATCH --qos=mwilsons
"""

"""source activate XY_RNA-Seq
newgrp wilsonlab"""

rule missing_file_1:
    output:
        xyonly="GRCh38.p12.genome.XYonly.fa",
        xxonly="GRCh38.p12.genome.XXonly.fa"
    conda:
        srcdir("envs/xyaline_env.yaml")
    shell:
        """xyalign --PREPARE_REFERENCE --ref /proj/regeps/regep00/studies/COPDGene/data/projectdata/rerpc/ref_index_primary_assembly/Homo_sapiens.GRCh38.dna.primary_assembly.fa --xx_ref_out {output.xxonly} --xy_ref_out {output.xyonly} --x_chromosome X --y_chromosome Y --reference_mask empty_stub.bed --output_dir ."""

rule missing_file_3:
    input:
        "gencode.v29.transcripts.fa"
    output: 
        "gencode.v29.transcripts_YPARs_masked_XY.fa"
    shell:
        """sed -e '/^>/b;205760,205886s/[ATCG]/N/g' gencode.v29.transcripts.fa > gencode.v29.transcripts_Y_PARs_masked_XY.fa;
           sed -e '/^>/b;206625,206657s/[ATCG]/N/g' gencode.v29.transcripts_Y_PARs_masked_XY.fa > gencode.v29.transcripts_YPARs_masked_XY.fa"""
            
rule decoys_ymask_x:
    """# Y masked gencode transcriptome"""
    input:
        "GRCh38.p12.genome.XXonly.fa"
    output:
        "decoys_ymask_x.txt"
    shell:
        """grep "^>" <(cat GRCh38.p12.genome.XXonly.fa) | cut -d " " -f 1 > decoys_ymask_x.txt"""

rule decoys_ymask:
    input:
        "decoys_ymask_x.txt"
    output:
        "decoys_ymask.txt"
    shell:
        """cat decoys_ymask_x.txt | sed -e 's/>//g' > decoys_ymask.txt #sed -i.bak -e 's/>//g' decoys_ymask.txt"""

rule gentrome_ymask:
    input: ["gencode.v29.transcripts_Ymasked_XX.fa", "GRCh38.p12.genome.XXonly.fa"]
    output:
        "gentrome_ymask.fa.gz"
    shell:
        """cat gencode.v29.transcripts_Ymasked_XX.fa GRCh38.p12.genome.XXonly.fa > gentrome_ymask.fa.gz"""


rule salmon_index_XX:
    input:
        ["gentrome_ymask.fa.gz", "decoys_ymask.txt"]
    output:
        "gencode_salmon_index_XXonly"
    params:
        salmon="/udd/rezxu/softwares/salmon-latest_linux_x86_64/bin/salmon"
    shell:
        """salmon index -t gentrome_ymask.fa.gz -d decoys_ymask.txt -p 12 -i gencode_salmon_index_XXonly --gencode"""

#rm decoys_ymask.txt
#rm gentrome_ymask.fa.gz

rule decoys_ypars_x:
    """# YPARs masked gencode transcriptome"""
    input:
        "GRCh38.p12.genome.XYonly.fa"
    output:
        "decoys_ypars_x.txt"
    shell:
        """grep "^>" <(cat GRCh38.p12.genome.XYonly.fa) | cut -d " " -f 1 > decoys_ypars_x.txt"""

rule decoyes_ypars:
    input:
        "decoys_ypars_x.txt"
    output:
        "decoys_ypars.txt"
    shell:
        #"""sed -i.bak -e 's/>//g' decoys_ypars.txt"""
        """cat decoys_ypars_x.txt | sed -e 's/>//g' > decoys_ypars.txt"""

rule gentrome_ypars:
    input: ["gencode.v29.transcripts_YPARs_masked_XY.fa", "GRCh38.p12.genome.XYonly.fa"]
    output:
        "gentrome_ypars.fa.gz"
    shell:
        """cat gencode.v29.transcripts_YPARs_masked_XY.fa GRCh38.p12.genome.XYonly.fa > gentrome_ypars.fa.gz"""

rule salmon_index_XY:
    input: ["gentrome_ypars.fa.gz", "decoys_ypars.txt"]
    output:
        "gencode_salmon_index_XYonly"
    params:
        salmon="/udd/rezxu/softwares/salmon-latest_linux_x86_64/bin/salmon"
    shell:
        """salmon index -t gentrome_ypars.fa.gz -d decoys_ypars.txt -p 12 -i gencode_salmon_index_XYonly --gencode"""

rule gencode_ymasked:
    input:
        "gencode.v29.transcripts.fa"
    output:
        "gencode.v29.transcripts_Ymasked.fa"
    shell:
        """sed -e '/^>/b;5566757,5586637s/[ATCG]/N/g' gencode.v29.transcripts.fa > gencode.v29.transcripts_Ymasked.fa"""

all_rulenames = [rule for rule in dir(rules) if not "__" in rule]

all_outputs = [getattr(getattr(rules, rulename),"output") for rulename in all_rulenames]

#print(all_outputs)

rule all:
    input:
        all_outputs
