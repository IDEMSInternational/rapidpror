#' Get the key (Token) from the environment
#'
#' @return returns a string containing the key (Token) set in the environment for the rapidPro data.
#' @export
#'
#' @examples
get_rapidpro_key = function() {
  get("rapidpro_key", envir = pkg.env)
}