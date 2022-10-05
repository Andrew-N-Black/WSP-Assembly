#GGPLOT2 for nuDNA vs mtDNA divergence ratios 

library(ggplot2)
ratio <- read.csv("ratio.csv")
a<-ggplot(data=ratio,aes(x=mt,y=nu))+geom_point(aes(color=X),color="black",size=6,shape=19)+xlim(c(0,0.3))+ylim(c(0,0.3)) +   
    geom_label_repel(aes(label = X),  
                     box.padding   = 0.9,   
                     point.padding = 0.8,  
                     segment.color = 'grey50') +theme_classic()+geom_abline(linetype="dashed",color="grey")+geom_smooth(method=lm,se=FALSE,linetype="solid",color="grey")+geom_abline(linetype="dashed",color="red")  
