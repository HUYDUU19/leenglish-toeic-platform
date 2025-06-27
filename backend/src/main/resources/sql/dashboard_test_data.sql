-- Clean SQL script for dashboard testing
-- Only inserts data for existing users: admin (1), user1 (2), HANOI (7)

-- ========================================
-- Create user_stats table
-- ========================================
DROP TABLE IF EXISTS `user_stats`;

CREATE TABLE `user_stats` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `user_id` bigint(20) NOT NULL,
    `lessons_completed` int(11) NOT NULL DEFAULT 0,
    `practice_tests` int(11) NOT NULL DEFAULT 0,
    `average_score` decimal(5,2) NOT NULL DEFAULT 0.00,
    `study_streak` int(11) NOT NULL DEFAULT 0,
    `total_study_time` int(11) NOT NULL DEFAULT 0,
    `total_flashcards_studied` int(11) NOT NULL DEFAULT 0,
    `highest_score` int(11) NOT NULL DEFAULT 0,
    `last_study_date` datetime(6) DEFAULT NULL,
    `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    `is_active` bit(1) NOT NULL DEFAULT b'1',
    PRIMARY KEY (`id`),
    UNIQUE KEY `UK_user_stats_user_id` (`user_id`),
    CONSTRAINT `FK_user_stats_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ========================================
-- Create user_activities table 
-- ========================================
DROP TABLE IF EXISTS `user_activities`;

CREATE TABLE `user_activities` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `user_id` bigint(20) NOT NULL,
    `activity_type` enum('LESSON_COMPLETED','PRACTICE_TEST','FLASHCARD_STUDY','EXERCISE_COMPLETED','ACHIEVEMENT_EARNED','LOGIN','STREAK_MILESTONE','SCORE_IMPROVEMENT','QUESTION_ANSWERED') NOT NULL,
    `title` varchar(255) NOT NULL,
    `description` text DEFAULT NULL,
    `score` int(11) DEFAULT NULL,
    `duration_minutes` int(11) DEFAULT NULL,
    `points_earned` int(11) DEFAULT 0,
    `lesson_id` bigint(20) DEFAULT NULL,
    `exercise_id` bigint(20) DEFAULT NULL,
    `flashcard_set_id` bigint(20) DEFAULT NULL,
    `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    `is_active` bit(1) NOT NULL DEFAULT b'1',
    PRIMARY KEY (`id`),
    KEY `FK_user_activities_user` (`user_id`),
    CONSTRAINT `FK_user_activities_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ========================================
-- Insert user_stats data
-- ========================================
INSERT INTO `user_stats` (
    `user_id`, `lessons_completed`, `practice_tests`, `average_score`, 
    `study_streak`, `total_study_time`, `total_flashcards_studied`, 
    `highest_score`, `last_study_date`, `created_at`, `updated_at`, `is_active`
) VALUES
-- Admin user (id=1)
(1, 50, 25, 95.50, 30, 1800, 500, 98, '2025-06-23 14:00:00.000000', '2025-06-01 10:00:00.000000', '2025-06-23 14:00:00.000000', b'1'),

-- user1 (id=2) 
(2, 15, 8, 78.25, 5, 450, 120, 85, '2025-06-21 13:30:00.000000', '2025-06-02 11:00:00.000000', '2025-06-21 13:30:00.000000', b'1'),

-- HANOI (id=7) - Our test user
(7, 3, 1, 68.50, 1, 90, 25, 75, '2025-06-23 16:00:00.000000', '2025-06-21 14:30:08.000000', '2025-06-23 16:00:00.000000', b'1');

-- ========================================
-- Insert user_activities data
-- ========================================
INSERT INTO `user_activities` (
    `user_id`, `activity_type`, `title`, `description`, `score`, `duration_minutes`, 
    `points_earned`, `lesson_id`, `exercise_id`, `flashcard_set_id`, 
    `created_at`, `updated_at`, `is_active`
) VALUES
-- HANOI user (id=7) activities - Recent for dashboard testing
(7, 'LESSON_COMPLETED', 'Basic Grammar Lesson 1', 'Completed introduction to TOEIC grammar basics', 75, 25, 15, 1, NULL, NULL, '2025-06-23 15:30:00.000000', '2025-06-23 15:30:00.000000', b'1'),
(7, 'FLASHCARD_STUDY', 'Vocabulary Set - Common Words', 'Studied 25 flashcards on common TOEIC vocabulary', 68, 15, 10, NULL, NULL, 1, '2025-06-23 14:45:00.000000', '2025-06-23 14:45:00.000000', b'1'),
(7, 'PRACTICE_TEST', 'Practice Test 1', 'First practice test attempt', 65, 45, 20, NULL, NULL, NULL, '2025-06-23 16:00:00.000000', '2025-06-23 16:00:00.000000', b'1'),
(7, 'LOGIN', 'Daily Login', 'User logged in today', NULL, NULL, 5, NULL, NULL, NULL, '2025-06-23 14:00:00.000000', '2025-06-23 14:00:00.000000', b'1'),

-- Admin user (id=1) activities
(1, 'LESSON_COMPLETED', 'Advanced Reading Comprehension', 'Completed advanced reading strategies', 98, 35, 25, 5, NULL, NULL, '2025-06-23 13:00:00.000000', '2025-06-23 13:00:00.000000', b'1'),
(1, 'PRACTICE_TEST', 'Full Practice Test', 'Complete 2-hour practice test', 95, 120, 50, NULL, NULL, NULL, '2025-06-23 10:00:00.000000', '2025-06-23 10:00:00.000000', b'1'),
(1, 'ACHIEVEMENT_EARNED', 'Perfect Score', 'Achieved perfect score on listening section', 100, NULL, 100, NULL, NULL, NULL, '2025-06-23 11:30:00.000000', '2025-06-23 11:30:00.000000', b'1'),

-- user1 (id=2) activities
(2, 'LESSON_COMPLETED', 'Listening Practice 3', 'Completed listening comprehension exercises', 82, 30, 18, 3, NULL, NULL, '2025-06-21 13:00:00.000000', '2025-06-21 13:00:00.000000', b'1'),
(2, 'FLASHCARD_STUDY', 'Business Vocabulary', 'Studied business-related TOEIC words', 78, 20, 12, NULL, NULL, 2, '2025-06-21 12:30:00.000000', '2025-06-21 12:30:00.000000', b'1'),
(2, 'PRACTICE_TEST', 'Mini Test - Part 1', 'Photo description practice test', 85, 15, 15, NULL, NULL, NULL, '2025-06-21 11:45:00.000000', '2025-06-21 11:45:00.000000', b'1');

-- ========================================
-- Create indexes for performance
-- ========================================
CREATE INDEX `idx_user_stats_user_id` ON `user_stats` (`user_id`);
CREATE INDEX `idx_user_stats_last_study_date` ON `user_stats` (`last_study_date`);
CREATE INDEX `idx_user_stats_study_streak` ON `user_stats` (`study_streak`);
CREATE INDEX `idx_user_stats_average_score` ON `user_stats` (`average_score`);

CREATE INDEX `idx_user_activities_activity_type` ON `user_activities` (`activity_type`);
CREATE INDEX `idx_user_activities_created_at` ON `user_activities` (`created_at`);
CREATE INDEX `idx_user_activities_user_created` ON `user_activities` (`user_id`, `created_at`);
CREATE INDEX `idx_user_activities_score` ON `user_activities` (`score`);
CREATE INDEX `idx_user_activities_points` ON `user_activities` (`points_earned`);

COMMIT;
