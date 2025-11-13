# Use a lightweight OpenJDK image
FROM eclipse-temurin:22-jdk-alpine

# Set working directory inside the container
WORKDIR /app

# Copy the JAR file from target folder
COPY target/auto-attendance-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your Spring Boot app runs on
EXPOSE 8080

# Run the JAR file
ENTRYPOINT ["java","-jar","app.jar"]
