
# This function connects to the sormas db generate the data specified by issue https://github.com/hzi-braunschweig/SORMAS-Stats/issues/88
# these  data will be usfull for further statistics ralated to contacts
  
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
# load("fixBirthDate.R") # to load this method
# load("fixContactJurisdiction.R")
# fixContactJurisdiction, method assign the jurisdiction contacts with mission region and district using that of their source cases
# if both jurisdictions are missing, then the contact is deleted

# infectorInfecteeExport require fixBirthDate.R, libraries mentioned above and connection to db (sormas_db), 
contactDataExport = function(sormas_db){
  # loading tables from sormas db
  # load cases
  case = dbGetQuery(
    sormas_db,
    "SELECT uuid AS case_uuid, id AS case_id, person_id AS person_id_case, region_id AS region_id_case, reportdate AS report_date_case,
    district_id AS district_id_case, caseclassification AS case_classification, symptoms_id, disease AS disease_case
    FROM cases
    WHERE deleted = FALSE and caseclassification != 'NO_CASE'"
  )

  #load contacts
  contact = dbGetQuery(
    sormas_db,
    "SELECT uuid AS contact_uuid, id AS contact_id, caze_id AS case_id, district_id AS district_id_contact, disease AS disease_contact, region_id AS region_id_contact,
    person_id AS person_id_contact, reportdatetime AS report_date_contact, lastcontactdate AS lastcontact_date_contact, 
    contactproximity AS contact_proximity, resultingcase_id, contactstatus, contactclassification, followupstatus, followupuntil,
    relationtocase, returningtraveler AS returningtraveler_contact
    FROM public.contact
    WHERE deleted = FALSE" 
    # To include only contacts with source case id, use: WHERE deleted = FALSE and caze_id IS NOT NULL
  )
  #loading symptom data
  symptoms = dbGetQuery(
    sormas_db,
    "SELECT uuid AS symptom_uuid, id AS symptom_id, onsetdate AS onset_date
                         from public.symptoms"
  )
  # load person data
  person = dbGetQuery(
    sormas_db,
    "SELECT uuid AS person_uuid, id AS person_id
    FROM person"
  ) 
  # reading event
  events = dbGetQuery(
    sormas_db,
    "SELECT uuid AS event_uuid, id AS event_id, reportdatetime AS report_date_event, eventstatus, disease AS disease_event, typeofplace, eventlocation_id
    FROM public.events
    WHERE deleted = FALSE AND eventstatus != 'DROPPED'"
  )
  
  ## reading event participants
  eventsParticipant = dbGetQuery(
    sormas_db,
    "SELECT uuid AS event_part_uuid, id as eventPart_id, event_id, person_id AS person_id_eventPart, resultingcase_id AS resultingcaseid_eventPart
    FROM public.eventParticipant
    WHERE deleted = FALSE "
    )
  # load region
  region = dbGetQuery(
    sormas_db,
    "SELECT uuid AS region_uuid, id AS region_id, name AS region_name
    FROM public.region
    WHERE archived = FALSE"
  ) 
  # load district
  district = dbGetQuery(
    sormas_db,
    "SELECT uuid AS district_uuid, id AS district_id, name AS district_name
    FROM district
    WHERE archived = FALSE"
  )
  
  ## clean-up tables 
  ## fixing date formats for case,  contacts, symptoms
  case = case %>%
     mutate(report_date_case = as.Date(format(report_date_case, "%Y-%m-%d")))
  
  contact  = contact %>%
    mutate(report_date_contact = as.Date(format(report_date_contact, "%Y-%m-%d")),
           lastcontact_date_contact = as.Date(format(lastcontact_date_contact, "%Y-%m-%d")),
           followupuntil = as.Date(format(followupuntil, "%Y-%m-%d"))
           )
  
  symptoms = symptoms %>%
    mutate(onset_date = as.Date(format(onset_date, "%Y-%m-%d")))
  
  events = events %>%
    mutate(report_date_event = as.Date(format(report_date_event, "%Y-%m-%d")))
  
  ## Converting id to character for eary stacking of tables
  person$person_id = as.character( person$person_id )
  contact$person_id_contact = as.character(contact$person_id_contact )
  case$person_id_case = as.character( case$person_id_case)
  eventsParticipant$person_id_eventpart = as.character(eventsParticipant$person_id_eventpart)

  ### merging data to generate the line-list of contacts
  contCaseRegionDist = contact %>%
    left_join(., case, by="case_id") %>%  # Merging contact and case data by source case or infector case id
    fixContactJurisdiction(contCase = .) %>%  # giving contacts with missing region id the region and district id of their source cases
    select(., -c(region_id_case, district_id_case )) %>%  # dropping jurisdiction of source case
    left_join(., region, by = c("region_id_contact" = "region_id" )) %>% # merging with region table to get region details of  infector person
    left_join(., district, by = c("district_id_contact" = "district_id" )) %>% # merging with district table to get district details of  infector person
    mutate(region_name_contact = region_name, district_name_contact = district_name, case_classification_infector = case_classification, .keep = "unused") #renaming
  # contCaseRegionDist dataset has unique contacts but not unique person to person pair, thus we need to filter it to het unique adges between 2 nodes
 
  # Generation dataset of edges, elist, including events 
  # relationtocase
  elist = contCaseRegionDist %>%
    distinct(. , person_id_case, person_id_contact, .keep_all = T) %>% # keeping only contacts with distinct persons pair
    filter(person_id_case != person_id_contact) %>% # deleting contacts between one person and itselt and also dropping contacts wothout source cases
    select(. , c(from = person_id_case, to = person_id_contact, case_id, contact_id, resultingcase_id, region_name_contact, district_name_contact,
                contact_proximity, report_date_contact, disease_contact, case_classification_infector, relationtocase)  
           ) %>%
    mutate(
      label = case_when(
      contact_proximity %in% c("AEROSOL", "FACE_TO_FACE_LONG","TOUCHED_FLUID","MEDICAL_UNSAVE","CLOTHES_OR_OTHER","PHYSICAL_CONTACT" ) ~ 1,
      !(contact_proximity %in% c("AEROSOL", "FACE_TO_FACE_LONG","TOUCHED_FLUID","MEDICAL_UNSAVE","CLOTHES_OR_OTHER","PHYSICAL_CONTACT" )) ~ 2 
                            ), # assiginh 2 to missing and all other contact proximities not listed here
      dashes = case_when(label == 1 ~ FALSE,
                         label == 2 ~ TRUE
                          ), #defining broken lines fro high risk contact based on con tact procimity or label
      smooth = TRUE,
      arrows = "to", .keep = "unused"
       ) 

  # Defining nodes data and their attributes 
  contConvertedCase = elist %>%
    filter(resultingcase_id != 'NA') %>%
    left_join(., case,  c( "resultingcase_id" = "case_id")) %>%
    select(., c( from = person_id_case, case_classification_infector = case_classification) )  %>%  # 
  mutate(from = as.character(from), .keep = "unused")
   # person case classification fro resulting cases
  #  c( to, case_classification_infectee = case_classification) this is normall naming
  # above naming is to facilitate stacking later
  
  #combining nodes of all person who are either infector or infectee case
  nodesCasePersons = elist %>% 
    select(., c(from, case_classification_infector )) %>% 
    bind_rows(., contConvertedCase ) %>%
    distinct(from, .keep_all = TRUE ) # person id and case classificatiion of all nodes that are cases
  
  # obtaining combined nodes from contact table and defining their group attributes
  nodeLineList = elist %>%   # conmbined nodes fro all network
    select(., c(to, case_classification_infector )) %>%
    filter(!(to %in% contConvertedCase$from) ) %>%  # filter contact persons that did not become cases
    distinct(to, .keep_all = TRUE )  %>% # keeping only distinct person 
    mutate( from = to, case_classification_infector = "HEALTHY", .keep = "unused" ) %>% #
    bind_rows(., nodesCasePersons )  %>%  # combinig healthy and case nodes
    # nodeLineList$group = nodeLineList$Classification
    mutate(id = from,
           value = 1,
           shape = "icon",
           code = "f007",
           group = case_classification_infector,
           .keep = "unused"
           ) %>% # merge with person table to get the person_uuid of each node
    left_join(., person,  c( "id" = "person_id"))

  # At this point, we have buit the nodeLineList and elist onjects using only contact data as base.
  # We will now do the same thing for events and then stack them to have the complate transmission chain 
  # of cases, contacts and events
  # in theis transformation, we map source case person  node to event, contacts to event participants and resulting  case node to resulting case node
  # evet participant that do not result to cases are not included at this stage
  
  elistEvent = eventsParticipant %>%
    distinct(., event_id, person_id_eventpart , .keep_all = TRUE )  %>% # randomly deleting the one pair of the same person created twice in an event
    filter(resultingcaseid_eventpart != 'NA') %>% # keeping only event part that resulted to cases
    left_join(. , case,  c( "resultingcaseid_eventpart" = "case_id")) %>%
    filter(person_id_case != 'NA') %>%  # dropping resulting cases that were later deleted.  When resulting case from ep is deleted, the resulting case id is not deleted on the ep table
    left_join(. , events,  c( "event_id" = "event_id")) %>% # merge with event
    left_join(. , region,  c( "region_id_case" = "region_id")) %>% # use jurisdiction  of resulting case as referece
    left_join(., district, by = c("district_id_case" = "district_id" )) %>% # merging with district table to get district details
    mutate(from = event_uuid, to = as.character(person_id_case), case_id = resultingcaseid_eventpart, contact_id = eventpart_id,
           resultingcase_id = resultingcaseid_eventpart, region_name_contact = region_name, district_name_contact = district_name,
           report_date_contact = report_date_event, disease_contact = disease_case,
           case_classification_infector  = "CONFIRMED", case_classification_infectee = case_classification,
           relationtocase = "EVENT",
           label = 1,
           dashes = FALSE,
           smooth = TRUE,
           arrows = "to",   
           .keep = "none") # mappping to produce a similar data like  elist
 
  # defining node properties for event nodes
  eventNode = elistEvent %>%
  mutate(., case_classification_infector = "EVENT",
         id = from,
         value = 1,
         shape = "icon",
         code = c("f0c0"),
         group = case_classification_infector,
         .keep = "none" ) %>%
    distinct(., id , .keep_all = TRUE )
  
  # defining node properties for event part nodes. These are just person nodes
  eventPartNode = elistEvent %>%
    mutate(., case_classification_infector = case_classification_infectee,
           id = to,
           value = 1,
           shape = "icon",
           code = c("f007"),
           group = case_classification_infector,
           .keep = "none" ) %>%
    distinct(., id , .keep_all = TRUE )
  
  nodeLineListEvent =  bind_rows(eventNode, eventPartNode )  # combining event nodes and ep person nodes 
     
 # combining elist from event and elist from contact
  # delete case_classification_infectee from elistEvent before merging with elist
  elistCombined = elistEvent %>%
    select(., -c(case_classification_infectee)) %>%
    bind_rows(., elist )  %>%
    mutate(from = substr(from, 1, 6), .keep = "unused" )   # keep first 6 characters  of person id
  
  nodeListCombined =  nodeLineList  %>%
    bind_rows(. , nodeLineListEvent ) %>%
    distinct(., id , .keep_all = TRUE ) %>%
    mutate(id = substr(id, 1, 6), .keep = "unused" ) %>%   # keep first 6 characters  of person id
    select( -c(person_uuid, case_classification_infector ) ) # dropping useless varaibles
    
  return(list(contRegionDist = contCaseRegionDist, nodeLineList = nodeListCombined, elist = elistCombined)) 
}
# test run 
# contList = contactDataExport(sormas_db = sormas_db)
# contRegionDist = contList$contRegionDist
# nodeLineList = contList$nodeLineList
# elist = contList$elist
