#' Get the site value from the environment
#'
#' @return returns a string containing the website name set in the environment for the rapidPro data.
#' @export
#'
#' @examples
get_rapidpro_site = function() {
  get("rapidpro_site", envir = pkg.env)
}