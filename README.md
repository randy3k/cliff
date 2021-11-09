
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Execute Command Line Programs Interactively

<!-- badges: start -->

[![check](https://github.com/randy3k/cliff/actions/workflows/check.yaml/badge.svg)](https://github.com/randy3k/cliff/actions/workflows/check.yaml)
[![codecov](https://codecov.io/gh/randy3k/cliff/branch/master/graph/badge.svg)](https://codecov.io/gh/randy3k/cliff)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/cliff)](https://cran.r-project.org/package=cliff)
[![](https://cranlogs.r-pkg.org/badges/grand-total/cliff)](https://cran.r-project.org/package=cliff)
<!-- badges: end -->

Github: <https://github.com/randy3k/cliff>

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

    ## commit 4e877ae133e77889513e7b56519eb6ec3062a768
    ## Author: Randy Lai <randy.cs.lai@gmail.com>
    ## Date:   Sat Nov 6 15:31:23 2021 -0700
    ## 
    ##     Update docs
