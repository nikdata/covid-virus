#' Retrieve Corona Virust Cases
#'
#' This function returns a dataframe of corona virus cases. It has an optional input of <wide>.
#'
#' The wide option enables the confirmed, deaths, and recovered cases to appear in columns instead of in just one column.
#'
#' @param wide A boolean expression to indicate if a wide dataframe is preferred. Default is FALSE.
#'
#' @return a tidy dataframe of corona virus cases (infected, dead, cured)
#' @export
#'
#' @import dplyr
#' @import tidyr
#'
#' @examples
#' \dontrun{
#' cases <- get_cases() # standard
#' }
#' \dontrun{
#' cases <- get_cases(wide = TRUE) # wide dataframe
#' }
#'
get_cases <- function(wide=FALSE) {

  # check to make sure the parameter value is Boolean
  if (is.logical(wide) == FALSE) {
    stop("the 'wide' argument must be a Boolean value (e.g., TRUE or FALSE)")
  }

  # get the datasets
  cases <- get_datasets()

  for (i in 1:length(cases)) {
    cases[[i]] <- fix_dfnames(cases[[i]])
  }

  case_names <- c('confirmed','death','recovered')
  for(i in 1:length(cases)) {
    cases[[i]] <- process_dataset(cases[[i]], typeval = case_names[i])
  }

  output <- dplyr::bind_rows(cases[[1]], cases[[2]], cases[[3]])

  # if user wants a wide dataframe, then this will create it
  if (wide == TRUE) {
    output <- output %>%
      tidyr::pivot_wider(
        names_from = type,
        values_from = cases,
        values_fill = list(cases = 0)
      )
  }

  return(output)
}
