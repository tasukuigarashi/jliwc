other_function <- function(...) {
  if (exists("package:jliwc", where = .GlobalEnv)) {
    env <- get("jliwc_env", as.environment("package:jliwc"))
  } else {
    env <- get("jliwc_env", .GlobalEnv)
  }

  # 環境内の関数を使用
  result <- env$MECAB_LOOKUP
  return(result)
}
