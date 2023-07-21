#' Calculation to get the flow data.
#' @description This is called in the `get_flow_data` function. This function arranges the function for different flow types.
#'
#' @param result_flow Data frame containing flow data.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#' @param flow_type Default `none`. Takes values `"praise"`, `"calm"`, `"check_in"`, `"tips"`, `"none"`. These are related to ParentText analysis.
#' @param date_from character string giving the date to filter the data from.
#' @param date_to character string giving the date to filter the data to.
#' @param format_date from `as.POSIX*` function: character string giving a date-time format as used by `strptime`.
#' @param tzone_date from `as.POSIX*` function: time zone specification to be used for the conversion, if one is required. System-specific (see time zones), but "" is the current time zone, and "GMT" is UTC (Universal Time, Coordinated). Invalid values are most commonly treated as UTC, on some platforms with a warning.
#' @param created_on Parameter for flow_data.
#'
#' @return Data frame displaying the flow data.
#'
#' @importFrom dplyr %>%
flow_data_calculation <- function(result_flow, flatten = FALSE, flow_type = "none", date_from = NULL, date_to = NULL,
                                  format_date = "%Y-%m-%d", tzone_date = "UTC", created_on = FALSE){
  if (length(result_flow) == 0){
    flow_interaction <- NULL
  } else {
    if (!is.null(date_from)){
      result_flow <- result_flow %>% dplyr::filter(as.POSIXct(date_from, format=format_date, tzone = tzone_date) < as.POSIXct(result_flow$created_on, format="%Y-%m-%dT%H:%M:%OS", tz = "UTC"))
    }
    if (!is.null(date_to)){
      result_flow <- result_flow %>% dplyr::filter(as.POSIXct(date_to, format=format_date, tzone = tzone_date) > as.POSIXct(result_flow$created_on, format="%Y-%m-%dT%H:%M:%OS", tz = "UTC"))
    }
    uuid <- result_flow$contact$uuid
    interacted <- result_flow$responded
    created_run_on <- result_flow$created_on
    exit_type <- result_flow$exit_type
    modified_on <- result_flow$modified_on
    exited_on <- result_flow$exited_on
    
    # Relevant to ParentText only -----------------------------------------------------
    # for check in:
    if (flow_type == "praise" && nrow(result_flow$values) > 0){
      response <- result_flow$values$praise_interaction$category 
      if (!is.null(response)){
        flow_interaction <- tibble::tibble(uuid, interacted, response, created_run_on)
        response <- tidyr::replace_na(response, "No response")
      } else {
        flow_interaction <- tibble::tibble(uuid, interacted, response = "No response", created_run_on) 
      }
    } else if (flow_type == "calm" && !is.null(result_flow$values$calm_interaction)){
      response <- result_flow$values$calm_interaction$category
      response <- tidyr::replace_na(response, "No response")
      flow_interaction <- tibble::tibble(uuid, interacted, response, created_run_on)
    } else if (flow_type == "check_in" && nrow(result_flow$values) > 0){
      if (is.null(result_flow$values$checkin_managed$category)){
        managed_to_do_something <- "No response"
      } else {
        managed_to_do_something <- result_flow$values$checkin_managed$category
      }
      if (is.null(result_flow$values$checkin_how$category)){
        response <- "No response"
      } else {
        response <- result_flow$values$checkin_how$category
      }
      flow_interaction <- tibble::tibble(uuid, interacted, managed_to_do_something, response, created_run_on)
    } else if (flow_type == "tips" && nrow(result_flow$values) > 0){
      if (is.null(result_flow$values$know_more$category)){
        category <- "No response"
      } else {
        category <- result_flow$values$know_more$category
      }
      flow_interaction <- tibble::tibble(uuid, interacted, category, created_run_on)
    } else {
      flow_interaction <- tibble::tibble(uuid, interacted, created_run_on)
    }
    flow_interaction <- jsonlite::flatten(flow_interaction)
  }
  return(flow_interaction)
}