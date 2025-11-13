# Stage 1: Build
FROM maven:3.9.0-eclipse-temurin-22 AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:22-jdk

WORKDIR /app

COPY --from=build /app/target/auto-attendance-0.0.1-SNAPSHOT.jar /app/app.jar
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

CMD ["./start.sh"]
