#' Pick one dilution to perform CFU calculations on
#'
#' @param df dataframe that contains columns: dilution, CFU, and grouping variables
#' @param CFU_column the name of the CFU column in the dataframe
#' @param grouping_columns the columns names to group the data based on (i.e., Group, Timepoint)
#'
#' @return df
#' @export
#'
#' @examples pick_one_dilution(CFU_raw_formatted, "CFUs", c("group", "organ", "mouse"))
#'
#' @importFrom dplyr %>%
#' @importFrom rlang .data

#'
pick_one_dilution <- function(df, CFU_column, grouping_columns) {

  CFU_column = as.name(CFU_column) # use this because I'm making changes to the column
  grouping_columns <- rlang::syms(grouping_columns) # use this for grouping


  CFUs_2 <- sub_CFUs <- NULL

  df %>%
    dplyr::mutate(CFUs_2 = ifelse(.data$CFUs == 0, NA, .data$CFUs), # maybe don't need to convert to NA
           sub_CFUs = abs(25 - CFUs_2)) %>% # see if we can do this a little bit more elegantly
    dplyr::group_by(!!!grouping_columns) %>%
    dplyr::arrange(!!!grouping_columns, .data$sub_CFUs, .data$dilution) %>%
    dplyr::slice(1) %>%
    dplyr::select(-CFUs_2, -sub_CFUs)
}
