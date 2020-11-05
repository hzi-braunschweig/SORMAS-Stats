# Setup
## This is a very easy setup to connect to a running server

`docker build -t local-sormas/jupyter ./dev/jupyter`
`docker run -p 8888:8888 local-sormas/jupyter`

Currently, nothing gets mounted into the container, this will change soon.