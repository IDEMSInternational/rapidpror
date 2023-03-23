#' Get the UUID names from the environment
#' @description Call the UUID names from the environment. This set in the function `set_rapidpro_uuid_names`. 
#' @return returns the UUID names set in the environment for the RapidPro data.
#' @export
get_rapidpro_uuid_names <- function(){
  get("rapidpro_uuid_names", envir = pkg_env)
}