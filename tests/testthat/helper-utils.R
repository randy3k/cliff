git <- function(...) cliff::run("git", ...)

local_temp_git_repo <- function() {
    repo <- tempfile("repo")
    dir.create(repo, showWarnings = FALSE)
    withr::defer_parent(unlink(repo))
    git("init", wd = repo)
    return(repo)
}
