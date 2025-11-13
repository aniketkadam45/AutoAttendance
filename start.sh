#!/bin/sh

# Use the port provided by Render or fallback to 8080
echo "Starting AutoAttendance on port $PORT..."
java -Dserver.port=$PORT -jar app.jar
