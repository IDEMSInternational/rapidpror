#' Reset the website in the environment
#'
#' @param site A string denoting the website to call the API data from.
#'
#' @return
#' @export
#'
#' @examples

set_rapidpro_site = function(site) {
  assign("rapidpro_site", site, envir = pkg.env)
}