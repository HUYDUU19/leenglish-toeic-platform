package com.leenglish.toeic.repository;

import com.leenglish.toeic.domain.UserExerciseAttempt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserExerciseAttemptRepository extends JpaRepository<UserExerciseAttempt, Long> {

    List<UserExerciseAttempt> findByUserIdOrderByStartedAtDesc(Long userId);

    List<UserExerciseAttempt> findByUserIdAndExerciseId(Long userId, Long exerciseId);

    List<UserExerciseAttempt> findByUserIdAndIsCompletedTrue(Long userId);

    @Query("SELECT uea FROM UserExerciseAttempt uea WHERE uea.user.id = :userId AND uea.exercise.id = :exerciseId ORDER BY uea.score DESC LIMIT 1")
    Optional<UserExerciseAttempt> findBestAttemptByUserAndExercise(@Param("userId") Long userId,
            @Param("exerciseId") Long exerciseId);

    @Query("SELECT COUNT(uea) FROM UserExerciseAttempt uea WHERE uea.user.id = :userId AND uea.isCompleted = true")
    Long countCompletedAttemptsByUser(@Param("userId") Long userId);

    @Query("SELECT AVG(uea.score) FROM UserExerciseAttempt uea WHERE uea.user.id = :userId AND uea.isCompleted = true")
    Double getAverageScoreByUser(@Param("userId") Long userId);

    @Query("SELECT SUM(uea.timeSpentMinutes) FROM UserExerciseAttempt uea WHERE uea.user.id = :userId AND uea.isCompleted = true")
    Long getTotalTimeSpentByUser(@Param("userId") Long userId);

    @Query("SELECT uea FROM UserExerciseAttempt uea WHERE uea.user.id = :userId AND uea.isCompleted = true ORDER BY uea.completedAt DESC LIMIT 10")
    List<UserExerciseAttempt> findRecentCompletedAttempts(@Param("userId") Long userId);
}
