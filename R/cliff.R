#' Run a command line program and wait until it terminates.
#' @import rlang
#' @export
#' @param command the command to run
#' @param ... the arguments pass to the program, supports the
#'     [big bang](https://rlang.r-lib.org/reference/nse-force.html) operator `!!!`
#' @param input text pass to stdin
#' @param error_on_status raise an error if return code is not 0.
#' @param wd working directory
#' @param timeout throw an error after this amount of time in second
#' @param env additional environment variables
#' @return The stdout of the process in a scalar character.
#' It may contain a trailing newline. Use `trimws()` to
#' ensure the trailing newline is trimmed.
#' @examples
#' \dontrun{
#' git <- function(...) cliff::run("git", ...)
#' git("log", git("rev-parse", "--abbrev-ref", "HEAD"), "-n1")
#' }
#'
run <- function(
        command,
        ...,
        input = NULL,
        error_on_status = TRUE,
        wd = NULL,
        timeout = Inf,
        env = NULL) {

    on.exit({
        try(p$kill(), silent = TRUE)
    })

    ellipsis::check_dots_unnamed()
    args <- list2(...)
    for (i in seq_along(args)) {
        a <- args[[i]]
        if (!is.character(a) || !nzchar(a)) {
            stop("argument ", i, " is not a valid character")
        }
    }
    args <- vapply(
        args,
        function(x) if (inherits(x, "cliff_raw_output")) trimws(x) else x,
        character(1))
    p <- processx::process$new(
        command,
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
            c("cliff_timeout_error", "cliff_error"),
            stdout = out, stderr = err, message = "program timeout exceeded")
        cnd_signal(cnd)
    } else if (error_on_status && !identical(p$get_exit_status(), 0L)) {
        message <- sprintf("program terminated with code %i", p$get_exit_status())
        if (nzchar(err) > 0) {
            message <- paste0(message, "\n", silver("Got the following in stderr:"), "\n", red(err))
        } else if (nzchar(out) > 0) {
            message <- paste0(message, "\n", silver("Got the following in stdout:"), "\n", out)
        }
        cnd <- error_cnd("cliff_error", stdout = out, stderr = err, message = message)
        cnd_signal(cnd)
    }

    structure(out, class = "cliff_raw_output", err = err)
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
#' @method print cliff_raw_output
print.cliff_raw_output <- function(x, with_stderr = FALSE, ...) {
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
