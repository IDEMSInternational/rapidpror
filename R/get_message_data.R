#' Retrieve Message Data from RapidPro API
#'
#' @description
#' Fetches message data from the RapidPro API, allowing filtering based on different criteria such as folder, contact, label, or broadcast.
#'
#' @param rapidpro_site A character string specifying the base URL of the RapidPro instance. Defaults to `get_rapidpro_site()`.
#' @param token A character string specifying the API token for authentication. Defaults to `get_rapidpro_key()`.
#' @param call_type A character string indicating the type of API call. Default is `"messages.json"`.
#' @param filter_variable A character string specifying the filtering criterion. Must be one of `"folder"`, `"contact"`, `"label"`, or `"broadcast"`. Default is `"folder"`.
#' @param filter_variable_value A character string specifying the value for the filter variable. If `filter_variable = "folder"`, the allowed values are `"inbox"`, `"flows"`, `"archived"`, `"outbox"`, `"sent"`, or `"failed"`. Default is `"flows"`.
#' @param flatten A logical value indicating whether to flatten the retrieved data. Default is `FALSE`.
#' @param date_from A character string specifying the start date for filtering messages (in the format specified by `format_date`). Default is `NULL`, meaning no filtering by start date.
#' @param date_to A character string specifying the end date for filtering messages (in the format specified by `format_date`). Default is `NULL`, meaning no filtering by end date.
#' @param format_date A character string specifying the date format used for filtering. Default is `"%Y-%m-%d"`.
#' @param tzone_date A character string specifying the time zone for date filtering. Default is `"UTC"`.
#'
#' @details
#' - Only **one filter** can be applied at a time.
#' - The function removes messages with missing UUIDs to ensure data consistency.
#'
#' @return A tibble containing the retrieved message data, filtered according to the provided criteria.
#'
#' @examples
#' # Retrieve messages from the "flows" folder
#' #get_message_data(filter_variable = "folder", filter_variable_value = "flows")
#'
#' # Retrieve messages from a specific contact
#' #get_message_data(filter_variable = "contact", filter_variable_value = "12345")
#'
#' # Retrieve messages with a specific label
#' #get_message_data(filter_variable = "label", filter_variable_value = "survey_responses")
#'
#' # Retrieve messages from a broadcast
#' #get_message_data(filter_variable = "broadcast", filter_variable_value = "98765")
#'
#' @export
get_message_data <- function(rapidpro_site = get_rapidpro_site(), 
                             token = get_rapidpro_key(), 
                             call_type = "messages.json", 
                             filter_variable = "folder", 
                             filter_variable_value = "flows", 
                             flatten = FALSE, 
                             date_from = NULL, 
                             date_to = NULL, 
                             format_date = "%Y-%m-%d", 
                             tzone_date = "UTC") {
  
  # Build the API call with filtering if applicable
  if (!is.null(filter_variable) & !is.null(filter_variable_value)){
    call_type <- paste0(call_type, "?", filter_variable, "=", filter_variable_value)
  } 
  
  # Retrieve data from the API
  message_data <- purrr::map(.x = call_type, .f = ~get_data_from_rapidpro_api(
    call_type = .x, 
    rapidpro_site = rapidpro_site, 
    token = token, 
    flatten = flatten, 
    date_from = date_from, 
    date_to = date_to, 
    format_date = format_date, 
    tzone_date = tzone_date
  ))
  
  # Combine and deduplicate the data
  message_data <- unique(dplyr::bind_rows(message_data))
  
  # Filter out rows with missing UUIDs
  message_data <- message_data %>% dplyr::filter(!is.na(uuid))
  
  # Apply date filtering if dates are provided
  if (!flatten) {
    if (!is.null(date_from)) {
      message_data <- message_data %>% dplyr::filter(
        as.POSIXct(date_from, format = format_date, tzone = tzone_date) < 
          as.POSIXct(message_data$created_on, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC")
      )
    }
    if (!is.null(date_to)) {
      message_data <- message_data %>% dplyr::filter(
        as.POSIXct(date_to, format = format_date, tzone = tzone_date) > 
          as.POSIXct(message_data$created_on, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC")
      )
    }
  } else {
    if (!is.null(date_from)) {
      message_data <- message_data %>% dplyr::filter(
        as.POSIXct(date_from, format = format_date, tzone = tzone_date) < 
          as.POSIXct(message_data$fields.starting_date, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC")
      )
    }
    if (!is.null(date_to)) {
      message_data <- message_data %>% dplyr::filter(
        as.POSIXct(date_to, format = format_date, tzone = tzone_date) > 
          as.POSIXct(message_data$fields.starting_date, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC")
      )
    }
  } 
  
  # Return the final user data
  return(message_data)
}
