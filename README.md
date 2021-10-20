
# bactcountr

<!-- badges: start -->

<!-- badges: end -->

The goal of bactcountr is to provide an automated way to calculate CFUs
based on the dilutions used and to plot the final results.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("aef1004/bactcountr")
```

## Example

This is a basic example which shows you how to calculate CFUs based on
your data:

``` r
library(bactcountr)

library(dplyr)
library(tidyr)
library(ggplot2)
library(ggbeeswarm)
library(readxl)
library(purrr)
library(rstatix)
library(ggpubr)
```

In order to use the first function `tidy_CFU` the data must have some
columns:

  - some type of naming or grouping convention to separate out the
    individual observations such as the columns group, replicate, organ
  - dilution columns that are labeled `dilution_x` where x is the
    dilution used

<!-- end list -->

``` r
data("CFU_data")
head(CFU_data)
#> # A tibble: 6 x 7
#>   group replicate organ  dilution_0 dilution_1 dilution_2 dilution_3
#>   <dbl> <chr>     <chr>  <chr>      <chr>           <dbl>      <dbl>
#> 1     2 A         Spleen 26         10                  0          0
#> 2     2 B         Spleen TNTC       52                 10          5
#> 3     2 C         Spleen 0          0                   0          0
#> 4     3 A         Spleen 0          0                   0          0
#> 5     3 B         Spleen TNTC       TNTC               30         10
#> 6     3 C         Spleen 0          0                   0          0
```

When the `tidy_CFU` function is used, it puts it into a tidy format. The
naming/grouping columns are left alone, but the dilution and CFU columns
are gathered so that each row of the dataframe represents a single
observation. Any values in the original dataframe that are labeled as
“TNTC” (Too Numerous To Count) are converted to NA columns as they
cannot be used to calculate the CFUs. The CFUs are then filtered to
those less than 150 as counts above this number are generally not
accurate.

``` r
CFU_raw_formatted <- tidy_CFU(CFU_data)
#> Warning in mask$eval_all_mutate(quo): NAs introduced by coercion
head(CFU_raw_formatted)
#> # A tibble: 6 x 5
#>   group replicate organ  dilution  CFUs
#>   <dbl> <chr>     <chr>     <dbl> <dbl>
#> 1     2 A         Spleen        0    26
#> 2     2 C         Spleen        0     0
#> 3     3 A         Spleen        0     0
#> 4     3 C         Spleen        0     0
#> 5     4 A         Spleen        0     0
#> 6     4 B         Spleen        0     0

CFU_raw_formatted %>%
  calculate_cfu(dilution_factor = 5, 
                            resuspend_volume_ml = 0.5, 
                            volume_plated_uL = 100, 
                            percent = 0.5, "dilution", "CFUs")
#> # A tibble: 181 x 8
#>    group replicate organ  dilution  CFUs calculated_CFU whole_CFUs log_CFUs
#>    <dbl> <chr>     <chr>     <dbl> <dbl>          <dbl>      <dbl>    <dbl>
#>  1     2 A         Spleen        0    26            130        260     2.41
#>  2     2 C         Spleen        0     0              0          0     0   
#>  3     3 A         Spleen        0     0              0          0     0   
#>  4     3 C         Spleen        0     0              0          0     0   
#>  5     4 A         Spleen        0     0              0          0     0   
#>  6     4 B         Spleen        0     0              0          0     0   
#>  7     4 C         Spleen        0     0              0          0     0   
#>  8     5 A         Spleen        0     0              0          0     0   
#>  9     5 B         Spleen        0     0              0          0     0   
#> 10     5 C         Spleen        0     0              0          0     0   
#> # … with 171 more rows
```

The function `pick_one_dilution` sifts through all of the data for the
groups and finds the CFU observation for each group/replicate/organ that
is closest to 25 CFUs (and therefore, most likely the most accurate
observation). It picks one of the dilution-CFU observations per
grouping.

``` r
CFU_one_dilution <- pick_one_dilution(CFU_raw_formatted, "CFUs", c("group", "organ", "replicate"))

head(CFU_one_dilution)
#> # A tibble: 6 x 5
#> # Groups:   group, organ, replicate [6]
#>   group replicate organ  dilution  CFUs
#>   <dbl> <chr>     <chr>     <dbl> <dbl>
#> 1     2 A         Lung          0     0
#> 2     2 B         Lung          0     0
#> 3     2 C         Lung          0     2
#> 4     2 A         Spleen        0    26
#> 5     2 B         Spleen        2    10
#> 6     2 C         Spleen        0     0
```

The `calculate_cfu` function calculates the whole CFUs and log CFUs for
each observation in the data. It takes in experimental parameters such
as the dilution factor used, the volume (in milliliters) used to
resuspend the CFU solution, and the percent of the organ used (if organ
is used, default is 1 so whole organ).

``` r
final_data <- calculate_cfu(CFU_one_dilution, 
                            dilution_factor = 5, 
                            resuspend_volume_ml = 0.5, 
                            volume_plated_uL = 100, 
                            percent = 0.5, "dilution", "CFUs")

head(final_data)
#> # A tibble: 6 x 8
#> # Groups:   group, organ, replicate [6]
#>   group replicate organ  dilution  CFUs calculated_CFU whole_CFUs log_CFUs
#>   <dbl> <chr>     <chr>     <dbl> <dbl>          <dbl>      <dbl>    <dbl>
#> 1     2 A         Lung          0     0              0          0     0   
#> 2     2 B         Lung          0     0              0          0     0   
#> 3     2 C         Lung          0     2             10         20     1.30
#> 4     2 A         Spleen        0    26            130        260     2.41
#> 5     2 B         Spleen        2    10           1250       2500     3.40
#> 6     2 C         Spleen        0     0              0          0     0
```

## Example of full run-through of the data and plotting

This is an example reading in the data from an excel file. The functions
are all run through so that the log CFUs are calculated for each group
and replicate for the spleen. The results can subsequently be plotted.

``` r
# example file for the excel file
example_file_address <- system.file("extdata", "PL_D-21_BCG_CFUs.xlsx", package = "bactcountr")

# all of the functions are used to tidy the data, pick one dilution, and then calculate the log CFUs
analyzed_CFUs <- read_xlsx(example_file_address) %>%
  tidy_CFU() %>%
  pick_one_dilution("CFUs", c("group", "organ", "replicate")) %>%
  filter(organ == "Spleen") %>%
  calculate_cfu(dilution_factor = 5,
                resuspend_volume_ml = 0.5,
                volume_plated_uL = 100,
                percent = .5, "dilution", "CFUs")

# the CFUs can then be plotted
ggplot(analyzed_CFUs, aes(group, log_CFUs, color = group)) +
  geom_beeswarm(groupOnX = TRUE) +
  ggtitle("PL BCG CFUs D-21 Spleen")
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

The average of the groups can then be plotted.

``` r
# calculate the average CFUs per group
avg_data <- analyzed_CFUs %>%
  ungroup() %>%
  select(group, log_CFUs) %>%
  group_by(group) %>%
  mutate(avg_CFUs = mean(log_CFUs)) %>%
  select(group, avg_CFUs) %>%
  unique() %>%
  rename(log_CFUs = avg_CFUs) %>%
  ungroup() %>%
  mutate(group = as.factor(group))

# plot average and individual CFUs
ggplot(analyzed_CFUs, aes(x = as.factor(group), y = log_CFUs)) +
  geom_bar(data = avg_data,  stat = "identity", aes(fill =group)) +
    geom_point(color = "black") +
  xlab("Group") +
  ggtitle("PL BCG D-21 Spleen Average CFUS")
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

## Alternative use without using pick\_one\_dilution

If you want to see the consistancy of the plating across the dilutions,
you can skip the `pick_one_dilution` function and plot the calculated
log\_CFUs for group/replicate against the dilutions.

``` r
analyzed_CFUs_wo_pick_one <- read_xlsx(example_file_address) %>%
  tidy_CFU() %>%
  filter(organ == "Spleen") %>%
  calculate_cfu(5, 0.5, 100, .5, "dilution", "CFUs") %>%
  unite(col = group_replicate, group, replicate, sep = "_")
#> Warning in mask$eval_all_mutate(quo): NAs introduced by coercion

ggplot(analyzed_CFUs_wo_pick_one, aes(dilution, log_CFUs, color = group_replicate)) +
  geom_point() +
  geom_path() +
  ggtitle("PL BCG CFUs D-21 Spleen for all dilutions")
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

## Calculate statistical significance with different dataset

We will use a different dataset here that has real statistical
significance. The data is from the PL Experiment, D21 post-infection
with *Mycobacterium tuberculosis*.

``` r
# example file for the excel file
example_file_address <- system.file("extdata", "PL_D21_Mtb_CFUs.xlsx", package = "bactcountr")

# all of the functions are used to tidy the data, pick one dilution, and then calculate the log CFUs
analyzed_CFUs <- read_xlsx(example_file_address, sheet = "Raw Counts") %>%
  tidy_CFU() %>%
  pick_one_dilution("CFUs", c("group", "organ", "replicate")) %>%
  filter(organ == "Lung") %>%
  calculate_cfu(dilution_factor = 5, 
                resuspend_volume = 0.5,
                volume_plated_uL = 100,
                percent = 1/3, "dilution", "CFUs") %>%
  mutate(group = as.factor(group))

# the CFUs can then be plotted
ggplot(analyzed_CFUs, aes(group, log_CFUs, color = group)) +
  geom_beeswarm(groupOnX = TRUE) +
  ggtitle("PL Mtb CFUs D21 Lung")
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />

Calculate statistical significance with ANOVA and Tukey HSD

``` r
# calculate ANOVA and tukey HSD stat signif
sig2 <- analyzed_CFUs %>%
  ungroup() %>%
  select(group, log_CFUs) %>%
  aov(log_CFUs ~ group, data = .) %>%
  TukeyHSD() %>%
  broom::tidy() %>%
  separate(col = "contrast", c("group1", "group2"), sep = "-") %>%
  filter(adj.p.value < 0.05) %>%
  mutate(adj.p.value   = round(adj.p.value, 3)) 

# calculates where the p-value bar will first show on the plots
ypos <- c(max(max(abs(sig2$conf.low)), max(abs(sig2$conf.high))))

# plot the results
ggscatter(x = "group", y = "log_CFUs", color = "group", data = analyzed_CFUs) +
  stat_pvalue_manual(data = sig2, label = "adj.p.value", 
                     hide.ns = TRUE, y.position = ypos, step.increase = 0.1) +
  ggtitle("PL Mtb CFUs D21 Lung")
```

<img src="man/figures/README-unnamed-chunk-11-1.png" width="100%" />

Test different statistical analyses

``` r
# one-tailed t.test - have to choose a mu value
# have to choose "greater or "less" and a "mu"
t_sig <-analyzed_CFUs %>%
  ungroup() %>%
  t_test(log_CFUs ~ group, mu = 2) %>% #   adjust_pvalue(method = "BH") %>%
  add_significance() %>%
  rstatix::add_xy_position(x = "group")
  
  
ggline(x = "group", y = "log_CFUs", color = "group", alpha = 0.5, 
       data = analyzed_CFUs,
       font.label = list(size = 30, face = "plain")) +
      stat_pvalue_manual(data = t_sig, hide.ns = TRUE) +
    ggtitle(paste("T-test"))
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="100%" />

``` r

# two way anova - can choose additional factors that play a role
```

Different plots

``` r
# line with mean_se
ggline(x = "group", y = "log_CFUs", color = "group", alpha = 0.5, data = analyzed_CFUs,
       font.label = list(size = 30, face = "plain"), add = c("mean_se")) +
  stat_pvalue_manual(data = sig2, label = "adj.p.value", 
                     hide.ns = TRUE, y.position = ypos, step.increase = 0.1) +
  ggtitle("PL Mtb CFUs D21 Lung")
#> geom_path: Each group consists of only one observation. Do you need to adjust
#> the group aesthetic?
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />

``` r

# bar plot
ggbarplot(x = "group", y = "log_CFUs", fill = "group", data = analyzed_CFUs,
       font.label = list(size = 30, face = "plain"), add = c("mean_se")) +
  stat_pvalue_manual(data = sig2, label = "adj.p.value", 
                     hide.ns = TRUE, y.position = ypos, step.increase = 0.1) +
  ggtitle("PL Mtb CFUs D21 Lung")
```

<img src="man/figures/README-unnamed-chunk-13-2.png" width="100%" />

``` r
  
analyzed_CFUs <- analyzed_CFUs %>%
  mutate(group = as.factor(group))

# scatter plot
ggscatter(x = "group", y = "log_CFUs", color = "group", data = analyzed_CFUs) +
  stat_pvalue_manual(data = sig2, label = "adj.p.value", 
                     hide.ns = TRUE, y.position = ypos, step.increase = 0.1) +
  ggtitle("PL Mtb CFUs D21 Lung")
```

<img src="man/figures/README-unnamed-chunk-13-3.png" width="100%" />

## Alternative use calculating average of all CFUs

If you want to see the consistancy of the plating across the dilutions,
you can skip the `pick_one_dilution` function and calcuate the average
CFUs for each group/replicate. Typically this is done by only
calculating CFUs for which there is a count (removing CFU rows that are
either TNTC or 0).

**Note: The way that I’m doing this now doesn’t account for the fact
that if a group/replicate has 0 CFUs across the dataset, it will just be
removed since I’m filtering CFUs \!= 0**

``` r
analyzed_CFUs_wo_pick_one <- read_xlsx(example_file_address) %>%
  tidy_CFU() %>%
  filter(organ == "Spleen") %>%
  calculate_cfu(5, 0.5, 100, .5, "dilution", "CFUs") %>%
  filter(CFUs != 0) %>%
  group_by(group, replicate) %>%
  mutate(average_log_CFUs = mean(log_CFUs)) 
#> Warning in mask$eval_all_mutate(quo): NAs introduced by coercion
```

Group Names

``` r
group <- c(1:10)
route <- c(rep("I.P.", 5), rep("Oral", 5))
drug <- c(rep(c("control", "control", "Drug 1", "Drug 2", "Drug 1 + Drug 2"), 2))

vaccination <- c(rep(c("PBS", rep("BCG", 4)), 2))

group_df <- data.frame(group, route, drug, vaccination)
group_df
#>    group route            drug vaccination
#> 1      1  I.P.         control         PBS
#> 2      2  I.P.         control         BCG
#> 3      3  I.P.          Drug 1         BCG
#> 4      4  I.P.          Drug 2         BCG
#> 5      5  I.P. Drug 1 + Drug 2         BCG
#> 6      6  Oral         control         PBS
#> 7      7  Oral         control         BCG
#> 8      8  Oral          Drug 1         BCG
#> 9      9  Oral          Drug 2         BCG
#> 10    10  Oral Drug 1 + Drug 2         BCG
```
