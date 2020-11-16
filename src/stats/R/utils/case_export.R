source('/srv/src/R/utils/date.R')
source('/srv/src/R/db/sormas_db.R')

library(lubridate)

fixBirthDate = function(person){
  # cases with birth year set!!!
  birthYear = person[is.na(person$birthdate_yyyy) == F, ] 
  firstJan = rep(1, nrow(birthYear))
  # if only year is set, set birth date to 1st January
  birthYear$birthDate = 
    as.Date(
      with(
        birthYear,
        paste(birthdate_yyyy, firstJan, firstJan, sep = "-")
      )
    )

  
  # cases with no birth date set!!!
  noBirthYear = person[is.na(person$birthdate_yyyy) == T, ]
  # null birth year
  noBirthYear$birthDate = rep(NA,nrow(noBirthYear)) 
  
  
  person = rbind(birthYear, noBirthYear)
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
  
  case$reportdate =   as.Date(case$reportdate, "%Y-%m-%d")
  case$creationdate = as.Date(case$creationdate, "%Y-%m-%d")
  

  person = fixBirthDate(person)

  
  # merge case and person table
  ret = merge(case, person, by="person_id",  all.x = T, all.y = F)
  
  # calculate age at point when the person was a case
  ret$age = floor(as.numeric(ret$reportdate - ret$birthDate)/365)
  
  # merge casePerson with region
  ret = merge(ret, region, by = "region_id", all.x = T, all.y = F)
  
    # merge casePersonRegion with district
  ret = merge(ret, district, by = "district_id", all.x = T, all.y = F)
  
  
  ret$reportweek = lubridate::week(ret$reportdate)
  ret$reportmonth = lubridate::month(ret$reportdate)
  ret$reportyear = lubridate::year(ret$reportdate)
  
  #View(ret)

  return(ret)
}
