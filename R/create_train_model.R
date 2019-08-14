#' Create random-forest training model for bike rental prediction.
#'
#' @param train_dataset Training dataset created by create_train_dataset()
#' @return random forest training model
#' @export
#' @import randomForest
#' @examples
#' train_dataset <- create_train_dataset(3)
#' rf_model <- create_train_model(train_dataset)

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

