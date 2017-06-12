#' extract features in test data frame.
#'
#' This function extracts features that affect demand of bike rental in test data frame.
#' feature : season, month, hour, day of week, temperature, humidity, rainfall, affect of festival.
#'
#' @param data #정류소 별 대여 데이터(+계절, 월, 시간, 요일, 기온, 습도, 강수량, 축제 여부)
#' @examples
#' extractFeatures()

extractFeatures <- function(data){
  features <- c ("season","rentMonth","rentHour", "rentWeekday","temperature", "humidity", "rainfall","isFestival")

  return(data[, features])
}
