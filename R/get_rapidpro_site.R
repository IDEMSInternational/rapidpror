#' Get the website from the environment
#' @description Call the website from the environment. The website is set in the function `set_rapidpro_site`. 
#'
#' @return returns a string containing the website name set in the environment for the RapidPro data.
#' @export
get_rapidpro_site = function() {
  get("rapidpro_site", envir = pkg_env)
}