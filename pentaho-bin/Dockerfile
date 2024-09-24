# Use Ubuntu as the base image
FROM ubuntu:22.04

# Update Ubuntu and install OpenJDK 8, sudo, and bash
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk sudo bash && \
    apt-get clean

# Add JAVA_HOME to the environment
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
RUN echo 'JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' >> /etc/environment

# Create a new user named "pentaho" with root privileges
RUN useradd -m -s /bin/bash pentaho && \
    echo "pentaho:pentaho" | chpasswd && \
    adduser pentaho sudo

# Allow the pentaho user to run sudo commands without a password, but we'll avoid using sudo for the install
RUN echo "pentaho ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to root user for setup
USER root

# Copy the Pentaho .bin file to the container
COPY pentaho-business-analytics-9.3.0.0-428-x64.bin /home/pentaho/

# Change ownership of the file to the pentaho user
RUN chown pentaho:pentaho /home/pentaho/pentaho-business-analytics-9.3.0.0-428-x64.bin

# Switch to the pentaho user for installation
USER pentaho
WORKDIR /home/pentaho

# Run the Pentaho installer without sudo, as the pentaho user
RUN if [ ! -d "/home/pentaho/Pentaho" ]; then \
      echo "Starting Pentaho installation..." && \
      chmod +x /home/pentaho/pentaho-business-analytics-9.3.0.0-428-x64.bin && \
      ./pentaho-business-analytics-9.3.0.0-428-x64.bin --mode unattended --postgres_password t@mbul1 && \
      echo "Installation complete, removing .bin file..." && \
      rm -f /home/pentaho/pentaho-business-analytics-9.3.0.0-428-x64.bin || \
      echo "Installation failed"; \
    else \
      echo "Pentaho already installed"; \
    fi


# Add environment variable to control activation process
ENV ENABLE_CDE_ACTIVATION=true

# Copy plugin and settings files to a temporary location
COPY ./plugin.xml /tmp/
COPY ./settings.xml /tmp/

# Conditionally copy the plugin and settings files if ENABLE_CDE_ACTIVATION is true
RUN if [ "$ENABLE_CDE_ACTIVATION" = "true" ]; then \
      echo "Activating CDE features..." && \
      cp -f /tmp/plugin.xml /home/pentaho/Pentaho/server/pentaho-server/pentaho-solutions/system/pentaho-cdf-dd/plugin.xml && \
      cp -f /tmp/settings.xml /home/pentaho/Pentaho/server/pentaho-server/pentaho-solutions/system/pentaho-cdf-dd/settings.xml; \
    else \
      echo "Skipping CDE activation"; \
    fi


# Expose Pentaho default port
EXPOSE 8080


# Set the entry point to ensure Pentaho server is started
CMD /home/pentaho/Pentaho/ctlscript.sh start && tail -f /dev/null
