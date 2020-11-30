contact_export <- function(sormas_db){
  # load cases
  case = dbGetQuery(
    sormas_db,
    "SELECT uuid AS case_uuid, id AS case_id, person_id AS person_id_case, region_id AS region_id_case, reportdate AS report_date_case,
    district_id AS district_id_case, caseclassification AS case_classification, symptoms_id, disease AS disease_case
    FROM cases
    WHERE deleted = FALSE and caseclassification != 'NO_CASE'"
  )

  # load contacts
  # caze_id IS NOT NULL required b/c returning travelers are mapped as contacts without source case
  contact = dbGetQuery(
    sormas_db,
    "SELECT uuid AS contact_uuid, id AS contact_id, caze_id AS case_id, district_id AS district_id_contact, disease AS disease_contact, region_id AS region_id_contact,
    person_id AS person_id_contact, reportdatetime AS report_date_contact, lastcontactdate AS lastcontact_date_contact, 
    contactproximity AS contact_proximity, resultingcase_id, contactstatus, contactclassification, followupstatus, followupuntil,
    relationtocase
    FROM public.contact
    WHERE deleted = FALSE AND caze_id IS NOT NULL" 
  )

  # load symptom data
  symptoms = dbGetQuery(
    sormas_db,
    "SELECT uuid AS symptom_uuid, id AS symptom_id, onsetdate AS onset_date
    FROM public.symptoms"
  )
 
  # load regions
  region = dbGetQuery(
    sormas_db,
    "SELECT id AS region_id, name AS region_name
    FROM public.region
    WHERE archived = FALSE"
  ) 

  # load districts
  district = dbGetQuery(
    sormas_db,
    "SELECT id AS district_id, name AS district_name
    FROM district
    WHERE archived = FALSE"
  )
  
  # clean-up tables 
  # fix date formats
  case = case %>%
    dplyr::mutate(report_date_case = as.Date(format(report_date_case, "%Y-%m-%d")))
  
  contact  = contact %>%
    dplyr::mutate(report_date_contact = as.Date(format(report_date_contact, "%Y-%m-%d")),
           lastcontact_date_contact = as.Date(format(lastcontact_date_contact, "%Y-%m-%d")),
           followupuntil = as.Date(format(followupuntil, "%Y-%m-%d"))
  )
  
  symptoms = symptoms %>%
    dplyr::mutate(onset_date = as.Date(format(onset_date, "%Y-%m-%d")))
  
  events = events %>%
    dplyr::mutate(report_date_event = as.Date(format(report_date_event, "%Y-%m-%d")))
  
  # converting id to character for eary stacking of tables
  person$person_id = as.character(person$person_id)
  contact$person_id_contact = as.character(contact$person_id_contact )
  case$person_id_case = as.character(case$person_id_case)
  eventsParticipant$person_id_eventpart = as.character(eventsParticipant$person_id_eventpart)

  # merging data to generate the line-list of contacts
  export_contacts = contact %>%
    # Merging contact and case data by source case or infector case id
    dplyr::left_join(., case, by="case_id") %>%
    # giving contacts with missing region id the region and district id of their source cases
    fixContactJurisdiction(contCase = .) %>%
    # dropping jurisdiction of source case
    dplyr::select(., -c(region_id_case, district_id_case )) %>%
    # merging with region table to get region details of  infector person
    dplyr::left_join(., region, by = c("region_id_contact" = "region_id" )) %>%
    # merging with district table to get district details of  infector person
    dplyr::left_join(., district, by = c("district_id_contact" = "district_id" )) %>%
    
    # export_contacts dataset has unique contacts but not unique person to person pair,
    # thus we need to filter it to het unique adges between 2 nodes
    dplyr::mutate(region_name_contact = region_name, district_name_contact = district_name, case_classification_infector = case_classification, .keep = "unused")
    
    return(export_contacts)
}