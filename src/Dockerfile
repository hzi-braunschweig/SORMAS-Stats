FROM debian:buster-slim
RUN apt update && apt upgrade -y --no-install-recommends
RUN apt install -y \
    vim \
    libpq-dev gcc \
    python3 python3-pip python3-setuptools python3-wheel python3-venv python3-dev\
    uwsgi-plugin-python3 \
    python3-psycopg2 python3-pandas python3-pdfkit \
    r-base r-cran-dbi

WORKDIR /srv

# create directories
RUN mkdir src

# [cache] install R packages not available as deb package
COPY sormas_stats/stats/statistics/r_sormas_stats/install_packages.R src/R/
RUN Rscript src/R/install_packages.R

# FIXME(@JonasCir) python3-rpy2 is to old
# FIXME(@JonasCir) https://github.com/unbit/uwsgi/issues/1126
#  switch back to Debian version once landed
# [cache] install python packages we want to fetch via pip
COPY requirements-prod.txt src/python/
RUN python3 -m venv src/python/venv && \
    pip3 install -r src/python/requirements-prod.txt

# [cache] installl SORMAS R package
COPY sormas_stats/stats/statistics/r_sormas_stats src/sormas_stats/stats/statistics/r_sormas_stats
RUN R -e 'install.packages("/srv/src/sormas_stats/stats/statistics/r_sormas_stats", repos = NULL, type = "source")'

# copy everything
COPY . src/

# run migration, start cron, and start python dash
CMD [ "/srv/src/config/setup_and_run.sh" ]
