#TODO: find some way of specifying the conda environment directory
#TODO: replace home directory ${HOME} with /udd/${me} or vice versa
#TODO: Curate the options for generating 

export study=copdgene
export me=`whoami`
export yamllist_arg=$1
export currdir=`pwd`
export github=git@changit.bwh.harvard.edu:rerpc/channing_mrna_rnaseq_alignment.git
export snakemakedir=/udd/rerpc/repos/channing_mrna_rnaseq_alignment/
export snakefile=${snakemakedir}/workflow/rnaseq.smk
export snakefile_advanced=${snakemakedir}/workflow/rnaseq.smk
export projectprefix=COPDGene_rna_mrna_repjc
export genome=grc38withSJDB_2pass;
export genomedesignation=grch38
export envmod="--use-envmodules"
export condaenv="--use-conda --conda-prefix /udd/rerpc/snakemake"
export condadir=/proj/relibs/relib00/conda/bin/activate
export loopstart=`date +"%Y_%m_%d_%H_%M_%S"`
export repodir=/udd/rerpc/repos/channing_mrna_rnaseq_alignment/
export docsdir=/d/tmp2/log/rerpc/logs_rnaseq_rerpc_${loopstart}
export logdir=$docsdir
export jobname="--jobname {name}.{jobid}_snakejob.sh"
source ${condadir}
conda activate sm6

for transferyamlfile in `cat ${yamllist_arg}`; do
    export batchdesignation=`cat ${transferyamlfile} | grep seqbatchid | cut -f 2 -d ":" | xargs`;
    export seqbatchid=`cat ${transferyamlfile} | grep seqbatchid | cut -f 2 -d ":" | xargs`;
    export projectyaml=analyses/rnaseq_configuration.yaml #${projectprefix}${batchdesignation}.yaml;
    echo ${batchdesignation};
    cd batch_${batchdesignation};
#    cd channing_mrna_rnaseq_alignment;
    if [ ! -d logs ]; then mkdir logs; fi
    if [ ! -d ${docsdir} ]; then mkdir ${docsdir}; fi
        export logdir=/d/tmp2/log/rerpc/logs_rnaseq_rerpc_${loopstart}
        if [ ! -d ${logdir} ]; then mkdir ${logdir}; fi
        #export clustersettings="qsub -l lx7,virtual_free=100G,12hour=true -p ${study} -cwd -S /bin/bash -v PATH -o ${logdir} -e ${logdir}"
        #export clustersettings_longterm="qsub -l lx7,virtual_free=100G -p ${study} -cwd -S /bin/bash -v PATH -o ${logdir} -e ${logdir}"
        export profile=/udd/rerpc/repos/snakemake_profiles/channing_mrna_rnaseq_alignment/
	export profile_longterm=/udd/rerpc/repos/snakemake_profiles/channing_mrna_rnaseq_alignment_longterm/
	export profile_longterm=/udd/rerpc/repos/channing_mrna_rnaseq_alignment/genericproject_12hour_envmod
        export alignment_config_name=alignment_config.yaml
        echo "transferqc_yaml: ${transferyamlfile}" > ${alignment_config_name}
        echo "project_hotfix: COPDGene" >> ${alignment_config_name}
	echo "projectYaml: ${projectyaml}" >> ${alignment_config_name}
	echo "genome: ${genome}" >> ${alignment_config_name}
	echo "seqbatchid: ${seqbatchid}" >> ${alignment_config_name}
	echo "batch: batch_${batchdesignation}" >> ${alignment_config_name}
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
	export returnhere=`pwd`;
	cd ${snakemakedir};
	export revhash=`git rev-parse development`
	cd ${returnhere};
	echo "rnaseq_hash: ${revhash}" >> ${alignment_config_name}
	
        echo "skipping unlock all ${batchdesignation}"
        #snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name} ${condaenv} --unlock -n -p all  2>&1 | tee -a ${logfilepath} #unlock and show dry run
	echo "rnaseq configuration ${batchdesignation}"
        snakemake --snakefile ${snakefile} --cores 1 --configfiles ${alignment_config_name} --latency-wait 300 -p --keep-going analyses/rnaseq_configuration.yaml 2>&1 | tee -a ${logfilepath} #generate configuration
	echo "sample config file ${batchdesignation}"
	snakemake --snakefile ${snakefile} --cores 1 --configfiles ${alignment_config_name} --latency-wait 300 -p --keep-going sample_config_file.txt  2>&1 | tee -a ${logfilepath} #generate sample config
	echo "skipping star alignment, rsubreads star, salmon ${batchdesignation}"
	#        snakemake --snakefile ${snakefile} --config --configfiles ${alignment_config_name} ${envmod} --profile ${profile} --jobs 40 --latency-wait 300 -p --keep-going star_alignment rsubreads_star salmon_driver  2>&1 | tee -a ${logfilepath} #generate alignments
	echo "skipping star alignment, rsubreads star, salmon ${batchdesignation}"
        ##snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name} --profile ${profile} --jobs 40 --latency-wait 300 -p --keep-going star_alignment rsubreads_star salmon_driver  2>&1 | tee -a ${logfilepath} #generate alignments
	echo "salmon ${batchdesignation}"
        snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name} --profile ${profile_envmod} --jobs 40 --latency-wait 300 -p --keep-going salmon_driver  2>&1 | tee -a ${logfilepath} #generate alignments
	echo "skipping rsubreads only ${batchdesignation}"
	#    snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name} ${condaenv} --latency-wait 300 -p --keep-going rsubreads  2>&1 | tee -a ${logfilepath}#Generate rsubreads count files
	echo "skipping generate app ${batchdesignation}"
	#snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name} ${condaenv} --latency-wait 300 -n -p --keep-going --summary analyses/${seqbatchid}/${genomedesignation}_gtf/qc_app/app.R
	export prefix="COPDGene"
        export bamfiletsv=analyses/shiny_star_pe_${seqbatchid}/${genomedesignation}_gtf/qc_app/rnaseq_qc_app/data/${prefix}_${seqbatchid}_${genomedesignation}_gtf/BAM_file.tsv
        #export metrics=analyses/shiny_star_${seqbatchid}/${genomedesignation}_gtf/qc_app/rnaseq_qc_app/data/${prefix}_${seqbatchid}_${genomedesignation}_gtf/metrics.tsv
        export metrics=analyses/qc/rnaseqc_pe_star_all_karyotypic_${genomedesignation}_gtf/metrics.tsv
        #export samplesex=analyses/shiny_star_${seqbatchid}/${genomedesignation}_gtf/qc_app/rnaseq_qc_app/data/${prefix}_${seqbatchid}_${genomedesignation}_gtf/sampleSex.txt
        export samplesex=analyses/qc/qc_star_gender_samplesex_${seqbatchid}_${genomedesignation}_gtf.txt
	export provenance_file=analyses/COPDGene_rna_mrna_rnaseq_provenance_batch_${seqbatchid}_${genomedesignation}_gtf.yaml
	echo "skipping creating bamfile tsv file without cluster ${batchdesignation}"
#        snakemake --snakefile ${snakefile_advanced} --cores 1 --config transferqc_yaml=${transferyamlfile} projectYaml=${projectyaml} genome=${genome} seqbatchid=${seqbatchid} batch=batch_${batchdesignation} --jobs 40 --latency-wait 300 -p --keep-going ${bamfiletsv} ${samplesex}

	#echo "skipping creating dag, filegraph and rulegraph ${batchdesignation} for metrics"
        #snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name}  --profile ${profile_longterm} --jobs 40 --latency-wait 300 -p -n --filegraph --keep-going ${samplesex} ${bamfiletsv} ${metrics} ${condaenv} | tee ${logdir}/filegraph_run_metrics.txt
	#cat ${logdir}/filegraph_run_metrics.txt | dot -Tsvg | tee ${logdir}/filegraph_run_metrics.svg
	#snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name}  --profile ${profile_longterm}" --jobs 40 --latency-wait 300 -p -n --dag --keep-going ${samplesex} ${bamfiletsv} ${metrics} ${condaenv} | tee ${logdir}/dag_run_metrics.txt
	#cat ${logdir}/dag_run_metrics.txt | dot -Tsvg | tee ${logdir}/dag_run_metrics.svg
	#snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name}  --profile ${profile_longterm} --jobs 40 --latency-wait 300 -p -n --rulegraph --keep-going ${samplesex} ${bamfiletsv} ${metrics} ${condaenv} | tee ${logdir}/rulegraph_run_metrics.txt
	#cat ${logdir}/rulegraph_run_metrics.txt | dot -Tsvg | tee ${logdir}/rulegraph_run_metrics.svg

	echo "creating timestamped logfile ${batchdesignation}"
        export rightnow=`date +"%Y_%m_%d_%H_%M_%S"`
        export logfile=${projectprefix}_${seqbatchid}_${rightnow}_rnaseq_smk.log
        export logfilepath=${docsdir}/${logfile}

        echo "creating bamfile tsv and metrics file along with provenance file with cluster ${batchdesignation}"
        snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name}  --profile ${profile_longterm} --jobs 40 --latency-wait 300 -p --touch --keep-going ${samplesex} ${bamfiletsv} ${metrics} ${condaenv} 2>&1 | tee -a ${logfilepath};
        snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name}  --profile ${profile_longterm} --jobs 40 --latency-wait 300 -p --rerun-incomplete --keep-going ${samplesex} ${bamfiletsv} ${metrics} ${condaenv} 2>&1 | tee -a ${logfilepath};

	snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name} --profile ${profile} --jobs 40 --latency-wait 300 -p --keep-going --unlock ${provenance_file} ${condaenv} 2>&1 | tee -a ${logfilepath}
	snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name}  --profile ${profile} --jobs 40 --latency-wait 300 --touch -p --keep-going --rerun-incomplete ${jobname} ${provenance_file} ${condaenv} 2>&1 | tee -a ${logfilepath}
	snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name}  --profile ${profile} --jobs 40 --latency-wait 300 -p --keep-going --rerun-incomplete ${jobname} ${provenance_file} ${condaenv} 2>&1 | tee -a ${logfilepath}

        export collation=output_summary_provenance_copdgene_collation
	
        snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name}  --profile ${profile} --jobs 40 --latency-wait 300 -p --debug-dag --keep-going --rerun-incomplete ${jobname} ${collation} ${condaenv} 2>&1 | tee -a ${logfilepath}

	echo "creating dag, filegraph and rulegraph ${batchdesignation} for collation"
        snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name}  --profile ${profile_longterm} --jobs 40 --latency-wait 300 -p -n --filegraph --keep-going ${collation} ${condaenv} | tee ${logdir}/filegraph_run.txt
	cat ${logdir}/filegraph_run.txt | dot -Tsvg | tee ${logdir}/filegraph_run.svg
	snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name}  --profile ${profile_longterm} --jobs 40 --latency-wait 300 -p -n --dag --keep-going ${collation} ${condaenv} | tee ${logdir}/dag_run.txt
	cat ${logdir}/dag_run.txt | dot -Tsvg | tee ${logdir}/dag_run.svg
	snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name}  --profile ${profile_longterm} --jobs 40 --latency-wait 300 -p -n --rulegraph --keep-going ${collation} ${condaenv} | tee ${logdir}/rulegraph_run.txt
	cat ${logdir}/rulegraph_run.txt | dot -Tsvg | tee ${logdir}/rulegraph_run.svg

	
	export returnhere=`pwd`;
	cd ${repodir};
	git add -u;
	git commit -m "automatically committing code upon run...";
	#git push;
	cd ${returnhere};
    echo "skipping Creating bamfile tsv and metrics file: ${metrics} ${bamfiletsv} ${batchdesignation}"
    ##snakemake --snakefile ${snakefile_advanced} --configfiles ${alignment_config_name} ${condaenv}  --profile ${profile_longterm} --jobs 40 --latency-wait 300 -p --keep-going ${bamfiletsv} ${metrics}  2>&1 | tee -a ${logfilepath}
    export multiqchtml=${multiqchtml_prefix}.html
    echo "skipping creating multiqc ${multiqchtml} with snakemake ${batchdesignation}"
    export multiqchtml_prefix=analyses/qc/multiqc/${seqbatchid}_${genomedesignation}_gtf_multiqc_report

    #snakemake --snakefile ${snakefile_advanced} --configfiles ${alignment_config_name} --jobs 40 --latency-wait 300 -n -p --keep-going ${multiqchtml}  2>&1 | tee -a ${logfilepath}#this generates multiqc data
    #conda activate multiqc_III
    #multiqc -n ${multiqchtml_prefix}_multiqc_report -o analyses/qc/multiqc/ analyses/.  2>&1 | tee -a ${logfilepath}
    #conda activate sm5
    echo "skipping snakemake auto-creation of conversion file ${batchdesignation}"
    #snakemake --snakefile ${snakefile} --configfiles ${alignment_config_name} ${condaenv}  --profile ${profile} --jobs 40 --latency-wait 300 -p --keep-going analyses/${seqbatchid}/${genomedesignation}_gtf/conversion_file.txt 2>&1 | tee -a ${logfilepath}
    cat ${logfilepath} | grep 'ERROR' | grep 'executing rule'
    ls ${logdir}
    echo ${logfilepath}
    cd ${currdir};
done
