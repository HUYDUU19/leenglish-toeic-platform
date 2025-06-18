package com.leenglish.toeic.repository;

import com.leenglish.toeic.domain.Lesson;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long> {

    // Find lessons by level
    List<Lesson> findByLevel(String level);

    List<Lesson> findByLevelAndIsActiveTrue(String level);

    // Find active lessons
    List<Lesson> findByIsActiveTrue();

    List<Lesson> findByIsActiveTrueOrderByOrderIndexAsc();

    // Find premium lessons
    List<Lesson> findByIsPremiumTrue();

    List<Lesson> findByIsPremiumFalse();

    List<Lesson> findByIsPremiumAndIsActiveTrue(Boolean isPremium);

    // Search lessons by keyword
    @Query("SELECT l FROM Lesson l WHERE " +
            "(l.title LIKE %:keyword% OR l.description LIKE %:keyword% OR l.content LIKE %:keyword%) AND " +
            "l.isActive = true")
    List<Lesson> searchByKeyword(@Param("keyword") String keyword);

    // Find lessons with audio
    @Query("SELECT l FROM Lesson l WHERE l.audioUrl IS NOT NULL AND l.audioUrl != '' AND l.isActive = true")
    List<Lesson> findLessonsWithAudio();

    // Find lessons with images
    @Query("SELECT l FROM Lesson l WHERE l.imageUrl IS NOT NULL AND l.imageUrl != '' AND l.isActive = true")
    List<Lesson> findLessonsWithImages();

    // Count lessons by level
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.level = :level AND l.isActive = true")
    Long countByLevel(@Param("level") String level);

    // Find lessons by multiple criteria
    @Query("SELECT l FROM Lesson l WHERE " +
            "(:level IS NULL OR l.level = :level) AND " +
            "(:isActive IS NULL OR l.isActive = :isActive) AND " +
            "(:isPremium IS NULL OR l.isPremium = :isPremium)")
    List<Lesson> findByCriteria(
            @Param("level") String level,
            @Param("isActive") Boolean isActive,
            @Param("isPremium") Boolean isPremium); // Find random lessons by level

    @Query(value = "SELECT * FROM lessons l WHERE l.level = :level AND l.is_active = true ORDER BY RAND()", nativeQuery = true)
    List<Lesson> findRandomLessons(@Param("level") String level, Pageable pageable);

    // Find lessons ordered by creation date
    @Query("SELECT l FROM Lesson l WHERE l.isActive = true ORDER BY l.createdAt DESC")
    List<Lesson> findActiveOrderByCreatedAtDesc();

    // Find lessons ordered by update date
    @Query("SELECT l FROM Lesson l WHERE l.isActive = true ORDER BY l.updatedAt DESC")
    List<Lesson> findActiveOrderByUpdatedAtDesc();
}
