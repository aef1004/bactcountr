#' Clean CFU data and selects all columns that start with dilution
#'
#' @param df dataframe that contains all of the raw CFU data with the dilutions
#' @param CFU_column ?? not sure why I need this part actually...
#'
#' @return
#' @export
#'
#' @examples tidy_CFU(CFU_excel_raw, "CFUs")
#'
#'
tidy_CFU <- function(df, CFU_column) {

  CFU_column = as.name(CFU_column) # use this because I'm making changes to the column

  df %>%
    gather(key = dilution, value = CFUs, matches("dilution")) %>%
    mutate(dilution = str_replace(dilution, "dilution_", ""),
           dilution = as.numeric(dilution),
           CFUs = str_replace(!! sym(CFU_column), "TNTC", "NA"),
           CFUs = as.numeric(!! sym(CFU_column))) %>%
    na.omit()
}
