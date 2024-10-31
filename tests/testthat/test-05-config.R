library(mockery)

temp_dir <- tempdir()

# Helper function to create a temporary directory and file
create_temp_config <- function() {
  config_dir <- file.path(temp_dir, "jliwc", "config")
  dir.create(config_dir, recursive = TRUE, showWarnings = FALSE)
  config_file <- file.path(config_dir, "config.json")
  return(list(dir = config_dir, file = config_file))
}

temp_config <- create_temp_config()
cat(temp_config$file)

test_that("save_jliwc_config creates new config file", {
  # Mock the R_user_dir function
  mock_R_user_dir <- mock(temp_config$dir)
  stub(save_jliwc_config, "tools::R_user_dir", mock_R_user_dir)

  file_path <- "path/to/file.txt"
  save_jliwc_config(file_path, "test_key")

  expect_true(file.exists(temp_config$file))
  config <- jsonlite::read_json(temp_config$file, simplifyVector = TRUE)
  expected_path <- normalizePath(file_path, winslash = "/", mustWork = FALSE)
  expect_equal(config$test_key, expected_path)
})

test_that("save_jliwc_config overides existing config", {
  # Mock the R_user_dir function
  mock_R_user_dir <- mock(temp_config$dir)
  stub(save_jliwc_config, "tools::R_user_dir", mock_R_user_dir)

  initial_path <- "existing/path.txt"
  initial_config <- list(test_key = normalizePath(initial_path, winslash = "/", mustWork = FALSE))
  jsonlite::write_json(initial_config, temp_config$file, auto_unbox = TRUE)

  new_file_path <- "new/path/to/file.txt"
  save_jliwc_config(new_file_path, "test_key")

  config <- jsonlite::read_json(temp_config$file, simplifyVector = TRUE)
  expected_paths <- normalizePath(new_file_path, winslash = "/", mustWork = FALSE)

  expect_equal(config$test_key, expected_paths)
})

# Helper function to create a mock config file
create_mock_config <- function(temp_dir) {
  config <- list(
    jliwcdic = normalizePath(file.path(temp_dir, "J-LIWC2015", "LIWC2015_mock_jp.dic"), winslash = "/", mustWork = FALSE),
    ipadic = sapply(c("char.bin", "dicrc", "matrix.bin", "sys.dic", "unk.dic"), function(file) {
      normalizePath(file.path(temp_dir, "J-LIWC2015", "mecab-ipadic", file), winslash = "/", mustWork = FALSE)
    }) |> as.vector(),
    userdic = normalizePath(file.path(temp_dir, "J-LIWC2015", "user_dict.dic"), winslash = "/", mustWork = FALSE)
  )

  config_dir <- file.path(temp_dir, "R", "jliwc", "config")
  dir.create(config_dir, recursive = TRUE, showWarnings = FALSE)
  config_file <- file.path(config_dir, "config.json")

  return(list(file = config_file, content = config))
}

test_that("load_jliwc_config loads configuration correctly", {
  # Create a mock config file
  mock_config <- create_mock_config(tools::R_user_dir("jliwc", "config"))

  # Mock the R_user_dir function to return our temp directory
  # mock_R_user_dir <- mock(file.path(temp_dir, "R", "jliwc", "config"))
  # stub(load_jliwc_config, "tools::R_user_dir", mock_R_user_dir)

  # Run the function
  result <- load_jliwc_config()

  # Test jliwcdic
  expect_equal(result$jliwcdic, mock_config$content$jliwcdic)
  expect_true(is.character(result$jliwcdic))
  expect_length(result$jliwcdic, 1)
  expect_true(grepl("J-LIWC2015/LIWC2015_mock_jp.dic$", result$jliwcdic))

  # Test ipadic
  expect_equal(result$ipadic, mock_config$content$ipadic)
  expect_true(is.character(result$ipadic))
  expect_length(result$ipadic, 5)
  expect_true(all(grepl("J-LIWC2015/mecab-ipadic", result$ipadic)))
  expect_true(all(basename(result$ipadic) %in% c("char.bin", "dicrc", "matrix.bin", "sys.dic", "unk.dic")))

  # Test userdic
  expect_equal(result$userdic, mock_config$content$userdic)
  expect_true(is.character(result$userdic))
  expect_length(result$userdic, 1)
  expect_true(grepl("J-LIWC2015/user_dict.dic$", result$userdic))
})
