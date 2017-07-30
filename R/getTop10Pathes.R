#' Get Top 10 Pathes that were most used from 2013 to 2015 And visualize the result on map.
#'
#' @export
#' @import ggplot2
#' @examples
#' getTop10Pathes()

getTop10Pathes <- function() {
    trace_cnt <- data.frame(table(tashuDataFor3year$RENT_STATION, tashuDataFor3year$RETURN_STATION))
    names(trace_cnt) <- c("RENT_STATION", "RETURN_STATION", "COUNT")
    sort_trace_cnt <- head(trace_cnt[order(-trace_cnt$COUNT),],20)
    ggplot() + geom_point(aes(x = RENT_STATION, y = RETURN_STATION, size = COUNT), data = sort_trace_cnt)
}
