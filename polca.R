#Plot Polca statistis


polca <- read.csv("polca.csv")
a<-ggplot(polca, aes(round, subs,group=round))+geom_point(size=4) + theme_bw() +ggtitle("Subtitutions")  
ggsave(a,device = 'svg',filename = "subs.svg")
a<-ggplot(polca, aes(round, indels,group=round))+geom_point(size=4) + theme_bw() +ggtitle("Insertions / Deletions")  
a
ggsave(a,device = 'svg',filename = "indels.svg")

a<-ggplot(polca, aes(round, size,group=round))+geom_point(size=4) + theme_bw() +ggtitle("Genome Size")  
ggsave(a,device = 'svg',filename = "size.svg")
