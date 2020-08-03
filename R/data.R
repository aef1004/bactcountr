#' Raw CFU data
#'
#' A dataset containing the Colony Forming Units (CFUs) for different mice
#' at various dilutions
#'
#' @format A data frame with 46 rows and 7 variables:
#' \describe{
#'   \item{group}{group number to which each mouse belongs}
#'   \item{mouse}{mouse name}
#'   \item{organ}{organ name of each sample}
#'   \item{dilution_0}{number of CFUs present for the undiluted sample}
#'   \item{dilution_1}{number of CFUs present for dilution 1}
#'   \item{dilution_2}{number of CFUs present for dilution 2}
#'   \item{dilution_3}{number of CFUs present for dilution 3}
#'   ...
#' }
"CFU_excel_raw"


#' CFU data formatted after using tidy_cfu
#'
#' A dataset containing the Colony Forming Units (CFUs) for different mice
#' at various dilutions
#'
#' @format A data frame with 181 rows and 5 variables:
#' \describe{
#'   \item{group}{group number to which each mouse belongs}
#'   \item{mouse}{mouse name}
#'   \item{organ}{organ name of each sample}
#'   \item{dilution}{the dilution at which each CFU count is counted}
#'   \item{CFUs}{number of CFUs present for each of the corresponding dilutions}
#'   ...
#' }

"CFU_raw_formatted"


#' CFU data formatted before calculating whole and log CFUs
#'
#' A dataset containing the Colony Forming Units (CFUs) for different mice
#' at various dilutions
#'
#' @format A data frame with 46 rows and 5 variables:
#' \describe{
#'   \item{group}{group number to which each mouse belongs}
#'   \item{mouse}{mouse name}
#'   \item{organ}{organ name of each sample}
#'   \item{dilution}{the dilution at which each CFU count is counted}
#'   \item{CFUs}{number of CFUs present for each of the corresponding dilutions}
#'   ...
#' }

"CFU_one_dilution"
