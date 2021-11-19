# A generalised version of get_user_data.R
# We don't use this function, but it may have a purpose. TODO: discuss this. 
#' 
#' Calling data from rapidpro API
#' 
#' @param call_type A string containing the call type
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See set_rapidpro_site() to amend the website.
#' @param token A string containing the token to call the data. See set_rapidpro_key() to amend the token.
#' @param flatten Default FALSE. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#'
#' @return TODO
#' @export
#'
#' @examples
#' TODO
get_data_from_rapidpro_api <- function(call_type, rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE){
  get_command <- paste(rapidpro_site, call_type, sep = "")
  user_result <- httr_get_call(get_command = get_command, token = token)
  if (flatten){
    user_result <- jsonlite::flatten(user_result)
  }
  return(user_result)
}