#' Get data detailing the user group information.
#' Is this function needed? We do not use it anymore.
#' 
#' @param user_data 
#' @param name 
#' @param uuid 
#'
#' @return
#' @export
#'
#' @examples
get_user_group_data <- function(user_data = get_user_data(), name = NULL, uuid = NULL){
  
  # check name/uuid for typo
  if (length(which(get_user_data()$name == name)) == 0){
    if (length(which(get_user_data()$uuid == uuid)) == 0){
      stop("Neither name nor uuid supplied recognised")
    } else{
      message("name supplied is not recognised. Using the uuid instead.")
    }
  } else {
    if (length(which(get_user_data()$uuid == uuid)) == 0){
      message("uuid supplied is not recognised. Using the name instead.")
    } else{
      if(which(get_user_data()$name == name) != which(get_user_data()$uuid == uuid)){
        warning("name and uuid supplied do not match. Using the name supplied.")
      }
    }
  }
  
  if (is.null(name)){
    if (is.null(uuid)){
      stop("Either `name` or `uuid` must be supplied.")
    } else {
      get_user_data()$groups[[which(uuid == uuid)]]
    }
  } else {
    get_user_data()$groups[[which(name == name)]]
  }
}