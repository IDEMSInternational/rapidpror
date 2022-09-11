#' Unlist variables in a variable
#' @description After importing data from RapidPro, unlist the variables that are stored in a list
#'
#' @param data The data frame containing the data
#' @param variable The variable that contains the unlisted variable
#'
#' @return returns a data frame containing the unlisted data.
#' @export
# just consent for now
unlist_rapidpro_variable <- function(data, variable = "groups"){
  if (variable %in% names(data) && class(data[[variable]]) == "list"){
    consent <- NULL
    if (length(data[[variable]]) > 0){
      for (i in 1:length(data[[variable]])){
        contact_name <- data[[variable]][[i]]
        if (length(contact_name)==0) {
          consent[i] <- NA
        } else {
          consent[i] <- ifelse(any(contact_name$name %in% "consent"), "Yes", "No")
        }
      }
    }
  }
  data$consent <- consent
  return(data)
}