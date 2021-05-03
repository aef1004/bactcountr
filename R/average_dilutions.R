#' Average CFUs for each sample
#'
#' This is the method used by Mercedes lab - they take all of the dilutions for which there are countable CFUs and find an average of the CFUs for each sample. This is an alternative to "pick_one_dilution."
#'
#' @param df dataframe that contains columns: dilution, CFU, and grouping variables
#' @param CFU_column the name of the CFU column in the dataframe
#' @param grouping_columns the columns names to group the data based on (i.e., Group, Timepoint)
#'
#' @return
#' @export
#'
#' @examples average_dilutions(CFU_raw_formatted, "CFUs", c("group", "organ", "replicate"))
#'
#' @importFrom dplyr %>%
#' @importFrom rlang .data
#'
average_dilutions <- function(df, CFU_column, grouping_columns) {

}
