#' Clean CFU data and selects all columns that start with dilution
#'
#' @param df dataframe that contains all of the raw CFU data with the dilutions
#' @param CFU_column ?? not sure why I need this part actually...
#'
#' @return df
#' @export
#'
#' @examples tidy_CFU(CFU_excel_raw, "CFUs")
#'
#' @importFrom dplyr %>%
#'
tidy_CFU <- function(df, CFU_column) {

  CFU_column = as.name(CFU_column) # use this because I'm making changes to the column
  dilution <- CFUs <- NULL # bind the variable locally to the function as I'm creating these columns

  df %>%
    tidyr::gather(key = dilution, value = CFUs, tidyr::matches("dilution")) %>%
    dplyr::mutate(dilution = stringr::str_replace(dilution, "dilution_", ""),
           dilution = as.numeric(dilution),
           CFUs = stringr::str_replace(!! rlang::sym(CFU_column), "TNTC", "NA"),
           CFUs = as.numeric(!! rlang::sym(CFU_column))) %>%
    stats::na.omit()
}
