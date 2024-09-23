# create the container with ubuntu
FROM ubuntu:22.04

# We need to update ubuntu and install open jkd to execute pentaho
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get clean && apt-get install bash;

# Add JAVA_PATH to the environment

RUN echo 'JAVA_PATH="/usr/lib/jvm/java-8-openjdk-amd64"' >> /etc/environment

# Copy the pentaho-server folder from the host machine to the container
COPY pentaho-server /home/ubuntu/pentaho/

# set the default directory
WORKDIR /home/ubuntu/pentaho/

# give permissions needed

RUN chmod +x tomcat/bin/catalina.sh
RUN chmod +x start-pentaho.sh

# by default pentaho works on port 8080, so to ensure access from 
# other machines we need to expose the port in use
EXPOSE 8080

# Make that when the container start run the server

CMD ["./start-pentaho.sh && tail -f /dev/null"]