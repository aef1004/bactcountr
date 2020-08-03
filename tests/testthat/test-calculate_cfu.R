context("calculate cfu input and output")

test_that("Input dataframe must contain numeric `dilution` and `CFUs` columns", {

  data <- CFU_one_dilution

  expect_is(data, "data.frame")
  expect_is(data$dilution, "numeric")
  expect_is(data$CFUs, "numeric")
  expect_lte(percent, 1)

})

test_that("Output dataframe", {

  calculate_cfu(CFU_one_dilution, dilution_factor = 5, resuspend_volume_ml = 0.5, percent = .5, "dilution", "CFUs")

  expect_is(one_dilution_data, "data.frame")
  expect_is(one_dilution_data$CFUs, "numeric")
  expect_is(one_dilution_data$dilution, "numeric")

})
