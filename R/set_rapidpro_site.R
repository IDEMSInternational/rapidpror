#' Reset the website in the environment
#' @description Set the website to access the data.
#' 
#' @param site A string denoting the website to call the API data from.
#'
#' @return A string containing the RapidPro website.
#'
set_rapidpro_site = function(site) {
  if (!is.character(site)){
    stop("`site` provided should be a character variable")
  }
  pkg_env$rapidpro_site <- site 
}
