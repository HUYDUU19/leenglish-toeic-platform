package com.leenglish.toeic.controller;

import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.dto.UserDto;
import com.leenglish.toeic.dto.UserLessonProgressDto;
import com.leenglish.toeic.service.UserService;
import com.leenglish.toeic.service.LessonService;
import com.leenglish.toeic.service.UserProgressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Enhanced User API Controller
 * Provides comprehensive user management and progress tracking endpoints
 */
@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserApiController {

    @Autowired
    private UserService userService;

    @Autowired
    private LessonService lessonService;

    @Autowired
    private UserProgressService userProgressService;

    // =====================================================
    // USER PROFILE ENDPOINTS
    // =====================================================

    /**
     * GET /api/users/profile - Get current user profile
     */
    @GetMapping("/profile")
    public ResponseEntity<UserDto> getCurrentUserProfile(Authentication authentication) {
        String username = authentication.getName();
        User user = userService.findByUsername(username);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }
        UserDto userDto = userService.convertToDto(user);
        return ResponseEntity.ok(userDto);
    }

    /**
     * PUT /api/users/profile - Update current user profile
     */
    @PutMapping("/profile")
    public ResponseEntity<UserDto> updateUserProfile(
            @RequestBody UserDto userDto,
            Authentication authentication) {
        String username = authentication.getName();
        UserDto updatedUser = userService.updateUserProfile(username, userDto);
        return ResponseEntity.ok(updatedUser);
    }

    /**
     * GET /api/users/{userId} - Get user by ID (Admin only)
     */
    @GetMapping("/{userId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserDto> getUserById(@PathVariable Long userId) {
        User user = userService.findById(userId);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }
        UserDto userDto = userService.convertToDto(user);
        return ResponseEntity.ok(userDto);
    }

    /**
     * GET /api/users - Get all users (Admin only)
     */
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UserDto>> getAllUsers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {
        List<UserDto> users = userService.getAllUsers(page, size, sortBy, sortDir);
        return ResponseEntity.ok(users);
    }

    // =====================================================
    // USER LESSONS ENDPOINTS (1 User → N Lessons)
    // =====================================================

    /**
     * GET /api/users/{userId}/lessons - Get all lessons for a user
     */
    @GetMapping("/{userId}/lessons")
    public ResponseEntity<List<UserLessonProgressDto>> getUserLessons(
            @PathVariable Long userId,
            @RequestParam(required = false) String toeicPart,
            @RequestParam(required = false) String difficulty,
            @RequestParam(required = false) String lessonType,
            @RequestParam(required = false) String status,
            Authentication authentication) {

        // Check if user is accessing their own data or is admin
        if (!userService.canAccessUserData(userId, authentication)) {
            return ResponseEntity.forbid().build();
        }

        List<UserLessonProgressDto> lessons = lessonService.getUserLessonsWithProgress(
                userId, toeicPart, difficulty, lessonType, status);
        return ResponseEntity.ok(lessons);
    }

    /**
     * GET /api/users/lessons - Get current user's lessons
     */
    @GetMapping("/lessons")
    public ResponseEntity<List<UserLessonProgressDto>> getCurrentUserLessons(
            @RequestParam(required = false) String toeicPart,
            @RequestParam(required = false) String difficulty,
            @RequestParam(required = false) String lessonType,
            @RequestParam(required = false) String status,
            Authentication authentication) {

        User user = userService.findByUsername(authentication.getName());
        List<UserLessonProgressDto> lessons = lessonService.getUserLessonsWithProgress(
                user.getId(), toeicPart, difficulty, lessonType, status);
        return ResponseEntity.ok(lessons);
    }

    /**
     * POST /api/users/{userId}/lessons/{lessonId}/start - Start a lesson
     */
    @PostMapping("/{userId}/lessons/{lessonId}/start")
    public ResponseEntity<UserLessonProgressDto> startLesson(
            @PathVariable Long userId,
            @PathVariable Long lessonId,
            Authentication authentication) {

        if (!userService.canAccessUserData(userId, authentication)) {
            return ResponseEntity.forbid().build();
        }

        UserLessonProgressDto progress = userProgressService.startLesson(userId, lessonId);
        return ResponseEntity.ok(progress);
    }

    /**
     * POST /api/users/lessons/{lessonId}/start - Start a lesson for current user
     */
    @PostMapping("/lessons/{lessonId}/start")
    public ResponseEntity<UserLessonProgressDto> startLessonForCurrentUser(
            @PathVariable Long lessonId,
            Authentication authentication) {

        User user = userService.findByUsername(authentication.getName());
        UserLessonProgressDto progress = userProgressService.startLesson(user.getId(), lessonId);
        return ResponseEntity.ok(progress);
    }

    // =====================================================
    // USER STATISTICS ENDPOINTS
    // =====================================================

    /**
     * GET /api/users/{userId}/stats - Get user learning statistics
     */
    @GetMapping("/{userId}/stats")
    public ResponseEntity<Map<String, Object>> getUserStats(
            @PathVariable Long userId,
            Authentication authentication) {

        if (!userService.canAccessUserData(userId, authentication)) {
            return ResponseEntity.forbid().build();
        }

        Map<String, Object> stats = userProgressService.getUserStatistics(userId);
        return ResponseEntity.ok(stats);
    }

    /**
     * GET /api/users/stats - Get current user statistics
     */
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getCurrentUserStats(Authentication authentication) {
        User user = userService.findByUsername(authentication.getName());
        Map<String, Object> stats = userProgressService.getUserStatistics(user.getId());
        return ResponseEntity.ok(stats);
    }

    /**
     * GET /api/users/{userId}/progress - Get detailed user progress
     */
    @GetMapping("/{userId}/progress")
    public ResponseEntity<Map<String, Object>> getUserProgress(
            @PathVariable Long userId,
            @RequestParam(required = false) String timeRange,
            Authentication authentication) {

        if (!userService.canAccessUserData(userId, authentication)) {
            return ResponseEntity.forbid().build();
        }

        Map<String, Object> progress = userProgressService.getDetailedUserProgress(userId, timeRange);
        return ResponseEntity.ok(progress);
    }

    /**
     * GET /api/users/progress - Get current user detailed progress
     */
    @GetMapping("/progress")
    public ResponseEntity<Map<String, Object>> getCurrentUserProgress(
            @RequestParam(required = false) String timeRange,
            Authentication authentication) {

        User user = userService.findByUsername(authentication.getName());
        Map<String, Object> progress = userProgressService.getDetailedUserProgress(user.getId(), timeRange);
        return ResponseEntity.ok(progress);
    }

    // =====================================================
    // USER ACHIEVEMENTS ENDPOINTS
    // =====================================================

    /**
     * GET /api/users/{userId}/achievements - Get user achievements
     */
    @GetMapping("/{userId}/achievements")
    public ResponseEntity<List<Map<String, Object>>> getUserAchievements(
            @PathVariable Long userId,
            Authentication authentication) {

        if (!userService.canAccessUserData(userId, authentication)) {
            return ResponseEntity.forbid().build();
        }

        List<Map<String, Object>> achievements = userProgressService.getUserAchievements(userId);
        return ResponseEntity.ok(achievements);
    }

    /**
     * GET /api/users/achievements - Get current user achievements
     */
    @GetMapping("/achievements")
    public ResponseEntity<List<Map<String, Object>>> getCurrentUserAchievements(Authentication authentication) {
        User user = userService.findByUsername(authentication.getName());
        List<Map<String, Object>> achievements = userProgressService.getUserAchievements(user.getId());
        return ResponseEntity.ok(achievements);
    }

    // =====================================================
    // USER PREFERENCES ENDPOINTS
    // =====================================================

    /**
     * GET /api/users/preferences - Get user preferences
     */
    @GetMapping("/preferences")
    public ResponseEntity<Map<String, Object>> getUserPreferences(Authentication authentication) {
        User user = userService.findByUsername(authentication.getName());
        Map<String, Object> preferences = userService.getUserPreferences(user.getId());
        return ResponseEntity.ok(preferences);
    }

    /**
     * PUT /api/users/preferences - Update user preferences
     */
    @PutMapping("/preferences")
    public ResponseEntity<Map<String, Object>> updateUserPreferences(
            @RequestBody Map<String, Object> preferences,
            Authentication authentication) {

        User user = userService.findByUsername(authentication.getName());
        Map<String, Object> updatedPreferences = userService.updateUserPreferences(user.getId(), preferences);
        return ResponseEntity.ok(updatedPreferences);
    }
}
