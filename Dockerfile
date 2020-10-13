FROM r-base

RUN apt update && apt upgrade -y

WORKDIR /srv


## create directories
RUN mkdir -p data
RUN mkdir -p code
RUN mkdir -p output

## copy files
COPY src/install_packages.R code/install_packages.R
COPY src/myScript.R code/myScript.R

## install R-packages
RUN Rscript code/install_packages.R

CMD Rscript code/myScript.R