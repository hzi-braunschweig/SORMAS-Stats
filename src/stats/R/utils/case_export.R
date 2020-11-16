source('/srv/src/R/db/sormas_db.R')

library(DBI)
library(lubridate)
library(dplyr)

fixBirthDate = function(person){
  # cases with birth year set!!!
  birthYear = person[is.na(person$birthdate_yyyy) == F, ] 
  firstJan = rep(1, nrow(birthYear))
  # if only year is set, set birth date to 1st January
  birthYear$date_of_birth = 
    as.Date(
      with(
        birthYear,
        paste(birthdate_yyyy, firstJan, firstJan, sep = "-")
      )
    )

  
  # cases with no birth date set!!!
  noBirthYear = person[is.na(person$birthdate_yyyy) == T, ]
  # null birth year
  noBirthYear$date_of_birth = rep(NA,nrow(noBirthYear)) 
  
  
  person = rbind(birthYear, noBirthYear)
  return (person)
}

caseExport = function(sormas_db){
  
  # load cases
  case = dbGetQuery(
    sormas_db,
    "SELECT uuid AS case_uuid, disease, reportdate AS report_date, creationdate AS creation_date, person_id, region_id, district_id, 
             caseclassification AS case_classification, outcome, caseorigin AS case_origin, quarantine
    FROM cases
    WHERE deleted = FALSE and caseclassification != 'NO_CASE'"
  )  
  

  # load person data
  person = dbGetQuery(
    sormas_db,
    "SELECT id AS person_id, uuid AS person_uuid, sex, occupationtype AS occupation_type, presentcondition AS present_condition, birthdate_dd, birthdate_mm, birthdate_yyyy
    FROM person"
  ) 
  

  # load region
  region = dbGetQuery(
    sormas_db,
    "SELECT id AS region_id, uuid AS region_uuid, name AS region_name
    FROM public.region
    WHERE archived = FALSE"
  ) 
  
  # load district
  district = dbGetQuery(
    sormas_db,
    "SELECT id AS district_id, uuid AS district_uuid, name AS district_name
    FROM district
    WHERE archived = FALSE"
  )
  
  case$report_date = as.Date(case$report_date, "%Y-%m-%d")
  case$creation_date = as.Date(case$creation_date, "%Y-%m-%d")
  

  person = fixBirthDate(person)

  
  # merge case and person table
  ret = merge(case, person, by="person_id", all.x = T, all.y = F)
  
  # calculate age at point when the person was a case
  ret$age_at_report = floor(as.numeric(ret$report_date - ret$date_of_birth)/365)
  
  # merge casePerson with region
  ret = merge(ret, region, by = "region_id", all.x = T, all.y = F)
  
    # merge casePersonRegion with district
  ret = merge(ret, district, by = "district_id", all.x = T, all.y = F)
  
  
  ret$report_week = lubridate::week(ret$report_date)
  ret$report_month = lubridate::month(ret$report_date)
  ret$report_year = lubridate::year(ret$report_date)
  
  #View(ret)

  ret = ret %>% select(
    case_uuid, disease, report_date, creation_date, report_year,
    report_month, report_week, case_classification, outcome, 
    case_origin, quarantine, person_uuid, sex, date_of_birth, age_at_report,
    occupation_type, present_condition, region_uuid, region_name, district_uuid, district_name  
  )


  return(ret)
}
