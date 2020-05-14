
install.packages('rsconnect')
rsconnect::setAccountInfo(name='sormas-extension', token='986EFF594630457F580F1EB8C7808818', secret='voQGzYO+IqSH9pJVVnh/QhEKme3mnlopwLJlNzjJ')
library(rsconnect)
rsconnect::deployApp("/home/bsi17/Dropbox/sormas_2020/sormasDevelopment/dashboardShiny/sormas/sormasAppPublished")
