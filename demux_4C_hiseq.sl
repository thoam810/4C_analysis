#!/bin/bash

# loading scripts and environment:
#Rfoursig=/mnt/projects/amarni_4c/code_from_judith/fourSig_processing.R
demuxBin=/mnt/projects/amarni_4c/code_from_judith/demux_hiseq.plx
primerFile=/mnt/projects/amarni_4c/code_from_judith/Amarni_4C_Primers.txt
seqDir=/mnt/projects/amarni_4c/OG4533BP2/OG4533BP2_fastq/
outputDir=/mnt/projects/amarni_4c/OG4533BP2/data_processing/
#TTAAsites=/mnt/projects/amarni_4c/code_from_judith/TTAA_sites_all.txt
#GTACsites=/mnt/projects/amarni_4c/code_from_judith/GTAC_sites_all.txt
# getting sample number from taskID:

for sample in S16_fastq.gz S17_fastq.gz S18_fastq.gz S19_fastq.gz S20_fastq.gz S21_fastq.gz S22_fastq.gz S23_fastq.gz S24_fastq.gz S25_fastq.gz S26_fastq.gz S27_fastq.gz S28_fastq.gz S29_fastq.gz S30_fastq.gz S31_fastq.gz S32_fastq.gz S33_fastq.gz S34_fastq.gz S35_fastq.gz S36_fastq.gz S37_fastq.gz
do
	#echo "Processing: $sample"
	R1filefastq=$seqDir/$sample
	#echo "Single End Read Fastq: $R1filefastq"
	if [ -e $R1filefastq ];then
	   samplename="${sample%_*.*}"
	   for primer in Runx1P1 Runx124 Runx1P2 Erg85
	   do
		primer1_tmp=$(grep $primer $primerFile | cut -f 2)
		primer2_tmp=$(grep $primer $primerFile | cut -f 3)
		outname1="${samplename}_${primer}_fwd.fastq"
		outname2="${samplename}_${primer}_rev.fastq"
		echo "zcat $R1filefastq | grep -i --no-group-separator -A 2 -B 1 \"^$primer1_tmp\" > $outname1;"
		echo "zcat $R1filefastq | grep -i --no-group-separator -A 2 -B 1 \"^$primer2_tmp\" > $outname2;"
	    #echo $R1filefastq $samplename p $primer p1 $primer1_tmp p2 $primer2_tmp o1 $outname1 o2 $outname2
	   done
	   #echo demux: $demuxBin -o $outputDir -n $samplename -f $R1filefastq -r $R2filefastq -s TTAA -p $primerFile
	   #srun $demuxBin -o $outputDir -n $samplename -f $R1filefastq -r $R2filefastq -s TTAA -p $primerFile
	   #echo demux: $demuxBin -o $outputDir -n $samplename -f $R1filefastq -p $primerFile -s GATC
	   #srun $demuxBin -o $outputDir -n $samplename -f $R1filefastq -p $primerFile -s GATC
	   #echo demux done for $samplename!
	   
	   # multilpe bam per condition:
	else 
	   echo missing $R1filefastq
	fi
done

