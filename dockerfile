# Stage 1: Build the project using Maven + JDK 17
FROM maven:3.8.7-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven configuration and pre-fetch dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the Spring Boot app with JDK 22
FROM eclipse-temurin:22-jdk

WORKDIR /app
COPY --from=build /app/target/auto-attendance-0.0.1-SNAPSHOT.jar /app/app.jar

EXPOSE 8080
ENV PORT=8080

CMD ["sh", "-c", "java -Dserver.port=$PORT -jar app.jar"]
