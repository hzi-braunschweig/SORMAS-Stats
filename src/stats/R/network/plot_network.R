# This function visualizes the network data in R as specified 
# by issue https://github.com/hzi-braunschweig/SORMAS-Stats/issues/98
# This function used the output data returned by contact_network.R and the visNetwork package
# library("visNetwork")
plot_network = function(nodeLineList, elist)
{
  defaultFont="font-family:'Open Sans', sans-serif, 'Source Sans Pro'"
  mainStyle = paste(defaultFont, "color: #6591C4", ";font-weight: 600", "font-size: 1.6em", "text-align:center;", sep="; ")
  submainStyle = paste(defaultFont, "text-align:center;", sep="; ")
  footerStyle = defaultFont
  addNodesS <- data.frame(label = c("Legend", "Healthy","Not_classified" ,"Suspected", "Probable", "Confirmed", "Not case", "1 = High risk", "2 = Low risk", "Event"), shape = "icon",
                          icon.code = c("f0c0","f007", "f007", "f007", "f007", "f007","f007", "f178", "f178", "f0c0"),
                          icon.size = c(0.1,25, 25, 25, 25, 25,25,25,25,25), icon.color = c("#0d0c0c","#17bd27", "#706c67", "#ffff00", "#ffa500", "#f70707","#99bd17", "#0d0c0c", "#0d0c0c", "#0000ff"))
  
  g= visNetwork(nodeLineList, elist,  main = list(text = "Disease network diagram", style = mainStyle),
                submain = list(text = "The arrows indicate the direction of transmission", style = submainStyle), 
                footer = list(text = "Zoom in to see the IDs and contact category", style = footerStyle), 
                background = "white", annot = T, width = "100%", height = "100vh") %>%  # width = "100%", height = "90vh", "500px" 
    visEdges(arrows = "to", color = "black") %>% 
    #visOptions(selectedBy = "Classification",highlightNearest = TRUE,nodesIdSelection = FALSE) %>% 
    visOptions(selectedBy = NULL,highlightNearest = TRUE,nodesIdSelection = FALSE) %>% 
    #visOptions(selectedBy = NULL,highlightNearest = TRUE,nodesIdSelection = FALSE) %>% 
    visGroups(groupname = "SUSPECT", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#ffff00")) %>%
    visGroups(groupname = "PROBABLE", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#ffa500")) %>%
    visGroups(groupname = "CONFIRMED", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#f70707")) %>%
    visGroups(groupname = "NOT_CLASSIFIED", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#706c67" )) %>%
    visGroups(groupname = "HEALTHY", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#17bd27")) %>%
    visGroups(groupname = "NO_CASE", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f007"), color="#99bd17")) %>%
    visGroups(groupname = "EVENT", size = 10, shape = "icon", icon = list( face ='FontAwesome', code = c( "f0c0"), color="#0000ff")) %>%
    addFontAwesome() %>%
    visLegend(addNodes = addNodesS, useGroups = F, position = "right", width = 0.2, ncol = 1, stepX = 100, stepY = 100) %>%  
    visPhysics(stabilization = F) %>%
    visInteraction(dragNodes = T, dragView = T, zoomView = T)
  
  print(g)
}

