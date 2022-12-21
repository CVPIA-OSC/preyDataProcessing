
<!-- README.md is generated from README.Rmd. Please edit that file -->

# preyDataProcessing

<img src="man/figures/cvpia_logo.jpg" align="right" width="40%"/>

### Aggregated prey density across multiple watersheds

*This package is for sourcing prey density across multiple watersheds
and habitat types. Also included in this package are fish mass and and
fork length data as well as associated environmental (temperature and
dissolved oxygen) data. Data can be used as inputs into bioenergetic
models.*

#### Installation

``` r
# install.packages("remotes")
remotes::install_github("CVPIA-OSC/preyDataProcessing")
```

#### Usage

This package includes aggregated prey density data from participating
authors.

``` r
# datasets within the package
data(package = 'preyDataProcessing')
```

#### About the Datasets

Datasets were aggregated from multiple authors and across many
watersheds. For each dataset, the habitat type was assigned. Specific
methods and supporting documents for data aggregation and decisions in
every watershed are provided by author:

- [Montgomery](https://github.com/CVPIA-OSC/preyDataProcessing/blob/for_review/data-raw/standard_format_markdowns/montgomery_data.md)
- [Corline](https://github.com/CVPIA-OSC/preyDataProcessing/blob/for_review/data-raw/standard_format_markdowns/corline_data.md)
- [Zeug](https://github.com/CVPIA-OSC/preyDataProcessing/blob/for_review/data-raw/standard_format_markdowns/zeug_data.md)
  - San Joaquin River
  - Merced River
- [Cordoleani](https://github.com/CVPIA-OSC/preyDataProcessing/blob/for_review/data-raw/standard_format_markdowns/cordoleani_data.md)
- [Guignard](https://github.com/CVPIA-OSC/preyDataProcessing/blob/for_review/data-raw/standard_format_markdowns/guignard_data.md)
- [Zooper R
  Library](https://github.com/CVPIA-OSC/preyDataProcessing/blob/for_review/data-raw/standard_format_markdowns/zooper_data.md)

Information regarding compiled datasets is located here:

- [prey density data
  aggregation](https://github.com/CVPIA-OSC/preyDataProcessing/blob/for_review/data-raw/standard_format_markdowns/combine_data_and_eda.md)

- [habitat type definition and
  methodology](https://github.com/CVPIA-OSC/preyDataProcessing/blob/for_review/data-raw/standard_format_markdowns/habitat_type_eda.html)

  - Note: must download HTML file and open in browser

- [size class
  methodology](https://github.com/CVPIA-OSC/preyDataProcessing/blob/for_review/data-raw/standard_format_markdowns/size_class_methodolgy.md)

##### Prey Density Datasets

- `all_prey_density`

- `monthly_prey_density`

##### Fish Datasets:

- `all_fish_data`

- `monthly_fish_data`

##### Environmental Datasets:

- `all_enviro_data`

#### Joining Datasets

Datasets can be joined on `site`, see example below:

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.0      ✔ purrr   0.3.5 
    ## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
    ## ✔ tidyr   1.2.1      ✔ stringr 1.5.0 
    ## ✔ readr   2.1.3      ✔ forcats 0.5.2 
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
## All data: 
all_prey <- preyDataProcessing::all_prey_density 
all_fish <- preyDataProcessing::all_fish_data
all_enviro <- preyDataProcessing::all_enviro_data 

# all prey density and fork length/mass data
all_prey_and_fish <- all_prey %>% left_join(all_fish) 
```

    ## Joining, by = c("habitat_type", "date", "author", "watershed", "site")

``` r
# join environmental data with prey density:
all_prey_and_enviro <- all_prey %>% left_join(all_enviro) 
```

    ## Joining, by = c("habitat_type", "date", "author", "watershed", "site")

``` r
## Monthly Data:
monthly_prey <- preyDataProcessing::monthly_prey_density
monthly_fish <- preyDataProcessing::monthly_fish_data

monthly_prey_and_fish <- monthly_prey %>% left_join(monthly_fish) 
```

    ## Joining, by = c("watershed", "habitat_type", "year", "month")

### Dependencies

The `preyDataProcessing` data package provides data bioenergetic
modeling within the [CVPIA Open Science
Collaborative](https://github.com/CVPIA-OSC).
