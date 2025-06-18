package com.leenglish.toeic.controller;

import com.leenglish.toeic.dto.ExerciseDto;
import com.leenglish.toeic.dto.ExerciseAttemptDto;
import com.leenglish.toeic.service.ExerciseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/exercises")
@CrossOrigin(origins = "*")
public class ExerciseController {

    @Autowired
    private ExerciseService exerciseService;

    @GetMapping
    public ResponseEntity<List<ExerciseDto>> getAllExercises() {
        List<ExerciseDto> exercises = exerciseService.getAllActiveExercises();
        return ResponseEntity.ok(exercises);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ExerciseDto> getExerciseById(@PathVariable Long id) {
        ExerciseDto exercise = exerciseService.getExerciseById(id);
        return ResponseEntity.ok(exercise);
    }

    @GetMapping("/type/{type}")
    public ResponseEntity<List<ExerciseDto>> getExercisesByType(@PathVariable String type) {
        List<ExerciseDto> exercises = exerciseService.getExercisesByType(type);
        return ResponseEntity.ok(exercises);
    }

    @GetMapping("/difficulty/{difficulty}")
    public ResponseEntity<List<ExerciseDto>> getExercisesByDifficulty(@PathVariable String difficulty) {
        List<ExerciseDto> exercises = exerciseService.getExercisesByDifficulty(difficulty);
        return ResponseEntity.ok(exercises);
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('COLLABORATOR')")
    public ResponseEntity<ExerciseDto> createExercise(@RequestBody ExerciseDto exerciseDto) {
        ExerciseDto createdExercise = exerciseService.createExercise(exerciseDto);
        return ResponseEntity.ok(createdExercise);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('COLLABORATOR')")
    public ResponseEntity<ExerciseDto> updateExercise(@PathVariable Long id, @RequestBody ExerciseDto exerciseDto) {
        ExerciseDto updatedExercise = exerciseService.updateExercise(id, exerciseDto);
        return ResponseEntity.ok(updatedExercise);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteExercise(@PathVariable Long id) {
        exerciseService.deleteExercise(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<ExerciseDto>> searchExercises(@RequestParam String query) {
        List<ExerciseDto> exercises = exerciseService.searchExercises(query);
        return ResponseEntity.ok(exercises);
    }
}
