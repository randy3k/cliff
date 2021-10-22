test_that("git status works", {
  skip_on_cran()
  wd <- local_temp_git_repo()
  result <- git("status", wd = wd)
  expect_true(grepl("No commits yet", result, fixed = TRUE))
})
