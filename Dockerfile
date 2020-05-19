# check available R versions here: <https://hub.docker.com/r/rocker/shiny/tags>
FROM rocker/shiny:3.6.3

# ---------------------------------------------
# Install missing debian/ubuntu packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
       libcurl4-openssl-dev \
       libv8-dev \
 && apt-get -y autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install required R packages for shiny
COPY requirements.R /root/requirements.R
RUN Rscript /root/requirements.R

# Debugging
#RUN R -e ".libPaths()"

# ---------------------------------------------
# Install missing debian/ubuntu packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
       xtail \
 && apt-get -y autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy the app
RUN ls -la /srv/shiny-server
RUN rm -rf /srv/shiny-server/*
COPY shinyapp /srv/shiny-server/
RUN chmod -R 755 /srv/shiny-server/
RUN ls -la /srv/shiny-server

# Expose port 
# (We can map it to standard HTTP port lateron when building the container!)
EXPOSE 3838

# run the shiny app
CMD ["/usr/bin/shiny-server.sh"]
