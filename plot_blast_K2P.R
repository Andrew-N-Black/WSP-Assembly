#This will take output from blast and calcualte distance and plot  
#Load modules:   
module load bioinfo ; module load R  
  
  
#Run Rscript by:  
Rscript k2p.R  

#Begin Rscript  
setwd("/scratch/snyder/b/blackan/k2_genomes/chunk_100kb")  
  
#install.packages("ape", lib="/scratch/snyder/b/blackan/rlibs/", repos='http://cran.us.r-project.org')  
#.libPaths("/scratch/snyder/b/blackan/rlibs/")   
  
#install.packages("PopGenome", lib="/scratch/snyder/b/blackan/rlibs/", repos='http://cran.us.r-project.org')  
#.libPaths("/scratch/snyder/b/blackan/rlibs/")   
  
library(ape)  
alignments = read.table("list.tsv", sep="\t")  
colnames(alignments) = c("sp1_sp2")  
  
#iterate over alignments list and estimate divergence  
write.table(t(c( "spp", "length", "raw", "K80", "K81", "F84", "TN93")), "DNAdiv_estimates.csv", sep=",", row.names=F, col.names=F, append=F)  
write.table(t(c("starting loop")), "DNAdiv_watch.csv", sep=",", row.names=F, col.names=F, append=F)  
for(f in 1:nrow(alignments)){  
  # read in each data file  
  data = read.table(paste(alignments$sp1_sp2[f]), sep=" ", header=F)  
  colnames(data) = c("query_contig", "subject_scaffold", "query_seq", "subject_seq")  
  # remove alignments less than 2000bp  
  # print summary statistics to stdout  
  print(paste("alignment: ", alignments$sp1_sp2[f]))  
    
  
#prep aligned sequences  
s = strsplit(paste(data$subject_seq, "", collapse=""), "")  
q = strsplit(paste(data$query_seq, "", collapse=""), "")  
  
temp = as.DNAbin(c(s, q))  
write.table(paste("created DNAbin for", as.character(alignments$sp1_sp2[f])), "DNAdiv_watch.csv", sep=",", row.names=F, col.names=F, append=T)  
  
#estimate divergences  
raw = K80 = K81 = F84 = TN93 = NULL  
raw = dist.dna(temp, model=c("raw"), variance = T)  
K80 = dist.dna(temp, model=c("K80"), variance = T)  
K81 = dist.dna(temp, model=c("K81"), variance = T)  
F84 = dist.dna(temp, model=c("F84"), variance = T)  
TN93 = dist.dna(temp, model=c("TN93"), variance = T)  
#cat(str(K80)); cat(str(K81)); cat(str(raw)); cat(str(F84)); cat(str(TN93))  
write.table(paste("Finished total calculations for", as.character(alignments$sp1_sp2[f])), "DNAdiv_watch.csv", sep=",", row.names=F, col.names=F, append=T)  
  
#save output  
write.table(t(c(as.character(alignments$sp1_sp2[f]), summary(temp)[1,1], raw, K80, K81, F84, TN93)), "DNAdiv_estimates.csv", sep=",", row.names=F, col.names=F, append=T)  
  
# run separately for all aligned sequences  
write.table(t(c("query_contig", "subject_scaffold", "query_seq", "subject_scaffold", "subject_seq", "raw", "K80", "K81", "F84", "TN93")), paste("DNAdiv_sequences_", as.character(alignments$sp1_sp2[f]), ".csv", sep = ""), sep=",", row.names=F, col.names=F, append=F)  
# run estimates for each row  
}  
  

#After Rscript has run, need to run the following commands in shell
  
#awk '{print $3}' to.parse| grep "[A C T G N -]" > Q  
#echo -e ">subject_variegatus" | cat - Q >q.fast  
  
#awk '{print $4}' to.parse| grep "[A C T G N -]" > S  
#echo -e ">query_tularosa | cat - S >s.fasta  
  
#cat q.fasta s.fasta > alignment.fasta  
  
#alg<-read.FASTA("./alignment.fasta")  
#awk '{print $1,$2}' genome1genome2blast.tsv | tr " " "," > qs   
#paste qs DNAdiv_estimates.csv > dna.dist.csv  
  
#Now plot each pairwise nuDNA panel. 
dna.dist <- read.csv("~/tularosa_variegatus_dis_30kb.csv")           
ggplot(data=dna.dist,aes(x=query,y=K81,group=1))+geom_line(linetype="dashed",color="grey")+geom_point(size=1,aes(colour=factor(grp))) + scale_color_manual(values=c("red", "red", "black"))+theme(legend.position = "none",panel.grid = element_blank(),axis.title = element_blank(),axis.text.x = element_blank(),panel.background = element_blank())+ geom_hline(yintercept = 0.02221, linetype="dashed",colour="red")

#Now plot
a<-ggplot(x) +geom_point(aes(dist,ho,color=pop,group=pop,size=8,shape=pop))+theme_bw() +ylab("Observed Heterozygosity") +theme(axis.text=element_text(size=14,angle = 60,hjust = 1),axis.title=element_text(size=14))+xlab("")+theme(axis.text.y = element_text(size=12))+scale_color_manual(values=c("black","black"))+xlab("Distance (Kb) to nearest gene")+scale_shape_manual(values=c(20, 2))+xlim(0,50) +ylim(0,1)+ geom_abline(intercept = 0.41, slope = -0.0077, color="grey",linetype="dashed", size=1.5) 
#OR as a boxplot after assigning factors for pairwise comp:
nu_k2p$sp1_sp2 <- factor(nu_k2p$sp1_sp2,levels = c("C.tul-C.var", "C.nev-C.var", "C.nev-C.tul", "X.mac-C.nev", "X.mac-C.tul", "X.mac-C.var")) 
gplot(data=nu_k2p,aes(x=sp1_sp2,y=K81,group=sp1_sp2))+geom_boxplot() +theme_classic()

