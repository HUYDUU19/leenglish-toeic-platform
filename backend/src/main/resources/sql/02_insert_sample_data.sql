-- ================================================================
-- LEENGLISH PLATFORM - SAMPLE DATA INSERT
-- Database: english5
-- Generated: June 21, 2025
-- ================================================================

USE `english5`;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- ================================================================
-- 1. INSERT USERS - Different roles and statuses
-- ================================================================
INSERT INTO `users` (`id`, `country`, `created_at`, `date_of_birth`, `email`, `full_name`, `gender`, `is_active`, `is_premium`, `last_login`, `password_hash`, `phone`, `premium_expires_at`, `profile_picture_url`, `role`, `total_score`, `updated_at`, `username`) VALUES
(1, 'VN', '2025-06-01 10:00:00', '1990-01-15', 'admin@leenglish.com', 'System Administrator', 'MALE', 1, 1, '2025-06-21 14:00:00', '$2a$12$UphTMB.7a00/9KN44NnhC.T/Uhede1rXJ9ym34L2/k3Mq.yI6sZ4C', '+84-901-234-567', '2026-06-01 10:00:00', 'https://robohash.org/admin?set=set1&size=200x200', 'ADMIN', 0, '2025-06-21 14:00:00', 'admin'),
(2, 'VN', '2025-06-02 11:00:00', '1995-03-22', 'user1@example.com', 'Nguyễn Văn An', 'MALE', 1, 0, '2025-06-21 13:30:00', '$2a$12$urj6e0rHs7.3IFYN7xkIMu.eUbXgXnDByOHnQHvnaCpB5WoXtoZYW', '+84-901-111-111', NULL, 'https://robohash.org/user1?set=set2&size=200x200', 'USER', 125, '2025-06-21 13:30:00', 'user1'),
(3, 'US', '2025-06-03 12:00:00', '1988-07-10', 'john@example.com', 'John Smith', 'MALE', 1, 1, '2025-06-21 12:15:00', '$2a$10$N.fO7.F2.1bq9A2Kqf9Cue3YYs/Q.RK6XEtzPJ6K8LQGXg.Yy5GZq', '+1-555-0123', '2025-12-03 12:00:00', 'https://robohash.org/john?set=set3&size=200x200', 'USER', 285, '2025-06-21 12:15:00', 'johnsmith'),
(4, 'UK', '2025-06-04 13:00:00', '1992-11-05', 'jane@example.com', 'Jane Wilson', 'FEMALE', 1, 1, '2025-06-21 11:45:00', '$2a$10$N.fO7.F2.1bq9A2Kqf9Cue3YYs/Q.RK6XEtzPJ6K8LQGXg.Yy5GZq', '+44-20-7946-0958', '2025-12-04 13:00:00', 'https://robohash.org/jane?set=set4&size=200x200', 'USER', 195, '2025-06-21 11:45:00', 'janewilson'),
(5, 'VN', '2025-06-05 14:00:00', '1993-09-18', 'collaborator@example.com', 'Trần Thị Bình', 'FEMALE', 1, 0, '2025-06-21 10:30:00', '$2a$10$N.fO7.F2.1bq9A2Kqf9Cue3YYs/Q.RK6XEtzPJ6K8LQGXg.Yy5GZq', '+84-901-555-555', NULL, 'https://robohash.org/collab?set=set1&size=200x200', 'COLLABORATOR', 75, '2025-06-21 10:30:00', 'collaborator1'),
(6, 'CA', '2025-06-06 15:00:00', '1987-04-25', 'mike@example.com', 'Mike Johnson', 'MALE', 1, 0, '2025-06-20 16:20:00', '$2a$10$N.fO7.F2.1bq9A2Kqf9Cue3YYs/Q.RK6XEtzPJ6K8LQGXg.Yy5GZq', '+1-604-555-0199', NULL, 'https://robohash.org/mike?set=set2&size=200x200', 'USER', 45, '2025-06-20 16:20:00', 'mikej');

-- ================================================================
-- 2. INSERT MEMBERSHIP PLANS - Different tiers
-- ================================================================
INSERT INTO `membership_plans` (`id`, `access_audio_features`, `access_premium_content`, `created_at`, `currency`, `description`, `download_offline`, `duration_days`, `duration_in_days`, `features`, `has_audio_access`, `has_premium_content`, `has_progress_tracking`, `is_active`, `is_popular`, `max_exercises_per_day`, `max_flashcards_per_set`, `max_lessons_access`, `max_lessons_per_day`, `name`, `plan_type`, `price`, `priority_support`, `unlimited_flashcards`, `updated_at`) VALUES
(1, 0, 0, '2025-06-01 10:00:00', 'USD', 'Basic plan with limited features for beginners', 0, 30, 30, 'Basic lessons, Limited exercises, Community support', 0, 0, 1, 1, 0, 5, 50, 10, 3, 'Basic Monthly', 'MONTHLY', 9.99, 0, 0, '2025-06-01 10:00:00'),
(2, 1, 0, '2025-06-01 10:00:00', 'USD', 'Standard plan with audio features and more content', 0, 30, 30, 'All basic features, Audio access, More exercises, Progress tracking', 1, 0, 1, 1, 1, 15, 150, 25, 8, 'Standard Monthly', 'MONTHLY', 19.99, 0, 1, '2025-06-01 10:00:00'),
(3, 1, 1, '2025-06-01 10:00:00', 'USD', 'Premium plan with full access to all features', 1, 30, 30, 'All features, Premium content, Offline download, Priority support', 1, 1, 1, 1, 0, NULL, NULL, NULL, NULL, 'Premium Monthly', 'MONTHLY', 29.99, 1, 1, '2025-06-01 10:00:00'),
(4, 1, 1, '2025-06-01 10:00:00', 'USD', 'Annual premium subscription with best value', 1, 365, 365, 'All premium features, Best value, 2 months free', 1, 1, 1, 1, 0, NULL, NULL, NULL, NULL, 'Premium Yearly', 'YEARLY', 299.99, 1, 1, '2025-06-01 10:00:00');

-- ================================================================
-- 3. INSERT USER MEMBERSHIPS - Active subscriptions
-- ================================================================
INSERT INTO `user_memberships` (`id`, `auto_renew`, `cancellation_reason`, `cancelled_at`, `created_at`, `end_date`, `is_active`, `payment_status`, `start_date`, `status`, `updated_at`, `membership_plan_id`, `user_id`) VALUES
(1, 1, NULL, NULL, '2025-06-01 10:00:00', '2026-06-01', 1, 'PAID', '2025-06-01', 'ACTIVE', '2025-06-01 10:00:00', 3, 1),
(2, 1, NULL, NULL, '2025-06-03 12:00:00', '2025-12-03', 1, 'PAID', '2025-06-03', 'ACTIVE', '2025-06-03 12:00:00', 2, 3),
(3, 0, NULL, NULL, '2025-06-04 13:00:00', '2025-12-04', 1, 'PAID', '2025-06-04', 'ACTIVE', '2025-06-04 13:00:00', 3, 4);

-- ================================================================
-- 4. INSERT LESSONS - Learning content
-- ================================================================
INSERT INTO `lessons` (`id`, `audio_url`, `content`, `created_at`, `description`, `difficulty`, `duration`, `image_url`, `is_active`, `is_premium`, `level`, `order_index`, `title`, `type`, `updated_at`) VALUES
(1, 'https://audio.leenglish.com/greetings.mp3', 'Learn basic greetings: Hello, Hi, Good morning, Good afternoon, Good evening. Practice introducing yourself: My name is..., I am from..., Nice to meet you.', '2025-06-01 10:00:00', 'Essential greetings and self-introduction phrases', 'BEGINNER', 25, 'https://images.leenglish.com/greetings.jpg', 1, 0, 'A1', 1, 'Basic Greetings and Introductions', 'LESSON', '2025-06-01 10:00:00'),
(2, 'https://audio.leenglish.com/present-simple.mp3', 'Present Simple structure: Subject + Verb (+ s/es for 3rd person). Examples: I work, You work, He works, She studies. Negative: do not/does not + verb.', '2025-06-01 11:00:00', 'Understanding and using present simple tense', 'BEGINNER', 35, 'https://images.leenglish.com/present-simple.jpg', 1, 0, 'A1', 2, 'Present Simple Tense', 'LESSON', '2025-06-01 11:00:00'),
(3, 'https://audio.leenglish.com/numbers.mp3', 'Numbers 1-100, ordinal numbers, time expressions: What time is it? It is 3 o clock, half past three, quarter to four. Days of the week, months.', '2025-06-01 12:00:00', 'Numbers, time, dates and calendar vocabulary', 'BEGINNER', 30, 'https://images.leenglish.com/numbers.jpg', 1, 0, 'A1', 3, 'Numbers and Time', 'LESSON', '2025-06-01 12:00:00'),
(4, 'https://audio.leenglish.com/past-simple.mp3', 'Past Simple formation: Regular verbs + ed, Irregular verbs (go-went, come-came). Questions: Did + subject + verb? Negatives: did not + verb.', '2025-06-01 13:00:00', 'Learn to express past events and experiences', 'INTERMEDIATE', 40, 'https://images.leenglish.com/past-simple.jpg', 1, 0, 'A2', 4, 'Past Simple Tense', 'LESSON', '2025-06-01 13:00:00'),
(5, 'https://audio.leenglish.com/food.mp3', 'Food vocabulary, restaurant phrases: menu, order, bill, tip. I would like..., Could I have..., The check please. Describing food: delicious, spicy, sweet.', '2025-06-01 14:00:00', 'Food vocabulary and restaurant communication', 'INTERMEDIATE', 35, 'https://images.leenglish.com/food.jpg', 1, 0, 'A2', 5, 'Food and Restaurants', 'LESSON', '2025-06-01 14:00:00'),
(6, 'https://audio.leenglish.com/future.mp3', 'Future tense forms: will + verb, going to + verb. Plans vs predictions. Tomorrow, next week, in the future. Making arrangements and appointments.', '2025-06-01 15:00:00', 'Express future plans and intentions', 'INTERMEDIATE', 45, 'https://images.leenglish.com/future.jpg', 1, 0, 'B1', 6, 'Future Tense and Plans', 'LESSON', '2025-06-01 15:00:00'),
(7, 'https://audio.leenglish.com/conditionals.mp3', 'Conditional sentences: If + present, will + verb (1st conditional). If + past, would + verb (2nd conditional). Real and hypothetical situations.', '2025-06-01 16:00:00', 'Understanding conditional structures', 'ADVANCED', 50, 'https://images.leenglish.com/conditionals.jpg', 1, 1, 'B2', 7, 'Conditional Sentences', 'LESSON', '2025-06-01 16:00:00'),
(8, 'https://audio.leenglish.com/business.mp3', 'Business vocabulary: meetings, presentations, negotiations. Email writing, reports, proposals. Professional communication in workplace.', '2025-06-01 17:00:00', 'Professional English for business situations', 'ADVANCED', 60, 'https://images.leenglish.com/business.jpg', 1, 1, 'C1', 8, 'Business Communication', 'LESSON', '2025-06-01 17:00:00');

-- ================================================================
-- 5. INSERT EXERCISES - Practice activities
-- ================================================================
INSERT INTO `exercises` (`id`, `audio_url`, `correct_answer`, `created_at`, `description`, `difficulty`, `difficulty_level`, `explanation`, `image_url`, `is_active`, `is_premium`, `lesson_id`, `level`, `options`, `order_index`, `points`, `question`, `time_limit_seconds`, `title`, `type`, `updated_at`) VALUES
(1, NULL, 'Good morning', '2025-06-01 10:00:00', 'Choose the appropriate greeting for 9:00 AM', 'BEGINNER', 'BEGINNER', 'Good morning is used from sunrise until noon (12:00 PM)', NULL, 1, 0, 1, 'A1', '["Good morning","Good afternoon","Good evening","Good night"]', 1, 10, 'What greeting do you use at 9:00 AM?', 30, 'Morning Greeting Selection', 'MULTIPLE_CHOICE', '2025-06-01 10:00:00'),
(2, NULL, 'is', '2025-06-01 10:30:00', 'Complete the self-introduction sentence', 'BEGINNER', 'BEGINNER', 'Use "is" with singular subjects like "name" (My name is...)', NULL, 1, 0, 1, 'A1', NULL, 2, 5, 'My name ___ John.', 25, 'Self Introduction Practice', 'FILL_BLANK', '2025-06-01 10:30:00'),
(3, NULL, 'is', '2025-06-01 11:00:00', 'Choose the correct form of "be" verb', 'BEGINNER', 'BEGINNER', 'Use "is" with third person singular subjects (he/she/it)', NULL, 1, 0, 2, 'A1', '["is","am","are","be"]', 1, 10, 'She ___ a teacher.', 25, 'Present Simple - Be Verb', 'MULTIPLE_CHOICE', '2025-06-01 11:00:00'),
(4, NULL, 'works', '2025-06-01 11:30:00', 'Fill in the correct present simple form', 'BEGINNER', 'BEGINNER', 'Add "-s" to verbs with third person singular subjects (he/she/it)', NULL, 1, 0, 2, 'A1', NULL, 2, 10, 'He ___ (work) in an office.', 30, 'Present Simple - Regular Verbs', 'FILL_BLANK', '2025-06-01 11:30:00'),
(5, NULL, 'twenty-five', '2025-06-01 12:00:00', 'Write the number in words', 'BEGINNER', 'BEGINNER', 'Hyphenate compound numbers from twenty-one to ninety-nine', NULL, 1, 0, 3, 'A1', NULL, 1, 10, 'Write "25" in words', 45, 'Number Writing Practice', 'TEXT_INPUT', '2025-06-01 12:00:00'),
(6, NULL, 'half past three', '2025-06-01 12:30:00', 'Express the time in words', 'BEGINNER', 'BEGINNER', '30 minutes past the hour is expressed as "half past"', NULL, 1, 0, 3, 'A1', NULL, 2, 15, 'Express 3:30 in words', 60, 'Time Telling Practice', 'TEXT_INPUT', '2025-06-01 12:30:00'),
(7, NULL, 'went', '2025-06-01 13:00:00', 'Choose the correct past simple form', 'INTERMEDIATE', 'INTERMEDIATE', '"Go" is an irregular verb - its past form is "went"', NULL, 1, 0, 4, 'A2', '["go","went","going","goes"]', 1, 15, 'Yesterday I ___ to the store.', 30, 'Past Simple Formation', 'MULTIPLE_CHOICE', '2025-06-01 13:00:00'),
(8, NULL, 'Did you visit Paris last year?', '2025-06-01 13:30:00', 'Transform statement into past simple question', 'INTERMEDIATE', 'INTERMEDIATE', 'Use "Did" + subject + base form of verb for past simple questions', NULL, 1, 0, 4, 'A2', NULL, 2, 20, 'Transform: You visited Paris last year.', 60, 'Past Simple Questions', 'TEXT_INPUT', '2025-06-01 13:30:00'),
(9, NULL, 'will', '2025-06-01 16:00:00', 'Complete the first conditional sentence', 'ADVANCED', 'ADVANCED', 'First conditional uses "will" in the main clause for future results', NULL, 1, 1, 7, 'B2', '["will","would","am","do"]', 1, 25, 'If it rains, I ___ stay home.', 45, 'First Conditional Practice', 'MULTIPLE_CHOICE', '2025-06-01 16:00:00'),
(10, NULL, 'were', '2025-06-01 16:30:00', 'Choose the correct second conditional form', 'ADVANCED', 'ADVANCED', 'Use "were" for all persons in second conditional (hypothetical situations)', NULL, 1, 1, 7, 'B2', '["am","was","were","be"]', 2, 30, 'If I ___ you, I would apologize.', 60, 'Second Conditional Practice', 'MULTIPLE_CHOICE', '2025-06-01 16:30:00');

-- ================================================================
-- 6. INSERT EXERCISE QUESTIONS - Multi-question exercises
-- ================================================================
INSERT INTO `exercise_question` (`id`, `audio_url`, `correct_answer`, `created_at`, `exercise_id`, `image_url`, `options`, `order_index`, `question_text`, `type`, `updated_at`) VALUES
(1, NULL, 'Hello', '2025-06-01 10:00:00', 1, NULL, '["Hello","Goodbye","Thank you","Sorry"]', 1, 'What is the most common informal greeting?', 'MULTIPLE_CHOICE', '2025-06-01 10:00:00'),
(2, NULL, 'Nice to meet you', '2025-06-01 10:00:00', 1, NULL, '["Nice to meet you","See you later","How are you","What\'s up"]', 2, 'What do you say when meeting someone for the first time?', 'MULTIPLE_CHOICE', '2025-06-01 10:00:00'),
(3, NULL, 'am', '2025-06-01 11:00:00', 3, NULL, '["am","is","are","be"]', 1, 'I ___ a student.', 'MULTIPLE_CHOICE', '2025-06-01 11:00:00'),
(4, NULL, 'are', '2025-06-01 11:00:00', 3, NULL, '["am","is","are","be"]', 2, 'You ___ very kind.', 'MULTIPLE_CHOICE', '2025-06-01 11:00:00'),
(5, NULL, 'studied', '2025-06-01 13:00:00', 7, NULL, NULL, 1, 'Yesterday, I ___ (study) for 3 hours.', 'FILL_BLANK', '2025-06-01 13:00:00');

-- ================================================================
-- 7. INSERT QUESTIONS - TOEIC-style questions
-- ================================================================
INSERT INTO `questions` (`id`, `audio_duration`, `correct_answer`, `correct_answer_text`, `correct_attempts`, `created_at`, `difficulty`, `explanation`, `explanation_audio_url`, `explanation_image_url`, `is_active`, `learning_tip`, `option_a`, `option_b`, `option_c`, `option_d`, `option_e`, `points`, `question_audio_url`, `question_image_url`, `question_order`, `question_text`, `question_type`, `skill_tested`, `time_limit`, `toeic_part`, `total_attempts`, `updated_at`, `exercise_id`) VALUES
(1, 15, 'A', 'The man is reading a newspaper', 45, '2025-06-01 10:00:00', 'BEGINNER', 'Look at the image carefully. The man is clearly reading a newspaper, not a book or magazine.', NULL, NULL, 1, 'Focus on what the person is actually doing in the picture', 'The man is reading a newspaper', 'The man is writing a letter', 'The man is drinking coffee', 'The man is making a phone call', NULL, 5, 'https://audio.leenglish.com/toeic/part1_q1.mp3', 'https://images.leenglish.com/toeic/part1_q1.jpg', 1, 'Look at the picture and choose the best description.', 'LISTENING', 'Picture Description', 30, 'PART_1', 67, '2025-06-01 10:00:00', 1),
(2, 10, 'B', 'Where did you put my keys?', 32, '2025-06-01 10:30:00', 'BEGINNER', 'The question asks about location, so the appropriate response should indicate where the keys are.', NULL, NULL, 1, 'Listen for question words like "where" to understand what type of response is needed', 'I bought them yesterday', 'They are on the table', 'Yes, I have them', 'No, I don\'t like them', NULL, 5, 'https://audio.leenglish.com/toeic/part2_q1.mp3', NULL, 1, 'You will hear a question. Choose the best response.', 'LISTENING', 'Question Response', 25, 'PART_2', 58, '2025-06-01 10:30:00', 2),
(3, NULL, 'C', 'works', 28, '2025-06-01 11:00:00', 'INTERMEDIATE', 'After "he" (third person singular), we need to add "-s" to the base form of regular verbs in present simple.', NULL, NULL, 1, 'Remember: he/she/it + verb + s/es in present simple', 'work', 'working', 'works', 'worked', NULL, 10, NULL, NULL, 1, 'He ___ in a bank.', 'GRAMMAR', 'Verb Forms', 20, 'PART_5', 42, '2025-06-01 11:00:00', 3),
(4, NULL, 'A', 'have been working', 19, '2025-06-01 11:30:00', 'ADVANCED', 'Present perfect continuous is used for actions that started in the past and continue to the present, often with "for" or "since".', NULL, NULL, 1, 'Use present perfect continuous for ongoing actions that started in the past', 'have been working', 'am working', 'worked', 'will work', NULL, 15, NULL, NULL, 2, 'I ___ here for five years.', 'GRAMMAR', 'Tense Usage', 25, 'PART_5', 35, '2025-06-01 11:30:00', 4);

-- ================================================================
-- 8. INSERT FLASHCARD SETS - Study collections
-- ================================================================
INSERT INTO `flashcard_sets` (`id`, `category`, `created_at`, `description`, `difficulty_level`, `estimated_time_minutes`, `is_active`, `is_premium`, `is_public`, `name`, `tags`, `updated_at`, `view_count`, `created_by`) VALUES
(1, 'VOCABULARY', '2025-06-01 10:00:00', 'Essential English words every beginner should know', 'BEGINNER', 15, 1, 0, 1, 'Essential Vocabulary A1', 'basic,vocabulary,essential,beginner', '2025-06-01 10:00:00', 150, 1),
(2, 'GRAMMAR', '2025-06-01 11:00:00', 'Key grammar concepts and rules for beginners', 'BEGINNER', 20, 1, 0, 1, 'Grammar Fundamentals', 'grammar,fundamental,structure,rules', '2025-06-01 11:00:00', 120, 1),
(3, 'BUSINESS', '2025-06-01 12:00:00', 'Important business terms and professional phrases', 'ADVANCED', 30, 1, 1, 1, 'Business English Essentials', 'business,professional,workplace,advanced', '2025-06-01 12:00:00', 80, 5),
(4, 'PHRASAL_VERBS', '2025-06-01 13:00:00', 'Common phrasal verbs with examples and usage', 'INTERMEDIATE', 25, 1, 1, 1, 'Phrasal Verbs Collection', 'phrasal,verbs,intermediate,expressions', '2025-06-01 13:00:00', 95, 1),
(5, 'CONVERSATION', '2025-06-01 14:00:00', 'Phrases for daily communication and small talk', 'BEGINNER', 18, 1, 0, 1, 'Everyday Conversations', 'conversation,daily,communication,phrases', '2025-06-01 14:00:00', 140, 5),
(6, 'TOEIC', '2025-06-01 15:00:00', 'TOEIC test vocabulary for intermediate learners', 'INTERMEDIATE', 35, 1, 0, 1, 'TOEIC Vocabulary', 'toeic,test,vocabulary,intermediate', '2025-06-01 15:00:00', 110, 1);

-- ================================================================
-- 9. INSERT FLASHCARDS - Individual study cards
-- ================================================================
INSERT INTO `flashcards` (`id`, `audio_url`, `back_text`, `category`, `correct_count`, `created_at`, `definition`, `example`, `explanation`, `front_text`, `hint`, `image_url`, `incorrect_count`, `is_active`, `is_public`, `level`, `tags`, `term`, `updated_at`, `view_count`, `created_by`, `flashcard_set_id`) VALUES
(1, 'https://audio.leenglish.com/hello.mp3', 'A common greeting used when meeting someone', 'GREETINGS', 25, '2025-06-01 10:00:00', 'An expression of greeting', 'Hello, how are you today?', 'Used to greet someone when you meet them for the first time or see them again', 'Hello', 'What do you say when you meet someone?', NULL, 3, 1, 1, 'A1', 'greeting,basic,common', 'hello', '2025-06-01 10:00:00', 45, 1, 1),
(2, 'https://audio.leenglish.com/thankyou.mp3', 'Expression of gratitude', 'GRATITUDE', 22, '2025-06-01 10:30:00', 'A polite expression of appreciation', 'Thank you for your help!', 'Used to show appreciation for something someone did for you', 'Thank you', 'What do you say when someone helps you?', NULL, 2, 1, 1, 'A1', 'gratitude,polite,basic', 'thank you', '2025-06-01 10:30:00', 38, 1, 1),
(3, 'https://audio.leenglish.com/water.mp3', 'H2O - essential liquid for life', 'DRINKS', 30, '2025-06-01 11:00:00', 'Clear, colorless liquid', 'I drink water every day', 'A clear, colorless liquid that all living things need to survive', 'Water', 'What do you drink when you are thirsty?', NULL, 1, 1, 1, 'A1', 'drink,essential,basic', 'water', '2025-06-01 11:00:00', 52, 1, 1),
(4, 'https://audio.leenglish.com/house.mp3', 'A building where people live', 'HOUSING', 28, '2025-06-01 11:30:00', 'A residential building', 'I live in a big house', 'A structure built for people to live in, typically with walls, roof, and rooms', 'House', 'Where do people live?', NULL, 4, 1, 1, 'A1', 'home,building,basic', 'house', '2025-06-01 11:30:00', 41, 1, 1),
(5, NULL, 'Tense used for habits, facts, and general truths', 'TENSES', 18, '2025-06-01 12:00:00', 'A grammatical tense', 'I work every day (habit)', 'Used for things that happen regularly, are always true, or are general facts', 'Present Simple', 'What tense describes daily routines?', NULL, 5, 1, 1, 'A2', 'grammar,tense,basic', 'present simple', '2025-06-01 12:00:00', 67, 1, 2),
(6, NULL, 'Past form of the verb "go"', 'VERBS', 15, '2025-06-01 12:30:00', 'Irregular past tense verb', 'I went to school yesterday', 'An irregular verb - the past tense of "go" is "went", not "goed"', 'Went', 'Past tense of "go"', NULL, 8, 1, 1, 'A2', 'verb,past,irregular', 'went', '2025-06-01 12:30:00', 33, 1, 2),
(7, 'https://audio.leenglish.com/meeting.mp3', 'A gathering of people for discussion', 'BUSINESS', 12, '2025-06-01 13:00:00', 'Business gathering', 'We have a meeting at 2 PM', 'A formal or informal gathering where people discuss business matters', 'Meeting', 'What do you call a business gathering?', NULL, 3, 1, 1, 'B1', 'business,professional,work', 'meeting', '2025-06-01 13:00:00', 24, 5, 3),
(8, 'https://audio.leenglish.com/deadline.mp3', 'The final date when something must be completed', 'BUSINESS', 10, '2025-06-01 13:30:00', 'Time limit for completion', 'The deadline for the project is Friday', 'The latest time or date by which something should be completed', 'Deadline', 'What is the final date for completion?', NULL, 6, 1, 1, 'B1', 'business,time,work', 'deadline', '2025-06-01 13:30:00', 19, 5, 3),
(9, 'https://audio.leenglish.com/giveup.mp3', 'To stop trying; to surrender', 'PHRASAL_VERBS', 8, '2025-06-01 14:00:00', 'To cease attempting', 'Don\'t give up on your dreams!', 'To stop making an effort; to quit or abandon something', 'Give up', 'To stop trying', NULL, 4, 1, 1, 'B1', 'phrasal,verb,quit', 'give up', '2025-06-01 14:00:00', 16, 1, 4),
(10, 'https://audio.leenglish.com/howsitgoing.mp3', 'Informal way to ask about someone\'s situation', 'CONVERSATION', 20, '2025-06-01 14:30:00', 'Casual greeting/inquiry', 'Hi John, how\'s it going?', 'An informal way to greet someone and ask how they are doing', 'How\'s it going?', 'Informal way to ask how someone is', NULL, 2, 1, 1, 'A2', 'conversation,informal,greeting', 'how\'s it going', '2025-06-01 14:30:00', 35, 5, 5);

-- ================================================================
-- 10. INSERT USER LESSON PROGRESS - Learning tracking
-- ================================================================
INSERT INTO `user_lesson_progress` (`id`, `completed_at`, `created_at`, `last_accessed_at`, `notes`, `progress_percentage`, `started_at`, `status`, `time_spent_minutes`, `updated_at`, `lesson_id`, `user_id`) VALUES
(1, '2025-06-02 11:25:00', '2025-06-02 11:00:00', '2025-06-02 11:25:00', 'Completed all greeting exercises successfully', 100, '2025-06-02 11:00:00', 'COMPLETED', 25, '2025-06-02 11:25:00', 1, 2),
(2, '2025-06-03 12:30:00', '2025-06-03 12:00:00', '2025-06-03 12:30:00', 'Good understanding of present simple structure', 100, '2025-06-03 12:00:00', 'COMPLETED', 30, '2025-06-03 12:30:00', 2, 2),
(3, NULL, '2025-06-15 14:00:00', '2025-06-15 14:15:00', 'Working on number pronunciation', 60, '2025-06-15 14:00:00', 'IN_PROGRESS', 15, '2025-06-15 14:15:00', 3, 2),
(4, '2025-06-05 10:52:00', '2025-06-05 10:30:00', '2025-06-05 10:52:00', 'Great start with basic greetings', 100, '2025-06-05 10:30:00', 'COMPLETED', 22, '2025-06-05 10:52:00', 1, 3),
(5, NULL, '2025-06-10 11:15:00', '2025-06-10 11:35:00', 'Understanding present simple verb forms', 75, '2025-06-10 11:15:00', 'IN_PROGRESS', 20, '2025-06-10 11:35:00', 2, 3),
(6, '2025-06-12 15:40:00', '2025-06-12 15:00:00', '2025-06-12 15:40:00', 'Excellent progress with past tense', 100, '2025-06-12 15:00:00', 'COMPLETED', 40, '2025-06-12 15:40:00', 4, 4),
(7, NULL, '2025-06-20 09:00:00', '2025-06-20 09:30:00', 'Learning business vocabulary', 45, '2025-06-20 09:00:00', 'IN_PROGRESS', 30, '2025-06-20 09:30:00', 8, 4);

-- ================================================================
-- 11. INSERT USER EXERCISE ATTEMPTS - Exercise tracking
-- ================================================================
INSERT INTO `user_exercise_attempts` (`id`, `attempt_number`, `completed_at`, `correct_answers`, `score`, `started_at`, `status`, `time_taken`, `total_questions`, `exercise_id`, `user_id`) VALUES
(1, 1, '2025-06-02 11:15:00', 1, 100.0, '2025-06-02 11:10:00', 'COMPLETED', 15, 1, 1, 2),
(2, 1, '2025-06-02 11:20:00', 1, 100.0, '2025-06-02 11:18:00', 'COMPLETED', 12, 1, 2, 2),
(3, 1, '2025-06-03 12:20:00', 1, 100.0, '2025-06-03 12:15:00', 'COMPLETED', 18, 1, 3, 2),
(4, 1, '2025-06-05 10:45:00', 1, 100.0, '2025-06-05 10:35:00', 'COMPLETED', 20, 1, 1, 3),
(5, 1, '2025-06-05 10:50:00', 0, 0.0, '2025-06-05 10:47:00', 'COMPLETED', 25, 1, 2, 3),
(6, 2, '2025-06-05 11:00:00', 1, 100.0, '2025-06-05 10:55:00', 'COMPLETED', 15, 1, 2, 3),
(7, 1, '2025-06-12 15:25:00', 1, 100.0, '2025-06-12 15:20:00', 'COMPLETED', 22, 1, 7, 4),
(8, 1, '2025-06-12 15:35:00', 1, 100.0, '2025-06-12 15:30:00', 'COMPLETED', 35, 1, 8, 4);

-- ================================================================
-- 12. INSERT USER QUESTION ANSWERS - Detailed answer tracking
-- ================================================================
INSERT INTO `user_question_answers` (`id`, `answered_at`, `is_correct`, `time_taken`, `user_answer`, `exercise_question_id`, `user_id`, `user_exercise_attempt_id`) VALUES
(1, '2025-06-02 11:15:00', 1, 8, 'Hello', 1, 2, 1),
(2, '2025-06-02 11:16:00', 1, 7, 'Nice to meet you', 2, 2, 1),
(3, '2025-06-03 12:18:00', 1, 12, 'am', 3, 2, 3),
(4, '2025-06-03 12:19:00', 1, 6, 'are', 4, 2, 3),
(5, '2025-06-05 10:42:00', 1, 15, 'Hello', 1, 3, 4),
(6, '2025-06-05 10:48:00', 0, 20, 'See you later', 2, 3, 5),
(7, '2025-06-05 10:58:00', 1, 10, 'Nice to meet you', 2, 3, 6),
(8, '2025-06-12 15:23:00', 1, 18, 'studied', 5, 4, 7);

COMMIT;

-- ================================================================
-- VERIFICATION QUERIES (Optional - for testing)
-- ================================================================
-- SELECT COUNT(*) as total_users FROM users;
-- SELECT COUNT(*) as total_lessons FROM lessons;
-- SELECT COUNT(*) as total_exercises FROM exercises;
-- SELECT COUNT(*) as total_flashcard_sets FROM flashcard_sets;
-- SELECT COUNT(*) as total_flashcards FROM flashcards;
-- SELECT COUNT(*) as active_memberships FROM user_memberships WHERE is_active = 1;