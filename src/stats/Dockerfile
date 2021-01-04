FROM debian:buster-slim
RUN apt update && apt upgrade -y --no-install-recommends
RUN apt install -y \
    cron vim \
    libpq-dev gcc \
    python3 python3-pip python3-setuptools python3-wheel python3-venv python3-dev\
    uwsgi uwsgi-plugin-python3 \
    python3-psycopg2 python3-pandas python3-pdfkit python3-rpy2 \
    r-base r-cran-dbi

# FIXME(@JonasCir) https://github.com/yandex/pgmigrate/issues/22 and move to requirements.txt
RUN pip3 install "yandex-pgmigrate==1.0.5"

WORKDIR /srv

# create directories
RUN mkdir src && \
    mkdir data && \
    mkdir output

# [cache] install R packages not available as deb package
COPY R/install_packages.R src/R/
RUN Rscript src/R/install_packages.R

# [cache] install python packages we want to fetch via pip
COPY python/requirements-prod.txt src/python/
RUN python3 -m venv src/python/venv && \
    pip3 install -r src/python/requirements-prod.txt

# [cache] setup cron tab
COPY config/crontab /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab

# copy everything
COPY . src/

# run migration, start cron, and start python dash
CMD [ "/srv/src/config/setup_and_run.sh" ]
