
<!-- README.md is generated from README.Rmd. Please edit that file -->

# DSMprey

<img src="man/figures/cvpia_logo.jpg" align="right" width="40%"/>

### Aggregated prey density across multiple watersheds

*This package is for sourcing prey density across multiple watersheds
and habitat types. Also included in this package are fish mass and and
fork length data as well as associated environmental (temperature and
dissolved oxygen) data.*

#### Installation

``` r
# install.packages("remotes")
remotes::install_github("CVPIA-OSC/DSMprey")
```

#### Usage

This package includes aggregated prey density data from participating
authors.

``` r
# datasets within the package
data(package = 'DSMprey')
```

#### About the Datasets

Datasets were aggregated from multiple authors and across many
watersheds. For each dataset, the habitat type was assigned. Specific
methods and supporting documents for data aggregation and decisions in
every watershed are provided on the reference tab.

##### Prey Density Datasets

-   `all_prey_density`

-   `monthly_prey_density`

##### Fish Datasets:

-   `all_fish_data`

-   `monthly_fish_data`

##### Environmental Datasets:

-   `all_enviro_data`

#### Joining Datasets

Datasets can be joined on `site`, see example below:

``` r
library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
#> ✔ ggplot2 3.3.5     ✔ purrr   0.3.4
#> ✔ tibble  3.1.6     ✔ dplyr   1.0.8
#> ✔ tidyr   1.2.0     ✔ stringr 1.4.0
#> ✔ readr   2.1.2     ✔ forcats 0.5.1
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()


## All data: 
all_prey <- DSMprey::all_prey_density 
all_fish <- DSMprey::all_fish_data
all_enviro <- DSMprey::all_enviro_data 

# all prey density and fork length/mass data
all_prey_and_fish <- all_prey %>% left_join(all_fish) 
#> Joining, by = c("site", "habitat_type", "date", "author", "watershed")

# join environmental data with prey density:
all_prey_and_enviro <- all_prey %>% left_join(all_enviro) 
#> Joining, by = c("site", "habitat_type", "date", "author", "watershed")

## Monthly Data:
monthly_prey <- DSMprey::monthly_prey_density
monthly_fish <- DSMprey::monthly_fish_data

monthly_prey_and_fish <- monthly_prey %>% left_join(monthly_fish) 
#> Joining, by = c("watershed", "habitat_type", "year", "month")
```

