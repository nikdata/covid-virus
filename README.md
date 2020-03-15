
<!-- README.md is generated from README.Rmd. Please edit that file -->

# covidvirus

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![License:
MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

The {covidvirus} package provides a tidy format dataset of the 2019
Novel Coronavirus COVID-19 (2019-nCoV) epidemic. The raw data pulled
from the Johns Hopkins University Center for Systems Science and
Engineering (JHU CCSE) Coronavirus
[repository](https://github.com/CSSEGISandData/COVID-19).

This package was inspired by [Rami Krispin’s {coronavirus}
package](https://github.com/RamiKrispin/coronavirus). The key difference
is that Rami’s package provides a dataset which must be manually updated
from the package author’s perspective. In this package, I’ve used (i.e,
respectfully copied) his data retrieval code and modified it to use
substantially more “tidyverse” packages such as {janitor}, {lubridate},
etc. Another key difference is the name of columns. Since I’ve used the
package {janitor}, the column names use a ‘snake’ style and do not have
dots ‘.’ (opting for the underscore ’\_’).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("nikdata/covidvirus")
```

## Usage

This is a basic example which shows you how to solve a common problem:

``` r
library(covidvirus)

corona_virus <- get_cases(wide=FALSE)
```

Similar to Rami’s package, the output is as follows:

``` r
head(corona_virus)
#> # A tibble: 6 x 11
#>   province_state city_county state state_name country_region continent   lat
#>   <chr>          <chr>       <chr> <chr>      <chr>          <chr>     <dbl>
#> 1 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
#> 2 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
#> 3 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
#> 4 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
#> 5 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
#> 6 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
#> # … with 4 more variables: long <dbl>, date <date>, type <chr>, cases <dbl>
```

``` r
tail(corona_virus) 
#> # A tibble: 6 x 11
#>   province_state city_county state state_name country_region continent   lat
#>   <chr>          <chr>       <chr> <chr>      <chr>          <chr>     <dbl>
#> 1 <NA>           <NA>        <NA>  <NA>       Vietnam        Asia         16
#> 2 <NA>           <NA>        <NA>  <NA>       Vietnam        Asia         16
#> 3 <NA>           <NA>        <NA>  <NA>       Vietnam        Asia         16
#> 4 <NA>           <NA>        <NA>  <NA>       Vietnam        Asia         16
#> 5 <NA>           <NA>        <NA>  <NA>       Vietnam        Asia         16
#> 6 <NA>           <NA>        <NA>  <NA>       Vietnam        Asia         16
#> # … with 4 more variables: long <dbl>, date <date>, type <chr>, cases <dbl>
```

Here’s an example of total cases by region and type (top 10):

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

corona_virus %>%
  group_by(country_region, type) %>%
  summarize(total_cases = sum(cases)) %>%
  arrange(desc(total_cases)) %>%
  head(20)
#> # A tibble: 20 x 3
#> # Groups:   country_region [15]
#>    country_region type      total_cases
#>    <chr>          <chr>           <dbl>
#>  1 China          confirmed       80977
#>  2 China          recovered       65660
#>  3 Italy          confirmed       21157
#>  4 Iran           confirmed       12729
#>  5 Korea, South   confirmed        8086
#>  6 Spain          confirmed        6391
#>  7 Germany        confirmed        4585
#>  8 France         confirmed        4480
#>  9 China          death            3193
#> 10 Iran           recovered        2959
#> 11 United States  confirmed        2727
#> 12 Italy          recovered        1966
#> 13 Italy          death            1441
#> 14 Switzerland    confirmed        1359
#> 15 United Kingdom confirmed        1143
#> 16 Norway         confirmed        1090
#> 17 Sweden         confirmed         961
#> 18 Netherlands    confirmed         959
#> 19 Denmark        confirmed         836
#> 20 Japan          confirmed         773
```

To manually create a wide dataframe, you can do the following (it is
recommended to use the wide=TRUE argument):

    #> # A tibble: 10 x 4
    #>    country        confirmed death recovered
    #>    <chr>              <dbl> <dbl>     <dbl>
    #>  1 Italy               3497   175       527
    #>  2 Iran                1365    97         0
    #>  3 Spain               1159    62       324
    #>  4 Germany              910     2         0
    #>  5 France               813    12         0
    #>  6 United States        548     7         0
    #>  7 United Kingdom       342    13         0
    #>  8 Switzerland          220     2         0
    #>  9 Netherlands          155     2         2
    #> 10 Austria              151     0         0

### Wide Dataframe

Sometimes it may be easier to have a “wide” dataframe that enables you
to see the number of cases for each type in their own respective
columns.

    #> # A tibble: 10 x 12
    #>    province_state city_county state state_name country_region continent   lat
    #>    <chr>          <chr>       <chr> <chr>      <chr>          <chr>     <dbl>
    #>  1 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
    #>  2 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
    #>  3 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
    #>  4 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
    #>  5 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
    #>  6 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
    #>  7 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
    #>  8 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
    #>  9 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
    #> 10 Adams, IN      Adams       IN    Indiana    United States  North Am…  39.9
    #> # … with 5 more variables: long <dbl>, date <date>, confirmed <dbl>,
    #> #   death <dbl>, recovered <dbl>

``` r
dplyr::glimpse(covidvirus::get_cases(wide = TRUE))
#> Observations: 23,426
#> Variables: 12
#> $ province_state <chr> "Adams, IN", "Adams, IN", "Adams, IN", "Adams, IN", "A…
#> $ city_county    <chr> "Adams", "Adams", "Adams", "Adams", "Adams", "Adams", …
#> $ state          <chr> "IN", "IN", "IN", "IN", "IN", "IN", "IN", "IN", "IN", …
#> $ state_name     <chr> "Indiana", "Indiana", "Indiana", "Indiana", "Indiana",…
#> $ country_region <chr> "United States", "United States", "United States", "Un…
#> $ continent      <chr> "North America", "North America", "North America", "No…
#> $ lat            <dbl> 39.8522, 39.8522, 39.8522, 39.8522, 39.8522, 39.8522, …
#> $ long           <dbl> -77.2865, -77.2865, -77.2865, -77.2865, -77.2865, -77.…
#> $ date           <date> 2020-01-22, 2020-01-23, 2020-01-24, 2020-01-25, 2020-…
#> $ confirmed      <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ death          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ recovered      <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
```

## Comments

I would greatly appreciate any feedback you may have. If you find a bug,
please file an issue.

Finally, a **HUGE** thanks to Rami Krispin for creating the
{coronavirus} package\!
