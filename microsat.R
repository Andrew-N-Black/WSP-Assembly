#Plot Microsat Heterozygosity
library(ggplot2)
het2 <- read.csv("~/het2.csv")
het2$micro <- factor(het2$micro,levels = c("WSP-2", "WSP-11", "WSP-20", "WSP-23", "WSP-24", "WSP-25", "WSP-26", "WSP-30","WSP-32", "WSP-33", "WSP-34"))  
a<-ggplot(het2) +geom_point(aes(x=as.factor(micro),y=het,fill=exp_het,shape=exp_het),size=4)+theme_bw() + ylab("Heterozygosity") +theme(axis.text=element_text(size=14,angle = 60,hjust = 1),axis.title=element_text(size=14))+xlab("")+theme(axis.text.y = element_text(size=12))+scale_fill_manual(values=c("red","black"))+scale_shape_manual(values=c(24,21))+facet_wrap(~esu,ncol = 1)+ylim(c(0,1))  
