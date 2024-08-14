#' Get data for each user from RapidPro
#' 
#' @description 
#' This function retrieves contact data from RapidPro for each user. It is a wrapper function around `get_data_from_rapidpro_api` and allows for filtering and formatting of the returned data.
#'
#' @param rapidpro_site A string containing the RapidPro website URL from which to retrieve the data. Use `set_rapidpro_site()` to amend the website.
#' @param token A string containing the API token required for authentication. Use `set_rapidpro_key()` to set the token.
#' @param call_type A string specifying the type of data call. The default is `"contacts.json"`. To get user data for a specific group, such as `"joined"`, set this parameter to `"contacts.json?group=joined"`, or, for multiple groups use the `filter_variable` and `filter_variable_value` parameters.
#' @param filter_variable A string specifying the variable used to filter the data. The default is `"group"`. This variable is appended to the `call_type` to form the final API endpoint.
#' @param filter_variable_value A string specifying the value of `filter_variable` used to filter the data. For example, `"joined"` can be used to filter contacts by group.
#' @param flatten Logical, default is `FALSE`. If `TRUE`, the data will be flattened into a two-dimensional tabular structure.
#' @param date_from A character string representing the start date to filter the data from. The date format should match `format_date`.
#' @param date_to A character string representing the end date to filter the data to. The date format should match `format_date`.
#' @param format_date A character string specifying the date-time format, as used by `strptime`. The default is `"%Y-%m-%d"`.
#' @param tzone_date A character string specifying the time zone for date conversion. The default is `"UTC"`. This parameter is passed to `as.POSIXct` to ensure correct time zone handling.
#' @param unlist_consent Logical, default is `FALSE`. If `TRUE`, any variables containing "consent" in their name will be unlisted, simplifying the data structure.
#'
#' @return 
#' A data frame containing the contact data from RapidPro, filtered and formatted according to the specified parameters.
#'
#' @details 
#' This function builds the API call to retrieve user data from RapidPro, with optional filtering by group and date. The retrieved data can be flattened into a simple data frame, and optional date filters can be applied. If `unlist_consent` is set to `TRUE`, variables containing "consent" will be unlisted to simplify the structure.
#'
#' @examples 
#' #\dontrun{
#' ## Set the RapidPro site and API key
#' #set_rapidpro_site("https://app.rapidpro.io")
#' #set_rapidpro_key("your_api_key")
#'#
#'# # Get data for users in the "joined" group
#'# user_data <- get_user_data(call_type = "contacts.json", filter_variable = "group", filter_variable_value = "joined")
#'#
#'# # Get data for users in the "joined" group, filtering by date range
#'# user_data <- get_user_data(call_type = "contacts.json", filter_variable = "group", filter_variable_value = "joined", date_from = "2023-01-01", date_to = "2023-12-31")
#'# }
#'
#' @export
get_user_data <- function(rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), call_type = "contacts.json", filter_variable = "group", filter_variable_value = "joined", flatten = FALSE, date_from = NULL, date_to = NULL, format_date = "%Y-%m-%d", tzone_date = "UTC", unlist_consent = FALSE){
  
  # Build the API call with filtering if applicable
  if (!is.null(filter_variable) & !is.null(filter_variable_value)){
    call_type <- paste0(call_type, "?", filter_variable, "=", filter_variable_value)
  } 
  
  # Retrieve data from the API
  user_data <- purrr::map(.x = call_type, .f = ~get_data_from_rapidpro_api(call_type = .x, rapidpro_site = rapidpro_site, token = token, flatten = flatten, date_from = date_from, date_to = date_to, format_date = format_date, tzone_date = tzone_date))
  
  # Combine and deduplicate the data
  user_data <- unique(bind_rows(user_data))
  
  # Filter out rows with missing UUIDs
  user_data <- user_data %>% filter(!is.na(uuid))
  
  # Apply date filtering if dates are provided
  if (!flatten){
    if (!is.null(date_from)){
      user_data <- user_data %>% dplyr::filter(as.POSIXct(date_from, format = format_date, tzone = tzone_date) < as.POSIXct(user_data$created_on, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC"))
    }
    if (!is.null(date_to)){
      user_data <- user_data %>% dplyr::filter(as.POSIXct(date_to, format = format_date, tzone = tzone_date) > as.POSIXct(user_data$created_on, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC"))
    }
  } else {
    if (!is.null(date_from)){
      user_data <- user_data %>% dplyr::filter(as.POSIXct(date_from, format = format_date, tzone = tzone_date) < as.POSIXct(user_data$fields.starting_date, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC"))
    }
    if (!is.null(date_to)){
      user_data <- user_data %>% dplyr::filter(as.POSIXct(date_to, format = format_date, tzone = tzone_date) > as.POSIXct(user_data$fields.starting_date, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC"))
    }
  } 
  
  # Unlist "consent" variables if specified
  if (unlist_consent){
    user_data <- unlist_rapidpro_variable(user_data)
  }
  
  # Return the final user data
  return(user_data)
}
