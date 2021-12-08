#' Reset the key value in the environment
#' @description Set a key (token) value to access the given RapidPro website.
#'
#' @param key A string denoting the API Token associated with the website given in `set_rapidpro_site`.
#'
#' @return A string containing the key (token) required to access the given RapidPro website.
#' @export
set_rapidpro_key = function(key) {
  if (!is.character(key)){
    stop("`key` provided should be a character variable")
  }
  pkg_env$rapidpro_key <- key 
}