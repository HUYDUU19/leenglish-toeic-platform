package com.leenglish.toeic.enums;

public enum ToeicPart {
    PART1("Part 1 - Photographs"),
    PART2("Part 2 - Question-Response"),
    PART3("Part 3 - Conversations"),
    PART4("Part 4 - Talks"),
    PART5("Part 5 - Incomplete Sentences"),
    PART6("Part 6 - Text Completion"),
    PART7("Part 7 - Reading Comprehension");

    private final String displayName;

    ToeicPart(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
