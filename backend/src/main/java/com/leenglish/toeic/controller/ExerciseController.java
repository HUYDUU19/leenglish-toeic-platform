package com.leenglish.toeic.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.leenglish.toeic.domain.Exercise;
import com.leenglish.toeic.dto.ExerciseDto;
import com.leenglish.toeic.service.ExerciseService;

@RestController
@RequestMapping("/api/exercises")
@CrossOrigin(origins = "*")
public class ExerciseController {

    @Autowired
    private ExerciseService exerciseService;

    // Lấy 1 exercise theo id
    @GetMapping("/{id}")
    public ResponseEntity<ExerciseDto> getExercise(@PathVariable Long id) {
        return exerciseService.getExerciseById(id)
                .map(this::convertToDto)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Lấy tất cả exercise
    @GetMapping
    public ResponseEntity<?> getAllExercises() {
        return ResponseEntity.ok(
                exerciseService.getAllExercises()
                        .stream()
                        .map(this::convertToDto)
                        .toList());
    }

    // Tạo mới exercise
    @PostMapping
    public ResponseEntity<ExerciseDto> createExercise(@RequestBody ExerciseDto exerciseDto) {
        Exercise exercise = convertToEntity(exerciseDto);
        Exercise savedExercise = exerciseService.createExercise(exercise);
        return ResponseEntity.ok(convertToDto(savedExercise));
    }

    // Xóa exercise
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteExercise(@PathVariable Long id) {
        exerciseService.deleteExercise(id);
        return ResponseEntity.ok().build();
    }

    // Chuyển đổi entity sang dto
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

    // Chuyển đổi dto sang entity
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
