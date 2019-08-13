extract_features <- function(data){
  features <- c ("hour", "month", "weekday", "season",
                 "Temperature", "Windspeed", "Humidity", "Rainfall")

  return(data[, features])
}

create_train_model <- function(train_dataset) {
  rf_model <- randomForest(extract_features(train_dataset),
                           train_dataset$rentcount,
                           ntree = 50, mtry = 2, importance = TRUE)

  return(rf_model)
}

