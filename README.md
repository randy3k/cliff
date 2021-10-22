
<!-- README.md is generated from README.Rmd. Please edit that file -->

# A Simple Wrapper for Git Command Line

<!-- badges: start -->

[![R-CMD-check](https://github.com/rtagbot/git/workflows/R-CMD-check/badge.svg)](https://github.com/rtagbot/git/actions)
[![codecov](https://codecov.io/gh/rtagbot/git/branch/master/graph/badge.svg)](https://codecov.io/gh/rtagbot/git)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/git)](https://cran.r-project.org/package=git)
[![](https://cranlogs.r-pkg.org/badges/grand-total/git)](https://cran.r-project.org/package=git)
<!-- badges: end -->

Github: <https://github.com/RTagBot/git>

Documentation: <https://rtagbot.github.io/git>

While ‘git2r’ and ‘gert’ provide excellent bindings to the ‘libgit2’
library, they do not cover all functionalities that the git command line
offers. This simple wrapper of the git command line exposes the git
command line to R and allows users to invoke git commands directly from
R. Readers should keep in mind that there are performance tradeoffs to
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
    ## Changes not staged for commit:
    ##   (use "git add <file>..." to update what will be committed)
    ##   (use "git restore <file>..." to discard changes in working directory)
    ##  modified:   docs/404.html
    ##  modified:   docs/LICENSE-text.html
    ##  modified:   docs/LICENSE.html
    ##  modified:   docs/authors.html
    ##  modified:   docs/index.html
    ##  modified:   docs/pkgdown.css
    ##  modified:   docs/pkgdown.js
    ##  modified:   docs/pkgdown.yml
    ##  modified:   docs/reference/git.html
    ##  modified:   docs/reference/index.html
    ## 
    ## no changes added to commit (use "git add" and/or "git commit -a")

``` r
git("log", "--graph", "--oneline", "-n5")
```

    ## * 26ff855 upgrade Roxygen
    ## * 264caa4 add test
    ## * 2a2c270 udpate check.yaml
    ## * 9935620 update docs
    ## * cd71e61 better argument validation
