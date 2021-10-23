
<!-- README.md is generated from README.Rmd. Please edit that file -->

# A Simple Wrapper for Git Command Line

<!-- badges: start -->

[![R-CMD-check](https://github.com/rtagbot/git/workflows/R-CMD-check/badge.svg)](https://github.com/rtagbot/git/actions)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/git)](https://cran.r-project.org/package=git)
[![](https://cranlogs.r-pkg.org/badges/grand-total/git)](https://cran.r-project.org/package=git)
<!-- badges: end -->

Github: <https://github.com/RTagBot/git>

Documentation:
[https://rtagbot.github.io/git](https://rtagbot.github.io/git/)

While ‘git2r’ and ‘gert’ provide excellent bindings to the ‘libgit2’
library, they do not cover all functionalities that the git command line
offers. This simple wrapper of the git command line exposes the git
command line to R and allows users to invoke git commands directly from
R. Readers should keep in mind that there are performance trade-offs to
use the wrapped command line instead of using directly the efficient
‘libgit2’ library. In addition, user authentication cannot not handled
seamlessly. In most situations, this should be only considered if
‘git2r’ or ‘gert’ do not satisfy the needs.

## Installation

You can install the released version of git from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("git")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rtagbot/git")
```

## Example

``` r
library(git)

git("status")
```

    ## On branch master
    ## Your branch is up to date with 'origin/master'.
    ## 
    ## nothing to commit, working tree clean

``` r
git("log", "--graph", "--oneline", "-n5")
```

    ## * 089b5bd fix cran complaints
    ## * 9ee0fd5 add ignore files
    ## * 03296f2 skip on cran
    ## * 519f5b6 update pkg site
    ## * 26ff855 upgrade Roxygen
