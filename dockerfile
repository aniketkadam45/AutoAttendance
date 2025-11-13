# Stage 1: Build the project using Maven + JDK 17
FROM maven:3.8.7-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven files and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the project (skip tests for faster build)
RUN mvn clean package -DskipTests

# Stage 2: Run the app with JDK 22
FROM eclipse-temurin:22-jdk

WORKDIR /app

# Copy the JAR from build stage
COPY --from=build /app/target/auto-attendance-0.0.1-SNAPSHOT.jar app.jar

# Copy start script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8080

# Use start script that respects Render's $PORT
CMD ["sh", "-c", "/app/start.sh"]
