FROM alpine

RUN apk update && apk upgrade
RUN apk add --no-cache build-base postgresql-dev py3-pip python3-dev R R-dev R-doc bash vim

# FIXME(@JonasCir) https://github.com/yandex/pgmigrate/issues/22
RUN pip install "yandex-pgmigrate==1.0.5"

WORKDIR /srv

## create directories
RUN mkdir -p data
RUN mkdir -p src/R
RUN mkdir -p src/python
RUN mkdir -p output

## install and cache R-packages
COPY R/install_packages.R src/R/
RUN Rscript src/R/install_packages.R

# setup cron tab
COPY config/crontab /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab

COPY . src/

# run migration
ENTRYPOINT ["/srv/src/config/setup.sh" ]

CMD ["crond","-f", "-L", "/dev/stdout"]
