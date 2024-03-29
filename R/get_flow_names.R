#' Get a data frame containing the UUID and names for flows.
#'
#' @description Call the names of each run (flow) and their UUID values. This function is often called inside another function.
#' 
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See `set_rapidpro_site()` to amend the website.
#' @param token A string containing the token to call the data. See `set_rapidpro_key()` to amend the token.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#' @param date_from character string giving the date to filter the data from.
#' @param date_to character string giving the date to filter the data to.
#' @param format_date from `as.POSIX*` function: character string giving a date-time format as used by `strptime`.
#' @param tzone_date from `as.POSIX*` function: time zone specification to be used for the conversion, if one is required. System-specific (see time zones), but "" is the current time zone, and "GMT" is UTC (Universal Time, Coordinated). Invalid values are most commonly treated as UTC, on some platforms with a warning.
#'
#' @return A data frame containing the flows data in RapidPro.
#' @export
get_flow_names <- function(rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE, date_from = NULL, date_to = NULL, format_date = "%Y-%m-%d", tzone_date = "UTC"){
  get_data_from_rapidpro_api(call_type = "flows.json", rapidpro_site = rapidpro_site, token = token, flatten = flatten, date_from = date_from, date_to = date_to, format_date = format_date, tzone_date = tzone_date)
}
