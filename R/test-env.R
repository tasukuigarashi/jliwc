other_function <- function(...) {
  if (exists("package:jliwc", where = .GlobalEnv)) {
    env <- get("jliwc_env", as.environment("package:jliwc"))
  } else {
    env <- get("jliwc_env", .GlobalEnv)
  }

  # Use the environment to get the value of the variable
  result <- env$MECAB_LOOKUP
  return(result)
}
