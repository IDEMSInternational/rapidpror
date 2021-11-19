#' Get the UUID names from the environment
#'
#' @return returns the UUID names set in the environment for the rapidPro data
#' @export
#'
#' @examples
get_rapidpro_uuid_names = function(){
  get("rapidpro_uuid_names", envir = pkg.env)
}