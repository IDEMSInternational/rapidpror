#' Get the key (token) from the environment
#' 
#' @description Call the key (token) from the environment. The key is set in the function `set_rapidpro_key`. 
#'
#' @return returns a string containing the key (Token) set in the environment for the rapidPro data.
#' @export
get_rapidpro_key = function() {
  get("rapidpro_key", envir = pkg_env)
}
