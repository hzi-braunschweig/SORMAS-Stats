# SORMAS-Stats
SORMAS-Stats contain functions to analyze and visualize surveillance data collected by SORMAS.

## `shinyapp` folder
- `SORMAS-Stats/shinyapp`
    - `app.R`
    - `utils/`
    - `demo-data/`

## Run docker container
(1) Start your docker daemon

(2) Call Docker Compose

```bash
docker-compose build
docker-compose up
```

(3) Check in your browser if the tracking server is up and running

[http://localhost](http://localhost)


## Run locally
(1) Set the R PATH to

```r
setwd("SORMAS-Stats/shinyapp")
```

(2) Run `app.R`
