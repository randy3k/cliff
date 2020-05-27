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
        abort("cannot find 'git' binary")
    }
    path
}


#' Running a Git Command
#' @import rlang
#' @export
#' @param ... the arguments pass to git command, supports the
#'     [big bang](https://rlang.r-lib.org/reference/nse-force.html) operator `!!!`
#' @param input text pass to stdin
#' @param wd working directory
#' @param env additional environment variable pass to git
#' @param timeout throw an error after this amount of time in second
#' @param want_process return the underlying process object instead of the output
#' @return The stdout of the process in a scalar character.
#' It may contain a trailing newline. Use `trimws()` to
#' ensure the trailing newline is trimmed.
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
        timeout = Inf,
        want_process = FALSE) {

    if (!want_process) {
        on.exit({
            try(p$kill(), silent = TRUE)
        })
    }

    ellipsis::check_dots_unnamed()
    git_path <- get_git_path()
    args <- list2(...)
    for (i in seq_along(args)) {
        a <- args[[i]]
        if (!is.character(a) || !nzchar(a)) {
            stop("argument ", i, " is not a valid character")
        }
    }
    args <- vapply(
        args,
        function(x) if (inherits(x, "git_raw_output")) trimws(x) else x,
        character(1))
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
    if (want_process) {
        return(p)
    }
    res <- tryCatch(
            fetch_result(p, timeout),
            interrupt = function(e) {
                try(p$kill(), silent = TRUE)
                invokeRestart("abort")
            }
        )
    out <- res$out
    err <- res$err

    if (res$timeout_happend) {
        cnd <- error_cnd(
            c("git_timeout_error", "git_error"),
            stdout = out, stderr = err, message = "git timeout exceeded")
        cnd_signal(cnd)
    } else if (!identical(p$get_exit_status(), 0L)) {
        message <- sprintf("git terminated with code %i", p$get_exit_status())
        if (nzchar(err) > 0) {
            message <- paste0(message, "\n", silver("Got the following in stderr:"), "\n", red(err))
        } else if (nzchar(out) > 0) {
            message <- paste0(message, "\n", silver("Got the following in stdout:"), "\n", out)
        }
        cnd <- error_cnd("git_error", stdout = out, stderr = err, message = message)
        cnd_signal(cnd)
    }

    structure(out, class = "git_raw_output", err = err)
}


fetch_result <- function(proc, timeout) {
    out <- ""
    err <- ""

    start_time <- Sys.time()
    timeout_happend <- FALSE
    while (proc$is_alive()) {
        remaining <- start_time + timeout - Sys.time()
        if (remaining < 0) {
            if (proc$kill(close_connections = FALSE)) {
                timeout_happend <- TRUE
            }
            break
        }
        if (timeout < Inf) {
            remaining <- as.integer(as.numeric(remaining) * 1000)
        } else {
            remaining <- 200
        }
        proc$poll_io(remaining)
        out <- paste0(out, proc$read_output(2000))
        err <- paste0(err, proc$read_error(2000))
    }
    # make sure the process is done
    if (!timeout_happend) {
        proc$wait()
    }
    while (proc$is_incomplete_output() ||
           (proc$has_error_connection() && proc$is_incomplete_error())) {
        proc$poll_io(-1)
        out <- paste0(out, proc$read_output(2000))
        err <- paste0(err, proc$read_error(2000))
    }

    list(out = out, err = err, timeout_happend = timeout_happend)
}


#' @export
#' @method print git_raw_output
print.git_raw_output <- function(x, with_stderr = FALSE, ...) {
    err <- attr(x, "err")
    show_section <- nzchar(err) && nzchar(x)
    if (nzchar(err)) {
        cat(silver("Got the following in stderr:\n"))
        cat(err, file = stderr())
    }
    if (nzchar(x)) {
        if (show_section) cat(silver("Got the following in stdout:\n"))
        cat(x)
    }
    invisible(x)
}
