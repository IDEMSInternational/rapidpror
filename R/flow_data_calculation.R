#' Calculate flow data.
#'
#' This function arranges flow data for different flow types.
#'
#' @param result_flow Data frame containing flow data.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#' @param flow_type Default `none`. Takes values `"praise"`, `"calm"`, `"check_in"`, `"tips"`, `"none"`. These are related to ParentText analysis.
#' @param flow_handle_type Default `NULL`. If `flow_type` is `other`, this is the value of the flow under `$value` to get the response for.
#' @param date_from character string giving the date to filter the data from.
#' @param date_to character string giving the date to filter the data to.
#' @param format_date character string giving a date-time format as used by `strptime`.
#' @param tzone_date time zone specification to be used for the conversion, if one is required.
#' @param created_on Parameter for flow_data.
#'
#' @return Data frame displaying the flow data.
#'
#' @importFrom dplyr %>%
flow_data_calculation <- function(result_flow, flatten = FALSE, flow_type = "none", flow_handle_type = NULL, flow_handle_type_sub = "category", date_from = NULL, date_to = NULL,
                                  format_date = "%Y-%m-%d", tzone_date = "UTC", created_on = FALSE) {
  if (length(result_flow) == 0) {
    return(NULL) 
  }
  if (flow_type == "other"){
    if (is.null(flow_handle_type)){
      warning("flow_handle_type is NULL. Setting flow_type as none.")
      flow_type <- "none"
    }
  }
  # Filter data based on date range
  if (!is.null(date_from)) {
    result_flow <- filter_date_range(result_flow, date_from, format_date, tzone_date)
  }
  if (!is.null(date_to)) {
    result_flow <- filter_date_range(result_flow, date_to, format_date, tzone_date, start = FALSE)
  }
  
  # Extract relevant columns
  uuid <- result_flow$contact$uuid
  interacted <- result_flow$responded
  created_run_on <- result_flow$created_on
  
  # Handle different flow types
  flow_interaction <- switch(flow_type,
                             "praise" = handle_praise_flow(result_flow),
                             "calm" = handle_calm_flow(result_flow),
                             "check_in" = handle_check_in_flow(result_flow),
                             "check_in_2" = handle_check_in_2_flow(result_flow),
                             "tips" = handle_tips_flow(result_flow),
                             "other" = handle_type_flow(result_flow, type = flow_handle_type, type_2 = flow_handle_type_sub),
                             "none" = tibble::tibble(uuid, interacted, created_run_on)
  )
  
  # Flatten the data if requested
  if (flatten) {
    flow_interaction <- jsonlite::flatten(flow_interaction)
  }
  
  return(flow_interaction)
}