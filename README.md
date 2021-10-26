
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Execute command line programs interactively

<!-- badges: start -->

[![R-CMD-check](https://github.com/rtagbot/cliff/workflows/R-CMD-check/badge.svg)](https://github.com/rtagbot/cliff/actions)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/cliff)](https://cran.r-project.org/package=cliff)
[![](https://cranlogs.r-pkg.org/badges/grand-total/cliff)](https://cran.r-project.org/package=cliff)
<!-- badges: end -->

Github: <https://github.com/RTagBot/cliff>

Documentation:
[https://rtagbot.github.io/cliff](https://rtagbot.github.io/cliff/)

Execute command line programs and format results for interactive usage.

## Installation

You can install the released version of cliff from
[CRAN](https://CRAN.R-project.org) with:

``` r
# (not yet released)
install.packages("cliff")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rtagbot/cliff")
```

## Example

``` r
git <- function(...) cliff::run("git", ...)

git("log", git("rev-parse", "--abbrev-ref", "HEAD"), "-n1")
```

    ## commit 54b033ca7fe932f487cbd06e38d5d95654a73d08
    ## Author: Randy Lai <randy.cs.lai@gmail.com>
    ## Date:   Tue Oct 26 14:50:04 2021 -0700
    ## 
    ##     rename package
