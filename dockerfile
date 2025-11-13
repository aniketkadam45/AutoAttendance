# Use Maven + JDK image
FROM maven:3.9.3-eclipse-temurin-22 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the project
RUN mvn clean package -DskipTests

# Use a smaller JDK image for running the app
FROM eclipse-temurin:22-jdk

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/auto-attendance-0.0.1-SNAPSHOT.jar /app/auto-attendance-0.0.1-SNAPSHOT.jar

# Copy start.sh
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Default command
CMD ["./start.sh"]
