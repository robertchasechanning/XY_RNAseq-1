resources manifest:



#Via email from Camily 10/17/22
cat /proj/regeps/regep00/studies/LTRC/analyses/nhclr/data/v1/freeze.10.draft.data.dictionary.2021dec20.copdgene.cmlr.txt | grep -E "X0$|XXX$|XXY$|XYY$" | cut -f 3 | cut -f 2 -d "_" > resources/aneuploiudylist.txt

also see qc_WGS_sex_COPDGene.html

for i in $(cat resources/aneuploiudylist.txt); do cat ../generate_xyrnaseq_config/results/stashq_output_manifest_all5000.txt | grep $i; done | cut -f 1 -d "," > resources/sidlist_aneuploidy.txt