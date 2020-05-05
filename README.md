<!-- README.md is generated from README.Rmd. Please edit that file -->

# A Simple Wrapper for Git Command Line

<!-- badges: start -->

[![R-CMD-check](https://github.com/randy3k/git/workflows/R-CMD-check/badge.svg)](https://github.com/randy3k/git/actions)
[![codecov](https://codecov.io/gh/randy3k/git/branch/master/graph/badge.svg)](https://codecov.io/gh/randy3k/git)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/git)](https://cran.r-project.org/package=git)
[![](http://cranlogs.r-pkg.org/badges/grand-total/git)](https://cran.r-project.org/package=git)
<!-- badges: end -->

Documentation: [http://randy3k.github.io/git](https://randy3k.github.io/git)

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

## Example

``` r
library(git)

git("status")
#> On branch master
#> Your branch is up to date with 'origin/master'.
#> 
#> Changes not staged for commit:
#>   (use "git add <file>..." to update what will be committed)
#>   (use "git restore <file>..." to discard changes in working directory)
#>  modified:   README.Rmd
#>  modified:   README.md
#> 
#> no changes added to commit (use "git add" and/or "git commit -a")

git("log", "--graph", "--oneline", "-n5")
#> * 42ae287 update
#> * a869c4b update docs
#> * ba7e0a7 use dontrun instead
#> * 523f70d reset wd
#> * 68173cb update docs
```
