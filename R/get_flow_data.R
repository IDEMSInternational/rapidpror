#' Get Data from each Run (Flow)
#'
#' @description Call RapidPro data from each run or flow.
#' 
#' @param uuid_data A string containing UUID values. See `set_rapidpro_uuid_names()` to set this value.
#' @param flow_name A string containing flow names to call data from.
#' @param result TODO: result name? If so, we need to make it so you can change the result name.
#' @param call_type A string containing the call type.
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See `set_rapidpro_site()` to amend the website.
#' @param token A string containing the token to call the data. See `set_rapidpro_key()` to amend the token.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#' @param checks Default `FALSE`. A boolean whether to check and update the data if it is not found.
#'
#' @return List separated by each flow_name provided. Each element in the list contains a data frame for each flow_name provided.
#' @export
get_flow_data <- function(uuid_data = get_rapidpro_uuid_names(), flow_name, call_type = "runs.json?flow=", rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE, checks = FALSE){
  if (is.null(rapidpro_site)){
    stop("rapidpro_site is NULL. Set a website with `set_rapidpro_site`.")
  }
  if (is.null(token)){
    stop("token is NULL. Set a token with `set_rapidpro_key`.")
  }
  if (is.null(call_type)){
    stop("call_type is NULL. Expecting a valid call_type.")
  }
  if (!is.character(call_type)){
    stop("call_type should be a character variable.")
  }
  if (is.null(flow_name)){
    stop("flow_name is NULL. Expecting a valid flow_name")
  }
  if (!is.character(flow_name)){
    stop("flow_name should be a character variable.")
  }
  if (!is.logical(flatten)){
    stop("flatten should be TRUE or FALSE")
  }
  if (!is.logical(checks)){
    stop("checks should be TRUE or FALSE")
  }
  
  if (checks){
    i = 1
    if (nrow(uuid_data[which(uuid_data$name == flow_name),]) == 0 & i == 1){
      message("flow_name not recognised. Updating uuid_data sheet")
      set_rapidpro_uuid_names()
      uuid_data = get_rapidpro_uuid_names()
      i = i + 1
      if (nrow(uuid_data[which(uuid_data$name == flow_name),]) == 0){
        stop("flow_name not recognised.")
      } else {
        message("flow_name recognised. Updated uuid_data sheet")
      }
    }
  }
  flow_interaction <- NULL
  for (i in 1:length(flow_name)){
    uuid_flow <- uuid_data[which(uuid_data$name == flow_name[i]),]
    get_command <- paste(rapidpro_site, call_type, uuid_flow[1], sep = "")
    result_flow <- httr_get_call(get_command = get_command, token = token)
    if (length(result_flow) == 0){
      flow_interaction[[i]] <- NULL
    } else {
      uuid <- result_flow$contact$uuid
      response <- result_flow$responded
      #result <- na.omit(unique(flatten(result_flow$values)$name))[1]
      #if (length(result) == 1){
      #  category <- flatten(result_flow$values %>% dplyr::select({{ result }}))$category
      #} else {
      #  warning("category result not found")
      #  category <- NA
      #}
      flow_interaction[[i]] <- tibble::tibble(uuid, response)#, category)
      flow_interaction[[i]] <- flow_interaction[[i]] %>% mutate(flow_type = uuid_flow[1])
      #if (flatten){
      flow_interaction[[i]] <- jsonlite::flatten(flow_interaction[[i]])
      #}
    }
  }
  names(flow_interaction) <- flow_name[1:length(flow_interaction)]
  return(flow_interaction)
}
