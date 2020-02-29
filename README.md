
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

corona_virus <- get_cases()
```

Similar to Rami’s package, the output is as follows:

``` r
head(corona_virus)
#> # A tibble: 6 x 7
#>   province_state country_region   lat  long date       type      cases
#>   <chr>          <chr>          <dbl> <dbl> <date>     <chr>     <dbl>
#> 1 Anhui          Mainland China  31.8  117. 2020-01-22 confirmed     1
#> 2 Anhui          Mainland China  31.8  117. 2020-01-23 confirmed     8
#> 3 Anhui          Mainland China  31.8  117. 2020-01-24 confirmed     6
#> 4 Anhui          Mainland China  31.8  117. 2020-01-25 confirmed    24
#> 5 Anhui          Mainland China  31.8  117. 2020-01-26 confirmed    21
#> 6 Anhui          Mainland China  31.8  117. 2020-01-27 confirmed    10
```

``` r
tail(corona_virus)
#> # A tibble: 6 x 7
#>   province_state country_region   lat  long date       type      cases
#>   <chr>          <chr>          <dbl> <dbl> <date>     <chr>     <dbl>
#> 1 <NA>           Vietnam           16   108 2020-02-23 recovered     0
#> 2 <NA>           Vietnam           16   108 2020-02-24 recovered     0
#> 3 <NA>           Vietnam           16   108 2020-02-25 recovered     2
#> 4 <NA>           Vietnam           16   108 2020-02-26 recovered     0
#> 5 <NA>           Vietnam           16   108 2020-02-27 recovered     0
#> 6 <NA>           Vietnam           16   108 2020-02-28 recovered     0
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
#> # Groups:   country_region [14]
#>    country_region type      total_cases
#>    <chr>          <chr>           <dbl>
#>  1 Mainland China confirmed       78824
#>  2 Mainland China recovered       36291
#>  3 Mainland China death            2788
#>  4 South Korea    confirmed        2337
#>  5 Italy          confirmed         888
#>  6 Others         confirmed         705
#>  7 Iran           confirmed         388
#>  8 Japan          confirmed         228
#>  9 Hong Kong      confirmed          94
#> 10 Singapore      confirmed          93
#> 11 Iran           recovered          73
#> 12 Singapore      recovered          62
#> 13 US             confirmed          62
#> 14 France         confirmed          57
#> 15 Germany        confirmed          48
#> 16 Italy          recovered          46
#> 17 Kuwait         confirmed          45
#> 18 Thailand       confirmed          41
#> 19 Bahrain        confirmed          36
#> 20 Iran           death              34
```

    #> # A tibble: 10 x 4
    #>    country              confirmed death recovered
    #>    <chr>                    <dbl> <dbl>     <dbl>
    #>  1 South Korea                571     0         0
    #>  2 Mainland China             326    44      3393
    #>  3 Italy                      233     4         1
    #>  4 Iran                       143     8        24
    #>  5 France                      19     0         0
    #>  6 Spain                       17     0         0
    #>  7 Japan                       14     0         0
    #>  8 United Arab Emirates         6     0         1
    #>  9 Norway                       5     0         0
    #> 10 UK                           5     0         0

## Comments

I would greatly appreciate any feedback you may have. If you find a bug,
please file an issue.

Finally, a **HUGE** thanks to Rami Krispin for creating the
{coronavirus} package\!
