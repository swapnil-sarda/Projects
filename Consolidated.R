library(arules) # Apriori algorithm
library(Boruta) # Feature selection
library(httr) # API handling
library(jsonlite) # API handling
library(plyr) # List functions
library(stringr) # Sting functions


# PUBG API Documentation

# https://documentation.pubg.com/en/index.html

# Kaggle dataset link

# https://www.kaggle.com/c/pubg-finish-placement-prediction

# Fetching leader data

headers = c(
  Accept ='application/json',
  Authorization ='Bearer <api-key>'
)

leadurl <- 'https://api.pubg.com/shards/steam/leaderboards/solo?page[number]=0'

res <- GET(url = leadurl , add_headers(.headers=headers))

raw <- fromJSON(rawToChar(res$content))

pubg <- do.call(c, sapply(raw,`[[`,'relationships'))

leader<- data.frame(unlist(pubg$included.name))

leader[,"Rank"]<-unlist(pubg$included.rank)

leader[,"Id"] <- unlist(raw$included$id)

colnames(leader) <- c("Name","Rank","Id")

leader <- leader[order(leader$Rank),]

rownames(leader) <- NULL

leader <- read.csv(file = "Leaderboard.csv")

# Retrieving data of every match for every player

headers = c(
  Accept = 'application/json',
  Authorization = 'Bearer <api-key>'
)

link <- 'https://api.pubg.com/shards/steam/players/'

Listdf <- list()


for(i in 1:nrow(leader)) {
  
  results <- data.frame(matrix(NA, nrow = nrow(M_id), ncol = 25), stringsAsFactors = FALSE)
  
  resp <- GET(url ='https://api.pubg.com/shards/steam/players/account.eebb11be0892411cb7b8b479e8250c71', add_headers(.headers = headers))
  
  rawp <- fromJSON(rawToChar(resp$content))
  
  M_id <- data.frame(unlist(data.frame(unlist(rawp$data$relationships$matches$data$id), stringsAsFactors = FALSE)),stringsAsFactors = FALSE)
  
  ###################################### Single Match Data ##################################################
  
  u1 <- 'https://api.pubg.com/shards/steam/matches/'
  
  
  for(j in 1:nrow(M_id)){
    
    u2 <- M_id[j,]
    
    #Data fetched using URL
    resm <- GET(url = paste0(u1,u2), add_headers(.headers = headers))
    
    rawm <- fromJSON(rawToChar(resm$content))
    
    m_stat <- lapply(rawm$included$attributes$stats, function(j) list(unlist(j, recursive = TRUE)))
    
    
    if(length(m_stat) < 1) { break } 
    
    else {
      match_stat <- data.frame(matrix(unlist(m_stat), nrow=length(m_stat), byrow = T), stringsAsFactors = FALSE)
      
      match_stat <- data.frame(t(match_stat), stringsAsFactors = FALSE)
      
      colnames(match_stat)<- names(m_stat)
      
      rownames(match_stat) <- NULL
      
      match_stat <- match_stat[match_stat$playerId %in% leader$Id[i],]
      
      results[j,] <- match_stat
    }
  }
  
  Listdf[[i]] <- results
  
  
  print(i) 
}

Listdf <- lapply(Listdf2, setNames, clist)

Listdf2 <- Listdf


############### Changes to single list

#,"Rank","TeamId")

Listdf2 <- lapply(Listdf2, setNames, clist)

# Rotating NA columns to end
Listdf2 <- lapply(Listdf2, 
                  function(Listdf2) 
                    data.frame(t(apply(Listdf2, 1, function(x) c(x[!is.na(x)], x[is.na(x)])))))

# Remove columns which aren't required. 
Listdf2 <- lapply(Listdf2, "[",-c(12,13,24,25))

# Remove rows with NA values in every dataframe in the list
Listdf3 <- Listdf2

Listdf3 <- lapply(Listdf3, function(x) x[complete.cases(x),])

# Declaring column names
clist <-c("DBNOs","Assists","Boosts","DamageDealt","DeathType",
          "HeadshotKills","Heals","KillPlace",
          "KillStreaks","Kills","LongestKill","Revives",
          "RideDistance","RoadKills","SwimDistance","TeamKills","TimeSurvived",
          "VehicleDestroys","WalkDistance","WeaponsAcquired","WinPlace")


# Listdf3 <- lapply(Listdf3, setNames, clist)

# Remove dataframes depending on number of rows
Listdf4 <- Listdf3

Listdf4 <- Filter(function(x) nrow(x)> 100, Listdf4)

Listdf4 <- lapply(Listdf4, setNames, clist)

# Factor to numeric

# Create dataframes dynamically while assigning each element of a list to a new dataframe.

for (i in seq(Listdf4)){as.data.frame(assign(paste0("Playerdata", i), Listdf4[[i]]), stringsAsFactors = FALSE)}



# Dataframe for every individual player.

mmm <- mget(ls(pattern = "Playerdata[0-9]"))

# Transpose all the dataframes, keeping data type as numeric

mmm <- lapply(mmm, function(x) data.frame(x))

# for (i in seq(mmm)) {
#   as.data.frame(assign(paste0("Df",i), mmm[[i]]))
# }


set.seed(1337)

# All data frames to one single list.
bigdf <- ldply(mmm)

bigdf <- bigdf[,-1]

# Feature selection

Hokagetest <- Boruta(WinPlace~., data = bigdf, doTrace = 2, maxRuns = 18)

# Discarding roadKill attribute. 
bigdf <- bigassdf[,-14]

# Ordering columns
bigassdf <- bigassdf[,c(18,1:17)]

# Binning dataframe
bigdf <- OneR::bin(bigdf, nbins = 6)

# Converting to transaction data type
bigdf <- as(bigdf, "transactions")

# Apriori algorithm
Player0 <- apriori(bigassdf4, parameter = list(support = 0.7, confidence = 0.7, maxlen = 18, target = "rules"))

# Rules to dataframe
pubdf <- arules::DATAFRAME(Player0)

# Add new interest measure column
pubdf[,"RPF"] <- arules::interestMeasure(Player0, measure = "rulePowerFactor")


###################### Kaggle Dataset handling ########################

# Load Kaggle Dataset
Kaggledf33 <- read.csv(file = "train_V2.csv", stringsAsFactors = FALSE)

# Remove mismatch column
Kaggledf33 <- Kaggledf33[,-c(1:3,15:19,28)]


# Feature selection

Hokagetest <- Boruta(WinPlace~., data = bigassdf2, doTrace = 2, maxRuns = 18)


# Discard unimportant feature Roadkill and a deprecated column.
Kaggledf33 <- Kaggledf33[,-c(8,14)]

# Reorder and Rename
Kaggledf33 <- Kaggledf33[,c(18,1:17)]

colnames(Kaggledf33)[1]<-"WinPlace"

# Subset to only winning rows
Kaggledf33 <- Kaggledf33[Kaggledf33$WinPlace == 1,]

# Binning and assinging label for easier reading

Kaggledf33$assists <- cut(Kaggledf33$assists, breaks = 5, labels = c("0 to 4", "5 to 8", "9 to 12","13 to 16","17 to 20"))
Kaggledf33$boosts <- cut(Kaggledf33$boosts, breaks = 5, labels = c("0 to 4", "5 to 8", "9 to 12","13 to 16","17 to 20"))
Kaggledf33$damageDealt <- cut(Kaggledf33$damageDealt, breaks = 6, labels = c("0 to 1100","1101 to 2200","2201 to 3300","3301 to 4400","4401 to 5500","5501 to 6600"))
Kaggledf33$DBNOs <- cut(Kaggledf33$DBNOs, breaks = 5, labels = c("0 to 6","7 to 13","14 to 20","21 to 26","27 to 33"))
Kaggledf33$headshotKills <- cut(Kaggledf33$headshotKills, breaks = 4, labels = c("0 to 10","11 to 20", "21 to 30", "31 to 40"))
Kaggledf33$heals <- cut(Kaggledf33$heals, breaks = 5, labels = c("0 to 7","8 to 14","15 to 21","22 to 28","29 to 35"))
Kaggledf33$kills <- cut(Kaggledf33$kills, breaks = 5, labels = c("0 to 13","14 to 26","27 to 39","40 to 52","53 to 65"))
Kaggledf33$killPlace <- cut(Kaggledf33$killPlace, breaks = 6, labels = c("0 to 12","12 to 24","25 to 36","37 to 48","49 to 60","61 to 72"))
Kaggledf33$killStreaks <- cut(Kaggledf33$killStreaks, breaks = 3, labels = c("0 to 4","5 to 8","9 to 12"))
Kaggledf33$longestKill <- cut(Kaggledf33$longestKill, breaks = 5, labels = c("0 to 200","201 to 400","401 to 600","601 to 800","801 to 1000"))
Kaggledf33$revives <- cut(Kaggledf33$revives, breaks = 6, labels = c("0 to 1","1 to 2","2 to 3","3 to 4","4 to 5","5 to 6"))
Kaggledf33$rideDistance <- cut(Kaggledf33$rideDistance, breaks = 4, labels = c("0 to 4400","4401 to 8800","8801 to 13200","13200 to 17600"))
Kaggledf33$swimDistance <- cut(Kaggledf33$swimDistance, breaks = 6, labels = c("0 to 450","451 to 900","901 to 1350","1351 to 1800","1801 to 2250","2251 to 2700"))
Kaggledf33$teamKills <-cut(Kaggledf33$teamKills, breaks = 5, labels = c("0","1","2","3","4"))
Kaggledf33$vehicleDestroys <- cut(Kaggledf33$vehicleDestroys, breaks = 4, labels = c("0",'1',"2","3"))
Kaggledf33$walkDistance <- cut(Kaggledf33$walkDistance, breaks = 5, labels = c("0 to 2000","2001 to 4000","4001 to 6000","6001 to 8000","8001 to 10000"))
Kaggledf33$weaponsAcquired <- cut(Kaggledf33$weaponsAcquired, breaks = 9, labels = c("1 to 9","10 to 18",">18",">18",">18",">18",">18",">18",">18"))
Kaggledf33$WinPlace <- cut(Kaggledf33$WinPlace, breaks = 2, labels = c("1","0"))


# Convert to transaction matrix
Kaggledf09 <- as(Kaggledf33, "transactions")

# Applying Apriori algorithm
KaggleP9 <- arules::apriori(Kaggledf09, parameter = list(support = 0.70, confidence = 0.70, maxlen = 20, target = "rules"))

# Subset RHS values.
vizkaggle09 <- arules::subset(KaggleP9, subset = rhs %in% "WinPlace=1")

# Convert to dataframe and add RPF value
vizkaggle18 <- as(vizkaggle09, "data.frame")

vizkaggle18[,"RPF"] <- arules::interestMeasure(vizkaggle09, measure = "rulePowerFactor")


# Interest measure

kdf <- arules::DATAFRAME(KaggleP9)

kdf[,"RPF"] <- arules::interestMeasure(KaggleP3, measure = "rulePowerFactor")



# Comparison of evaluation results
boxplot(kdf$support, pubdf$support, col = c("Orange","Red"), main = "Support Value comparison", xlab = "Yellow  = Kaggle Data Values | Red = PUBG API Data Values", ylab = "Support Values" )

boxplot(kdf$RPF, pubdf$RPF, col = c("Orange","Red"), main = "RPF Value comparison", xlab = "Yellow  = Kaggle Data Values | Red = PUBG API Data Values", ylab = " RPF Values")

boxplot(kdf$confidence, pubdf$confidence,col = c("Orange","Red"), main = "Confidence Value comparison", xlab = "Yellow  = Kaggle Data Values | Red = PUBG API Data Values", ylab = "Confidence Values")

# Kaggle dataset have higher Confidence, Support and RPF values compared to PUBG dataset.
# For visualisation,  Kaggle dataset is chosen.

# Subset rows into different files
kset1 = kset2 = kset3 = kset4 = kset5 = kset6 <- data.frame(items = as.character(), support = as.character(), confidence = as.character(), lift = as.character(), count = as.character(), RPF= as.character(), stringsAsFactors = FALSE)


for(i in 1:nrow(vizkaggle18)){
  if(str_count(gsub("\\(.*?\\]", "",vizkaggle18$rules[i]),",") == 0)
  {
    set <- rbind(vizkaggle18[i,])
    kset1 <- rbind(kset1,set)
  }
}  


for(i in 1:nrow(vizkaggle18)){
  if(str_count(gsub("\\(.*?\\]", "",vizkaggle18$rules[i]),",") == 1)
  {
    set <- rbind(vizkaggle18[i,])
    kset2 <- rbind(kset2,set)
  }
}  

for(i in 1:nrow(vizkaggle18)){
  if(str_count(gsub("\\(.*?\\]", "",vizkaggle18$rules[i]),",") == 2)
  {
    set <- rbind(vizkaggle18[i,])
    kset3 <- rbind(kset3,set)
  }
} 

for(i in 1:nrow(vizkaggle18)){
  if(str_count(gsub("\\(.*?\\]", "",vizkaggle18$rules[i]),",") == 3)
  {
    set <- rbind(vizkaggle18[i,])
    kset4 <- rbind(kset4,set)
  }
}


for(i in 1:nrow(vizkaggle18)){
  if(str_count(gsub("\\(.*?\\]", "",vizkaggle18$rules[i]),",") == 4)
  {
    set <- rbind(vizkaggle18[i,])
    kset5 <- rbind(kset5,set)
  }
} 

for(i in 1:nrow(vizkaggle18)){
  if(str_count(gsub("\\(.*?\\]", "",vizkaggle18$rules[i]),",") == 5)
  {
    set <- rbind(vizkaggle18[i,])
    kset6 <- rbind(kset6,set)
  }
}

# Subset based on required confidence values

kset1 <- kset1[-1,]

kset6$support <- round(kset6$support, digits = 3)
kset5$support <- round(kset5$support, digits = 3)
kset4$support <- round(kset4$support, digits = 3)
kset3$support <- round(kset3$support, digits = 3)
kset2$support <- round(kset2$support, digits = 3)
kset1$support <- round(kset1$support, digits = 3)



kset6 <- kset6[kset6$support > 0.94,]
kset5 <- kset5[kset5$support > 0.955,]
kset4 <- kset4[kset4$support > 0.969,]
kset3 <- kset3[kset3$support > 0.981,]
kset2 <- kset2[kset2$support > 0.984,]
kset1 <- kset1[kset1$support > 0.973,]

# Writing as CSV files

csvlist2 <- list(kset1,kset2,kset3,kset4,kset5,kset6)


for(i in 1:6){
  write.csv(csvlist2[[i]],paste0("K",i,".csv"), row.names = FALSE)
}