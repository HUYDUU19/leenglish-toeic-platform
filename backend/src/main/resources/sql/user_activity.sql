-- USER ACTIVITY TABLE - TOEIC Learning Platform
-- Bảng lưu trữ hoạt động học tập của người dùng

DROP TABLE IF EXISTS `user_activities`;

CREATE TABLE `user_activities` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `type` enum('LESSON','TEST','FLASHCARD','EXERCISE','ACHIEVEMENT','LOGIN','STUDY_SESSION') NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `score` int(11) DEFAULT NULL COMMENT 'Score achieved (0-100)',
  `duration_minutes` int(11) DEFAULT NULL COMMENT 'Duration in minutes',
  `points_earned` int(11) DEFAULT 0,
  `lesson_id` bigint(20) DEFAULT NULL,
  `exercise_id` bigint(20) DEFAULT NULL,
  `flashcard_set_id` bigint(20) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`id`),  KEY `FK_user_activities_user` (`user_id`),
  KEY `idx_user_activities_type` (`type`),
  KEY `idx_user_activities_created_at` (`created_at`),
  KEY `idx_user_activities_user_created` (`user_id`, `created_at`),
  CONSTRAINT `FK_user_activities_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- SAMPLE DATA FOR USER_ACTIVITY

INSERT INTO `user_activities` (
  `user_id`, `type`, `title`, `description`, `score`, `duration_minutes`, 
  `points_earned`, `lesson_id`, `exercise_id`, `flashcard_set_id`, 
  `created_at`, `updated_at`, `is_active`
) VALUES

-- HANOI USER (id=7) ACTIVITIES - Recent activities for dashboard testing
(7, 'LESSON', 'Basic Grammar Lesson 1', 'Completed introduction to TOEIC grammar basics', 75, 25, 15, 1, NULL, NULL, '2025-06-23 15:30:00.000000', '2025-06-23 15:30:00.000000', b'1'),

(7, 'FLASHCARD', 'Vocabulary Set - Common Words', 'Studied 25 flashcards on common TOEIC vocabulary', 68, 15, 10, NULL, NULL, 1, '2025-06-23 14:45:00.000000', '2025-06-23 14:45:00.000000', b'1'),

(7, 'TEST', 'Practice Test 1', 'First practice test attempt', 65, 45, 20, NULL, NULL, NULL, '2025-06-23 16:00:00.000000', '2025-06-23 16:00:00.000000', b'1'),

(7, 'LOGIN', 'Daily Login', 'User logged in today', NULL, NULL, 5, NULL, NULL, NULL, '2025-06-23 14:00:00.000000', '2025-06-23 14:00:00.000000', b'1'),

-- ADMIN USER (id=1) ACTIVITIES
(1, 'LESSON', 'Advanced Reading Comprehension', 'Completed advanced reading strategies', 98, 35, 25, 5, NULL, NULL, '2025-06-23 13:00:00.000000', '2025-06-23 13:00:00.000000', b'1'),

(1, 'TEST', 'Full Practice Test', 'Complete 2-hour practice test', 95, 120, 50, NULL, NULL, NULL, '2025-06-23 10:00:00.000000', '2025-06-23 10:00:00.000000', b'1'),

(1, 'ACHIEVEMENT', 'Perfect Score', 'Achieved perfect score on listening section', 100, NULL, 100, NULL, NULL, NULL, '2025-06-23 11:30:00.000000', '2025-06-23 11:30:00.000000', b'1'),

-- USER1 (id=2) ACTIVITIES - Nguyễn Văn An
(2, 'LESSON', 'Listening Practice 3', 'Completed listening comprehension exercises', 82, 30, 18, 3, NULL, NULL, '2025-06-21 13:00:00.000000', '2025-06-21 13:00:00.000000', b'1'),

(2, 'FLASHCARD', 'Business Vocabulary', 'Studied business-related TOEIC words', 78, 20, 12, NULL, NULL, 2, '2025-06-21 12:30:00.000000', '2025-06-21 12:30:00.000000', b'1'),

(2, 'TEST', 'Mini Test - Part 1', 'Photo description practice test', 85, 15, 15, NULL, NULL, NULL, '2025-06-21 11:45:00.000000', '2025-06-21 11:45:00.000000', b'1'),

-- JOHNSMITH (id=3) ACTIVITIES - Premium user
(3, 'LESSON', 'Grammar Mastery 5', 'Advanced grammar patterns and usage', 92, 40, 30, 8, NULL, NULL, '2025-06-21 11:30:00.000000', '2025-06-21 11:30:00.000000', b'1'),

(3, 'TEST', 'Timed Practice Test', 'Full-length timed practice session', 88, 120, 45, NULL, NULL, NULL, '2025-06-21 09:00:00.000000', '2025-06-21 09:00:00.000000', b'1'),

(3, 'FLASHCARD', 'Academic Vocabulary', 'High-level academic terms for TOEIC', 90, 25, 20, NULL, NULL, 3, '2025-06-20 16:45:00.000000', '2025-06-20 16:45:00.000000', b'1'),

(3, 'ACHIEVEMENT', 'Study Streak 10', 'Maintained 10-day study streak', NULL, NULL, 50, NULL, NULL, NULL, '2025-06-20 15:00:00.000000', '2025-06-20 15:00:00.000000', b'1'),

-- JANEWILSON (id=4) ACTIVITIES - Premium user
(4, 'LESSON', 'Reading Strategies 4', 'Skimming and scanning techniques', 88, 35, 22, 7, NULL, NULL, '2025-06-21 11:00:00.000000', '2025-06-21 11:00:00.000000', b'1'),

(4, 'FLASHCARD', 'Phrasal Verbs', 'Common phrasal verbs in TOEIC context', 85, 18, 14, NULL, NULL, 4, '2025-06-21 10:30:00.000000', '2025-06-21 10:30:00.000000', b'1'),

(4, 'TEST', 'Reading Comprehension Test', 'Part 7 focused practice test', 87, 50, 25, NULL, NULL, NULL, '2025-06-20 14:00:00.000000', '2025-06-20 14:00:00.000000', b'1'),

-- COLLABORATOR1 (id=5) ACTIVITIES - Trần Thị Bình
(5, 'LESSON', 'Pronunciation Practice', 'Working on American pronunciation', 75, 28, 16, 4, NULL, NULL, '2025-06-21 10:00:00.000000', '2025-06-21 10:00:00.000000', b'1'),

(5, 'FLASHCARD', 'Travel Vocabulary', 'Travel and transportation terms', 80, 22, 13, NULL, NULL, 5, '2025-06-21 09:30:00.000000', '2025-06-21 09:30:00.000000', b'1'),

(5, 'EXERCISE', 'Fill in the Blanks', 'Grammar exercise with missing words', 78, 15, 12, NULL, 1, NULL, '2025-06-20 18:00:00.000000', '2025-06-20 18:00:00.000000', b'1'),

-- MIKEJ (id=6) ACTIVITIES
(6, 'LESSON', 'Basic Listening 1', 'Introduction to TOEIC listening format', 72, 20, 10, 2, NULL, NULL, '2025-06-20 16:00:00.000000', '2025-06-20 16:00:00.000000', b'1'),

(6, 'FLASHCARD', 'Starter Vocabulary', 'Essential TOEIC vocabulary for beginners', 65, 25, 8, NULL, NULL, 6, '2025-06-20 15:30:00.000000', '2025-06-20 15:30:00.000000', b'1'),

(6, 'LOGIN', 'Daily Login', 'User logged in', NULL, NULL, 5, NULL, NULL, NULL, '2025-06-20 15:00:00.000000', '2025-06-20 15:00:00.000000', b'1'),

-- OLDER ACTIVITIES (for historical data)
(7, 'STUDY_SESSION', 'First Study Session', 'Initial platform exploration and setup', NULL, 30, 10, NULL, NULL, NULL, '2025-06-21 15:00:00.000000', '2025-06-21 15:00:00.000000', b'1'),

(2, 'ACHIEVEMENT', 'First Lesson Complete', 'Completed first lesson milestone', NULL, NULL, 25, NULL, NULL, NULL, '2025-06-15 14:00:00.000000', '2025-06-15 14:00:00.000000', b'1'),

(3, 'ACHIEVEMENT', 'High Score', 'Achieved score above 85 on practice test', 87, NULL, 40, NULL, NULL, NULL, '2025-06-18 16:30:00.000000', '2025-06-18 16:30:00.000000', b'1'),

(4, 'STUDY_SESSION', 'Weekend Study', 'Extended weekend study session', NULL, 90, 30, NULL, NULL, NULL, '2025-06-19 10:00:00.000000', '2025-06-19 10:00:00.000000', b'1');

-- ADDITIONAL INDEXES FOR PERFORMANCE

CREATE INDEX `idx_user_activities_score` ON `user_activities` (`score`);
CREATE INDEX `idx_user_activities_points` ON `user_activities` (`points_earned`);
CREATE INDEX `idx_user_activities_lesson` ON `user_activities` (`lesson_id`);
CREATE INDEX `idx_user_activities_exercise` ON `user_activities` (`exercise_id`);
CREATE INDEX `idx_user_activities_flashcard` ON `user_activities` (`flashcard_set_id`);
