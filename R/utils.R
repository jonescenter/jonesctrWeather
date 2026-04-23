#' Fetch all pages from a DAB REST endpoint
#'
#' @param base_url Character. The API base URL.
#' @param entity Character. The entity name.
#' @param filter Character. The OData filter string.
#' @param token Character. Bearer token from \code{auth_jones()}.
#' @param role Character. The \code{X-MS-API-ROLE} header value.
#'
#' @return A dataframe of all records across all pages.
#' @keywords internal
#' @noRd
fetch_all_pages <- function(base_url, entity, filter, token, role) {
  records <- list()
  url <- paste0(base_url, "/", entity, "?$filter=", utils::URLencode(filter, repeated = TRUE))

  repeat {
    resp <- httr2::request(url) |>
      httr2::req_auth_bearer_token(token) |>
      httr2::req_headers(`X-MS-API-ROLE` = role) |>
      httr2::req_error(is_error = function(resp) FALSE) |>
      httr2::req_perform()

    status <- httr2::resp_status(resp)

    raw <- tryCatch(
      httr2::resp_body_string(resp),
      error = function(e) ""
    )

    if (status != 200L) {
      stop(sprintf("API request failed [HTTP %d]", status), call. = FALSE)
    }

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