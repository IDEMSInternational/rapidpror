#' Reset the key value in the environment
#'
#' @param key A string denoting the API Token associated with the website given in set_rapidpro_site()
#'
#' @return
#' @export
#'
#' @examples
set_rapidpro_key = function(key) {
  assign("rapidpro_key", key, envir = pkg.env)
}