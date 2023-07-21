#' Calling data from RapidPro
#' @description Call data from RapidPro into R. The main purpose of this function is to be called within other functions.
#'
#' @param get_command A string containing the website to call the data from. Usually called within a function.
#' @param token A string containing the token to call the data. See `set_rapidpro_key()` to amend the token.
#'
#' @return A data frame containing RapidPro data.
httr_get_call <- function(get_command, token = get_rapidpro_key()){
  if (is.null(token)){
    stop("token is NULL. Set token with `set_rapidpro_key`.")
  }
  if (is.null(get_command)){
    stop("get_command is NULL. Expecting a website.")
  }
  response <- httr::GET(get_command, config = httr::add_headers(Authorization = paste("Token", token)))
  raw <- httr::content(response, as = "text")
  results <- jsonlite::fromJSON(raw)
  if(!is.null(results$'next')){
    dplyr::bind_rows(results$results, httr_get_call(results$'next', token))
  } else {
    return(results$results)
  }
}