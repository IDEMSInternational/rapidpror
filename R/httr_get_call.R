# Calling data - this function is called in other functions
httr_get_call <- function(get_command, token = get_rapidpro_key()){
  response <- httr::GET(get_command, config = httr::add_headers(Authorization = paste("Token", token)))
  raw <- httr::content(response, as = "text")
  results <- jsonlite::fromJSON(raw)
  if(!is.null(results$'next')){
    bind_rows(results$results, httr_get_call(results$'next',token))
  } else {
    return(results$results)
  }
}