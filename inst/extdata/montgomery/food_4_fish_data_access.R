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

caged_fish <- httr::content(caged_fish_response) %>% glimpse
zoops_table <- httr::content(zoops_response) %>% janitor::clean_names() %>% glimpse
location_lookup <- httr::content(location_lookup_response) %>% glimpse

rm(caged_fish_response, get_data_package_response, get_entity_response, location_lookup_response, zoops_response)
