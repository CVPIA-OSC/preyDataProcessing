# EDI NUMBER
# .996.2

# # Test Upload in staging area
# LOAD IN PACKAGES -------------------------------------------------------------
library(httr)
library(tidyverse)

# # Get a specifc data entity
caged_fish_response <- httr::GET(
  url = "https://pasta.lternet.edu/package/data/eml/edi/996/1/a662de31341bc78b29ebf51216ebff75",
  # config = httr::authenticate(paste('uid=', user_id, ",o=EDI", ',dc=edirepository,dc=org'), password),
  handle = httr::handle("")
)
caged_fish_response


caged_fish <- httr::content(caged_fish_response)

zoops_response <- httr::GET(
  url = "https://pasta.lternet.edu/package/data/eml/edi/996/2/ab7607eaec46a3c4fc683896b1319960",
  # config = httr::authenticate(paste('uid=', user_id, ",o=EDI", ',dc=edirepository,dc=org'), password),
  handle = httr::handle("")
)
zoops_response

montgomery_prey_data <- httr::content(zoops_response) %>% janitor::clean_names()

location_lookup_response <- httr::GET(
  url = "https://pasta.lternet.edu/package/data/eml/edi/996/2/552af228cbd6a24d7b152a60bc53c0dd",
  # config = httr::authenticate(paste('uid=', user_id, ",o=EDI", ',dc=edirepository,dc=org'), password),
  handle = httr::handle("")
)
location_lookup_response
location_lookup <- httr::content(location_lookup_response)


montgomery_locations <- location_lookup


