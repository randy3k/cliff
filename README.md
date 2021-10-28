
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Execute Command Line Programs Interactively

<!-- badges: start -->

[![R-CMD-check](https://github.com/rtagbot/cliff/workflows/R-CMD-check/badge.svg)](https://github.com/rtagbot/cliff/actions)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/cliff)](https://cran.r-project.org/package=cliff)
[![](https://cranlogs.r-pkg.org/badges/grand-total/cliff)](https://cran.r-project.org/package=cliff)
<!-- badges: end -->

Github: <https://github.com/RTagBot/cliff>

Documentation:
[https://rtagbot.github.io/cliff](https://rtagbot.github.io/cliff/)

Execute command line programs and format results for interactive use. It
is based on the package ‘processx’ so it does not use shell to start up
the process like ‘system()’ and ‘system2()’. It also provides a simpler
and cleaner interface than ‘processx::run()’.

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

    ## commit 55b20b7ca1d675469bd5b1c18e4e00c12fc4d984
    ## Author: Randy Lai <randy.cs.lai@gmail.com>
    ## Date:   Wed Oct 27 10:07:23 2021 -0700
    ## 
    ##     bump to 0.1.2
