##PURGE_HAPLOTIGS to identify/remove haplotypes: 
#The next step is to identify and remove haplotigs that were assembled as separate contigs:


#!/bin/sh  
#SBATCH -A fnrdewoody  
#SBATCH --time=12:00:00  
#SBATCH --job-name=purge_haplo_WS  
#SBATCH -n 50  
#SBATCH --ntasks-per-core=1  
#SBATCH --mem=0  
  
module load bioinfo  
module load purge_haplotigs/28-feb-2020  
module load minimap2/2.10  
module load BEDTools/2.26.0-35-g6114307  
module load samtools  
module load R  
#Installed ggplot2 at: ~/R/x86_64-pc-linux-gnu-library/3.4  
  
module load perl  
#required: install module FindBin, Getopt::Long, Time::Piece, threads, Thread::Semaphore, Thread::Queue, List::Util  
  
#Need to index first  
samtools faidx ./wp4.polished.fasta 
  
minimap2 -t 50 -ax sr ./wp4.polished.fasta illumina/cleaned/040524_WP4-UM_S152_R1_filtered_val_1.fq.gz illumina/cleaned/040524_WP4-UM_S152_R2_filtered_val_2.fq.gz --secondary=no  | samtools sort -m 20G > aligned.bam 

#Coverage info/histogram  
 purge_haplotigs hist -b aligned.bam  -g ./wp4.polished.fa -t 50  
#in=aligned.bam.genegov
#out=histogram.png
  
#Usage to place cutoffs based upon histogram  
purge_haplotigs  cov  -i aligned.bam.genecov  -low 10 -mid 70  -high 190 -o coverage_stats.csv -j 80 -s 80   
  
#Purge haplotigs  
purge_haplotigs purge -g ./wp4.polished.fa -c coverage_stats.csv -t 50  

#Once the haplotigs have been removed, rename the curate file for input into BLOBTOOLS (to identify contaminants).
mv curated.fasta wp4.polished.purged.fasta 
