#' Get archived (flow/run) data
#' @description Download the archived run data from RapidPro.
#'
#' @param rapidpro_site A string containing the rapidpro website to call the data from. See `set_rapidpro_site()` to amend the website.
#' @param token A string containing the token to call the data. See `set_rapidpro_key()` to amend the token.
#' @param period Default `"monthly"`. A character string giving the period of time. One of `"monthly"`, `"daily"`, or `"none"`.
#' @param flatten Default `FALSE`. A boolean denoting whether the data should be flattened into a two-dimensional tabular structure.
#' @param date_from character string giving the date to filter the data from.
#' @param date_to character string giving the date to filter the data to.
#' @param archive_type character string denoting whether to call `"runs"` or `"messages"` data.
#' @param format_date from `as.POSIX*` function: character string giving a date-time format as used by `strptime`.
#' @param tzone_date from `as.POSIX*` function: time zone specification to be used for the conversion, if one is required. System-specific (see time zones), but "" is the current time zone, and "GMT" is UTC (Universal Time, Coordinated). Invalid values are most commonly treated as UTC, on some platforms with a warning.
#'
#' @return Archived data
#' @export
get_archived_data <- function(rapidpro_site = get_rapidpro_site(), token = get_rapidpro_key(), period = "monthly", flatten = FALSE, date_from = NULL, date_to = NULL, archive_type = c("run", "messages"), format_date = "%Y-%m-%d", tzone_date = "UTC"){
  # removed call_type = "archives.json". If there are problems with this function, check this isn't it.
  call_type <- "archives.json"
  get_command <- paste(rapidpro_site, call_type, sep = "")
  result_flow <- httr_get_call(get_command = get_command, token = token) 
  archive_type <- match.arg(archive_type)
  
  if (!is.null(date_from)){
    if (format_date != "%Y-%m-%d"){
      date_from <- format(as.Date(date_from, format_date), '%Y-%m-%d')
    }
    result_flow <- result_flow %>% dplyr::filter(start_date >= date_from)
  }
  if (!is.null(date_to)){
    if (format_date != "%Y-%m-%d"){
      date_to <- format(as.Date(date_to, format_date), '%Y-%m-%d')
    }
    result_flow <- result_flow %>% dplyr::filter(start_date <= date_to)
  }
  
  if (period == "daily"){
    result_flow <- result_flow %>% dplyr::filter(period == "daily")
  } else if (period == "monthly"){
    result_flow <- result_flow %>% dplyr::filter(period == "monthly")
  } else {
    result_flow <- result_flow
  }
  result_flow <- result_flow %>% dplyr::filter(archive_type == archive_type)
  archived_data_bank <- NULL
  if (nrow(result_flow) == 0){
    return(archived_data_bank)
  } else {
    for (i in 1:nrow(result_flow)){
      if (result_flow$download_url[i] == ""){
        archived_data_bank[[i]] <- ""
      } else {
        archived_data_bank[[i]] <- jsonlite::stream_in(
          gzcon(url(result_flow$download_url[i])), flatten = FALSE
        )
      }
    }
    names(archived_data_bank) <- (result_flow$start_date)
    return(archived_data_bank)
  }
}