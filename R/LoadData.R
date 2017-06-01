

# Load Tashu rent/return data from 2013 to 2014 tashu20132014Data <- read.csv('./data/tashu20132014.csv', stringsAsFactors = F)
tashu2013 <- read.csv("./data/tashu2013.csv", stringsAsFactors = F)
tashu2014 <- read.csv("./data/tashu2014.csv", stringsAsFactors = F)

# Remove rows that contain NA tashu20132014Data <- na.omit(tashu20132014Data) tashu20132014Data$rentDateTime <- ymd_hms(tashu20132014Data$RENT_DATE) tashu20132014Data$returnDateTime <-
# ymd_hms(tashu20132014Data$RETURN_DATE)
tashu2013 <- na.omit(tashu2013)
tashu2013$rentDateTime <- ymd_hms(tashu2013$RENT_DATE)
tashu2013$returnDateTime <- ymd_hms(tashu2013$RETURN_DATE)

tashu2014 <- na.omit(tashu2014)
tashu2014$rentDateTime <- ymd_hms(tashu2014$RENT_DATE)
tashu2014$returnDateTime <- ymd_hms(tashu2014$RETURN_DATE)


# Load Tashu rent/return data in 2015.
tashu2015 <- read.csv("./data/tashu2015.csv", stringsAsFactors = F)
# Remove rows that contain NA
tashu2015 <- na.omit(tashu2015)
tashu2015$rentDateTime <- ymd_hms(tashu2015$RENT_DATE)
tashu2015$returnDateTime <- ymd_hms(tashu2015$RETURN_DATE)

tashuTotalData <- rbind(tashu2013, tashu2014)
tashuTotalData <- rbind(tashuTotalData, tashu2015)

# Load weather data from 2013 to 2015 in Daejeon
weather2013Data <- read.csv("./data/weather/2013_weatherData.csv", stringsAsFactors = F)
weather2014Data <- read.csv("./data/weather/2014_weatherData.csv", stringsAsFactors = F)
weather2015Data <- read.csv("./data/weather/2015_weatherData.csv", stringsAsFactors = F)
weather2013Data$DT <- ymd_hm(weather2013Data$Datetime)
weather2014Data$DT <- ymd_hm(weather2014Data$Datetime)
weather2015Data$DT <- ymd_hm(weather2015Data$Datetime)
weather2013Data <- weather2013Data[minute(weather2013Data$DT) == 0, ]
weather2014Data <- weather2014Data[minute(weather2014Data$DT) == 0, ]
weather2015Data <- weather2015Data[minute(weather2015Data$DT) == 0, ]

# Load festival data from 2013 to 2015 in Daejeon
festivalData <- read.csv("./data/festival_info.csv", stringsAsFactors = F)
festivalData$startDate <- ymd_hm(festivalData$startDate)
festivalData$endDate <- ymd_hm(festivalData$endDate)

# Load Tashu Station data
tashuStationData <- read.csv("./data/Tashu_stationData.csv", stringsAsFactors = F)

