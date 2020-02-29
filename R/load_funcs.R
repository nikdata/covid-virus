#' Base Functions for package {covidvirus}
#'
#' @return nothing
#'
#'
#' @importFrom magrittr `%>%`
#' @import dplyr
#' @importFrom readr read_csv cols col_double col_character
#' @importFrom janitor make_clean_names
#' @importFrom tidyr pivot_longer
#' @importFrom purrr map_df
#' @import stringr
#' @importFrom lubridate ymd mdy
#'
#'

get_datasets <- function() {
  raw_confirmed <- readr::read_csv(file = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv", col_types = readr::cols(.default=readr::col_double(), `Province/State` = readr::col_character(), `Country/Region` = readr::col_character()))

  raw_death <- readr::read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv", col_types = readr::cols(.default=readr::col_double(), `Province/State` = readr::col_character(), `Country/Region` = readr::col_character()))

  raw_cured <- readr::read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv", col_types = readr::cols(.default=readr::col_double(), `Province/State` = readr::col_character(), `Country/Region` = readr::col_character()))

  df_list <- list(infected = raw_confirmed, dead = raw_death, cured = raw_cured)

  return(df_list)

}

fix_dfnames <- function(df) {
  names(df) <- janitor::make_clean_names(colnames(df), case = 'snake')

  return(df)
}

process_dataset <- function(df, typeval) {

  basedf <- df %>% dplyr::select(province_state, country_region, lat, long)

  for (i in 5:ncol(df)) {

    tmp <- df
    tmp[,i] <- tmp %>% dplyr::select(c(i)) %>% purrr::map_df(function(x) as.integer(x))

    # each date column shows cumulative sum so we need to subtract the column from previous to get daily totals
    if (i == 5) {
      basedf <- dplyr::bind_cols(basedf, tmp[,i])
    } else {
      basedf <- dplyr::bind_cols(basedf, tmp[,i] - tmp[,i-1])
    }

  }

  finaldf <- basedf %>%
    tidyr::pivot_longer(
      cols = dplyr::starts_with('x'),
      names_to = 'date',
      values_to = 'cases'
    ) %>%
    dplyr::mutate(
      date = stringr::str_remove(date, pattern='x'),
      date = lubridate::ymd(lubridate::mdy(date)),
      type = typeval
    ) %>%
    dplyr::group_by(province_state, country_region, lat, long, date, type) %>%
    dplyr::summarize(
      cases = sum(cases)
    ) %>%
    dplyr::ungroup()

  return(finaldf)
}
