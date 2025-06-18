package com.leenglish.toeic.domain;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "flashcards")
public class Flashcard {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String frontText;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String backText;

    @Column(columnDefinition = "TEXT")
    private String hint;

    @Column(columnDefinition = "TEXT")
    private String explanation;

    private String imageUrl;
    private String audioUrl;

    @Column(nullable = false)
    private String category;

    private String tags;

    private Boolean isActive = true;
    private Boolean isPublic = true;

    private Integer viewCount = 0;
    private Integer correctCount = 0;
    private Integer incorrectCount = 0;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "flashcard_set_id")
    private FlashcardSet flashcardSet;

    // Constructors
    public Flashcard() {
    }

    public Flashcard(String frontText, String backText, String category) {
        this.frontText = frontText;
        this.backText = backText;
        this.category = category;
        this.isActive = true;
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

    public String getFrontText() {
        return frontText;
    }

    public void setFrontText(String frontText) {
        this.frontText = frontText;
    }

    public String getBackText() {
        return backText;
    }

    public void setBackText(String backText) {
        this.backText = backText;
    }

    public String getHint() {
        return hint;
    }

    public void setHint(String hint) {
        this.hint = hint;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getAudioUrl() {
        return audioUrl;
    }

    public void setAudioUrl(String audioUrl) {
        this.audioUrl = audioUrl;
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

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(Boolean isPublic) {
        this.isPublic = isPublic;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public Integer getCorrectCount() {
        return correctCount;
    }

    public void setCorrectCount(Integer correctCount) {
        this.correctCount = correctCount;
    }

    public Integer getIncorrectCount() {
        return incorrectCount;
    }

    public void setIncorrectCount(Integer incorrectCount) {
        this.incorrectCount = incorrectCount;
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

    public FlashcardSet getFlashcardSet() {
        return flashcardSet;
    }

    public void setFlashcardSet(FlashcardSet flashcardSet) {
        this.flashcardSet = flashcardSet;
    }

    // Business Logic Methods
    public boolean hasAudio() {
        return audioUrl != null && !audioUrl.trim().isEmpty();
    }

    public boolean hasImage() {
        return imageUrl != null && !imageUrl.trim().isEmpty();
    }

    public boolean hasHint() {
        return hint != null && !hint.trim().isEmpty();
    }

    public boolean hasExplanation() {
        return explanation != null && !explanation.trim().isEmpty();
    }

    public void incrementViewCount() {
        this.viewCount = (this.viewCount != null ? this.viewCount : 0) + 1;
        this.updatedAt = LocalDateTime.now();
    }

    public void incrementCorrectCount() {
        this.correctCount = (this.correctCount != null ? this.correctCount : 0) + 1;
        this.updatedAt = LocalDateTime.now();
    }

    public void incrementIncorrectCount() {
        this.incorrectCount = (this.incorrectCount != null ? this.incorrectCount : 0) + 1;
        this.updatedAt = LocalDateTime.now();
    }

    public double getAccuracyRate() {
        int total = (correctCount != null ? correctCount : 0) + (incorrectCount != null ? incorrectCount : 0);
        if (total == 0)
            return 0.0;
        return (double) (correctCount != null ? correctCount : 0) / total * 100;
    }

    public int getTotalAttempts() {
        return (correctCount != null ? correctCount : 0) + (incorrectCount != null ? incorrectCount : 0);
    }

    public boolean isValid() {
        return frontText != null && !frontText.trim().isEmpty() &&
                backText != null && !backText.trim().isEmpty() &&
                category != null && !category.trim().isEmpty();
    }

    // Lifecycle Methods
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();

        if (isActive == null)
            isActive = true;
        if (isPublic == null)
            isPublic = true;
        if (viewCount == null)
            viewCount = 0;
        if (correctCount == null)
            correctCount = 0;
        if (incorrectCount == null)
            incorrectCount = 0;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
