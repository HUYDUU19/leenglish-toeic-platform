package com.leenglish.toeic.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuestionDto {
    private Long id;
    private String text;
    private String type;
    private List<String> options;
    private String correctAnswer;
    private String explanation;
    private Integer orderIndex;
}
