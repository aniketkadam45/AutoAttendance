package com.attendance.autoattendance;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;

@SpringBootApplication
@EnableScheduling
public class AutoAttendanceApplication {

    public static void main(String[] args) {
        SpringApplication.run(AutoAttendanceApplication.class, args);
    }

    // Runs every day at 4:35 PM
    @Scheduled(cron = "0 35 16 * * *", zone = "Asia/Kolkata")
    public void markAttendance() {
        String attendanceUrl = "https://javabykiran.com/jbkcrm/studentattendance/submitAttendence";

        try {
            // 🔥 ALL REQUIRED FIELDS HERE
            String postData =
                    "admissionId=21668" +
                    "&collegeId=" +
                    "&batchId=902" +
                    "&mode=Offline" +
                    "&contactNumber=7558383889" +
                    "&qualification=" +
                    "&college_category=";

            URL url = new URL(attendanceUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setRequestProperty("Accept", "application/json");

            try (OutputStream os = conn.getOutputStream()) {
                os.write(postData.getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();
            System.out.println(LocalDateTime.now() + " → Response Code: " + responseCode);

            if (responseCode == 200) {
                System.out.println("✅ Attendance marked successfully!");
            } else {
                System.out.println("⚠️ Attendance failed. Response code: " + responseCode);
            }

            conn.disconnect();

        } catch (Exception e) {
            System.out.println("❌ Error marking attendance: " + e.getMessage());
        }
    }

    @RestController
    class HealthController {
        @GetMapping("/")
        public String home() {
            return "✅ AutoAttendance Service running!";
        }
    }
}
