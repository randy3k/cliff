get_git_path  <- function() {
    path <- getOption("git_path", Sys.which("git"))
    if (is.null(path) && .Platform$OS.type == "windows") {
        paths <- c(
            "C:\\Program Files\\Git\\bin\\git.exe",
            "C:\\Program Files (x86)\\Git\\bin\\git.exe"
        )
        for (p in paths) {
            if (file.exists(p)) {
                return(p)
            }
        }
    }
    if (is.null(path) || !nzchar(path)) {
        stop("cannot find 'git' binary", call. = FALSE)
    }
    path
}


#' Running a Git Command
#' @export
#' @param ... the arguments pass to git command, supports the
#'     [big bang](https://rlang.r-lib.org/reference/nse-force.html) operator `!!!`
#' @param input text pass to stdin
#' @param wd working directory
#' @param env additional environment variable pass to git
#' @param just_the_proc return the underlying process object instead of the output
#' @return The output in a scalar character. It may contain a trailing newline. Use `as.character()`
#'     to ensure the trailing newline is trimmed.
#' @details
#' If `git()` fails to locate the git binary automatically, the path could be
#' specify with `options(git_path = "/path/to/git")`.
#'
#' @examples
#' \donttest{
#' cwd <- getwd()
#' td <- file.path(tempdir(), "git-examples")
#' dir.create(td, showWarnings = FALSE)
#' setwd(td)
#'
#' git("init")
#' git("config", "--local", "user.email", "you@example.com")
#' git("config", "--local", "user.name", "Your Name")
#'
#' cat("hello\n", file = "hello.txt")
#'
#' git("status")
#'
#' git("add", "hello.txt")
#'
#' git("commit", "-m", "initial message")
#'
#' git("log")
#'
#' cat("world\n", file = "world.txt")
#'
#' git("add", "world.txt")
#'
#' git("commit", "-F", "-", input = "second message")
#'
#' (sha <- git("rev-parse", "HEAD"))
#'
#' git("show", sha)
#'
#' setwd(cwd)
#' }
#'
git <- function(
        ...,
        input = NULL,
        wd = NULL,
        env = NULL,
        just_the_proc = FALSE) {

    on.exit({
        try(p$kill(), silent = TRUE)
    })

    ellipsis::check_dots_unnamed()
    git_path <- get_git_path()
    args <- vapply(rlang::list2(...), function(x) as.character(x), character(1))
    p <- processx::process$new(
        git_path,
        args,
        stdin = "|",
        stdout = "|",
        stderr = "|",
        env = env,
        wd = wd,
        windows_hide_window = TRUE)
    if (!is.null(input)) {
        r <- p$write_input(input)
        while (is.raw(r) && length(r) > 0) {
            r <- p$write_input(r)
        }
        close(p$get_input_connection())
    }
    if (just_the_proc) {
        return(p)
    }
    p$wait()
    out <- p$read_all_output()
    err <- p$read_all_error()

    if (!identical(p$get_exit_status(), 0L)) {
        if (nzchar(out) > 0 || nzchar(err) > 0) {
            stop(paste0(out, err), call. = FALSE)
        } else{
            stop("git command returns with status ", p$get_exit_status(), call. = FALSE)
        }
    }

    structure(out, class = "git_output", err = err)
}

#' @export
#' @method print git_output
print.git_output <- function(x, ...) {
    if (nzchar(x)) {
        cat(x)
    }
    err <- attr(x, "err")
    if (nzchar(err)) {
        cat(err, file = stderr())
    }
}


#' @export
#' @method as.character git_output
as.character.git_output <- function(x, trim = TRUE, ...) {
    err <- attr(x, "err")
    out <- paste0(x, err)
    if (trim) {
        out <- trimws(out)
    }
    out
}
