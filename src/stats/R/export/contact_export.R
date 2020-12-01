# This function connects to the sormas db and exports to contact data for contacts with known 
# source case together with their source case information and jurisdiction. 
# returned data will later be exported to sormas-stats db
# as specified by issue https://github.com/hzi-braunschweig/SORMAS-Stats/issues/97
# Dependandy utils : sormas_db, fixContactJurisdiction
# Dependancy packages: RPostgreSQL, lubridate, dplyr

contact_export <- function(sormas_db){
  # load cases
  case = dbGetQuery(
    sormas_db,
    "SELECT uuid AS case_uuid, id AS case_id, person_id AS person_id_case, region_id AS region_id_case, 
    district_id AS district_id_case, caseclassification AS case_classification, disease AS disease_case
    FROM cases
    WHERE deleted = FALSE and caseclassification != 'NO_CASE'"
  )

  # load contacts
  # caze_id IS NOT NULL required b/c returning travelers are mapped as contacts without source case
  contact = dbGetQuery(
    sormas_db,
    "SELECT uuid AS contact_uuid, id AS contact_id, caze_id AS case_id, district_id AS district_id_contact,
    disease AS disease_contact, region_id AS region_id_contact, person_id AS person_id_contact, 
    reportdatetime AS report_date_contact, lastcontactdate AS lastcontact_date_contact, contactproximity AS contact_proximity, 
    resultingcase_id, contactstatus, contactclassification, followupstatus, relationtocase
    FROM public.contact
    WHERE deleted = FALSE AND caze_id IS NOT NULL" 
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
  contact  = contact %>%
    dplyr::mutate(report_date_contact = as.Date(format(report_date_contact, "%Y-%m-%d")),
           lastcontact_date_contact = as.Date(format(lastcontact_date_contact, "%Y-%m-%d"))
  )
  # converting person ids to character for eary stacking of tables with nodes from event
  contact$person_id_contact = as.character(contact$person_id_contact )
  case$person_id_case = as.character(case$person_id_case)

  # merging data to generate the line-list of contacts
  export_contacts = contact %>%
    # Merging contact and case data by source case or infector case id
    dplyr::left_join(., case, by="case_id") %>%
    # giving contacts with missing region id the region and district id of their source cases
    fixContactJurisdiction(contCase = .) %>%
    # dropping jurisdiction id of source case
    dplyr::select(., -c(region_id_case, district_id_case )) %>%
    # merging with region table to get region details of  infector person
    dplyr::left_join(., region, by = c("region_id_contact" = "region_id" )) %>%
    # merging with district table to get district details of  infector person
    dplyr::left_join(., district, by = c("district_id_contact" = "district_id" )) %>%
    
    # export_contacts dataset has unique contacts but not unique person to person pair,
    # thus we need to filter it to het unique adges between 2 nodes
    dplyr::mutate(region_name_contact = region_name, district_name_contact = district_name, 
                  case_classification_infector = case_classification, .keep = "unused") %>%
    # dropping jurisdiction id of contacts
    dplyr::select(., -c(region_id_contact, district_id_contact ))
    
    
    return(export_contacts)
}