
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Execute Command Line Programs Interactively

<!-- badges: start -->

[![R-CMD-check](https://github.com/randy3k/cliff/workflows/R-CMD-check/badge.svg)](https://github.com/randy3k/cliff/actions)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/cliff)](https://cran.r-project.org/package=cliff)
[![](https://cranlogs.r-pkg.org/badges/grand-total/cliff)](https://cran.r-project.org/package=cliff)
<!-- badges: end -->

Github: <https://github.com/RTagBot/cliff>

Documentation:
[https://randy3k.github.io/cliff](https://randy3k.github.io/cliff/)

Execute command line programs and format results for interactive use. It
is based on the package ‘processx’ so it does not use shell to start up
the process like system() and system2(). It also provides a simpler and
cleaner interface than processx::run().

## Installation

You can install the released version of cliff from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("cliff")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("randy3k/cliff")
```

## Example

``` r
git <- function(...) cliff::run("git", ...)

git("log", git("rev-parse", "--abbrev-ref", "HEAD"), "-n1")
```

    ## commit cf5cdb734aac42f5350ea690874554bfaa94b8dc
    ## Author: Randy Lai <randy.cs.lai@gmail.com>
    ## Date:   Tue Nov 2 13:49:25 2021 -0700
    ## 
    ##     update docs
