#' Helper function to filter data by date range.
#'
#' This function filters a data frame based on a specified date range.
#'
#' @param data A data frame to be filtered.
#' @param date The date to filter the data by.
#' @param format The date-time format as used by `strptime`.
#' @param tzone The time zone specification to be used for conversion.
#' @param start A logical value indicating whether to filter for dates before or after the specified date.
#'
#' @return A filtered data frame.
#'
#' @importFrom dplyr %>%
filter_date_range <- function(data, date, format, tzone, start = TRUE) {
  date_posix <- as.POSIXct(date, format = format, tz = tzone)
  if (start) {
    return(dplyr::filter(data, date_posix < as.POSIXct(data$created_on, format="%Y-%m-%dT%H:%M:%OS", tz = "UTC")))
  } else {
    return(dplyr::filter(data, date_posix > as.POSIXct(data$created_on, format="%Y-%m-%dT%H:%M:%OS", tz = "UTC")))
  }
}

#' Helper function to handle praise flow data.
#'
#' This function processes praise flow data and extracts relevant information.
#'
#' @param data A data frame containing praise flow data.
#'
#' @return A tibble with relevant information.
#'
handle_praise_flow <- function(data) {
  response <- data$values$praise_interaction$category
  response <- tidyr::replace_na(response, "No response")
  return(tibble::tibble(uuid = data$contact$uuid, interacted = data$responded, response, created_run_on = data$created_on))
}

#' Helper function to handle calm flow data.
#'
#' This function processes calm flow data and extracts relevant information.
#'
#' @param data A data frame containing calm flow data.
#'
#' @return A tibble with relevant information.
#'
handle_calm_flow <- function(data) {
  response <- data$values$calm_interaction$category
  response <- tidyr::replace_na(response, "No response")
  return(tibble::tibble(uuid = data$contact$uuid, interacted = data$responded, response, created_run_on = data$created_on))
}

#' Helper function to handle check-in flow data.
#'
#' This function processes check-in flow data and extracts relevant information.
#'
#' @param data A data frame containing check-in flow data.
#'
#' @return A tibble with relevant information.
#'
handle_check_in_flow <- function(data) {
  managed_to_do_something <- ifelse(is.na(data$values$checkin_managed$category), "No response", data$values$checkin_managed$category)
  response <- ifelse(is.na(data$values$checkin_how$category), "No response", data$values$checkin_how$category)
  return(tibble::tibble(uuid = data$contact$uuid, interacted = data$responded, managed_to_do_something, response, created_run_on = data$created_on))
}

#' Helper function to handle check-in 2 flow data.
#'
#' This function processes check-in 2 flow data and extracts relevant information.
#'
#' @param data A data frame containing check-in 2 flow data.
#'
#' @return A tibble with relevant information.
#'
handle_check_in_2_flow <- function(data) {
  handle_type_flow(data = data, type = "completed")
}

#' Helper function to handle flow data of a specified type.
#'
#' This function processes flow data of a specified type and extracts relevant information.
#'
#' @param data A data frame containing flow data.
#' @param type The type of flow data to handle.
#' @param type_2 The group within `type` to handle.
#'
#' @return A tibble with relevant information.
#'
handle_type_flow <- function(data, type = "completed", type_2 = "category") {
  response <- ifelse(is.na(data$values[[type]][[type_2]]), "No response", data$values[[type]][[type_2]])
  return(tibble::tibble(uuid = data$contact$uuid, interacted = data$responded, response, created_run_on = data$created_on))
}

#' Helper function to handle tips flow data.
#'
#' This function processes tips flow data and extracts relevant information.
#'
#' @param data A data frame containing tips flow data.
#'
#' @return A tibble with relevant information.
#'
handle_tips_flow <- function(data) {
  handle_type_flow(data = data, type = "know_more")
}
