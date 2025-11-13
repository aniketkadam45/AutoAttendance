package com.attendance.autoattendance;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;

@SpringBootApplication
@EnableScheduling
public class AutoAttendanceApplication {

    @Value("${attendance.mobile}")
    private String mobileNumber = "7558383889";

    @Value("${attendance.mode}")
    private String mode = "Offline";

    public static void main(String[] args) {
        SpringApplication.run(AutoAttendanceApplication.class, args);
    }

    // Scheduled to run every day at 4:35 PM IST
    @Scheduled(cron = "0 35 16 * * *", zone = "Asia/Kolkata")
    public void markAttendance() {
        String attendanceUrl = "https://javabykiran.com/jbkcrm/studentattendance/submitAttendence";
        try {
            // Build POST parameters
            String postData = "contactNumber=" + mobileNumber + "&mode=" + mode;

            URL url = new URL(attendanceUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setRequestProperty("Accept", "application/json");

            // Send data
            try (OutputStream os = conn.getOutputStream()) {
                os.write(postData.getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();
            System.out.println(LocalDateTime.now() + " → Response: " + responseCode);

            if (responseCode == 200) {
                System.out.println("✅ Attendance marked successfully!");
            } else {
                System.out.println("⚠️ Failed to mark attendance. Response: " + responseCode);
            }

            conn.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
