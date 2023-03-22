#' Count number of active days for each user
#' @description The number of days that each user is active
#'
#' @param uuid_data A string containing UUID values. See `set_rapidpro_uuid_names()` to set this value.
#' @param flow_name A string containing flow names to call data from.
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See `set_rapidpro_site()` to amend the website.
#' @param token A string containing the token to call the data. See `set_rapidpro_key()` to amend the token.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#' @param read_runs Default `FALSE`. A boolean denoting whether to read in the `runs_data`, or to read the data from RapidPro
#' @param runs_data If the "runs.json" data has been read in already, this is the run data. Instead, the `uuid_data`, `call_type`, and `token` can be given (note that this latter approach is slower since it requires reading the data in).
#' @param include_archived_data Default `FALSE`. A boolean denoting whether to include archived data or not.
#' @param get_by A string denoting how to access the archived data (if `include_archived_data` is `TRUE`). Options are `"read_from_RDS"`, `"gotit"`. The first denotes that the data is read from an RDS file (given in `read_archived_data_from`), the latter that the data is stored and will be read in directly (see `data_from_archived`).
#' @param data_from_archived If `get_by = "gotit"`, this is the archived data.
#' @param read_archived_data_from If `get_by = "read_from_RDS"`, this is the archived data.
#' 
#' @return A data frame with two columns: The unique ID of the individual, and the number of days they have been active.
#' @export
#' @importFrom dplyr %>%
days_active_data <- function(uuid_data = get_rapidpro_uuid_names(), flow_name, rapidpro_site = get_rapidpro_site(),
                             token = get_rapidpro_key(), flatten = FALSE, read_runs = FALSE, runs_data = "result_flow_runs.RDS", 
                             include_archived_data = FALSE, get_by = "gotit", data_from_archived = archived_data,
                             read_archived_data_from = "archived_data_monthly.RDS"){
  # note: moved call_type here. Check this hasn't created issues.
  call_type <- "runs.json"
  
  if(read_runs){
    result_flow_runs <- readRDS(runs_data)
  } else {
    get_command <- paste(rapidpro_site, call_type, sep = "")
    result_flow <- httr_get_call(get_command = get_command, token = token)
    result_flow_runs <- result_flow
  }
  
  #saveRDS(result_flow_runs, "result_flow_runs.RDS")
  
  data_flow <- result_flow_runs %>% 
    dplyr::filter(responded == TRUE) %>%
    dplyr::mutate(day_created = as.Date(created_on))
  day_active <- data_flow$day_created
  ID <- data_flow$contact$uuid
  day_created <- data.frame(day_active, ID)
  day_created <- unique(day_created)
  active_days_nonarch <- day_created
  
  # for archived data
  if (!include_archived_data){
    active_days_data <- active_days_nonarch
  } else {
    flow_data_bank[[1]] <- flow_data
    if (get_by == "read_from_RDS"){
      archived_data <- readRDS(read_archived_data_from)
    } else {
      archived_data <- data_from_archived
    }
    active_days <- NULL
    result_flow <- archived_data
    for (k in 1:length(archived_data)){
      data_flow <- result_flow[[k]]
      if (nrow(data_flow) > 0){
        data_flow <- data_flow %>% 
          dplyr::filter(responded == TRUE) %>%
          dplyr::mutate(day_created = as.Date(created_on))
        day_active <- data_flow$day_created
        ID <- data_flow$contact$uuid
        day_created <- data.frame(day_active, ID)
        day_created <- unique(day_created)
        active_days[[k]] <- day_created
      }
    }
    active_days_archived <- plyr::ldply(active_days)
    active_days_archived <- unique(active_days_archived)
    active_days_data <- dplyr::bind_rows(active_days_nonarch, active_days_archived)
    
  }
  active_days_data <- unique(active_days_data) 
  active_days_data <- active_days_data %>%
    dplyr::group_by(ID) %>%
    dplyr::summarise(number_days_active = n())
  return(active_days_data)
}
