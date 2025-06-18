package com.leenglish.toeic.enums;

public enum LessonType {
    LISTENING("Listening Skills"),
    READING("Reading Skills"),
    MIXED("Mixed Skills"),
    VOCABULARY("Vocabulary Building"),
    GRAMMAR("Grammar Practice");

    private final String description;

    LessonType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
