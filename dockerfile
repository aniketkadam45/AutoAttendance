# ---------- Stage 1: Build using Maven ----------
FROM maven:3.8.7-eclipse-temurin-17 AS build
WORKDIR /app

# Copy Maven configuration and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the JAR
COPY src ./src
RUN mvn clean package -DskipTests


# ---------- Stage 2: Run using JDK 22 ----------
FROM eclipse-temurin:22-jdk
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/auto-attendance-0.0.1-SNAPSHOT.jar app.jar

# Copy the startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose port (Render auto-detects this)
EXPOSE 8080

# Start the app
CMD ["sh", "/app/start.sh"]
