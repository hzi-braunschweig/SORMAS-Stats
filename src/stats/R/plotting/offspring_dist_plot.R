# FIXME import infector_infectee_export

offspringDistPlot = function(infectorInfecteePair){ 
  #counting the number of offsprings per infector
  offspring <- infectorInfecteePair %>%
    dplyr::select(case_id_infector) %>%
    group_by(case_id_infector) %>%
    count() %>%
    arrange(desc(n))
  
  # extracting infectee nodes
  infectee <- infectorInfecteePair %>%
    dplyr::select(case_id_infectee) %>%
    gather() #%>%
  #extracting infector nodes
  infector <-  infectorInfecteePair %>%
    dplyr::select(case_id_infector) %>%
    gather()
  
  # selecting nodes that are linked to both infectors and infectees, thus duplicates
  duplicate <- infector %>%
    left_join(., infectee, by = 'value') %>%  # leftjoin infector and infectee
    filter(key.y != 'NA') %>%  # filter all infectors who were also infectees in the past
    dplyr::select(value) %>% # keep only id
    distinct()   # selecte distict node id, this should be person id in this case.
  
  # selecting terminal infectees nodes and sum them. 
  # This is a subset of termainal doses in the db because of infectorInfecteePair data
  nterminal_infectees <- infectee %>%
    dplyr::select(value) %>%
    filter(!value %in% duplicate$value) %>% # infectees that are not infectors
    transmute(case.no = as.character(value)) %>%
    nrow() 
  
  #create vector of complete offspring distribution with terminal cases having zero secondary cases
  complete_offspringd <- enframe(c(offspring$n, rep(0,nterminal_infectees))) # convert vector to dataframe
  
  #fit negative binomial distribution to the final offspring distribution
  fit <- complete_offspringd %>%
    dplyr::pull(value) %>%
    fitdistrplus::fitdist(., distr = 'nbinom')
  
  # Estimating CI by bootstrap method 
  fit_boot <- summary(fitdistrplus::bootdist(fit))  
  
  # extracting estimates
  rkEstmate = dplyr::bind_cols(data.frame(fit$estimate), data.frame(fit_boot$CI) ) # extracting estimates and CI as a data frame
  colnames(rkEstmate) = c("Estimate", "Median", "2.5% CI", "97.5% CI")
  rkEstmate = round(rkEstmate, 2) # mu = nbfit$estimate[[2]] = mean = overall reporoduction number and  size = nbfit$estimate[[1]] = dispersion parameter k 

  #plot offspring distribution with negative binomial parameters
  #Setting polynomial degree
  polyDegree = length(unique(complete_offspringd$value))
  if(polyDegree > 9){
    polyDegreePlot = 9 # Think of adding parameter for user defined if need be.
  } else {
    polyDegreePlot = polyDegree-1 # polyDegreePlot should be less than the number of unique values
  }
  offspringDistributionPlot = ggplot(data = complete_offspringd) +
    geom_histogram(aes(x=value, y = ..density..), fill = "#dedede", colour = "Black", binwidth = 1) +
    geom_point(aes(x = value, y = dnbinom(x = value, size = fit$estimate[[1]], mu = fit$estimate[[2]])), size = 1.5) +
    stat_smooth(aes(x = value, y = dnbinom(x = value, size = fit$estimate[[1]], mu = fit$estimate[[2]])), method = 'lm', formula = y ~ poly(x, polyDegreePlot), se = FALSE, size = 0.5, colour = 'black') +
    expand_limits(x = 0, y = 0) +
    scale_x_continuous("Secondary cases per infector", expand = c(0, 0), breaks = seq(min(complete_offspringd$value), max(complete_offspringd$value), by = 5))  +
    scale_y_continuous("Proportion", limits = c(0,0.7), expand = c(0, 0)) +
    theme_classic() +
    theme(aspect.ratio = 1)
  ret = list(rkEstmate = rkEstmate, offspringDistributionPlot = offspringDistributionPlot)  # list object: table of estimates and image
  
}
#calling function
# retOffspring = offspringDistPlot(infectorInfecteePair = infectorInfecteePair)
# retOffspring$rkEstmate
# retOffspring$offspringDistributionPlot


