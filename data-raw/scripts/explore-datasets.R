library(tidyverse)
library(dplyr)
library(readxl)
library(lubridate)


# Sutter Bypass Data Cordoleani ------------------------------------------------
### FISH GROWTH
fish_growth_data_2019 <- read_csv("data-raw/Cordoleani et al Sutter Bypass CVPIA 2020 2021/DailyCageFish_data_2019.csv")
fish_growth_data_2019
fish_growth_data_2020 <- read_csv("data-raw/Cordoleani et al Sutter Bypass CVPIA 2020 2021/DailyCageFish_data_2020.csv")
fish_growth_data_2020

total_fish_growth <- bind_rows(fish_growth_data_2019, fish_growth_data_2020)%>% glimpse()

table(total_fish_growth$cage_id)
table(total_fish_growth$Region)
table(total_fish_growth$Type)

### Three mass columns (mass, mass_interp, mass_fill). Need to understand what the differnt masses mean, 
### how do they interp mass when there are no values. What are the units? 
# Mass appears to be between 0 and 9
hist(total_fish_growth$mass)

# 91% of mass column is NA 
sum(is.na(total_fish_growth$mass))/nrow(total_fish_growth)

# Mass inteperate also appears to be between 0 and 9
hist(total_fish_growth$mass_interp)

sum(is.na(total_fish_growth$mass_interp))/nrow(total_fish_growth) # 0 NA 

# Mass fill also appears to be between 0 and 9
hist(total_fish_growth$mass_fill)

sum(is.na(total_fish_growth$mass_fill))/nrow(total_fish_growth) # 0 NA 

## Fish cage data from Cordoleani
prey_data_2019 <- read_csv("data-raw/Cordoleani et al Sutter Bypass CVPIA 2020 2021/DailyZoopTemp_data_2019.csv")
prey_data_2019 %>% glimpse
prey_data_2020 <- read_csv("data-raw/Cordoleani et al Sutter Bypass CVPIA 2020 2021/DailyZoopTemp_data_2020.csv") %>%  
  mutate(Date = lubridate::as_date(Date, format = "%d/%m/%y"))

total_prey <- bind_rows(prey_data_2019, prey_data_2020) %>% glimpse()


hist(total_prey$totprey_density)
hist(total_prey$totprey_density_interp)
hist(total_prey$totprey_density_fill)

hist(total_prey$mean_temperature)
hist(total_prey$min_temperature)
hist(total_prey$max_temperature)

table(total_prey$Report_type)
table(total_prey$cage_id)
table(total_prey$Region)
table(total_prey$Type)

# combine prey and fish datasets
# tot_prey_and_fish <- merge(total_prey, total_fish_growth, by = c("cage_id", 'Date', 'Region', 'Type'))
# names(tot_prey_and_fish)

#complete
cordoleani_zoop <- total_prey %>% 
  select(cage_id:totprey_density,totcladocera_density, totpulex_density, mean_temperature, Report_type) %>% 
  mutate(habitat_type = ifelse(is.na(total_prey$Type), total_prey$Report_type, total_prey$Type)) %>%
  rename(prey_density = totprey_density, # organisms/m^3 per Sutter 2020 report 
         location = Region,
         sample_id = cage_id) %>%
  filter(!is.na(prey_density)) %>%
  mutate(Author = 'Cordoleani') %>%
  select(-Type, -Report_type, -mean_temperature) %>%
  #filter(prey_density > 0) %>%
  glimpse()
#save(cordoleani_zoop, file = "data-raw/data_clean_draft/cordoleani_zoop.RData")

# extra temp 
cordoleani_temp <- total_prey %>%
  select(Date, Region, cage_id, mean_temperature) %>% 
  rename(location = Region,
         sample_id = cage_id) %>%
  glimpse() 
save(cordoleani_temp, file = "data-raw/data_clean_draft/cordoleani_temp.RData")

#sporadic temperature 
ggplot(data = cordoleani_temp, aes(x = Date, y = mean_temperature)) +
  geom_line() +
  facet_wrap(~location+sample_id)

# select columns we want and change names
#complete
cordoleani_fish <- total_fish_growth %>% 
  select(fish_id:mass) %>% 
  rename(habitat_type = Type, 
         location = Region,
         sample_id = cage_id) %>%
  filter(!is.na(mass)) %>%
  mutate(Author = 'Cordoleani') %>% glimpse()
#save(cordoleani_fish, file = "data/data_clean/cordoleani_fish.RData")


## Merced River data from Steve Zeug -------------------------------------------

### FISH ABUNDANCE
salmon_abundance <- read_excel("data-raw/merced-steve-zeug/April 09_Merced_salmon abundance.xlsx") %>% glimpse()
readxl::excel_sheets("data-raw/merced-steve-zeug/April 09_Merced_salmon abundance.xlsx") # "Sheet3" Is blank 

# invert_data 
### INVERTABRATE
# Added new tab where I simplified species name (Only took the first species name) 
raw_df <- read_excel("data-raw/merced-steve-zeug/Merced invert data_environment.xls", .name_repair = 'minimal', sheet = "erin_modified",  col_names = FALSE)

dates <- janitor::excel_numeric_to_date(as.numeric(raw_df[1,3:ncol(raw_df)]), date_system = 'mac pre-2011') %>% as.character()
sites <- raw_df[2, 3:ncol(raw_df)]

col_names <- append(
  c('Species', 'Measurement'),
  paste(dates, sites, sep = '__')
)

names(raw_df) <- col_names

reformated_invert <- raw_df[3:nrow(raw_df),] %>%
  fill(Species, .direction = 'down') %>% #TODO make sure species is accurate(looks like fill is tricky with xlsx format)
  filter(Measurement == 'No. m-2 (subsam)') %>% # is this the value we want for prey density??
  pivot_longer(cols = !c('Species', 'Measurement'), names_to = "date__site") %>%
  separate(col = date__site, into = c('date', 'site'), sep = '__') %>%
  rename(prey_density = value, #TODO: what is this unit, No. m-2 (subsam) ??
         Date = date, 
         sample_id = site, 
         species = Species) %>%
  mutate(Author = 'merced-steve-zeug',
         size_class = ifelse(grepl('Adult', species), 'Adult', 
                             ifelse(grepl('Larvae', species), 'Larvae',
                                    ifelse(grepl('Pupae', species), 'Pupae',
                                           ifelse(grepl('Nymph', species), 'Nymph', NA)))),
         gear_type = ifelse(grepl('Drift', sample_id), 'Drift', 
                            ifelse(grepl('Benthic', sample_id), 'Benthic', NA))) %>%
  mutate(tmp_name = gsub('Drift', '', sample_id), # extract sample_id 
         name = stringr::str_split(tmp_name, " ") %>% map_chr(., 1),
         sample_id = ifelse(name == '', tmp_name, name )) %>% 
  select(-c(tmp_name, name)) %>%
  mutate(sample_id = gdata::trim(sample_id)) %>% glimpse()

#complete-ish
# merced_steve_zeug_zoop <- reformated_invert %>%
#   group_by(sample_id, Date, gear_type) %>% # add method here
#   summarize(prey_density_total = sum(as.numeric(prey_density), na.rm = TRUE)) %>%
#   left_join(reformated_invert, by = c('sample_id', 'Date', 'gear_type')) %>% glimpse()
#save(merced_steve_zeug_zoop, file = 'data/data_clean/mereced_steve_zeug_zoop.RData')

### GUT CONTENTS
raw_salmon <- read_excel("data-raw/merced-steve-zeug/salmon data_final(Josie).xlsx", skip = 2) %>% glimpse()

table(raw_salmon$Location)
hist(raw_salmon[raw_salmon$`Length of Fish (cm)` < 70, ]$`Length of Fish (cm)`)
hist(raw_salmon$`Weight of fish (g)`) # Weight of fish has a much more even distribution than length (check this out)
# MR: I think there might be and error with a single value of 70 cm. We might want to remove, 
#as seen in the updated above histogram.

merced_steve_zeug_fish <- raw_salmon %>%
  filter(`Length of Fish (cm)` < 70) %>% # removes outlier
  rename(fish_id = `fish #`,
         sample_id = Location,
         fork_length = `Length of Fish (cm)`,
         mass = `Weight of fish (g)`) %>% glimpse()
  select(-c(`Otolith code`:`Tin Weight (combusted weight)`)) %>%
  gather(!c('fish_id', 'sample_id', 'fork_length', 'mass'), key = species, value = value )%>%
  mutate(Author = 'merced-steve-zeug',
         size_class = ifelse(grepl('adult', species), 'Adult', 
                             ifelse(grepl('larva', species), 'Larvae',
                                    ifelse(grepl('pupa', species), 'Pupae',
                                           ifelse(grepl('nymph', species), 'Nymph', NA)))),
         value = as.numeric(value)) %>% 
  rename(count = value) %>%
  glimpse()
#save(merced_steve_zeug_fish, file = 'data/data_clean/merced_steve_zeug_fish.RData')

# TODO: unsure how to interpret tin weight metrics
# TODO for all prey datasets we are going to need to figure out what level we want taxonomic classification for 

### TEMPERATURE
raw_temps <- read_excel("data-raw/merced-steve-zeug/Temperature.xlsx", sheet = "Sheet1", range = "A1:U212") %>% 
  mutate(date = as.Date(`date/time`)) %>%
  select(-difference, -`date/time`) %>%
  glimpse()

merced_steve_zeug_temp <- raw_temps %>% 
  pivot_longer(cols = `23 max`:`BW mean`) %>% 
  separate(name, into = c("site", "measurement"), sep = " ") %>%
  rename(temperature = value,
         sample_id = site, 
         month = Month,
         Date = date) %>%
  mutate(Author = 'merced-steve-zeug') %>%
  glimpse() 
#save(merced_steve_zeug_temp, file = 'data/data_clean/merced_steve_zeug_temp.RData')

merced_steve_zeug_temp %>% ggplot() + 
  geom_line(aes(x = date, y = temperature)) + 
  facet_wrap(~sample_id)

## San Joaquin River data from Steve Zeug --------------------------------------

## Zooplankton data
# raw_zoops <- read_excel("data-raw/san-joaquin-steve-zeug/summary_zooplankton_10_19_17.xlsx", sheet = "RA52016", range = "A1:K56") %>% 
#   glimpse()

# TODO figure out what the relative abundance is referring to 
# MR: looks like it's TotalTaxByReach/CountbyReachPerWeek


raw_zoops <- read_excel("data-raw/san-joaquin-steve-zeug/summary_zooplankton_10_19_17.xlsx", sheet = "CountLiter2016", 
                        range = "A1:H56") %>% 
  glimpse()
# TODO: fix to tab CountLiter2016; count per volume column = total prey/l; fix units to m^3

merced_sanJoaquin_zoops <- raw_zoops %>%
  rename(sample_id = Reach, 
         species = TaxGrp_1,
         count = TotalTaxbyReach,
         prey_density = CountperVolume) %>%# currently total prey/l
  select(sample_id, species, count, prey_density, Year, Week) %>% 
  mutate(prey_density = prey_density/0.001) %>% # 1 L = 0.001 m^3
  glimpse()
#save(merced_sanJoaquin_zoops, file = 'data/data_clean/merced_sanJoaquin_zoops.RData')
# merced_sj_zoops <- raw_zoops %>%
#   select(-`...2`) %>%
#   rename(timeframe = `...1`,
#          totprey_density  = `Prey abundance`,
#          temperature = temp)


# Stanislaus data from Jason Guignard ------------------------------------------

# stanislaus_prey_data <- read_excel("data-raw/stanislaus-jason-guignard/Honolulu Bar data.xlsx") %>% 
#   mutate(Date = as.Date(Date),
#          `Flow (mean of 2)` = as.numeric(`Flow (mean of 2)`)) %>%
#   glimpse()
# 
# hist(stanislaus_prey_data$`Flow (mean of 2)`)
# hist(stanislaus_prey_data$Count)
# table(stanislaus_prey_data$Order)
# table(stanislaus_prey_data$Family)

stanislaus_zoop_raw <- read_excel("data-raw/stanislaus-jason-guignard/Honolulu Bar data.xlsx", 
                                   sheet = 'Density by location, date,ta_MR') %>%
  glimpse()

stanislaus_zoop <- stanislaus_zoop_raw %>%
  rename(location = Location,
         prey_density = `Total  Drift Density`,# needs to be changed from cubic feet to m^3
         other_taxa = `Other Taxa`) %>%
  mutate(prey_density = prey_density/0.0283168) %>%  #1ft^3 = 0.0283168 m^3       
  gather(!c('location', 'prey_density', 'Date'), key = species, value = value )%>%
  mutate(Author = 'stanislaus-jason-guignard') %>%
  rename(prey_density_by_species = value) %>%
  glimpse()
#save(stanislaus_zoop, file = 'data/data_clean/stanislaus_zoop.Rdata')

stanislaus_temp_data_raw <- read_excel("data-raw/stanislaus-jason-guignard/Honolulu Bar data.xlsx", 
                                   sheet = 'FlowTemp') %>%
  glimpse()

stanislaus_temp_data <- stanislaus_temp_data_raw %>%
  rename(temperature_F = `Temp F`, #TODO: convert to celsius
         flow_cfs = `Flow cfs`) %>%
  mutate(Time = lubridate::as_date(Time),
         temperature = temperature_F/32,
         Author = 'stanislaus-jason-guignard') %>% 
  select(-temperature_F) %>%
  glimpse()
#save(stanislaus_temp_data, file = 'data/data_clean/stanislaus_temp.RData')

ggplot(stanislaus_temp_data) + 
  geom_line(aes(x = Time, y = temperature)) 

ggplot(stanislaus_temp_data) + 
  geom_line(aes(x = Time, y = flow_cfs))

# Corline  ---------------------------------------------------------------------
corline_raw_zoop <- read_excel("data-raw/corline/Zoop2013_2016.xlsx") %>%
  glimpse()

corline_zoop <- corline_raw_zoop %>%
  rename(location = Location, 
         gear_type = Method, 
         life_stage = `Life Stage`) %>%
  mutate(prey_density = Count/(`Volume subsampled (ml)`*1e-6)) %>% #convert ml to m^3 and calculate prey density 
  select(-c(Throws:`Volume subsampled (ml)`), -Count, -c(Phylum:Genus)) %>%
  rename(sample_id = Field, 
         species = Species) %>%
  mutate(Author = "Corline") %>%
  glimpse()
#save(corline_zoop, file = 'data-raw/data_clean_draft/corline_zoop.RData')

hist(corline_zoop$prey_density)


# Fish Food on Floodplain Farm Fields 2019; Montgomery, Jacob (California Trout)------------------------------------------------------------------------------
# metadata: https://portal.edirepository.org/nis/metadataviewer?packageid=edi.996.1

source('data-raw/food_4_fish_data_access.R')
zoops_table %>% glimpse()

# count of zooplankton species standardized to one cubic meter of water sampled	

montgomery_zoop <- zoops_table %>%
  separate(id, c('location', 'Date'), '_') %>% 
  mutate(Date = mdy(Date)) %>% 
  gather(!c('location', 'Date', 'date':'volume_sampled'), key = species, value = value) %>%
  separate(species, c('species', 'size_class'), '_') %>%
  select(-c(date, location, ec_s_cm:do_sat, p_h:volume_sampled)) %>%
  rename(temperature = temp_c,
         prey_density = value) %>%
  mutate(Author = "Montgomery") %>%
  glimpse()

# extract out temperature, do
montgomery_temp <- montgomery_zoop %>%
  select(Date, time, temperature, do_mg_l, Author) %>%
  glimpse()
#save(montgomery_temp, file = 'data-raw/data_clean_draft/montgomery_temp.RData')

# extract out relevant zoop data and filter to relevant prey_density 
montgomery_zoop <- montgomery_zoop %>%
  select(Date, time, species:Author) %>%
  filter(prey_density > 0) %>%
  glimpse()
#save(montgomery_zoop, file = 'data-raw/data_clean_draft/montgomery_zoop.RData')


# TODO: should likely add value by sample_id and size class (or species)

caged_fish %>% glimpse()

montgomery_fish <- caged_fish %>%
  rename(location_id = LOCATION, 
         fish_id = PIT, 
         fork_length = Length.mm,
         mass = Weight.g) %>%
  mutate(Date = mdy(Date),
         Author = "Montgomery") %>%
  glimpse()
#save(montgomery_fish, file = 'data/data_clean/montgomery_fish.RData')

#----------
# Author, Species, Lifestage
cordoleani <- data.frame('Author' = c('Cordoleani', 'Cordoleani'),
                         'species' = c('cladocera', 'pulex'),
                         'life_stage' = c(NA, NA))
corline <- corline_zoop %>% select(Author, life_stage, species)
merced_sanjoaquin <- merced_sanJoaquin_zoops  %>% select(species) %>% mutate(Author = 'merced_sanjoaquin')
merced_steve_zeug <- merced_steve_zeug_zoop %>% ungroup %>% select(Author, species, size_class) %>% rename(life_stage = size_class)
montgomery <- montgomery_zoop %>% select(Author, species, size_class) %>% rename(life_stage = size_class)
stanislaus <- stanislaus_zoop %>% select(Author, species)

all <- bind_rows(cordoleani, corline, merced_sanjoaquin, merced_steve_zeug, montgomery, stanislaus)
#write.csv(all, 'data-raw/all_species_and_lifestage.csv')
