#' Get the Website from the Environment
#' @description Call the website from the environment. The website is set in the function `set_rapidpro_website`. 
#'
#' @return returns a string containing the website name set in the environment for the RapidPro data.
#' @export
get_rapidpro_site = function() {
  get("rapidpro_site", envir = pkg_env)
}
