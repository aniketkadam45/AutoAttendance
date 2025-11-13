# Use OpenJDK 22 as base image
FROM openjdk:22-jdk

# Set working directory inside the container
WORKDIR /app

# Copy the JAR file into the container
COPY target/auto-attendance-0.0.1-SNAPSHOT.jar /app/auto-attendance-0.0.1-SNAPSHOT.jar

# Copy your start.sh script
COPY start.sh /app/start.sh

# Make the script executable
RUN chmod +x /app/start.sh

# Default command to run your app
CMD ["./start.sh"]
