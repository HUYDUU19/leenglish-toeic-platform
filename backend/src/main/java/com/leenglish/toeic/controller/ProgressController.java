package com.leenglish.toeic.controller;

import com.leenglish.toeic.dto.UserProgressDto;
import com.leenglish.toeic.service.UserProgressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/progress")
@CrossOrigin(origins = "*")
public class ProgressController {

    @Autowired
    private UserProgressService userProgressService;

    @GetMapping("/user/{userId}")
    @PreAuthorize("hasRole('USER') or hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<List<UserProgressDto>> getUserProgress(@PathVariable Long userId) {
        List<UserProgressDto> progress = userProgressService.getUserProgress(userId);
        return ResponseEntity.ok(progress);
    }

    @GetMapping("/user/{userId}/completed")
    @PreAuthorize("hasRole('USER') or hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<List<UserProgressDto>> getCompletedLessons(@PathVariable Long userId) {
        List<UserProgressDto> completedLessons = userProgressService.getCompletedLessons(userId);
        return ResponseEntity.ok(completedLessons);
    }

    @PostMapping("/update")
    @PreAuthorize("hasRole('USER') or hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<UserProgressDto> updateProgress(
            @RequestParam Long userId,
            @RequestParam Long lessonId,
            @RequestParam Integer progressPercentage,
            @RequestParam Integer timeSpent) {
        UserProgressDto updatedProgress = userProgressService.updateProgress(userId, lessonId, progressPercentage,
                timeSpent);
        return ResponseEntity.ok(updatedProgress);
    }

    @GetMapping("/user/{userId}/stats/completed-count")
    @PreAuthorize("hasRole('USER') or hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<Long> getCompletedLessonsCount(@PathVariable Long userId) {
        Long count = userProgressService.getCompletedLessonsCount(userId);
        return ResponseEntity.ok(count);
    }

    @GetMapping("/user/{userId}/stats/average-progress")
    @PreAuthorize("hasRole('USER') or hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<Double> getAverageProgress(@PathVariable Long userId) {
        Double average = userProgressService.getAverageProgress(userId);
        return ResponseEntity.ok(average);
    }

    @GetMapping("/user/{userId}/stats/total-time")
    @PreAuthorize("hasRole('USER') or hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<Long> getTotalTimeSpent(@PathVariable Long userId) {
        Long totalTime = userProgressService.getTotalTimeSpent(userId);
        return ResponseEntity.ok(totalTime);
    }

    @GetMapping("/my")
    @PreAuthorize("hasRole('USER') or hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<List<UserProgressDto>> getMyProgress(Authentication authentication) {
        // Extract user ID from authentication
        Long userId = 1L; // This should be extracted from the authenticated user
        List<UserProgressDto> progress = userProgressService.getUserProgress(userId);
        return ResponseEntity.ok(progress);
    }
}
