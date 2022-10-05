##MITOBIM to assemble Mitochondrial genome ##
 
#To generate a mitochondrial genome assembly, cleaned Illumina paired-end reads were first mapped to C. diabolis, 
#filtered for only those that aligned, converted back to fastq format, interleaved, and processed with MITOBIM.
#!/bin/bash  
#SBATCH --job-name=mito_pupfish5_MT  
#SBATCH -A fnrquail  
#SBATCH -t 14-00:00:00  
#SBATCH -n 10  
#SBATCH --mem=100G  
  
module purge  
module load bioinfo  
module load MITObim/1.8  
module load bioinfo  
module load bwa  
module load picard-tools  
module load bedops  
module load GATK/3.6.0  
module load samtools  
export PATH=/home/blackan/CoalQC/scripts/:$PATH  
export coalpath=/home/blackan/CoalQC/scripts  
cd $SLURM_SUBMIT_DIR  

#Map to congener
coalqc map -g ../../diabolis_MT.fasta -f ./040524_WP4-UM_S152_R1_filtered_val_1.fq.gz -r ./040524_WP4-UM_S152_R2_filtered_val_2.fq.gz -p mapped_mt -n 10  
  
#Filter to only keep mapped reads
samtools view -b -F 4 mapped_mt.bam > mapped_F_mt.bam  
  
#Convert interleaved files over to fastq  
samtools bam2fq ./mapped_F_mt.bam > mapped_mt.fastq  
  
#modify headers for forward and paired reads  
#cat mapped_mt.fastq | grep '^@.*/1$' -A 3 --no-group-separator > mapped_r1.fastq  
#cat mapped_mt.fastq | grep '^@.*/2$' -A 3 --no-group-separator > mapped_r2.fastq  
  
#Interleave mapped fastq paired-end reads  
interleave-fastqgz-MITOBIM.py ../cleaned/mapped_r1.fastq.gz ../cleaned/mapped_r2.fastq.gz > pupfish_interleaved.fastq   
  
#Run mitobim with congener mt genome with pupfish reads that ONLY mapped to it (mapped_mt.fastq)  
MITObim.pl -start 1 -end 150 -sample wp4 -ref diabolis -readpool ../cleaned/mapped_mt.fastq --quick diabolis.fasta --trimoverhang --clean &> log5 #use previous iteration as reference with pacbio reads 
