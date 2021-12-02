#' Set the UUID names in the environment for the flow data
#'
#' @param uuid_names Default get_flow_names() (recommended). Data frame containing the flow names and UUIDs.
#'
#' @return
#' @export
set_rapidpro_uuid_names = function(uuid_names = get_flow_names()){
  pkg_env$rapidpro_uuid_names <- uuid_names 
}