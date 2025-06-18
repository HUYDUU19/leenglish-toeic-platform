-- ========================================
-- LEENGLISH TOEIC PLATFORM DATABASE SCHEMA
-- ========================================
-- Structure: User → Lessons → Exercises → Questions
-- Created: 2025-06-18
-- Updated: Compatible with Spring Boot JPA

-- Drop existing tables if they exist (in reverse order due to foreign keys)
DROP TABLE IF EXISTS user_progress;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS exercises;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS users;

-- ========================================
-- 1. USERS TABLE
-- ========================================
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    phone VARCHAR(15),
    date_of_birth DATE,
    gender ENUM('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY'),
    country VARCHAR(100),
    role ENUM('USER', 'ADMIN', 'COLLABORATOR') NOT NULL DEFAULT 'USER',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    profile_picture_url VARCHAR(500),
    total_score INT NOT NULL DEFAULT 0,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    premium_expires_at TIMESTAMP NULL,
    is_premium BOOLEAN NOT NULL DEFAULT FALSE,
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_created_at (created_at),
    INDEX idx_total_score (total_score)
);

-- ========================================
-- 2. LESSONS TABLE  
-- ========================================
CREATE TABLE lessons (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    skill ENUM('LISTENING', 'READING', 'GRAMMAR', 'VOCABULARY', 'SPEAKING', 'WRITING') NOT NULL,
    difficulty_level ENUM('BEGINNER', 'ELEMENTARY', 'INTERMEDIATE', 'UPPER_INTERMEDIATE', 'ADVANCED') NOT NULL DEFAULT 'BEGINNER',
    toeic_part ENUM('PART1', 'PART2', 'PART3', 'PART4', 'PART5', 'PART6', 'PART7') NOT NULL,
    image_url VARCHAR(500),
    audio_url VARCHAR(500),
    video_url VARCHAR(500),
    duration_minutes INT DEFAULT 30,
    is_premium BOOLEAN NOT NULL DEFAULT FALSE,
    is_published BOOLEAN NOT NULL DEFAULT TRUE,
    lesson_order INT NOT NULL DEFAULT 1,
    total_exercises INT NOT NULL DEFAULT 0,
    completion_rate DECIMAL(5,2) DEFAULT 0.00,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    INDEX idx_user_id (user_id),
    INDEX idx_skill (skill),
    INDEX idx_difficulty (difficulty_level),
    INDEX idx_toeic_part (toeic_part),
    INDEX idx_lesson_order (lesson_order),
    INDEX idx_created_at (created_at),
    INDEX idx_user_skill (user_id, skill),
    INDEX idx_user_part (user_id, toeic_part)
);

-- ========================================
-- 3. EXERCISES TABLE
-- ========================================
CREATE TABLE exercises (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lesson_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    exercise_type ENUM('MULTIPLE_CHOICE', 'FILL_IN_BLANK', 'TRUE_FALSE', 'MATCHING', 'LISTENING_COMPREHENSION', 'READING_COMPREHENSION', 'GRAMMAR_CHECK', 'VOCABULARY_QUIZ') NOT NULL,
    instructions TEXT,
    image_url VARCHAR(500),
    audio_url VARCHAR(500),
    video_url VARCHAR(500),
    exercise_order INT NOT NULL DEFAULT 1,
    time_limit_minutes INT DEFAULT 10,
    total_questions INT NOT NULL DEFAULT 0,
    max_score INT NOT NULL DEFAULT 100,
    passing_score INT NOT NULL DEFAULT 60,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    
    INDEX idx_lesson_id (lesson_id),
    INDEX idx_exercise_type (exercise_type),
    INDEX idx_exercise_order (exercise_order),
    INDEX idx_created_at (created_at),
    INDEX idx_lesson_order (lesson_id, exercise_order)
);

-- ========================================
-- 4. QUESTIONS TABLE
-- ========================================
CREATE TABLE questions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    exercise_id BIGINT NOT NULL,
    question_text TEXT NOT NULL,
    question_type ENUM('MULTIPLE_CHOICE', 'FILL_IN_BLANK', 'TRUE_FALSE', 'SHORT_ANSWER', 'ESSAY') NOT NULL DEFAULT 'MULTIPLE_CHOICE',
    option_a VARCHAR(500),
    option_b VARCHAR(500),
    option_c VARCHAR(500),
    option_d VARCHAR(500),
    correct_answer VARCHAR(500) NOT NULL,
    explanation TEXT,
    image_url VARCHAR(500),
    audio_url VARCHAR(500),
    video_url VARCHAR(500),
    question_order INT NOT NULL DEFAULT 1,
    points INT NOT NULL DEFAULT 5,
    difficulty_level ENUM('EASY', 'MEDIUM', 'HARD') NOT NULL DEFAULT 'MEDIUM',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    
    INDEX idx_exercise_id (exercise_id),
    INDEX idx_question_type (question_type),
    INDEX idx_question_order (question_order),
    INDEX idx_difficulty (difficulty_level),
    INDEX idx_created_at (created_at),
    INDEX idx_exercise_order (exercise_id, question_order)
);

-- ========================================
-- 5. USER_PROGRESS TABLE (Tracking Progress)
-- ========================================
CREATE TABLE user_progress (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    lesson_id BIGINT,
    exercise_id BIGINT,
    question_id BIGINT,
    progress_type ENUM('LESSON_STARTED', 'LESSON_COMPLETED', 'EXERCISE_STARTED', 'EXERCISE_COMPLETED', 'QUESTION_ANSWERED') NOT NULL,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    score INT DEFAULT 0,
    max_score INT DEFAULT 0,
    time_spent_minutes INT DEFAULT 0,
    attempts INT NOT NULL DEFAULT 1,
    user_answer TEXT,
    is_correct BOOLEAN,
    completed_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    
    INDEX idx_user_id (user_id),
    INDEX idx_lesson_id (lesson_id),
    INDEX idx_exercise_id (exercise_id),
    INDEX idx_question_id (question_id),
    INDEX idx_progress_type (progress_type),
    INDEX idx_is_completed (is_completed),
    INDEX idx_created_at (created_at),
    INDEX idx_user_lesson (user_id, lesson_id),
    INDEX idx_user_exercise (user_id, exercise_id),
    INDEX idx_user_progress_type (user_id, progress_type)
);

-- ========================================
-- TRIGGERS FOR AUTO-UPDATING COUNTS
-- ========================================

-- Update total_exercises in lessons when exercise is added/removed
DELIMITER //
CREATE TRIGGER update_lesson_exercise_count 
AFTER INSERT ON exercises
FOR EACH ROW
BEGIN
    UPDATE lessons 
    SET total_exercises = (
        SELECT COUNT(*) 
        FROM exercises 
        WHERE lesson_id = NEW.lesson_id AND is_active = TRUE
    )
    WHERE id = NEW.lesson_id;
END//

CREATE TRIGGER update_lesson_exercise_count_delete
AFTER DELETE ON exercises
FOR EACH ROW
BEGIN
    UPDATE lessons 
    SET total_exercises = (
        SELECT COUNT(*) 
        FROM exercises 
        WHERE lesson_id = OLD.lesson_id AND is_active = TRUE
    )
    WHERE id = OLD.lesson_id;
END//

-- Update total_questions in exercises when question is added/removed
CREATE TRIGGER update_exercise_question_count
AFTER INSERT ON questions
FOR EACH ROW
BEGIN
    UPDATE exercises 
    SET total_questions = (
        SELECT COUNT(*) 
        FROM questions 
        WHERE exercise_id = NEW.exercise_id AND is_active = TRUE
    )
    WHERE id = NEW.exercise_id;
END//

CREATE TRIGGER update_exercise_question_count_delete
AFTER DELETE ON questions
FOR EACH ROW
BEGIN
    UPDATE exercises 
    SET total_questions = (
        SELECT COUNT(*) 
        FROM questions 
        WHERE exercise_id = OLD.exercise_id AND is_active = TRUE
    )
    WHERE id = OLD.exercise_id;
END//

DELIMITER ;

-- ========================================
-- INITIAL DATA SETUP
-- ========================================

-- Create admin user
INSERT INTO users (username, email, password_hash, full_name, role, country, total_score) VALUES
('admin', 'admin@leenglish.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd99B9tsT/WSyDkW', 'System Administrator', 'ADMIN', 'Vietnam', 0);

-- Create sample users
INSERT INTO users (username, email, password_hash, full_name, phone, date_of_birth, gender, country, total_score) VALUES
('john_doe', 'john@example.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd99B9tsT/WSyDkW', 'John Doe', '+1234567890', '1995-05-15', 'MALE', 'USA', 850),
('jane_smith', 'jane@example.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd99B9tsT/WSyDkW', 'Jane Smith', '+1987654321', '1992-08-22', 'FEMALE', 'Canada', 920),
('toeic_learner', 'learner@example.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd99B9tsT/WSyDkW', 'TOEIC Learner', '+84123456789', '1998-12-10', 'OTHER', 'Vietnam', 750);

-- Create sample lessons for user 2 (john_doe)
INSERT INTO lessons (user_id, title, description, skill, difficulty_level, toeic_part, image_url, audio_url, duration_minutes, lesson_order) VALUES
(2, 'TOEIC Part 1: Photographs', 'Learn to describe photographs in detail using present continuous and simple present tense', 'LISTENING', 'BEGINNER', 'PART1', 'https://example.com/images/part1_photos.jpg', 'https://example.com/audio/part1_intro.mp3', 45, 1),
(2, 'TOEIC Part 2: Question-Response', 'Master short conversations and appropriate responses', 'LISTENING', 'ELEMENTARY', 'PART2', 'https://example.com/images/part2_conversation.jpg', 'https://example.com/audio/part2_intro.mp3', 30, 2),
(2, 'TOEIC Part 5: Incomplete Sentences', 'Complete sentences with correct grammar and vocabulary', 'GRAMMAR', 'INTERMEDIATE', 'PART5', 'https://example.com/images/part5_grammar.jpg', NULL, 40, 3);

-- Create sample lessons for user 3 (jane_smith)
INSERT INTO lessons (user_id, title, description, skill, difficulty_level, toeic_part, image_url, duration_minutes, lesson_order) VALUES
(3, 'Advanced Reading Comprehension', 'Advanced reading strategies for TOEIC Part 7', 'READING', 'ADVANCED', 'PART7', 'https://example.com/images/reading_advanced.jpg', 60, 1),
(3, 'Business Vocabulary Builder', 'Essential business vocabulary for TOEIC success', 'VOCABULARY', 'UPPER_INTERMEDIATE', 'PART5', 'https://example.com/images/business_vocab.jpg', 35, 2);

-- Create sample exercises for lessons
INSERT INTO exercises (lesson_id, title, description, exercise_type, instructions, image_url, audio_url, exercise_order, time_limit_minutes, max_score) VALUES
-- Exercises for Lesson 1 (Part 1: Photographs)
(1, 'Photograph Description Practice', 'Look at photographs and choose the best description', 'MULTIPLE_CHOICE', 'Listen to four statements about the photograph. Choose the statement that best describes what you see.', 'https://example.com/images/photo_exercise1.jpg', 'https://example.com/audio/part1_ex1.mp3', 1, 15, 100),
(1, 'Present Continuous Recognition', 'Identify present continuous actions in photos', 'MULTIPLE_CHOICE', 'Select the sentence that correctly uses present continuous tense to describe the photograph.', 'https://example.com/images/photo_exercise2.jpg', NULL, 2, 10, 80),

-- Exercises for Lesson 2 (Part 2: Question-Response)
(2, 'Question Types Practice', 'Practice different types of questions in TOEIC Part 2', 'LISTENING_COMPREHENSION', 'Listen to a question and three responses. Choose the best response.', NULL, 'https://example.com/audio/part2_ex1.mp3', 1, 20, 100),
(2, 'Appropriate Responses', 'Choose appropriate responses to various questions', 'MULTIPLE_CHOICE', 'Read the question and select the most appropriate response.', NULL, 'https://example.com/audio/part2_ex2.mp3', 2, 15, 90),

-- Exercises for Lesson 3 (Part 5: Grammar)
(3, 'Verb Tense Selection', 'Choose the correct verb tense for each sentence', 'MULTIPLE_CHOICE', 'Complete each sentence by choosing the correct verb form.', NULL, NULL, 1, 25, 100),
(3, 'Preposition Practice', 'Master common prepositions in business contexts', 'FILL_IN_BLANK', 'Fill in the blanks with the appropriate prepositions.', NULL, NULL, 2, 20, 80),

-- Exercises for Lesson 4 (Advanced Reading)
(4, 'Business Email Comprehension', 'Understand business emails and documents', 'READING_COMPREHENSION', 'Read the business email and answer the questions.', NULL, NULL, 1, 30, 100),

-- Exercises for Lesson 5 (Business Vocabulary)
(5, 'Corporate Terminology Quiz', 'Test your knowledge of business terms', 'VOCABULARY_QUIZ', 'Choose the best definition for each business term.', NULL, NULL, 1, 15, 100);

-- Create sample questions for exercises
INSERT INTO questions (exercise_id, question_text, question_type, option_a, option_b, option_c, option_d, correct_answer, explanation, image_url, audio_url, question_order, points) VALUES
-- Questions for Exercise 1 (Photograph Description)
(1, 'What is happening in this photograph?', 'MULTIPLE_CHOICE', 'A man is reading a newspaper', 'A woman is typing on a computer', 'People are having a meeting', 'Someone is making a phone call', 'B', 'The photograph shows a woman sitting at a desk, typing on a computer keyboard.', 'https://example.com/images/woman_typing.jpg', 'https://example.com/audio/q1.mp3', 1, 5),
(1, 'Where is this scene taking place?', 'MULTIPLE_CHOICE', 'In a library', 'In an office', 'In a restaurant', 'In a hospital', 'B', 'The setting appears to be a modern office environment with desks and computers.', 'https://example.com/images/office_scene.jpg', 'https://example.com/audio/q2.mp3', 2, 5),

-- Questions for Exercise 2 (Present Continuous)
(2, 'Which sentence correctly describes the action?', 'MULTIPLE_CHOICE', 'The man reads a book', 'The man is reading a book', 'The man will read a book', 'The man has read a book', 'B', 'Present continuous tense (is reading) is used to describe an action happening now in the photograph.', 'https://example.com/images/man_reading.jpg', NULL, 1, 4),

-- Questions for Exercise 3 (Question-Response)
(3, 'When will the meeting start?', 'MULTIPLE_CHOICE', 'In the conference room', 'At 2:00 PM', 'With the entire team', 'Yes, it will', 'B', 'When asking about time, the appropriate response should indicate a specific time.', NULL, 'https://example.com/audio/q3.mp3', 1, 5),
(3, 'Who is responsible for this project?', 'MULTIPLE_CHOICE', 'Next Monday', 'In the morning', 'Sarah from marketing', 'Very important', 'C', 'Who questions require answers that identify a person or group of people.', NULL, 'https://example.com/audio/q4.mp3', 2, 5),

-- Questions for Exercise 4 (Appropriate Responses)
(4, 'Would you like some coffee?', 'MULTIPLE_CHOICE', 'Yes, black please', 'In the kitchen', 'Very expensive', 'Tomorrow morning', 'A', 'Offers should be responded to with acceptance or polite refusal, along with any preferences.', NULL, 'https://example.com/audio/q5.mp3', 1, 4),

-- Questions for Exercise 5 (Verb Tense)
(5, 'The company _____ its profits significantly last year.', 'MULTIPLE_CHOICE', 'increase', 'increased', 'will increase', 'is increasing', 'B', 'Last year indicates past time, so simple past tense (increased) is correct.', NULL, NULL, 1, 5),
(5, 'We _____ a new marketing strategy next month.', 'MULTIPLE_CHOICE', 'implement', 'implemented', 'will implement', 'are implementing', 'C', 'Next month indicates future time, so future tense (will implement) is correct.', NULL, NULL, 2, 5),

-- Questions for Exercise 6 (Prepositions)
(6, 'The meeting is scheduled _____ 3:00 PM.', 'FILL_IN_BLANK', 'at', 'in', 'on', 'for', 'at', 'We use at with specific times (3:00 PM).', NULL, NULL, 1, 4),
(6, 'Please submit your report _____ Friday.', 'FILL_IN_BLANK', 'at', 'in', 'on', 'by', 'by', 'By indicates a deadline - submit before or on Friday.', NULL, NULL, 2, 4),

-- Questions for Exercise 7 (Business Email Comprehension)
(7, 'What is the main purpose of this email?', 'MULTIPLE_CHOICE', 'To schedule a meeting', 'To request information', 'To confirm an order', 'To announce a promotion', 'C', 'The email content focuses on confirming order details and delivery information.', NULL, NULL, 1, 6),

-- Questions for Exercise 8 (Corporate Terminology)
(8, 'What does ROI stand for?', 'MULTIPLE_CHOICE', 'Return on Investment', 'Rate of Interest', 'Revenue of Income', 'Report on Issues', 'A', 'ROI is a common business metric that measures Return on Investment.', NULL, NULL, 1, 5),
(8, 'What is a stakeholder?', 'MULTIPLE_CHOICE', 'A company owner', 'Anyone affected by business decisions', 'A stock market investor', 'A government regulator', 'B', 'A stakeholder is any person or group that has an interest in or is affected by a companys decisions.', NULL, NULL, 2, 5);

-- Create sample user progress data
INSERT INTO user_progress (user_id, lesson_id, exercise_id, question_id, progress_type, is_completed, score, max_score, time_spent_minutes, user_answer, is_correct) VALUES
-- John Doe's progress
(2, 1, 1, 1, 'QUESTION_ANSWERED', TRUE, 5, 5, 2, 'B', TRUE),
(2, 1, 1, 2, 'QUESTION_ANSWERED', TRUE, 5, 5, 3, 'B', TRUE),
(2, 1, 1, NULL, 'EXERCISE_COMPLETED', TRUE, 10, 10, 5, NULL, NULL),
(2, 1, NULL, NULL, 'LESSON_STARTED', FALSE, 10, 20, 5, NULL, NULL),

-- Jane Smith's progress
(3, 4, 7, 7, 'QUESTION_ANSWERED', TRUE, 6, 6, 4, 'C', TRUE),
(3, 4, 7, NULL, 'EXERCISE_COMPLETED', TRUE, 6, 6, 4, NULL, NULL),
(3, 4, NULL, NULL, 'LESSON_COMPLETED', TRUE, 6, 6, 4, NULL, NULL);

-- ========================================
-- USEFUL QUERIES FOR TESTING
-- ========================================

/*
-- Get all lessons for a specific user with exercise counts
SELECT l.*, COUNT(e.id) as exercise_count 
FROM lessons l 
LEFT JOIN exercises e ON l.id = e.lesson_id 
WHERE l.user_id = 2 
GROUP BY l.id;

-- Get all exercises for a specific lesson with question counts
SELECT e.*, COUNT(q.id) as question_count 
FROM exercises e 
LEFT JOIN questions q ON e.id = q.exercise_id 
WHERE e.lesson_id = 1 
GROUP BY e.id;

-- Get user progress for a specific lesson
SELECT up.*, l.title as lesson_title, e.title as exercise_title 
FROM user_progress up 
LEFT JOIN lessons l ON up.lesson_id = l.id 
LEFT JOIN exercises e ON up.exercise_id = e.id 
WHERE up.user_id = 2 AND up.lesson_id = 1;

-- Get leaderboard (top users by total score)
SELECT username, full_name, total_score, country 
FROM users 
WHERE role = 'USER' AND is_active = TRUE 
ORDER BY total_score DESC 
LIMIT 10;
*/