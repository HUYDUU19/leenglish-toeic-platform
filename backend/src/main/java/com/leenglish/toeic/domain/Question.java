package com.leenglish.toeic.domain;

import com.leenglish.toeic.enums.*;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "questions")
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exercise_id", nullable = false)
    private Exercise exercise;

    @Column(name = "question_text", columnDefinition = "TEXT", nullable = false)
    private String questionText;

    @Enumerated(EnumType.STRING)
    @Column(name = "question_type", nullable = false)
    private ExerciseType questionType;

    @Enumerated(EnumType.STRING)
    @Column(name = "difficulty")
    private Difficulty difficulty = Difficulty.EASY;

    // Media Resources
    @Column(name = "question_image_url", length = 500)
    private String questionImageUrl;

    @Column(name = "question_audio_url", length = 500)
    private String questionAudioUrl;

    @Column(name = "audio_duration")
    private Integer audioDuration = 0;

    // Answer Options
    @Column(name = "option_a", length = 500)
    private String optionA;

    @Column(name = "option_b", length = 500)
    private String optionB;

    @Column(name = "option_c", length = 500)
    private String optionC;

    @Column(name = "option_d", length = 500)
    private String optionD;

    @Column(name = "option_e", length = 500)
    private String optionE;

    // Correct Answer
    @Column(name = "correct_answer", nullable = false, length = 1)
    private String correctAnswer;

    @Column(name = "correct_answer_text", columnDefinition = "TEXT")
    private String correctAnswerText;

    // Explanation & Learning
    @Column(name = "explanation", columnDefinition = "TEXT")
    private String explanation;

    @Column(name = "explanation_image_url", length = 500)
    private String explanationImageUrl;

    @Column(name = "explanation_audio_url", length = 500)
    private String explanationAudioUrl;

    @Column(name = "learning_tip", columnDefinition = "TEXT")
    private String learningTip;

    // TOEIC Specific
    @Enumerated(EnumType.STRING)
    @Column(name = "toeic_part", nullable = false)
    private ToeicPart toeicPart;

    @Column(name = "skill_tested", length = 50, nullable = false)
    private String skillTested;

    // Scoring
    @Column(name = "points")
    private Integer points = 1;

    @Column(name = "time_limit")
    private Integer timeLimit = 0;

    // Order and Status
    @Column(name = "question_order")
    private Integer questionOrder = 0;

    @Column(name = "is_active")
    private Boolean isActive = true;

    // Statistics
    @Column(name = "total_attempts")
    private Integer totalAttempts = 0;

    @Column(name = "correct_attempts")
    private Integer correctAttempts = 0;

    // Timestamps
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Constructors
    public Question() {}

    public Question(String questionText, ExerciseType questionType, String correctAnswer, ToeicPart toeicPart, String skillTested) {
        this.questionText = questionText;
        this.questionType = questionType;
        this.correctAnswer = correctAnswer;
        this.toeicPart = toeicPart;
        this.skillTested = skillTested;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Exercise getExercise() { return exercise; }
    public void setExercise(Exercise exercise) { this.exercise = exercise; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public ExerciseType getQuestionType() { return questionType; }
    public void setQuestionType(ExerciseType questionType) { this.questionType = questionType; }

    public Difficulty getDifficulty() { return difficulty; }
    public void setDifficulty(Difficulty difficulty) { this.difficulty = difficulty; }

    public String getQuestionImageUrl() { return questionImageUrl; }
    public void setQuestionImageUrl(String questionImageUrl) { this.questionImageUrl = questionImageUrl; }

    public String getQuestionAudioUrl() { return questionAudioUrl; }
    public void setQuestionAudioUrl(String questionAudioUrl) { this.questionAudioUrl = questionAudioUrl; }

    public Integer getAudioDuration() { return audioDuration; }
    public void setAudioDuration(Integer audioDuration) { this.audioDuration = audioDuration; }

    public String getOptionA() { return optionA; }
    public void setOptionA(String optionA) { this.optionA = optionA; }

    public String getOptionB() { return optionB; }
    public void setOptionB(String optionB) { this.optionB = optionB; }

    public String getOptionC() { return optionC; }
    public void setOptionC(String optionC) { this.optionC = optionC; }

    public String getOptionD() { return optionD; }
    public void setOptionD(String optionD) { this.optionD = optionD; }

    public String getOptionE() { return optionE; }
    public void setOptionE(String optionE) { this.optionE = optionE; }

    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }

    public String getCorrectAnswerText() { return correctAnswerText; }
    public void setCorrectAnswerText(String correctAnswerText) { this.correctAnswerText = correctAnswerText; }

    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }

    public String getExplanationImageUrl() { return explanationImageUrl; }
    public void setExplanationImageUrl(String explanationImageUrl) { this.explanationImageUrl = explanationImageUrl; }

    public String getExplanationAudioUrl() { return explanationAudioUrl; }
    public void setExplanationAudioUrl(String explanationAudioUrl) { this.explanationAudioUrl = explanationAudioUrl; }

    public String getLearningTip() { return learningTip; }
    public void setLearningTip(String learningTip) { this.learningTip = learningTip; }

    public ToeicPart getToeicPart() { return toeicPart; }
    public void setToeicPart(ToeicPart toeicPart) { this.toeicPart = toeicPart; }

    public String getSkillTested() { return skillTested; }
    public void setSkillTested(String skillTested) { this.skillTested = skillTested; }

    public Integer getPoints() { return points; }
    public void setPoints(Integer points) { this.points = points; }

    public Integer getTimeLimit() { return timeLimit; }
    public void setTimeLimit(Integer timeLimit) { this.timeLimit = timeLimit; }

    public Integer getQuestionOrder() { return questionOrder; }
    public void setQuestionOrder(Integer questionOrder) { this.questionOrder = questionOrder; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public Integer getTotalAttempts() { return totalAttempts; }
    public void setTotalAttempts(Integer totalAttempts) { this.totalAttempts = totalAttempts; }

    public Integer getCorrectAttempts() { return correctAttempts; }
    public void setCorrectAttempts(Integer correctAttempts) { this.correctAttempts = correctAttempts; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    // Helper methods
    public Double getSuccessRate() {
        if (totalAttempts == 0) return 0.0;
        return (double) correctAttempts / totalAttempts * 100;
    }

    public void incrementAttempts(boolean isCorrect) {
        this.totalAttempts++;
        if (isCorrect) {
            this.correctAttempts++;
        }
    }
}
