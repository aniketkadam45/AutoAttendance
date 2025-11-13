# Stage 1: Build the project using Maven + JDK 17
FROM maven:3.8.7-eclipse-temurin-17 AS build

# Use IPv4 to avoid Maven timeout or repo access issues
ENV MAVEN_OPTS="-Djava.net.preferIPv4Stack=true"

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

# ✅ Tell Render which port your app listens to
EXPOSE 8080

# ✅ Use dynamic port for Render, fallback to 8080
CMD ["sh", "-c", "java -Dserver.port=${PORT:-8080} -jar app.jar"]
