package com.leenglish.toeic.enums;

public enum ExerciseType {
    MULTIPLE_CHOICE("Multiple Choice"),
    FILL_IN_BLANK("Fill in the Blank"),
    TRUE_FALSE("True/False"),
    MATCHING("Matching"),
    LISTENING_COMPREHENSION("Listening Comprehension"),
    READING_COMPREHENSION("Reading Comprehension"),
    GRAMMAR_CHECK("Grammar Check"),
    VOCABULARY_QUIZ("Vocabulary Quiz");

    private final String displayName;

    ExerciseType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
