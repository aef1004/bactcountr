
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bactcountr

<!-- badges: start -->

<!-- badges: end -->

The goal of bactcountr is to provide an automated way to calculate CFUs
based on the dilutions used and to plot the final results.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("aef1004/bactcountr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(bactcountr)
## basic example code
```

``` r
CFU_raw_formatted <- tidy_CFU(CFU_excel_raw, "CFUs")
#> Warning: NAs introduced by coercion

pick_one_dilution(CFU_raw_formatted, "CFUs", c("group", "organ", "mouse"))
#> # A tibble: 46 x 5
#> # Groups:   group, organ, mouse [46]
#>    group mouse organ  dilution  CFUs
#>    <dbl> <chr> <chr>     <dbl> <dbl>
#>  1     2 A     Lung          0     0
#>  2     2 B     Lung          0     0
#>  3     2 C     Lung          0     2
#>  4     2 A     Spleen        0    26
#>  5     2 B     Spleen        2    10
#>  6     2 C     Spleen        0     0
#>  7     3 A     Lung          0     0
#>  8     3 B     Lung          0     1
#>  9     3 C     Lung          0     0
#> 10     3 A     Spleen        0     0
#> # … with 36 more rows
```
