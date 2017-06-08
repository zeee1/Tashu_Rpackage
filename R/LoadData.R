

# Load Tashu rent/return data from 2013 to 2014 tashu20132014Data <- read.csv('./data/tashu20132014.csv', stringsAsFactors = F)
tashu2013 <- read.csv("./data/tashu2013.csv", stringsAsFactors = F)
tashu2014 <- read.csv("./data/tashu2014.csv", stringsAsFactors = F)

tashu2013 <- na.omit(tashu2013)
tashu2013$RENT_DATE <- ymd_hms(tashu2013$RENT_DATE)
tashu2013$RETURN_DATE <- ymd_hms(tashu2013$RETURN_DATE)

tashu2014 <- na.omit(tashu2014)
tashu2014$RENT_DATE <- ymd_hms(tashu2014$RENT_DATE)
tashu2014$RETURN_DATE <- ymd_hms(tashu2014$RETURN_DATE)


# Load Tashu rent/return data in 2015.
tashu2015 <- read.csv("./data/tashu2015.csv", stringsAsFactors = F)
# Remove rows that contain NA
tashu2015 <- na.omit(tashu2015)
tashu2015$RENT_DATE <- ymd_hms(tashu2015$RENT_DATE)
tashu2015$RETURN_DATE <- ymd_hms(tashu2015$RETURN_DATE)


# Load weather data from 2013 to 2015 in Daejeon
weather2013 <- read.csv("./data/weather/2013_weatherData.csv", stringsAsFactors = F)
weather2014 <- read.csv("./data/weather/2014_weatherData.csv", stringsAsFactors = F)
weather2015 <- read.csv("./data/weather/2015_weatherData.csv", stringsAsFactors = F)
weather2013$Datetime <- ymd_hm(weather2013$Datetime)
weather2014$Datetime <- ymd_hm(weather2014$Datetime)
weather2015$Datetime <- ymd_hm(weather2015$Datetime)
weather2013 <- weather2013[minute(weather2013$Datetime) == 0, ]
weather2014 <- weather2014[minute(weather2014$Datetime) == 0, ]
weather2015 <- weather2015[minute(weather2015$Datetime) == 0, ]

# Load festival data from 2013 to 2015 in Daejeon
festivalData <- read.csv("./data/festival_info.csv", stringsAsFactors = F)
festivalData$startDate <- ymd_hm(festivalData$startDate)
festivalData$endDate <- ymd_hm(festivalData$endDate)

# Load Tashu Station data
tashuStationData <- read.csv("./data/Tashu_stationData.csv", stringsAsFactors = F)

# merge tashu data for 3 year.
tashuDataFor3year <- rbind(tashu2013, tashu2014)
tashuDataFor3year <- rbind(tashuDataFor3year, tashu2015)
