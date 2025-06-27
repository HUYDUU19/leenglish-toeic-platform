-- SQL script to insert sample data into user_stats and user_activities tables
-- This script creates the tables with the correct schema expected by the Java entities
-- and inserts realistic sample data for testing

-- ========================================
-- Create user_stats table (if not exists)
-- ========================================
CREATE TABLE IF NOT EXISTS `user_stats` (
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
    `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
    `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
    `is_active` bit(1) NOT NULL DEFAULT b'1',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_stats_user_id` (`user_id`),
    KEY `idx_user_stats_user_id` (`user_id`),
    CONSTRAINT `fk_user_stats_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ========================================
-- Create user_activities table (if not exists)
-- ========================================
CREATE TABLE IF NOT EXISTS `user_activities` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `user_id` bigint(20) NOT NULL,
    `activity_type` enum('LESSON_COMPLETED','PRACTICE_TEST','FLASHCARD_STUDY','EXERCISE_COMPLETED','ACHIEVEMENT_EARNED','LOGIN','STREAK_MILESTONE','SCORE_IMPROVEMENT','QUESTION_ANSWERED') NOT NULL,
    `title` varchar(255) NOT NULL,
    `description` text DEFAULT NULL,
    `score` int(11) DEFAULT NULL,
    `duration_minutes` int(11) DEFAULT NULL,
    `points_earned` int(11) DEFAULT 0,
    `lesson_id` bigint(20) DEFAULT NULL,
    `flashcard_set_id` bigint(20) DEFAULT NULL,
    `exercise_id` bigint(20) DEFAULT NULL,
    `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
    `is_active` bit(1) NOT NULL DEFAULT b'1',
    PRIMARY KEY (`id`),
    KEY `idx_user_activities_user_id` (`user_id`),
    KEY `idx_user_activities_type` (`activity_type`),
    KEY `idx_user_activities_created_at` (`created_at`),
    CONSTRAINT `fk_user_activities_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ========================================
-- Insert sample data into user_stats
-- ========================================

-- Clear existing data
DELETE FROM `user_stats` WHERE `user_id` IN (1, 2, 3, 4, 5, 11, 12, 13, 14);

-- Insert sample user stats for existing users
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
-- Admin user (user_id: 1)
(1, 0, 0, 0.00, 0, 0, 0, 0, NULL, NOW(), NOW(), 1),

-- Test User (user_id: 2) - Active learner
(2, 25, 8, 78.50, 12, 1250, 180, 92, '2025-01-21 10:30:00', '2025-06-16 17:02:58', NOW(), 1),

-- Test User 2 (user_id: 11) - Beginner
(11, 5, 2, 65.00, 3, 320, 45, 75, '2025-01-20 14:20:00', '2025-06-20 06:13:02', NOW(), 1),

-- Test User 3 (user_id: 12) - Intermediate
(12, 15, 5, 82.30, 7, 890, 120, 88, '2025-01-21 09:15:00', '2025-06-20 06:18:07', NOW(), 1),

-- Test API User (user_id: 13) - Advanced
(13, 45, 15, 89.75, 25, 2100, 350, 95, '2025-01-21 08:45:00', '2025-06-20 08:39:20', NOW(), 1),

-- Add data for HANOI user (user_id: 7) to match the existing user
(7, 3, 1, 68.50, 1, 90, 25, 75, '2025-06-23 16:00:00.000000', '2025-06-21 14:30:08.000000', NOW(), 1);

-- ========================================
-- Insert sample data into user_activities
-- ========================================

-- Clear existing data
DELETE FROM `user_activities` WHERE `user_id` IN (1, 2, 3, 4, 5, 7, 11, 12, 13, 14);

-- Insert sample activities for HANOI user (user_id: 7) - This is our test user
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
-- Recent activities for HANOI user (user_id: 7)
(7, 'LOGIN', 'Daily Login', 'User logged in today', NULL, NULL, 5, NULL, NULL, NULL, '2025-06-23 14:00:00.000000', 1),
(7, 'LESSON_COMPLETED', 'Basic Grammar Lesson 1', 'Completed introduction to TOEIC grammar basics', 75, 25, 15, 1, NULL, NULL, '2025-06-23 15:30:00.000000', 1),
(7, 'FLASHCARD_STUDY', 'Vocabulary Set - Common Words', 'Studied 25 flashcards on common TOEIC vocabulary', 68, 15, 10, NULL, 1, NULL, '2025-06-23 14:45:00.000000', 1),
(7, 'PRACTICE_TEST', 'Practice Test 1', 'First practice test attempt', 65, 45, 20, NULL, NULL, NULL, '2025-06-23 16:00:00.000000', 1),
(2, 'LOGIN', 'Daily Login', 'User logged in to continue their learning journey', NULL, NULL, 5, NULL, NULL, NULL, '2025-01-21 10:30:00', 1),
(2, 'LESSON_COMPLETED', 'Completed Business English Lesson', 'Finished studying business vocabulary and expressions', 88, 35, 25, 1, NULL, NULL, '2025-01-21 09:45:00', 1),
(2, 'EXERCISE_COMPLETED', 'Business Vocabulary Exercise', 'Completed Part 5 grammar exercise with 8/10 correct answers', 80, 12, 15, NULL, NULL, 1, '2025-01-21 09:15:00', 1),
(2, 'FLASHCARD_STUDY', 'Studied TOEIC Vocabulary Set', 'Reviewed 25 flashcards from advanced vocabulary set', NULL, 20, 10, NULL, 1, NULL, '2025-01-21 08:30:00', 1),
(2, 'PRACTICE_TEST', 'TOEIC Reading Practice', 'Completed a full reading section practice test', 92, 75, 50, NULL, NULL, NULL, '2025-01-20 14:00:00', 1),
(2, 'ACHIEVEMENT_EARNED', '7-Day Streak Achievement', 'Earned achievement for maintaining a 7-day study streak', NULL, NULL, 100, NULL, NULL, NULL, '2025-01-20 10:30:00', 1),

-- Activities for Test User 2 (user_id: 11)
(11, 'LOGIN', 'Daily Login', 'New user exploring the platform', NULL, NULL, 5, NULL, NULL, NULL, '2025-01-20 14:20:00', 1),
(11, 'LESSON_COMPLETED', 'Basic Grammar Lesson', 'Completed introductory lesson on basic grammar', 65, 25, 20, 2, NULL, NULL, '2025-01-20 14:00:00', 1),
(11, 'FLASHCARD_STUDY', 'Basic Vocabulary Cards', 'Studied 15 basic vocabulary flashcards', NULL, 15, 8, NULL, 2, NULL, '2025-01-20 13:30:00', 1),

-- Activities for Test User 3 (user_id: 12)
(12, 'LOGIN', 'Daily Login', 'Regular user maintaining study routine', NULL, NULL, 5, NULL, NULL, NULL, '2025-01-21 09:15:00', 1),
(12, 'LESSON_COMPLETED', 'Listening Comprehension', 'Completed intermediate listening lesson', 82, 40, 30, 3, NULL, NULL, '2025-01-21 08:45:00', 1),
(12, 'EXERCISE_COMPLETED', 'Listening Part 3 Practice', 'Practiced conversation listening skills', 85, 18, 20, NULL, NULL, 2, '2025-01-21 08:15:00', 1),
(12, 'STREAK_MILESTONE', '5-Day Streak', 'Achieved 5 consecutive days of study', NULL, NULL, 50, NULL, NULL, NULL, '2025-01-20 09:15:00', 1),

-- Activities for Test API User (user_id: 13)
(13, 'LOGIN', 'Daily Login', 'Advanced user with consistent study habits', NULL, NULL, 5, NULL, NULL, NULL, '2025-01-21 08:45:00', 1),
(13, 'PRACTICE_TEST', 'Full TOEIC Practice Test', 'Completed comprehensive TOEIC practice test', 95, 120, 100, NULL, NULL, NULL, '2025-01-21 07:00:00', 1),
(13, 'LESSON_COMPLETED', 'Advanced Reading Strategies', 'Mastered advanced reading comprehension techniques', 92, 45, 40, 4, NULL, NULL, '2025-01-20 16:30:00', 1),
(13, 'FLASHCARD_STUDY', 'Advanced Business Terms', 'Studied complex business vocabulary', NULL, 30, 15, NULL, 3, NULL, '2025-01-20 15:45:00', 1),
(13, 'ACHIEVEMENT_EARNED', '20-Day Streak Achievement', 'Exceptional dedication with 20+ day streak', NULL, NULL, 200, NULL, NULL, NULL, '2025-01-19 08:45:00', 1),

-- Activities for hihihaha user (user_id: 14)
(14, 'LOGIN', 'First Login', 'Welcome! First time using the platform', NULL, NULL, 10, NULL, NULL, NULL, '2025-01-19 16:30:00', 1),
(14, 'LESSON_COMPLETED', 'Welcome Lesson', 'Completed the introductory lesson', 55, 20, 15, 5, NULL, NULL, '2025-01-19 16:10:00', 1);

-- ========================================
-- Verification queries (commented out)
-- ========================================

-- Check inserted user_stats data:
-- SELECT us.*, u.username, u.full_name 
-- FROM user_stats us 
-- JOIN users u ON us.user_id = u.id 
-- ORDER BY us.user_id;

-- Check inserted user_activities data:
-- SELECT ua.*, u.username 
-- FROM user_activities ua 
-- JOIN users u ON ua.user_id = u.id 
-- ORDER BY ua.created_at DESC 
-- LIMIT 20;

-- Count activities by type:
-- SELECT activity_type, COUNT(*) as count 
-- FROM user_activities 
-- GROUP BY activity_type 
-- ORDER BY count DESC;

-- Check total records:
-- SELECT 
--     (SELECT COUNT(*) FROM user_stats) as total_user_stats,
--     (SELECT COUNT(*) FROM user_activities) as total_user_activities;

COMMIT;
