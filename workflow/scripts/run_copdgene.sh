#TODO: find some way of specifying the conda environment directory
#TODO: replace home directory ${HOME} with /udd/${me} or vice versa
#TODO: Curate the options for generating 

export study=copdgene
export me=`whoami`
export yamllist_arg=$1
export currdir=`pwd`
export snakemakedir=/d/tmp/regeps/regep00/studies/pilots/analyses/rerpc/xyrnaseq_rna_mrna_redld/XY_RNAseq/
export snakefile=${snakemakedir}/Processing/COPDGene_freeze5.Snakefile
export projectprefix=xyrnaseq_rna_mrna_redld
export condadir=/proj/relibs/relib00/conda/bin/activate
export condaenv="--use-conda --conda-prefix /udd/rerpc/snakemake"
export loopstart=`date +"%Y_%m_%d_%H_%M_%S"`
export docsdir=/d/tmp2/log/rerpc/logs_xyrnaseq_rerpc_${loopstart}
export logdir=$docsdir
export jobname="--jobname {name}.{jobid}_snakejob.sh"
source ${condadir} sm6

if [ ! -d logs ]; then mkdir logs; fi
if [ ! -d ${docsdir} ]; then mkdir ${docsdir}; fi
if [ ! -d ${logdir} ]; then mkdir ${logdir}; fi

#export clustersettings="qsub -l lx7,virtual_free=100G,12hour=true -p ${study} -cwd -S /bin/bash -v PATH -o ${logdir} -e ${logdir}"
#export clustersettings_longterm="qsub -l lx7,virtual_free=100G -p ${study} -cwd -S /bin/bash -v PATH -o ${logdir} -e ${logdir}"
export profile=/udd/rerpc/repos/snakemake_profiles/channing_mrna_rnaseq_alignment/
export profile_longterm=$profile
export alignment_config_name=alignment_config.yaml

echo "transferqc_yaml: ${transferyamlfile}" > ${alignment_config_name}
echo "project_hotfix: COPDGene" >> ${alignment_config_name}
echo "projectYaml: ${projectyaml}" >> ${alignment_config_name}
echo "study: ${study}" >> ${alignment_config_name}

echo "adding Dublin Core Metadata to configuration file..."
echo "dublin_Contributor: blank" >> ${alignment_config_name}
echo "dublin_Coverage: blank" >> ${alignment_config_name}
echo "dublin_Creator: blank" >> ${alignment_config_name}
echo "dublin_Date: blank" >> ${alignment_config_name}
echo "dublin_Description: blank" >> ${alignment_config_name}
echo "dublin_Format: blank" >> ${alignment_config_name}
echo "dublin_Identifier: blank" >> ${alignment_config_name}
echo "dublin_Language: blank" >> ${alignment_config_name}
echo "dublin_Publisher: blank" >> ${alignment_config_name}
echo "dublin_Relation: blank" >> ${alignment_config_name}
echo "dublin_Rights: blank" >> ${alignment_config_name}
echo "dublin_Source: blank" >> ${alignment_config_name}
echo "dublin_Subject: blank" >> ${alignment_config_name}
echo "dublin_Title: blank" >> ${alignment_config_name}
echo "dublin_Type: blank" >> ${alignment_config_name}

echo "recording commit hash for current workflow run in config yaml..." 
export returnhere=`pwd`;
cd ${snakemakedir};
export revhash=`git rev-parse development`
cd ${returnhere};
echo "rnaseq_hash: ${revhash}" >> ${alignment_config_name}
	
echo "creating timestamped logfile ${batchdesignation}"
export logfile=${projectprefix}_xyrnaseq_smk.log
export logfilepath=${docsdir}/${logfile}

echo "skipping unlock all ${batchdesignation}"
snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name} ${condaenv} --unlock -n -p all  2>&1 | tee -a ${logfilepath} #unlock and show dry run

echo "Generating dag run metrics"
snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name} --profile ${profile_longterm} -p -n --dag --keep-going all ${condaenv} | tee ${logdir}/dag_all.txt
cat ${logdir}/dag_all.txt | dot -Tsvg | tee ${logdir}/dag_all.svg

snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name} --profile ${profile_longterm} -p -n --rulegraph --keep-going all ${condaenv} | tee ${logdir}/rulegraph_all.txt
cat ${logdir}/rulegraph_all.txt | dot -Tsvg | tee ${logdir}/rulegraph_all.svg

echo "running pipeline..."
snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name} --profile ${profile_longterm} -p --keep-going all ${condaenv} 2>&1 | tee -a ${logfilepath};

export returnhere=`pwd`;
cd ${snakemakedir};
git add -u;
git commit -m "automatically committing code upon run...";
#git push;
cd ${returnhere};

cat ${logfilepath} | grep 'ERROR' | grep 'executing rule'
ls ${logdir}/*
echo ${logfilepath}
