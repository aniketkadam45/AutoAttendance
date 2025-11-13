# Stage 1: Build
FROM maven:3.9.3-jdk-22 AS build

WORKDIR /app

# Copy Maven files first for caching dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the project and skip tests
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:22-jdk

WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/auto-attendance-0.0.1-SNAPSHOT.jar /app/auto-attendance-0.0.1-SNAPSHOT.jar

# Copy start.sh and make it executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Default command
CMD ["./start.sh"]
