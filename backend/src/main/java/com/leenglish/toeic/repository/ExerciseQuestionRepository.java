package com.leenglish.toeic.repository;

import com.leenglish.toeic.domain.ExerciseQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ExerciseQuestionRepository extends JpaRepository<ExerciseQuestion, Long> {

    // Find questions by exercise
    List<ExerciseQuestion> findByExerciseId(Long exerciseId);

    List<ExerciseQuestion> findByExerciseIdOrderById(Long exerciseId);

    // Find questions by type
    List<ExerciseQuestion> findByType(String type);

    // Search questions by keyword
    @Query("SELECT eq FROM ExerciseQuestion eq WHERE eq.questionText LIKE %:keyword%")
    List<ExerciseQuestion> searchByKeyword(@Param("keyword") String keyword);

    // Find questions with audio
    @Query("SELECT eq FROM ExerciseQuestion eq WHERE eq.audioUrl IS NOT NULL AND eq.audioUrl != ''")
    List<ExerciseQuestion> findQuestionsWithAudio();

    // Find questions with images
    @Query("SELECT eq FROM ExerciseQuestion eq WHERE eq.imageUrl IS NOT NULL AND eq.imageUrl != ''")
    List<ExerciseQuestion> findQuestionsWithImages();

    // Count questions by exercise
    @Query("SELECT COUNT(eq) FROM ExerciseQuestion eq WHERE eq.exerciseId = :exerciseId")
    Long countByExerciseId(@Param("exerciseId") Long exerciseId);

    // Count questions by type
    @Query("SELECT COUNT(eq) FROM ExerciseQuestion eq WHERE eq.type = :type")
    Long countByType(@Param("type") String type);

    // Find questions by exercise and type
    @Query("SELECT eq FROM ExerciseQuestion eq WHERE eq.exerciseId = :exerciseId AND eq.type = :type")
    List<ExerciseQuestion> findByExerciseIdAndType(@Param("exerciseId") Long exerciseId, @Param("type") String type);

    // Delete questions by exercise
    void deleteByExerciseId(Long exerciseId);
}
