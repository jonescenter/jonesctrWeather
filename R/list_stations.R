#' List available weather stations
#'
#' Returns a dataframe of weather stations available through the Jones Center
#' weather API. Use the \code{station} column as reference when filtering
#' data — currently all data returned by \code{get_weather()} is from the
#' Crafton Palmer station.
#'
#' @return A dataframe with one row per station and the following columns:
#'   \describe{
#'     \item{station}{Station identifier used in API entity names.}
#'     \item{name}{Human-readable station name.}
#'     \item{location}{Physical location description.}
#'     \item{intervals}{Available data intervals.}
#'   }
#'
#' @examples
#' list_stations()
#'
#' @export
list_stations <- function() {
  data.frame(
    station   = "CraftonPalmer",
    name      = "Crafton Palmer Weather Station",
    location  = "Ichauway, Baker County, Georgia",
    intervals = "15min, daily",
    stringsAsFactors = FALSE
  )
}