-- ================================================================
-- LEENGLISH TOEIC PLATFORM - COMPLETE DATABASE STRUCTURE
-- ================================================================
-- Add all missing tables and update existing users table

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- ================================================================
-- 1. UPDATE USERS TABLE - ADD MISSING SECURITY FIELDS
-- ================================================================

-- Add missing security and profile fields to users table
ALTER TABLE `users` 
ADD COLUMN `email_verified` bit(1) NOT NULL DEFAULT b'0' AFTER `total_score`,
ADD COLUMN `email_verification_token` varchar(255) DEFAULT NULL AFTER `email_verified`,
ADD COLUMN `password_reset_token` varchar(255) DEFAULT NULL AFTER `email_verification_token`,
ADD COLUMN `password_reset_expires` datetime(6) DEFAULT NULL AFTER `password_reset_token`,
ADD COLUMN `streak_days` int(11) NOT NULL DEFAULT 0 AFTER `password_reset_expires`,
ADD COLUMN `login_count` int(11) NOT NULL DEFAULT 0 AFTER `streak_days`,
ADD COLUMN `preferred_language` varchar(10) DEFAULT 'en' AFTER `login_count`,
ADD COLUMN `timezone` varchar(50) DEFAULT 'UTC' AFTER `preferred_language`;

-- Update existing users with realistic data
UPDATE `users` SET 
    `email_verified` = CASE WHEN `id` IN (1, 2, 3, 4, 6, 7) THEN b'1' ELSE b'0' END,
    `streak_days` = CASE 
        WHEN `id` = 2 THEN 2 WHEN `id` = 3 THEN 4 WHEN `id` = 4 THEN 1 
        WHEN `id` = 7 THEN 3 ELSE 0 END,
    `login_count` = CASE 
        WHEN `id` = 1 THEN 25 WHEN `id` = 2 THEN 8 WHEN `id` = 3 THEN 15 
        WHEN `id` = 4 THEN 22 WHEN `id` = 6 THEN 12 WHEN `id` = 7 THEN 18 ELSE 1 END,
    `total_score` = CASE 
        WHEN `id` = 2 THEN 45 WHEN `id` = 3 THEN 85 WHEN `id` = 4 THEN 95 
        WHEN `id` = 6 THEN 35 WHEN `id` = 7 THEN 105 ELSE 0 END,
    `last_login` = CASE 
        WHEN `id` = 1 THEN '2025-06-21 13:00:00.000000'
        WHEN `id` = 2 THEN '2025-06-21 10:30:00.000000'
        WHEN `id` = 3 THEN '2025-06-21 09:15:00.000000'
        WHEN `id` = 4 THEN '2025-06-21 08:45:00.000000'
        WHEN `id` = 6 THEN '2025-06-20 16:30:00.000000'
        WHEN `id` = 7 THEN '2025-06-21 07:20:00.000000'
        ELSE NULL END,
    `country` = CASE 
        WHEN `id` IN (9, 10) THEN 'VN' WHEN `id` = 1 THEN 'US' WHEN `id` = 4 THEN 'UK'
        WHEN `id` = 6 THEN 'AU' ELSE 'US' END,
    `date_of_birth` = CASE 
        WHEN `id` = 1 THEN '1985-01-15' WHEN `id` = 2 THEN '1995-03-22'
        WHEN `id` = 3 THEN '1988-07-10' WHEN `id` = 4 THEN '1992-11-05'
        WHEN `id` = 9 THEN '1999-12-19' WHEN `id` = 10 THEN '1999-12-19'
        ELSE NULL END,
    `gender` = CASE 
        WHEN `id` IN (1, 3, 5, 8, 9, 10) THEN 'MALE'
        WHEN `id` IN (4, 6, 7) THEN 'FEMALE' ELSE 'OTHER' END,
    `phone` = CASE 
        WHEN `id` = 9 THEN '+84-912-345-678' WHEN `id` = 10 THEN '+84-913-456-789'
        WHEN `id` = 1 THEN '+1-555-0001' ELSE NULL END,
    `preferred_language` = CASE WHEN `id` IN (9, 10) THEN 'vi' ELSE 'en' END,
    `timezone` = CASE 
        WHEN `id` IN (9, 10) THEN 'Asia/Ho_Chi_Minh' WHEN `id` = 4 THEN 'Europe/London'
        WHEN `id` = 6 THEN 'Australia/Sydney' ELSE 'America/New_York' END;

-- Add verification tokens for unverified users
UPDATE `users` SET 
    `email_verification_token` = CONCAT(MD5(CONCAT(`email`, '_', `created_at`)), '_', UNIX_TIMESTAMP(NOW()))
WHERE `email_verified` = b'0';

-- ================================================================
-- 2. CATEGORIES TABLE
-- ================================================================
CREATE TABLE `categories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `slug` varchar(100) NOT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `color` varchar(7) DEFAULT '#3B82F6',
  `order_index` int(11) DEFAULT 0,
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `parent_id` bigint(20) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_categories_slug` (`slug`),
  KEY `idx_categories_active` (`is_active`),
  KEY `idx_categories_parent` (`parent_id`),
  CONSTRAINT `fk_categories_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 3. USER SETTINGS TABLE
-- ================================================================
CREATE TABLE `user_settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `setting_type` enum('STRING','NUMBER','BOOLEAN','JSON') DEFAULT 'STRING',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_setting` (`user_id`, `setting_key`),
  CONSTRAINT `fk_user_settings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 4. NOTIFICATIONS TABLE
-- ================================================================
CREATE TABLE `notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `type` enum('INFO','SUCCESS','WARNING','ERROR','REMINDER','ACHIEVEMENT') DEFAULT 'INFO',
  `is_read` bit(1) NOT NULL DEFAULT b'0',
  `is_important` bit(1) NOT NULL DEFAULT b'0',
  `action_url` varchar(500) DEFAULT NULL,
  `expires_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `fk_notifications_user` (`user_id`),
  KEY `idx_notifications_read` (`is_read`),
  KEY `idx_notifications_type` (`type`),
  KEY `idx_notifications_created` (`created_at`),
  CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 5. USER STATISTICS TABLE
-- ================================================================
CREATE TABLE `user_statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `total_lessons_completed` int(11) NOT NULL DEFAULT 0,
  `total_exercises_completed` int(11) NOT NULL DEFAULT 0,
  `total_flashcards_studied` int(11) NOT NULL DEFAULT 0,
  `total_time_spent_minutes` int(11) NOT NULL DEFAULT 0,
  `current_streak_days` int(11) NOT NULL DEFAULT 0,
  `longest_streak_days` int(11) NOT NULL DEFAULT 0,
  `total_points_earned` int(11) NOT NULL DEFAULT 0,
  `current_level` int(11) NOT NULL DEFAULT 1,
  `experience_points` int(11) NOT NULL DEFAULT 0,
  `average_lesson_score` decimal(5,2) DEFAULT 0.00,
  `total_achievements` int(11) NOT NULL DEFAULT 0,
  `favorite_category` varchar(100) DEFAULT NULL,
  `study_time_goal_minutes` int(11) DEFAULT 30,
  `weekly_goal_lessons` int(11) DEFAULT 5,
  `last_activity_date` date DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_statistics` (`user_id`),
  CONSTRAINT `fk_user_statistics_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 6. ACHIEVEMENTS TABLE
-- ================================================================
CREATE TABLE `achievements` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `badge_color` varchar(7) DEFAULT '#FFD700',
  `type` enum('LESSON','EXERCISE','STREAK','SCORE','TIME','SPECIAL') DEFAULT 'LESSON',
  `requirement_type` enum('COUNT','STREAK','SCORE','TIME','CUSTOM') DEFAULT 'COUNT',
  `requirement_value` int(11) NOT NULL,
  `points_reward` int(11) DEFAULT 0,
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `is_hidden` bit(1) NOT NULL DEFAULT b'0',
  `order_index` int(11) DEFAULT 0,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_achievements_type` (`type`),
  KEY `idx_achievements_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 7. USER ACHIEVEMENTS TABLE
-- ================================================================
CREATE TABLE `user_achievements` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `achievement_id` bigint(20) NOT NULL,
  `earned_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `progress_value` int(11) DEFAULT 0,
  `is_claimed` bit(1) NOT NULL DEFAULT b'0',
  `claimed_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_achievement` (`user_id`, `achievement_id`),
  KEY `fk_user_achievements_achievement` (`achievement_id`),
  CONSTRAINT `fk_user_achievements_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_achievements_achievement` FOREIGN KEY (`achievement_id`) REFERENCES `achievements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 8. STUDY SESSIONS TABLE
-- ================================================================
CREATE TABLE `study_sessions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `session_type` enum('LESSON','EXERCISE','FLASHCARD','PRACTICE_TEST') NOT NULL,
  `reference_id` bigint(20) DEFAULT NULL,
  `started_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `ended_at` datetime(6) DEFAULT NULL,
  `duration_minutes` int(11) DEFAULT 0,
  `points_earned` int(11) DEFAULT 0,
  `completion_status` enum('COMPLETED','PAUSED','ABANDONED') DEFAULT 'COMPLETED',
  `score` decimal(5,2) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `device_type` varchar(50) DEFAULT 'WEB',
  `ip_address` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_study_sessions_user` (`user_id`),
  KEY `idx_study_sessions_type` (`session_type`),
  KEY `idx_study_sessions_date` (`started_at`),
  CONSTRAINT `fk_study_sessions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 9. LEARNING PATHS TABLE
-- ================================================================
CREATE TABLE `learning_paths` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `level` enum('BEGINNER','INTERMEDIATE','ADVANCED') DEFAULT 'BEGINNER',
  `estimated_duration_hours` int(11) DEFAULT 10,
  `difficulty_rating` int(1) DEFAULT 1,
  `is_premium` bit(1) NOT NULL DEFAULT b'0',
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `image_url` varchar(500) DEFAULT NULL,
  `prerequisites` text DEFAULT NULL,
  `learning_outcomes` text DEFAULT NULL,
  `order_index` int(11) DEFAULT 0,
  `enrollment_count` int(11) NOT NULL DEFAULT 0,
  `completion_count` int(11) NOT NULL DEFAULT 0,
  `average_rating` decimal(3,2) DEFAULT 0.00,
  `created_by` bigint(20) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_learning_paths_level` (`level`),
  KEY `idx_learning_paths_active` (`is_active`),
  KEY `fk_learning_paths_creator` (`created_by`),
  CONSTRAINT `fk_learning_paths_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 10. FORUMS TABLE
-- ================================================================
CREATE TABLE `forums` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `category` varchar(100) DEFAULT 'General',
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `order_index` int(11) DEFAULT 0,
  `topic_count` int(11) NOT NULL DEFAULT 0,
  `post_count` int(11) NOT NULL DEFAULT 0,
  `last_post_at` datetime(6) DEFAULT NULL,
  `last_post_by` bigint(20) DEFAULT NULL,
  `moderators` json DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_forums_active` (`is_active`),
  KEY `idx_forums_category` (`category`),
  KEY `fk_forums_last_poster` (`last_post_by`),
  CONSTRAINT `fk_forums_last_poster` FOREIGN KEY (`last_post_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 11. SYSTEM LOGS TABLE
-- ================================================================
CREATE TABLE `system_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` bigint(20) DEFAULT NULL,
  `level` enum('DEBUG','INFO','WARN','ERROR','FATAL') DEFAULT 'INFO',
  `message` text DEFAULT NULL,
  `details` json DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_system_logs_user` (`user_id`),
  KEY `idx_system_logs_action` (`action`),
  KEY `idx_system_logs_level` (`level`),
  KEY `idx_system_logs_created` (`created_at`),
  KEY `idx_system_logs_entity` (`entity_type`, `entity_id`),
  CONSTRAINT `fk_system_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 12. ADD ADDITIONAL INDEXES TO USERS TABLE
-- ================================================================
ALTER TABLE `users` 
ADD KEY `idx_email_verification_token` (`email_verification_token`),
ADD KEY `idx_password_reset_token` (`password_reset_token`),
ADD KEY `idx_email_verified` (`email_verified`),
ADD KEY `idx_password_reset_expires` (`password_reset_expires`),
ADD KEY `idx_users_streak_days` (`streak_days`),
ADD KEY `idx_users_country` (`country`),
ADD KEY `idx_users_last_login` (`last_login`),
ADD KEY `idx_users_created_at` (`created_at`),
ADD KEY `idx_users_is_active` (`is_active`),
ADD KEY `idx_users_is_premium` (`is_premium`);

-- ================================================================
-- 13. INSERT SAMPLE DATA
-- ================================================================

-- Categories
INSERT INTO `categories` (`name`, `description`, `slug`, `icon`, `color`, `order_index`) VALUES
('Grammar', 'English grammar rules and structures', 'grammar', 'book-open', '#3B82F6', 1),
('Vocabulary', 'Word learning and expansion', 'vocabulary', 'academic-cap', '#10B981', 2),
('Listening', 'Audio comprehension skills', 'listening', 'musical-note', '#F59E0B', 3),
('Reading', 'Text comprehension and analysis', 'reading', 'document-text', '#EF4444', 4),
('Speaking', 'Oral communication practice', 'speaking', 'microphone', '#8B5CF6', 5),
('Writing', 'Written expression skills', 'writing', 'pencil', '#06B6D4', 6),
('TOEIC Practice', 'Official TOEIC test preparation', 'toeic-practice', 'clipboard-check', '#F97316', 7),
('Business English', 'Professional workplace communication', 'business-english', 'briefcase', '#84CC16', 8);

-- User Statistics for existing users
INSERT INTO `user_statistics` (`user_id`, `total_lessons_completed`, `total_exercises_completed`, `total_flashcards_studied`, `total_time_spent_minutes`, `current_streak_days`, `longest_streak_days`, `total_points_earned`, `current_level`, `experience_points`, `average_lesson_score`, `total_achievements`, `favorite_category`, `study_time_goal_minutes`, `weekly_goal_lessons`, `last_activity_date`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0.00, 0, NULL, 60, 10, NULL),
(2, 2, 4, 15, 85, 2, 3, 45, 2, 45, 92.50, 1, 'Vocabulary', 30, 5, '2025-06-21'),
(3, 4, 7, 25, 148, 4, 4, 85, 3, 85, 88.75, 2, 'Grammar', 45, 7, '2025-06-21'),
(4, 5, 6, 12, 175, 1, 5, 95, 3, 95, 94.20, 3, 'Grammar', 60, 8, '2025-06-21'),
(5, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0.00, 0, NULL, 30, 3, NULL),
(6, 3, 0, 8, 125, 0, 2, 35, 2, 35, 85.00, 1, 'Business English', 45, 6, '2025-06-20'),
(7, 4, 4, 20, 168, 3, 6, 105, 4, 105, 91.25, 4, 'Speaking', 60, 10, '2025-06-21'),
(8, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0.00, 0, NULL, 30, 5, NULL),
(9, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0.00, 0, NULL, 30, 5, NULL),
(10, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0.00, 0, NULL, 30, 5, NULL),
(11, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0.00, 0, NULL, 30, 5, NULL),
(12, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0.00, 0, NULL, 30, 5, NULL),
(13, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0.00, 0, NULL, 30, 5, NULL),
(14, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0.00, 0, NULL, 30, 5, NULL);

-- Achievements
INSERT INTO `achievements` (`name`, `description`, `icon`, `badge_color`, `type`, `requirement_type`, `requirement_value`, `points_reward`, `order_index`) VALUES
('First Steps', 'Complete your first lesson', 'star', '#FFD700', 'LESSON', 'COUNT', 1, 10, 1),
('Getting Started', 'Complete 5 lessons', 'medal', '#C0C0C0', 'LESSON', 'COUNT', 5, 25, 2),
('Lesson Master', 'Complete 10 lessons', 'trophy', '#FFD700', 'LESSON', 'COUNT', 10, 50, 3),
('Exercise Rookie', 'Complete 10 exercises', 'target', '#87CEEB', 'EXERCISE', 'COUNT', 10, 30, 4),
('Week Warrior', 'Study for 7 consecutive days', 'fire', '#FF4500', 'STREAK', 'STREAK', 7, 100, 5),
('Perfect Score', 'Get 100% on any exercise', 'star-fill', '#FFD700', 'SCORE', 'SCORE', 100, 25, 6);

-- User Settings
INSERT INTO `user_settings` (`user_id`, `setting_key`, `setting_value`, `setting_type`) VALUES
(1, 'theme', 'dark', 'STRING'),
(1, 'notifications_enabled', 'true', 'BOOLEAN'),
(2, 'theme', 'light', 'STRING'),
(2, 'daily_goal_minutes', '30', 'NUMBER'),
(3, 'theme', 'light', 'STRING'),
(3, 'notifications_enabled', 'false', 'BOOLEAN'),
(4, 'theme', 'auto', 'STRING'),
(4, 'daily_goal_minutes', '60', 'NUMBER');

-- Notifications
INSERT INTO `notifications` (`user_id`, `title`, `message`, `type`, `is_read`, `is_important`) VALUES
(2, 'Welcome to LeEnglish!', 'Start your English learning journey today. Complete your first lesson to earn points!', 'INFO', b'1', b'1'),
(2, 'Daily Goal Reminder', 'You have 15 minutes left to reach your daily study goal. Keep going!', 'REMINDER', b'0', b'0'),
(3, 'Streak Alert!', 'Great job! You are on a 4-day learning streak. Keep it up!', 'SUCCESS', b'0', b'0'),
(4, 'Achievement Unlocked!', 'Congratulations! You have completed 5 lessons.', 'ACHIEVEMENT', b'1', b'0');

-- Learning Paths
INSERT INTO `learning_paths` (`name`, `description`, `level`, `estimated_duration_hours`, `difficulty_rating`, `is_premium`, `order_index`, `enrollment_count`, `completion_count`, `average_rating`, `created_by`) VALUES
('TOEIC Beginner Path', 'Complete beginner course for TOEIC preparation', 'BEGINNER', 40, 2, b'0', 1, 25, 8, 4.2, 1),
('Business English Mastery', 'Professional English for workplace success', 'INTERMEDIATE', 60, 4, b'1', 2, 15, 3, 4.7, 6),
('Advanced Grammar Course', 'Master complex English grammar structures', 'ADVANCED', 30, 5, b'1', 3, 12, 2, 4.5, 1);

-- Forums
INSERT INTO `forums` (`name`, `description`, `category`, `order_index`, `topic_count`, `post_count`) VALUES
('General Discussion', 'General English learning topics and community chat', 'General', 1, 8, 25),
('TOEIC Preparation', 'TOEIC test strategies, tips, and practice discussions', 'TOEIC', 2, 12, 45),
('Grammar Help', 'Get help with English grammar rules and usage', 'Grammar', 3, 15, 38),
('Study Groups', 'Find study partners and form learning groups', 'Community', 4, 6, 18);

-- System Logs
INSERT INTO `system_logs` (`user_id`, `action`, `entity_type`, `entity_id`, `level`, `message`, `ip_address`) VALUES
(2, 'LOGIN', 'USER', 2, 'INFO', 'User logged in successfully', '192.168.1.100'),
(3, 'COMPLETE_LESSON', 'LESSON', 1, 'INFO', 'User completed lesson successfully', '192.168.1.101'),
(4, 'COMPLETE_EXERCISE', 'EXERCISE', 1, 'INFO', 'User completed exercise with perfect score', '192.168.1.102'),
(1, 'SYSTEM_MAINTENANCE', 'SYSTEM', NULL, 'WARN', 'Scheduled maintenance completed', '127.0.0.1');

COMMIT;

-- ================================================================
-- VERIFICATION QUERY
-- ================================================================
SELECT 'Database structure completed successfully!' as status,
       'All missing tables have been created' as tables_status,
       'Users table updated with security fields' as users_status,
       'Sample data inserted for testing' as data_status;

-- Show updated users table structure
DESCRIBE `users`;

-- Show sample data from new tables
SELECT COUNT(*) as category_count FROM `categories`;
SELECT COUNT(*) as achievement_count FROM `achievements`;
SELECT COUNT(*) as user_stats_count FROM `user_statistics`;
SELECT COUNT(*) as notification_count FROM `notifications`;