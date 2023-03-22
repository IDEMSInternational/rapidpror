#' Reset the website in the environment
#'
#' @param site A string denoting the website associated with the token given in `set_rapidpro_key`.
#'
#' @return A string containing the website required to access RapidPro.
#' @export
#'
#' @examples #
set_rapidpro_site <- function(site) {
  if (!is.character(site)){
    stop("`site` provided should be a character variable")
  }
  pkg_env$rapidpro_site <- site 
}