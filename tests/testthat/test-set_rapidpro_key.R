library(testthat)

# Assuming 'pkg_env' is defined somewhere in your package's environment
pkg_env <- new.env()

# Mock the 'rapidpro_key' variable in the package environment for testing
# Replace 'your_mocked_key_value' with the value you want to test
set_rapidpro_key("your_mocked_key_value")

# Write the unit test
test_that("get_rapidpro_key returns the correct key", {
  expected_key <- "your_mocked_key_value"
  actual_key <- get_rapidpro_key()
  expect_equal(actual_key, expected_key, 
               info = "The function should return the correct rapidpro key.")
})
