
package com.leenglish.toeic.domain;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "flashcard_sets")
public class FlashcardSet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(length = 1000)
    private String description;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "is_premium")
    private Boolean isPremium = false;

    @Column(name = "is_public")
    private Boolean isPublic = true;

    @Column(name = "category")
    private String category;

    @Column(name = "tags")
    private String tags;

    @Column(name = "difficulty_level")
    private String difficultyLevel;

    @Column(name = "estimated_time_minutes")
    private Integer estimatedTimeMinutes;

    @Column(name = "view_count")
    private Integer viewCount = 0;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;

    @OneToMany(mappedBy = "flashcardSet", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Flashcard> flashcards = new ArrayList<>();

    // Constructors
    public FlashcardSet() {
    }

    public FlashcardSet(String name, String description) {
        this.name = name;
        this.description = description;
        this.isActive = true;
        this.isPremium = false;
        this.isPublic = true;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Boolean getIsPremium() {
        return isPremium;
    }

    public void setIsPremium(Boolean isPremium) {
        this.isPremium = isPremium;
    }

    public Boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(Boolean isPublic) {
        this.isPublic = isPublic;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public String getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(String difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }

    public Integer getEstimatedTimeMinutes() {
        return estimatedTimeMinutes;
    }

    public void setEstimatedTimeMinutes(Integer estimatedTimeMinutes) {
        this.estimatedTimeMinutes = estimatedTimeMinutes;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public User getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(User createdBy) {
        this.createdBy = createdBy;
    }

    public List<Flashcard> getFlashcards() {
        return flashcards;
    }

    public void setFlashcards(List<Flashcard> flashcards) {
        this.flashcards = flashcards;
    }

    public String getLevel() {
        return difficultyLevel;
    }

    public void setLevel(String level) {
        setDifficultyLevel(level);
    }

    public int getCardCount() {
        return getFlashcardCount();
    }

    public void setCardCount(int cardCount) {
        // This is a computed field, so we don't actually set it
        // but provide the method for compatibility
    }

    // Business Logic Methods
    public void addFlashcard(Flashcard flashcard) {
        flashcards.add(flashcard);
        flashcard.setFlashcardSet(this);
        this.updatedAt = LocalDateTime.now();
    }

    public void removeFlashcard(Flashcard flashcard) {
        flashcards.remove(flashcard);
        flashcard.setFlashcardSet(null);
        this.updatedAt = LocalDateTime.now();
    }

    public int getFlashcardCount() {
        return flashcards != null ? flashcards.size() : 0;
    }

    public int getActiveFlashcardCount() {
        if (flashcards == null)
            return 0;
        return (int) flashcards.stream()
                .filter(f -> f.getIsActive() != null && f.getIsActive())
                .count();
    }

    public void incrementViewCount() {
        this.viewCount = (this.viewCount != null ? this.viewCount : 0) + 1;
        this.updatedAt = LocalDateTime.now();
    }

    public boolean isPremiumSet() {
        return isPremium != null && isPremium;
    }

    public boolean isPublicSet() {
        return isPublic != null && isPublic;
    }

    public boolean isActiveSet() {
        return isActive != null && isActive;
    }

    public boolean hasFlashcards() {
        return flashcards != null && !flashcards.isEmpty();
    }

    public boolean isValid() {
        return name != null && !name.trim().isEmpty();
    }

    public double getAverageAccuracy() {
        if (flashcards == null || flashcards.isEmpty())
            return 0.0;

        return flashcards.stream()
                .mapToDouble(Flashcard::getAccuracyRate)
                .average()
                .orElse(0.0);
    }

    public int getTotalAttempts() {
        if (flashcards == null)
            return 0;

        return flashcards.stream()
                .mapToInt(Flashcard::getTotalAttempts)
                .sum();
    }

    // Lifecycle Methods
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();

        if (isActive == null)
            isActive = true;
        if (isPremium == null)
            isPremium = false;
        if (isPublic == null)
            isPublic = true;
        if (viewCount == null)
            viewCount = 0;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}