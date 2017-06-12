#' Predict hourly Demand of Bike in 2015.
#'
#' @param trainData training data for creating prediction model
#' @param testData testing data for prediction
#' @param isImportance if TRUE, visualize the ranking of Feature importance.
#' @param numOftree number of tree in random Forest
#' @param type if 0, random Forest for classification. if 1, random Forest for regression
#' @return a data frame that
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
