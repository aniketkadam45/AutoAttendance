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
import java.util.List;


@SpringBootApplication
@EnableScheduling
public class AutoAttendanceApplication {

    static class Student {
        int admissionId;
        int batchId;
        String contactNumber;
    
        public Student(int admissionId, int batchId, String contactNumber) {
            this.admissionId = admissionId;
            this.batchId = batchId;
            this.contactNumber = contactNumber;
        }
    }


    public static void main(String[] args) {
        SpringApplication.run(AutoAttendanceApplication.class, args);
    }

    // Runs every day at 4:32 PM
    @Scheduled(cron = "0 32 16 * * *", zone = "Asia/Kolkata")
    public void markAttendance() {
    
        // List of all students
        List<Student> students = List.of(
                new Student(21668, 902, "7558383889"),
                new Student(1, 2, "123"),
                new Student(12, 4, "321")
        );
    
        // Mark attendance for each student
        for (Student s : students) {
            sendAttendance(s);
        }
    }

    
    public void sendAttendance(Student s) {
        String attendanceUrl = "https://javabykiran.com/jbkcrm/studentattendance/submitAttendence";

        try {
            String postData =
                "admissionId=" + s.admissionId +
                "&collegeId=" +
                "&batchId=" + s.batchId +
                "&mode=Offline" +
                "&contactNumber=" + s.contactNumber +
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
            System.out.println(LocalDateTime.now()  
                + " | Student: " + s.admissionId
                + " | Batch: " + s.batchId
                + " | Response: " + responseCode
            );

            if (responseCode == 200) {
                System.out.println("✅ Attendance marked successfully! " + s.admissionId);
            } else {
                System.out.println("⚠️ Attendance failed for :" + s.admissionId + ". Response code: " + responseCode);
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
