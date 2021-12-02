#' Reset the website in the environment
#'
#' @param site A string denoting the website to call the API data from.
#'
#' @return
#' @export
#'
set_rapidpro_site = function(site) {
  pkg_env$rapidpro_site <- NULL 
}