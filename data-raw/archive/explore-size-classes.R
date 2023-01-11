library(tidyverse)
library(readr)
library(jsonlite)

# Delta Science programs 
#  https://deltacouncil.ca.gov/pdf/science-program/2020-11-09-iep-93-zooplankton-integrated-dataset-metadata.pdf


# microzooplankton (less than 0.2 mm)
# mesozooplankton (0.2–20 mm in length) 
# macrozooplankton (longer than 20 mm)

distinct_prey <- read_csv("data-raw/all_species_and_lifestage.csv") %>% 
  select(-X1) %>%
  distinct()

distinct_prey %>% View

here(
)
