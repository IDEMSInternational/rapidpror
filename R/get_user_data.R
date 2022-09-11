#' Get data for each user
#' @description Call the contact data from RapidPro for each user
#'
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See `set_rapidpro_site()` to amend the website.
#' @param token A string containing the token to call the data. See `set_rapidpro_key()` to amend the token.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#' @param date_from character string giving the date to filter the data from.
#' @param date_to character string giving the date to filter the data from.
#' @param format_date from `as.POSIX*` function: character string giving a date-time format as used by `strptime`.
#' @param tzone_date from `as.POSIX*` function: time zone specification to be used for the conversion, if one is required. System-specific (see time zones), but "" is the current time zone, and "GMT" is UTC (Universal Time, Coordinated). Invalid values are most commonly treated as UTC, on some platforms with a warning.
#' @param unlist_consent boolean denoting whether to unlist a variable containing "consent".
#'
#' @return returns a data frame containing the contact data.
#' @export
get_user_data <- function(rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE, date_from = NULL, date_to = NULL, format_date = "%Y-%m-%d", tzone_date = "UTC", unlist_consent = TRUE){
  data <- get_data_from_rapidpro_api(call_type = "contacts.json", rapidpro_site = rapidpro_site, token = token, flatten = flatten, date_from = date_from, date_to = date_to, format_date = format_date, tzone_date = tzone_date)
  
  if (unlist_consent){
  data <- unlist_rapidpro_variable(data = data)
  }
  return(data)
}
