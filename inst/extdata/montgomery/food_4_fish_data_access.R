# EDI NUMBER
# .996.1

# # Test Upload in staging area
# LOAD IN PACKAGES -------------------------------------------------------------
library(httr)
library(tidyverse)

# List data package names
get_entity_response <- httr::GET(
  url = "https://pasta.lternet.edu/package/name/eml/edi/996/1",
  # config = httr::authenticate(paste('uid=', user_id, ",o=EDI", ',dc=edirepository,dc=org'), password),
  handle = httr::handle("")
)
get_entity_response

# Get/see full package
get_data_package_response <- httr::GET(
  url = "https://pasta.lternet.edu/package/eml/edi/996/1/",
  # config = httr::authenticate(paste('uid=', user_id, ",o=EDI", ',dc=edirepository,dc=org'), password),
  handle = httr::handle("")
)
get_data_package_response

# Get a specifc data entity
caged_fish_response <- httr::GET(
  url = "https://pasta.lternet.edu/package/data/eml/edi/996/1/a662de31341bc78b29ebf51216ebff75",
  # config = httr::authenticate(paste('uid=', user_id, ",o=EDI", ',dc=edirepository,dc=org'), password),
  handle = httr::handle("")
)
caged_fish_response

zoops_response <- httr::GET(
  url = "https://pasta.lternet.edu/package/data/eml/edi/996/1/0971a1156f2568800cc5f8b87ab28040",
  # config = httr::authenticate(paste('uid=', user_id, ",o=EDI", ',dc=edirepository,dc=org'), password),
  handle = httr::handle("")
)
zoops_response

location_lookup_response <- httr::GET(
  url = "https://pasta.lternet.edu/package/data/eml/edi/996/1/e3469060640918747d763fd677260d8c",
  # config = httr::authenticate(paste('uid=', user_id, ",o=EDI", ',dc=edirepository,dc=org'), password),
  handle = httr::handle("")
)
location_lookup_response

caged_fish <- httr::content(caged_fish_response)
zoops_table <- httr::content(zoops_response) %>% janitor::clean_names()
location_lookup <- httr::content(location_lookup_response)


# source updated montgomery data ------------------------------------------

# Get 2022 data
# edi.996.2

zoops_response2 <- httr::GET(
  url = "https://pasta.lternet.edu/package/data/eml/edi/996/2/ab7607eaec46a3c4fc683896b1319960",
  # config = httr::authenticate(paste('uid=', user_id, ",o=EDI", ',dc=edirepository,dc=org'), password),
  handle = httr::handle("")
)
zoops_response2

zoops_table2 <- httr::content(zoops_response) %>% janitor::clean_names() %>% glimpse

montgomery_prey_data <- bind_rows(zoops_table, zoops_table2)

location_lookup_response2 <- httr::GET(
  url = "https://pasta.lternet.edu/package/data/eml/edi/996/2/552af228cbd6a24d7b152a60bc53c0dd",
  # config = httr::authenticate(paste('uid=', user_id, ",o=EDI", ',dc=edirepository,dc=org'), password),
  handle = httr::handle("")
)
location_lookup_response2
location_lookup2 <- httr::content(location_lookup_response2)


montgomery_locations <- bind_rows(location_lookup, location_lookup2)

rm(caged_fish_response, get_data_package_response, get_entity_response, location_lookup_response, zoops_response,
   zoops_response2, location_lookup_response2, location_lookup, location_lookup2, zoops_table, zoops_table2)

