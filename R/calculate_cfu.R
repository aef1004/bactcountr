#' Calculate the cfus based on the dilution factor and resuspended volume
#'
#' @param df dataframe that contains information on the cfu counts and corresponding dilutions
#' @param dilution_factor the dilution factor used to perform dilutions (e.g., 5 fold dilutions)
#' @param resuspend_volume_mL the volume that the organ is resuspended in mL (e.g., 0.5 mL)
#' @param percent percentage of the organ used to plate as a fraction/decimal, default is 1 (whole organ)
#' @param dilution_column name of the dilution column in the input dataframe
#' @param CFU_column name of the CFU column in the input dataframe
#'
#' @return df
#' @export
#'
#' @examples calculate_cfu(CFU_one_dilution, 5, 0.5, .5, "dilution", "CFUs")
#'
#'
calculate_cfu <- function(df, dilution_factor, resuspend_volume_mL, percent = 1, dilution_column = "dilution", CFU_column = "CFUs") {

  stopifnot(percent <1)
  CFU_column = as.name(CFU_column)
  dilution_column = as.name(dilution_column)
  calculated_CFU <- whole_CFUs <- log_CFUs <- NULL

  new_df <- df %>%
    dplyr::mutate(calculated_CFU = (10*!! rlang::sym(CFU_column)*dilution_factor^ !! rlang::sym(dilution_column))*resuspend_volume_mL,
           whole_CFUs = calculated_CFU/percent,
           log_CFUs = log10(whole_CFUs),
           log_CFUs = as.numeric(stringr::str_replace(log_CFUs, "-Inf", "0"))) # could add a case_when for this part

  return(new_df)
}
