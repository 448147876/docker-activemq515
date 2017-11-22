# https://github.com/phusion/baseimage-docker#using
FROM phusion/baseimage:0.9.22

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
## Update OS
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"
RUN apt-get -y install openjdk-8-jre-headless wget


## Install Activemq
RUN wget -O "/tmp/apache-activemq-5.15.2-bin.tar.gz" "http://www.apache.org/dyn/closer.cgi?filename=/activemq/5.15.2/apache-activemq-5.15.2-bin.tar.gz&action=download"
RUN cd /tmp; tar zxvf apache-activemq-5.15.2-bin.tar.gz;
RUN mv /tmp/apache-activemq-5.15.2/ /opt;
RUN ln -s /opt/apache-activemq-5.15.2 /opt/activemq
RUN cd /opt/activemq/bin; chmod 755 activemq;

# Activemq conf directory setup
RUN rm /opt/activemq/conf/*
## Make start script for activemq
RUN mkdir -p /etc/my_init.d
COPY start_activemq.sh /etc/my_init.d/start_activemq.sh
RUN chmod +x /etc/my_init.d/start_activemq.sh
## ActiveMQ config
COPY conf/activemq.xml /opt/activemq/conf/activemq.xml
COPY conf/log4j.properties /opt/activemq/conf/log4j.properties
COPY conf/credentials.properties /opt/activemq/conf/
## JMX
COPY conf/jmx.access /opt/activemq/conf/jmx.access
COPY conf/jmx.password /opt/activemq/conf/jmx.password
## Jetty
COPY conf/jetty.xml /opt/activemq/conf/
COPY conf/jetty-realm.properties /opt/activemq/conf/

## Clean up APT when done.
RUN apt-get -y remove wget
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Expose ports
## JMS port
EXPOSE 61616
## Admin web console
EXPOSE 8161
## JMX
EXPOSE 1099