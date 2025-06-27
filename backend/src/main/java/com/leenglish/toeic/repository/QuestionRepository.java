package com.leenglish.toeic.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.leenglish.toeic.domain.Question;

@Repository
public interface QuestionRepository extends JpaRepository<Question, Long> {

    // ================================================================
    // CHỈ 2 METHODS CỐT LÕI
    // ================================================================

    /**
     * Lấy questions của exercise theo thứ tự
     */
    List<Question> findByExerciseIdAndIsActiveTrueOrderByQuestionOrder(Long exerciseId);

    /**
     * Lấy free questions cho guests
     */
    @Query("SELECT q FROM Question q WHERE q.exercise.isPremium = false AND q.isActive = true")
    List<Question> findByExercise_IsFreeTrue();
}