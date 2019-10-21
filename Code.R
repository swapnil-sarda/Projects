library(httr)
library(jsonlite)
library(stringr)
library(sqldf)

# Fetching data using API

ocm_url <- GET("https://api.openchargemap.io/v2/poi/?output=json&countrycode=NO&maxresults=3000&compact=true&verbose=false&opendata=true")
ocm <- rawToChar(ocm_url$content)
class(ocm)
ocm1 <- fromJSON(ocm)
ocm1 <- data.frame(ocm1)
ocm2 <- data.frame(ocm1$AddressInfo)
ocmurl2 <- ("https://api.openchargemap.io/v2/poi/?output=csv&countrycode=NO&maxresults=3000&opendata=true")
ocm_data <- read.csv(ocmurl2, na.strings=c("",".","NA"))

# Cleaning data

# Merging data sources using common columns using sql

ocm3 <- data.frame(ocm2$Town,ocm2$StateOrProvince,ocm2$Postcode,ocm_data$ConnectionType)
colnames(ocm3) <- c("Town","County","PostCode","Connector")
look_up <- read.delim("NO.txt",sep = "\t", encoding = "UTF-8")
colnames(look_up) <- c("Country", "Postcode","Town","County","Extra1","Extra2","Extra3","Extra4","Extra5","Extra6","Extra7","Extra8")
ocm3 <- sqldf(c("update ocm3
                set Town = (select Town from look_up where look_up.Postcode = ocm3.Postcode)
                where exists(select Town from look_up where look_up.Postcode = ocm3.Postcode)",
                "select * from ocm3"))
ocm3 <- sqldf(c("update ocm3
                set County = (select County from look_up where look_up.Postcode = ocm3.Postcode)
                where exists(select Town from look_up where look_up.Postcode = ocm3.Postcode)",
                "select * from ocm3"))

# Replacing foreign characters in data. Data snippet taken from stackoverflow.				
				
fromto <- read.table(text="
from to
                     š s
                     œ oe
                     ž z
                     ß ss
                     þ y
                     à a
                     á a
                     â a
                     ã a
                     ä a
                     å a
                     æ ae
                     ç c
                     è e
                     é e
                     ê e
                     ë e
                     ì i
                     í i
                     î i
                     ï i
                     ð d
                     ñ n
                     ò o
                     ó o
                     ô o
                     õ o
                     ö o
                     ø o
                     ù u
                     ú u
                     û u
                     ü u
                     ý y
                     ÿ y
                     ğ g
                     Ø O",header=TRUE)

replaceforeignchars <- function(dat,fromto) {
  for(i in 1:nrow(fromto) ) {
    dat <- gsub(fromto$from[i],fromto$to[i],dat)
  }
  dat
}


ocm3$Town <- replaceforeignchars(ocm3$Town,fromto)
ocm3$County <- replaceforeignchars(ocm3$County,fromto)


# Aggregating type of cars based on connection type into groups

ocm3$Connector[grep("CHAdeMO; CCS",ocm3$Connector)] <- "Type 3 / Type 2"
ocm3$Connector[grep("Mennekes",ocm3$Connector)] <- "Type 2"
ocm3$Connector[grep("Tesla",ocm3$Connector)] <- "Tesla"
ocm3$Connector[grep("IEC",ocm3$Connector)] <- "Type 2"
ocm3$Connector[grep("CCS",ocm3$Connector)] <- "Type 2"
ocm3$Connector[grep("CHAdeMO",ocm3$Connector)] <- "Type 3"
ocm3$Connector[grep("Unknown",ocm3$Connector)] <- "Unknown"
ocm3$Connector[grep("Unknown",ocm3$Connector)] <- NA
ocm3$Connector[grep("IEC",ocm3$Connector)] <- "Type 2"
ocm3$Connector[grep("Type F",ocm3$Connector)] <- "Type 1"
ocm3$Connector[grep("J1772",ocm3$Connector)] <- "Type 1"

ocm3 <- na.omit(ocm3)

ocm3$Ocm_Index <- seq.int(nrow(ocm3))

write.csv(ocm3, "Ocm_clean.csv", row.names = FALSE)
