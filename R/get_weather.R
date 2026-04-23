#' Get weather station data
#'
#' Returns a dataframe of weather readings from the Jones Center Crafton Palmer
#' Weather Station for a given date range. On the first call a browser window
#' will open for your \@jonesctr.org sign-in. Subsequent calls in the same
#' session are silent.
#'
#' @param start Character. Start date in \code{YYYY-MM-DD} format.
#' @param end Character. End date in \code{YYYY-MM-DD} format.
#' @param interval Character. Either \code{"15min"} (default) or
#'   \code{"daily"} for daily aggregates.
#'
#' @return A dataframe of weather records for the requested date range.
#'
#' @examples
#' \dontrun{
#' # 15-minute data
#' wx <- get_weather(start = "2024-01-01", end = "2024-01-31")
#'
#' # Daily aggregates
#' wx <- get_weather(start = "2024-01-01", end = "2024-01-31", interval = "daily")
#' }
#'
#' @export
get_weather <- function(start, end, interval = "15min") {

  interval <- match.arg(interval, c("15min", "daily"))

  start_dt <- tryCatch(as.Date(start), error = function(e)
    stop("'start' must be a date in YYYY-MM-DD format.", call. = FALSE))
  end_dt <- tryCatch(as.Date(end), error = function(e)
    stop("'end' must be a date in YYYY-MM-DD format.", call. = FALSE))

  if (end_dt < start_dt)
    stop("'end' must be on or after 'start'.", call. = FALSE)

  start_str <- format(start_dt, "%Y-%m-%d 00:00:00")
  end_str   <- format(end_dt,   "%Y-%m-%d 23:59:59")

  entity <- if (interval == "15min") "CraftonWS_FifteenMin" else "CraftonWS_Daily"
  filter <- sprintf("TmStamp ge '%s' and TmStamp le '%s'", start_str, end_str)
 
  token <- auth_jones()
  fetch_all_pages(JONES_API_BASE, entity, filter, token, JONES_READ_ROLE)
}