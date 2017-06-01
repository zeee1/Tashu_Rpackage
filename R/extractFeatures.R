#' Feature extraction Function
#'
#' This function extracts feature data that affects demand of bikes in Tashu.
#' @param data #정류소 별 대여 데이터(+계절, 월, 시간, 요일, 기온, 습도, 강수량, 축제 여부)
#' @keywords feature extraction
#' @export
#' @examples
#' extractFeatures()

extractFeatures <- function(data){
  features <- c ("season","rentMonth","rentHour", "rentWeekday","temperature", "humidity", "rainfall","isFestival")

  return(data[, features])
}
