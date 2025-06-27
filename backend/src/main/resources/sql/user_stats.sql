-- USER STATS TABLE - TOEIC Learning Platform
-- Bảng thống kê học tập của người dùng

DROP TABLE IF EXISTS `user_stats`;

CREATE TABLE `user_stats` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `lessons_completed` int(11) NOT NULL DEFAULT 0,
  `practice_tests` int(11) NOT NULL DEFAULT 0,
  `average_score` decimal(5,2) NOT NULL DEFAULT 0.00,
  `study_streak` int(11) NOT NULL DEFAULT 0,
  `total_study_time` int(11) NOT NULL DEFAULT 0 COMMENT 'Total study time in minutes',
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

-- SAMPLE DATA FOR USER_STATS

INSERT INTO `user_stats` (
  `user_id`, `lessons_completed`, `practice_tests`, `average_score`, 
  `study_streak`, `total_study_time`, `total_flashcards_studied`, 
  `highest_score`, `last_study_date`, `created_at`, `updated_at`, `is_active`
) VALUES
-- Admin user (id=1)
(1, 50, 25, 95.50, 30, 1800, 500, 98, '2025-06-23 14:00:00.000000', '2025-06-01 10:00:00.000000', '2025-06-23 14:00:00.000000', b'1'),

-- user1 (id=2) - Nguyễn Văn An
(2, 15, 8, 78.25, 5, 450, 120, 85, '2025-06-21 13:30:00.000000', '2025-06-02 11:00:00.000000', '2025-06-21 13:30:00.000000', b'1'),

-- johnsmith (id=3) - Premium user
(3, 32, 18, 82.75, 12, 960, 285, 92, '2025-06-21 12:15:00.000000', '2025-06-03 12:00:00.000000', '2025-06-21 12:15:00.000000', b'1'),

-- janewilson (id=4) - Premium user
(4, 28, 15, 80.50, 8, 720, 195, 88, '2025-06-21 11:45:00.000000', '2025-06-04 13:00:00.000000', '2025-06-21 11:45:00.000000', b'1'),

-- collaborator1 (id=5) - Trần Thị Bình
(5, 22, 12, 75.25, 3, 540, 150, 82, '2025-06-21 10:30:00.000000', '2025-06-05 14:00:00.000000', '2025-06-21 10:30:00.000000', b'1'),

-- mikej (id=6)
(6, 8, 4, 65.75, 2, 240, 75, 72, '2025-06-20 16:20:00.000000', '2025-06-06 15:00:00.000000', '2025-06-20 16:20:00.000000', b'1'),

-- HANOI (id=7) - New user with basic stats
(7, 3, 1, 68.50, 1, 90, 25, 75, '2025-06-23 16:00:00.000000', '2025-06-21 14:30:08.000000', '2025-06-23 16:00:00.000000', b'1');

-- INDEXES FOR PERFORMANCE

CREATE INDEX `idx_user_stats_user_id` ON `user_stats` (`user_id`);
CREATE INDEX `idx_user_stats_last_study_date` ON `user_stats` (`last_study_date`);
CREATE INDEX `idx_user_stats_study_streak` ON `user_stats` (`study_streak`);
CREATE INDEX `idx_user_stats_average_score` ON `user_stats` (`average_score`);
