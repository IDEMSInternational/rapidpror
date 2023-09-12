#' Get data from each run (flow)
#' @description Call RapidPro data from each run or flow.
#' 
#' @param uuid_data A string containing UUID values. See `set_rapidpro_uuid_names()` to set this value.
#' @param flow_name A string containing flow names to call data from.
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See `set_rapidpro_site()` to amend the website.
#' @param token A string containing the token to call the data. See `set_rapidpro_key()` to amend the token.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#' @param checks Default `FALSE`. A boolean whether to check and update the data if it is not found.
#' @param return_all Default `FALSE`. A boolean whether to return a specific part of the string, or all of the data.
#' @param flow_type Only if `return_all = FALSE`. Default `none`. Takes values `"praise"`, `"calm"`, `"check_in"`, `"tips"`, `"none"`, `"other"`. These are related to ParentText.
#' @param flow_handle_type Default `NULL`. If `flow_type` is `other`, this is the value of the flow under `$value` to get the response for.
#' @param flow_handle_type_sub Default `NULL`. If `flow_type` is `other`, this is the group within `flow_handle_type` to handle.
#' @param include_archived_data Default `FALSE`. A boolean denoting whether to include archived data or not.
#' @param get_by A string denoting how to access the archived data (if `include_archived_data` is `TRUE`). Options are `"read_from_RDS"`, `"gotit"`. The first denotes that the data is read from an RDS file (given in `read_archived_data_from`), the latter that the data is stored and will be read in directly (see `data_from_archived`).
#' @param data_from_archived If `get_by = "gotit"`, this is the archived data.
#' @param read_archived_data_from If `get_by = "read_from_RDS"`, this is the archived data.
#' @param created_on Parameter for flow_data.
#' @param date_from character string giving the date to filter the data from.
#' @param date_to character string giving the date to filter the data to.
#' @param format_date from `as.POSIX*` function: character string giving a date-time format as used by `strptime`.
#' @param tzone_date from `as.POSIX*` function: time zone specification to be used for the conversion, if one is required. System-specific (see time zones), but "" is the current time zone, and "GMT" is UTC (Universal Time, Coordinated). Invalid values are most commonly treated as UTC, on some platforms with a warning.
#'
#' @return List separated by each flow_name provided. Each element in the list contains a data frame for each flow_name provided.
#' @export
# TODO: `flow_type` is relevant to ParentText. We should have a general wrapper for this function in the rapidpror package
# That wrapper function calls this parenttext specific function from a separate package, and has flow_type = "none".
get_flow_data <- function(uuid_data = get_rapidpro_uuid_names(), flow_name, rapidpro_site = get_rapidpro_site(), 
                          token = get_rapidpro_key(), flatten = FALSE, checks = FALSE, return_all = FALSE,
                          flow_type = "none", flow_handle_type = NULL, flow_handle_type_sub = "category", 
                          include_archived_data = FALSE, get_by = "gotit", data_from_archived = NULL, 
                          read_archived_data_from = NULL, created_on = FALSE, date_from = NULL, 
                          date_to = NULL, format_date = "%Y-%m-%d", tzone_date = "UTC") 
{
  call_type <- "runs.json?flow="
  if (is.null(rapidpro_site)) {
    stop("rapidpro_site is NULL. Set a website with `set_rapidpro_site`.")
  }
  if (is.null(token)) {
    stop("token is NULL. Set a token with `set_rapidpro_key`.")
  }
  if (is.null(call_type)) {
    stop("call_type is NULL. Expecting a valid call_type.")
  }
  if (!is.character(call_type)) {
    stop("call_type should be a character variable.")
  }
  if (is.null(flow_name)) {
    stop("flow_name is NULL. Expecting a valid flow_name")
  }
  if (!is.character(flow_name)) {
    stop("flow_name should be a character variable.")
  }
  if (!is.logical(flatten)) {
    stop("flatten should be TRUE or FALSE")
  }
  if (!is.logical(checks)) {
    stop("checks should be TRUE or FALSE")
  }
  if (checks) {
    i = 1
    if (nrow(uuid_data[which(uuid_data$name == flow_name), 
    ]) == 0 & i == 1) {
      message("flow_name not recognised. Updating uuid_data sheet")
      set_rapidpro_uuid_names()
      uuid_data = get_rapidpro_uuid_names()
      i = i + 1
      if (nrow(uuid_data[which(uuid_data$name == flow_name), 
      ]) == 0) {
        stop("flow_name not recognised.")
      }
      else {
        message("flow_name recognised. Updated uuid_data sheet")
      }
    }
  }
  flow_data_bank <- NULL
  flow_data <- NULL
  for (i in flow_name) {
    j <- which(flow_name == i)
    uuid_flow <- uuid_data[which(uuid_data$name == i), ]
    get_command <- paste(rapidpro_site, call_type, uuid_flow[1], 
                         sep = "")
    result_flow <- httr_get_call(get_command = get_command, token = token)
    if (return_all){
      flow_data[[j]] <- result_flow
    } else {
      if (length(result_flow) == 0) {
        flow_data[[j]] <- NULL
      }
      else {
        flow_data[[j]] <- flow_data_calculation(result_flow = result_flow, 
                                                flatten = flatten, flow_type = flow_type, flow_handle_type = flow_handle_type, 
                                                flow_handle_type_sub = flow_handle_type_sub, 
                                                date_from = date_from, date_to = date_to, format_date = format_date, 
                                                tzone_date = tzone_date, created_on = created_on) %>% 
          dplyr::mutate(flow_type = uuid_flow[1, 1])
      }
    }
  }
  if (return_all){
    return(flow_data)
  }
  if (!is.null(flow_data)) {
    names(flow_data) <- flow_name[1:length(flow_data)]
  }
  flow_data <- plyr::ldply(flow_data)
  if (!include_archived_data) {
    flow_data_bank <- flow_data
  }
  else {
    flow_data_bank[[1]] <- flow_data
    if (get_by == "read") {
      archived_data <- readRDS(read_archived_data_from)
    }
    else {
      archived_data <- data_from_archived
    }
    arch_data_bank <- NULL
    for (i in flow_name) {
      j <- which(flow_name == i)
      uuid_flow <- uuid_data[which(uuid_data$name == i), 
      ]
      arch_data <- NULL
      for (k in 1:length(archived_data)) {
        arch_flow_data_K <- archived_data[[k]] %>% dplyr::filter(archived_data[[k]]$flow$name == 
                                                                   i)
        arch_data[[k]] <- flow_data_calculation(result_flow = arch_flow_data_K, 
                                                flow_type = flow_type)
      }
      names(arch_data) <- names(archived_data)[1:length(arch_data)]
      arch_data_bank[[j]] <- plyr::ldply(arch_data)
      arch_data_bank[[j]]$.id <- NULL
      arch_data_bank[[j]] <- arch_data_bank[[j]] %>% dplyr::mutate(flow_type = uuid_flow[1, 
                                                                                         1])
    }
    names(arch_data_bank) <- flow_name
    arch_data_bank <- plyr::ldply(arch_data_bank)
    flow_data_bank[[2]] <- arch_data_bank
    names(flow_data_bank) <- c("Current", "Archived")
    flow_data_bank <- plyr::ldply(flow_data_bank)
  }
  return(flow_data_bank)
}