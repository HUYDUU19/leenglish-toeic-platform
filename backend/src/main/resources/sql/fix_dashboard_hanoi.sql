-- Quick fix for dashboard API - Insert data for HANOI user (id=7)
-- Execute this in phpMyAdmin to fix the 500 error

-- Create user_stats entry for HANOI user
INSERT INTO `user_stats` (
    `user_id`, 
    `lessons_completed`, 
    `practice_tests`, 
    `average_score`, 
    `study_streak`, 
    `total_study_time`, 
    `total_flashcards_studied`, 
    `highest_score`, 
    `last_study_date`,
    `created_at`,
    `updated_at`,
    `is_active`
) VALUES 
(7, 3, 1, 68.50, 1, 90, 25, 75, '2025-06-23 16:00:00.000000', '2025-06-21 14:30:08.000000', NOW(), 1)
ON DUPLICATE KEY UPDATE
    `lessons_completed` = 3,
    `practice_tests` = 1,
    `average_score` = 68.50,
    `study_streak` = 1,
    `total_study_time` = 90,
    `total_flashcards_studied` = 25,
    `highest_score` = 75,
    `last_study_date` = '2025-06-23 16:00:00.000000',
    `updated_at` = NOW();

-- Create user_activities entries for HANOI user
INSERT INTO `user_activities` (
    `user_id`, 
    `activity_type`, 
    `title`, 
    `description`, 
    `score`, 
    `duration_minutes`, 
    `points_earned`, 
    `lesson_id`, 
    `flashcard_set_id`, 
    `exercise_id`, 
    `created_at`,
    `is_active`
) VALUES 
(7, 'LOGIN', 'Daily Login', 'User logged in today', NULL, NULL, 5, NULL, NULL, NULL, '2025-06-23 14:00:00.000000', 1),
(7, 'LESSON_COMPLETED', 'Basic Grammar Lesson 1', 'Completed introduction to TOEIC grammar basics', 75, 25, 15, 1, NULL, NULL, '2025-06-23 15:30:00.000000', 1),
(7, 'FLASHCARD_STUDY', 'Vocabulary Set - Common Words', 'Studied 25 flashcards on common TOEIC vocabulary', 68, 15, 10, NULL, 1, NULL, '2025-06-23 14:45:00.000000', 1),
(7, 'PRACTICE_TEST', 'Practice Test 1', 'First practice test attempt', 65, 45, 20, NULL, NULL, NULL, '2025-06-23 16:00:00.000000', 1)
ON DUPLICATE KEY UPDATE
    `title` = VALUES(`title`),
    `description` = VALUES(`description`),
    `score` = VALUES(`score`),
    `duration_minutes` = VALUES(`duration_minutes`),
    `points_earned` = VALUES(`points_earned`);
