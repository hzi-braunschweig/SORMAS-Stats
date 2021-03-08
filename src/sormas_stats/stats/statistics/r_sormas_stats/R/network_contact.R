#' This function connects to the sormas db and generates the data specified
#' by issue https://github.com/hzi-braunschweig/SORMAS-Stats/issues/88
#' the data will be usfull for further statistics ralated to contacts
#' @export
#' @import dplyr
contact_network <- function(sormas_db) {

  # load cases
  case <- DBI::dbGetQuery(
    sormas_db,
    "SELECT uuid AS case_uuid, id AS case_id, person_id AS person_id_case, region_id AS region_id_case, 
    district_id AS district_id_case, caseclassification AS case_classification, disease AS disease_case
    FROM cases
    WHERE deleted = FALSE and caseclassification != 'NO_CASE'"
  )

  # load person data
  person <- DBI::dbGetQuery(
    sormas_db,
    "SELECT uuid AS person_uuid, id AS person_id
    FROM person"
  )

  # load events
  events <- DBI::dbGetQuery(
    sormas_db,
    "SELECT uuid AS event_uuid, id AS event_id, reportdatetime AS report_date_event, eventstatus,
    disease AS disease_event, typeofplace, eventlocation_id
    FROM public.events
    WHERE deleted = FALSE AND eventstatus != 'DROPPED'"
  )

  # load event participants
  eventsParticipant <- DBI::dbGetQuery(
    sormas_db,
    "SELECT uuid AS event_part_uuid, id as eventPart_id, event_id, person_id AS person_id_eventPart, 
    resultingcase_id AS resultingcaseid_eventPart
    FROM public.eventParticipant
    WHERE deleted = FALSE"
  )

  # load regions
  region <- DBI::dbGetQuery(
    sormas_db,
    "SELECT id AS region_id, name AS region_name
    FROM public.region
    WHERE archived = FALSE"
  )

  # load districts
  district <- DBI::dbGetQuery(
    sormas_db,
    "SELECT id AS district_id, name AS district_name
    FROM district
    WHERE archived = FALSE"
  )

  con <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = 'sormas_stats',
    host = 'localhost',
    port = 5432,
    user = 'stats_user',
    password = 'password'
  )

  # load contacts
  contCaseRegionDist <- DBI::dbGetQuery(
    con,
    "SELECT person_id_cases AS person_id_case, person_id_contact,
    caze_id as case_id, id as contact_id, resultingcase_id,
    region_name as region_name_contact, district_name as district_name_contact,
    contactproximity as contact_proximity, reportdate as report_date_contact,
    disease_contact, caseclassification as case_classification_infector,
    relationtocase
    FROM stats_contacts"
  )

  # clean-up tables
  # fix date formats
  events <- events %>%
    dplyr::mutate(report_date_event = as.Date(format(report_date_event, "%Y-%m-%d")))

  # converting ids to character for eary stacking of tables 
  # this is needed because event_uuid was used, using evetid is prone to error when stacking tables
  person$person_id <- as.character(person$person_id)
  case$person_id_case <- as.character(case$person_id_case)
  eventsParticipant$person_id_eventpart <- as.character(eventsParticipant$person_id_eventpart)

  # edge list for cases and contacts
  elist <- contCaseRegionDist %>%
    # keeping only contacts with distinct persons pair
    dplyr::distinct(., person_id_case, person_id_contact, .keep_all = T) %>%
    # delete contacts between one person and itselt and also dropping contacts without source cases
    dplyr::filter(person_id_case != person_id_contact) %>%
    dplyr::select(., c(
      from = person_id_case,
      to = person_id_contact, case_id, contact_id, resultingcase_id,
      region_name_contact, district_name_contact, contact_proximity, report_date_contact,
      disease_contact, case_classification_infector, relationtocase
    )
    ) %>%
    # assign 2 to missing and all other contact proximity not listed here
    # defining broken lines for high risk contact based on contact proximity or label
    dplyr::mutate(
      label = case_when(
        contact_proximity %in% c("AEROSOL", "FACE_TO_FACE_LONG", "TOUCHED_FLUID", "MEDICAL_UNSAVE", "CLOTHES_OR_OTHER", "PHYSICAL_CONTACT") ~ 1,
        !(contact_proximity %in% c("AEROSOL", "FACE_TO_FACE_LONG", "TOUCHED_FLUID", "MEDICAL_UNSAVE", "CLOTHES_OR_OTHER", "PHYSICAL_CONTACT")) ~ 2
      ),
      dashes = case_when(label == 1 ~ FALSE,
                         label == 2 ~ TRUE
      ),
      smooth = TRUE,
      arrows = "to", .keep = "unused"
    ) %>%
    dplyr::mutate(from = as.character(from), .keep = "unused") %>%
    dplyr::mutate(to = as.character(to), .keep = "unused")

  # Defining nodes data and their attributes 
  contConvertedCase <- elist %>%
    dplyr::filter(resultingcase_id != 'NA') %>%
    dplyr::left_join(., case, c("resultingcase_id" = "case_id")) %>%
    dplyr::select(., c(from = person_id_case, case_classification_infector = case_classification)) %>%  #
    dplyr::mutate(from = as.character(from), .keep = "unused")

  # person case classification for resulting cases
  # c( to, case_classification_infectee = case_classification) this is normal naming
  # above naming is to facilitate stacking later
  # combining nodes of all person who are either infector or infectee case
  # person id and case classificatiion of all nodes that are cases
  nodesCasePersons <- elist %>%
    dplyr::select(., c(from, case_classification_infector)) %>%
    dplyr::bind_rows(., contConvertedCase) %>%
    dplyr::distinct(from, .keep_all = TRUE)

  # obtaining combined nodes from contact table and defining their group attributes
  nodeLineList <- elist %>%   # conmbined nodes for all networks
    dplyr::select(., c(to, case_classification_infector)) %>%
    # filter contact persons that did not become cases
    dplyr::filter(!(to %in% contConvertedCase$from)) %>%
    # keeping only distinct person 
    dplyr::distinct(to, .keep_all = TRUE) %>%
    dplyr::mutate(from = to, case_classification_infector = "HEALTHY", .keep = "unused") %>%
    # combinig healthy and case nodes
    dplyr::bind_rows(., nodesCasePersons) %>%
    dplyr::mutate(id = from,
                  value = 1,
                  shape = "icon",
                  code = "f007",
                  group = case_classification_infector,
                  .keep = "unused"
    ) %>%
    # merge with person table to get the person_uuid of each node
    dplyr::left_join(., person, c("id" = "person_id"))

  # At this point, we have buit the nodeLineList and elist objects using only contact data as base.
  # We will now do the same thing for events and then stack them to have the complete contact network
  # of cases, contacts and events
  # in this transformation, we map source case person  node to event, contacts to event participants and 
  # resulting  case node to resulting case node
  # evet participant that do not result to cases are not included at this stage

  elistEvent <- eventsParticipant %>%
    # randomly deleting the one pair of the same person created twice in an event
    dplyr::distinct(., event_id, person_id_eventpart, .keep_all = TRUE) %>%
    # keeping only event part that resulted to cases
    dplyr::filter(resultingcaseid_eventpart != 'NA') %>%
    dplyr::left_join(., case, c("resultingcaseid_eventpart" = "case_id")) %>%
    # dropping resulting cases that were later deleted.  When resulting case from ep is deleted, 
    # the resulting case id is not deleted on the ep table
    dplyr::filter(person_id_case != 'NA') %>%
    # merge with event 
    dplyr::left_join(., events, c("event_id" = "event_id")) %>%
    # use jurisdiction  of resulting case as referece
    dplyr::left_join(., region, c("region_id_case" = "region_id")) %>%
    # merging with district table to get district details
    dplyr::left_join(., district, by = c("district_id_case" = "district_id")) %>%
    # mappping to produce a similar data like elist
    dplyr::mutate(from = event_uuid, to = as.character(person_id_case), case_id = resultingcaseid_eventpart, contact_id = eventpart_id,
                  resultingcase_id = resultingcaseid_eventpart, region_name_contact = region_name, district_name_contact = district_name,
                  report_date_contact = report_date_event, disease_contact = disease_case,
                  case_classification_infector = "CONFIRMED", case_classification_infectee = case_classification,
                  relationtocase = "EVENT",
                  label = 1,
                  dashes = FALSE,
                  smooth = TRUE,
                  arrows = "to",
                  .keep = "none"
    )

  # define node properties for event nodes
  eventNode <- elistEvent %>%
    dplyr::mutate(
      ., case_classification_infector = "EVENT",
      id = from,
      value = 1,
      shape = "icon",
      code = "f0c0",
      group = case_classification_infector,
      .keep = "none"
    ) %>%
    dplyr::distinct(., id, .keep_all = TRUE)

  # define node properties for event part nodes. These are just person nodes
  eventPartNode <- elistEvent %>%
    dplyr::mutate(., case_classification_infector = case_classification_infectee,
                  id = to,
                  value = 1,
                  shape = "icon",
                  code = "f007",
                  group = case_classification_infector,
                  .keep = "none") %>%
    dplyr::distinct(., id, .keep_all = TRUE)

  # combine event nodes and event participant person nodes 
  nodeLineListEvent <- dplyr::bind_rows(eventNode, eventPartNode)

  # combine elist from event and elist from contact
  # delete case_classification_infectee from elistEvent before merging with elist
  elistCombined <- elistEvent %>%
    dplyr::select(., -case_classification_infectee) %>%
    dplyr::bind_rows(., elist) %>%
    # keep first 6 characters  of person id
    dplyr::mutate(from = substr(from, 1, 6), .keep = "unused")

  nodeListCombined <- nodeLineList %>%
    dplyr::bind_rows(., nodeLineListEvent) %>%
    dplyr::distinct(., id, .keep_all = TRUE) %>%
    # keep first 6 characters  of person id
    dplyr::mutate(id = substr(id, 1, 6), .keep = "unused") %>%
    # dropping useless variables
    dplyr::select(-c(person_uuid, case_classification_infector))

  return(list(nodeLineList = nodeListCombined, elist = elistCombined))
}
