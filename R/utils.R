is_installed <- function(pkg) {
  is_true(requireNamespace(pkg, quietly = TRUE))
}

has_crayon <- function() {
  is_installed("crayon") && crayon::has_color()
}

silver <- function(x) if (has_crayon()) crayon::silver(x) else x
red <- function(x) if (has_crayon()) crayon::red(x) else x
