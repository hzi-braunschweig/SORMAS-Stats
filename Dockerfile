FROM r-base

RUN apt update && apt upgrade -y
RUN apt install -y libpq-dev

WORKDIR /srv

## create directories
RUN mkdir -p data
RUN mkdir -p code
RUN mkdir -p output

## install R-packages
COPY install_packages.R code/
RUN Rscript code/install_packages.R

COPY src/ code/

#CMD Rscript code/main.R
CMD ["sh", "-c", "tail -f /dev/null"]