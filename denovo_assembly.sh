#convert bam files to fastq format 
bam2fastq -o output_prefix prefix_subreads.xml   

#Fastq files were then pooled together and filtered with SEQKIT to remove reads  <1kb and >50kb.
seqkit seq -m 1000 -M 50000 in.fastq > out.fastq  

#REDBEAN assembly at different coverage levels (50,90x) 
 
#REDBEAN (wtdbg) was then used to assemble the reads using the following options (Coverage subsampled to 50,90X):

#50x coverage subsampling  
wtdbg2 -x sq -g 1g -t 36 -X 50 -i out.fastq -fo out_prefix  
wtpoa-cns -t 36 -i out_prefix.ctg.lay.gz -fo out_prefix_50.ctg.fa  
#Run time was 18 hours and max RAM usage was 200GB.  

#90x coverage subsampling  
wtdbg2 -x sq -g 1g -t 36 -X 90 -i out.fastq -fo out_prefix  
wtpoa-cns -t 36 -i out_prefix.ctg.lay.gz -fo out_prefix_90.ctg.fa
#Run time was 22 hours and max RAM usage was 200GB.  

#ARROW to polish the assembly using long-reads 
 
#The first step in using long-reads to error correct an assembly is to align the subreads to the raw assembly. 
#This was done using minimap2 (well actually Pacbio’s version of it):
pbmm2 align ref.fa subreads_bam.xml subreads_aligned_sorted.bam --preset SUBREAD --sort -j 32 -J 8 > pbmm2.log 2>&1  

#The raw assembly was then polished with "GCPP/ARROW" from SMRT Link v8.0 with 36 CPUs
gcpp --algorithm=arrow --log-level INFO --log-file gcpp.log -j 36 subreads_aligned_sorted.bam -r ref.fa -o polished.fasta  

