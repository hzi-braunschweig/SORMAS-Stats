FROM debian:buster-slim

RUN apt update && apt upgrade -y
RUN apt install -y \
    cron vim \
    libpq-dev \
    python3 python3-pip \
    r-base r-cran-dbi r-cran-tidyverse \
    python-psycopg2 python-numpy python-scipy python-pandas python-matplotlib
 

# FIXME(@JonasCir) https://github.com/yandex/pgmigrate/issues/22
RUN pip3 install "yandex-pgmigrate==1.0.5"

WORKDIR /srv

# create directories
RUN mkdir src && \
    mkdir data && \
    mkdir output

# install R packages not available as deb package
COPY R/install_packages.R src/R/
RUN Rscript src/R/install_packages.R


# setup cron tab
COPY config/crontab /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab

COPY . src/

# run migration and start cron
CMD ["/srv/src/config/setup_and_run.sh" ]
