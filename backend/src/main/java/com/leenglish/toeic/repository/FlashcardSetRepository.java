package com.leenglish.toeic.repository;

import com.leenglish.toeic.domain.FlashcardSet;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FlashcardSetRepository extends JpaRepository<FlashcardSet, Long> {

    // ========== BASIC METHODS ONLY ==========

    Optional<FlashcardSet> findByName(String name);

    List<FlashcardSet> findByDifficultyLevel(String difficultyLevel);

    Page<FlashcardSet> findByDifficultyLevel(String difficultyLevel, Pageable pageable);

    @Query("SELECT f FROM FlashcardSet f WHERE f.isActive = true")
    List<FlashcardSet> findActiveFlashcardSets();

    @Query("SELECT f FROM FlashcardSet f WHERE f.isActive = true")
    Page<FlashcardSet> findActiveFlashcardSets(Pageable pageable);

    @Query("SELECT COUNT(f) FROM FlashcardSet f WHERE f.isActive = true")
    long countActiveFlashcardSets();

    long countByDifficultyLevel(String difficultyLevel);
}
