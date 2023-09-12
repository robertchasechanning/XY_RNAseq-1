# 39 placentas - Pisarska 
# 17 females
# 22 males 


#   "females": ["SRR6463487", "SRR6463488", "SRR6463489", "SRR6463490", "SRR6463491", "SRR6463492", "SRR6463493", "SRR6463494", 
# 			"SRR6463495", "SRR6463496", "SRR6463497", "SRR6463498", "SRR6463499", "SRR6463500", "SRR6463501", "SRR6463502", "SRR6463503"],

# _HISAT_transcriptCounts_XX.txt
  
  
#  "males": ["SRR6463504", "SRR6463505", "SRR6463506", "SRR6463507", "SRR6463508", "SRR6463509", "SRR6463510", "SRR6463511", "SRR6463512", 
#  		"SRR6463513", "SRR6463514", "SRR6463515", "SRR6463516", "SRR6463517", "SRR6463518", "SRR6463519", "SRR6463520", "SRR6463521", 
# 		"SRR6463522", "SRR6463523", "SRR6463524", "SRR6463525"],

# _HISAT_transcriptCounts_XY.txt

cut -f7 SRR6463487_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp1
cut -f7 SRR6463488_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp2
cut -f7 SRR6463489_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp3
cut -f7 SRR6463490_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp4
cut -f7 SRR6463491_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp5
cut -f7 SRR6463492_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp6
cut -f7 SRR6463493_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp7
cut -f7 SRR6463494_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp8
cut -f7 SRR6463495_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp9
cut -f7 SRR6463496_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp10
cut -f7 SRR6463497_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp11
cut -f7 SRR6463498_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp12
cut -f7 SRR6463499_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp13
cut -f7 SRR6463500_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp14
cut -f7 SRR6463501_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp15
cut -f7 SRR6463502_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp16
cut -f7 SRR6463503_HISAT_transcriptCounts_XX.txt  | sed 1d > tmp17

cut -f7 SRR6463504_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp18
cut -f7 SRR6463505_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp19
cut -f7 SRR6463506_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp20
cut -f7 SRR6463507_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp21
cut -f7 SRR6463508_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp22
cut -f7 SRR6463509_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp23
cut -f7 SRR6463510_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp24
cut -f7 SRR6463511_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp25
cut -f7 SRR6463512_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp26
cut -f7 SRR6463513_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp27
cut -f7 SRR6463514_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp28
cut -f7 SRR6463515_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp29
cut -f7 SRR6463516_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp30
cut -f7 SRR6463517_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp31
cut -f7 SRR6463518_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp32
cut -f7 SRR6463519_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp33
cut -f7 SRR6463520_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp34
cut -f7 SRR6463521_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp35
cut -f7 SRR6463522_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp36
cut -f7 SRR6463523_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp37
cut -f7 SRR6463524_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp38
cut -f7 SRR6463525_HISAT_transcriptCounts_XY.txt  | sed 1d > tmp39

# ALL 
paste tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 tmp10 tmp11 tmp12 tmp13 tmp14 tmp15 tmp16 tmp17 tmp18 tmp19 tmp20 tmp21 tmp22 tmp23 tmp24 tmp25 tmp26 tmp27 tmp28 tmp29 tmp30 tmp31 tmp32 tmp33 tmp34 tmp35 tmp36 tmp37 tmp38 tmp39 > placenta_pisarska_RNA_HISAT_FC_strandedRF_transcriptCounts_FandM.tsv


# females XX
paste tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 tmp10 tmp11 tmp12 tmp13 tmp14 tmp15 tmp16 tmp17   > placenta_pisarska_RNA_HISAT_FC_strandedRF_transcriptCounts_female.tsv

# males XY 
paste tmp18 tmp19 tmp20 tmp21 tmp22 tmp23 tmp24 tmp25 tmp26 tmp27 tmp28 tmp29 tmp30 tmp31 tmp32 tmp33 tmp34 tmp35 tmp36 tmp37 tmp38 tmp39 > placenta_pisarska_RNA_HISAT_FC_strandedRF_transcriptCounts_male.tsv
