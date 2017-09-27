#### Clean Up environment -----------------------------
rm(list=ls())
 
#### Packages -----------------------------
library(readxl)
library(tidyverse)
library(dts.quality)
 
#### Functions -----------------------------
 
 
#### Data Input -  -----------------------------------------

data.in <- read_excel("~/Desktop/FAME/FAME02_Results.xlsx", 
                      col_types = c("numeric", "date", "text", 
                                    "text", "text", "text", "numeric", 
                                    "numeric", "text", "text", "text", 
                                    "text", "numeric", "text", "text", 
                                    "text", "text", "text", "numeric", 
                                    "text"))

#### Data Cleaning -----------------------------

data.in2 <- data.in %>% filter(grepl("^C:", REPORTED_NAME))

data.in2 <- unique(data.in2)

data.in2 <- data.in2 %>% 
        group_by(REPORTED_NAME) %>% 
        mutate(ENTRY = outliers(ENTRY)) %>% 
        ungroup()


batches <- read_excel("~/Desktop/FAME/FAME02_Batches.xlsx", 
                      sheet = "blurp")

gc_position <- batches %>% 
        filter(NAME__1 == "GC System ID")
colnames(gc_position)[1] <- "Batch"
gc_position <- gc_position[,c(1,4)]

data.in3 <- merge(data.in2, gc_position, by.x = "NAME", by.y = "Batch", all = FALSE )

wide_data2 <- spread(data.in3, REPORTED_NAME, ENTRY.x, fill="")

wide_data2 <- wide_data2[,c(2,1,19, 20:86)]

write.csv(wide_data2, "summary2.csv")
