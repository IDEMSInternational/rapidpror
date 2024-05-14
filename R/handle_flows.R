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
#' @export
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

#' Helper function to handle flow data of a specified type.
#'
#' This function processes flow data of a specified type and extracts relevant information.
#'
#' @param data A data frame containing flow data.
#' @param type The type of flow data to handle.
#' @param type_2 The group within `type` to handle.
#'
#' @export
#' @return A tibble with relevant information.
#'
handle_type_flow <- function(data, type = "completed", type_2 = "category") {
  response <- ifelse(is.na(data$values[[type]][[type_2]]), "No response", data$values[[type]][[type_2]])
  return(tibble::tibble(uuid = data$contact$uuid, interacted = data$responded, response, created_run_on = data$created_on))
}