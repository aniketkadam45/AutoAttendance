#!/bin/sh
echo "🚀 Starting AutoAttendance on port ${PORT:-8080}..."
exec java -Dserver.port=${PORT:-8080} -jar app.jar
