# Grafana for SORMAS

[Grafana](https://grafana.com/) is a well-known realtime monitoring platform for time serious data.

## Setup and Access
Start the complete deployment with `docker-compose up -d`. After the stack has started, navigate to `http://localhost:3000` and 
login with `admin:admin`. There is a `SORMAS Main` dashboard which you can use as a starting point. After you added some
data to the database, you can start to create visualizations :) Follow the information provided 
[here](https://grafana.com/docs/grafana/latest/features/datasources/postgres/).

## Status Quo
It is not clear how we are going to use Grafana for now.

## Questions/Todo
- ~~Secure PostgreSQL access!~~
- Store data in postgres such that it is backed up
- [ ] Can we use keycloak for user authentication?
- [ ] Go through the config file and remove everything we don't need!
