#Base package
FROM alpine:3.13.4

#Added label info here
LABEL COMPANY=JAVAHOME
LABEL EMAIL=Sreeni.devops@gmail.com

#Install java
RUN apk add openjdk8

#changing working dir
WORKDIR /opt

#Install tomccat8
ADD  https://downloads.apache.org/tomcat/tomcat-8/v8.5.65/bin/apache-tomcat-8.5.65.tar.gz .

#Untar the file  
RUN tar -xf apache-tomcat-8.5.65.tar.gz

#Rename the file
RUN mv apache-tomcat-8.5.65 tomcat8

#Remove tar file
RUN rm apache-tomcat-8.5.65.tar.gz

#Install Maven
ENV MAVEN_VERSION 3.5.4
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH
RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

#Get git bash
RUN apk add --no-cache bash git openssh

#validating git installation(Optional step)
RUN git --version

#Download project from repo
RUN git clone  https://github.com/saddikutireddy/my-app

#Chaning permissions
RUN chmod 777 my-app
RUN chmod 777 tomcat8

#Changing work dir
WORKDIR /opt/my-app

#Execute maven commands
RUN mvn clean package

#changing working dir
WORKDIR /opt/tomcat8/webapps/

#Copy war file to current dir
RUN cp /opt/my-app/target/myweb-0.0.15.war .

#Rename war file(Its optional. based on war file name endpoint URL will changes)
RUN mv myweb-0.0.15.war myapp.war

#Enabiling port to access from internet
EXPOSE 8080

#Start Tomcat
CMD ["/opt/tomcat8/bin/catalina.sh","run"]

#Once above file is ready then  try below sample commands to build and create docker container
#To build docker file(docker build -t myapp:1 .)
#To create container(docker run -dp 8080:8080 myapp:1)
#Enpoint would be like this (http://HOSTNAME:8080/myapp/)

