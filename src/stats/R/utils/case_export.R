source('/srv/src/R/utils/date.R')
source('/srv/src/R/db/sormas_db.R')

library(lubridate)

fixBirthDate = function(person){
    # cases with birthdate set!!!
  perTemp = person[is.na(person$birthdate_yyyy) == F, ] 
  dm = rep(1, nrow(perTemp))
  # if only year is set, set birth date to 1st January
  perTemp$birthDate = as.Date(with(perTemp, paste(birthdate_yyyy, dm, dm, sep = "-")))

  
  # cases with no birthdate set!!!
  perTemp2 = person[is.na(person$birthdate_yyyy) == T, ]
  perTemp2$birthDate = rep(NA,nrow(perTemp2)) 
  
  person = rbind(perTemp, perTemp2)
  return (person)
}

caseExport = function(sormas_db){


  # load cases
  case = db_send_and_setch(
    sormas_db,
    "SELECT id AS case_id, disease, reportdate, creationdate, person_id, region_id, district_id, 
            caseclassification, outcome, caseorigin, quarantine
    FROM cases
    WHERE deleted = FALSE and caseclassification != 'NO_CASE'"
  )  
  

  # load person data
  person = db_send_and_setch(
    sormas_db,
    "SELECT id AS person_id, sex, occupationtype, presentcondition, birthdate_dd, birthdate_mm, birthdate_yyyy
    FROM person"
  ) 
  

  # load region
  region = db_send_and_setch(
    sormas_db,
    "SELECT id AS region_id, name AS region_name
    FROM public.region
    WHERE archived = FALSE"
  ) 
  
  # load district
  district = db_send_and_setch(
    sormas_db,
    "SELECT id AS district_id, name AS district_name
    FROM district
    WHERE archived = FALSE"
  )
  
  # converting all date formats from POSIX to date

# todo just need year, month, day
# 2020-11-09 
  case$reportdate = dateTimeToDate(case$reportdate)
  case$creationdate = dateTimeToDate(case$creationdate)
  

  person = fixBirthDate(person)

  
  # merge case and person table
  casePerson = merge(case, person, by="person_id",  all.x = T, all.y = F)
  
  # calculate age at point when the person was a case
  casePerson$age = floor(as.numeric(casePerson$reportdate - casePerson$birthDate)/365)
  
  # merge casePerson with region
  casePersonRegion = merge(casePerson, region, by = "region_id", all.x = T, all.y = F)
  
    # merge casePersonRegion with district
  casePersonRegionDist = merge(casePersonRegion, district, by = "district_id", all.x = T, all.y = F)
  
  
  casePersonRegionDist$reportweek = lubridate::week(casePersonRegion$reportdate)
  casePersonRegionDist$reportmonth = lubridate::month(casePersonRegion$reportdate)
  casePersonRegionDist$reportyear = lubridate::year(casePersonRegion$reportdate)
  
  #View(casePersonRegionDist)

  return(casePersonRegionDist)
}
