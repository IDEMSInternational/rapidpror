# Calling data from rapidpro API
# A generalised version of get_user_data.R
# We don't use this function, but it may have a purpose. TODO: discuss this. 
get_data_from_rapidpro_api <- function(call_type, rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE){
  get_command <- paste(rapidpro_site, call_type, sep = "")
  user_result <- httr_get_call(get_command = get_command, token = token)
  if (flatten){
    user_result <- jsonlite::flatten(user_result)
  }
  return(user_result)
}