#' Set the UUID names in the environment for the flow data
#' @description Set the UUID names to access data in RapidPro.
#' @param uuid_names Default `get_flow_names()` (recommended). Data frame containing the flow names and UUIDs.
#'
#' @return Setting a data frame containing RapidPro flow data to the environment.
#' @export
set_rapidpro_uuid_names <- function(uuid_names = get_flow_names()){
  pkg_env$rapidpro_uuid_names <- uuid_names 
}