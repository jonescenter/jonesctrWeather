#' @keywords internal
#' @noRd
#'
# Internal constants — public identifiers, not secrets
JONES_TENANT_ID <- "d1f21831-a420-4b90-a1bd-be2d7f4025e1"
JONES_CLIENT_ID <- "e3ab7f68-9182-412e-bcf3-760e6ba333bc"
JONES_RESOURCE  <- "e3ab7f68-9182-412e-bcf3-760e6ba333bc"
JONES_API_BASE  <- "https://api.jonesctr.org/weather/api"
JONES_READ_ROLE <- "WeatherAPI.Read"

#' Acquire and cache an Entra ID token for the Jones Center Weather API
#'
#' Called automatically by \code{get_weather()} and \code{get_weather_daily()}.
#' On the first call per session a browser window opens for \@jonesctr.org
#' sign-in. AzureAuth caches the token locally — subsequent calls are silent.
#'
#' @return A character string containing the Bearer token.
#' @keywords internal
#' @noRd
auth_jones <- function() {
  token <- AzureAuth::get_azure_token(
    resource  = JONES_RESOURCE,
    tenant    = JONES_TENANT_ID,
    app       = JONES_CLIENT_ID,
    auth_type = "authorization_code"
  )
  AzureAuth::extract_jwt(token)
}