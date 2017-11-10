# What is this?
An example dockerfile which has an ActiveMQ server running in it.

## Build
`docker build -t activemq515:0.0.1 .`

## Run
`docker run --rm -p 8161:8161 -p 61616:61616 -p 1099:1099 activemq515:0.0.1`

## Connect to `CONTAINER_NAME` 
`docker exec -i -t <CONTAINER_NAME> /bin/bash`

## Admin page
[Should be at http://localhost:8161](http://localhost:8161)

#### Login details for admin web console?
admin, admin

## Default JMX connection details?
- localhost:1099
- user: admin
- pass: activemq

## Why can't I see the admin page?
If you're on windows, sometimes docker network isn't setup properly. Try 'docker inspect <CONTAINER_NAME>'

Then look at the network gateway I.P. address and replace 'localhost' with that IP.