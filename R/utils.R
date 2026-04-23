#' Fetch all pages from a DAB REST endpoint
#'
#' DAB paginates results using a \code{nextLink} field in the response body.
#' This helper follows the chain until no \code{nextLink} is returned,
#' combining all pages into a single dataframe.
#'
#' @param url Character. The initial request URL.
#' @param token Character. Bearer token from \code{auth_jones()}.
#' @param role Character. The \code{X-MS-API-ROLE} header value.
#'
#' @return A dataframe of all records across all pages.
#' @keywords internal
#' @noRd
fetch_all_pages <- function(url, token, role) {
  records <- list()

  repeat {
    resp <- httr2::request(url) |>
      httr2::req_headers(
        Authorization   = paste("Bearer", token),
        `X-MS-API-ROLE` = role
      ) |>
      httr2::req_error(is_error = function(resp) FALSE) |>
      httr2::req_perform()

    status <- httr2::resp_status(resp)

    if (status != 200L) {
      stop(sprintf("API request failed [HTTP %d]: %s",
        status,
        httr2::resp_body_string(resp)), call. = FALSE)
    }

    # Guard against empty body
    raw <- httr2::resp_body_string(resp)
    if (!nzchar(raw)) {
      message("Warning: empty response body received from API.")
      break
    }

    body    <- jsonlite::fromJSON(raw, simplifyVector = FALSE)
    records <- c(records, body$value)

    next_link <- body[["nextLink"]]
    if (is.null(next_link) || !nzchar(next_link)) break
    url <- next_link
  }

  if (length(records) == 0) {
    message("No records returned for the requested date range.")
    return(data.frame())
  }

  dplyr::bind_rows(lapply(records, as.data.frame, stringsAsFactors = FALSE))
}