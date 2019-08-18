#' Visualize Top 10 Pathes that were most used from 2013 to 2015.
#'
#' @export
#' @import ggplot2 utils
#' @importFrom ggplot2 ggplot geom_point aes_string margin
#' @examples
#' \dontrun{top10_pathes()}
#'
top10_pathes <- function() {
    trace_cnt <- data.frame(table(tashu$RENT_STATION, tashu$RETURN_STATION))
    names(trace_cnt) <- c("RENT_STATION", "RETURN_STATION", "COUNT")
    sort_trace_cnt <- head(trace_cnt[order(-trace_cnt$COUNT), ], 10)
    ggplot() +
      geom_point(
        aes_string(x = "RENT_STATION", y = "RETURN_STATION", size = "COUNT"),
        data = sort_trace_cnt)
}
