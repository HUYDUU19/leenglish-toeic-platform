package com.leenglish.toeic.controller;

import com.leenglish.toeic.domain.Lesson;
import com.leenglish.toeic.dto.LessonDto;
import com.leenglish.toeic.service.LessonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/lessons")
@CrossOrigin(origins = "*")
public class LessonController {

    @Autowired
    private LessonService lessonService;

    @GetMapping("/{id}")
    public ResponseEntity<LessonDto> getLesson(@PathVariable Long id) {
        return lessonService.getLessonById(id)
                .map(lessonService::convertToDto)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    public ResponseEntity<List<LessonDto>> getAllLessons() {
        return ResponseEntity.ok().body(lessonService.findAllLessonsAsDto());
    }

    @PostMapping
    public ResponseEntity<LessonDto> createLesson(@RequestBody LessonDto lessonDto) {
        LessonDto createdLesson = lessonService.createLesson(lessonDto);
        return ResponseEntity.ok().body(createdLesson);
    }

    @GetMapping("/type/{type}")
    public ResponseEntity<List<LessonDto>> getLessonsByType(@PathVariable String type) {
        List<LessonDto> lessons = lessonService.getLessonsByType(type);
        return ResponseEntity.ok(lessons);
    }

    @GetMapping("/difficulty/{difficulty}")
    public ResponseEntity<List<LessonDto>> getLessonsByDifficulty(@PathVariable String difficulty) {
        List<LessonDto> lessons = lessonService.getLessonsByDifficulty(difficulty);
        return ResponseEntity.ok(lessons);
    }

    @PutMapping("/{id}")
    public ResponseEntity<LessonDto> updateLesson(@PathVariable Long id, @RequestBody LessonDto lessonDto) {
        LessonDto updatedLesson = lessonService.updateLesson(id, lessonDto);
        return ResponseEntity.ok().body(updatedLesson);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteLesson(@PathVariable Long id) {
        lessonService.deleteLesson(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/category/{categoryId}")
    public ResponseEntity<List<LessonDto>> getLessonsByCategory(@PathVariable Long categoryId) {
        // Temporarily comment out until the method is available
        // return
        // ResponseEntity.ok().body(lessonService.findLessonsByCategoryAsDto(categoryId));
        return ResponseEntity.ok().body(new ArrayList<>());
    }

    @GetMapping("/level/{level}")
    public ResponseEntity<List<LessonDto>> getLessonsByLevel(@PathVariable String level) {
        List<Lesson> lessons = lessonService.getLessonsByLevel(level);
        List<LessonDto> lessonDtos = lessons.stream()
                .map(lessonService::convertToDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(lessonDtos);
    }

    @GetMapping("/search")
    public ResponseEntity<List<LessonDto>> searchLessonsByTitle(@RequestParam String title) {
        List<LessonDto> lessons = lessonService.searchLessonsByTitle(title);
        return ResponseEntity.ok(lessons);
    }

    @GetMapping("/recent")
    public ResponseEntity<List<LessonDto>> getRecentLessons() {
        return ResponseEntity.ok().body(lessonService.getRecentLessons());
    }

    /**
     * Get free lessons for non-premium users (only first 2 basic lessons)
     * This endpoint is accessible without authentication
     */
    @GetMapping("/free")
    public ResponseEntity<List<LessonDto>> getFreeLessons() {
        List<LessonDto> freeLessons = lessonService.getFreeLessonsForBasicUsers();
        return ResponseEntity.ok(freeLessons);
    }

    /**
     * Check if a specific lesson is accessible for basic users
     */
    @GetMapping("/free/{id}")
    public ResponseEntity<LessonDto> getFreeLessonById(@PathVariable Long id) {
        return lessonService.getFreeLessonByIdForBasicUsers(id)
                .map(lessonService::convertToDto)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
