#' Reset the key value in the environment
#' @description Set a key (token) value to access the given RapidPro website.
#'
#' @param key A string denoting the API Token associated with the website given in `set_rapidpro_site`.
#' If `file = FALSE`, the string is the key value itself.
#' If `file = TRUE`, the string is a text file containing the key. Only the first line will be taken in the text file.
#' @param file A boolean denoting whether the key given is a file path or a string.
#'
#' @return A string containing the key (token) required to access the given RapidPro website.
#' @export
set_rapidpro_key = function(key, file = FALSE) {
  if (file){
    file_value <- utils::read.table(key, quote="\"", comment.char="")
    key <- file_value[[1]]
  }
  if (!is.character(key)){
    stop("`key` provided should be a character variable")
  }
  pkg_env$rapidpro_key <- key 
}