<!-- README.md is generated from README.Rmd. Please edit that file -->

# A Simple Wrapper for Git Command Line

<!-- badges: start -->

[![R-CMD-check](https://github.com/randy3k/git/workflows/R-CMD-check/badge.svg)](https://github.com/randy3k/git/actions)
[![codecov](https://codecov.io/gh/randy3k/git/branch/master/graph/badge.svg)](https://codecov.io/gh/randy3k/git)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/git)](https://cran.r-project.org/package=git)
[![](https://cranlogs.r-pkg.org/badges/grand-total/git)](https://cran.r-project.org/package=git)
<!-- badges: end -->

Github: <https://github.com/randy3k/git>

Documentation: <https://randy3k.github.io/git>

While ‘git2r’ and ‘gert’ provide excellent bindings to the ‘libgit2’ library,
they do not cover all functionalities that the git command line offers. This simple
wrapper of the git command line exposes the git command line to R and allows users to
invoke git commands directly from R. Readers should keep in mind that
there are performance tradeoffs to use the wrapped command line instead of using directly
the efficient ‘libgit2’ library. In addition, user authentication cannot not handled seamlessly.
In most situations, this should be only considered if ‘git2r’ or ‘gert’ do not satisfy the needs.

## Installation

You can install the released version of git from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("git")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("randy3k/git")
```

## Example

``` r
library(git)

git("status")
#> On branch master
#> Your branch is up to date with 'origin/master'.
#> 
#> nothing to commit, working tree clean

git("log", "--graph", "--oneline", "-n5")
#> * b922c3e update docs
#> * 1c974d7 add dev installation note
#> * f4cacd0 fix doc errors
#> * 66c6817 udpate README
#> * 42ae287 update
```
