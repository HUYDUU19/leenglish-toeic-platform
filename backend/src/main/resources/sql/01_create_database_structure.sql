-- ================================================================
-- LEENGLISH TOEIC PLATFORM - DATABASE STRUCTURE
-- Created: June 21, 2025
-- Description: Complete database schema for English learning platform
-- ================================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- ================================================================
-- 1. USERS TABLE - Core user management
-- ================================================================
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `email` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `profile_picture_url` varchar(500) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('MALE','FEMALE','OTHER') DEFAULT NULL,
  `role` enum('USER','COLLABORATOR','ADMIN') NOT NULL DEFAULT 'USER',
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `is_premium` bit(1) NOT NULL DEFAULT b'0',
  `premium_expires_at` datetime(6) DEFAULT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `total_score` int(11) NOT NULL DEFAULT 0,
  `streak_days` int(11) NOT NULL DEFAULT 0,
  `login_count` int(11) NOT NULL DEFAULT 0,
  `email_verified` bit(1) NOT NULL DEFAULT b'0',
  `email_verification_token` varchar(255) DEFAULT NULL,
  `password_reset_token` varchar(255) DEFAULT NULL,
  `password_reset_expires` datetime(6) DEFAULT NULL,
  `preferred_language` varchar(10) DEFAULT 'en',
  `timezone` varchar(50) DEFAULT 'UTC',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_email` (`email`),
  UNIQUE KEY `uk_users_username` (`username`),
  KEY `idx_users_email` (`email`),
  KEY `idx_users_username` (`username`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_active` (`is_active`),
  KEY `idx_users_premium` (`is_premium`),
  KEY `idx_users_email_verified` (`email_verified`),
  KEY `idx_users_created_at` (`created_at`),
  KEY `idx_users_last_login` (`last_login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 2. CATEGORIES TABLE - Content categorization
-- ================================================================
CREATE TABLE IF NOT EXISTS `categories` (
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
  KEY `idx_categories_order` (`order_index`),
  CONSTRAINT `fk_categories_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 3. LESSONS TABLE - Learning content
-- ================================================================
CREATE TABLE IF NOT EXISTS `lessons` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `level` varchar(10) DEFAULT NULL,
  `difficulty` varchar(50) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `order_index` int(11) DEFAULT NULL,
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `is_premium` bit(1) NOT NULL DEFAULT b'0',
  `audio_url` varchar(500) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `category_id` bigint(20) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_lessons_level` (`level`),
  KEY `idx_lessons_active` (`is_active`),
  KEY `idx_lessons_premium` (`is_premium`),
  KEY `idx_lessons_difficulty` (`difficulty`),
  KEY `idx_lessons_category` (`category_id`),
  KEY `idx_lessons_order` (`order_index`),
  CONSTRAINT `fk_lessons_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 4. EXERCISES TABLE - Practice exercises
-- ================================================================
CREATE TABLE IF NOT EXISTS `exercises` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `type` varchar(100) NOT NULL,
  `question` varchar(2000) DEFAULT NULL,
  `options` varchar(2000) DEFAULT NULL,
  `correct_answer` varchar(500) DEFAULT NULL,
  `explanation` varchar(1000) DEFAULT NULL,
  `level` varchar(5) DEFAULT NULL,
  `difficulty_level` varchar(255) DEFAULT NULL,
  `points` int(11) DEFAULT NULL,
  `time_limit_seconds` int(11) DEFAULT NULL,
  `order_index` int(11) DEFAULT NULL,
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `is_premium` bit(1) NOT NULL DEFAULT b'0',
  `audio_url` varchar(500) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `lesson_id` bigint(20) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_exercises_lesson` (`lesson_id`),
  KEY `idx_exercises_type` (`type`),
  KEY `idx_exercises_difficulty` (`difficulty_level`),
  KEY `idx_exercises_active` (`is_active`),
  KEY `idx_exercises_premium` (`is_premium`),
  CONSTRAINT `fk_exercises_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 5. FLASHCARD SETS TABLE - Flashcard collections
-- ================================================================
CREATE TABLE IF NOT EXISTS `flashcard_sets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `difficulty_level` varchar(255) DEFAULT NULL,
  `estimated_time_minutes` int(11) DEFAULT NULL,
  `tags` varchar(255) DEFAULT NULL,
  `is_active` bit(1) DEFAULT b'1',
  `is_public` bit(1) DEFAULT b'1',
  `is_premium` bit(1) DEFAULT b'0',
  `view_count` int(11) DEFAULT 0,
  `created_by` bigint(20) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_flashcard_sets_category` (`category`),
  KEY `idx_flashcard_sets_active` (`is_active`),
  KEY `idx_flashcard_sets_public` (`is_public`),
  KEY `idx_flashcard_sets_premium` (`is_premium`),
  KEY `idx_flashcard_sets_creator` (`created_by`),
  CONSTRAINT `fk_flashcard_sets_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 6. FLASHCARDS TABLE - Individual flashcards
-- ================================================================
CREATE TABLE IF NOT EXISTS `flashcards` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `front_text` varchar(255) NOT NULL,
  `back_text` text NOT NULL,
  `explanation` text DEFAULT NULL,
  `hint` text DEFAULT NULL,
  `category` varchar(255) NOT NULL,
  `level` varchar(255) DEFAULT NULL,
  `tags` varchar(255) DEFAULT NULL,
  `audio_url` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `is_active` bit(1) DEFAULT b'1',
  `is_public` bit(1) DEFAULT b'1',
  `view_count` int(11) DEFAULT 0,
  `correct_count` int(11) DEFAULT 0,
  `incorrect_count` int(11) DEFAULT 0,
  `flashcard_set_id` bigint(20) DEFAULT NULL,
  `created_by` bigint(20) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_flashcards_category` (`category`),
  KEY `idx_flashcards_level` (`level`),
  KEY `idx_flashcards_active` (`is_active`),
  KEY `idx_flashcards_set` (`flashcard_set_id`),
  KEY `idx_flashcards_creator` (`created_by`),
  CONSTRAINT `fk_flashcards_set` FOREIGN KEY (`flashcard_set_id`) REFERENCES `flashcard_sets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_flashcards_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 7. MOCK TESTS TABLE - Test definitions
-- ================================================================
CREATE TABLE IF NOT EXISTS `mock_tests` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `level` varchar(5) DEFAULT NULL,
  `duration_minutes` int(11) DEFAULT 120,
  `total_questions` int(11) DEFAULT 0,
  `is_active` bit(1) DEFAULT b'1',
  `is_premium` bit(1) DEFAULT b'0',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_mock_tests_level` (`level`),
  KEY `idx_mock_tests_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 8. MEMBERSHIP PLANS TABLE - Subscription plans
-- ================================================================
CREATE TABLE IF NOT EXISTS `membership_plans` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `currency` varchar(3) DEFAULT 'USD',
  `duration_days` int(11) NOT NULL,
  `membership_type` enum('MONTHLY','YEARLY','LIFETIME') NOT NULL,
  `features` text DEFAULT NULL,
  `max_lessons_per_day` int(11) DEFAULT NULL,
  `max_exercises_per_day` int(11) DEFAULT NULL,
  `max_flashcards_per_set` int(11) DEFAULT NULL,
  `has_premium_content` bit(1) DEFAULT b'0',
  `has_audio_access` bit(1) DEFAULT b'0',
  `has_progress_tracking` bit(1) DEFAULT b'1',
  `priority_support` bit(1) DEFAULT b'0',
  `download_offline` bit(1) DEFAULT b'0',
  `unlimited_flashcards` bit(1) DEFAULT b'0',
  `is_active` bit(1) DEFAULT b'1',
  `is_popular` bit(1) DEFAULT b'0',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_membership_plans_name` (`name`),
  KEY `idx_membership_plans_active` (`is_active`),
  KEY `idx_membership_plans_type` (`membership_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 9. USER LESSON PROGRESS TABLE - Track lesson completion
-- ================================================================
CREATE TABLE IF NOT EXISTS `user_lesson_progress` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `lesson_id` bigint(20) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'NOT_STARTED',
  `progress_percentage` int(11) NOT NULL DEFAULT 0,
  `time_spent_minutes` int(11) DEFAULT 0,
  `notes` text DEFAULT NULL,
  `started_at` datetime(6) DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `last_accessed_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_lesson_progress` (`user_id`, `lesson_id`),
  KEY `idx_user_lesson_progress_user` (`user_id`),
  KEY `idx_user_lesson_progress_lesson` (`lesson_id`),
  KEY `idx_user_lesson_progress_status` (`status`),
  CONSTRAINT `fk_user_lesson_progress_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_lesson_progress_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 10. USER EXERCISE ATTEMPTS TABLE - Track exercise attempts
-- ================================================================
CREATE TABLE IF NOT EXISTS `user_exercise_attempts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `exercise_id` bigint(20) DEFAULT NULL,
  `attempt_number` int(11) DEFAULT 1,
  `status` varchar(30) NOT NULL DEFAULT 'IN_PROGRESS',
  `score` double DEFAULT 0,
  `correct_answers` int(11) DEFAULT 0,
  `total_questions` int(11) NOT NULL DEFAULT 1,
  `time_taken` int(11) DEFAULT 0,
  `started_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `completed_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_exercise_attempts_user` (`user_id`),
  KEY `idx_user_exercise_attempts_exercise` (`exercise_id`),
  KEY `idx_user_exercise_attempts_status` (`status`),
  CONSTRAINT `fk_user_exercise_attempts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_exercise_attempts_exercise` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 11. TEST RESULTS TABLE - Store test scores
-- ================================================================
CREATE TABLE IF NOT EXISTS `test_results` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `mock_test_id` bigint(20) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `max_score` int(11) DEFAULT 100,
  `percentage` decimal(5,2) DEFAULT NULL,
  `time_taken_minutes` int(11) DEFAULT NULL,
  `correct_answers` int(11) DEFAULT 0,
  `total_questions` int(11) DEFAULT 0,
  `taken_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_test_results_user` (`user_id`),
  KEY `idx_test_results_test` (`mock_test_id`),
  KEY `idx_test_results_taken` (`taken_at`),
  CONSTRAINT `fk_test_results_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_test_results_test` FOREIGN KEY (`mock_test_id`) REFERENCES `mock_tests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 12. USER MEMBERSHIPS TABLE - Track user subscriptions
-- ================================================================
CREATE TABLE IF NOT EXISTS `user_memberships` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `membership_plan_id` bigint(20) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'ACTIVE',
  `payment_status` varchar(255) DEFAULT 'PENDING',
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `auto_renew` bit(1) DEFAULT b'0',
  `cancellation_reason` varchar(255) DEFAULT NULL,
  `cancelled_at` datetime(6) DEFAULT NULL,
  `is_active` bit(1) DEFAULT b'1',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_user_memberships_user` (`user_id`),
  KEY `idx_user_memberships_plan` (`membership_plan_id`),
  KEY `idx_user_memberships_status` (`status`),
  KEY `idx_user_memberships_active` (`is_active`),
  CONSTRAINT `fk_user_memberships_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_memberships_plan` FOREIGN KEY (`membership_plan_id`) REFERENCES `membership_plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 13. COMMENTS TABLE - User comments on lessons
-- ================================================================
CREATE TABLE IF NOT EXISTS `comments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `lesson_id` bigint(20) DEFAULT NULL,
  `content` text NOT NULL,
  `is_approved` bit(1) DEFAULT b'1',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_comments_user` (`user_id`),
  KEY `idx_comments_lesson` (`lesson_id`),
  KEY `idx_comments_approved` (`is_approved`),
  KEY `idx_comments_created` (`created_at`),
  CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comments_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 14. USER STATISTICS TABLE - Detailed user analytics
-- ================================================================
CREATE TABLE IF NOT EXISTS `user_statistics` (
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
  KEY `idx_user_statistics_level` (`current_level`),
  KEY `idx_user_statistics_streak` (`current_streak_days`),
  KEY `idx_user_statistics_activity` (`last_activity_date`),
  CONSTRAINT `fk_user_statistics_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 15. ACHIEVEMENTS TABLE - Available achievements
-- ================================================================
CREATE TABLE IF NOT EXISTS `achievements` (
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
  KEY `idx_achievements_active` (`is_active`),
  KEY `idx_achievements_order` (`order_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 16. USER ACHIEVEMENTS TABLE - User earned achievements
-- ================================================================
CREATE TABLE IF NOT EXISTS `user_achievements` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `achievement_id` bigint(20) NOT NULL,
  `earned_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `progress_value` int(11) DEFAULT 0,
  `is_claimed` bit(1) NOT NULL DEFAULT b'0',
  `claimed_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_achievement` (`user_id`, `achievement_id`),
  KEY `idx_user_achievements_user` (`user_id`),
  KEY `idx_user_achievements_achievement` (`achievement_id`),
  KEY `idx_user_achievements_earned` (`earned_at`),
  CONSTRAINT `fk_user_achievements_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_achievements_achievement` FOREIGN KEY (`achievement_id`) REFERENCES `achievements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 17. NOTIFICATIONS TABLE - User notifications
-- ================================================================
CREATE TABLE IF NOT EXISTS `notifications` (
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
  KEY `idx_notifications_user` (`user_id`),
  KEY `idx_notifications_read` (`is_read`),
  KEY `idx_notifications_type` (`type`),
  KEY `idx_notifications_created` (`created_at`),
  CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 18. USER SETTINGS TABLE - User preferences
-- ================================================================
CREATE TABLE IF NOT EXISTS `user_settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `setting_type` enum('STRING','NUMBER','BOOLEAN','JSON') DEFAULT 'STRING',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_setting` (`user_id`, `setting_key`),
  KEY `idx_user_settings_user` (`user_id`),
  CONSTRAINT `fk_user_settings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- ================================================================
-- 19. SYSTEM LOGS TABLE - System activity tracking
-- ================================================================
CREATE TABLE IF NOT EXISTS `system_logs` (
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
  `request_id` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_system_logs_user` (`user_id`),
  KEY `idx_system_logs_action` (`action`),
  KEY `idx_system_logs_level` (`level`),
  KEY `idx_system_logs_created` (`created_at`),
  KEY `idx_system_logs_entity` (`entity_type`, `entity_id`),
  CONSTRAINT `fk_system_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

COMMIT;

-- ================================================================
-- VERIFICATION
-- ================================================================
SELECT 'Database structure created successfully!' as status;

-- Show created tables
SHOW TABLES;

-- Show table counts
SELECT 
    'STRUCTURE CREATED' as phase,
    COUNT(*) as total_tables_created
FROM information_schema.tables 
WHERE table_schema = DATABASE();

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;