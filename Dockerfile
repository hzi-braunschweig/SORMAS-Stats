FROM r-base

RUN apt update && apt upgrade -y
RUN apt install -y libpq-dev vim

WORKDIR /srv

## create directories
RUN mkdir -p data
RUN mkdir -p code/R
RUN mkdir -p code/python
RUN mkdir -p output

## install R-packages
COPY install_packages.R code/R
RUN Rscript code/R/install_packages.R

COPY src/ code/

#CMD Rscript code/main.R
CMD ["sh", "-c", "tail -f /dev/null"]