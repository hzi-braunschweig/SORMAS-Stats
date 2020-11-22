
# This function connects to the sormas db generate the data specified by issue https://github.com/hzi-braunschweig/SORMAS-Stats/issues/87

# DB_USER = "sormas_user"
# DB_PASS = "password"
# DB_HOST = "127.0.0.1"
# DB_PORT = "5432"
# DB_NAME= "sormas"
# 
# library(RPostgreSQL)
# library(DBI)
# library(lubridate)
# library(dplyr)
# sormas_db = dbConnect(PostgreSQL(), user=DB_USER,  dbname=DB_NAME, password = DB_PASS, host=DB_HOST, port=DB_PORT) # should be replaced when doin gpull request
#load("fixBirthDate.R") # to load this method

# infectorInfecteeExport require fixBirthDate.R, libraries mentioned above and connection to db (sormas_db), 
infectorInfecteeExport = function(sormas_db){
  # loading tables from sormas db
  # load cases
  case = dbGetQuery(
    sormas_db,
    "SELECT uuid AS case_uuid, id AS case_id, disease, reportdate AS report_date_case, creationdate AS creation_date_case, person_id AS person_id_case,
    region_id AS region_id_case, district_id AS district_id_case, caseclassification AS case_classification, caseorigin AS case_origin, symptoms_id
    FROM cases
    WHERE deleted = FALSE and caseclassification != 'NO_CASE'"
   )
  
  #load contacts
  contact = dbGetQuery(
    sormas_db,
    "SELECT uuid AS contact_uuid, id AS contact_id, caze_id AS case_id, district_id AS district_id_contact, region_id AS region_id_contact,
    person_id AS person_id_contact, reportdatetime AS report_date_contact, creationdate AS creation_date_contact, lastcontactdate AS lastcontact_date_contact,
    contactproximity AS contact_proximity, resultingcase_id, contactstatus, contactclassification
    FROM public.contact
    WHERE deleted = FALSE and caze_id IS NOT NULL and contactclassification = 'CONFIRMED'" 
    # no need to add "unconfirmed" and  "not a contact" because our focus is only on contacts that resulted to cases
    # only confirmed contacts are permitted to result to cases in app
  )
  
  #loading symptom data
  symptoms = dbGetQuery(
    sormas_db,
    "SELECT id AS symptom_id, onsetdate AS onset_date
                         from public.symptoms"
    )
  
  # load person data
  person = dbGetQuery(
    sormas_db,
    "SELECT id AS person_id, sex, birthdate_dd, birthdate_mm, birthdate_yyyy
    FROM person"
  ) 
  
  # load region
  region = dbGetQuery(
    sormas_db,
    "SELECT id AS region_id, name AS region_name
    FROM public.region
    WHERE archived = FALSE"
  ) 
  
  # load district
  district = dbGetQuery(
    sormas_db,
    "SELECT id AS district_id, name AS district_name
    FROM district
    WHERE archived = FALSE"
  )

## clean-up tables 
## fixing date formats for case,  contacts, symptoms
  case = case %>%
    mutate(report_date_case = as.Date(format(report_date_case, "%Y-%m-%d")),
           creation_date_case = as.Date(format(creation_date_case, "%Y-%m-%d")))

  contact  = contact %>%
    mutate(report_date_contact = as.Date(format(report_date_contact, "%Y-%m-%d")) ,
           creation_date_contact = as.Date(format(creation_date_contact, "%Y-%m-%d")),
           lastcontact_date_contact = as.Date(format(lastcontact_date_contact, "%Y-%m-%d")))
  
  symptoms = symptoms %>%
    mutate(onset_date = as.Date(format(onset_date, "%Y-%m-%d")))
  
  # fixing birth date of person. 
  person = fixBirthDate(person) # This method assign the birhdate of the person as first January of the year of birth. Improvement will follow
  person = person %>%
    select(person_id, sex, date_of_birth) #dropping unused varaibles
  
  ## Obtaining dataset to the exported
  # The primary dataset to begin with is the contact since the goel is to export the contact data
  
  # Merging tables
  ret = contact %>%
    filter(resultingcase_id != "NA")  %>%  #dropping contacts that did not resulted to a case
    left_join(., case, by="case_id") %>%  # Merging contact and case data by source case or infector case id
    mutate(case_uuid_infector = case_uuid, case_id_infector= case_id,  disease_infector = disease,  report_date_infector = report_date_case,
           creation_date_case_infector = creation_date_case,  person_id_case_infector = person_id_case, region_id_case_infector = region_id_case,
           district_id_case_infector = district_id_case, case_classification_infector = case_classification, case_origin_infector = case_origin,
           symptoms_id_infector = symptoms_id, .keep = "unused" ) %>% # renaming variables ny adding infector to them
    left_join(., case, by = c( "resultingcase_id" = "case_id") ) %>%  # merging data with case table again by resulting case or infectee id
    mutate(case_uuid_infectee = case_uuid,case_id_infectee = resultingcase_id,  disease_infectee = disease,  report_date_infectee = report_date_case,
           creation_date_case_infectee = creation_date_case,  person_id_case_infectee = person_id_case, region_id_case_infectee = region_id_case,
           district_id_case_infectee = district_id_case, case_classification_infectee = case_classification, case_origin_infectee = case_origin,
           symptoms_id_infectee = symptoms_id, .keep = "unused" ) %>% # renaming variables ny adding infectee to them
    select(., -c(person_id_contact, case_uuid_infector, contact_uuid, case_uuid_infectee, disease_infectee, case_origin_infectee, region_id_case_infectee, district_id_case_infectee)) %>%  # dropping duplicates or unimportant varibles
    left_join(., person, by = c( "person_id_case_infector" = "person_id") ) %>% # merging with person table to get person details of  infector person
    mutate(sex_infector = sex, date_of_birth_infector = date_of_birth, .keep = "unused") %>% # renaming
    left_join(., person, by = c( "person_id_case_infectee" = "person_id") )  %>%  # merging with person table to get person details of  infectee person
    mutate(sex_infectee = sex, date_of_birth_infectee = date_of_birth, .keep = "unused") %>% #renaming
    left_join(., region, by = c("region_id_case_infector" = "region_id" )) %>% # merging with region table to get region details of  infector person
    left_join(., district, by = c("district_id_case_infector" = "district_id" )) %>% # merging with district table to get district details of  infector person
    mutate(region_infector = region_name, district_infector = district_name, .keep = "unused") %>% #renaming
    left_join(., symptoms, by = c("symptoms_id_infector" = "symptom_id" )) %>% #  merging with symptom table to get symptoms details of  infector person
    mutate(onset_date_infector = onset_date, .keep = "unused") %>%  #renaming
    left_join(., symptoms, by = c("symptoms_id_infectee" = "symptom_id" )) %>%  # merging with symptom table to get symptoms details of  infectee person
    mutate(onset_date_infectee = onset_date, .keep = "unused") %>% # renaming
    
  # computing derived variables 
    mutate(age_at_report_infector = floor(as.numeric(report_date_infector - date_of_birth_infector)/365),
           age_at_report_infectee = floor(as.numeric(report_date_infectee - date_of_birth_infectee)/365),
           serial_interval = as.numeric(onset_date_infectee - onset_date_infector),
           incubation_Period = as.numeric(onset_date_infectee - lastcontact_date_contact),
           report_week_contact = lubridate::week(report_date_contact),
           report_month_contact = lubridate::month(report_date_contact),
           report_year_contact = lubridate::year(report_date_contact)
           ) %>%
    
  ## selecting variables to export
    select(
      # contact varibles, rendering by time will be based on report date of contact
      contact_id, report_date_contact,  report_week_contact, report_month_contact, report_year_contact, contact_proximity,
      #infector variables, rendering by disease, region and district will be based on the infrestructure of the infector
      person_id_case_infector, case_id_infector, disease_infector, 
      report_date_infector, region_infector, district_infector, case_classification_infector, case_origin_infector, 
      sex_infector, onset_date_infector, age_at_report_infector,
      #infectiee variables
      person_id_case_infectee, case_id_infectee, report_date_infectee, case_classification_infectee, sex_infectee,
      onset_date_infectee, age_at_report_infectee,
      #other variables
      serial_interval, incubation_Period
  )
  return(ret)
}








