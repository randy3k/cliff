get_git_path  <- function() {
    path <- getOption("git_path", Sys.which("git"))
    if (is.null(path) || !nzchar(path)) {
        path <- "git"
    }
    path
}


#' @export
git <- function(
        ...,
        input = NULL,
        working_dir = NULL,
        throw_on_stderr = FALSE,
        env = NULL,
        just_the_proc = FALSE) {
    on.exit({
        try(p$kill(), silent = TRUE)
    })

    ellipsis::check_dots_unnamed()
    git_path <- get_git_path()
    args <- as.character(rlang::list2(...))
    p <- processx::process$new(
        git_path, args, stdin = "|", stdout = "|", stderr = "|", env = env, wd = working_dir)
    if (just_the_proc) {
        return(p)
    }
    if (!is.null(input)) {
        r <- p$write_input(input)
        while (is.raw(r) && length(r) > 0) {
            r <- p$write_input(r)
        }
        close(p$get_input_connection())
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

    if (nzchar(err) > 0) {
        if (throw_on_stderr) {
            stop(paste0(out, err))
        }
    }
    structure(out, class = "git_result", err = err)
}

#' @export
#' @method print git_result
print.git_result <- function(x, ...) {
    if (nzchar(x)) {
        cat(x)
    }
    err <- attr(x, "err")
    if (nzchar(err)) {
        cat(err, file = stderr())
    }
}


#' @export
#' @method as.character git_result
as.character.git_result <- function(x, ...) {
    err <- attr(x, "err")
    paste0(x, err)
}
