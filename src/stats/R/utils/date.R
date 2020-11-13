dateTimeToDate = function(x){
  temp1 = substr(x,1,10) # cut first 10 characters in the string
  temp1[temp1==""]=NA  # replace empty sub-string with NA
  return(as.Date(temp1)) # convert sub-string to R date 
}