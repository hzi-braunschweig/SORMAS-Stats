# Statistic Docker Container for SORMAS

The statistics docker container for SORMAS runs a Django webserver to display dashboards with statistics and to offer downloadable reports, both based on SORMAS live data.  
Realtime monitoring is provided by the Grafana data visualisation platform.

# Development Quick Start
Requirements: python3, docker, docker-compose, postgres, virtualenv, R, JDK 11.
``` 
git clone https://github.com/hzi-braunschweig/SORMAS-Stats.git

cd SORMAS-Stats
python3 -m venv src/venv
source src/venv/bin/activate

pip3 install -r src/requirements-dev.txt

sudo Rscript src/sormas_stats/stats/statistics/r_sormas_stats/install-requirements.R

sudo docker-compose up -d

cd src/sormas-stats
python3 manage.py runserver
``` 

# Development Setup
This guide shows how to prepare a clean development setup in detail.  
It was produced on a clean Ubuntu 20.04.1 LTS ("focal") installation and (with small adaptations) can be used for other Linux- / Unix-based operating systems as well.

Install system packages for python, postgres and R:
``` 
sudo apt-get update && sudo apt upgrade
sudo apt-get install python3-venv python3-dev libpg-dev r-base r-base-dev 
```

Install JDK 11:
``` 
sudo apt-get install openjdk-11-jdk
``` 
(Optional: switch java version to JDK 11)  
``` 
sudo update-alternatives --config java
``` 

Install and start [Docker engine](https://docs.docker.com/engine/install/):
``` 
sudo apt install  apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
``` 

Install [Docker Compose](https://docs.docker.com/compose/install/):
``` 
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
``` 

Clone the SORMAS-Stats repository:
``` 
git clone https://github.com/hzi-braunschweig/SORMAS-Stats.git
``` 

Activate python virtual environment:
``` 
cd SORMAS-Stats
python3 -m venv src/venv
source src/venv/bin/activate
``` 
(Always use the python interpreter and pip from the virtual environment from now on.)

Install required python packages:
``` 
pip3 install -r src/requirements-dev.txt
``` 

Install R requirements:
``` 
sudo Rscript src/sormas_stats/stats/statistics/r_sormas_stats/install-requirements.R
``` 

Run Docker Compose to build and start the containers for SORMAS-Stats:
``` 
sudo docker-compose up -d
``` 

Run Django webserver:
``` 
cd src/sormas-stats
python3 manage.py runserver
``` 

Now you should be able to access your development server at `http://127.0.0.1:8000/` in your browser.