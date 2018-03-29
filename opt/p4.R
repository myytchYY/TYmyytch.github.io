rm(list = ls())
library(RMySQL)
library(reshape2)
library(pracma)
con<- dbConnect(RMySQL::MySQL(),dbname = "finalexam", username = "root", password = "root")
dbListTables(con)

dc <- dbReadTable(con,"ww_dcs")
stores <- dbReadTable(con,"ww_stores")

c1 <- c()
c2 <- c()
distance <- c()
size1 <- nrow(dc)
for (i in 1:size1){
  for (j in 1:nrow(stores)){
    dc_loc <- c(dc[i,"lat"],dc[i,"lon"])
    store_loc <- c(stores[j,"lat"],stores[j,"lon"])
    c1[(i-1)*size1+j] <- dc[i,1]
    c2[(i-1)*size1+j] <- stores[j,1]
    distance[(i-1)*size1+j] <- haversine(dc_loc,store_loc)
  }
} 
mytable <- data.frame(cbind(c1,c2,distance))
colnames(mytable) <- dbListFields(con,"ww_mileage")
dbWriteTable(con,"ww_mileage",mytable,row.names = F,append = T)
dbDisconnect(con)