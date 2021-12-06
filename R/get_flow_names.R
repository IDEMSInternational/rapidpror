#' Get a data frame containing the UUID and names for flows.
#'
#' @description Call the names of each run (flow) and their UUID values. This function is often called inside another function.
#' 
#' @param call_type A string containing the call type.
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See `set_rapidpro_site()` to amend the website.
#' @param token A string containing the token to call the data. See `set_rapidpro_key()` to amend the token.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#'
#' @return A data frame containing the flows data in RapidPro.
#' @export
get_flow_names <- function(rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE){
  get_data_from_rapidpro_api(call_type = "flows.json", rapidpro_site = rapidpro_site, token = token, flatten = flatten)
}
