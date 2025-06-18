package com.leenglish.toeic.enums;

public enum DifficultyLevel {
    BEGINNER("Beginner"),
    ELEMENTARY("Elementary"), 
    INTERMEDIATE("Intermediate"),
    UPPER_INTERMEDIATE("Upper Intermediate"),
    ADVANCED("Advanced");

    private final String displayName;

    DifficultyLevel(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public int getLevel() {
        return switch (this) {
            case BEGINNER -> 1;
            case ELEMENTARY -> 2;
            case INTERMEDIATE -> 3;
            case UPPER_INTERMEDIATE -> 4;
            case ADVANCED -> 5;
        };
    }
}