context("cfu dataframe format")

test_that("The format of the cfu dataframe is unusable", {

  data <- CFU_data

  cleaned_data <- tidy_CFU(data)

  expect_is(cleaned_data, "data.frame")
  expect_is(cleaned_data$CFUs, "numeric")
  expect_is(cleaned_data$dilution, "numeric")

})
