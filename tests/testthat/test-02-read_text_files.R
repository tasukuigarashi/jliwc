# Test for reading a single file
test_that("read_text_files reads a single file correctly and in the right order", {
  # Create a temporary file for testing
  temp_file <- tempfile(fileext = ".txt")
  writeLines(c("This is a test file.", "It has multiple lines."), temp_file)

  # Read the file using the function
  result <- read_text_files(temp_file)

  # Test that the result is a data frame and the content matches
  expect_true(is.data.frame(result))
  expect_equal(nrow(result), 1)
  expect_equal(result$text[1], "This is a test file.\nIt has multiple lines.")
})

# Test for reading multiple files and preserving order
test_that("read_text_files reads multiple files correctly and in correct order", {
  # Create multiple temporary files for testing
  temp_file1 <- tempfile(fileext = ".txt")
  temp_file2 <- tempfile(fileext = ".txt")
  writeLines(c("File 1 content."), temp_file1)
  writeLines(c("File 2 content."), temp_file2)

  # Read the files using the function
  result <- read_text_files(c(temp_file1, temp_file2))

  # Test that the result is a data frame and contains both files in correct order
  expect_true(is.data.frame(result))
  expect_equal(nrow(result), 2)
  expect_equal(result$text[1], "File 1 content.")
  expect_equal(result$text[2], "File 2 content.")
})

# Test for handling non-existing files
test_that("read_text_files handles non-existing files", {
  non_existing_file <- "non_existing_file.txt"

  expect_error(read_text_files(non_existing_file), "The specified path does not exist: non_existing_file.txt")
})

# Test for reading files from a directory
test_that("read_text_files reads all files from a directory in correct order", {
  temp_dir <- tempdir()
  # delete all .tx file in temp_dir
  unlink(list.files(temp_dir, pattern = "\\.txt$", full.names = TRUE))

  # Create two temporary files in the directory
  temp_file1 <- file.path(temp_dir, "test_file1.txt")
  temp_file2 <- file.path(temp_dir, "test_file2.txt")
  writeLines(c("Directory file 1 content."), temp_file1)
  writeLines(c("Directory file 2 content."), temp_file2)

  # Read files from the directory
  result <- read_text_files(temp_dir)

  # Test that both files are read into the data frame in the correct order
  expect_true(is.data.frame(result))
  expect_equal(nrow(result), 2)
  expect_equal(result$text[1], "Directory file 1 content.")
  expect_equal(result$text[2], "Directory file 2 content.")
})

# Test for handling empty files
test_that("read_text_files handles empty files correctly", {
  temp_dir <- tempdir()
  # delete all .tx file in temp_dir
  unlink(list.files(temp_dir, pattern = "\\.txt$", full.names = TRUE))

  temp_file <- tempfile(fileext = ".txt")
  file.create(temp_file) # Create an empty file
  temp_file1 <- file.path(temp_dir, "test_file1.txt")
  writeLines(c("Directory file 1 content."), temp_file1)

  result <- read_text_files(temp_dir)

  # Test that the data frame doesn't contains the empty file
  expect_true(is.data.frame(result))
  expect_equal(nrow(result), 1)
  expect_equal(result$text[1], "Directory file 1 content.")
})
