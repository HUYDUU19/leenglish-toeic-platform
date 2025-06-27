package com.leenglish.toeic.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "questions")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exercise_id", nullable = false)
    private Exercise exercise;

    // ================================================================
    // CỐT LÕI - CHỈ NHỮNG GÌ CẦN THIẾT
    // ================================================================

    @Column(name = "question_text", columnDefinition = "TEXT", nullable = false)
    private String questionText;

    // Answer Options - CHỈ A, B, C, D cho TOEIC
    @Column(name = "option_a", length = 500)
    private String optionA;

    @Column(name = "option_b", length = 500)
    private String optionB;

    @Column(name = "option_c", length = 500)
    private String optionC;

    @Column(name = "option_d", length = 500)
    private String optionD;

    // Correct Answer - CHỈ CẦN THIẾT
    @Column(name = "correct_answer", nullable = false, length = 1)
    private String correctAnswer; // A, B, C, or D

    // Explanation - CƠ BẢN
    @Column(name = "explanation", columnDefinition = "TEXT")
    private String explanation;

    // Scoring & Order - TỐI THIỂU
    @Column(name = "points")
    @Builder.Default
    private Integer points = 1;

    @Column(name = "question_order")
    @Builder.Default
    private Integer questionOrder = 0;

    // Status - CẦN THIẾT
    @Column(name = "is_active")
    @Builder.Default
    private Boolean isActive = true;

    // Timestamps - TỰ ĐỘNG
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}
