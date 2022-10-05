#POLCA to polish the assembly with cleaned short-reads 
 #Now that the Illumina short reads were cleaned, the next step was to polish the assembly. 
 #Three total iterations of polishing were performed. Each iteration was ‘uncommented’ prior to re-submitting the job.

#!/bin/bash  
#SBATCH --job-name=polca_1  
#SBATCH -A fnrdewoody  
#SBATCH -t 14-00:00:00  
#SBATCH -n 40  
#SBATCH --ntasks-per-core=1  
#SBATCH --mem=0  
  
cd $SLURM_SUBMIT_DIR  
  
module load bioinfo  
module load bwa  
module load samtools  
module load boost/1.64.0  
  
#Usage:    
#polca.sh -a <assembly contigs or scaffolds> -#r <'Illumina_reads_fastq1 Illumina_reads_fastq'> t <number of threads>
# [n] <optional:do not fix errors that are found> [m] <optional: memory per thread 
#to use in samtools sort> 

#First iteration 
/home/blackan/MaSuRCA-3.4.1/bin/polca.sh -a ../../pacbio/Pupfish_Redbean_90X_arrow_2cells.fasta -r '040524_WP4-UM_S152_R1_filtered_val_1.fq.gz 040524_WP4-UM_S152_R2_filtered_val_2.fq.gz' -t 40  
  

#Second iteration  
/home/blackan/MaSuRCA-3.4.1/bin/polca.sh -a ./Pupfish_Redbean_90X_arrow_2cells.fasta.PolcaCorrected.fa -r '040524_WP4-UM_S152_R1_filtered_val_1.fq.gz 040524_WP4-UM_S152_R2_filtered_val_2.fq.gz' -t 40   
  
#Third iteration  
/home/blackan/MaSuRCA-3.4.1/bin/polca.sh -a ./Pupfish_Redbean_90X_arrow_2cells.fasta.PolcaCorrected.fa.PolcaCorrected.fa -r '040524_WP4-UM_S152_R1_filtered_val_1.fq.gz 040524_WP4-UM_S152_R2_filtered_val_2.fq.gz' -t 40 
#Once the third iteration is done, rename the final output:
mv Pupfish_Redbean_90X_arrow_2cells.fasta.PolcaCorrected.PolcaCorrected.PolcaCorrected.fa ./wp4.polished.fasta
