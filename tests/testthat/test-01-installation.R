# Test dictionary installation functions
temp_dir <- tempdir()
config_dir <- file.path(temp_dir, "jliwc", "config")
data_dir <- file.path(temp_dir, "jliwc", "data")

mock_R_user_dir <- mockery::mock(temp_dir)

# Helper function to create a temporary directory and file
create_temp_config <- function(data_dir, config_dir) {
  dir.create(config_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)
  config_file <- file.path(config_dir, "config.json")
  return(list(config_dir = config_dir, data_dir = data_dir, file = config_file))
}

# Helper function to create a mock config file
create_mock_config <- function(data_dir, config_dir) {
  config <- list(
    ipadic = sapply(c("char.bin", "dicrc", "matrix.bin", "sys.dic", "unk.dic"), function(file) {
      normalizePath(file.path(data_dir, "mecab-ipadic", file), winslash = "/", mustWork = FALSE)
    }) |> as.vector(),
    userdic = normalizePath(file.path(data_dir, "user_dict.dic"), winslash = "/", mustWork = FALSE),
    jliwcdic = normalizePath(file.path(data_dir, "LIWC2015_mock_jp.dic"), winslash = "/", mustWork = FALSE)
  )

  dir.create(config_dir, recursive = TRUE, showWarnings = FALSE)
  config_file <- file.path(config_dir, "config.json")

  # return(list(file = config_file, content = config |> jsonlite::toJSON()))
  return(list(file = config_file, content = config))
}

# a directory to a install configuration file
# temp_config_dir <- create_temp_config(temp_dir)$config_dir

# a directory to install dictionary files
# temp_data_dir <- create_temp_config(temp_dir)$data_dir

options(jliwc_project_home = data_dir)

# create a mock configuration file
mock_config <- create_mock_config(data_dir, config_dir)

# IPAdic
test_that("install_ipadic proceeds with user confirmation", {
  with_mocked_bindings(
    readline = function(prompt) "y", # Mock readline to return "y"
    {
      options(jliwc_project_home = data_dir)

      mock_save_jliwc_config <- function(file_path, config_key) {
        save_jliwc_config(file_path, config_key, config_dir = temp_dir)
      }

      mockery::stub(install_ipadic, "save_jliwc_config", mock_save_jliwc_config)

      expect_true(install_ipadic(data_dir)) # Should proceed with installation
    }
  )
})

test_that("install_ipadic aborts on 'no'", {

  with_mocked_bindings(
    readline = function(prompt) "n", # Mock readline to return "n"
    {
      options(jliwc_project_home = data_dir)

      mock_save_jliwc_config <- function(file_path, config_key) {
        save_jliwc_config(file_path, config_key, config_dir = temp_dir)
      }

      mockery::stub(install_ipadic, "save_jliwc_config", mock_save_jliwc_config)

      expect_false(install_ipadic(data_dir)) # Should abort installation
    }
  )
})

# User dictionary
test_that("install_userdic proceeds with user confirmation", {

  with_mocked_bindings(
    readline = function(prompt) "y", # Mock readline to return "y"
    {
      options(jliwc_project_home = data_dir)

      mock_save_jliwc_config <- function(file_path, config_key) {
        save_jliwc_config(file_path, config_key, config_dir = temp_dir)
      }

      mockery::stub(install_userdic, "save_jliwc_config", mock_save_jliwc_config)

      expect_true(install_userdic(data_dir)) # Should proceed with installation
    }
  )
})

test_that("install_userdic aborts on 'no'", {

  with_mocked_bindings(
    readline = function(prompt) "n", # Mock readline to return "n"
    {
      options(jliwc_project_home = data_dir)

      mock_save_jliwc_config <- function(file_path, config_key) {
        save_jliwc_config(file_path, config_key, config_dir = temp_dir)
      }

      mockery::stub(install_userdic, "save_jliwc_config", mock_save_jliwc_config)

      expect_false(install_userdic(data_dir)) # Should abort installation
    }
  )
})

# Check dictionaries
test_that("test check_ipadic and check_userdic", {
  options(jliwc_project_home = data_dir)
  expect_true(check_ipadic(data_dir)) # Should return TRUE
  expect_true(check_userdic(data_dir)) # Should return TRUE
})

# J-LIWC2015 dictionary
test_that("install_jliwc2015 proceeds with user confirmation", {
  with_mocked_bindings(
    readline = function(prompt) "y", # Mock readline to return "y"
    {
      options(jliwc_project_home = data_dir)

      mock_save_jliwc_config <- function(file_path, config_key) {
        save_jliwc_config(file_path, config_key, config_dir = temp_dir)
      }

      mockery::stub(install_jliwcdic, "save_jliwc_config", mock_save_jliwc_config)

      options(jliwc_project_home = data_dir)
      filename <- "LIWC2015_mock_jp.dic"
      # override a file name
      options(jliwc_dic_filename = list(LIWC2015 = filename))
      dic <- system.file("extdata", filename, package = "jliwc")

      # Mock dictionary categories (in Japanese)
      jliwc_env$liwc_cat_ja <- c("機能語", "名詞", "動詞", "ポジティブ感情", "ネガティブ感情", "人物名")

      expect_true(file.exists(dic))
      expect_true(install_jliwcdic(dir = data_dir, dic = dic)) # Should proceed with installation
    }
  )
})
