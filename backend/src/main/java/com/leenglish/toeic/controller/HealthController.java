package com.leenglish.toeic.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Controller to provide health check endpoints
 * Used to verify if the API is running correctly
 */
@RestController
@RequestMapping("/api")
public class HealthController {

    /**
     * Basic health check endpoint
     * Returns a 200 OK response with a timestamp and status
     * @return ResponseEntity with health status information
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("timestamp", LocalDateTime.now().toString());
        response.put("service", "TOEIC Platform API");
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * Detailed health check with memory information
     * @return ResponseEntity with detailed health information
     */
    @GetMapping("/health/details")
    public ResponseEntity<Map<String, Object>> detailedHealthCheck() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("timestamp", LocalDateTime.now().toString());
        response.put("service", "TOEIC Platform API");
        
        // Add system info
        Runtime runtime = Runtime.getRuntime();
        Map<String, Object> memory = new HashMap<>();
        memory.put("total", runtime.totalMemory() / (1024 * 1024) + " MB");
        memory.put("free", runtime.freeMemory() / (1024 * 1024) + " MB");
        memory.put("max", runtime.maxMemory() / (1024 * 1024) + " MB");
        
        response.put("memory", memory);
        
        // Add additional server info
        Map<String, Object> server = new HashMap<>();
        server.put("javaVersion", System.getProperty("java.version"));
        server.put("osName", System.getProperty("os.name"));
        server.put("availableProcessors", runtime.availableProcessors());
        
        response.put("server", server);
        
        return ResponseEntity.ok(response);
    }
}