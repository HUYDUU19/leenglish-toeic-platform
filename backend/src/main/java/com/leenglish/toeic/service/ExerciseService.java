package com.leenglish.toeic.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.leenglish.toeic.domain.Exercise;
import com.leenglish.toeic.domain.Question;
import com.leenglish.toeic.repository.ExerciseRepository;
import com.leenglish.toeic.repository.QuestionRepository;

@Service
public class ExerciseService {

    private final QuestionRepository exerciseQuestionRepository;

    @Autowired
    public ExerciseService(QuestionRepository exerciseQuestionRepository) {
        this.exerciseQuestionRepository = exerciseQuestionRepository;
    }

    @Autowired
    private ExerciseRepository exerciseRepository;

    // Chỉ giữ lại các method thao tác với Question

    public Question saveQuestion(Question question) {
        if (question.getId() == null) {
            question.setCreatedAt(LocalDateTime.now());
        }
        question.setUpdatedAt(LocalDateTime.now());
        return exerciseQuestionRepository.save(question);
    }

    public Question updateQuestion(Question question) {
        question.setUpdatedAt(LocalDateTime.now());
        return exerciseQuestionRepository.save(question);
    }

    public void deleteQuestion(Long id) {
        exerciseQuestionRepository.deleteById(id);
    }

    public Optional<Exercise> getExerciseById(Long id) {
        // TODO: Thay bằng logic thật nếu cần
        return Optional.empty();
    }

    public List<Exercise> getAllExercises() {
        // TODO: Thay bằng logic thật nếu cần
        return new ArrayList<>();
    }

    public Exercise createExercise(Exercise exercise) {
        // TODO: Thay bằng logic thật nếu cần
        return exercise;
    }

    public void deleteExercise(Long id) {
        // TODO: Thay bằng logic thật nếu cần
    }

    public long getTotalExerciseCount() {
        return exerciseRepository.count();
    }
}
