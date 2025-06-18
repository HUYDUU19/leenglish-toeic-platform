package com.leenglish.toeic.repository;

import com.leenglish.toeic.domain.FlashcardSet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FlashcardSetRepository extends JpaRepository<FlashcardSet, Long> {

    List<FlashcardSet> findByCreatedByIdAndIsActiveTrue(Long userId);

    List<FlashcardSet> findByIsPublicTrueAndIsActiveTrue();

    List<FlashcardSet> findByCategoryAndIsActiveTrue(String category);

    List<FlashcardSet> findByLevelAndIsActiveTrue(String level);

    @Query("SELECT fs FROM FlashcardSet fs WHERE (fs.isPublic = true OR fs.createdBy.id = :userId) AND fs.isActive = true ORDER BY fs.createdAt DESC")
    List<FlashcardSet> findAccessibleFlashcardSets(@Param("userId") Long userId);

    @Query("SELECT fs FROM FlashcardSet fs WHERE LOWER(fs.name) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR LOWER(fs.description) LIKE LOWER(CONCAT('%', :searchTerm, '%')) AND fs.isActive = true AND (fs.isPublic = true OR fs.createdBy.id = :userId)")
    List<FlashcardSet> searchFlashcardSets(@Param("searchTerm") String searchTerm, @Param("userId") Long userId);
}
