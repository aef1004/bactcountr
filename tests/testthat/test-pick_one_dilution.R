context("cfu dataframe format")

test_that("Input dataframe must contain numeric `dilution` and `CFUs` columns", {

  data <- CFU_raw_formatted

  expect_is(data, "data.frame")
  expect_is(data$dilution, "numeric")
  expect_is(data$CFUs, "numeric")

})

test_that("Output dataframe", {

  one_dilution_data <- pick_one_dilution(CFU_raw_formatted, "CFUs", c("group", "organ", "mouse"))

  expect_is(one_dilution_data, "data.frame")
  expect_is(one_dilution_data$CFUs, "numeric")
  expect_is(one_dilution_data$dilution, "numeric")

})



