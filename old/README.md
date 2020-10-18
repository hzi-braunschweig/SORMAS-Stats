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

(2) Run app using the command `shiny::runApp()`


# Installation for VMs hosted by HZI RZ

## SSH Login into the VM
Login into the VM from your Computer via ssh

```bash
ssh yourusername@sormas-stats.helmholtz-hzi.de
```


## Activate IPv6 (HZI specific)
The default VMs by HZI RZ might have IPv6 disabled.
You need to activate IPv6 in order to run the Docker service properly.

(1) Open
```bash
sudo -s
nano /etc/default/grub
```

(2) Change the line

```
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1"
```

to

```
GRUB_CMDLINE_LINUX_DEFAULT=""
```

(3) Update the GRUB menu
```bash
update-grub
```

(4) Reboot the VM
```bash
reboot
```


## Install software
Make sure git and docker is installed

```bash
sudo -s
apt install git docker docker-compose
```

## Change some docker configs (HZI specific)
Open
```bash
nano /etc/docker/daemon.json
```

and add

```
{
  "default-address-pools":[ {"base":"172.17.252.192/27","size":28} ]
}
```

run 

```bash
service docker restart
```



## Download the repo
```bash
sudo -s
cd /root
git clone https://github.com/bernardsilenou/SORMAS-Stats.git
cd SORMAS-Stats
```

## Build the image and start container
```bash
docker-compose build
docker-compose up
```

You can also run

```bash
bash install.sh
```

This script contains additional clean up commands.


## cron job to update the deployment
```bash
sudo -s
crontab -e
```

and add the following line

```
45 2 * * *  (cd /root/SORMAS-Stats/  && bash install.sh)
```
