-- ================================================================
-- LEENGLISH TOEIC DATABASE - FIXED VERSION
-- Sửa lỗi và thêm dữ liệu thiếu theo đúng định dạng
-- ================================================================

-- Thêm dữ liệu vào bảng `questions` (đang thiếu hoàn toàn)
INSERT INTO `questions` (`id`, `exercise_id`, `question_text`, `question_type`, `difficulty`, `question_image_url`, `question_audio_url`, `audio_duration`, `option_a`, `option_b`, `option_c`, `option_d`, `option_e`, `correct_answer`, `correct_answer_text`, `explanation`, `explanation_image_url`, `explanation_audio_url`, `learning_tip`, `toeic_part`, `skill_tested`, `points`, `time_limit`, `question_order`, `is_active`, `total_attempts`, `correct_attempts`, `created_at`, `updated_at`) VALUES

-- Questions cho Exercise 1 (Greeting Selection)
(1, 1, 'What greeting do you use at 9:00 AM?', 'MULTIPLE_CHOICE', 'EASY', NULL, 'https://example.com/audio/greeting1.mp3', 5, 'Good morning', 'Good afternoon', 'Good evening', 'Good night', NULL, 'A', 'Good morning', 'Good morning is used from sunrise until noon (around 12:00 PM)', NULL, NULL, 'This is a basic greeting that shows respect and politeness', 'PART_1', 'Listening Comprehension', 10, 30, 1, 1, 25, 20, NOW(), NOW()),

-- Questions cho Exercise 2 (Introduction Practice) 
(2, 2, 'My name ___ John.', 'FILL_BLANK', 'EASY', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'is', 'is', 'Use "is" with singular subjects like "name". The correct form is "My name is John."', NULL, NULL, 'Remember: I am, You are, He/She/It is', 'PART_5', 'Grammar', 5, 20, 1, 1, 30, 25, NOW(), NOW()),

-- Questions cho Exercise 3 (Present Simple - Be Verb)
(3, 3, 'She ___ a teacher.', 'MULTIPLE_CHOICE', 'EASY', NULL, NULL, 0, 'is', 'am', 'are', 'be', NULL, 'A', 'is', 'Use "is" with third person singular (he/she/it)', NULL, NULL, 'Third person singular always uses "is"', 'PART_5', 'Grammar', 10, 25, 1, 1, 40, 35, NOW(), NOW()),

-- Questions cho Exercise 4 (Present Simple - Regular Verbs)
(4, 4, 'He ___ (work) in an office.', 'FILL_BLANK', 'EASY', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'works', 'works', 'Add "-s" to verbs with third person singular subjects. "He works in an office."', NULL, NULL, 'Remember to add -s for he/she/it', 'PART_5', 'Grammar', 10, 30, 1, 1, 35, 28, NOW(), NOW()),

-- Questions cho Exercise 5 (Number Recognition)
(5, 5, 'Write "25" in words', 'TEXT_INPUT', 'EASY', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'twenty-five', 'twenty-five', 'Hyphenate numbers from twenty-one to ninety-nine', NULL, NULL, 'Always use hyphens for compound numbers', 'PART_7', 'Reading Comprehension', 10, 45, 1, 1, 20, 18, NOW(), NOW()),

-- Questions cho Exercise 6 (Time Telling)
(6, 6, 'Express 3:30 in words', 'TEXT_INPUT', 'EASY', NULL, 'https://example.com/audio/time1.mp3', 3, NULL, NULL, NULL, NULL, NULL, 'half past three', 'half past three', '30 minutes past the hour is "half past". Alternative: "three thirty"', NULL, NULL, 'Half past = 30 minutes after the hour', 'PART_1', 'Listening Comprehension', 15, 60, 1, 1, 22, 19, NOW(), NOW()),

-- Questions cho Exercise 7 (Past Simple Formation)
(7, 7, 'Yesterday I ___ to the store.', 'MULTIPLE_CHOICE', 'INTERMEDIATE', NULL, NULL, 0, 'go', 'went', 'going', 'goes', NULL, 'B', 'went', '"Go" is irregular - past form is "went". "Yesterday I went to the store."', NULL, NULL, 'Irregular verbs must be memorized', 'PART_5', 'Grammar', 15, 30, 1, 1, 45, 40, NOW(), NOW()),

-- Questions cho Exercise 8 (Past Simple Questions)
(8, 8, 'Transform: You visited Paris last year.', 'TEXT_INPUT', 'INTERMEDIATE', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'Did you visit Paris last year?', 'Did you visit Paris last year?', 'Use "Did" + base form for past simple questions. The structure is: Did + subject + base verb + object + time?', NULL, NULL, 'Questions in past simple always use "did" + base form', 'PART_5', 'Grammar', 20, 60, 1, 1, 30, 25, NOW(), NOW()),

-- Questions cho Exercise 9 (First Conditional)
(9, 9, 'If it rains, I ___ stay home.', 'MULTIPLE_CHOICE', 'ADVANCED', NULL, NULL, 0, 'will', 'would', 'am', 'do', NULL, 'A', 'will', 'First conditional uses "will" in the main clause. Structure: If + present simple, will + base form', NULL, NULL, 'First conditional = real possibility in future', 'PART_5', 'Grammar', 25, 45, 1, 1, 20, 15, NOW(), NOW()),

-- Questions cho Exercise 10 (Second Conditional)
(10, 10, 'If I ___ you, I would apologize.', 'MULTIPLE_CHOICE', 'ADVANCED', NULL, NULL, 0, 'am', 'was', 'were', 'be', NULL, 'C', 'were', 'Use "were" for all persons in second conditional. This is subjunctive mood for hypothetical situations.', NULL, NULL, 'Second conditional = unreal/hypothetical situation', 'PART_5', 'Grammar', 30, 60, 1, 1, 18, 12, NOW(), NOW()),

-- Questions cho Exercise 11 (Business Email)
(11, 11, 'How do you end a formal business email?', 'MULTIPLE_CHOICE', 'ADVANCED', NULL, NULL, 0, 'Love', 'Cheers', 'Best regards', 'See ya', NULL, 'C', 'Best regards', '"Best regards" is professional and widely accepted in business communication', NULL, NULL, 'Always use formal closings in business emails', 'PART_7', 'Reading Comprehension', 20, 30, 1, 1, 25, 22, NOW(), NOW()),

-- Questions cho Exercise 12 (Meeting Vocabulary)
(12, 12, 'Let us ___ the meeting for next Monday.', 'FILL_BLANK', 'ADVANCED', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'schedule', 'schedule', '"Schedule" means to plan or arrange a meeting at a specific time', NULL, NULL, 'Common business verbs: schedule, arrange, organize', 'PART_5', 'Grammar', 25, 45, 1, 1, 15, 12, NOW(), NOW());

-- ================================================================
-- Thêm dữ liệu vào bảng `exercise_question` 
-- (Có vẻ như bảng này duplicate với `questions`, nhưng sẽ thêm để đảm bảo)
-- ================================================================

INSERT INTO `exercise_question` (`id`, `exercise_id`, `question_text`, `type`, `correct_answer`, `options`, `audio_url`, `image_url`, `order_index`, `created_at`, `updated_at`) VALUES
(1, 1, 'What greeting do you use at 9:00 AM?', 'MULTIPLE_CHOICE', 'Good morning', '["Good morning","Good afternoon","Good evening","Good night"]', 'https://example.com/audio/greeting1.mp3', NULL, 1, NOW(), NOW()),
(2, 2, 'My name ___ John.', 'FILL_BLANK', 'is', NULL, NULL, NULL, 1, NOW(), NOW()),
(3, 3, 'She ___ a teacher.', 'MULTIPLE_CHOICE', 'is', '["is","am","are","be"]', NULL, NULL, 1, NOW(), NOW()),
(4, 4, 'He ___ (work) in an office.', 'FILL_BLANK', 'works', NULL, NULL, NULL, 1, NOW(), NOW()),
(5, 5, 'Write "25" in words', 'TEXT_INPUT', 'twenty-five', NULL, NULL, NULL, 1, NOW(), NOW()),
(6, 6, 'Express 3:30 in words', 'TEXT_INPUT', 'half past three', NULL, 'https://example.com/audio/time1.mp3', NULL, 1, NOW(), NOW()),
(7, 7, 'Yesterday I ___ to the store.', 'MULTIPLE_CHOICE', 'went', '["go","went","going","goes"]', NULL, NULL, 1, NOW(), NOW()),
(8, 8, 'Transform: You visited Paris last year.', 'TEXT_INPUT', 'Did you visit Paris last year?', NULL, NULL, NULL, 1, NOW(), NOW()),
(9, 9, 'If it rains, I ___ stay home.', 'MULTIPLE_CHOICE', 'will', '["will","would","am","do"]', NULL, NULL, 1, NOW(), NOW()),
(10, 10, 'If I ___ you, I would apologize.', 'MULTIPLE_CHOICE', 'were', '["am","was","were","be"]', NULL, NULL, 1, NOW(), NOW()),
(11, 11, 'How do you end a formal business email?', 'MULTIPLE_CHOICE', 'Best regards', '["Love","Cheers","Best regards","See ya"]', NULL, NULL, 1, NOW(), NOW()),
(12, 12, 'Let us ___ the meeting for next Monday.', 'FILL_BLANK', 'schedule', NULL, NULL, NULL, 1, NOW(), NOW());

-- ================================================================
-- Cập nhật và thêm dữ liệu thiếu cho các bảng khác
-- ================================================================

-- Cập nhật flashcard_sets với dữ liệu đầy đủ
UPDATE `flashcard_sets` SET 
    `difficulty_level` = 'BEGINNER',
    `estimated_time_minutes` = 15,
    `is_premium` = 0,
    `tags` = 'basic,vocabulary,essential',
    `view_count` = 150
WHERE `id` = 1;

UPDATE `flashcard_sets` SET 
    `difficulty_level` = 'BEGINNER',
    `estimated_time_minutes` = 20,
    `is_premium` = 0,
    `tags` = 'grammar,fundamental,structure',
    `view_count` = 120
WHERE `id` = 2;

UPDATE `flashcard_sets` SET 
    `difficulty_level` = 'ADVANCED',
    `estimated_time_minutes` = 30,
    `is_premium` = 1,
    `tags` = 'business,professional,workplace',
    `view_count` = 80
WHERE `id` = 3;

UPDATE `flashcard_sets` SET 
    `difficulty_level` = 'INTERMEDIATE',
    `estimated_time_minutes` = 25,
    `is_premium` = 1,
    `tags` = 'phrasal,verbs,advanced',
    `view_count` = 95
WHERE `id` = 4;

UPDATE `flashcard_sets` SET 
    `difficulty_level` = 'BEGINNER',
    `estimated_time_minutes` = 18,
    `is_premium` = 0,
    `tags` = 'conversation,daily,communication',
    `view_count` = 140
WHERE `id` = 5;

UPDATE `flashcard_sets` SET 
    `difficulty_level` = 'ADVANCED',
    `estimated_time_minutes` = 35,
    `is_premium` = 1,
    `tags` = 'advanced,sophisticated,vocabulary',
    `view_count` = 45
WHERE `id` = 6;

-- ================================================================
-- Thêm PRIMARY KEY và INDEX constraints (nếu chưa có)
-- ================================================================

-- Primary keys
ALTER TABLE `comments` ADD PRIMARY KEY (`id`);
ALTER TABLE `exercises` ADD PRIMARY KEY (`id`);
ALTER TABLE `exercise_question` ADD PRIMARY KEY (`id`);
ALTER TABLE `flashcards` ADD PRIMARY KEY (`id`);
ALTER TABLE `flashcard_sets` ADD PRIMARY KEY (`id`);
ALTER TABLE `lessons` ADD PRIMARY KEY (`id`);
ALTER TABLE `membership_plans` ADD PRIMARY KEY (`id`);
ALTER TABLE `mock_tests` ADD PRIMARY KEY (`id`);
ALTER TABLE `questions` ADD PRIMARY KEY (`id`);
ALTER TABLE `test_results` ADD PRIMARY KEY (`id`);
ALTER TABLE `users` ADD PRIMARY KEY (`id`);
ALTER TABLE `user_exercise_attempts` ADD PRIMARY KEY (`id`);

-- Auto increment
ALTER TABLE `comments` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
ALTER TABLE `exercises` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
ALTER TABLE `exercise_question` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
ALTER TABLE `flashcards` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
ALTER TABLE `flashcard_sets` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
ALTER TABLE `lessons` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
ALTER TABLE `membership_plans` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
ALTER TABLE `mock_tests` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
ALTER TABLE `questions` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
ALTER TABLE `test_results` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;
ALTER TABLE `users` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
ALTER TABLE `user_exercise_attempts` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

-- Foreign key constraints
ALTER TABLE `comments` ADD CONSTRAINT `fk_comments_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE;
ALTER TABLE `comments` ADD CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `exercises` ADD CONSTRAINT `fk_exercises_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE;
ALTER TABLE `exercise_question` ADD CONSTRAINT `fk_exercise_question_exercise` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`) ON DELETE CASCADE;
ALTER TABLE `flashcards` ADD CONSTRAINT `fk_flashcards_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;
ALTER TABLE `flashcards` ADD CONSTRAINT `fk_flashcards_set` FOREIGN KEY (`flashcard_set_id`) REFERENCES `flashcard_sets` (`id`) ON DELETE CASCADE;
ALTER TABLE `flashcard_sets` ADD CONSTRAINT `fk_flashcard_sets_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;
ALTER TABLE `questions` ADD CONSTRAINT `fk_questions_exercise` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`) ON DELETE CASCADE;
ALTER TABLE `test_results` ADD CONSTRAINT `fk_test_results_mock_test` FOREIGN KEY (`mock_test_id`) REFERENCES `mock_tests` (`id`) ON DELETE CASCADE;
ALTER TABLE `test_results` ADD CONSTRAINT `fk_test_results_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_exercise_attempts` ADD CONSTRAINT `fk_user_exercise_attempts_exercise` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_exercise_attempts` ADD CONSTRAINT `fk_user_exercise_attempts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

-- ================================================================
-- Thêm indexes để tối ưu performance
-- ================================================================

CREATE INDEX `idx_lessons_level` ON `lessons` (`level`);
CREATE INDEX `idx_lessons_is_premium` ON `lessons` (`is_premium`);
CREATE INDEX `idx_exercises_lesson_id` ON `exercises` (`lesson_id`);
CREATE INDEX `idx_exercises_difficulty` ON `exercises` (`difficulty_level`);
CREATE INDEX `idx_flashcards_set_id` ON `flashcards` (`flashcard_set_id`);
CREATE INDEX `idx_questions_exercise_id` ON `questions` (`exercise_id`);
CREATE INDEX `idx_users_email` ON `users` (`email`);
CREATE INDEX `idx_users_username` ON `users` (`username`);

COMMIT;
