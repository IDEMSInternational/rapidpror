#' Unlist variables in a variable
#' @description After importing data from RapidPro, unlist the variables that are stored in a list
#'
#' @param data The data frame containing the data
#' @param variable The variable that contains the groups
#'
#' @return returns a data frame containing the unlisted data.
#' @export
# just consent for now
unlist_rapidpro_variable <- function(data, variable = "groups"){
  if (variable %in% names(data) && class(data[[variable]]) == "list"){
    consent <- NULL
    program <- NULL
    enrolled <- NULL
    if (length(data[[variable]]) > 0){
      for (i in 1:length(data[[variable]])){
        contact_name <- data[[variable]][[i]]
        if (length(contact_name)==0) {
          consent[i] <- NA
          program[i] <- NA
          enrolled[i] <- NA
        } else {
          consent[i] <- ifelse(any(contact_name$name %in% "consent"), "Yes", "No")
          program[i] <- ifelse(any(contact_name$name %in% "in program"), "Yes", "No")
          enrolled[i] <- ifelse(any(contact_name$name %in% "joined"), "Yes", "No")
        }
      }
    }
  }
  data$consent <- consent
  data$program <- program
  data$enrolled <- enrolled
  return(data)
}