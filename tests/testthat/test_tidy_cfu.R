context("cfu dataframe format")

test_that("The format of the cfu dataframe is usable", {

  data <- CFU_excel_raw

  cleaned_data <- tidy_CFU(data, "CFUs")

  expect_is(cleaned_data, "data.frame")
  expect_is(cleaned_data$CFUs, "numeric")
  expect_is(cleaned_data$dilution, "numeric")

})
