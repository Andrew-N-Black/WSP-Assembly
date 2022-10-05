#The next step is to use short-reads to further error correct an assembly. 
#This is done by aligning the Illumina reads to the draft assembly. 
#Before we could error correct with short reads, , we needed to clean the short-reads with TRIMGALORE. 
#The short reads were cleaned by running the following script:


#!/bin/bash  
#SBATCH --job-name=trimgalore  
#SBATCH -A standby  
#SBATCH -t 04:00:00  
#SBATCH -n 4  
  
cd $SLURM_SUBMIT_DIR  
  
module load bioinfo  
module load samtools  
module load BEDTools  
module load TrimGalore  
	  
cd $SLURM_SUBMIT_DIR  
  
#Make a directory to house the cleaned / cutadapt samples. Also make a directory to house the fastqc and multiqc reports  
#mkdir -p ../cleaned/fastqc_out/QC  
  
for i in $(ls -1 *_R1_*fastq.gz )  
do  
#SAMPLENAME=`echo $i | cut -c 1-6`  
R1FILE=`echo $i | sed -r 's/_R2_/_R1_/'`  
R2FILE=`echo $i | sed -r 's/_R1_/_R2_/'`  
  
  
#echo " processing ${SAMPLENAME} "  
  
# -q Trim low-quality ends from reads in addition to adapter removal. phred 20  
# run fastqc  
trim_galore --stringency 1 --cores 4  --length 30 --quality 20 --paired --fastqc -o ../cleaned ./$R1FILE ./$R2FILE  
  
done  
