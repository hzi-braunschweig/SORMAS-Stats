# Welcome
This project's goal is to provide first class statistics for SORMAS.

# REMINDER
* This is pre-alpha code
* DO NOT CONNECT THIS TO A PRODUCTION SERVER

# FAQ
* Does it work: No
* Should I use it in production: Absolutely not
* Will it eat my laundry: Yes

# How do I build and run it?
Start the stack via `docker-compose up -d`. This might take a while as this starts more or less a complete [SORMAS-Docker]() deployment including together with the `statistics` and `grafana` container of this repository.

# How do I contribute?
First of all: Thank you for getting involved, we love contributions! Follow these steps:
1. Pick or create an issue which you want to resolve
1. Fork the project
1. From the repo base folder run `git checkout devlopment && git checkout -b feature/$issue-numer$-$some-name$`. This helps the team to keep overview.
1. Start your work: *PLEASE* include the issue number you are working on at the beginning of each commit message. E.g., for commits belonging to issue 123 use `git commit -m '[#123] your message here'` for each commit. GitHub will automatically use this to link issues and commits which makes at lot things easier.
1. Open a Pull Request. For bigger changes, you can also consider to open a draft PR such that we can take a first look at what is going on.