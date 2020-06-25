# ##### some code here run once when the app is launched

library(shiny)
library(shinythemes)
library(shinyWidgets)
library(leaflet)
library(plotly)
library(dplyr)
library(tidyr)
library(tigris)
library(DT)

options(tigris_use_cache = TRUE)
#options(tigris_refresh = TRUE)

confirmedUSUrl <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
deathsUSUrl <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv"
recoveredUrl <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"
#census <- readRDS("c19app/data/counties.rds")

time_ <- trunc(as.numeric(as.POSIXlt(Sys.time()))/1440)

if(!exists("confData") || time_ > time_run){ # only load once a day
    confData <- read.csv(confirmedUSUrl, header = TRUE, stringsAsFactors = FALSE,
                         check.names = FALSE)
    deathData <- read.csv(deathsUSUrl, header = TRUE, stringsAsFactors = FALSE,
                          check.names = FALSE)
    recoveredData <- read.csv(recoveredUrl, header = TRUE, stringsAsFactors = FALSE,
                              check.names = FALSE)
    
    time_run <- trunc(as.numeric(as.POSIXlt(Sys.time()))/1440)
    
}

##### light cleaning ######
# continental US
us_states <- unique(fips_codes$state_name)[1:51]
continental_states <- us_states[!us_states %in% c("Alaska", "Hawaii")]

# Filter out unwated columns of both dataframes
confirm <- confData %>%
    select(5, County_Area = Admin2, 7,lat = Lat, lng = Long_, total_cases = ncol(confData))
death <- deathData %>%
    select(5, County_Area = Admin2, 7, lat = Lat, lng = Long_, 12, total_deaths = ncol(deathData))
recovered <- recoveredData %>%
    select(1:2, lat = Lat, lng = Long, total_recovered = ncol(recoveredData)) %>%
    filter(`Country/Region` == "US")

# combine dataframs and filter out unwated areas
county_outbreak <- left_join(confirm, death, by = c("FIPS", "County_Area", "Province_State", "lat", "lng")) %>%
    replace(is.na(.), 0) %>%
    filter(Province_State %in% continental_states)
# group for state data
state_outbreak <- county_outbreak %>%
    group_by(Province_State) %>%
    summarize(total_cases = sum(total_cases),
              Population = sum(Population),
              total_deaths = sum(total_deaths))
# County_outbreak for DT
county_outbreak_dt <- select(county_outbreak, -c("FIPS", "lat", "lng"))

# US spatial data from tigri for county lines
counties_ <- counties(state = county_outbreak$Province_State, cb = TRUE )
states_ <- states(cb = TRUE)
states_ <- states_[states_$NAME %in% continental_states,]

counties_$GEOID <- as.numeric(counties_$GEOID) # numeric to match other df and to get rid of leading 0's
#states_$GEOID <- as.numeric(states_$GEOID)

# join spatial data and df
counties_sd <- geo_join(counties_, county_outbreak, "GEOID", "FIPS")
states_sd <- geo_join(states_, state_outbreak, "NAME", "Province_State")

# x_pal <- colorNumeric(palette = "Blues", domain = states_sd$total_cases)

s_bins <- c(0, 20, 200, 500, 1000, 2000, 16000, 40000, 75000, Inf)
s_pal <- colorBin("Blues", domain = states_sd$total_cases, bins = s_bins)

c_bins <- c(0, 10, 20, 50, 100, 500, 2000, 5000, 20000, Inf)
c_pal <- colorBin("Reds", domain = counties_sd$total_cases, bins = c_bins)


##### for charts ########


dchart <- deathData %>%
    select(-(c(1:4,9:11)), County_Area = Admin2) %>%
    pivot_longer(cols = -(1:5), names_to="Date", values_to = "Deaths")

cchart <- confData %>%
    select(-(c(1:4,9:11)), County_Area = Admin2) %>%
    pivot_longer(cols = -(1:4), names_to="Date", values_to = "Cases")

combinechart <- full_join(dchart,cchart) %>% 
    filter(Province_State %in% continental_states) %>% 
    mutate(Date=as.Date(Date, format="%m/%d/%y"))

st <- combinechart %>% group_by(Province_State, Date) %>% 
    summarize(t_deaths = sum(Deaths), t_cases = sum(Cases))

cnty <- combinechart %>% group_by(County_Area, Date) %>% 
    summarize(t_deaths = sum(Deaths), t_cases = sum(Cases))
