#' Calling data from RapidPro API
#' 
#' @description A generalised way to call data from the RapidPro API.
#'
#' @param call_type A string containing the call type, e.g., `"flows.json"`.
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See `set_rapidpro_site()` to amend the website.
#' @param token A string containing the token to call the data. See `set_rapidpro_key()` to amend the token.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#' @param date_from character string giving the date to filter the data from.
#' @param format_date from `as.POSIX*` function: character string giving a date-time format as used by `strptime`.
#' @param tzone_date from `as.POSIX*` function: time zone specification to be used for the conversion, if one is required. System-specific (see time zones), but "" is the current time zone, and "GMT" is UTC (Universal Time, Coordinated). Invalid values are most commonly treated as UTC, on some platforms with a warning.
#' 
#' @return A data frame of the data specified in the `call_type` parameter.
#' 
#' @importFrom dplyr %>%
get_data_from_rapidpro_api <- function(call_type, rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE,
                                       date_from, format_date = "%Y-%m-%d", tzone_date = "UTC"){
  if (is.null(rapidpro_site)){
    stop("rapidpro_site is NULL. Set a website with `set_rapidpro_site`.")
  }
  if (is.null(token)){
    stop("token is NULL. Set a token with `set_rapidpro_key`.")
  }
  if (is.null(call_type)){
    stop("call_type is NULL. Expecting a valid call_type.")
  }
  if (!is.logical(flatten)){
    stop("flatten should be TRUE or FALSE")
  }
  get_command <- paste(rapidpro_site, call_type, sep = "")
  user_result <- httr_get_call(get_command = get_command, token = token)
  if (flatten){
    user_result <- jsonlite::flatten(user_result)
  }
  if (!is.null(date_from)){
    user_result <- user_result %>% dplyr::filter(as.POSIXct(date_from, format=format_date, tzone = tzone_date) < as.POSIXct(user_result$created_on, format="%Y-%m-%dT%H:%M:%OS", tz = "UTC"))
  }
  return(user_result)
}
