# Function to get a list of the UUID of flows. This function is usually called in another function
get_flow_names <- function(call_type = "flows.json", rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE){
  # TODO put in checks - check site is correct, then token, then call_type
  get_command <- paste(rapidpro_site, call_type, sep = "")
  flow_names <- httr_get_call(get_command = get_command, token = token)
  if (flatten){
    flow_names <- jsonlite::flatten(flow_names)
  }
  return(flow_names)
}