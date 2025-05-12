# Make Union Map Files

library(dplyr)
library(tidyr)
library(tidyverse)

# Use Sandoy samples (FSa) as an example
indv <- c("FSa1","FSa10","FSa11","FSa12","FSa16","FSa2","FSa20","FSa21","FSa4","FSa6","FSa7","FSa9")

chr_all <- commandArgs(TRUE)
chr <- chr_all[1]

for (i in indv) {
  map_set0 <- read.csv(paste("../FS_set0/WG_chr",chr,"_",i,".map.csv", sep=""), header = TRUE)
  map_set0$set <- 0
  map_set1 <- read.csv(paste("../FS_set1/WG_chr",chr,"_",i,".map.csv", sep=""), header = TRUE)
  map_set1$set <- 1
  map_set2 <- read.csv(paste("../FS_set2/WG_chr",chr,"_",i,".map.csv", sep=""), header = TRUE)
  map_set2$set <- 2
  map_set3 <- read.csv(paste("../FS_set3/WG_chr",chr,"_",i,".map.csv", sep=""), header = TRUE)
  map_set3$set <- 3

  colnames(map_set0) <- c("position","anc0","set0")
  colnames(map_set1) <- c("position","anc1","set1")
  colnames(map_set2) <- c("position","anc2","set2")
  colnames(map_set3) <- c("position","anc3","set3")

  map1 <- full_join(map_set0,map_set1)
  map2 <- full_join(map1,map_set2)
  map3 <- full_join(map2,map_set3)

  map <- map3 %>% mutate(same = anc0==anc1 & anc1==anc2 & anc2==anc3)
  export_map <- filter(map, same==TRUE) %>% select(position,anc0)

  new_filename <- paste("WG_chr",chr,"_",i,".map.csv", sep="")
  write.csv(export_map, new_filename, row.names = FALSE, quote=FALSE)

  map_set0 <- read.csv(paste("../FS_set0/WG_chr",chr,"_",i,".map95.csv", sep=""), header = TRUE)
  map_set0$set <- 0
  map_set1 <- read.csv(paste("../FS_set1/WG_chr",chr,"_",i,".map95.csv", sep=""), header = TRUE)
  map_set1$set <- 1
  map_set2 <- read.csv(paste("../FS_set2/WG_chr",chr,"_",i,".map95.csv", sep=""), header = TRUE)
  map_set2$set <- 2
  map_set3 <- read.csv(paste("../FS_set3/WG_chr",chr,"_",i,".map95.csv", sep=""), header = TRUE)
  map_set3$set <- 3

  colnames(map_set0) <- c("position","anc0","set0")
  colnames(map_set1) <- c("position","anc1","set1")
  colnames(map_set2) <- c("position","anc2","set2")
  colnames(map_set3) <- c("position","anc3","set3")

  map1 <- full_join(map_set0,map_set1)
  map2 <- full_join(map1,map_set2)
  map3 <- full_join(map2,map_set3)

  map <- map3 %>% mutate(same = anc0==anc1 & anc1==anc2 & anc2==anc3)
  export_map <- filter(map, same==TRUE) %>% select(position,anc0)

  new_filename <- paste("WG_chr",chr,"_",i,".map95.csv", sep="")
  write.csv(export_map, new_filename, row.names = FALSE, quote=FALSE)
}
