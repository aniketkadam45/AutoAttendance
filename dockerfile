# Stage 1: Build the project using Maven + JDK
FROM maven:3.8.7-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Run the Spring Boot application
FROM eclipse-temurin:22-jdk

WORKDIR /app

COPY --from=build /app/target/auto-attendance-0.0.1-SNAPSHOT.jar app.jar

# Tell Docker/Render the port
EXPOSE 8080

# Command to run the app, binding to Render's $PORT
CMD ["sh", "-c", "java -Dserver.port=$PORT -jar app.jar"]
