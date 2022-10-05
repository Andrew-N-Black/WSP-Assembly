#To replicate the  methods on nuclear DNA between Cyprinodontoformes with a reference genome, the following commands were executed:
#This will extract 3kb sequences from reference genome and blast it, then parse the results
#Extract contigs greater than 3kb from pupfish assembly    
splitter -sequence wp4.polished.purged.decon.auto.fasta -size 30000 -outseq tularosa_30kb.fasta    
#Once the genomes were split, each genome was processed using the following script:

#!/bin/bash  
#SBATCH --job-name=var_blastn  
#SBATCH -A fnrgenetics  
#SBATCH -t 12-00:00:00  
#SBATCH -n 5  
  
cd $SLURM_SUBMIT_DIR  
  
module load bioinfo  
module load blast/2.10.0+  
module load openmpi/1.10.7   
  
#makeblastdb -in ./variegatus_30kb.fasta -dbtype nucl  
  
blastn -db ./variegatus_30kb.fasta -query ./tularosa_30kb.fasta -num_threads 5 \  
  -out tularosa_variegatus_2blast_strand_cull.tsv \  
  -outfmt '6 qseqid sseqid length evalue pident nident mismatch gapopen gaps qstart qend qlen sstart send slen score bitscore qseq sseq' \  
  -perc_identity 3 -qcov_hsp_perc 3 -max_target_seqs 1 -culling_limit 1 -evalue 50 -max_hsps 1 -strand minus  

#Now, several columns need to be extracted from the output blast file before parsing out each blast hit:
# Use awk to extract queryid,subjectid, query seq, subject seq:  
awk '{print $1,$2,$18,$19}' tularosa_variegatus_2blast_strand_cull.tsv  > to.parse parse  
  
#Split output file into individual lines:  
split -l 1 --numeric-suffixes=1 --additional-suffix=.txt --suffix-length=6 to.parse ''  
#Make a list of these files to feed into R  
ls -1 *.txt > list.txt  
  
