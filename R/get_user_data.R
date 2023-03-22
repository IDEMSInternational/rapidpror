#' Get data for each user
#' @description Call the contact data from RapidPro for each user. A wrapper function to `get_data_from_rapidpro_api`.
#'
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See `set_rapidpro_site()` to amend the website.
#' @param token A string containing the token to call the data. See `set_rapidpro_key()` to amend the token.
#' @param call_type A string containing the call type. By default this is `"contacts.json?group=joined"`. To get the user data, use `"contacts.json?group=joined"` or `"contacts.json"`.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#' @param date_from character string giving the date to filter the data from.
#' @param date_to character string giving the date to filter the data from.
#' @param format_date from `as.POSIX*` function: character string giving a date-time format as used by `strptime`.
#' @param tzone_date from `as.POSIX*` function: time zone specification to be used for the conversion, if one is required. System-specific (see time zones), but "" is the current time zone, and "GMT" is UTC (Universal Time, Coordinated). Invalid values are most commonly treated as UTC, on some platforms with a warning.
#' @param type character string giving the source of data (`"parenttext"`, `"srh_user"`)
#' @param unlist_consent Default `FALSE`. A boolean denoting whether to unlist a variable containing "consent".
#'
#' @return returns a data frame containing the contact data.
#' @export
get_user_data <- function(rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), call_type = "contacts.json?group=joined", flatten = FALSE, date_from = NULL, date_to = NULL, format_date = "%Y-%m-%d", tzone_date = "UTC", type = "parenttext", unlist_consent = FALSE){
  user_data <- get_data_from_rapidpro_api(call_type = call_type, rapidpro_site = rapidpro_site, token = token, flatten = flatten, date_from = NULL, date_to = NULL, format_date = format_date, tzone_date = tzone_date)
  
  if(type != "srh_user"){
    if (!flatten){
      if (!is.null(date_from)){
        user_data <- user_data %>% dplyr::filter(as.POSIXct(date_from, format=format_date, tzone = tzone_date) < as.POSIXct(user_data$created_on, format="%Y-%m-%dT%H:%M:%OS", tz = "UTC"))
      }
      if (!is.null(date_to)){
        user_data <- user_data %>% dplyr::filter(as.POSIXct(date_to, format=format_date, tzone = tzone_date) > as.POSIXct(user_data$created_on, format="%Y-%m-%dT%H:%M:%OS", tz = "UTC"))
      }
    } else {
      if (!is.null(date_from)){
        user_data <- user_data %>% dplyr::filter(as.POSIXct(date_from, format=format_date, tzone = tzone_date) < as.POSIXct(user_data$fields.starting_date, format="%Y-%m-%dT%H:%M:%OS", tz = "UTC"))
      }
      if (!is.null(date_to)){
        user_data <- user_data %>% dplyr::filter(as.POSIXct(date_to, format=format_date, tzone = tzone_date) > as.POSIXct(user_data$fields.starting_date, format="%Y-%m-%dT%H:%M:%OS", tz = "UTC"))
      }
    } 
  }
  if (unlist_consent){
    user_data <- unlist_rapidpro_variable(user_data)
  }
  return(user_data)
}
