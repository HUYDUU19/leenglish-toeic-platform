package com.leenglish.toeic.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuestionDto {

    // ================================================================
    // CỐT LÕI - MATCH VỚI Question Entity
    // ================================================================

    private Long id;

    @NotNull(message = "Exercise ID is required")
    private Long exerciseId;

    @NotBlank(message = "Question text is required")
    private String questionText;

    private String questionType; // NEW FIELD

    // Answer Options - CHỈ A, B, C, D cho TOEIC
    private String optionA;
    private String optionB;
    private String optionC;
    private String optionD;

    @NotBlank(message = "Correct answer is required")
    private String correctAnswer; // A, B, C, or D

    private String explanation;

    // Scoring & Order - TỐI THIỂU
    private Integer points;
    private Integer questionOrder;

    private Boolean isActive; // NEW FIELD

    // Note: Không cần createdAt, updatedAt trong DTO
    // Chỉ dành cho internal entity management
}
