library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyWidgets)

library(visNetwork)
library(ggplot2)
library(dplyr)
library(plotly)
library(extrafont)
library(rpart)
library(RColorBrewer)

###
# mypath = "C:/Users/bsi17/Dropbox/sormas_2020/sormasDevelopment/dashboardShiny/sormas/sormasApp" # Windows path 
mypath = "/home/bsi17/Dropbox/sormas_2020/sormasDevelopment/dashboardShiny/sormas/sormasApp"  ## ununtu path
#mypath = "/media/bsi17/Transcend/sormas_export_2020-05-07"
setwd(mypath)
sep = ";"

load("dateTimeToDate.R")
load("import.multiple.csv.files.R")
load("importDataFrontEnd.R")
load("plotNet.R")

importDataFrontEndOutput = importDataFrontEnd(mypath = mypath, sep = sep)

contRegionDist = importDataFrontEndOutput$contRegionDist
nodeLineList = importDataFrontEndOutput$nodeLineList  # id here is person id
elist = importDataFrontEndOutput$elist  # id here is contact id
siDat = importDataFrontEndOutput$siDat

save(contRegionDist , file = "contRegionDist.RData")
save(nodeLineList , file = "nodeLineList.RData")
save(elist , file = "elist.RData")
save(siDat , file = "siDat.RData")



#####################################################
dateTimeToDate = function(x)
{
  temp1 = substr(x,1,10)
  temp1[temp1==""]=NA
  return(as.Date(temp1))
}

import.multiple.csv.files<-function(mypath,mypattern,...)
{
  tmp.list.1<-list.files(mypath, pattern=mypattern)
  tmp.list.2<-list(length=length(tmp.list.1))
  for (i in 1:length(tmp.list.1)){tmp.list.2[[i]]<-read.csv(tmp.list.1[i],...)}
  names(tmp.list.2)<-tmp.list.1
  tmp.list.2
}

plotNet = function(nodeLineList, elist)
{
  defaultFont="font-family:'Open Sans', sans-serif, 'Source Sans Pro'"
  mainStyle = paste(defaultFont, "color: #6591C4", ";font-weight: 600", "font-size: 1.6em", "text-align:center;", sep="; ")
  submainStyle = paste(defaultFont, "text-align:center;", sep="; ")
  footerStyle = defaultFont
  addNodesS <- data.frame(label = c("Legend", "Healthy","Not_classified" ,"Suspected", "Probable", "Confirmed", "Not case", "1 = High risk", "2 = Low risk"), shape = "icon",
                          icon.code = c("f0c0","f007", "f007", "f007", "f007", "f007","f007", "f178", "f178"),
                          icon.size = c(0.1,25, 25, 25, 25, 25,25,25,25), icon.color = c("#0d0c0c","#17bd27", "#706c67", "#a88732", "#db890f", "#f70707","#99bd17", "#0d0c0c", "#0d0c0c"))
  
  g= visNetwork(nodeLineList, elist,  main = list(text = "Disease network diagram", style = mainStyle),
                submain = list(text = "The arrows indicate the direction of transmission", style = submainStyle), 
                footer = list(text = "Zoom in to see the person ID and contact category", style = footerStyle), 
                background = "white", annot = T, width = "100%", height = "100vh" ) %>%  # width = "100%"
    visEdges(arrows = "to", color = "black") %>% 
    visOptions(selectedBy = "Classification",highlightNearest = TRUE,nodesIdSelection = FALSE) %>% 
    visGroups(groupname = "SUSPECT", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#a88732")) %>%
    visGroups(groupname = "PROBABLE", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#db890f")) %>%
    visGroups(groupname = "CONFIRMED", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#f70707")) %>%
    visGroups(groupname = "NOT_CLASSIFIED", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#706c67" )) %>%
    visGroups(groupname = "HEALTHY", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#17bd27")) %>%
    visGroups(groupname = "NO_CASE", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#99bd17")) %>%
    addFontAwesome() %>%
    visLegend(addNodes = addNodesS, useGroups = F, position = "left", width = 0.3, ncol = 1, stepX = 100, stepY = 50) %>%  
    visPhysics(stabilization = F) %>%
    visInteraction(dragNodes = T, dragView = T, zoomView = T)
  
  print(g)
}

importDataFrontEnd = function(mypath, sep)
{ 
  dataList = import.multiple.csv.files(mypath = mypath, mypattern = ".csv$", sep = ";")
  case = dataList$cases.csv
  contact = dataList$contacts.csv
  region = dataList$regions.csv
  person = dataList$persons.csv
  district = dataList$districts.csv
  symptoms = dataList$case_symptoms.csv
  
  #filtering needed columns in symptoms table
  symptoms = symptoms[,colnames(symptoms) %in% c("id","onsetdate")]
  symptoms$onsetdate = dateTimeToDate(symptoms$onsetdate)
  ## Merging contact and region table
  
  conVar = c( "id","caze_id","district_id", "region_id", "person_id","reportdatetime", "lastcontactdate", "disease",
              "contactclassification","contactproximity","resultingcase_id")
  
  contact = contact[contact$deleted == "f" & is.na(contact$caze_id) == F ,colnames(contact) %in% conVar] # deleting contacts with missing caseid
  
  
  #defining dates as date data types 
  contact$lastcontactdate = dateTimeToDate(contact$lastcontactdate)
  contact$reportdatetime = dateTimeToDate(contact$reportdatetime)
  
  # deleting duplicate contacts ie duplicate edges linking two nodes
  # contact = distinct(contact, caze_id, person_id, .keep_all = T) # keep this for now so users can see and clean their data
  
  ## giving the region and district id of the case to contacts that have NA for region and district of contact 
  # merging contact and case table keeping only cases that have contacts becuse focus here is on contacts
  #caseVar=c("id","creationdate","disease","investigateddate","reportdate","healthfacility_id",
  #          "person_id","symptoms_id","region_id","district_id", "caseclassification",
  #          "investigationstatus","hospitalization_id", "epidata_id","epidnumber",
  #          "outcome","outcomedate","caseage")
  caseVar=c("id","disease","reportdate","person_id","region_id","district_id", "caseclassification", "outcome", "epidnumber", "symptoms_id" )
  case = case[,colnames(case) %in% caseVar]
  
  # converting date time to date 
  # case$creationdate = dateTimeToDate(case$creationdate)
  #case$investigateddate = dateTimeToDate(case$investigateddate)
  case$reportdate = dateTimeToDate(case$reportdate)
  
  # colnames(case) =  c("caze_id","creationdateCase","diseaseCase","investigateddateCase","reportdateCase","healthfacility_idCase",
  #                     "person_idCase","symptoms_idCase","region_idCase","district_idCase", "caseclassificationCase",
  #                     "investigationstatusCase","hospitalization_idCase", "epidata_idCase","epidnumberCase",
  #                   "outcomeCase","outcomedateCase","ageCase")
  case = case %>% 
    rename(caze_id = id, diseaseCase = disease, reportdateCase = reportdate, person_idCase = person_id, region_idCase = region_id,
           district_idCase = district_id, caseclassificationCase = caseclassification,  epidnumberCase = epidnumber, outcomeCase = outcome, symptoms_idCase = symptoms_id)
  
  
  contCase = merge(contact,case, by = "caze_id", all.x = T, all.y = F ) # to ge the casevaraibles of contacts. Contacts that
  
  # cases without having contacts will not show up here.
  # giving contacts with missing region id  the id of the region of the case   
  temp1 = contCase[is.na(contCase$region_id) == T,] # cotacts with missiing region_id
  temp2 = contCase[is.na(contCase$region_id) == F,]
  temp1$region_id = temp1$region_idCase
  temp1$district_id = temp1$district_idCase
  contCase = rbind(temp1, temp2)
  
  # for(i in 1:nrow(contCase))
  #  {
  #   if(is.na(contCase$region_id[i]) == T)
  #    {
  #    contCase$region_id[i] = contCase$region_idCase[i]
  #    contCase$district_id[i] = contCase$district_idCase[i]
  #  }
  
  #  }
  
  # selecting cntacts with mim set of varables needed to plot
  #minVar = c("id","caze_id","reportdatetime", "disease", "contactclassification", "region_id", "district_id", "resultingcase_id", "contactproximity" )
  #contactMinVar = contCase[, colnames(contCase) %in% minVar]
  contactMinVar = contCase
  # merging contactMinVar with region to get teh names of the regions
  
  regionVar = c("id", "name")
  region = region[region$archived == "f",colnames(region) %in% regionVar]
  colnames(region) = c("region_id", "region_name")
  
  contRegion = merge(contactMinVar,region, by = "region_id", all.x = T, all.y = F) # do not keep regions that do not have a contact
  contRegion$region_name = as.character(contRegion$region_name)
  contRegion$disease = as.character(contRegion$disease)
  contRegion$contactclassification = as.character(contRegion$contactclassification)
  contRegion$contactproximity = as.character(contRegion$contactproximity)
  
  # save(contRegion, file = "contRegion.RData")
  
  ## Merging contRegion with district table to know the district nemas of contacts
  disVar = c("id", "name")
  district = district[district$archived == "f", colnames(district) %in% disVar ]
  colnames(district) = c("district_id", "district_name")
  district$district_name = as.character(district$district_name)
  
  contRegionDist = merge(contRegion,district, by = "district_id", all.x = T, all.y = F)
  
  # deleting dupliccate contacts in contRegionDist
  # contRegionDist = distinct(contRegionDist, person_idCase, person_id, .keep_all = T)  #  keep this in plot so that users can see and clean their data
  # deleting edges linking a node to itselt
  # contRegionDist = contRegionDist[contRegionDist$person_idCase != contRegionDist$person_id,]
  
  
  #merging contRegionDist and person table to keep only persons that belongs to contRegionDist table
  
  
  #  case_id = as.character(case$caze_id)
  #  case_idCont = as.character(contRegionDist$caze_id)
  
  #adding person id of cases in contact table
  #   pIdCase = rep(NA, nrow(contRegionDist))
  #   personIdCase = case$person_id
  
  #  for(i in 1:length(case_idCont))
  #   {
  #    temp = case_idCont[i]
  #    if(is.na(temp) == T)
  #   {
  #     pIdCase[i] = NA
  #    } else{
  #      for(j in 1:length(case_id))
  #      {
  #       if(temp == case_id[j] )
  #        {
  #         pIdCase[i] = personIdCase[j]
  #       }
  #       
  #      } 
  #    }
  
  #   }
  
  
  
  ## defining contact categories based on proximity
  contRegionDist$label = NA
  contRegionDist$label[contRegionDist$contactproximity %in% c("FACE_TO_FACE_LONG","TOUCHED_FLUID","MEDICAL_UNSAVE","CLOTHES_OR_OTHER","PHYSICAL_CONTACT" )] = 1 
  contRegionDist$label[!(contRegionDist$contactproximity %in% c("FACE_TO_FACE_LONG","TOUCHED_FLUID","MEDICAL_UNSAVE","CLOTHES_OR_OTHER","PHYSICAL_CONTACT" ))] = 2
  
  # elist = data.frame(pIdCase, contRegionDist$person_id, contRegionDist$contactproximity, contRegionDist$id )
  
  elist = data.frame(contRegionDist$person_idCase, contRegionDist$person_id, contRegionDist$label, contRegionDist$id)
  colnames(elist) = c("from", "to", "label", "id")
  
  
  #status of each node or person in line list
  #get person id fro resulting case id
  personVar=c("id", "sex")
  person = person[, colnames(person) %in% personVar]
  
  contConvCase = case[case$caze_id %in% contRegionDist$resultingcase_id,] ## cases resulted from contacts
  idPersonCaseCont = unique(as.character(c(contRegionDist$person_id, contRegionDist$person_idCase, contConvCase$person_idCase))) # uniqur persons in either case or contact table
  personUnique = person[person$id %in% idPersonCaseCont,]
  
  Classification = rep("HEALTHY",nrow(personUnique)) # classification if person
  personId = personUnique$id
  # selzcting cases that belongs to cntact table or cntacts converted to cases
  idCaseUnique = unique(na.omit(c(contRegionDist$caze_id, contRegionDist$resultingcase_id)))
  caseUnique = case[case$caze_id %in% idCaseUnique, ]
  
  casPersonId = caseUnique$person_idCase # using caseUnique table, person id that belong to the set of cases in network
  personClass = as.character(caseUnique$caseclassificationCase)
  
  for( i in 1:length(Classification))
  {
    for (j in 1:nrow(caseUnique))
    {
      if(personId[i] == casPersonId[j])
      {
        Classification[i] = personClass[j]
      }
    }
  }
  
  nodeLineList = data.frame(personUnique, Classification)
  
  
  ## defining plotting parameters
  #nodesS = nodeLineList
  #edgesS = elist
  
  #deleting duplicate edges
  #elist = distinct(elist, from, to, .keep_all = T)
  # deleting edges linking a node to itselt
  # elist = elist[elist$from != elist$to,]
  
  # defining edge attributes
  #elist$label = elist$label
  elist$smooth = TRUE
  elist$dashes = TRUE
  elist$dashes[elist$label == 1] = FALSE #  using broken lines for high risk contacts
  elist$arrows = "to"
  
  # defining node attributes
  nodeLineList$group = nodeLineList$Classification
  nodeLineList$label = nodeLineList$id
  nodeLineList$value = 1
  nodeLineList$shape = c("icon")
  nodeLineList$code = c("f007")
  #nodeLineList$shadow = F, 
  
  ############### determining serial interval  ###########
  # selecting unique case id from contats table
  temp = contRegionDist[,colnames(contRegionDist) %in% c("resultingcase_id", "caze_id", "disease", "region_name", "district_name","reportdatetime" )] # these varibales are used to filter commands from ui latter
  selCases = temp[is.na(temp$resultingcase_id) == F,] # edge table with casee id for source cases and resulting cases. We only use data for cases whose contacts became cases
  uniqCaseId = unique(c(selCases$caze_id, selCases$resultingcase_id))
  
  #merging uniqCaseId with case table to know the syptom of the cases 
  temp = case[case$caze_id %in% uniqCaseId, c("caze_id", "symptoms_idCase") ]  # cases in involved in contact network
  #merging with syptoms
  caseSymp = merge(temp,symptoms, by.x = "symptoms_idCase", by.y = "id", all.x = T, all.y = F)
  caseSymp = caseSymp[, colnames(caseSymp) != "symptoms_idCase"]
  #merging caseSymp with selCases
  selCasesSympCase  = merge(selCases, caseSymp, by = "caze_id", all.x = T, all.y = F)
  selCasesSympResultCase = merge(selCasesSympCase, caseSymp, by.x = "resultingcase_id", by.y = "caze_id", all.x = T, all.y = F)
  selCasesSympResultCase$si = as.numeric(c(selCasesSympResultCase$onsetdate.y - selCasesSympResultCase$onsetdate.x))
  siDat = selCasesSympResultCase[, colnames(selCasesSympResultCase) %in% c("si","reportdatetime", "disease", "region_name","district_name" )]
  siDat = siDat[is.na(siDat$si) == F,]  # dropping missing values
  
  ######  Data export ###########
  #choosing final set of variables fror contRegionDist to be exported
  expVar = c("id", "person_id", "person_idCase", "disease","contactproximity", "lastcontactdate", "reportdatetime", "contactclassification","disease", "caseclassificationCase",
             "region_name","district_name", "outcomeCase", "caze_id") 
  contRegionDist = contRegionDist[ ,colnames(contRegionDist) %in% expVar ]
  
  return(list(contRegionDist = contRegionDist, nodeLineList = nodeLineList, elist = elist, siDat = siDat))
}

save(dateTimeToDate, file = "dateTimeToDate.R")
save(import.multiple.csv.files, file = "import.multiple.csv.files.R")
save(importDataFrontEnd, file = "importDataFrontEnd.R")
save(plotNet, file = "plotNet.R")


###############################
## importDataFrontEndOutput = 
importDataFrontEndOutput = importDataFrontEnd(mypath = mypath, sep = sep)


plotNet(nodeLineList= nodeLineList, elist = elist)




