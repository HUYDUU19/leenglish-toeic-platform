package com.leenglish.toeic.controller;

import com.leenglish.toeic.dto.LessonDto;
import com.leenglish.toeic.service.LessonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/lessons")
@CrossOrigin(origins = "*")
public class LessonController {

    @Autowired
    private LessonService lessonService;

    @GetMapping
    public ResponseEntity<List<LessonDto>> getAllLessons() {
        List<LessonDto> lessons = lessonService.getAllActiveLessons();
        return ResponseEntity.ok(lessons);
    }

    @GetMapping("/{id}")
    public ResponseEntity<LessonDto> getLessonById(@PathVariable Long id) {
        LessonDto lesson = lessonService.getLessonById(id);
        return ResponseEntity.ok(lesson);
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

    @GetMapping("/level/{level}")
    public ResponseEntity<List<LessonDto>> getLessonsByLevel(@PathVariable String level) {
        List<LessonDto> lessons = lessonService.getLessonsByLevel(level);
        return ResponseEntity.ok(lessons);
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('COLLABORATOR')")
    public ResponseEntity<LessonDto> createLesson(@RequestBody LessonDto lessonDto) {
        LessonDto createdLesson = lessonService.createLesson(lessonDto);
        return ResponseEntity.ok(createdLesson);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('COLLABORATOR')")
    public ResponseEntity<LessonDto> updateLesson(@PathVariable Long id, @RequestBody LessonDto lessonDto) {
        LessonDto updatedLesson = lessonService.updateLesson(id, lessonDto);
        return ResponseEntity.ok(updatedLesson);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteLesson(@PathVariable Long id) {
        lessonService.deleteLesson(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<LessonDto>> searchLessons(@RequestParam String query) {
        List<LessonDto> lessons = lessonService.searchLessons(query);
        return ResponseEntity.ok(lessons);
    }
}
