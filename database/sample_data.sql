-- Sample Data for LeEnglish TOEIC Platform
-- Rich dataset with realistic TOEIC content including images and audio
-- Execute after running leenglish_toeic_schema.sql

USE english5;

-- =====================================================
-- SAMPLE USERS
-- =====================================================
INSERT INTO users (username, email, password, first_name, last_name, level, total_score, current_streak, is_premium) VALUES
('student001', 'student1@test.com', '$2a$10$example_hash_1', 'Alice', 'Johnson', 'BEGINNER', 150, 5, FALSE),
('student002', 'student2@test.com', '$2a$10$example_hash_2', 'Bob', 'Wilson', 'INTERMEDIATE', 450, 12, TRUE),
('student003', 'student3@test.com', '$2a$10$example_hash_3', 'Carol', 'Davis', 'ADVANCED', 850, 25, TRUE),
('student004', 'student4@test.com', '$2a$10$example_hash_4', 'David', 'Brown', 'BEGINNER', 75, 2, FALSE),
('teacher001', 'teacher@leenglish.com', '$2a$10$example_hash_teacher', 'Sarah', 'Miller', 'ADVANCED', 950, 50, TRUE);

-- =====================================================
-- COMPREHENSIVE LESSONS DATA
-- =====================================================

-- LISTENING LESSONS (PART 1-4)
INSERT INTO lessons (user_id, title, description, lesson_type, difficulty, toeic_part, target_score, estimated_duration, lesson_order, thumbnail_url, is_premium) VALUES
-- Part 1: Pictures
(1, 'TOEIC Part 1: Office Scenarios', 'Describe pictures of office and workplace situations', 'LISTENING', 'EASY', 'PART1', 80, 25, 1, '/images/thumbnails/office_scenarios.jpg', FALSE),
(1, 'TOEIC Part 1: Daily Activities', 'Practice describing everyday activities and situations', 'LISTENING', 'EASY', 'PART1', 85, 20, 2, '/images/thumbnails/daily_activities.jpg', FALSE),
(1, 'TOEIC Part 1: Transportation & Travel', 'Describe transportation and travel-related pictures', 'LISTENING', 'MEDIUM', 'PART1', 90, 30, 3, '/images/thumbnails/transportation.jpg', TRUE),

-- Part 2: Question-Response  
(1, 'TOEIC Part 2: Basic Questions', 'Master basic question-response patterns', 'LISTENING', 'EASY', 'PART2', 75, 20, 4, '/images/thumbnails/questions_basic.jpg', FALSE),
(1, 'TOEIC Part 2: Workplace Communication', 'Practice workplace question-response scenarios', 'LISTENING', 'MEDIUM', 'PART2', 80, 25, 5, '/images/thumbnails/workplace_comm.jpg', FALSE),
(1, 'TOEIC Part 2: Advanced Patterns', 'Master complex question-response patterns', 'LISTENING', 'HARD', 'PART2', 85, 30, 6, '/images/thumbnails/advanced_patterns.jpg', TRUE),

-- Part 3: Conversations
(1, 'TOEIC Part 3: Business Meetings', 'Understand business meeting conversations', 'LISTENING', 'MEDIUM', 'PART3', 70, 35, 7, '/images/thumbnails/business_meetings.jpg', FALSE),
(1, 'TOEIC Part 3: Phone Conversations', 'Practice listening to telephone conversations', 'LISTENING', 'MEDIUM', 'PART3', 75, 30, 8, '/images/thumbnails/phone_conversations.jpg', TRUE),

-- Part 4: Talks
(1, 'TOEIC Part 4: Announcements', 'Understand public announcements and messages', 'LISTENING', 'MEDIUM', 'PART4', 70, 40, 9, '/images/thumbnails/announcements.jpg', FALSE),
(1, 'TOEIC Part 4: Business Presentations', 'Listen to business presentations and reports', 'LISTENING', 'HARD', 'PART4', 75, 45, 10, '/images/thumbnails/presentations.jpg', TRUE);

-- READING LESSONS (PART 5-7)
INSERT INTO lessons (user_id, title, description, lesson_type, difficulty, toeic_part, target_score, estimated_duration, lesson_order, thumbnail_url, is_premium) VALUES
-- Part 5: Incomplete Sentences
(1, 'TOEIC Part 5: Grammar Fundamentals', 'Master basic grammar for incomplete sentences', 'READING', 'EASY', 'PART5', 80, 30, 11, '/images/thumbnails/grammar_fundamentals.jpg', FALSE),
(1, 'TOEIC Part 5: Vocabulary in Context', 'Choose correct vocabulary in business contexts', 'READING', 'MEDIUM', 'PART5', 85, 35, 12, '/images/thumbnails/vocabulary_context.jpg', FALSE),
(1, 'TOEIC Part 5: Advanced Grammar', 'Complex grammar patterns and structures', 'READING', 'HARD', 'PART5', 90, 40, 13, '/images/thumbnails/advanced_grammar.jpg', TRUE),

-- Part 6: Text Completion
(1, 'TOEIC Part 6: Email Completion', 'Complete business emails and messages', 'READING', 'MEDIUM', 'PART6', 75, 35, 14, '/images/thumbnails/email_completion.jpg', FALSE),
(1, 'TOEIC Part 6: Business Documents', 'Complete various business documents', 'READING', 'MEDIUM', 'PART6', 80, 40, 15, '/images/thumbnails/business_docs.jpg', TRUE),

-- Part 7: Reading Comprehension
(1, 'TOEIC Part 7: Single Passages', 'Understand single business documents', 'READING', 'MEDIUM', 'PART7', 70, 45, 16, '/images/thumbnails/single_passages.jpg', FALSE),
(1, 'TOEIC Part 7: Double Passages', 'Analyze relationships between two documents', 'READING', 'HARD', 'PART7', 75, 50, 17, '/images/thumbnails/double_passages.jpg', TRUE),
(1, 'TOEIC Part 7: Triple Passages', 'Master complex three-document scenarios', 'READING', 'HARD', 'PART7', 80, 60, 18, '/images/thumbnails/triple_passages.jpg', TRUE);

-- =====================================================
-- EXERCISES DATA
-- =====================================================

-- PART 1 EXERCISES
INSERT INTO exercises (lesson_id, title, description, exercise_type, toeic_part, skill_focus, instructions, context_text, total_questions, exercise_order, time_limit, context_image_url, context_audio_url) VALUES
-- Office Scenarios
(1, 'Office Workers and Equipment', 'Identify activities and objects in office settings', 'SINGLE_CHOICE', 'PART1', 'LISTENING', 'Look at each picture and listen to four statements. Choose the statement that best describes what you see.', NULL, 6, 1, 10, NULL, '/audio/exercises/part1_office_intro.mp3'),
(1, 'Meeting Room Situations', 'Describe meeting and conference room scenarios', 'SINGLE_CHOICE', 'PART1', 'LISTENING', 'Listen to the statements and choose the one that accurately describes the picture.', NULL, 4, 2, 8, NULL, '/audio/exercises/part1_meeting_intro.mp3'),

-- Daily Activities  
(2, 'Shopping and Dining', 'Practice describing shopping and restaurant scenarios', 'SINGLE_CHOICE', 'PART1', 'LISTENING', 'Choose the statement that best matches what is happening in the picture.', NULL, 5, 1, 10, NULL, '/audio/exercises/part1_shopping_intro.mp3'),
(2, 'Recreation and Leisure', 'Describe recreational and leisure activities', 'SINGLE_CHOICE', 'PART1', 'LISTENING', 'Listen carefully and select the most accurate description.', NULL, 5, 2, 10, NULL, '/audio/exercises/part1_leisure_intro.mp3'),

-- PART 2 EXERCISES
(4, 'WH-Questions Practice', 'Master Who, What, When, Where, Why questions', 'SINGLE_CHOICE', 'PART2', 'LISTENING', 'Listen to each question and choose the best response from three options.', NULL, 8, 1, 15, NULL, '/audio/exercises/part2_wh_intro.mp3'),
(4, 'Yes/No Questions', 'Practice responding to yes/no questions appropriately', 'SINGLE_CHOICE', 'PART2', 'LISTENING', 'Choose the most logical response to each question.', NULL, 6, 2, 12, NULL, '/audio/exercises/part2_yesno_intro.mp3'),

-- PART 3 EXERCISES  
(7, 'Project Planning Meeting', 'Listen to a conversation about project planning', 'SINGLE_CHOICE', 'PART3', 'LISTENING', 'Listen to the conversation and answer the questions that follow.', 'You will hear a conversation between a project manager and team member discussing upcoming deadlines.', 3, 1, 20, '/images/exercises/project_meeting.jpg', '/audio/exercises/part3_project_meeting.mp3'),
(7, 'Client Service Call', 'Understand a customer service phone conversation', 'SINGLE_CHOICE', 'PART3', 'LISTENING', 'Listen to the conversation between a customer and service representative.', 'A customer is calling about a problem with their recent order.', 3, 2, 20, '/images/exercises/customer_service.jpg', '/audio/exercises/part3_customer_service.mp3'),

-- PART 5 EXERCISES
(11, 'Verb Tenses and Forms', 'Choose correct verb forms in business contexts', 'SINGLE_CHOICE', 'PART5', 'GRAMMAR', 'Complete each sentence by selecting the correct word or phrase.', NULL, 10, 1, 20, NULL, NULL),
(11, 'Prepositions and Articles', 'Master prepositions and articles usage', 'SINGLE_CHOICE', 'PART5', 'GRAMMAR', 'Choose the word that best completes each sentence.', NULL, 8, 2, 15, NULL, NULL),

-- PART 7 EXERCISES
(16, 'Business Email Analysis', 'Analyze and understand business email content', 'SINGLE_CHOICE', 'PART7', 'READING', 'Read the email and answer the questions that follow.', 'From: john.smith@company.com\nTo: team@company.com\nSubject: Quarterly Meeting Schedule\n\nDear Team,\n\nI hope this email finds you well. I am writing to inform you about our upcoming quarterly meeting scheduled for next Friday, March 15th, at 2:00 PM in Conference Room A.\n\nThe agenda will include:\n- Q1 performance review\n- Q2 goals and objectives  \n- New project proposals\n- Budget allocation discussion\n\nPlease prepare your departmental reports and bring any questions you may have. Light refreshments will be provided.\n\nIf you cannot attend, please let me know by Wednesday so we can arrange alternative participation methods.\n\nBest regards,\nJohn Smith\nProject Manager', 4, 1, 25, NULL, NULL);

-- =====================================================
-- COMPREHENSIVE QUESTIONS DATA
-- =====================================================

-- PART 1 QUESTIONS (Picture Description)
INSERT INTO questions (exercise_id, question_text, question_type, option_a, option_b, option_c, option_d, correct_answer, explanation, toeic_part, skill_tested, points, question_order, question_image_url, question_audio_url, audio_duration) VALUES

-- Office Workers Exercise
(1, 'Look at the picture. What is happening?', 'SINGLE_CHOICE', 'A woman is filing documents', 'A man is using a photocopier', 'Someone is answering the phone', 'People are having lunch', 'B', 'The picture clearly shows a man operating a photocopying machine in an office environment.', 'PART1', 'LISTENING', 1, 1, '/images/questions/part1/office_photocopier.jpg', '/audio/questions/part1/q1_photocopier.mp3', 15),

(1, 'What do you see in this image?', 'SINGLE_CHOICE', 'A person is typing on a computer', 'Someone is reading a newspaper', 'A woman is making coffee', 'People are in an elevator', 'A', 'The image shows someone actively typing at a computer workstation.', 'PART1', 'LISTENING', 1, 2, '/images/questions/part1/office_typing.jpg', '/audio/questions/part1/q2_typing.mp3', 12),

(1, 'Describe what is shown in the picture.', 'SINGLE_CHOICE', 'Books are on a shelf', 'A meeting is in progress', 'Equipment is being moved', 'A presentation is being given', 'C', 'The picture depicts office equipment being relocated or moved.', 'PART1', 'LISTENING', 1, 3, '/images/questions/part1/office_moving.jpg', '/audio/questions/part1/q3_moving.mp3', 14),

-- PART 2 QUESTIONS (Question-Response)
(5, 'When does the store close?', 'SINGLE_CHOICE', 'At 9 PM', 'On Main Street', 'Very expensive', 'Yes, it is', 'A', 'When asking about time, the response should indicate a specific time.', 'PART2', 'LISTENING', 1, 1, NULL, '/audio/questions/part2/q1_store_close.mp3', 8),

(5, 'Who organized this event?', 'SINGLE_CHOICE', 'Next week', 'Marketing department', 'In the auditorium', 'Very successful', 'B', 'The question asks for the person or group responsible, so the answer should identify who organized it.', 'PART2', 'LISTENING', 1, 2, NULL, '/audio/questions/part2/q2_event_organizer.mp3', 10),

(5, 'Would you like some coffee?', 'SINGLE_CHOICE', 'In the morning', 'Yes, please', 'Very hot', 'Black coffee', 'B', 'This is a yes/no question offering something, so the appropriate response is acceptance or decline.', 'PART2', 'LISTENING', 1, 3, NULL, '/audio/questions/part2/q3_coffee_offer.mp3', 9),

-- PART 3 QUESTIONS (Conversations)
(9, 'What is the main topic of the conversation?', 'SINGLE_CHOICE', 'Scheduling a meeting', 'Ordering supplies', 'Planning a presentation', 'Discussing budget', 'C', 'The speakers are discussing the preparation and content of an upcoming presentation.', 'PART3', 'LISTENING', 1, 1, NULL, '/audio/questions/part3/q1_conversation_topic.mp3', 25),

(9, 'When will the presentation take place?', 'SINGLE_CHOICE', 'Tomorrow morning', 'Next week', 'This afternoon', 'Next month', 'A', 'The woman mentions that the presentation is scheduled for tomorrow morning.', 'PART3', 'LISTENING', 1, 2, NULL, '/audio/questions/part3/q2_presentation_time.mp3', 25),

(9, 'What does the man suggest?', 'SINGLE_CHOICE', 'Canceling the meeting', 'Adding more slides', 'Practicing beforehand', 'Inviting more people', 'C', 'The man recommends practicing the presentation before the actual event.', 'PART3', 'LISTENING', 1, 3, NULL, '/audio/questions/part3/q3_suggestion.mp3', 25),

-- PART 5 QUESTIONS (Grammar)
(11, 'The marketing team _____ completed their quarterly report yesterday.', 'SINGLE_CHOICE', 'have', 'has', 'had', 'having', 'B', 'The subject "team" is singular, so it requires the singular verb form "has".', 'PART5', 'GRAMMAR', 1, 1, NULL, NULL, 0),

(11, 'Please submit your expense reports _____ the end of the month.', 'SINGLE_CHOICE', 'by', 'in', 'on', 'at', 'A', '"By" indicates a deadline or time limit, which is appropriate in this context.', 'PART5', 'GRAMMAR', 1, 2, NULL, NULL, 0),

(11, 'The conference room is _____ for the board meeting this afternoon.', 'SINGLE_CHOICE', 'reserved', 'reserving', 'reservation', 'reserves', 'A', 'The past participle "reserved" is used in passive voice construction.', 'PART5', 'GRAMMAR', 1, 3, NULL, NULL, 0),

-- PART 7 QUESTIONS (Reading Comprehension)
(15, 'What is the main purpose of this email?', 'SINGLE_CHOICE', 'To cancel a meeting', 'To announce a meeting', 'To request a report', 'To change the agenda', 'B', 'The email is primarily announcing the quarterly meeting and providing details.', 'PART7', 'READING', 1, 1, NULL, NULL, 0),

(15, 'When is the meeting scheduled?', 'SINGLE_CHOICE', 'March 14th at 2:00 PM', 'March 15th at 2:00 PM', 'March 16th at 2:00 PM', 'March 15th at 3:00 PM', 'B', 'The email clearly states the meeting is on Friday, March 15th, at 2:00 PM.', 'PART7', 'READING', 1, 2, NULL, NULL, 0),

(15, 'What should attendees bring to the meeting?', 'SINGLE_CHOICE', 'Laptops', 'Departmental reports', 'Lunch', 'Presentation slides', 'B', 'The email specifically requests that attendees prepare and bring their departmental reports.', 'PART7', 'READING', 1, 3, NULL, NULL, 0),

(15, 'What will be provided at the meeting?', 'SINGLE_CHOICE', 'Transportation', 'Equipment', 'Light refreshments', 'Printed materials', 'C', 'The email mentions that light refreshments will be provided.', 'PART7', 'READING', 1, 4, NULL, NULL, 0);

-- =====================================================
-- UPDATE EXERCISE AND LESSON TOTALS
-- =====================================================

-- Update total questions in exercises
UPDATE exercises SET total_questions = (
    SELECT COUNT(*) FROM questions WHERE questions.exercise_id = exercises.id
);

-- Update total exercises in lessons
UPDATE lessons SET total_exercises = (
    SELECT COUNT(*) FROM exercises WHERE exercises.lesson_id = lessons.id
);

-- =====================================================
-- SAMPLE MEDIA FILES
-- =====================================================
INSERT INTO media_files (file_name, original_name, file_path, file_url, file_type, mime_type, file_size, usage_type, reference_id, reference_type, width, height, duration) VALUES
-- Question Images
('office_photocopier.jpg', 'office_photocopier_original.jpg', '/storage/images/questions/part1/', '/images/questions/part1/office_photocopier.jpg', 'IMAGE', 'image/jpeg', 245760, 'QUESTION_IMAGE', 1, 'QUESTION', 800, 600, 0),
('office_typing.jpg', 'office_typing_original.jpg', '/storage/images/questions/part1/', '/images/questions/part1/office_typing.jpg', 'IMAGE', 'image/jpeg', 198432, 'QUESTION_IMAGE', 2, 'QUESTION', 800, 600, 0),
('office_moving.jpg', 'office_moving_original.jpg', '/storage/images/questions/part1/', '/images/questions/part1/office_moving.jpg', 'IMAGE', 'image/jpeg', 312150, 'QUESTION_IMAGE', 3, 'QUESTION', 800, 600, 0),

-- Question Audio Files  
('q1_photocopier.mp3', 'part1_question1_audio.mp3', '/storage/audio/questions/part1/', '/audio/questions/part1/q1_photocopier.mp3', 'AUDIO', 'audio/mpeg', 187392, 'QUESTION_AUDIO', 1, 'QUESTION', 0, 0, 15),
('q2_typing.mp3', 'part1_question2_audio.mp3', '/storage/audio/questions/part1/', '/audio/questions/part1/q2_typing.mp3', 'AUDIO', 'audio/mpeg', 149504, 'QUESTION_AUDIO', 2, 'QUESTION', 0, 0, 12),
('q3_moving.mp3', 'part1_question3_audio.mp3', '/storage/audio/questions/part1/', '/audio/questions/part1/q3_moving.mp3', 'AUDIO', 'audio/mpeg', 174080, 'QUESTION_AUDIO', 3, 'QUESTION', 0, 0, 14),

-- Exercise Context Audio
('part1_office_intro.mp3', 'part1_office_introduction.mp3', '/storage/audio/exercises/', '/audio/exercises/part1_office_intro.mp3', 'AUDIO', 'audio/mpeg', 96256, 'EXERCISE_CONTEXT', 1, 'EXERCISE', 0, 0, 8),
('part3_project_meeting.mp3', 'part3_project_meeting_conversation.mp3', '/storage/audio/exercises/', '/audio/exercises/part3_project_meeting.mp3', 'AUDIO', 'audio/mpeg', 1248760, 'EXERCISE_CONTEXT', 9, 'EXERCISE', 0, 0, 120),

-- Lesson Thumbnails
('office_scenarios.jpg', 'office_scenarios_thumbnail.jpg', '/storage/images/thumbnails/', '/images/thumbnails/office_scenarios.jpg', 'IMAGE', 'image/jpeg', 87654, 'LESSON_THUMBNAIL', 1, 'LESSON', 400, 300, 0),
('daily_activities.jpg', 'daily_activities_thumbnail.jpg', '/storage/images/thumbnails/', '/images/thumbnails/daily_activities.jpg', 'IMAGE', 'image/jpeg', 92341, 'LESSON_THUMBNAIL', 2, 'LESSON', 400, 300, 0);

-- =====================================================
-- SAMPLE USER PROGRESS DATA
-- =====================================================

-- User Lesson Progress
INSERT INTO user_lesson_progress (user_id, lesson_id, status, completed_exercises, total_exercises, completion_percentage, total_score, max_possible_score, score_percentage, time_spent, started_at, completed_at) VALUES
(1, 1, 'COMPLETED', 2, 2, 100.00, 8, 10, 80.00, 25, '2025-06-10 09:00:00', '2025-06-10 09:25:00'),
(1, 2, 'IN_PROGRESS', 1, 2, 50.00, 4, 5, 80.00, 15, '2025-06-15 14:00:00', NULL),
(1, 4, 'COMPLETED', 2, 2, 100.00, 12, 14, 85.71, 35, '2025-06-12 10:00:00', '2025-06-12 10:35:00'),
(2, 1, 'COMPLETED', 2, 2, 100.00, 9, 10, 90.00, 20, '2025-06-08 16:00:00', '2025-06-08 16:20:00'),
(2, 7, 'IN_PROGRESS', 1, 2, 50.00, 3, 3, 100.00, 20, '2025-06-16 11:00:00', NULL);

-- User Exercise Progress
INSERT INTO user_exercise_progress (user_id, lesson_id, exercise_id, status, completed_questions, total_questions, completion_percentage, score, max_score, score_percentage, is_passed, time_spent, started_at, completed_at) VALUES
(1, 1, 1, 'COMPLETED', 6, 6, 100.00, 5, 6, 83.33, TRUE, 600, '2025-06-10 09:00:00', '2025-06-10 09:10:00'),
(1, 1, 2, 'COMPLETED', 4, 4, 100.00, 3, 4, 75.00, TRUE, 480, '2025-06-10 09:15:00', '2025-06-10 09:23:00'),
(1, 4, 5, 'COMPLETED', 8, 8, 100.00, 7, 8, 87.50, TRUE, 900, '2025-06-12 10:00:00', '2025-06-12 10:15:00'),
(1, 4, 6, 'COMPLETED', 6, 6, 100.00, 5, 6, 83.33, TRUE, 720, '2025-06-12 10:20:00', '2025-06-12 10:32:00'),
(2, 1, 1, 'COMPLETED', 6, 6, 100.00, 6, 6, 100.00, TRUE, 540, '2025-06-08 16:00:00', '2025-06-08 16:09:00');

-- User Question Answers
INSERT INTO user_question_answers (user_id, exercise_id, question_id, selected_answer, is_correct, points_earned, time_spent, answered_at) VALUES
(1, 1, 1, 'B', TRUE, 1, 45, '2025-06-10 09:02:00'),
(1, 1, 2, 'A', TRUE, 1, 38, '2025-06-10 09:03:00'),
(1, 1, 3, 'C', TRUE, 1, 42, '2025-06-10 09:04:00'),
(1, 5, 4, 'A', TRUE, 1, 25, '2025-06-12 10:05:00'),
(1, 5, 5, 'B', TRUE, 1, 30, '2025-06-12 10:06:00'),
(1, 5, 6, 'B', TRUE, 1, 28, '2025-06-12 10:07:00'),
(2, 1, 1, 'B', TRUE, 1, 40, '2025-06-08 16:02:00'),
(2, 1, 2, 'A', TRUE, 1, 35, '2025-06-08 16:03:00'),
(2, 1, 3, 'C', TRUE, 1, 38, '2025-06-08 16:04:00');

-- =====================================================
-- LESSON CATEGORY MAPPINGS
-- =====================================================
INSERT INTO lesson_category_mapping (lesson_id, category_id) VALUES
(1, 1), (2, 1), (3, 1), -- Listening lessons
(4, 1), (5, 1), (6, 1),
(7, 1), (8, 1), (9, 1), (10, 1),
(11, 2), (12, 2), (13, 2), -- Reading lessons  
(14, 2), (15, 2), (16, 2), (17, 2), (18, 2),
(11, 4), (12, 3), (13, 4); -- Grammar and Vocabulary

-- =====================================================
-- SAMPLE ACHIEVEMENTS
-- =====================================================
INSERT INTO user_achievements (user_id, achievement_type, achievement_name, achievement_description, target_value, current_value, is_completed, earned_at) VALUES
(1, 'COMPLETION', 'First Lesson Complete', 'Complete your first lesson', 1, 1, TRUE, '2025-06-10 09:25:00'),
(1, 'STREAK', '5 Day Streak', 'Study for 5 consecutive days', 5, 5, TRUE, '2025-06-15 20:00:00'),
(1, 'SCORE', 'High Achiever', 'Score 80% or higher on 3 exercises', 3, 2, FALSE, NULL),
(2, 'COMPLETION', 'First Lesson Complete', 'Complete your first lesson', 1, 1, TRUE, '2025-06-08 16:20:00'),
(2, 'ACCURACY', 'Perfect Score', 'Get 100% on any exercise', 1, 1, TRUE, '2025-06-08 16:09:00'),
(2, 'STREAK', '10 Day Streak', 'Study for 10 consecutive days', 10, 12, TRUE, '2025-06-14 19:00:00');

COMMIT;
