path <- system.file("extdata", 'guignard', "Honolulu Bar data.xlsx", package = "preyDataProcessing")
stanislaus_zoop_raw <- readxl::read_excel(path, sheet = 'Density by location, date,ta_MR')


path <- system.file("extdata", 'guignard', "Honolulu Bar data_05062022.xlsx", package = "preyDataProcessing")
stanislaus_zoop_raw_2 <- readxl::read_excel(path, sheet = 'Raw_data')


stanislaus_zoop_2 <- stanislaus_zoop_raw_2 %>%
  janitor::clean_names() %>%
  rename(site = location,
         species = order) %>%
  group_by(species, site, date, volume_sampled) %>%
  summarise(sum_count = sum(count, na.rm = TRUE)) %>%
  mutate(prey_density = sum_count/volume_sampled/28.3168,
         species = tolower(species),
         watershed = 'Stanislaus',
         author = 'Guignard_updated',
         gear_type = "net throw",
         mesh_size = 335,
         size_class = "meso/macro")
# %>%
#   mutate(site = case_when("B+M Side Channel" ~ "Top Side",
#                           "Lower Flood Plain" ~ 'Lower Flood Plain',
#                           "Lower Side Channel /B+M" ~ "Top Side",
#                           'Main Channel above Side Channel'))


stanislaus_zoop <- stanislaus_zoop_raw %>%
  rename(location = Location,
         prey_density_total = `Total  Drift Density`,# units are cubic feet
         other_taxa = `Other Taxa`) %>%
  mutate(prey_density_total = prey_density_total/28.3168) %>%  #1ft^3 = 28.3168 Liters  # this is the sum of all species
  gather(!c('location', 'prey_density_total', 'Date'), key = species, value = value )%>%
  mutate(author = 'Guignard',
         watershed = 'Stanislaus',
         species = tolower(species)) %>%
  rename(prey_density = value,
         date = Date) %>%
  mutate(prey_density = prey_density/0.0283168,
         site = location,
         gear_type = "net throw",
         mesh_size = 335,
         size_class = "meso/macro") %>% # size class is 335 micrometer mesh.
  select(-prey_density_total, -location)


# locations integration  --------------------------------------------------

path <- system.file("extdata", 'guignard', "drift net sites_to_kml.kml", package = "preyDataProcessing")
locations <- st_read(dsn = path)

# add lat and long columns based on geometry
locations <- locations %>%
  dplyr::mutate(lon = sf::st_coordinates(.)[,1],
                lat = sf::st_coordinates(.)[,2])

# change the names of the locations dataset to match those in in the zoops table
locations[locations$Name == "H Bar Main Channel", 'Name'] <- 'Main Channel'
locations[locations$Name == "Side Channel Upper", 'Name'] <- 'Top Side'
locations[locations$Name == "Side Channel Lower", 'Name'] <- 'Lower Side'
locations[locations$Name == "Floodplain Upper", 'Name'] <- 'Upper Flood Plain'
locations[locations$Name == "Middle Floodplain", 'Name'] <- 'Middle Flood Plain'
locations[locations$Name == "Floodplain Lower", 'Name'] <- 'Lower Flood Plain'

locations <- locations %>%
  mutate(habitat_type = ifelse(Name %in% c('Main Channel'), 'perennial instream',
                               ifelse(Name %in% c('Top Side', 'Lower Side'), 'side channel',
                                      ifelse(Name %in% c('Upper Flood Plain', 'Middle Flood Plain', 'Lower Flood Plain'), 'floodplain', NA)))
  ) %>%
  rename(site = Name)

stanislaus_zoop <- stanislaus_zoop %>% left_join(locations) %>%
  select(-Description)

stanislaus_zoop_2 <- stanislaus_zoop_2 %>% left_join(locations) %>%
  select(-Description)


# bind to prey data -------------------------------------------------------

all_stanislaus <- bind_rows(stanislaus_zoop, stanislaus_zoop_2)

all_prey <- bind_rows(cordoleani_zoop,
                      corline_zoop,
                      zeug_zoop,
                      zooper_prey_data,
                      merced_steve_zeug_zoop,
                      montgomery_zoop,
                      stanislaus_zoop,
                      stanislaus_zoop_2)

ggplot(data = all_prey, aes(x = author, y = prey_density)) +
  geom_boxplot() +
  ylab('log(prey density) count/L') +
  coord_flip() +
  scale_y_continuous(trans='log10')


ggplot(data = all_stanislaus, aes(x = author, y = prey_density)) +
  geom_boxplot() +
  ylab('log(prey density) count/L') +
  coord_flip() +
  scale_y_continuous(trans='log10')

ggplot(data = all_stanislaus, aes(y = prey_density, color = author)) +
  geom_histogram() +
  ylab('log(prey density) count/L') +
  coord_flip() +
  scale_y_continuous(trans='log10')
