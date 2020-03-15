
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
#> # A tibble: 6 x 10
#>   province_state city_county state country_region continent   lat  long
#>   <chr>          <chr>       <chr> <chr>          <chr>     <dbl> <dbl>
#> 1 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
#> 2 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
#> 3 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
#> 4 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
#> 5 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
#> 6 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
#> # … with 3 more variables: date <date>, type <chr>, cases <dbl>
```

``` r
tail(corona_virus)
#> # A tibble: 6 x 10
#>   province_state city_county state country_region continent   lat  long
#>   <chr>          <chr>       <chr> <chr>          <chr>     <dbl> <dbl>
#> 1 <NA>           <NA>        <NA>  Vietnam        Asia         16   108
#> 2 <NA>           <NA>        <NA>  Vietnam        Asia         16   108
#> 3 <NA>           <NA>        <NA>  Vietnam        Asia         16   108
#> 4 <NA>           <NA>        <NA>  Vietnam        Asia         16   108
#> 5 <NA>           <NA>        <NA>  Vietnam        Asia         16   108
#> 6 <NA>           <NA>        <NA>  Vietnam        Asia         16   108
#> # … with 3 more variables: date <date>, type <chr>, cases <dbl>
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
#> # Groups:   country_region [7]
#>    country_region      type      total_cases
#>    <chr>               <chr>           <dbl>
#>  1 Afghanistan         confirmed          NA
#>  2 Afghanistan         death              NA
#>  3 Afghanistan         recovered          NA
#>  4 Albania             confirmed          NA
#>  5 Albania             death              NA
#>  6 Albania             recovered          NA
#>  7 Algeria             confirmed          NA
#>  8 Algeria             death              NA
#>  9 Algeria             recovered          NA
#> 10 Andorra             confirmed          NA
#> 11 Andorra             death              NA
#> 12 Andorra             recovered          NA
#> 13 Antigua and Barbuda confirmed          NA
#> 14 Antigua and Barbuda death              NA
#> 15 Antigua and Barbuda recovered          NA
#> 16 Argentina           confirmed          NA
#> 17 Argentina           death              NA
#> 18 Argentina           recovered          NA
#> 19 Armenia             confirmed          NA
#> 20 Armenia             death              NA
```

To manually create a wide dataframe, you can do the following (it is
recommended to use the wide=TRUE argument):

    #> # A tibble: 10 x 4
    #>    country             confirmed death recovered
    #>    <chr>                   <dbl> <dbl>     <dbl>
    #>  1 Afghanistan                 0     0         0
    #>  2 Albania                     0     0         0
    #>  3 Algeria                     0     0         0
    #>  4 Andorra                     0     0         0
    #>  5 Antigua and Barbuda         0     0         0
    #>  6 Argentina                   0     0         0
    #>  7 Armenia                     0     0         0
    #>  8 Aruba                       0     0         0
    #>  9 Australia                   0     0         0
    #> 10 Austria                     0     0         0

### Wide Dataframe

Sometimes it may be easier to have a “wide” dataframe that enables you
to see the number of cases for each type in their own respective
columns.

    #> # A tibble: 10 x 11
    #>    province_state city_county state country_region continent   lat  long
    #>    <chr>          <chr>       <chr> <chr>          <chr>     <dbl> <dbl>
    #>  1 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
    #>  2 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
    #>  3 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
    #>  4 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
    #>  5 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
    #>  6 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
    #>  7 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
    #>  8 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
    #>  9 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
    #> 10 Adams, IN      Adams       Indi… United States  North Am…  39.9 -77.3
    #> # … with 4 more variables: date <date>, confirmed <dbl>, death <dbl>,
    #> #   recovered <dbl>

``` r
dplyr::glimpse(covidvirus::get_cases(wide = TRUE))
#> Observations: 22,313
#> Variables: 11
#> $ province_state <chr> "Adams, IN", "Adams, IN", "Adams, IN", "Adams, IN", "A…
#> $ city_county    <chr> "Adams", "Adams", "Adams", "Adams", "Adams", "Adams", …
#> $ state          <chr> "Indiana", "Indiana", "Indiana", "Indiana", "Indiana",…
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
