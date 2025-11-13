# Stage 1: Build the project using Maven + JDK
FROM maven:3.8.7-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy Maven configuration and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the project (skip tests for faster build)
RUN mvn clean package -DskipTests

# Stage 2: Run the Spring Boot application using JDK 22
FROM eclipse-temurin:22-jdk

# Set working directory
WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/auto-attendance-0.0.1-SNAPSHOT.jar /app/app.jar

# Copy start script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Command to run the app
CMD ["./start.sh"]
