#' Create random-forest training model for bicycle rental prediction.
#'
#' @param train_dataset Training dataset created by create_train_dataset()
#' @return random forest training model
#' @export
#' @importFrom randomForest randomForest
#' @examples
#' \dontrun{train_dataset <- create_train_dataset(3)
#' rf_model <- create_train_model(train_dataset)}

create_train_model <- function(train_dataset) {
  check_data()
  rf_model <- randomForest::randomForest(extract_features(train_dataset),
                           train_dataset$rentcount,
                           ntree = 50, mtry = 2, importance = TRUE)

  return(rf_model)
}

#' Extract feature columns from train/test dataset
#'
#' @param data data with feature columns and others
#' @return data containing only feature columns

extract_features <- function(data){
  features <- c ("hour", "month", "weekday", "season",
                 "Temperature", "Windspeed", "Humidity", "Rainfall")

  return(data[, features])
}

