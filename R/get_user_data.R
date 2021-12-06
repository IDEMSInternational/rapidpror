#' Get data for each user
#' @description Call the contact data from RapidPro for each user
#'
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See `set_rapidpro_site()` to amend the website.
#' @param token A string containing the token to call the data. See `set_rapidpro_key()` to amend the token.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#'
#' @return returns a data frame containing the contact data.
#' @export
get_user_data <- function(rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), flatten = FALSE){
  get_data_from_rapidpro_api(call_type = "contacts.json", rapidpro_site = rapidpro_site, token = token, flatten = flatten)
}
