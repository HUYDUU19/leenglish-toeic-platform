package com.leenglish.toeic.controller;

import com.leenglish.toeic.domain.Exercise;
import com.leenglish.toeic.dto.ExerciseDto;
import com.leenglish.toeic.service.ExerciseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/exercises")
@CrossOrigin(origins = "*")
public class ExerciseController {

    @Autowired
    private ExerciseService exerciseService;

    @GetMapping("/{id}")
    public ResponseEntity<ExerciseDto> getExercise(@PathVariable Long id) {
        return exerciseService.getExerciseById(id)
                .map(this::convertToDto)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    public ResponseEntity<List<ExerciseDto>> getAllExercises() {
        List<Exercise> exercises = exerciseService.getAllExercises();
        List<ExerciseDto> exerciseDtos = exercises.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(exerciseDtos);
    }

    @GetMapping("/difficulty/{difficulty}")
    public ResponseEntity<List<ExerciseDto>> getExercisesByDifficulty(@PathVariable String difficulty) {
        List<Exercise> exercises = exerciseService.getExercisesByDifficulty(difficulty);
        List<ExerciseDto> exerciseDtos = exercises.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(exerciseDtos);
    }

    @PostMapping
    public ResponseEntity<ExerciseDto> createExercise(@RequestBody ExerciseDto exerciseDto) {
        Exercise exercise = convertToEntity(exerciseDto);
        Exercise savedExercise = exerciseService.createExercise(exercise);
        return ResponseEntity.ok(convertToDto(savedExercise));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ExerciseDto> updateExercise(@PathVariable Long id, @RequestBody ExerciseDto exerciseDto) {
        Exercise exercise = convertToEntity(exerciseDto);
        Exercise updatedExercise = exerciseService.updateExercise(id, exercise);
        return ResponseEntity.ok(convertToDto(updatedExercise));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteExercise(@PathVariable Long id) {
        exerciseService.deleteExercise(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<ExerciseDto>> searchExercises(@RequestParam String query) {
        List<Exercise> exercises = exerciseService.searchExercisesByTitle(query);
        List<ExerciseDto> exerciseDtos = exercises.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(exerciseDtos);
    }

    private ExerciseDto convertToDto(Exercise exercise) {
        ExerciseDto dto = new ExerciseDto();
        dto.setId(exercise.getId());
        dto.setTitle(exercise.getTitle());
        dto.setDescription(exercise.getDescription());
        dto.setDifficulty(exercise.getDifficulty());
        dto.setType(exercise.getType());
        dto.setCreatedAt(exercise.getCreatedAt());
        dto.setUpdatedAt(exercise.getUpdatedAt());
        return dto;
    }

    private Exercise convertToEntity(ExerciseDto dto) {
        Exercise exercise = new Exercise();
        exercise.setId(dto.getId());
        exercise.setTitle(dto.getTitle());
        exercise.setDescription(dto.getDescription());
        exercise.setDifficulty(dto.getDifficulty());
        exercise.setType(dto.getType());
        return exercise;
    }
}
