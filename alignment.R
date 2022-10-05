#Code to plotAlignment Rates
 
library(ggplot2)
#read in file  
mapped <- read.delim("~/mapped.txt")  
#plot  
a<-ggplot(mapped, aes(fill=type, y=mapped, x=spp)) +   
    geom_bar(position="dodge", stat="identity")+coord_flip()+theme_classic() +scale_fill_manual(values=clr)  
