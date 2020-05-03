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
they do not provide all functionalities that the git command line offers. This simple
wrapper of the git command line exposes the git command line to the R interface and
allows R users to invoke git commands directly from R. One will find this package useful
if they need to perform complicated git operations locally.

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
#> 
#> no changes added to commit (use "git add" and/or "git commit -a")

git("log", "--graph", "--oneline")
#> * db76ce0 fix badge link
#> * 9b1a848 use single quotes
#> * 798df8c update README
#> * a5c6d58 update
#> * 0d9ac61 init
```
