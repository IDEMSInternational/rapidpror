# known elsewhere as: "survey_datetime_split_multiple"
# TODO: not sure if this would work as a general package function, or if we should have it in our separate ParentText work.
#' Get the survey data
#'
#' @param parenting_variable A character vector containing ...
#' @param survey_max A numerical value denoting ...
#'
#' @return A list of survey data
#' @export
#'
#' @examples
#'
get_survey_data <- function(parenting_variable, survey_max = 9){
  survey_entry <- NULL
  for (i in 1:survey_max){
    # split the string by different surveys taken
    split_parenting <- str_split(parenting_variable, pattern = fixed("|"))
    
    # for each individual, get each survey value (split by ,)
    parenting_response <- NULL
    for (j in 1:length(split_parenting)){
      split_parenting_2 <- str_split(split_parenting[[j]], ",") 
      
      # if it is NA, keep as NA
      if (is.na(split_parenting_2[[1]][3])){
        parenting_response[j] <- NA
      } else{
        # which survey to consider? Baseline = 1, week1 = 2, etc.
        # so get that correct week lot of surveys
        for (k in 2:length(split_parenting_2) - 1){
          if (as.numeric(as.character(split_parenting_2[[k]][2])) != i) {
            split_parenting_2[[k]][3] ="1970-01-01T00:00:00.873007+08:00"
          }
        }
        
        # take the response value corresponding to the most recent date
        response <- NA
        date <- as.POSIXct("1970-01-01T00:00:00.873007+08:00", format="%Y-%m-%dT%H:%M:%OS", tz = "UTC")
        
        for (k in 2:length(split_parenting_2) - 1){
          if (date < as.POSIXct(split_parenting_2[[k]][3], format="%Y-%m-%dT%H:%M:%OS", tz = "UTC")) {
            response <- split_parenting_2[[k]][1]
          }
        }
        parenting_response[j] <- as.numeric(as.character(response))
      }
    }
    survey_entry[[i]] <- parenting_response
  }
  return(survey_entry)
}