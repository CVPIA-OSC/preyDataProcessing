library(tidyverse)
library(leaflet)
library(leaflet.esri)
library(sf)

# data formatting and exploration for R package

load('data/all_prey_density.rda')

# all_prey_density <- all_prey_density %>% select(-geometry)

# usethis::use_data(all_prey_density, overwrite = T)

# monthly aggregation by watershed,  habitat type -------------------------
## group by watershed, habitat type, year, month - summarize prey density (median, min, max)
monthly_prey_density <- all_prey_density %>%
  mutate(year = ifelse(!is.na(date), lubridate::year(date), 2016),
         month = lubridate::month(date)) %>%
  group_by(watershed, habitat_type, year, month) %>%
  summarise_at(vars(prey_density), .funs = c('min', 'max', 'median', 'var'), na.rm = TRUE) %>%
  ungroup() %>%
  rename(min_prey_density = min,
         max_prey_density = max,
         median_prey_density = median,
         var_prey_density = var)

# save file for use in R package
# usethis::use_data(monthly_prey_density)


# aggregation for fish data -----------------------------------------------
load('data/all_fish_data.rda')

#all_fish_data <- all_fish_data %>% select(-lat, -lon)
#usethis::use_data(all_fish_data, overwrite = TRUE)

monthly_fish_data <- all_fish_data %>%
  mutate(year = ifelse(!is.na(date), lubridate::year(date), 2016),
         month = lubridate::month(date)) %>%
  mutate(habitat_type = case_when(watershed == "Merced" ~ "perennial instream",
                                  watershed != "Merced" ~ habitat_type)) %>%
  group_by(watershed, habitat_type, year, month) %>%
  summarise_at(vars(mass, fork_length), .funs = c('min', 'max', 'median'), na.rm = TRUE) %>%
  ungroup()

# save file for use in R package
# usethis::use_data(monthly_fish_data)


# aggregation of environmental data ---------------------------------------

load('data/all_enviro_data.rda')

#all_enviro_data <- all_enviro_data %>% mutate(date = as_date(date)) %>% select(-lat, -lon)

# usethis::use_data(all_enviro_data, overwrite = T)

monthly_enviro_data <- all_enviro_data %>%
  mutate(year = ifelse(!is.na(date), lubridate::year(date), 2016),
         month = lubridate::month(date)) %>%
  mutate(habitat_type = case_when(watershed == "Merced" ~ "perennial instream",
                                  grepl("zoop", all_enviro_data$author) ~ "floodplain",
                                  watershed != "Merced" ~ habitat_type)) %>%
  group_by(watershed, habitat_type, year, month) %>%
  summarise_at(vars(do_mg_l, temperature), .funs = c('min', 'max', 'median'), na.rm = TRUE) %>%
  ungroup()

is.na(monthly_enviro_data) <- do.call(cbind,lapply(monthly_enviro_data, is.infinite))

#TODO: need to  map zooper library to watersehds as is done in the prey_density

# data exploration --------------------------------------------------------

per_in <- all_prey_density %>%
  filter(habitat_type == "perennial instream") %>%
  mutate(year = ifelse(!is.na(date), lubridate::year(date), 2016),
         month = lubridate::month(date)) %>%
  group_by(watershed, habitat_type, year, month, author) %>%
  summarise_at(vars(prey_density), .funs = c('min', 'max', 'median', 'var'), na.rm = TRUE) %>% ungroup()

ggplot() +
  geom_boxplot(data = per_in, aes(x = as.factor(month), y = median), alpha = 0.5) +
  geom_jitter(data = per_in, aes(x = as.factor(month), y = median, color = watershed)) +
  scale_y_continuous(trans='log10') +
  ylab('log(median prey density)') +
  scale_color_brewer(palette = 'Dark2')+
  coord_flip()

ggplot() +
  geom_boxplot(data = monthly_prey_density, aes(x = as.factor(month), y = median_prey_density), alpha = 0.5) +
  geom_jitter(data = monthly_prey_density, aes(x = as.factor(month), y = median_prey_density, color = watershed)) +
  scale_y_continuous(trans='log10') +
  ylab('log(median prey density)') +
  facet_wrap(~watershed)+
  #scale_color_brewer(palette = 'Dark2')+
  coord_flip()

ggplot() +
  geom_boxplot(data = monthly_prey_density, aes(x = as.factor(month), y = median_prey_density), alpha = 0.5) +
  geom_jitter(data = monthly_prey_density, aes(x = as.factor(month), y = median_prey_density, color = habitat_type)) +
  scale_y_continuous(trans='log10') +
  xlab('month') +
  ylab('log(median prey density)')+
  scale_color_brewer(palette = 'Dark2')+
  coord_flip() +
  theme_minimal()



# summary table by author -------------------------------------------------
prey_agg_by_author <- all_prey_density %>%
  group_by(author) %>%
  summarise_at(vars(prey_density), .funs = c('min', 'max', 'median', 'var'), na.rm = TRUE)



# leaflet map of sites ----------------------------------------------------
all_prey <- preyDataProcessing::all_prey_density
all_prey_for_map <- all_prey %>%
  select(habitat_type, lat, lon, watershed, author) %>%
  distinct() %>%
  filter(!is.na(lat))
all_prey_for_map <- st_as_sf(all_prey_for_map, coords = c('lon', 'lat'))

leaflet(all_prey_for_map) %>%
  addEsriBasemapLayer(esriBasemapLayers$Imagery,
                      autoLabels=TRUE, group = 'Esri Basemap') %>%
  addMarkers(popup = ~paste0(all_prey_for_map$author, ' - ', all_prey_for_map$habitat_type ))
