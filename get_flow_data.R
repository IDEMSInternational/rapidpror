# Get run (flow) data
get_flow_data <- function(uuid_data = get_rapidpro_uuid_names(), flow_name, result, call_type="runs.json?flow=", rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE, checks = FALSE){
  # todo: checks/error handling messages.
  
  # todo: still need this?
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
      category <- result_flow$values$result$category            
      flow_interaction[[i]] <- tibble::tibble(uuid, response) #, category)
      flow_interaction[[i]] <- flow_interaction[[i]] %>% mutate(flow_type = uuid_flow[1])
      #if (flatten){
      flow_interaction[[i]] <- jsonlite::flatten(flow_interaction[[i]])
      #}
    }
  }
  names(flow_interaction) <- flow_name[1:length(flow_interaction)]
  return(flow_interaction)
}