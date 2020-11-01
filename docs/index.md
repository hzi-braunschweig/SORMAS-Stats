# Welcome
This project's goal is to provide first class statistics for SORMAS.

The high level idea for SORMAS-Stats is to have a dedicated container 
running in the SORMAS-Docker deployment (separations of concern). 
The container runs `R` and `python` scripts on a CRON schedule. 
The statistic scripts fetch data from the sormas DB with a read-only 
role and write their results back into a dedicated statistics database. 
This statistics database can easily be consumed by all sorts other 
tools for example Grafana or R-Shiny for visualization. The 
visualizations could be made accessible from SORMAS either by 
navigating to them through a button click or by using iframes.


# Developer
