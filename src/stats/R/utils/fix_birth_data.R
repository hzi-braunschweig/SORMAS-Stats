# FIXME: Handle given month

fixBirthDate = function(person){
  # cases with birth year set!!!
  birthYear = person[is.na(person$birthdate_yyyy) == F, ] 
  
  firstJan = rep(1, nrow(birthYear))
  # if only year is set, set birth date to 1st January
  birthYear$date_of_birth = 
    as.Date(
      with(
        birthYear,
        paste(birthdate_yyyy, firstJan, firstJan, sep = "-")
      )
    )

  # cases with no birth date set!!!
  noBirthYear = person[is.na(person$birthdate_yyyy) == T, ]
  # null birth year
  noBirthYear$date_of_birth = rep(NA,nrow(noBirthYear)) 


  person = rbind(birthYear, noBirthYear)
  return (person)
}

