# selects all columns that start with dilution
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
