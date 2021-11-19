# This function is usually called in another function
#' Function to get a data frame containing the UUID and names for flows.
#'
#' @param call_type A string containing the call type.
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See set_rapidpro_site() to amend the website.
#' @param token A string containing the token to call the data. See set_rapidpro_key() to amend the token.
#' @param flatten Default FALSE. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#'
#' @return
#' @export
#'
#' @examples
get_flow_names <- function(call_type = "flows.json", rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE){
  # TODO put in checks - check site is correct, then token, then call_type
  get_command <- paste(rapidpro_site, call_type, sep = "")
  flow_names <- httr_get_call(get_command = get_command, token = token)
  if (flatten){
    flow_names <- jsonlite::flatten(flow_names)
  }
  return(flow_names)
}