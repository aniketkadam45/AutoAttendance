# 📘 Auto Attendance System

Automated attendance-marking system built using **Java + Spring Boot**, deployed on **Render (Free Tier)**, and kept alive using **UptimeRobot**.  
The system automatically sends a POST request to the attendance API each day, eliminating manual work.

## 🚀 Project Overview
**Name:** Auto Attendance System  
**Purpose:** Automatically mark daily attendance using a scheduled POST request.  

## 🧱 Architecture
```
UptimeRobot (Ping every 5 min)
            │
            ▼
Render Free Tier Server  ────>  Spring Boot App (Cron Job)
            │
            ▼
JavaByKiran Attendance API (POST)
```

## 🛠 Tech Stack
- Java 17+
- Spring Boot
- Spring Scheduling
- HttpURLConnection
- Render (Free Tier Hosting)
- UptimeRobot (Keep Alive)

## ✨ Features
- Automatic attendance marking  
- Cron-based scheduling  
- Reliable POST request  
- Avoid cold start failures  
- Logging enabled  

## 📝 Example Cron Code
```java
@Scheduled(cron = "0 35 16 * * *", zone = "Asia/Kolkata")
public void sendAttendance() {
    try {
        URL url = new URL("https://javabykiran.com/jbkcrm/studentattendance/submitAttendence");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);

	String data ="contactNumber=" + mobileNumber + "&mode=" + mode + "&batch=Java%20Fullstack" + "&attendenceDate=" + LocalDate.now() + "&subject=Core%20Java" + "&studentId=OTAyMzE1MzYwMDAw";

        String data = "contactNumber=YOUR_MOBILE&mode=Offline";
        conn.getOutputStream().write(data.getBytes(StandardCharsets.UTF_8));

        int responseCode = conn.getResponseCode();
        System.out.println("Attendance Response: " + responseCode);

    } catch (Exception e) {
        e.printStackTrace();
    }
}
```

## 🏗 Deployment Steps (Render)
1. Push project to GitHub  
2. Create a Render Web Service  
3. Build:
```
mvn clean package
```
4. Start:
```
java -jar target/auto-attendance-0.0.1-SNAPSHOT.jar
```

## ❤️ Keeping Server Alive
Use UptimeRobot to ping your Render URL every 5 minutes.

## 🎯 Improvements
- Retry logic  
- Notifications  
- Dashboard  
- Multi-user support

## 🧑‍💻 Author
Aniket Kadam
