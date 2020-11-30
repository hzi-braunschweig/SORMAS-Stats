# FIXME this changes the data!

# fixContactJurisdiction, method assign the jurisdiction of contacts with mission region and 
# district using that of their source cases
# if both jurisdictions are missing, then the contact is deleted
fixContactJurisdiction = function(contCase){
  # contacts with missiing region_id for contact
  temp1 = contCase[is.na(contCase$region_id_contact) == T,] 
  temp2 = contCase[is.na(contCase$region_id_contact) == F,]
  # dropping contacts with missiong region of source case. This should normally not happen but 
  # is does
  temp1$region_id_contact = temp1$region_id_case
  temp1 = temp1[is.na(temp1$region_id_case)==F,]  
  temp1$district_id_contact = temp1$district_id_case
  res = rbind(temp1, temp2)
  return(res)
}
