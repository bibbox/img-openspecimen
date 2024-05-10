# OpenSpecimen Tomcat Container
 
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ARG VERSION v10.1.1.RC1

# update system
RUN apt-get update -y -q \
    && apt-get upgrade -y -q \
    && apt-get install -y -q apt-utils \
    && useradd -r -m -U -d /var/lib/tomcat9 -s /bin/bash tomcat


# TODO mak this user install all the shit to his home dir and then alls is fine ... 

## INSTALL DEPENDENCIES
# apt install
RUN apt install -y -q openjdk-17-jdk-headless \
    && apt install -y -q openjdk-17-jre-headless \
    && apt-get install -y -q tomcat9 \
    && apt-get install -y -q nano \
    && apt-get install -y -q wget \
    && apt-get install -y mysql-client \
    && apt-get update -y -q

##SET UP OPENSPECIMEN BUILD
#ENVIRONMENT
ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64/" 
ENV CATALINA_BASE="/var/lib/tomcat9" 
ENV TOMCAT_HOME="/var/lib/tomcat9" 
ENV export JAVA_HOME 
ENV export CATALINA_BASE 
ENV export TOMCAT_HOME

# Directories for Openspecimen log-files/plugins
RUN mkdir "/var/lib/tomcat9/openspecimen" \
    && mkdir "/var/lib/tomcat9/openspecimen/data" \
    && mkdir "/var/lib/tomcat9/openspecimen/plugins" \
    && mkdir "/etc/systemd/system/tomcat9.service.d" \
    && mkdir "/var/lib/tomcat9/temp"

#MYSQL-Connector
RUN cd /var/lib/tomcat9/lib \
    && wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.18/mysql-connector-java-8.0.18.jar


#properties & config-files
RUN rm /var/lib/tomcat9/conf/context.xml \
    && rm /var/lib/tomcat9/conf/tomcat-users.xml
USER tomcat
ADD configs/context.xml.template /var/lib/tomcat9/conf/
ADD configs/openspecimen.properties /var/lib/tomcat9/conf/
ADD configs/tomcat-users.xml /var/lib/tomcat9/conf/
ADD configs/OpenSpecimenAPIconnector-0.9.2-py3-none-any.whl /usr/local/src/
USER root


#rights and ownerships for installation
RUN chown -R tomcat:tomcat "/var/lib/tomcat9/" \
    && chown -R tomcat:tomcat "/usr/local/src/"

#CSet up OS
RUN echo 'JAVA_OPTS="-Xmx2048m"' > /usr/share/tomcat9/bin/setenv.sh
RUN sed -i -r 's/^(JAVA_OPTS=.*)"/\1 -Xmx2048m"/' "/etc/default/tomcat9"
RUN printf "[Service]\n%s\n" "ReadWritePaths=/var/lib/openspecimen/" > "/etc/systemd/system/tomcat9.service.d/openspecimen.conf"

RUN apt-get update && apt-get -y install python3-pip && python3 -m pip install xlrd && python3 -m pip install argparse 
RUN echo 'export PS1="[\u@openspecimen:\w]# "' >> /root/.bashrc


ADD configs/openspecimen.war /var/lib/tomcat9/webapps/openspecimen.war

ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN chmod -R 777 /var/lib \
    && chmod -R 777 /usr/ \
    && chmod -R 777 /etc/tomcat9/
USER tomcat
ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
