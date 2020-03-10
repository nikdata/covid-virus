
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
#> # A tibble: 6 x 7
#>   province_state     country_region   lat  long date       type      cases
#>   <chr>              <chr>          <dbl> <dbl> <date>     <chr>     <dbl>
#> 1 Alameda County, CA US              37.6 -122. 2020-01-22 confirmed     0
#> 2 Alameda County, CA US              37.6 -122. 2020-01-23 confirmed     0
#> 3 Alameda County, CA US              37.6 -122. 2020-01-24 confirmed     0
#> 4 Alameda County, CA US              37.6 -122. 2020-01-25 confirmed     0
#> 5 Alameda County, CA US              37.6 -122. 2020-01-26 confirmed     0
#> 6 Alameda County, CA US              37.6 -122. 2020-01-27 confirmed     0
```

``` r
tail(corona_virus)
#> # A tibble: 6 x 7
#>   province_state country_region   lat  long date       type      cases
#>   <chr>          <chr>          <dbl> <dbl> <date>     <chr>     <dbl>
#> 1 <NA>           Vietnam           16   108 2020-03-04 recovered     0
#> 2 <NA>           Vietnam           16   108 2020-03-05 recovered     0
#> 3 <NA>           Vietnam           16   108 2020-03-06 recovered     0
#> 4 <NA>           Vietnam           16   108 2020-03-07 recovered     0
#> 5 <NA>           Vietnam           16   108 2020-03-08 recovered     0
#> 6 <NA>           Vietnam           16   108 2020-03-09 recovered     0
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
#>  1 Mainland China confirmed       80735
#>  2 Mainland China recovered       58735
#>  3 Italy          confirmed        9172
#>  4 South Korea    confirmed        7478
#>  5 Iran           confirmed        7161
#>  6 Mainland China death            3120
#>  7 Iran           recovered        2394
#>  8 France         confirmed        1209
#>  9 Germany        confirmed        1176
#> 10 Spain          confirmed        1073
#> 11 Italy          recovered         724
#> 12 Others         confirmed         696
#> 13 US             confirmed         605
#> 14 Japan          confirmed         511
#> 15 Italy          death             463
#> 16 Switzerland    confirmed         374
#> 17 Netherlands    confirmed         321
#> 18 UK             confirmed         321
#> 19 Sweden         confirmed         248
#> 20 Belgium        confirmed         239
```

To manually create a wide dataframe, you can do the following (it is
recommended to use the wide=TRUE argument):

    #> # A tibble: 10 x 4
    #>    country     confirmed death recovered
    #>    <chr>           <dbl> <dbl>     <dbl>
    #>  1 Italy            1797    97       102
    #>  2 Iran              595    43       260
    #>  3 Spain             400    11         2
    #>  4 South Korea       164     3         0
    #>  5 Germany           136     2         0
    #>  6 France             83     0         0
    #>  7 US                 68     1         0
    #>  8 Netherlands        56     0         0
    #>  9 Denmark            55     0         0
    #> 10 UK                 48     1         0

### Wide Dataframe

Sometimes it may be easier to have a “wide” dataframe that enables you
to see the number of cases for each type in their own respective
columns.

    #> # A tibble: 10 x 8
    #>    province_state country_region   lat  long date       confirmed death
    #>    <chr>          <chr>          <dbl> <dbl> <date>         <dbl> <dbl>
    #>  1 Alameda Count… US              37.6 -122. 2020-01-22         0     0
    #>  2 Alameda Count… US              37.6 -122. 2020-01-23         0     0
    #>  3 Alameda Count… US              37.6 -122. 2020-01-24         0     0
    #>  4 Alameda Count… US              37.6 -122. 2020-01-25         0     0
    #>  5 Alameda Count… US              37.6 -122. 2020-01-26         0     0
    #>  6 Alameda Count… US              37.6 -122. 2020-01-27         0     0
    #>  7 Alameda Count… US              37.6 -122. 2020-01-28         0     0
    #>  8 Alameda Count… US              37.6 -122. 2020-01-29         0     0
    #>  9 Alameda Count… US              37.6 -122. 2020-01-30         0     0
    #> 10 Alameda Count… US              37.6 -122. 2020-01-31         0     0
    #> # … with 1 more variable: recovered <dbl>

## Comments

I would greatly appreciate any feedback you may have. If you find a bug,
please file an issue.

Finally, a **HUGE** thanks to Rami Krispin for creating the
{coronavirus} package\!
