#' Retrieve Corona Virust Cases
#'
#' This function returns a dataframe of corona virus cases. It takes no input.
#'
#'
#' @return a tidy dataframe of corona virus cases (infected, dead, cured)
#' @export
#'
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' cases <- refresh_cases()
#' }
#'
get_cases <- function() {

  #source('R/load_funcs.R')
  #devtools::load_all()

  cases <- get_datasets()

  for (i in 1:length(cases)) {
    cases[[i]] <- fix_dfnames(cases[[i]])
  }

  case_names <- c('confirmed','death','recovered')
  for(i in 1:length(cases)) {
    cases[[i]] <- process_dataset(cases[[i]], typeval = case_names[i])
  }

  output <- dplyr::bind_rows(cases[[1]], cases[[2]], cases[[3]])

  return(output)
}
