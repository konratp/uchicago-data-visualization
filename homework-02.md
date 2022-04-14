Homework 02
================
INSERT YOUR NAME HERE

``` r
library(tidyverse)
library(fs)
# add any other packages you use here
```

1.  **A new day, a new plot, a new geom.**

2.  **Key lyme pie.**

3.  **Foreign Connected PACs.**

``` r
# get a list of files with "Foreign Connected PAC" in their names
list_of_files <- dir_ls(path = "data", regexp = "Foreign Connected PAC")

# read all files and row bind them
# keeping track of the file name in a new column called year
pac <- read_csv(list_of_files, id = "year")
```

    ## Rows: 2184 Columns: 6
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (5): PAC Name (Affiliate), Country of Origin/Parent Company, Total, Dems...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

4.  **Hop on.**
