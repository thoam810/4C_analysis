#4C_analysis

4C seq differentiation analysis of WT K562 and cohesin mutant K562 cells: non-differentiated (12 hours DMSO treatment), 12 hours Phorbol 12-myristate 13-acetate (PMA) treatment, 72 hours PMA treatment

Baits used: Runx1 Promoter 1 (Runx1P1), Runx1 Promoter 2 (Runx1P2), Runx1 Enhancer +24 (Runx124), Erg Enhancer +85 (Erg85)

Software required:
 Bowtie2
 devtools
 BiocManager
 geneplotter
 genefilter
 DESeq2
 4Cker
 fastqc
 mnormt

Processing 4C data:
 In Unix
 
1. Concatenating files
 - Samples were sequenced using HiSeq2500 100bp single end reads on two lanes to join reads for the different lanes concatenate file was used: Concatenate_seq_bash
 
 This created output files:
 
 (Sample_name)_fastq.gz e.g S16_fastq.gz

2. Demultiplexing samples using the 4 baits/primers (Runx1P1 Runx124 Runx1P2 Erg85) and 2 restriction enzyme (RE) sites: demux_4C_hiseq_2.sh 
 ./demux_4C_hiseq_2.sh
 - Need to have file of primers pairs used. 
 - Name of file: Amarni_4C_Primers.txt - this is a tabulated file with 3 columns : Name of the primer pair \t fwd primer sequence \t rev primer sequence
 
 This created the output files: 
 
 (Sample_name)_(bait name)_(direction).fastq e.g S16_Runx124_rev.fastqc.

3. Generate read counts and data quality reports. 
 - To check the quality and number of initial reads and compare to the demultiplexed reads FASTQC_analysis_bash was used. 
 
 This created the output files:
 
 initial reads:
 (Sample name)_fastq_fastqc.zip e.g S16_fastq_fastqc.zip
 (Sample name)_fastq_fastqc.html e.g S16_fastq_fastqc.html
 
 demultiplexed reads:
 (Sample name)_(bait name)_(direction)_fastq_fastqc.zip e.g S16_Runx124_rev_fastqc.zip
 (Sample name)_(bait name)_(direction)_fastq_fastqc.html e.g S16_Runx124_rev_fastqc.html

4. Generate restriction enzyme (RE) digestion of Human Genome.
 - to map reads to regions of  Homo sapiens reference genome (hg19), the genome was digested using 4Cker_script and restriction enzyme (RE) digestion of Human  Genome file
 - use file: RE_digest_genome
 - edited 4Cker_script: reduced_genome_2.sh
 - Ch38 reference genome file from O'Sullivan lab: GCA_000001405.15_GRCh38_no_alt_analysis_set.fa
 - hg19 reference genome file from GATK (broad institute): hg19.fa
 - DpnII digestion file from 4Cker: dpnii.fa
 - Csp6I digestion file from 4Cker: csp6i.fa
 RE= Restriction Enzyme
 frag-len = fragment length chosen
 
 This created the output files:
 
 (Reference genome)_(RE)_flanking_sites_(frag-len)_unique.bed e.g hg19_dpnii_flanking_sites_70_unique.bed
 (Reference genome)_(RE)_flanking_sites_(frag-len)_.fa e.g hg19_dpnii_flanking_sites_70_unique.fa

5. Generate Bowtie2 files of RE digested genome. Bowtie2 is builds it’s own files for the digested DpnII or CpsI genome, this will result in 6 files
 - use file bowtie2_build
 
 This created the output files:
 
 (Reference genome)_(RE)_flanking_sites_(frag-len)_unique.1.bt2 e.g hg19_dpnii_flanking_sites_70_unique.1.bt2
 (Reference genome)_(RE)_flanking_sites_(frag-len)_unique.2.bt2 e.g hg19_dpnii_flanking_sites_70_unique.2.bt2
 (Reference genome)_(RE)_flanking_sites_(frag-len)_unique.3.bt2 e.g hg19_dpnii_flanking_sites_70_unique.3.bt2
 (Reference genome)_(RE)_flanking_sites_(frag-len)_unique.4.bt2 e.g hg19_dpnii_flanking_sites_70_unique.4.bt2
 (Reference genome)_(RE)_flanking_sites_(frag-len)_unique.rev.1.bt2 e.g hg19_dpnii_flanking_sites_70_unique.rev.1.bt2
 (Reference genome)_(RE)_flanking_sites_(frag-len)_unique.rev.2.bt2 e.g hg19_dpnii_flanking_sites_70_unique.rev.2.bt2

6. Align reads to Bowtie2 RE genome
  - use file Alignment_bowtie
  
 This created the output files:
 
 (Sample name)_(bait name)_(direction)_(re)_hg19_aligned.sam e.g S16_Runx124_rev_dpnii_hg19_aligned.sam
 (Sample name)_(bait name)_(direction)_(re)_hg19_unaligned.sam e.g S16_Runx124_rev_dpnii_hg19_unaligned.sam

7. Create a counts file from mapped data (SAM file output from bowtie2)
 - use file mapped_data_counts_bedGraph
 
 This created the output files:
 
 (Sample name)_(bait name)_(direction)_(re)_hg19_aligned.bedGraph e.g S16_Runx124_rev_dpnii_hg19_aligned.bedGraph
 (Sample name)_(bait name)_(direction)_(re)_hg19_unaligned.sam e.g S16_Runx124_rev_dpnii_hg19_unaligned.bedGraph

8. Removing the self-ligated and undigested fragments
 - use file remove_self_ligated_undigested
 
 This created the output files:
 
 (Sample name)_(bait name)_(direction)_(re)_hg19_aligned_rm_self_und.bedGraph e.g S37_Runx124_rev_dpnii_hg19_aligned_rm_self_und.bedGraph

9. Remove fragments that had reads in the control files
 - use file remove_controls
 
 This created the output files:
(Sample name)_(bait name)_(direction)_(re)_65_aligned_rm_self_und.bedGraph e.g S37_Runx124_rev_dpnii_65_aligned_rm_self_und.bedGraph
S16_Runx124_rev_dpnii_hg19_aligned_rem_con.bedGraph

10. Remove fragments 10kb up and downsteam of the bait.
- use file remove_bait_10kb

11. Analysing 4C interactions
 - use files Analysing_4C_interactions

12. Generate R ggplots of 4C interactions
 - use file 4C_ggplots

13. Differential analysis between different conditions (nearbait and cis)
 - use file DESeq_diff_analysis
 
14. Map to gene list
 - use file map_gene_list


