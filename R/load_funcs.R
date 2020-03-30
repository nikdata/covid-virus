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
  raw_confirmed <- readr::read_csv(file = "https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv", col_types = readr::cols(.default=readr::col_double(), `Province/State` = readr::col_character(), `Country/Region` = readr::col_character()))

  raw_death <- readr::read_csv("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv", col_types = readr::cols(.default=readr::col_double(), `Province/State` = readr::col_character(), `Country/Region` = readr::col_character()))

  raw_cured <- readr::read_csv("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv", col_types = readr::cols(.default=readr::col_double(), `Province/State` = readr::col_character(), `Country/Region` = readr::col_character()))

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

fix_values <- function(df) {
  # fix some country names
  ans <- df %>%
    dplyr::mutate(
      country_region = dplyr::case_when(
        country_region == 'Mainland China' ~ 'China',
        country_region == 'US' ~ 'United States',
        country_region == "Cote d'Ivoire" ~ 'Ivory Coast',
        country_region == 'Czechia' ~ 'Czech Republic',
        country_region == 'Holy See' ~ 'Vatican City',
        country_region == 'Taiwan*' ~ 'Taiwan',
        TRUE ~ country_region
      )
    )
  return(ans)
}

add_continents <- function(df) {

  ans <- df %>%
    dplyr::mutate(
      continent = dplyr::case_when(
        country_region == 'Algeria' ~ 'Africa',
        country_region == 'Angola' ~ 'Africa',
        country_region == 'Benin' ~ 'Africa',
        country_region == 'Botswana' ~ 'Africa',
        country_region == 'Burkina Faso' ~ 'Africa',
        country_region == 'Burundi' ~ 'Africa',
        country_region == 'Cameroon' ~ 'Africa',
        country_region == 'Cape Verde' ~ 'Africa',
        country_region == 'Central African Republic' ~ 'Africa',
        country_region == 'Chad' ~ 'Africa',
        country_region == 'Comoros' ~ 'Africa',
        country_region == 'Congo (Kinshasa)' ~ 'Africa',
        country_region == 'Congo, Democratic Republic of' ~ 'Africa',
        country_region == 'Djibouti' ~ 'Africa',
        country_region == 'Egypt' ~ 'Africa',
        country_region == 'Equatorial Guinea' ~ 'Africa',
        country_region == 'Eritrea' ~ 'Africa',
        country_region == 'Ethiopia' ~ 'Africa',
        country_region == 'Gabon' ~ 'Africa',
        country_region == 'Gambia' ~ 'Africa',
        country_region == 'Ghana' ~ 'Africa',
        country_region == 'Guinea' ~ 'Africa',
        country_region == 'Guinea-Bissau' ~ 'Africa',
        country_region == 'Ivory Coast' ~ 'Africa',
        country_region == 'Kenya' ~ 'Africa',
        country_region == 'Lesotho' ~ 'Africa',
        country_region == 'Liberia' ~ 'Africa',
        country_region == 'Libya' ~ 'Africa',
        country_region == 'Madagascar' ~ 'Africa',
        country_region == 'Malawi' ~ 'Africa',
        country_region == 'Mali' ~ 'Africa',
        country_region == 'Mauritania' ~ 'Africa',
        country_region == 'Mauritius' ~ 'Africa',
        country_region == 'Morocco' ~ 'Africa',
        country_region == 'Mozambique' ~ 'Africa',
        country_region == 'Namibia' ~ 'Africa',
        country_region == 'Niger' ~ 'Africa',
        country_region == 'Nigeria' ~ 'Africa',
        country_region == 'Rwanda' ~ 'Africa',
        country_region == 'Sao Tome and Principe' ~ 'Africa',
        country_region == 'Senegal' ~ 'Africa',
        country_region == 'Seychelles' ~ 'Africa',
        country_region == 'Sierra Leone' ~ 'Africa',
        country_region == 'Somalia' ~ 'Africa',
        country_region == 'South Africa' ~ 'Africa',
        country_region == 'South Sudan' ~ 'Africa',
        country_region == 'Sudan' ~ 'Africa',
        country_region == 'Swaziland' ~ 'Africa',
        country_region == 'Tanzania' ~ 'Africa',
        country_region == 'Togo' ~ 'Africa',
        country_region == 'Tunisia' ~ 'Africa',
        country_region == 'Uganda' ~ 'Africa',
        country_region == 'Zambia' ~ 'Africa',
        country_region == 'Zimbabwe' ~ 'Africa',
        country_region == 'Afghanistan' ~ 'Asia',
        country_region == 'Bahrain' ~ 'Asia',
        country_region == 'Bangladesh' ~ 'Asia',
        country_region == 'Bhutan' ~ 'Asia',
        country_region == 'Brunei' ~ 'Asia',
        country_region == 'Burma (Myanmar)' ~ 'Asia',
        country_region == 'Cambodia' ~ 'Asia',
        country_region == 'China' ~ 'Asia',
        country_region == 'East Timor' ~ 'Asia',
        country_region == 'India' ~ 'Asia',
        country_region == 'Indonesia' ~ 'Asia',
        country_region == 'Iran' ~ 'Asia',
        country_region == 'Iraq' ~ 'Asia',
        country_region == 'Israel' ~ 'Asia',
        country_region == 'Japan' ~ 'Asia',
        country_region == 'Jordan' ~ 'Asia',
        country_region == 'Kazakhstan' ~ 'Asia',
        country_region == 'Korea, North' ~ 'Asia',
        country_region == 'Korea, South' ~ 'Asia',
        country_region == 'Kuwait' ~ 'Asia',
        country_region == 'Kyrgyzstan' ~ 'Asia',
        country_region == 'Laos' ~ 'Asia',
        country_region == 'Lebanon' ~ 'Asia',
        country_region == 'Malaysia' ~ 'Asia',
        country_region == 'Maldives' ~ 'Asia',
        country_region == 'Mongolia' ~ 'Asia',
        country_region == 'Nepal' ~ 'Asia',
        country_region == 'Oman' ~ 'Asia',
        country_region == 'Pakistan' ~ 'Asia',
        country_region == 'Philippines' ~ 'Asia',
        country_region == 'Qatar' ~ 'Asia',
        country_region == 'Russia' ~ 'Asia',
        country_region == 'Saudi Arabia' ~ 'Asia',
        country_region == 'Singapore' ~ 'Asia',
        country_region == 'Sri Lanka' ~ 'Asia',
        country_region == 'Syria' ~ 'Asia',
        country_region == 'Tajikistan' ~ 'Asia',
        country_region == 'Thailand' ~ 'Asia',
        country_region == 'Turkey' ~ 'Asia',
        country_region == 'Turkmenistan' ~ 'Asia',
        country_region == 'United Arab Emirates' ~ 'Asia',
        country_region == 'Uzbekistan' ~ 'Asia',
        country_region == 'Vietnam' ~ 'Asia',
        country_region == 'Yemen' ~ 'Asia',
        country_region == 'Albania' ~ 'Europe',
        country_region == 'Andorra' ~ 'Europe',
        country_region == 'Armenia' ~ 'Europe',
        country_region == 'Austria' ~ 'Europe',
        country_region == 'Azerbaijan' ~ 'Europe',
        country_region == 'Belarus' ~ 'Europe',
        country_region == 'Belgium' ~ 'Europe',
        country_region == 'Bosnia and Herzegovina' ~ 'Europe',
        country_region == 'Bulgaria' ~ 'Europe',
        country_region == 'Croatia' ~ 'Europe',
        country_region == 'Cyprus' ~ 'Europe',
        country_region == 'Czech Republic' ~ 'Europe',
        country_region == 'Denmark' ~ 'Europe',
        country_region == 'Estonia' ~ 'Europe',
        country_region == 'Finland' ~ 'Europe',
        country_region == 'France' ~ 'Europe',
        country_region == 'Georgia' ~ 'Europe',
        country_region == 'Germany' ~ 'Europe',
        country_region == 'Greece' ~ 'Europe',
        country_region == 'Hungary' ~ 'Europe',
        country_region == 'Iceland' ~ 'Europe',
        country_region == 'Ireland' ~ 'Europe',
        country_region == 'Italy' ~ 'Europe',
        country_region == 'Latvia' ~ 'Europe',
        country_region == 'Liechtenstein' ~ 'Europe',
        country_region == 'Lithuania' ~ 'Europe',
        country_region == 'Luxembourg' ~ 'Europe',
        country_region == 'North Macedonia' ~ 'Europe',
        country_region == 'Malta' ~ 'Europe',
        country_region == 'Moldova' ~ 'Europe',
        country_region == 'Monaco' ~ 'Europe',
        country_region == 'Montenegro' ~ 'Europe',
        country_region == 'Netherlands' ~ 'Europe',
        country_region == 'Norway' ~ 'Europe',
        country_region == 'Poland' ~ 'Europe',
        country_region == 'Portugal' ~ 'Europe',
        country_region == 'Romania' ~ 'Europe',
        country_region == 'San Marino' ~ 'Europe',
        country_region == 'Serbia' ~ 'Europe',
        country_region == 'Slovakia' ~ 'Europe',
        country_region == 'Slovenia' ~ 'Europe',
        country_region == 'Spain' ~ 'Europe',
        country_region == 'Sweden' ~ 'Europe',
        country_region == 'Switzerland' ~ 'Europe',
        country_region == 'Ukraine' ~ 'Europe',
        country_region == 'United Kingdom' ~ 'Europe',
        country_region == 'Vatican City' ~ 'Europe',
        country_region == 'Antigua and Barbuda' ~ 'North America',
        country_region == 'Bahamas' ~ 'North America',
        country_region == 'Barbados' ~ 'North America',
        country_region == 'Belize' ~ 'North America',
        country_region == 'Canada' ~ 'North America',
        country_region == 'Costa Rica' ~ 'North America',
        country_region == 'Cuba' ~ 'North America',
        country_region == 'Dominica' ~ 'North America',
        country_region == 'Dominican Republic' ~ 'North America',
        country_region == 'El Salvador' ~ 'North America',
        country_region == 'Grenada' ~ 'North America',
        country_region == 'Guatemala' ~ 'North America',
        country_region == 'Haiti' ~ 'North America',
        country_region == 'Honduras' ~ 'North America',
        country_region == 'Jamaica' ~ 'North America',
        country_region == 'Mexico' ~ 'North America',
        country_region == 'Nicaragua' ~ 'North America',
        country_region == 'Panama' ~ 'North America',
        country_region == 'Saint Kitts and Nevis' ~ 'North America',
        country_region == 'Saint Lucia' ~ 'North America',
        country_region == 'Saint Vincent and the Grenadines' ~ 'North America',
        country_region == 'Trinidad and Tobago' ~ 'North America',
        country_region == 'United States' ~ 'North America',
        country_region == 'Australia' ~ 'Oceania',
        country_region == 'Fiji' ~ 'Oceania',
        country_region == 'Kiribati' ~ 'Oceania',
        country_region == 'Marshall Islands' ~ 'Oceania',
        country_region == 'Micronesia' ~ 'Oceania',
        country_region == 'Nauru' ~ 'Oceania',
        country_region == 'New Zealand' ~ 'Oceania',
        country_region == 'Palau' ~ 'Oceania',
        country_region == 'Papua New Guinea' ~ 'Oceania',
        country_region == 'Samoa' ~ 'Oceania',
        country_region == 'Solomon Islands' ~ 'Oceania',
        country_region == 'Tonga' ~ 'Oceania',
        country_region == 'Tuvalu' ~ 'Oceania',
        country_region == 'Vanuatu' ~ 'Oceania',
        country_region == 'Argentina' ~ 'South America',
        country_region == 'Bolivia' ~ 'South America',
        country_region == 'Brazil' ~ 'South America',
        country_region == 'Chile' ~ 'South America',
        country_region == 'Colombia' ~ 'South America',
        country_region == 'Ecuador' ~ 'South America',
        country_region == 'Guyana' ~ 'South America',
        country_region == 'Paraguay' ~ 'South America',
        country_region == 'Peru' ~ 'South America',
        country_region == 'Suriname' ~ 'South America',
        country_region == 'Uruguay' ~ 'South America',
        country_region == 'Venezuela' ~ 'South America',
        country_region == 'Aruba' ~ 'South America',
        country_region == 'Cayman Islands' ~ 'North America',
        country_region == 'French Guiana' ~ 'South America',
        country_region == 'Guadeloupe' ~ 'North America',
        country_region == 'Taiwan' ~ 'Asia',
        country_region == 'Martinique' ~ 'North America',
        TRUE ~ 'Unknown'
      )
    )

  return(ans)

}

add_states <- function(df) {
  # add full state names - only for US

  ans <- df %>%
    tidyr::separate(col = province_state, into = c('city_county', 'state'), sep = ', ', fill = 'left', remove = F) %>%
    dplyr::mutate(
      state = trimws(state),
      state = ifelse(country_region!='United States', NA, state),
      state = ifelse(province_state %in% c('Virgin Islands, U.S.'), 'Virgin Islands', state),
      city_county = ifelse(province_state %in% c('Virgin Islands, U.S.'), NA, city_county),
      state = dplyr::case_when(
        state == 'Alabama' ~ 'AL',
        state == 'Alaska' ~ 'AK',
        state == 'Arizona' ~ 'AZ',
        state == 'Arkansas' ~ 'AR',
        state == 'California' ~ 'CA',
        state == 'Colorado' ~ 'CO',
        state == 'Connecticut' ~ 'CT',
        state == 'Delaware' ~ 'DE',
        state == 'Florida' ~ 'FL',
        state == 'Georgia' ~ 'GA',
        state == 'Hawaii' ~ 'HI',
        state == 'Idaho' ~ 'ID',
        state == 'Illinois' ~ 'IL',
        state == 'Indiana' ~ 'IN',
        state == 'Iowa' ~ 'IA',
        state == 'Kansas' ~ 'KS',
        state == 'Kentucky' ~ 'KY',
        state == 'Louisiana' ~ 'LA',
        state == 'Maine' ~ 'ME',
        state == 'Maryland' ~ 'MD',
        state == 'Massachusetts' ~ 'MA',
        state == 'Michigan' ~ 'MI',
        state == 'Minnesota' ~ 'MN',
        state == 'Mississippi' ~ 'MS',
        state == 'Missouri' ~ 'MO',
        state == 'Montana' ~ 'MT',
        state == 'Nebraska' ~ 'NE',
        state == 'Nevada' ~ 'NV',
        state == 'New Hampshire' ~ 'NH',
        state == 'New Jersey' ~ 'NJ',
        state == 'New Mexico' ~ 'NM',
        state == 'New York' ~ 'NY',
        state == 'North Carolina' ~ 'NC',
        state == 'North Dakota' ~ 'ND',
        state == 'Ohio' ~ 'OH',
        state == 'Oklahoma' ~ 'OK',
        state == 'Oregon' ~ 'OR',
        state == 'Pennsylvania' ~ 'PA',
        state == 'Rhode Island' ~ 'RI',
        state == 'South Carolina' ~ 'SC',
        state == 'South Dakota' ~ 'SD',
        state == 'Tennessee' ~ 'TN',
        state == 'Texas' ~ 'TX',
        state == 'Utah' ~ 'UT',
        state == 'Vermont' ~ 'VT',
        state == 'Virginia' ~ 'VA',
        state == 'Washington' ~ 'WA',
        state == 'West Virginia' ~ 'WV',
        state == 'Wisconsin' ~ 'WI',
        state == 'Wyoming' ~ 'WY',
        state == 'District of Columbia' ~ 'D.C.',
        state == 'Grand Princess' ~ NA_character_,
        state == 'Diamond Princess' ~ NA_character_,
        TRUE ~ state
      ),
      state_name = dplyr::case_when(
        state == 'AL' ~ 'Alabama',
        state == 'AK' ~ 'Alaska',
        state == 'AZ' ~ 'Arizona',
        state == 'AR' ~ 'Arkansas',
        state == 'CA' ~ 'California',
        state == 'CO' ~ 'Colorado',
        state == 'CT' ~ 'Connecticut',
        state == 'DE' ~ 'Delaware',
        state == 'FL' ~ 'Florida',
        state == 'GA' ~ 'Georgia',
        state == 'HI' ~ 'Hawaii',
        state == 'ID' ~ 'Idaho',
        state == 'IL' ~ 'Illinois',
        state == 'IN' ~ 'Indiana',
        state == 'IA' ~ 'Iowa',
        state == 'KS' ~ 'Kansas',
        state == 'KY' ~ 'Kentucky',
        state == 'LA' ~ 'Louisiana',
        state == 'ME' ~ 'Maine',
        state == 'MD' ~ 'Maryland',
        state == 'MA' ~ 'Massachusetts',
        state == 'MI' ~ 'Michigan',
        state == 'MN' ~ 'Minnesota',
        state == 'MS' ~ 'Mississippi',
        state == 'MO' ~ 'Missouri',
        state == 'MT' ~ 'Montana',
        state == 'NE' ~ 'Nebraska',
        state == 'NV' ~ 'Nevada',
        state == 'NH' ~ 'New Hampshire',
        state == 'NJ' ~ 'New Jersey',
        state == 'NM' ~ 'New Mexico',
        state == 'NY' ~ 'New York',
        state == 'NC' ~ 'North Carolina',
        state == 'ND' ~ 'North Dakota',
        state == 'OH' ~ 'Ohio',
        state == 'OK' ~ 'Oklahoma',
        state == 'OR' ~ 'Oregon',
        state == 'PA' ~ 'Pennsylvania',
        state == 'RI' ~ 'Rhode Island',
        state == 'SC' ~ 'South Carolina',
        state == 'SD' ~ 'South Dakota',
        state == 'TN' ~ 'Tennessee',
        state == 'TX' ~ 'Texas',
        state == 'UT' ~ 'Utah',
        state == 'VT' ~ 'Vermont',
        state == 'VA' ~ 'Virginia',
        state == 'WA' ~ 'Washington',
        state == 'WV' ~ 'West Virginia',
        state == 'WI' ~ 'Wisconsin',
        state == 'WY' ~ 'Wyoming',
        state == 'D.C.' ~ 'District of Columbia',
        TRUE ~ state
      )
    )

  return(ans)

}
