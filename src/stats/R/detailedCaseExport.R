detailedCaseExport = function(DB_USER, DB_NAME, DB_PASS, DB_HOST, DB_PORT){
  #dataCombined = ImportingUnformatedDataFromDB(DB_USER = "sormas_user", DB_PASS = "password", DB_HOST = "127.0.0.1", DB_PORT = "5432", DB_NAME= "sormas")
  con = dbConnect(PostgreSQL(), user=DB_USER,  dbname=DB_NAME, password = DB_PASS, host=DB_HOST, port=DB_PORT)
  ## reading cases
  case = dbGetQuery(con,"select distinct id, disease, reportdate, creationdate, person_id,region_id,district_id, caseclassification, epidnumber, symptoms_id, healthfacility_id,
                           outcome,caseorigin,quarantine
                           from public.cases
                           where deleted = FALSE and caseclassification != 'NO_CASE'
                          ")  
  
  ## reading contact data ###
  # excluded contacts without a source case. Including them will mess up stuffs when merging contdacts and case table
  contact = dbGetQuery(con,"select distinct id,caze_id,district_id, region_id, person_id,reportdatetime, lastcontactdate, disease,
                contactclassification,contactproximity,resultingcase_id, followupstatus, followupuntil, contactstatus
                           from public.contact
                           where deleted = FALSE and caze_id IS NOT NULL
                          ")
  
  ### reading person data  ###
  person = dbGetQuery(con,"select distinct id, sex, occupationtype, presentcondition, birthdate_dd, birthdate_mm, birthdate_yyyy
                           from public.person
                           ") 
  
  # reading region
  region = dbGetQuery(con,"select distinct id, name
                           from public.region
                           where archived = FALSE
                           ") 
  
  #loading district
  district = dbGetQuery(con,"select distinct id, name
                           from public.district
                           where archived = FALSE
                           ")
  
  #disconnect from db
  dbDisconnect(con)
  
  ## converting all date formats from POSIXct to date
  case$reportdate = dateTimeToDate(case$reportdate)
  case$creationdate = dateTimeToDate(case$creationdate)
  
  #contact
  contact$reportdatetime = dateTimeToDate(contact$reportdatetime)
  contact$lastcontactdate = dateTimeToDate(contact$lastcontactdate)
  contact$followupuntil = dateTimeToDate(contact$followupuntil)
  
  #renaming ids
  case = case %>% rename(case_id = id)
  person = person %>% rename(person_id = id)
  region = region %>%  rename(region_id = id, region_name = name)
  district = district %>%  rename(district_id = id, district_name = name)  
  
  #cleaning person table  
  #person$birthDate = as.Date(with(person, paste(birthdate_yyyy, birthdate_mm, birthdate_dd, sep = "-")), format = "%Y/%m/%d")
  perTemp = person[is.na(person$birthdate_yyyy) == F, ]
  perTemp2 = person[is.na(person$birthdate_yyyy) == T, ]
  
  dm = rep(1,nrow(perTemp))
  perTemp$birthDate = as.Date(with(perTemp, paste(birthdate_yyyy, dm, dm, sep = "-")))
  perTemp2$birthDate = rep(NA,nrow(perTemp2)) 
  person = rbind(perTemp, perTemp2)
  
  
  personVar=c( "person_id", "sex","occupationtype","presentcondition", "birthDate")  # "approximateage","approximateagetype", "birthdate_dd", "birthdate_mm", "birthdate_yyyy"
  person = person[, colnames(person) %in% personVar]
  # person = person %>% rename(person_id = id)
  #df <- subset(df, select = -c(a, c))
  
  ## mergig case and person table
  casePerson = merge(case , person, by=  "person_id",  all.x = T, all.y = F ) # to ge the casevaraibles of contacts. Contacts that
  # calculating age at point that the person was a case
  casePerson$age = as.numeric(round((casePerson$reportdate - casePerson$birthDate)/365))
  
  
  casePersonRegion = merge(casePerson, region, by = "region_id", all.x = T, all.y = F)
  #casePersonRegion$region_name = as.character(casePersonRegion$region_name)
  
  ## Adding week, monthe year  as individual colums using date of report
  casePersonRegion = casePersonRegion[casePersonRegion$reportdate > as.Date("2017-05-01"),] # deleting cases with date errors 
  
  casePersonRegion$total = rep(1, nrow(casePersonRegion))
  casePersonRegion$reportweek = week(casePersonRegion$reportdate)
  casePersonRegion$reportmonth = month(casePersonRegion$reportdate)
  casePersonRegion$reportyear = year(casePersonRegion$reportdate)
  casePersonRegion$total = rep(1, nrow(casePersonRegion))
  
  ### merging casePersonRegion with district  ##
  casePersonRegionDist = merge(casePersonRegion, district, by = "district_id", all.x = T, all.y = F)
  Var=c( "case_id", "disease", "reportdate", "creationdate",  "caseclassification", "symptoms_id", "healthfacility_id", "outcome",           
         "caseorigin", "quarantine", "sex", "occupationtype", "presentcondition", "birthDate", "age", "region_name", "district_name", "reportweek",
         "reportmonth", "reportyear"  ) 
  casePersonRegionDist = casePersonRegionDist[, colnames(casePersonRegionDist) %in% Var]
  return(casePersonRegionDist) # To do: add the code to export this table directly to the stat db here
  
}
# calling the fuction 
#dat = detailedCaseExport(DB_USER = "sormas_user", DB_PASS = "password", DB_HOST = "127.0.0.1", DB_PORT = "5432", DB_NAME= "sormas")
