#' Link Data Frames within R-Instat
#'
#' This function links two data frames within the R-Instat environment using specified linking pairs. 
#' It is specifically designed for use within R-Instat and will stop with an error message if the data book object is not found, 
#' indicating that the data frames are not being managed through R-Instat.
#'
#' @param from_data_frame The name of the source data frame to link from, defaults to "flow_data".
#' @param to_data_frame The name of the target data frame to link to, defaults to "user_data".
#' @param link_pairs A named vector that specifies the column names used to establish the link, 
#'   with the name being the column in the `from_data_frame` and the value being the corresponding column in the `to_data_frame`.
#'   Defaults to linking "uuid" in both data frames.
#'
#' @return None; the function modifies the `data_book` environment by adding a new link.
#' @examples
#' # Assuming 'data_book' and required data frames are already loaded in R-Instat:
#' # link_data_frames("survey_data", "participant_data", c(participant_id="id"))
#'
#' @export
link_data_frames <- function(from_data_frame="flow_data", to_data_frame="user_data", link_pairs=c(uuid="uuid")){
  if (!exists("data_book")){
    stop("No data book found. Likely issue: Are you importing data through R-Instat? This function is for use in R-Instat.")
  }
  data_book$add_link(from_data_frame = from_data_frame,
                     to_data_frame = to_data_frame,
                     link_pairs = link_pairs,
                     type = "keyed_link",
                     link_name = "link")
}
