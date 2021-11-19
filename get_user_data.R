# Get the contacts data

get_user_data <- function(call_type="contacts.json", rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE){
  # todo: checks/error handling messages.
  get_command <- paste(rapidpro_site, call_type, sep = "")
  user_result <- httr_get_call(get_command = get_command, token = token)
  if (flatten){
    user_result <- jsonlite::flatten(user_result)
  }
  return(user_result)
}