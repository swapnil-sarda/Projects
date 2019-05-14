setwd("H:/Chrome Downloads/ADM/Project/Data files/PM 2.5")

library(xlsx)

library(DataExplorer)

library(lubridate)

library(dplyr)

rm(df1)

df1 <- read.xlsx("H:/Chrome Downloads/ADM/Project/Data files/PM 2.5/Jaipur.xlsx", sheetIndex = 1, as.data.frame = TRUE)

colnames(df1) <- c("Date","Concentration")

### Exploratory analysis

plot_str(df1)

plot_missing(df1)

plot_histogram(df1, nrow = 2L, ncol = 2L)

### Dealing with outliers if present

OutVals = boxplot.stats(df1$Concentration)$out 

df1 <- df1[!(df1 %in% OutVals )] 

### Consistent data format

df1$Concentration <- as.numeric(df1$Concentration)

df1$Date <- gsub(x = df1$Date, pattern = "00:00", replacement = " ")

df1$Date <- ymd(df1$Date)
 
df1 <- df1 %>%
  mutate(Date = as.Date(Date)) %>%
  complete(Date = seq.Date(min(Date), max(Date), by="day"))

df1$Date <- strptime(as.character(df1$Date), "%Y-%m-%d")

### Correcting different date formats to use one

df1$Date <- strptime(as.character(df1$Date), "%d-%m-%Y")

df1$Date <- format(as.Date(df1$Date), "%d/%m/%Y")

### Repalcing NA with 0

df2 <- cbind(df1)

df2$Concentration[is.na(df2$Concentration)]<- 0

### Train and test files

df2.1 <- head(df2, -7)

df2.2 <- tail(df2,7)

write.xlsx2(df2.1, "City1.xlsx", row.names = FALSE)

write.xlsx2(df2.2, "City2.xlsx", row.names = FALSE)

### Replacing 0 with rolling average

df3 <- NA

df3 <- rollmean(df2$Concentration,7)

df3 <- as.data.frame(unlist(df3))

### Train and test files

df3.1 <- head(df3,-7)

colnames(df3.1) <- c("Concentration")

df3.2 <- tail(df3,7)

colnames(df3.2) <- c("Concentration")

write.xlsx2(df3.1, "City3.xlsx", row.names = FALSE)

write.xlsx2(df3.2, "City4.xlsx", row.names = FALSE)


### Replacing 0 with average

df4 <- c()

df4 <- unlist(as.numeric(na.aggregate(df2$Concentration)))

df4 <- as.data.frame(unlist(df4))

### Train and test files

df4.1 <- head(df4, -7)

df4.2 <- tail(df4, 7)

write.xlsx2(df4.1, "City5.xlsx", row.names = FALSE)

write.xlsx2(df4.2, "City6.xlsx", row.names = FALSE)

