# Make Union Map Files

library(tidyverse)

# Use Sandoy samples (FSa) as an example
indv <- c("FSa10","FSa11","FSa12","FSa16","FSa2","FSa20","FSa21","FSa4","FSa6","FSa7","FSa9") # Removed 086

chr_all <- commandArgs(TRUE)
chr <- chr_all[1]

map_all <- read.csv(paste("WG_chr",chr,"_FSa1.map95.csv", sep=""), header = TRUE)
colnames(map_all) <- c("position","IFSa1")

for (i in indv) {
  map_I0 <- read.csv(paste("WG_chr",chr,"_",i,".map95.csv", sep=""), header = TRUE)
  colnames(map_I0) <- c("position",paste("I",i,sep=""))
  map_all <- full_join(map_all,map_I0)
  map_all[ map_all == "amb" ] <- NA
}

new_filename <- paste("WG_chr",chr,"_all.map95.csv", sep="")
write.csv(map_all, new_filename, row.names = FALSE, quote=FALSE)
