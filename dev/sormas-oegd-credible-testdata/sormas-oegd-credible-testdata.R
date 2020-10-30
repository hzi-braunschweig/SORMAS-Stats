library(here)
library(tictoc)
library(jsonlite)
library(zoo)
library(network)
library(igraph)
library(tidygraph)
library(ggraph) # devtools::install_github('thomasp85/ggraph')
library(tmap)
library(tmaptools)
library(ggmap)
library(ISOweek)
library(openxlsx)
library(sf)
library(geosphere)
library(fitdistrplus)
library(socialmixr)
library(ggplot2)
library(ggnetwork)
library(tidyr)
library(stringr)
library(dplyr)

### Parameters ----

# Computations:
# Whether to generate the test data set or to load it
generate_dataset <- FALSE

# Data download:
# If corona dashboard data are downloaded, SurvStat data should be downloaded at
# the same time! And `survstat_download_date` changed accordingly
download_covid_dashboard <- FALSE
survstat_download_date <- "20201018"
data_dir <- "data"
dir.create(here(data_dir, "out"), recursive = TRUE, showWarnings = FALSE)
img_dir <- "img"
dir.create(here(img_dir), recursive = TRUE, showWarnings = FALSE)

# Colors:
vega_colors <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
  "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")

# Counties of interest
selected_counties <- c("Braunschweig", "Salzgitter", "Wolfsburg")

# Maximum age that can be generated
max_age <- 95

# Default country of residence
default_country <- "Deutschland"
# Foreign country of residence taken as example
foreign_country <- "Frankreich"
# Probability that a case has residence abroad
p_foreign_country <- 0.05

# Common names
first_names <- list(
  Deutschland = list(
    w = c("Maria", "Ursula", "Monika", "Petra", "Elisabeth", "Sabine", "Renate",
      "Helga", "Karin", "Brigitte", "Ingrid", "Erika", "Andrea", "Gisela",
      "Claudia", "Susanne", "Gabriele", "Christa", "Christine", "Hildegard",
      "Anna", "Birgit", "Fatma", "Ayşe ", "Anna", "Maria"),
    m = c("Peter", "Wolfgang", "Michael", "Werner", "Klaus", "Thomas",
      "Manfred", "Helmut", "Jürgen", "Heinz", "Gerhard", "Andreas", "Hans",
      "Josef", "Günter", "Dieter", "Horst", "Walter", "Frank", "Bernd", "Karl",
      "Herbert", "Franz ", "Mehmet", "Mustafa", "Piotr", "Krzysztof")
  ),
  Frankreich = list(
    w = c("Marie", "Jeanne", "Françoise", "Monique", "Catherine", "Nathalie",
      "Isabelle", "Jacqueline", "Anne", "Sylvie"),
    m = c("Jean", "Pierre", "Michel", "André", "Philippe", "René", "Louis",
      "Alain", "Jacques", "Bernard")
  )
)
family_names <- list(
  Deutschland = c("Müller", "Schmidt", "Schneider", "Fischer", "Weber", "Meyer",
    "Wagner", "Becker", "Schulz", "Hoffmann", "Schäfer", "Koch", "Bauer",
    "Richter", "Klein", "Wolf", "Schröder", "Neumann", "Schwarz", "Zimmermann",
    "Braun", "Krüger", "Hofmann", "Yılmaz", "Kaya", "Nowak", "Kowalski"),
  Frankreich = c("Martin", "Bernard", "Thomas", "Petit", "Robert", "Richard",
    "Durand", "Dubois", "Moreau", "Laurent")
)

# County of residence and reporting local health authority are the same with
# probability `p_lha_address`
p_lha_address <- 0.85

# Hospitalization and death for cases
p_hospitalization <- 0.1
p_death <- 0.03 # case fatality rate, approximately the average for Germany
# in October 2020, see https://ourworldindata.org/ ...
# ... coronavirus-data-explorer?zoomToSelection=true&country=~DEU& ...
# ... region=World&cfrMetric=true&interval=smoothed&smoothing=7& ...
# ... pickerMetric=location&pickerSort=asc

# Symptoms:
# Probabilities of different symptoms given that the person has symptoms..
# Adapted from https://www.theguardian.com/world/2020/oct/19/ ...
# ... coronavirus-symptoms-how-to-tell-if-you-have-a-common-cold-flu-or-covid
# `term` is the term indicated in the article, `prob` the rough, somewhat
# arbitrary translation as a probability.
# `p_asymptomatic` is the probability of no symptom ("asymptomatic",
# 40% in best estimate scenario from CDC on 2020-9-10,
# https://www.cdc.gov/coronavirus/2019-ncov/hcp/planning-scenarios.html#box1 )
# The assignment of symptoms takes RKI's case definition into account, where
# for simplicity "klinisch" means that at least one symptom was observed:
# - case definition A: unknown (there might be symptoms)
# - case definition B: there are symptoms
# - case definition C: there are symptoms
# - case definition D: there are *no* symptoms
# - case definition E: unknown (there might be symptoms)
# Contacts (persons that are not cases) have missing symptoms.
p_asymptomatic <- 0.4
p_symptoms <- tibble(
  symptom = c("Fieber", "Müdigkeit", "Husten", "Geruchssinnsverlust",
    "Schmerzen", "Niesen", "Halssschmerz", "Durchfall", "Kopfschmerzen",
    "Atemnot"),
  term = c("common", "sometimes", "common", "common", "sometimes", "rare",
    "sometimes", "rare", "sometimes", "sometimes"),
  prob = c(0.6, 0.3, 0.6, 0.6, 0.3, 0.1, 0.3, 0.1, 0.3, 0.3)
)

# Date of onset of disease:
# The delay between onset and reporting dates is assumed to follow a Gumbel
# distribution fitted on available data. The function `rgumbel` to generate
# random numbers from the fitted distribution has three further (not fitted)
# parameters: `gumbel_stepsize`, `gumbel_lowerbound` and `gumbel_upperbound`.
gumbel_stepsize <- 1/100
gumbel_lowerbound <- -100
gumbel_upperbound <- 100

# Date of infection:
# Assumed to happen before the date of onset or reporting, whichever is earlier,
# with the length of the preceding period following an exponential distribution
# with scale `infection_timescale` (it is the inverse of the rate).
infection_timescale <- 3

# Infectiosity:
# A person is assumed infectious for a period after infection that follows an
# exponential distribution of scale `infectiosity_timescale` (it is the inverse
# of the rate).
infectiosity_timescale <- 5

# Clusters:
# the probability to be infected by a person is higher
# if that persons has already infected others. This is modeled with the
# relative gain in probability from each previous infection.
p_cluster_case <- 0.3

# Case generations:
# "0" = it is not known by whom one person was infected (root of the
#   transmission tree)
# "1" = infected by a generation 0 case (belongs to neighbors of a root)
# "2" = infected by a generation 1 case
# etc.
# Probabilities that a given case within the default country is of a given
# generation
p_case_generation <- c("0" = 0.2, "1" = 0.3, "2" = 0.2,
  "3" = 0.15, "4" = 0.15)
# Relative probability of infection as a function of the difference in
# generations between two cases. Taken to be an exponential of the distance -1
# (so that a case cannot be infected by a case of identical or higher
# generation) of scale `infect_diff_generation_scale` (the inverse of the rate).
infect_diff_generation_scale <- 1.5

# Initiation:
# All cases infected within `init_days` days of the first infection are roots in
# transmission chains (generation "0").
init_days <- 14

# Contacts:
# Probability that a contact resides in the county of the local health
# authority responsible for the index (otherwise equal probabilities to reside
# in the other counties)
p_contact_reside <- 2/3
# Probability that a contact has been contacted by the local health authority
# of the index
p_contact_contacted <- 0.5
# Probability that, given that they were contacted, a contact is in quarantine
p_contact_quarantine <- 0.75
# Probability that, given that they were contacted, a contact has been tested
# (with a negative result, otherwise it would be a case)
p_contact_test <- 0.75

# Geolocations:
# Shapes (polygons) of the counties
county_shapes <- st_read(
  here(data_dir, 'in/germany_counties.geojson'), quiet = T
) %>%
  st_set_crs(4839) %>%
  st_transform(crs = 4326) %>%
  select(-c(value, signal, id, IdParent, AdminUnit)) %>%
  filter(GeoName %in% selected_counties)
# The probability of the location of the contact of a person depends is
# an exponential of the distance between the two with scale (the inverse of
# the rate) `location_dist_scale` in meters.
location_dist_scale <- 2000
# Sample sizes of geolocations: `relative_sample_size_geolocation` sets the size
# of the one-time generated list of geolocations relative to the number of
# cases, `sub_sample_size_geolocation` the size of the samples from the list of
# geolocations
relative_sample_size_geolocation <- 100
sub_sample_size_geolocation <- 100

# Events:
frac_events_cases <- 0.05 # number of events divided by number of cases
mu_event_size <- 10 # mean parameter of the Gaussian used in draw the event size
sig_event_size <- 10 # standard deviation of the Gaussian
min_event_size <- 5 # minimum size of an event
p_known_participant <- 0.01 # 0.2 # proportion of participants who are a case
  # or a contact, knowing that there is at least one case participating

### Functions ----

AssignAgeFromRKIAgeGroup <- function (ag_vec, m_a) {
  # Draws a random age in each age group of the vector `ag_vec` uniformly at
  # random. For the last age group "A80+", a maximum age of `m_a` is taken.
  # Specific to the way age groups are coded in RKI's corona dashboard
  age_vec <- lapply(
    ag_vec,
    function (ag) {
      if (ag == "A80+") {
        sample(80:m_a, 1)
      } else {
        sample(
          seq(as.numeric(str_sub(ag, 2, 3)), as.numeric(str_sub(ag, 6, 7))),
          1
        )
      }
    }
  ) %>%
    unlist()

  return(age_vec)

}

# Functions for the Gumbel distribution, required by fitdistrplus::fitdist
dgumbel <- function(x, a, b) 1/b*exp((a-x)/b)*exp(-exp((a-x)/b))
pgumbel <- function(q, a, b) exp(-exp((a-q)/b))
qgumbel <- function(p, a, b) a-b*log(-log(p))

rgumbel <- function(n, a, b, g_ss, g_lb, g_ub) {
  # Custom random number generation from a Gumbel distribution.
  # Parameters are the step size `g_ss` and boundaries `g_lb` and `g_ub` for
  # the integration of the probability density function.
  rvec <- c()
  stepsize <- g_ss
  xmin <- g_lb
  xmax <- g_ub
  x <- seq(xmin, xmax, by=stepsize)
  cdf <- cumsum(dgumbel(x, a, b))*stepsize
  for (i in 1:n) {
    r <- runif(1, 0, 1)
    rvec <- c(rvec, max(x[which(cdf<=r)]))
  }
  return(rvec)
}

ImputeOnsetDate <- function(od, rd, p_delay, g_ss, g_lb, g_ub) {
  # Takes a vector of onset dates `od`, of reporting dates `rd` and, if any
  # element`od` is `NA` imputes a date that is the corresponding element in
  # `rd` minus a delay drawn from the fitted Gumbel distribution `p_delay`,
  # rounded.

  od_imp <- c()
  for (i in 1:length(od)) {
    if (is.na(od[i])) {
      delay <- round(
        rgumbel(1, p_delay$estimate['a'], p_delay$estimate['b'], g_ss, g_lb,
          g_ub)
      )
      od_imp <- c(od_imp, rd[i]-delay)
    } else {
      od_imp <- c(od_imp, od[i])
    }
  }
  return(as.Date(od_imp, origin="1970-1-1"))
}

ImputeInfectionDate <- function(od, rd, inf_scale) {
  # The infection happened `inf_delay` days before date of onset `od `or of
  # reporting `rd`, whichever is earlier. It is assumed to follow an exponential
  # distribution of scale `inf_scale`, rounded.

  infd <- c()
  for (i in 1:length(od)) {
    infd <- c(
      infd,
      min(od[i], rd[i]) - round(rexp(1, 1/inf_scale))
    )
  }
  return(as.Date(infd, origin="1970-1-1"))

}

CreateInfectionChains <- function(cases_df, index_cases, infected_cases,
  inf_time_scale, inf_gen_scale, p_cluster_c) {
  # Attaches the cases in `infected_cases` to those of the previous generation
  # in `index_cases`. If no candidate index case has been infected at an earlier
  # date as the infected, then all previous cases are tried.
  # The probability of an infection is proportional to an exponential of
  # difference in infection date, the relative "bonus" for cases that have
  # previously infected other cases and an exponential of the difference in
  # generations. It is then normalized.

  for (ifc in infected_cases) {
    infected_inf_date <- cases_df %>% filter(id == ifc) %>% pull(infection_date)
    infected_generation <- cases_df %>% filter(id == ifc) %>% pull(generation)
    past_index_cases <- index_cases[
      which(
        as.numeric(cases_df$infection_date[index_cases]) <=
          as.numeric(infected_inf_date)
      )
    ]
    if (length(past_index_cases) == 0) {
      # If there are no cases of the desired generation with earlier infection
      # date, then try all past cases of lower generation.
      past_index_cases <- cases_df %>%
        filter(
          infection_date <= infected_inf_date &
            as.numeric(generation) < as.numeric(infected_generation)
        ) %>%
        pull(id)
    }
    p_index_infecting <- c()
    for (irc in past_index_cases) {
      index_inf_date <- cases_df %>% filter(id == irc) %>% pull(infection_date)
      index_generation <- cases_df %>% filter(id == irc) %>% pull(generation)
      index_degree <- cases_df %>% filter(id == irc) %>% pull(degree)
      p_index_infecting <- c(
        p_index_infecting,
        dexp(as.numeric(infected_inf_date - index_inf_date), 1/inf_time_scale) *
          (1 + index_degree * p_cluster_c) *
          dexp(
            as.numeric(infected_generation) - as.numeric(index_generation),
            1/inf_gen_scale
          )
      )
    }
    p_index_infecting <- p_index_infecting/sum(p_index_infecting)
    if (length(past_index_cases) == 1) {
      index_infecting <- past_index_cases
    } else {
      index_infecting <- sample(past_index_cases, 1, prob = p_index_infecting)
    }
    cases_df$infected_by[cases_df$id == ifc] <- index_infecting
    cases_df$degree[cases_df$id == index_infecting] <-
      cases_df$degree[cases_df$id == index_infecting] + 1
  }
  return(cases_df)

}

# Names of persons
GetFirstName <- function(fi_na, cntry, se) {
  fn <- c()
  for (i in 1:length(cntry)) {
    fn <- c(fn, sample(fi_na[[cntry[i]]][[se[i]]], size = 1))
  }
  return(fn)
}
GetFamilyName <- function(fa_na, cntry) {
  fn <- c()
  for (i in 1:length(cntry)) {
    fn <- c(fn, sample(fa_na[[cntry[i]]], size = 1))
  }
  return(fn)
}

# Address vs. reporting local health authority
AssignAddress <- function(lha_vec, sel_cnts, p_lha_a) {

  addr_vec <- c()
  for (lha in lha_vec) {
    addr_vec <- c(
      addr_vec,
      sample(sel_cnts, 1, prob = sapply(sel_cnts,
        function (sc)
          ifelse(sc == lha, p_lha_a, (1-p_lha_a)/(length(sel_cnts)-1))
      )
      )
    )
  }
  return(addr_vec)

}

### Data ----

if (generate_dataset) {

  # Daily covid data from RKI (corona dashboard)
  if (download_covid_dashboard) {

    covid_dashboard <- fromJSON(
      paste0(
        "https://opendata.arcgis.com/datasets/",
        "dd4580c810204019a7b8eb3e0b329dd6_0.geojson"
      )
    )$features$properties %>%
      as_tibble() %>%
      select(Landkreis, Altersgruppe, Geschlecht, Meldedatum, AnzahlFall,
        Refdatum, IstErkrankungsbeginn) %>%
      filter(str_detect(Landkreis, paste(selected_counties, collapse = "|"))) %>%
      rename(
        county = Landkreis,
        sex = Geschlecht,
        age_group = Altersgruppe,
        reporting_date = Meldedatum,
        reference_date = Refdatum,
        is_onset_date = IstErkrankungsbeginn,
        count = AnzahlFall
      ) %>%
      mutate(
        county = str_replace(county, "SK\\s", ""),
        reporting_date = as.Date(str_sub(reporting_date, 1, 10)),
        reporting_week = ISOweek(reporting_date),
        onset_date = case_when(
          is_onset_date == 1 ~ as.Date(str_sub(reference_date, 1, 10)),
          TRUE ~ as.Date(NA)
        ),
        sex = case_when(
          sex == "M" ~ "m",
          sex == "W" ~ "w",
          TRUE ~ as.character(NA)
        )
      ) %>%
      select(county, sex, age_group, reporting_date, reporting_week, onset_date,
        count) %>%
      arrange(county, sex, age_group, reporting_date, onset_date)

    saveRDS(covid_dashboard, here(data_dir, "in/covid_dashboard.rds"))

  } else {

    covid_dashboard <- readRDS(here(data_dir, "in/covid_dashboard.rds"))

  }

  # Weekly Covid data from RKI (SurvStat)
  covid_survstat <- NULL
  for (cnty in selected_counties) {

    survstat_file <- here(
      data_dir,
      paste0(
        "in/survstat-", tolower(cnty), "-casedef-", survstat_download_date, ".csv"
      )
    )

    survstat_data <- bind_cols(
      tibble(county = cnty),
      read.csv(
        survstat_file,  sep = "\t", header = TRUE, fileEncoding = "UTF-16",
        skip = 1
      ) %>%
        as_tibble()
    ) %>%
      rename(case_def = X) %>%
      pivot_longer(
        cols = -c(county, case_def),
        names_to = "reporting_week",
        values_to = "count"
      ) %>%
      mutate(
        count = ifelse(is.na(count), 0, count),
        reporting_week = paste0(
          str_sub(reporting_week, 2, 5),
          "-W",
          str_sub(reporting_week, 9, 10)
        ),
        case_def_id = case_when(
          # Reference:
          # https://www.rki.de/DE/Content/Infekt/Jahrbuch/ ...
          #   ... Jahrbuch_2018.pdf?__blob=publicationFile
          case_def == "-nicht ermittelbar-" ~ "none",
          case_def == "klinisch" ~ "A",
          case_def == "klinisch-epidemiologisch" ~ "B",
          case_def == "klinisch-labordiagnostisch" ~ "C",
          case_def == "labordiagnostisch bei nicht erfüllter Klinik" ~ "D",
          case_def == "labordiagnostisch bei unbekannter Klinik" ~ "E",
          TRUE ~ as.character(NA)
        )
      ) %>%
      select(county, case_def_id, case_def, reporting_week, count)

    covid_survstat <- covid_survstat %>% bind_rows(survstat_data)

  }
  # Remove entries without cases, as they won't appear in the covid dashboard
  # data
  covid_survstat <- covid_survstat %>% filter(count != 0)

  ### Case persons ----

  # Check that the (weekly) case counts are the same in both data sources
  for (data_source in c("dashboard", "survstat")) {
    if (data_source == "dashboard") {
      data_df <- covid_dashboard
    } else {
      data_df <- covid_survstat
    }
    weekly_cases <- data_df %>%
      group_by(county, reporting_week) %>%
      summarise(weekly_count = sum(count)) %>%
      ungroup() %>%
      select(county, reporting_week, weekly_count) %>%
      arrange(county, reporting_week)
    if (data_source == "dashboard") {
      weekly_cases_dashboard <- weekly_cases
    } else {
      weekly_cases_survstat <- weekly_cases
    }
  }
  if(!all(weekly_cases_dashboard == weekly_cases_survstat)) {
    stop("Weekly case counts at the county level differ between dashboard",
      " and SurvStat.")
  }

  # Create individual cases that reproduce the aggregated data from covid
  # dashboard and SurvStat
  persons_df <- NULL
  for (duplicate in sort(unique(covid_dashboard$count))) {
    data_dupl <- covid_dashboard %>% filter(count == duplicate)
    for (i in 1:nrow(data_dupl)) {
      for (j in 1:duplicate) {
        persons_df <- persons_df %>% bind_rows(data_dupl[i,])
      }
    }
  }
  persons_df <- persons_df %>%
    select(-count) %>%
    rename(local_health_authority = county) %>%
    mutate(
      id = row_number(),
      is_case = TRUE,
      # Add random age, uniform in age group with A80+ up to 95
      age = AssignAgeFromRKIAgeGroup(age_group, max_age)
    )

  # Randomly assign a country of residence
  persons_df$country_of_residence <- sample(
    c(default_country, foreign_country),
    nrow(persons_df),
    prob = c(1-p_foreign_country, p_foreign_country),
    replace = TRUE
  )

  # For cases, if they live in the default country, the address is the reporting
  # local health authority with probability `p_lha_address` and any other county
  # with uniform probability. If the reside abroad it is "abroad".
  persons_df <- persons_df %>%
    mutate(address = ifelse(
      country_of_residence == default_country,
      AssignAddress(local_health_authority, selected_counties, p_lha_address),
      "abroad")
    )

  # When the onset date is missing, impute one by drawing from the overall
  # distribution of delay between onset and reporting
  reporting_delays <- persons_df %>%
    filter(!is.na(onset_date)) %>%
    mutate(delay = reporting_date-onset_date) %>%
    pull(delay) %>%
    as.integer()
  p_reporting_delay <- fitdist(reporting_delays, "gumbel",
    start = list(a = 10, b = 10))

  persons_df <- persons_df %>%
    mutate(onset_date = ImputeOnsetDate(onset_date, reporting_date,
      p_reporting_delay, gumbel_stepsize, gumbel_lowerbound, gumbel_upperbound))

  # Assign a date of infection:
  # it happened typically in the `infection_period` days before onset or
  # reporting, whichever is earlier
  persons_df <- persons_df %>%
    mutate(infection_date = ImputeInfectionDate(onset_date, reporting_date,
      infection_timescale))

  # Assign case definition to individual cases: For each reporting week,
  # randomly draw a number of cases that have a given case definition as given by
  # the SurvStat data.
  persons_df <- persons_df %>%
    mutate(case_def_id = as.character(NA), case_def = as.character(NA))

  for (cnty in unique(covid_survstat$county)) {
    survstat_df1 <- covid_survstat %>% filter(county == cnty)
    for (rw in unique(survstat_df1$reporting_week)) {
      survstat_df2 <- survstat_df1 %>% filter(reporting_week == rw)
      candidate_cases <- persons_df %>%
        filter(local_health_authority == cnty & reporting_week == rw) %>%
        pull(id)
      for (i in 1:nrow(survstat_df2)) {
        if (length(candidate_cases) == 1) {
          cd_cases <- candidate_cases
        } else {
          cd_cases <- sample(candidate_cases, survstat_df2$count[i])
        }
        persons_df <- persons_df %>%
          mutate(
            case_def_id = ifelse(
              id %in% cd_cases, survstat_df2$case_def_id[i], case_def_id
            ),
            case_def = ifelse(
              id %in% cd_cases, survstat_df2$case_def[i], case_def
            )
          )
        candidate_cases <- candidate_cases[!candidate_cases %in% cd_cases]
      }
      if (length(candidate_cases) > 0) {
        stop("Case definitions haven't been assigned to all cases.")
      }
    }
  }

  # Assign symptoms
  symptoms_cases_df <- as_tibble(matrix(NA, nrow = 0, ncol = 3,
    dimnames = list(NULL, c("id", "symptom", "id_person"))))
  symptoms_cases_df$symptom <- as.character(symptoms_cases_df$symptom)
  isympcase <- 1
  for (i in 1:nrow(persons_df)) {
    persons_df$has_symptoms[i] <- case_when(
      persons_df$case_def_id[i] == "D" ~ FALSE,
      persons_df$case_def_id[i] %in% c("B", "C") ~ TRUE,
      TRUE ~ sample(c(TRUE, FALSE), 1, prob = c(1-p_asymptomatic, p_asymptomatic))
    )
    if (persons_df$has_symptoms[i]) {
      at_least_one_symptom <- FALSE
      while(!at_least_one_symptom) {
        symp_vec <- c()
        for (prob in p_symptoms$prob) {
          symp_vec <- c(
            symp_vec,
            sample(c(TRUE, FALSE), 1, prob = c(prob, 1-prob))
          )
        }
        at_least_one_symptom <- any(symp_vec)
      }
      for (sy in p_symptoms$symptom[symp_vec]) {
        symptoms_cases_df <- symptoms_cases_df %>%
          bind_rows(
            tibble(
              id = isympcase,
              symptom = sy,
              id_person = persons_df$id[i]
            )
          )
        isympcase <- isympcase + 1
      }
    }
  }

  # Assign status `hospitalized` or `died`
  persons_df$hospitalized <- sample(
    c(TRUE, FALSE),
    nrow(persons_df),
    replace = TRUE,
    prob = c(p_hospitalization, 1-p_hospitalization)
  )
  persons_df$died <- sample(
    c(TRUE, FALSE),
    nrow(persons_df),
    replace = TRUE,
    prob = c(p_death, 1-p_death)
  )

  print("init done")

  ### Chains of infections ----

  # Assign a generation to each case
  persons_df$generation <- sample(
    names(p_case_generation), nrow(persons_df), prob = p_case_generation,
    replace = TRUE
  )

  # All persons with residence abroad or with onset date within `init_days` days
  # of the first are roots (generation "0")
  persons_df <- persons_df %>%
    mutate(
      generation = ifelse(
        country_of_residence == default_country &
          infection_date > min(persons_df$infection_date) + init_days,
        generation,
        "0"
      )
    )

  # `infected_by` designate by which case one was infected. root cases
  # (generation "0") have `infected_by` = `NA` since we don't know how they got
  # infected. Links are then added sequentially for cases within a generation
  # and then for increasing generations. The candidates are shuffled to avoid
  # systematic bias.
  # `degree` is the number of persons a case has infected.
  persons_df <- persons_df %>%
    mutate(
      infected_by = NA,
      degree = 0
    )

  tic()
  for (i in 2:length(p_case_generation)) {
    index_c <- persons_df %>%
      filter(generation == names(p_case_generation)[i-1]) %>%
      pull(id) %>%
      sample()
    infected_c <- persons_df %>%
      filter(generation == names(p_case_generation)[i]) %>%
      pull(id) %>%
      sample()
    persons_df <- CreateInfectionChains(persons_df, index_c, infected_c,
      infectiosity_timescale, infect_diff_generation_scale, p_cluster_case)
  }
  toc()

  print("chains done")

  ### Contacts ----

  # Add the columns specific to contacts filled with `NA` for the cases
  persons_df <- persons_df %>%
    mutate(
      has_contact = !is.na(infected_by),
      contact_contacted = NA,
      contact_quarantine = NA,
      contact_tested = NA
    )

  # Create contacts = pair of person + whether this was an infection
  # Infections correspond to a contact
  contacts_df <- persons_df %>%
    select(id, infected_by) %>%
    filter(!is.na(infected_by)) %>%
    mutate(is_infection = TRUE, idc = row_number()) %>%
    rename(
      id_index = infected_by,
      id_contact = id
    ) %>%
    rename(id = idc) %>%
    select(id, id_index, id_contact, is_infection)

  # Create other persons that didn't get infected and are contacts of cases
  # The social contact matrix is taken from the POLYMOD survey for Germany.
  # These are average numbers of contacts within one day. We assume the cases
  # have seen the same people every day in the days after their infection.
  # For simplicity, we draw the number of contacts in each age group from
  # a Poisson distribution with lambda the average number of contacts.
  limits_ag <- as.numeric(str_sub(sort(unique(covid_dashboard$age_group)), 2, 3))
  data("polymod")
  contact_matrix_agegroup <- contact_matrix(polymod, countries = "Germany",
    age.limits = limits_ag, symmetric = TRUE)$matrix
  colnames(contact_matrix_agegroup) <- sort(unique(covid_dashboard$age_group))
  rownames(contact_matrix_agegroup) <- sort(unique(covid_dashboard$age_group))

  contact_persons <- NULL
  idc <- max(contacts_df$id) + 1
  id_contact <- max(persons_df$id) + 1
  for (i in 1:nrow(persons_df)) {

    index_ag <- persons_df$age_group[i]
    n_contacts_ag <- sapply(
      colnames(contact_matrix_agegroup),
      function (ag) {
        rpois(1, lambda = contact_matrix_agegroup[index_ag, ag])
      }
    )
    n_contacts_ag <- n_contacts_ag[n_contacts_ag != 0]

    if (length(n_contacts_ag) > 0) {
      for (j in 1:length(n_contacts_ag)) {
        for (k in 1:n_contacts_ag[j]) {

          contact_agegroup <- names(n_contacts_ag)[j]
          contacted <- sample(c(TRUE, FALSE), 1,
            prob = c(p_contact_contacted, 1-p_contact_contacted))
          quarantine <- ifelse(
            contacted,
            sample(c(TRUE, FALSE), 1,
              prob = c(p_contact_quarantine, 1-p_contact_quarantine)),
            NA)
          tested <- ifelse(
            contacted,
            sample(c(TRUE, FALSE), 1,
              prob = c(p_contact_test, 1-p_contact_test)),
            NA)

          tmp_contact_persons <- as_tibble(matrix(NA, nrow = 1,
            ncol = ncol(persons_df), dimnames = list(NULL, names(persons_df))))
          tmp_contact_persons$sex <- sample(c("w", "m"), 1)
          tmp_contact_persons$age_group <- contact_agegroup
          tmp_contact_persons$id <- id_contact
          tmp_contact_persons$is_case <- FALSE
          tmp_contact_persons$age <- AssignAgeFromRKIAgeGroup(contact_agegroup,
            max_age)
          tmp_contact_persons$country_of_residence <- default_country
          tmp_contact_persons$has_contact <- TRUE
          tmp_contact_persons$contact_contacted <- contacted
          tmp_contact_persons$contact_quarantine <- quarantine
          tmp_contact_persons$contact_tested <- tested

          contact_persons <- contact_persons %>% bind_rows(tmp_contact_persons)

          contacts_df <- contacts_df %>%
            bind_rows(
              tibble(
                id = idc,
                id_index = persons_df$id[i],
                id_contact = id_contact,
                is_infection = FALSE
              )
            )
          idc <- idc + 1
          id_contact <- id_contact + 1
        }
      }
    }

  }

  # Append the contact persons
  persons_df <- persons_df %>% bind_rows(contact_persons)

  # Randomly assign first and family names based on country of residence and sex
  persons_df <- persons_df %>%
    mutate(
      first_name = GetFirstName(first_names, country_of_residence, sex),
      family_name = GetFamilyName(family_names, country_of_residence)
    )

  print("contacts done")

  ### Geolocations ----

  persons_df <- persons_df %>% mutate(longitude = NA, latitude = NA)

  # Generate a list of geolocations with `relative_sample_size_geolocation`
  # times more locations as persons (at the moment only cases) in the county of
  # the case (as given by `address`) or the county local health authority
  # responsible for the case if it resides abroad
  geolocations_df <- NULL
  tic()
  for (cnty in selected_counties) {
    n_addresses_in_county <- relative_sample_size_geolocation * (
      nrow(persons_df %>% filter(address == cnty)) +
        nrow(
          persons_df %>%
            filter(address == "abroad" & local_health_authority == cnty)
        )
    )
    locations <- st_sample(
      county_shapes %>% filter(GeoName == cnty),
      n_addresses_in_county
    )
    for (i in 1:n_addresses_in_county) {
      geolocations_df <- geolocations_df %>%
        bind_rows(
          tibble(
            county = cnty,
            longitude = locations[[i]][["lon"]],
            latitude = locations[[i]][["lat"]]
          )
        )
    }
  }
  toc()
  geolocations_df$id <- 1:nrow(geolocations_df)

  # Assign geolocations (longitude and latitude) to individual persons:
  # - Root cases (of generation "0") get a location in their county ,or
  #   for cases residing abroad, the county of the local health authority
  #   responsible, uniformly at random. For the "abroad" cases this reflects
  #   that they typically spend time around one location when visiting.
  # - Then the contacts (whether cases or not) of persons with a location are
  #   recursively assigned a location and an `address` (the corresponding
  #   county). The probability of picking a location is an exponential of the
  #   geographical distance to the index of the contact.
  # - The locations of the "abroad" cases are removed (assigned `NA`) since they
  #   don't actually reside in one of the counties.
  # To avoid complications in interpretation and visualization, locations that
  # have been assigned are removed from the list.
  id_root <- persons_df %>% filter(generation == "0") %>% pull(id)
  assigned_locations <- c()
  for (i in id_root) {

    case_county <- ifelse(
      persons_df$address[i] == "abroad",
      persons_df$local_health_authority[i],
      persons_df$address[i])

    iloc <- geolocations_df %>%
      filter(county == case_county & !id %in% assigned_locations) %>%
      pull(id) %>%
      sample(size = 1)

    persons_df$longitude[i] <- geolocations_df$longitude[iloc]
    persons_df$latitude[i] <- geolocations_df$latitude[iloc]

    assigned_locations <- c(assigned_locations, iloc)

  }

  cases_with_location <- id_root
  tic()
  while(length(cases_with_location) < nrow(persons_df)) {

    icontact <- contacts_df %>%
      filter(!id_contact %in% cases_with_location &
          id_index %in% cases_with_location) %>%
      pull(id_contact)
    if (length(icontact) > 1) {
      icontact <- sample(icontact, size = 1)
    }

    ref_location <- persons_df %>%
      filter(id == contacts_df$id_index[contacts_df$id_contact == icontact]) %>%
      select(longitude, latitude) %>%
      unlist()

    if (!is.na(persons_df$address[icontact])) {
      icandidate_locations <- geolocations_df %>%
        filter(county == persons_df$address[icontact] &
            !id %in% assigned_locations) %>%
        pull(id)
    } else {
      icandidate_locations <- geolocations_df %>%
        filter(!id %in% assigned_locations) %>%
        pull(id)
    }
    # To reduce computation time, take only a sample of all candidate locations
    icandidate_locations <- sample(
      icandidate_locations,
      size = sub_sample_size_geolocation
    )

    p_loc_dist <- sapply(
      icandidate_locations,
      function (il) {
        dist <- distm(
          c(geolocations_df$longitude[il], geolocations_df$latitude[il]),
          ref_location,
          fun = distHaversine
        )
        dexp(dist, 1/location_dist_scale)
      }
    )
    iloc <- sample(icandidate_locations, size = 1, prob = p_loc_dist)

    persons_df$longitude[icontact] <- geolocations_df$longitude[iloc]
    persons_df$latitude[icontact] <- geolocations_df$latitude[iloc]

    assigned_locations <- c(assigned_locations, iloc)
    cases_with_location <- c(cases_with_location, icontact)

  }
  toc()

  persons_df$longitude[persons_df$address == "abroad"] <- NA
  persons_df$latitude[persons_df$address == "abroad"] <- NA

  print("locations done")

  ### Events ----

  # - The number of events is a fixed fraction `frac_events_cases` of the
  #   overall number of cases, rounded, with at least one event.
  # - An event has persons (participants) that may or may be cases or contacts.
  #   Each event has at least one case (irrelevant otherwise). For each event,
  #   one case is drawn uniformly at random that participates.
  # - The number of participants is drawn from a Gaussian distribution of mean
  #   `mu_event_size` and standard deviation `sig_event_size`, cut below at
  #   `min_event_size` (included) and above at the total number of cases and
  #   contacts. Note that it means that the average and standard deviation of
  #   the number of participants is then different from `mu_event_size` and
  #   `sig_event_size`.
  # - Each participant has a probability `p_known_participant` to be already
  #   known (i.e., it is a case or a contact), the corresponding
  #   `persons_df$id` is drawn uniformly at random, with the ID of the first
  #   participating case removed.
  # - The other participants are added to the list of persons `persons_df` with
  #   `address`, `longitude` and `latitude` taken uniformly at random from
  #   the available locations in `geolocations_df`. First and family names
  #   are randomly assigned from those of `default_country`. Other information
  #   (age, sex, ...) are unknown and have value `NA`.
  # - Persons that participated in any event have value `TRUE` for the new field
  #   `was_in_event` in `persons_df`.
  # - The list of events and corresponding participant IDs is stored in
  #   `event_participants_df`.
  # - An event has fields `id`, `date`, `address` (the county where it
  #   happened), `longitude` and `latitude`. The `date` is drawn at random in
  #   the 14 days following the `infection_date` of the case drawn to be the
  #   first participant. Its `longitude` and `latitude` is the location from a
  #   sample of the available locations in `geolocations_df` that is closest to
  #   the center of mass of all participant locations (average longitude and
  #   latitude), with persons that reside abroad ignored for assigning address
  #   and location.

  n_events <- max(1,
    round(frac_events_cases * nrow(persons_df %>% filter(is_case))))

  events_df <- as_tibble(
    matrix(
      NA, nrow = 0, ncol = 5,
      dimnames = list(
        NULL,
        c("id", "date", "address", "longitude", "latitude")
      )
    )
  )
  events_df$date <- as.Date(events_df$date)
  events_df$address <- as.character(events_df$address)

  event_participants_df <- as_tibble(
    matrix(NA, nrow = 0, ncol = 3,
      dimnames = list(NULL, c("id", "id_event", "id_participant"))
    )
  )

  ievent_participants <- 1
  persons_df$was_in_event <- FALSE
  id_new_participant <- c(max(persons_df$id) + 1)

  tic()
  for (i in 1:n_events) {

    ievent <- i

    # Find first participant, who is a case. They define the date of the event,
    # are added to `event_participants_df` together with the event ID `ievent`,
    # and their value `persons_df$was_in_event` is set to `TRUE`.
    ifirst_participant <- sample(persons_df %>% filter(is_case) %>% pull(id), 1)
    first_participant_infect_date <- persons_df %>%
      filter(id == ifirst_participant) %>%
      pull(infection_date)

    eventdate <- as.Date(
      sample(
        seq(first_participant_infect_date,
          first_participant_infect_date + 14,
          by = "day"),
        1
      )
    )

    event_participants_df <- event_participants_df %>%
      bind_rows(
        tibble(id = ievent_participants, id_event = ievent,
          id_participant = ifirst_participant)
      )
    ievent_participants <- ievent_participants + 1

    persons_df$was_in_event[persons_df$id == ifirst_participant] <- TRUE

    # Define event size
    event_size <- 0
    while(event_size < min_event_size |
        event_size > nrow(persons_df %>% filter(is_case | has_contact))) {
      event_size <- round(rnorm(1, mu_event_size, sig_event_size))
    }

    # Find further known participants (case or contact)
    ifurther_known_participants_candidates <- persons_df %>%
      filter(id != ifirst_participant & (is_case | has_contact)) %>%
      pull(id)

    n_further_known_participants <- min(
      rbinom(1, event_size-1, prob = p_known_participant),
      length(ifurther_known_participants_candidates)
    )

    ifurther_known_participants <- c()
    if (n_further_known_participants > 0) {
      ifurther_known_participants <- sample(
        ifurther_known_participants_candidates,
        n_further_known_participants
      )
      event_participants_df <- event_participants_df %>%
        bind_rows(
          tibble(
            id = seq(
              ievent_participants,
              ievent_participants + length(ifurther_known_participants) - 1
            ),
            id_event = ievent,
            id_participant = ifurther_known_participants
          )
        )
      ievent_participants <- ievent_participants +
        length(ifurther_known_participants)
      persons_df$was_in_event[persons_df$id %in% ifurther_known_participants] <- TRUE
    }

    # Add new persons who are the rest of the participants
    n_missing_participants <- event_size - 1 - n_further_known_participants
    inew_part <- c()
    if (n_missing_participants > 0) {
      for (j in 1:n_missing_participants) {
        inew_part <- c(inew_part, max(id_new_participant) + 1)
        id_new_participant <- c(id_new_participant, max(id_new_participant) + 1)
      }

      event_participants_df <- event_participants_df %>%
        bind_rows(
          tibble(
            id = seq(
              ievent_participants,
              ievent_participants + length(inew_part) - 1
            ),
            id_event = ievent,
            id_participant = inew_part
          )
        )
      ievent_participants <- ievent_participants + length(inew_part)

      # Add new participants (who are neither case or contact) to `persons_df`
      # with `id`, `first_name`, `family_name`, `address`, `longitude`,
      # `latitude` and `was_in_event`, the other fields filled with `NA`
      particip_loc_ids <- c()
      for (j in 1:length(inew_part)) {
        particip_loc_ids <- c(
          particip_loc_ids,
          sample(# We assume here that there will always be at least 2 available
            # locations
            geolocations_df %>% filter(!id %in% assigned_locations) %>% pull(id),
            1
          )
        )
        assigned_locations <- c(assigned_locations, tail(particip_loc_ids, 1))
      }
      tmp_particip_persons_df <- as_tibble(
        matrix(NA, nrow = length(inew_part), ncol = ncol(persons_df),
          dimnames = list(NULL, names(persons_df)))
      )
      tmp_particip_persons_df$id <- inew_part
      tmp_particip_persons_df$first_name <- GetFirstName(
        first_names,
        rep(default_country, length(inew_part)),
        sample(c("w", "m"), length(inew_part), replace = TRUE)
      )
      tmp_particip_persons_df$family_name <- GetFamilyName(
        family_names, rep(default_country, length(inew_part))
      )
      tmp_particip_persons_df$address <- geolocations_df %>%
        filter(id %in% particip_loc_ids) %>%
        pull(county)
      tmp_particip_persons_df$longitude <- geolocations_df %>%
        filter(id %in% particip_loc_ids) %>%
        pull(longitude)
      tmp_particip_persons_df$latitude <- geolocations_df %>%
        filter(id %in% particip_loc_ids) %>%
        pull(latitude)
      tmp_particip_persons_df$was_in_event <- TRUE

      persons_df <- persons_df %>% bind_rows(tmp_particip_persons_df)

    }

    # Add event to event list with address and location closest to center of
    # mass of all participants
    mean_participants_longitude <- persons_df %>%
      filter(id %in% c(ifirst_participant, ifurther_known_participants,
        inew_part)) %>%
      pull(longitude) %>%
      mean(na.rm = TRUE)
    mean_participants_latitude <- persons_df %>%
      filter(id %in% c(ifirst_participant, ifurther_known_participants,
        inew_part)) %>%
      pull(latitude) %>%
      mean(na.rm = TRUE)
    # We assume there are more than `sub_sample_size_geolocation` locations
    # still available
    sample_available_loc_id <- sample(
      geolocations_df %>% filter(!id %in% assigned_locations) %>% pull(id),
      sub_sample_size_geolocation
    )
    sample_distances_to_center_mass <- sapply(
      sample_available_loc_id,
      function (il)
        distm(
          c(geolocations_df %>% filter(id == il) %>%
              pull(longitude),
            geolocations_df %>% filter(id == il) %>%
              pull(latitude)
          ),
          c(mean_participants_longitude, mean_participants_latitude),
          fun = distHaversine
        )
    )
    event_loc_id <- sample_available_loc_id[
      which(sample_distances_to_center_mass ==
          min(sample_distances_to_center_mass))
    ]

    events_df <- events_df %>%
      bind_rows(
        tibble(
          id = ievent,
          date = eventdate,
          address = geolocations_df %>%
            filter(id == event_loc_id) %>%
            pull(county),
          longitude = geolocations_df %>%
            filter(id == event_loc_id) %>%
            pull(longitude),
          latitude = geolocations_df %>%
            filter(id == event_loc_id) %>%
            pull(latitude)
        )
      )

  }
  toc()

  print("events done")

  # Quality check: every person should be at least one of case, contact or
  # participant
  quality_check <- identical(
    persons_df %>% filter(is_case | has_contact | was_in_event),
    persons_df
  )
  if (!quality_check) {
    stop("There are persons who are neither a case, a contact or a participant!")
  }

  ### Graph components ----
  # For nodes without coordinates, assign longitude and latitude of the upper
  # left corner of the bounding box of the county shapes (xmin resp. ymax).

  tic()
  # Build nodes, transform longitude and latitude to sf point objects
  nnodes <- bind_rows(
    persons_df %>%
      rename(date = infection_date) %>%
      mutate(
        id = as.character(id),
        root_case = (generation == "0"),
        type = case_when(
          is_case ~ "case",
          !is_case & (id %in% contacts_df$id_contact) ~ "contact",
          TRUE ~ "participant"
        ),
        longitude = ifelse(
          is.na(longitude),
          attributes(county_shapes$geometry)$bbox$xmin *
            (1 + 0.005*abs(rnorm(nrow(persons_df)))),
          longitude
        ),
        latitude = ifelse(
          is.na(latitude),
          attributes(county_shapes$geometry)$bbox$ymax *
            (1 - 0.0015*abs(rnorm(nrow(persons_df)))),
          latitude
        )
      ) %>%
      select(id, type, root_case, date, longitude, latitude),
    events_df %>%
      mutate(id = paste0("e", id), type = "event", root_case = NA) %>%
      select(id, type, root_case, date, longitude, latitude)
  ) %>%
    st_as_sf(coords = c('longitude', 'latitude'))

  # Build edges
  nedges <- bind_rows(
    contacts_df %>%
      mutate(
        from = as.character(id_index),
        to = as.character(id_contact)
      ) %>%
      select(from, to),
    event_participants_df %>%
      mutate(
        id_event = paste0("e", id_event),
        from = as.character(id_event),
        to = as.character(id_participant)
      ) %>%
      select(from, to)
  ) %>%
    left_join(nnodes %>% select(id, geometry), by = c("from" = "id")) %>%
    rename(from_geometry = geometry) %>%
    left_join(nnodes %>% select(id, geometry), by = c("to" = "id")) %>%
    rename(to_geometry = geometry)

  # Transform `from` and `to` longitudes and latitudes to sf linepoint objects
  eg <- st_sfc(
    lapply(
      1:nrow(nedges),
      function (i)
        st_linestring(x = matrix(
          c(st_coordinates(nedges[i, ]$from_geometry),
            st_coordinates(nedges[i, ]$to_geometry)),
          ncol = 2, byrow = TRUE
        ))
    )
  )
  nedges <- bind_cols(nedges, st_sf(geometry = eg)) %>%
    select(from, to, geometry)

  # Build the graph
  network_graph <- tbl_graph(nodes = nnodes, edges = nedges, directed = TRUE) %>%
    activate(nodes) %>%
    mutate(degree = centrality_degree())
  toc()
  print("clusters done")

  ### Save and export data ----
  # As RDS, two CSV formats, and Excel

  # Persons
  saveRDS(persons_df, here(data_dir, "out/persons_df.rds"))
  write.csv(persons_df, here(data_dir, "out/persons_df-format1.csv"),
    row.names = FALSE, fileEncoding = "UTF-8")
  write.csv2(persons_df, here(data_dir, "out/persons_df-format2.csv"),
    row.names = FALSE, fileEncoding = "UTF-8")
  write.xlsx(persons_df, here(data_dir, "out/persons_df-format3.xlsx"),
    rowNames = FALSE)

  # Symptoms
  saveRDS(symptoms_cases_df, here(data_dir, "out/symptoms_cases_df.rds"))
  write.csv(symptoms_cases_df,
    here(data_dir, "out/symptoms_cases_df-format1.csv"), row.names = FALSE,
    fileEncoding = "UTF-8")
  write.csv2(symptoms_cases_df,
    here(data_dir, "out/symptoms_cases_df-format2.csv"), row.names = FALSE,
    fileEncoding = "UTF-8")
  write.xlsx(symptoms_cases_df,
    here(data_dir, "out/symptoms_cases_df-format3.xlsx"), rowNames = FALSE)

  # Contacts
  saveRDS(contacts_df, here(data_dir, "out/contacts_df.rds"))
  write.csv(contacts_df, here(data_dir, "out/contacts_df-format1.csv"),
    row.names = FALSE, fileEncoding = "UTF-8")
  write.csv2(contacts_df, here(data_dir, "out/contacts_df-format2.csv"),
    row.names = FALSE, fileEncoding = "UTF-8")
  write.xlsx(contacts_df, here(data_dir, "out/contacts_df-format3.xlsx"),
    rowNames = FALSE)

  # Events
  saveRDS(events_df, here(data_dir, "out/events_df.rds"))
  write.csv(events_df, here(data_dir, "out/events_df-format1.csv"),
    row.names = FALSE, fileEncoding = "UTF-8")
  write.csv2(events_df, here(data_dir, "out/events_df-format2.csv"),
    row.names = FALSE, fileEncoding = "UTF-8")
  write.xlsx(events_df, here(data_dir, "out/events_df-format3.xlsx"),
    rowNames = FALSE)

  # Event participants
  saveRDS(event_participants_df, here(data_dir, "out/event_participants_df.rds"))
  write.csv(event_participants_df,
    here(data_dir, "out/event_participants_df-format1.csv"), row.names = FALSE,
    fileEncoding = "UTF-8")
  write.csv2(event_participants_df,
    here(data_dir, "out/event_participants_df-format2.csv"), row.names = FALSE,
    fileEncoding = "UTF-8")
  write.xlsx(event_participants_df,
    here(data_dir, "out/event_participants_df-format3.xlsx"), rowNames = FALSE)

  # Clusters
  saveRDS(network_graph, here(data_dir, "out/network_graph.rds"))

} else {

  persons_df <- readRDS(here(data_dir, "out/persons_df.rds"))
  symptoms_cases_df <- readRDS(here(data_dir, "out/symptoms_cases_df.rds"))
  contacts_df <- readRDS(here(data_dir, "out/contacts_df.rds"))
  events_df <- readRDS(here(data_dir, "out/events_df.rds"))
  event_participants_df <- readRDS(here(data_dir,
    "out/event_participants_df.rds"))
  network_graph <- readRDS(here(data_dir, "out/network_graph.rds"))

}

### Plots ----

# Case counts as functions of reporting, onset and infection dates
case_count_ts <- persons_df %>%
  filter(is_case) %>%
  select(reporting_date, onset_date, infection_date) %>%
  pivot_longer(
    cols = everything(), names_to = "date_type", values_to = "date"
  ) %>%
  group_by(date_type, date) %>%
  summarize(count = n()) %>%
  ungroup()
all_dates <- NULL
for (dtype in c("reporting_date", "onset_date", "infection_date")) {
  all_dates <- all_dates %>%
    bind_rows(
      tibble(
        date_type = dtype,
        date = seq(min(case_count_ts$date), max(case_count_ts$date), by = "day")
      )
    )
}
case_count_ts_full <- case_count_ts %>%
  right_join(all_dates, by=c("date_type", "date")) %>%
  mutate(count = ifelse(is.na(count), 0, count)) %>%
  arrange(date_type, date)

case_count_ts_plot <- ggplot(case_count_ts_full,
  aes(date, count, color=date_type)) +
  geom_line() +
  scale_color_manual(values = vega_colors) +
  ggtitle("Count time series from individual cases") +
  labs(color = "date type") +
  theme_bw()
ggsave(case_count_ts_plot, filename = here(img_dir, "case_count_ts_plot.pdf"),
  width = 20, height = 15, units = "cm")

# Reproduction number Rt as read from the infection degree
Rt_df <- persons_df %>%
  filter(is_case) %>%
  select(infection_date, degree) %>%
  group_by(infection_date) %>%
  summarise(Rt = mean(degree)) %>%
  ungroup() %>%
  right_join(
    tibble(infection_date =
        seq(min(case_count_ts$date), max(case_count_ts$date), by = "day")
    )
  ) %>%
  mutate(Rt = ifelse(is.na(Rt), 0, Rt)) %>%
  arrange(infection_date)
Rt_df$Rt_mean <- c(
  rep(NA, 3),
  rollmean(Rt_df$Rt, 7, align = "center"),
  rep(NA, 3)
)
Rt_df$Rt_sd <- c(
  rep(NA, 3),
  rollapply(Rt_df$Rt, 7, sd, align = "center"),
  rep(NA, 3)
)

Rt_plot <- ggplot(Rt_df, aes(x=infection_date)) +
  geom_ribbon(aes(ymin = pmax(0, Rt_mean-Rt_sd), ymax = Rt_mean+Rt_sd),
    fill = "grey75", alpha = 0.5) +
  geom_line(aes(y=Rt), color = "black", size = 0.3) +
  geom_line(aes(y=Rt_mean), color = vega_colors[1], size = 1) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  ggtitle(
    "Reproduction number from community infection degree",
    subtitle = paste0(
      "ignores the imported cases, i.e. without known index case\n",
      "with 7-day rolling mean +/- 1 standard deviation"
    )
  ) +
  labs(y = "R community") +
  theme_bw()
ggsave(Rt_plot, filename = here(img_dir, "Rt_plot.pdf"),
  width = 20, height = 15, units = "cm")

# Infection degree distribution with mean, median and dispersion index
# D = var/mu
degrees <- persons_df %>% filter(is_case) %>% select(degree)
n_infections_cases <- contacts_df %>%
  filter(is_infection) %>%
  group_by(id_index) %>%
  count() %>%
  arrange(desc(n))
n_infections_cases$cumul_n <- cumsum(n_infections_cases$n)
frac_cases_80pct_infections <- max(
  which(n_infections_cases$cumul_n <= 0.8 * sum(contacts_df$is_infection))
) / sum(persons_df$is_case, na.rm = TRUE)
degrees_plot <- ggplot(degrees, aes(degree)) +
  geom_bar(color = "black", fill = vega_colors[1],
    size = 0.5) +
  ggtitle(
    "Infection degree distribution",
    subtitle = paste0(
      "mean = ", signif(mean(degrees$degree), 2),
      ", median = ", signif(median(degrees$degree), 2),
      ", dispersion index D = var/µ = ",
      signif(var(degrees$degree)/mean(degrees$degree), 2),
      "\n",
      round(100*frac_cases_80pct_infections),
      "% of cases cause 80% of infections"
    )
  ) +
  theme_bw()
ggsave(degrees_plot,
  filename = here(img_dir, "degrees_plot.pdf"),
  width = 20, height = 15, units = "cm")

# Individual clusters, in abstract, in time (phylotree, dist = time between
# infections or geographical distance), in space
# TODO: write a function instead of repeating the code for plotting the graphs
node_colors <- vega_colors[1:4]
names(node_colors) <- c("case", "contact", "event", "participant")

# Overall network of cases, with and without their contacts
case_ids <- persons_df %>% filter(is_case) %>% pull(id)
network_cases <- network_graph %>% activate(nodes) %>% filter(id %in% case_ids)

cases_graph_plot <- ggraph(network_cases, layout = "igraph",
  algorithm = "nicely") +
  geom_edge_fan(show.legend = FALSE, color = "black",
    aes(alpha = stat(index))) +
  geom_node_point(aes(color = type, fill = root_case), size = 1,
    shape = 21, stroke = 0.1) +
  scale_color_manual(values = node_colors) +
  scale_fill_manual(values = list("TRUE" = vega_colors[1],
    "FALSE" = rgb(0, 0, 0, 0), na.value = rgb(0, 0, 0, 0))) +
  ggtitle("Network of cases",
    subtitle = paste("size =", length(unique(case_ids)))) +
  theme_graph(foreground = "black", fg_text_colour = "white",
    base_family = "", title_face = "plain", title_size = "")
ggsave(cases_graph_plot,
  filename = here(img_dir, "cases_graph.pdf"),
  width = 20, height = 15, units = "cm")

case_contact_ids <- contacts_df %>% filter(id_index %in% case_ids) %>%
  pull(id_contact)
network_cases_contacts <- network_graph %>% activate(nodes) %>%
  filter(id %in% c(case_ids, case_contact_ids))

cases_contacts_graph_plot <- ggraph(network_cases_contacts, layout = "igraph",
  algorithm = "nicely") +
  geom_edge_fan(show.legend = FALSE, color = "black",
    aes(alpha = stat(index))) +
  geom_node_point(aes(color = type, fill = root_case), size = 1,
    shape = 21, stroke = 0.1) +
  scale_color_manual(values = node_colors) +
  scale_fill_manual(values = list("TRUE" = vega_colors[1],
    "FALSE" = rgb(0, 0, 0, 0), na.value = rgb(0, 0, 0, 0))) +
  ggtitle("Network of cases and their contacts",
    subtitle = paste("size =", length(unique(c(case_ids, case_contact_ids))))) +
  theme_graph(foreground = "black", fg_text_colour = "white",
    base_family = "", title_face = "plain", title_size = "")
ggsave(cases_contacts_graph_plot,
  filename = here(img_dir, "cases_contacts_graph_plot.pdf"),
  width = 20, height = 15, units = "cm")

# Cases and there contacts for one infection date `infectdate`
infectdate <- as.Date("2020-3-20")
case_id_infectdate <- persons_df %>%
  filter(infection_date == infectdate) %>%
  pull(id)
contact_id_infectdate <- contacts_df %>%
  filter(id_index %in% case_id_infectdate & !is_infection) %>%
  pull(id_contact)
graph_infectdate <- network_graph %>%
  activate(nodes) %>%
  filter(id %in% c(case_id_infectdate, contact_id_infectdate))

graph_infectdate_plot <- ggraph(graph_infectdate, layout = "igraph",
  algorithm = "nicely") +
  geom_edge_fan(show.legend = FALSE, color = "black", aes(alpha = stat(index))) +
  geom_node_point(aes(color = type, size = degree, fill = root_case),
    shape = 21, stroke = 1.5) +
  scale_color_manual(values = node_colors) +
  scale_fill_manual(values = list("TRUE" = vega_colors[1],
    "FALSE" = rgb(0, 0, 0, 0), na.value = rgb(0, 0, 0, 0))) +
  ggtitle(paste("Cases infected on", infectdate, "and their contacts")) +
  theme_graph(foreground = "black", fg_text_colour = "white",
    base_family = "", title_face = "plain", title_size = "")
ggsave(graph_infectdate_plot,
  filename = here(img_dir, paste0("graph_infectdate-", infectdate,
    ".pdf")),
  width = 20, height = 15, units = "cm")

# Explore graph components
network_components <- components(network_graph)
components_list <- split(
  network_graph %>% activate(nodes) %>% pull(id),
  network_components$membership
)
components_with_event <- names(components_list)[which(unlist(
  lapply(components_list, function (cl) any(grepl("e", cl)))
))]

# Component sizes
csize_plot <- ggplot(network_components$csize %>% as_tibble() %>%
    rename(component_size = value), aes(component_size)) +
  geom_histogram(color = "black", fill = vega_colors[1], size = 0.5, bins = 40) +
  ggtitle(
    "Component size distribution",
    subtitle = paste0(
      "including cases, contacts, events and participants\n",
      "mean = ", signif(mean(network_components$csize), 2),
      ", median = ", signif(median(network_components$csize), 2),
      ", dispersion index D = var/µ = ",
      signif(var(network_components$csize)/mean(network_components$csize), 2)
    )
  ) +
  theme_bw()
ggsave(csize_plot, filename = here(img_dir, "csize_plot.pdf"), width = 20,
  height = 15, units = "cm")

# Individual components
tic()
for (graphcomp in c("all", names(components_list))) {

  dir.create(here(img_dir, paste0("components/", graphcomp)),
    showWarnings = FALSE, recursive = TRUE)

  # Select a component
  if (graphcomp == "all") {
    subnetwork_component <- network_graph
    comp_size <- network_graph %>% activate(nodes) %>% as_tibble() %>% nrow()
  } else {
    subnetwork_component <- network_graph %>%
      activate(nodes) %>%
      filter(id %in% components_list[[graphcomp]])
    comp_size <- length(components_list[[graphcomp]])
  }

  # Plot graph in an abstract space
  abstract_graph <- ggraph(subnetwork_component, layout = "igraph",
    algorithm = "nicely") +
    geom_edge_fan(show.legend = FALSE, color = "black",
      aes(alpha = stat(index))) +
    geom_node_point(aes(color = type, size = degree, fill = root_case),
      shape = 21, stroke = 1.5) +
    scale_color_manual(values = node_colors) +
    scale_fill_manual(values = list("TRUE" = vega_colors[1],
      "FALSE" = rgb(0, 0, 0, 0), na.value = rgb(0, 0, 0, 0))) +
    ggtitle(paste("Component", graphcomp),
      subtitle = paste0("size = ", comp_size,
        ifelse(graphcomp == "all", ", solitary cases excluded", ""))) +
    theme_graph(foreground = "black", fg_text_colour = "white",
      base_family = "", title_face = "plain", title_size = 14)
  ggsave(abstract_graph,
    filename = here(img_dir, paste0("components/", graphcomp,
      "/abstract_graph.pdf")),
    width = 20, height = 15, units = "cm")

  # Show underlying map: interactive
  geo_graph_leaflet <- tm_shape(county_shapes) +
    tm_borders(lwd = 2) +
    tm_shape(subnetwork_component %>% activate(edges) %>% as_tibble() %>%
      st_as_sf() %>% st_set_crs(4326)) +
    tm_lines(col = "grey60")
  for(ntype in c("case", "contact", "event", "participant")) {
    if (nrow(subnetwork_component %>% activate(nodes) %>%
        filter(type == ntype) %>% as_tibble()) > 0) {
      geo_graph_leaflet <- geo_graph_leaflet +
        tm_shape(subnetwork_component %>% activate(nodes) %>%
          filter(type == ntype) %>% as_tibble() %>% st_as_sf() %>%
          st_set_crs(4326)) +
        tm_dots(col = node_colors[[ntype]], size = 0.1)
    }
  }
  geo_graph_leaflet <- geo_graph_leaflet +
    tmap_options(basemaps = 'OpenStreetMap', basemaps.alpha = 0.5)
  geo_graph_leaflet <- tmap_leaflet(geo_graph_leaflet, mode = "view")
  htmlwidgets::saveWidget(geo_graph_leaflet,
    file = here(img_dir, paste0("components/", graphcomp,
      "/subnetwork_component.html")))

  # Show underlying map: static
  # Method 1: save PNG from Leaflet widget
  # webshot::install_phantomjs()
  webshot::webshot(
    here(img_dir, paste0("components/", graphcomp,
      "/subnetwork_component.html")),
    here(img_dir, paste0("components/", graphcomp,
      "/subnetwork_component.png"))
  )

  # Method 2: query map and draw with ggplot
  bb_counties <- bb(county_shapes)
  names(bb_counties) <- c("left", "bottom", "right", "top")
  county_map <- get_map(bb_counties)
  geo_graph_map <- ggmap(county_map) +
    geom_raster(hjust = 0, vjust = 0, fill = "white", alpha = 0.5) +
    geom_sf(data = county_shapes, fill = NA, inherit.aes = FALSE) +
    geom_sf(data = subnetwork_component %>% activate(edges) %>% as_tibble() %>%
        st_as_sf() %>% st_set_crs(4326), color = "grey60", inherit.aes = FALSE) +
    geom_sf(data = subnetwork_component %>% activate(nodes) %>% as_tibble() %>%
        st_as_sf() %>% st_set_crs(4326), aes(color = type, size = degree,
          fill = root_case),
      shape = 21, stroke = 1.5, inherit.aes = FALSE) +
    scale_color_manual(values = node_colors) +
    scale_fill_manual(values = list("TRUE" = vega_colors[1],
      "FALSE" = rgb(0, 0, 0, 0), na.value = rgb(0, 0, 0, 0))) +
    ggtitle(paste("Component", graphcomp),
      subtitle = paste0("size = ", comp_size,
        ifelse(graphcomp == "all", ", solitary cases excluded", ""))) +
    theme_bw() +
    theme(panel.grid = element_blank())
  ggsave(geo_graph_map,
    filename = here(img_dir, paste0("components/", graphcomp,
      "/geo_graph_map.pdf")),
    width = 20, height = 15, units = "cm")
}
toc()

