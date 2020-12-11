# Welcome
This project's goal is to provide first class statistics for SORMAS using Python, Python Dash for dashboards, and R.

The high level idea for SORMAS-Stats is to have a dedicated container running in the SORMAS-Docker deployment 
(separations of concern). The container runs `R` and `python` scripts on a CRON schedule. The statistic scripts 
fetch data from the sormas DB with a read-only role and write their results back into a dedicated statistics database. 
This statistics database can easily be consumed by all sorts other tools for example Grafana or Python Dash for 
visualization. The visualizations could be made accessible from SORMAS either by navigating to them through a 
button click or by using iframes.

# REMINDER
* This is alpha code
* DO NOT CONNECT THIS TO A PRODUCTION SERVER

# FAQ
* Does it work (yet): Reasonable well
* Should I use it in production: Absolutely not
* Will it eat my laundry: Yes


# Base directory structure
Check the `READMEs` in the sub-folders for more details.

```
SORMAS-Stats
├── dev # useful tools and resources which makes a devs life easier
├── docker # necessary to run the SORMAS-Docker stack via docker-compose
├── src #
│   ├── grafana # Dockerfile, dashboards and datasources for Grafana to visualize data
│   └── stats # Dockerfile, DB migrations, Python Dash and statistics scripts in R and Python
├── .env # ENV variables for docker-compose
└── docker-compose.yml # run more or less a SORMAS-Docker stack with a stats and grafana container included
```

# How do I build and run it?
1. Start the stack via `docker-compose up -d`. This might take a while as this 
  starts more or less a complete [SORMAS-Docker]() deployment including together 
  with the `statistics` and `grafana` container of this repository. 
1. Once the stack has started, login to `http://localhost:6080/sormas-ui/#!configuration/devMode` (`admin`:`sadmin`). 
  Use the developer mode to generate sample data.
1. Navigate to `localhost:3000` and login with `admin:admin` to access Grafana. 
  The `SORMAS Main` dashboard contains the visualizations. 
1. Navigate to `localhost:8080` to see the dashboards crated with python dash

The statistics scripts which pull data from the SORMAS-DB and store the results in 
the statistic DB are currently executed every minute.

# How do I contribute?
First of all: Thank you for getting involved, we love contributions! Follow these steps:
1. Pick or create an issue which you want to resolve
1. Fork the project
1. From the repo base folder run `git checkout devlopment && git checkout -b feature/$issue-numer$-$some-name$`. This helps the team to keep overview.
1. Start your work: *PLEASE* include the issue number you are working on at the beginning 
   of each commit message. E.g., for commits belonging to issue 123 use `git commit -m '[#123] your message here'` for each commit. GitHub will automatically use this to link issues and commits which makes at lot things easier.
1. Open a Pull Request. For bigger changes, you can also consider to open a draft PR such that we can take a first look at what is going on.