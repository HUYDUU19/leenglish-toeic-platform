package com.leenglish.toeic.service;

import com.leenglish.toeic.domain.Exercise;
import com.leenglish.toeic.domain.ExerciseQuestion;
import com.leenglish.toeic.dto.ExerciseDto;
import com.leenglish.toeic.repository.ExerciseRepository;
import com.leenglish.toeic.repository.ExerciseQuestionRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ExerciseService {

    private final ExerciseRepository exerciseRepository;
    private final ExerciseQuestionRepository exerciseQuestionRepository;

    @Autowired
    public ExerciseService(ExerciseRepository exerciseRepository,
            ExerciseQuestionRepository exerciseQuestionRepository) {
        this.exerciseRepository = exerciseRepository;
        this.exerciseQuestionRepository = exerciseQuestionRepository;
    }

    // Basic CRUD operations
    public List<Exercise> getAllExercises() {
        return exerciseRepository.findAll();
    }

    public Optional<Exercise> getExerciseById(Long id) {
        return exerciseRepository.findById(id);
    }

    public Exercise saveExercise(Exercise exercise) {
        if (exercise.getId() == null) {
            exercise.setCreatedAt(LocalDateTime.now());
        }
        exercise.setUpdatedAt(LocalDateTime.now());
        return exerciseRepository.save(exercise);
    }

    public Exercise createExercise(Exercise exercise) {
        exercise.setId(null); // Ensure it's a new exercise
        exercise.setCreatedAt(LocalDateTime.now());
        exercise.setUpdatedAt(LocalDateTime.now());

        // Set defaults if not provided
        if (exercise.getIsActive() == null) {
            exercise.setIsActive(true);
        }
        if (exercise.getIsPremium() == null) {
            exercise.setIsPremium(false);
        }
        if (exercise.getOrderIndex() == null) {
            exercise.setOrderIndex(0);
        }

        return exerciseRepository.save(exercise);
    }

    public Exercise updateExercise(Long id, Exercise exerciseUpdate) {
        Exercise exercise = exerciseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Exercise not found"));

        // Update fields
        exercise.setTitle(exerciseUpdate.getTitle());
        exercise.setDescription(exerciseUpdate.getDescription());
        exercise.setType(exerciseUpdate.getType());
        exercise.setLevel(exerciseUpdate.getLevel());
        exercise.setQuestion(exerciseUpdate.getQuestion());
        exercise.setCorrectAnswer(exerciseUpdate.getCorrectAnswer());
        exercise.setOptions(exerciseUpdate.getOptions());
        exercise.setExplanation(exerciseUpdate.getExplanation());
        exercise.setDifficultyLevel(exerciseUpdate.getDifficultyLevel());
        exercise.setPoints(exerciseUpdate.getPoints());
        exercise.setTimeLimitSeconds(exerciseUpdate.getTimeLimitSeconds());
        exercise.setAudioUrl(exerciseUpdate.getAudioUrl());
        exercise.setImageUrl(exerciseUpdate.getImageUrl());
        exercise.setOrderIndex(exerciseUpdate.getOrderIndex());
        exercise.setIsPremium(exerciseUpdate.getIsPremium());
        exercise.setIsActive(exerciseUpdate.getIsActive());
        exercise.setLessonId(exerciseUpdate.getLessonId());
        exercise.setUpdatedAt(LocalDateTime.now());

        return exerciseRepository.save(exercise);
    }

    public boolean deleteExercise(Long id) {
        if (exerciseRepository.existsById(id)) {
            exerciseRepository.deleteById(id);
            return true;
        }
        return false;
    }

    // Query methods
    public List<Exercise> getExercisesByLessonId(Long lessonId) {
        return exerciseRepository.findByLessonIdAndIsActiveTrueOrderByOrderIndexAsc(lessonId);
    }

    public List<Exercise> getExercisesByType(String type) {
        return exerciseRepository.findByTypeAndIsActiveTrue(type);
    }

    public List<Exercise> getExercisesByLevel(String level) {
        return exerciseRepository.findByLevelAndIsActiveTrue(level);
    }

    public List<Exercise> getExercisesByDifficulty(String difficultyLevel) {
        return exerciseRepository.findByDifficultyLevelAndIsActiveTrue(difficultyLevel);
    }

    public List<Exercise> getActiveExercises() {
        return exerciseRepository.findByIsActiveTrueOrderByOrderIndexAsc();
    }

    public List<Exercise> getPremiumExercises() {
        return exerciseRepository.findByIsPremiumAndIsActiveTrue(true);
    }

    public List<Exercise> getFreeExercises() {
        return exerciseRepository.findByIsPremiumAndIsActiveTrue(false);
    }

    public List<Exercise> searchExercises(String keyword) {
        return exerciseRepository.searchByKeyword(keyword);
    }

    public List<Exercise> getExercisesWithAudio() {
        return exerciseRepository.findExercisesWithAudio();
    }

    public List<Exercise> getExercisesWithImages() {
        return exerciseRepository.findExercisesWithImages();
    }

    public List<Exercise> getRandomExercises(String type, String level, int limit) {
        return exerciseRepository.findRandomExercises(type, level, PageRequest.of(0, limit));
    }

    public List<Exercise> getExercisesByPointsRange(Integer minPoints, Integer maxPoints) {
        return exerciseRepository.findByPointsRange(minPoints, maxPoints);
    }

    // Advanced search
    public List<Exercise> findByCriteria(Long lessonId, String type, String level,
            String difficultyLevel, Boolean isActive, Boolean isPremium) {
        return exerciseRepository.findByCriteria(lessonId, type, level, difficultyLevel, isActive, isPremium);
    }

    // Statistics
    public Long countByType(String type) {
        return exerciseRepository.countByType(type);
    }

    public Long countByLessonId(Long lessonId) {
        return exerciseRepository.countByLessonId(lessonId);
    }

    // Status management
    public Exercise activateExercise(Long id) {
        Exercise exercise = exerciseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Exercise not found"));

        exercise.setIsActive(true);
        exercise.setUpdatedAt(LocalDateTime.now());

        return exerciseRepository.save(exercise);
    }

    public Exercise deactivateExercise(Long id) {
        Exercise exercise = exerciseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Exercise not found"));

        exercise.setIsActive(false);
        exercise.setUpdatedAt(LocalDateTime.now());

        return exerciseRepository.save(exercise);
    }

    public Exercise setPremium(Long id, boolean isPremium) {
        Exercise exercise = exerciseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Exercise not found"));

        exercise.setIsPremium(isPremium);
        exercise.setUpdatedAt(LocalDateTime.now());

        return exerciseRepository.save(exercise);
    }

    // Validation
    public boolean validateExercise(Exercise exercise) {
        return exercise.isValid();
    } // DTO conversion methods

    public List<ExerciseDto> getAllActiveExercises() {
        List<Exercise> exercises = exerciseRepository.findByIsActiveTrueOrderByCreatedAtDesc();
        return exercises.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public ExerciseDto getExerciseDtoById(Long id) {
        Optional<Exercise> exercise = exerciseRepository.findById(id);
        return exercise.map(this::convertToDto).orElse(null);
    }

    public List<ExerciseDto> getExercisesDtoByType(String type) {
        List<Exercise> exercises = exerciseRepository.findByTypeAndIsActiveTrue(type);
        return exercises.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public List<ExerciseDto> getExercisesDtoByDifficulty(String difficulty) {
        List<Exercise> exercises = exerciseRepository.findByDifficultyLevelAndIsActiveTrue(difficulty);
        return exercises.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public ExerciseDto createExerciseFromDto(ExerciseDto exerciseDto) {
        Exercise exercise = convertToEntity(exerciseDto);
        Exercise savedExercise = createExercise(exercise);
        return convertToDto(savedExercise);
    }

    public ExerciseDto updateExerciseFromDto(Long id, ExerciseDto exerciseDto) {
        Exercise exercise = convertToEntity(exerciseDto);
        Exercise updatedExercise = updateExercise(id, exercise);
        return convertToDto(updatedExercise);
    }

    public List<ExerciseDto> searchExercisesDto(String query) {
        List<Exercise> exercises = exerciseRepository.searchByKeyword(query);
        return exercises.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    // Question related methods
    public List<ExerciseQuestion> getQuestionsByExerciseId(Long exerciseId) {
        return exerciseQuestionRepository.findByExerciseIdOrderByOrderIndexAsc(exerciseId);
    }

    public ExerciseQuestion saveQuestion(ExerciseQuestion question) {
        if (question.getId() == null) {
            question.setCreatedAt(LocalDateTime.now());
        }
        question.setUpdatedAt(LocalDateTime.now());
        return exerciseQuestionRepository.save(question);
    }

    public ExerciseQuestion updateQuestion(ExerciseQuestion question) {
        question.setUpdatedAt(LocalDateTime.now());
        return exerciseQuestionRepository.save(question);
    }

    public void deleteQuestion(Long id) {
        exerciseQuestionRepository.deleteById(id);
    }

    private ExerciseDto convertToDto(Exercise exercise) {
        ExerciseDto dto = new ExerciseDto();
        dto.setId(exercise.getId());
        dto.setTitle(exercise.getTitle());
        dto.setDescription(exercise.getDescription());
        dto.setType(exercise.getType());
        dto.setDifficulty(exercise.getDifficultyLevel());
        dto.setTimeLimit(exercise.getTimeLimitSeconds() != null ? exercise.getTimeLimitSeconds() / 60 : null); // Convert
                                                                                                               // seconds
                                                                                                               // to
                                                                                                               // minutes
        dto.setTotalQuestions(exercise.getQuestions() != null ? exercise.getQuestions().size() : 0);
        dto.setIsActive(exercise.getIsActive());
        dto.setCreatedAt(exercise.getCreatedAt());
        dto.setUpdatedAt(exercise.getUpdatedAt());
        return dto;
    }

    private Exercise convertToEntity(ExerciseDto dto) {
        Exercise exercise = new Exercise();
        exercise.setId(dto.getId());
        exercise.setTitle(dto.getTitle());
        exercise.setDescription(dto.getDescription());
        exercise.setType(dto.getType());
        exercise.setDifficultyLevel(dto.getDifficulty());
        exercise.setTimeLimitSeconds(dto.getTimeLimit() != null ? dto.getTimeLimit() * 60 : null); // Convert minutes to
                                                                                                   // seconds
        exercise.setIsActive(dto.getIsActive());
        return exercise;
    }
}
