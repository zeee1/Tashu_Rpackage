#' Predict hourly Demand of Bike in 2015.
#'
#' predict hourly amount of bike rental in 2015 using random forest algorithm. Create prediction model using "trainData" and forecast demand of bike rental according to the condition of "testData"
#'
#' @param trainData training data for creating prediction model
#' @param testData testing data.
#' @param isImportance if TRUE, show a image that visualize feature importance in that station.
#' @param numOftree number of tree in random Forest
#' @param type 0/1 0 for classification, 1 for regression.
#' @return testData with predictive result.
#' @examples
#' trainData <- createTrainData(3)
#' testData <- createTestData(3)
#' predictDemandOfBikesUsingRF(trainData, testData, TRUE, 50, 1)

predictDemandOfBikesUsingRF <- function(trainData, testData, isImportance, numOftree, type) {
    # trainData :
    #trainData <- get(paste("station_", toString(stationNum), "_rentTrainDF", sep = "", collapse = NULL))

    # testData :
    #testData <- get(paste("station_", toString(stationNum), "_rentTestDF", sep = "", collapse = NULL))

    monthList <- unique(trainData$rentMonth)
    monthList <- monthList[!is.na(monthList)]

    if (length(levels(testData$isFestival)) == 1) {
        levels(testData$isFestival) <- levels(trainData$isFestival)
    }

    if (type == 0) {
        # randomForest classification
        rfModel <- randomForest(as.factor(rentCount) ~ season + rentMonth + rentHour + rentWeekday + temperature + humidity + rainfall + isFestival, data = trainData, ntree = numOfNtree,
            importance = isImportance)

        for (i_month in monthList) {
            locs <- testData$rentMonth == i_month
            monthlySubsetData <- testData[locs, ]
            monthlySubsetData$rentCount <- monthlySubsetData$RrentCount

            testData[locs, "PrentCount"] <- predict(rfModel, extractFeatures(monthlySubsetData))
        }

        #assign(paste("station_", toString(stationNum), "_TestDF", sep = "", collapse = NULL), testData)
        # write.csv(testData, file = paste('station',toString(stationNum),'_rf_classification_result.csv',sep = '', collapse = NULL), row.names = F)

    } else {
        # randomForest regression
        rfModel <- randomForest(extractFeatures(trainData), trainData$rentCount, ntree = numOftree, importance = isImportance)
        for (i_month in monthList) {
            locs <- testData$rentMonth == i_month
            monthlySubsetData <- testData[locs, ]

            testData[locs, "PrentCount"] <- predict(rfModel, extractFeatures(monthlySubsetData))
        }

        #assign(paste("station_", toString(stationNum), "_TestDF", sep = "", collapse = NULL), testData)
        # write.csv(testData, file = paste('station',toString(stationNum),'_rf_regression_result.csv',sep = '', collapse = NULL), row.names = F)
    }


    if (isImportance == TRUE) {
        imp <- importance(rfModel, type = 1)
        featureImportance <- data.frame(Feature = row.names(imp), Importance = imp[, 1])

        ggplot(featureImportance, aes(x = reorder(Feature, Importance), y = Importance)) + geom_bar(stat = "identity", fill = "#53cfff") + coord_flip() + theme_light(base_size = 20) +
            xlab("Importance") + ylab("") + ggtitle("Random Forest Feature Importance\n") + theme(plot.title = element_text(size = 18))
    }

    return(testData)
}

#' extract features in test data frame.
#'
#' extract feature data from test Data.
#' feature : season, month, hour, day of week, temperature, humidity, rainfall, affect of festival.
#'
#' @param data testing data frame for prediction. Testing data frame is created by conducting createTestData()

extractFeatures <- function(data){
  features <- c ("season","rentMonth","rentHour", "rentWeekday","temperature", "humidity", "rainfall","isFestival")

  return(data[, features])
}

