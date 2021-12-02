#' Reset the key value in the environment
#'
#' @param key A string denoting the API Token associated with the website given in set_rapidpro_site()
#'
#' @return
#' @export
set_rapidpro_key = function(key) {
  pkg_env$rapidpro_key <- key 
}