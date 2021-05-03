#' Clean CFU data and selects all columns that start with dilution - it also removes counts >150 because they are not as accurate
#'
#' @param df dataframe that contains all of the raw CFU data with the dilutions
#'
#' @return df
#' @export
#'
#' @examples tidy_CFU(CFU_data)
#'
#' @importFrom dplyr %>%
#'
tidy_CFU <- function(df) {

  CFU_column <- "CFUs" # this is the column I create later with the gather
  CFU_column = as.name(CFU_column) # use this because I'm making changes to the column
  dilution <- CFUs <- NULL # bind the variable locally to the function as I'm creating these columns

  df %>%
    tidyr::gather(key = dilution, value = CFUs, tidyr::matches("dilution")) %>%
    dplyr::mutate(dilution = stringr::str_replace(dilution, "dilution_", ""),
           dilution = as.numeric(dilution),
           CFUs = stringr::str_replace(!! rlang::sym(CFU_column), "TNTC", "NA"),
           CFUs = as.numeric(!! rlang::sym(CFU_column))) %>%
    dplyr::filter(CFUs < 150) %>%
    stats::na.omit()
}
