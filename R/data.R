#' Aggregated Prey Density Data from Multiple Authors and Across Watersheds
#'
#' @description Prey density data was aggregated from five authors and the Zooper R library. All data was assigned a habitat type of agricultural canal,
#' floodplain, perennial instream, or side channel. Data exists in the following watersheds:
#' \itemize{
#' \item Butte Creek
#' \item Feather River
#' \item Sutter Bypass
#' \item Sacramento River
#' \item Yolo Bypass
#' \item San Joaquin
#' \item North Delta
#' \item South Delta
#' \item Merced
#' \item Stanislaus
#' }
#'
#' @format a dataframe
#'
#' @details
#' Data dictionary:
#'  \itemize{
#' \item date; yyyy-mm-dd
#' \item prey_density; numeric; total organisms/liter
#' \item life_stage; categorical
#' \item species; categorical
#' \item habitat_type; categorical
#' \item gear_type; categorical
#' \item site; categorical
#' \item watershed; categorical
#' \item mesh_size; numeric
#' \item size_class; categorical
#' \item author; categorical
#' \item lat; numeric
#' \item lon; numeric
#' }
#'
#' @source
#'
#' \strong{Corline} \cr
#' Corline et al. collected data from 2013-02-13 to 2016-04-18 for 12 sites. Corline collected prey density data.
#'
#' Corline, Nicholas J., et al. "Zooplankton ecology and trophic resources for rearing native fish on an agricultural floodplain in the
#' Yolo Bypass California, USA." Wetlands Ecology and Management 25.5 (2017): 533-545.
#'
#' \strong{Cordoleani} \cr
#' Cordoleani et al. collected data from 2019-01-07 to 2021-03-29 at 19 sites. In addition to prey density, Cordoleani et al. also collected
#' environmental and fish length/mass data.
#'
#' Cordoleani, Flora et al. Evaluating the role(s) of the Butte sink and Sutter
#' Bypass for Butte Creek spring-run Chinook Salmon and other Central Valley juvenile salmonid populations - 2020 study year (2021). Unpublished manuscript.
#'
#' \strong{Zeug} \cr
#' Zeug provided prey density data from two rivers: San Joaquin River and Merced River.
#'
#' San Joaquin River: \cr
#' Zeug collected data in 2016 for four sites along the San Joaquin River.
#'
#' Merced River: \cr
#' Zeug collected data in April 2019 for four sites along the Merced River.
#'
#' Citation: TODO
#'
#' \strong{Montgomery} \cr
#' Montgomery collected data from 2018-10-30 to 2019-05-07 at 41 sites. In addition to prey_density, Montgomery collected environmental and
#' fish length/mass data.
#'
#' Montgomery, J. 2021. Fish Food on Floodplain Farm Fields 2019 ver 1.
#' Environmental Data Initiative. https://doi.org/10.6073/pasta/53ab08e695503bfbbeaeee637835da0b (Accessed 2022-06-11).
#'
#'
#' \strong{Zooper R library} \cr
#'
#' Prey density data was downloaded from the
#' \href{https://github.com/CVPIA-OSC/DSMtemperature/blob/main/R/data.R}{\code{zooper library}} and integrated into
#' this dataset. Data was collected from 1995-2020 for 5 Zooper sites: 20mm, EMP, FMWT, FRP, STN.
#'
#' Citations: \cr
#' Bashevkin, S. M., R. Hartman, M. Thomas, A. Barros, C. E. Burdi, A. Hennessy, T. Tempel, and K. Kayfetz. 2022. Five decades (1972–2020) of
#' zooplankton monitoring in the upper San Francisco Estuary. PLOS ONE 17: e0265402.
#' doi:10.1371/journal.pone.0265402
#'
#' Bashevkin, S. M., R. Hartman, M. Thomas, A. Barros, C. Burdi, A. Hennessy, T. Tempel, and K. Kayfetz. 2022. Interagency Ecological Program:
#' Zooplankton abundance in the Upper San Francisco Estuary from 1972-2020, an integration of 5 long-term monitoring programs. ver 3. Environmental Data Initiative.
#' doi:10.6073/pasta/89dbadd9d9dbdfc804b160c81633db0d
#'
#' \strong{Guignard} \cr
#' Guignard et al. colllected data from 2014-04-03 to 2014-06-29 at 6 sites.
#'
#' Citation: TODO
#'
#'
"all_prey_density"

#' All Environmental Data
#'
#' @description all collected environmental data from sites/authors that collected prey density and fish metric data.

#' @format a dataframe
#'
#' @details
#' Data dictionary:
#'  \itemize{
#' \item date; yyyy-mm-dd
#' \item do_mg_l; numeric; dissolved oxygen (mg/L)
#' \item temperature; numeric; degrees celcius
#' \item flow_cfs; numeric; flow (cfs)
#' \item habitat_type; categorical
#' \item site; categorical
#' \item watershed; categorical
#' \item author; categorical
#' }
#'
#' @source
#'
#' \strong{Cordoleani} \cr
#' Cordoleani collected temperature and dissolved oxygen 2019 - 2021.
#'
#' Cordoleani, Flora et al. Evaluating the role(s) of the Butte sink and Sutter
#' Bypass for Butte Creek spring-run Chinook Salmon and other Central Valley juvenile salmonid populations - 2020 study year (2021). Unpublished manuscript.
#'
#' \strong{Zeug} \cr
#' Zeug collected temperature data in 2008 and 2009 along the Merced River.
#'
#' Citation: TODO
#'
#' \strong{Montgomery} \cr
#' Montgomery collected temperature and dissolved oxygen data in 2018 and 2019.
#'
#' Montgomery, J. 2021. Fish Food on Floodplain Farm Fields 2019 ver 1.
#' Environmental Data Initiative. https://doi.org/10.6073/pasta/53ab08e695503bfbbeaeee637835da0b (Accessed 2022-06-11).
#'
#' \strong{Zooper R library} \cr
#'
#' Temperature data was downloaded from the
#' \href{https://github.com/CVPIA-OSC/DSMtemperature/blob/main/R/data.R}{\code{zooper library}} and integrated into
#' this dataset. Data was collected from 1995-2020 for 5 Zooper sites: 20mm, EMP, FMWT, FRP, STN.
#'
#' Citations: \cr
#' Bashevkin, S. M., R. Hartman, M. Thomas, A. Barros, C. E. Burdi, A. Hennessy, T. Tempel, and K. Kayfetz. 2022. Five decades (1972–2020) of
#' zooplankton monitoring in the upper San Francisco Estuary. PLOS ONE 17: e0265402.
#' doi:10.1371/journal.pone.0265402
#'
#' Bashevkin, S. M., R. Hartman, M. Thomas, A. Barros, C. Burdi, A. Hennessy, T. Tempel, and K. Kayfetz. 2022. Interagency Ecological Program:
#' Zooplankton abundance in the Upper San Francisco Estuary from 1972-2020, an integration of 5 long-term monitoring programs. ver 3. Environmental Data Initiative.
#' doi:10.6073/pasta/89dbadd9d9dbdfc804b160c81633db0d
#'
#' \strong{Guignard} \cr
#' Guignard collected temperature and flow data in 2014.
#'
#' Citation: TODO
#'
"all_enviro_data"

#' All Fish Data
#'
#' @description all fork length and mass data for fish collected.

#' @format a dataframe
#'
#' @details
#' Data dictionary:
#'  \itemize{
#' \item date; yyyy-mm-dd
#' \item fork_length; numeric; the measured fish fork length (millimeters)
#' \item mass; numeric; weight of sampled fish (grams)
#' \item habitat_type; categorical
#' \item site; categorical
#' \item watershed; categorical
#' \item author; categorical
#' }
#'
#' @source
#'
#' \strong{Cordoleani} \cr
#' Cordoleani collected fish mass and fork length data in 2019-2021.
#'
#' Cordoleani, Flora et al. Evaluating the role(s) of the Butte sink and Sutter
#' Bypass for Butte Creek spring-run Chinook Salmon and other Central Valley juvenile salmonid populations - 2020 study year (2021). Unpublished manuscript.
#'
#' \strong{Zeug} \cr
#' Zeug collected fork length and mass data without a measured date along the Merced River.
#'
#' Citation: TODO
#'
#' \strong{Montgomery} \cr
#' Montgomery collected  fork length and mass data in 2019.
#'
#' Montgomery, J. 2021. Fish Food on Floodplain Farm Fields 2019 ver 1.
#' Environmental Data Initiative. https://doi.org/10.6073/pasta/53ab08e695503bfbbeaeee637835da0b (Accessed 2022-06-11).
#'
#'
"all_fish_data"

#' Monthly Fish Data
#'
"monthly_fish_data"

#' Monthly Prey Density Data
#'
#' @description this is the aggregation of all_prey_density by watershed, habitat type, year, and month.
#' The max, min, median, and variance are reported.
#'
#' @details
#' Data dictionary:
#'  \itemize{
#' \item habitat_type; categorical; c('perennial instream', 'floodplain', 'side channel', 'agricultural floodplain')
#' \item watershed; categorical; The watershed the data was collected in.
#' \item year; numeric; The year the data was collected.
#' \item month; numeric; The month the data was collected.
#' \item min_prey_density; numeric; The minimum prey density (number of oranisms/liter)
#' \item max_prey_density; numeric; The maximum prey density (number of oranisms/liter)
#' \item median_prey_density; numeric; The median prey density (number of oranisms/liter)
#' \item var_prey_density; numeric; The variance of prey density (number of oranisms/liter)
#' }
#'
#' @seealso all_prey_density
#'
"monthly_prey_density"

