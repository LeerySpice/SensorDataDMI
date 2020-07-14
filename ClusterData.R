library(ggplot2)
library(factoextra)
library(NbClust)
library(reshape2)
library(plotly)

load("Data/data.Rda")
row.names(data) <- data$`_id`[,1]

df <- na.omit(data.frame(data[,3][,-c(65:67)], row.names = data$`_id`[,1]))
df2 <- data.frame(scale(df))


# Revisar número de cluster via NBclust
set.seed(7)
dfs <- df2[sample(1:length(df2[,2]),1000),]
nb <- NbClust(dfs, distance = "euclidean", min.nc = 2, max.nc = 8, method = "kmeans")

jpeg("Cluster/optimz_nb.cluster.png", width = 800, height = 600)
fviz_nbclust(nb)
dev.off()

km.res <- kmeans(df2,4,nstart=25)

jpeg("Cluster/kmeans_cluster.png", width = 800, height = 600)
fviz_cluster(km.res,data=df2,
             palette=c("#000099","#00AFBB","#E7B800","#FC4E07"),
             ellipse.type="euclid",#Concentrationellipse
             star.plot=TRUE,#Addsegmentsfromcentroidstoitems
             #ggtheme=theme_minimal()
)
dev.off()


# Merge DB
df <- data.frame(df,data.frame(as.factor(km.res$cluster)))
names(df)[97] <- "km.res.cluster"
table(data.frame(km.res$cluster))
saveRDS(df,"Data/dfcluster.Rda")

for (x in 1:4) {
  assign(paste0("i",x), which(df$km.res.cluster==x))
  assign(paste0("DC",x), df[get(paste0("i",x)),][,-97])
  assign(paste0("PDC",x), colMeans(get(paste0("DC",x))))
  saveRDS(get(paste0("DC",x)),file=paste0('Data/DC', x, '.Rda'))
}

PC <- data.frame(PDC1,PDC2,PDC3,PDC4,rownames(data.frame(PDC1)) )
names(PC)[5]  <- "x"

jpeg("Cluster/main_cluster.png", width = 800, height = 600)
PC.long <- melt(PC, id.vars="x", measure=c("PDC1", "PDC2", "PDC3", "PDC4"))
ggplot(data = PC.long, aes(x,value, colour = variable, group=1)) +  
  geom_line(size=1) + geom_jitter() +
  theme(axis.text.x = element_text(angle=90, hjust=1, vjust = 1, size=5)) 
dev.off()

ay <- list(tickfont = list(color = "red"), overlaying = "y", side = "right", title = "# TEST/ día")
fig <- plot_ly()

for (x in 1:4) {
  fig <- fig %>% add_lines(x = PC$x, PC[[x]], name = names(PC[x]), yaxis = "Confirmados acum")
}

#viewer
fig



