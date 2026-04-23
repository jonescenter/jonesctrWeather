#' Get daily aggregate weather station data
#'
#' A convenience wrapper around \code{get_weather()} that returns daily
#' aggregate records instead of 15-minute interval data. Equivalent to
#' calling \code{get_weather(start, end, interval = "daily")}.
#'
#' @param start Character. Start date in \code{YYYY-MM-DD} format.
#' @param end Character. End date in \code{YYYY-MM-DD} format.
#'
#' @return A dataframe of daily aggregate weather records for the requested
#'   date range.
#'
#' @examples
#' \dontrun{
#' wx_daily <- get_weather_daily(start = "2024-01-01", end = "2024-01-31")
#' }
#'
#' @export
get_weather_daily <- function(start, end) {
  get_weather(start = start, end = end, interval = "daily")
}