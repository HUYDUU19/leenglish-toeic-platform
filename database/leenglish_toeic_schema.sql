-- LeEnglish TOEIC Platform Database Schema
-- Structure: User -> Lessons -> Exercises -> Questions
-- Created: June 18, 2025

-- Drop database if exists and create new one
DROP DATABASE IF EXISTS english5;
CREATE DATABASE english5 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE english5;

-- =====================================================
-- 1. USERS TABLE
-- =====================================================
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    avatar_url VARCHAR(500),
    date_of_birth DATE,
    gender ENUM('MALE', 'FEMALE', 'OTHER'),
    
    -- Learning Progress
    level ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED') DEFAULT 'BEGINNER',
    total_score INT DEFAULT 0,
    current_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    
    -- Account Status
    is_active BOOLEAN DEFAULT TRUE,
    is_premium BOOLEAN DEFAULT FALSE,
    email_verified BOOLEAN DEFAULT FALSE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP NULL,
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_level (level),
    INDEX idx_created_at (created_at)
);

-- =====================================================
-- 2. LESSONS TABLE
-- =====================================================
CREATE TABLE lessons (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    
    -- Lesson Information
    title VARCHAR(200) NOT NULL,
    description TEXT,
    lesson_type ENUM('LISTENING', 'READING', 'MIXED', 'VOCABULARY', 'GRAMMAR') NOT NULL,
    difficulty ENUM('EASY', 'MEDIUM', 'HARD') DEFAULT 'EASY',
    level ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED') DEFAULT 'BEGINNER',
    
    -- TOEIC Specific
    toeic_part ENUM('PART1', 'PART2', 'PART3', 'PART4', 'PART5', 'PART6', 'PART7') NOT NULL,
    target_score INT DEFAULT 0,
    estimated_duration INT DEFAULT 30, -- minutes
    
    -- Media Resources
    thumbnail_url VARCHAR(500),
    intro_video_url VARCHAR(500),
    intro_audio_url VARCHAR(500),
    
    -- Progress Tracking
    total_exercises INT DEFAULT 0,
    completed_exercises INT DEFAULT 0,
    is_completed BOOLEAN DEFAULT FALSE,
    completion_percentage DECIMAL(5,2) DEFAULT 0.00,
    
    -- Order and Status
    lesson_order INT DEFAULT 0,
    is_locked BOOLEAN DEFAULT FALSE,
    is_premium BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_lessons (user_id),
    INDEX idx_lesson_type (lesson_type),
    INDEX idx_toeic_part (toeic_part),
    INDEX idx_difficulty (difficulty),
    INDEX idx_lesson_order (lesson_order)
);

-- =====================================================
-- 3. EXERCISES TABLE
-- =====================================================
CREATE TABLE exercises (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lesson_id BIGINT NOT NULL,
    
    -- Exercise Information
    title VARCHAR(200) NOT NULL,
    description TEXT,
    exercise_type ENUM('SINGLE_CHOICE', 'MULTIPLE_CHOICE', 'LISTENING_COMPREHENSION', 'READING_COMPREHENSION', 'FILL_BLANK', 'MATCHING') NOT NULL,
    difficulty ENUM('EASY', 'MEDIUM', 'HARD') DEFAULT 'EASY',
    
    -- TOEIC Specific
    toeic_part ENUM('PART1', 'PART2', 'PART3', 'PART4', 'PART5', 'PART6', 'PART7') NOT NULL,
    skill_focus ENUM('LISTENING', 'READING', 'VOCABULARY', 'GRAMMAR') NOT NULL,
    
    -- Content & Media
    instructions TEXT,
    context_text TEXT, -- For reading exercises
    context_image_url VARCHAR(500), -- For image-based questions
    context_audio_url VARCHAR(500), -- For listening exercises
    context_video_url VARCHAR(500), -- For video exercises
    
    -- Audio Settings (for listening exercises)
    audio_duration INT DEFAULT 0, -- seconds
    audio_plays_allowed INT DEFAULT 2, -- How many times can play
    audio_transcript TEXT, -- For reference
    
    -- Progress Tracking
    total_questions INT DEFAULT 0,
    completed_questions INT DEFAULT 0,
    is_completed BOOLEAN DEFAULT FALSE,
    
    -- Scoring
    max_score INT DEFAULT 100,
    passing_score INT DEFAULT 70,
    time_limit INT DEFAULT 0, -- minutes, 0 = no limit
    
    -- Order and Status
    exercise_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    INDEX idx_lesson_exercises (lesson_id),
    INDEX idx_exercise_type (exercise_type),
    INDEX idx_toeic_part (toeic_part),
    INDEX idx_skill_focus (skill_focus),
    INDEX idx_exercise_order (exercise_order)
);

-- =====================================================
-- 4. QUESTIONS TABLE
-- =====================================================
CREATE TABLE questions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    exercise_id BIGINT NOT NULL,
    
    -- Question Content
    question_text TEXT NOT NULL,
    question_type ENUM('SINGLE_CHOICE', 'MULTIPLE_CHOICE', 'TRUE_FALSE', 'FILL_BLANK', 'MATCHING') NOT NULL,
    difficulty ENUM('EASY', 'MEDIUM', 'HARD') DEFAULT 'EASY',
    
    -- Media Resources
    question_image_url VARCHAR(500), -- Image for the question
    question_audio_url VARCHAR(500), -- Audio for the question
    audio_duration INT DEFAULT 0, -- seconds
    
    -- Answer Options (JSON format for flexibility)
    option_a VARCHAR(500),
    option_b VARCHAR(500),
    option_c VARCHAR(500),
    option_d VARCHAR(500),
    option_e VARCHAR(500), -- For some TOEIC parts
    
    -- Correct Answer
    correct_answer CHAR(1) NOT NULL, -- A, B, C, D, E
    correct_answer_text TEXT, -- For fill-in-the-blank questions
    
    -- Explanation & Learning
    explanation TEXT,
    explanation_image_url VARCHAR(500),
    explanation_audio_url VARCHAR(500),
    learning_tip TEXT,
    
    -- TOEIC Specific
    toeic_part ENUM('PART1', 'PART2', 'PART3', 'PART4', 'PART5', 'PART6', 'PART7') NOT NULL,
    skill_tested ENUM('LISTENING', 'READING', 'VOCABULARY', 'GRAMMAR', 'COMPREHENSION') NOT NULL,
    
    -- Scoring
    points INT DEFAULT 1,
    time_limit INT DEFAULT 0, -- seconds per question
    
    -- Order and Status
    question_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Statistics
    total_attempts INT DEFAULT 0,
    correct_attempts INT DEFAULT 0,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    INDEX idx_exercise_questions (exercise_id),
    INDEX idx_question_type (question_type),
    INDEX idx_toeic_part (toeic_part),
    INDEX idx_skill_tested (skill_tested),
    INDEX idx_question_order (question_order)
);

-- =====================================================
-- 5. USER LESSON PROGRESS TABLE
-- =====================================================
CREATE TABLE user_lesson_progress (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    lesson_id BIGINT NOT NULL,
    
    -- Progress Tracking
    status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'LOCKED') DEFAULT 'NOT_STARTED',
    completed_exercises INT DEFAULT 0,
    total_exercises INT DEFAULT 0,
    completion_percentage DECIMAL(5,2) DEFAULT 0.00,
    
    -- Scoring
    total_score INT DEFAULT 0,
    max_possible_score INT DEFAULT 0,
    score_percentage DECIMAL(5,2) DEFAULT 0.00,
    
    -- Time Tracking
    time_spent INT DEFAULT 0, -- minutes
    started_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    last_accessed_at TIMESTAMP NULL,
    
    -- Attempts
    attempt_count INT DEFAULT 0,
    best_score INT DEFAULT 0,
    best_score_percentage DECIMAL(5,2) DEFAULT 0.00,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_lesson (user_id, lesson_id),
    INDEX idx_user_progress (user_id),
    INDEX idx_lesson_progress (lesson_id),
    INDEX idx_status (status)
);

-- =====================================================
-- 6. USER EXERCISE PROGRESS TABLE
-- =====================================================
CREATE TABLE user_exercise_progress (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    lesson_id BIGINT NOT NULL,
    exercise_id BIGINT NOT NULL,
    
    -- Progress Tracking
    status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED') DEFAULT 'NOT_STARTED',
    completed_questions INT DEFAULT 0,
    total_questions INT DEFAULT 0,
    completion_percentage DECIMAL(5,2) DEFAULT 0.00,
    
    -- Scoring
    score INT DEFAULT 0,
    max_score INT DEFAULT 0,
    score_percentage DECIMAL(5,2) DEFAULT 0.00,
    is_passed BOOLEAN DEFAULT FALSE,
    
    -- Time Tracking
    time_spent INT DEFAULT 0, -- seconds
    started_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    
    -- Attempts
    attempt_count INT DEFAULT 0,
    best_score INT DEFAULT 0,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_exercise (user_id, exercise_id),
    INDEX idx_user_exercise_progress (user_id, exercise_id),
    INDEX idx_lesson_exercise_progress (lesson_id, exercise_id)
);

-- =====================================================
-- 7. USER QUESTION ANSWERS TABLE
-- =====================================================
CREATE TABLE user_question_answers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    exercise_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    
    -- Answer Details
    selected_answer CHAR(1), -- A, B, C, D, E
    selected_answer_text TEXT, -- For fill-in-the-blank
    is_correct BOOLEAN DEFAULT FALSE,
    points_earned INT DEFAULT 0,
    
    -- Timing
    time_spent INT DEFAULT 0, -- seconds
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Attempts (for practice mode)
    attempt_number INT DEFAULT 1,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    
    INDEX idx_user_answers (user_id, exercise_id),
    INDEX idx_question_answers (question_id),
    INDEX idx_answered_at (answered_at)
);

-- =====================================================
-- 8. MEDIA FILES TABLE (for managing images/audio)
-- =====================================================
CREATE TABLE media_files (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- File Information
    file_name VARCHAR(255) NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_type ENUM('IMAGE', 'AUDIO', 'VIDEO', 'DOCUMENT') NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    file_size BIGINT NOT NULL, -- bytes
    
    -- Image Specific
    width INT DEFAULT 0,
    height INT DEFAULT 0,
    
    -- Audio/Video Specific
    duration INT DEFAULT 0, -- seconds
    
    -- Usage Tracking
    usage_type ENUM('QUESTION_IMAGE', 'QUESTION_AUDIO', 'EXERCISE_CONTEXT', 'LESSON_THUMBNAIL', 'USER_AVATAR') NOT NULL,
    reference_id BIGINT, -- ID of the question, exercise, lesson, or user
    reference_type ENUM('QUESTION', 'EXERCISE', 'LESSON', 'USER') NOT NULL,
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_file_type (file_type),
    INDEX idx_usage_type (usage_type),
    INDEX idx_reference (reference_type, reference_id)
);

-- =====================================================
-- 9. USER ACHIEVEMENTS TABLE
-- =====================================================
CREATE TABLE user_achievements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    
    -- Achievement Details
    achievement_type ENUM('STREAK', 'SCORE', 'COMPLETION', 'SPEED', 'ACCURACY') NOT NULL,
    achievement_name VARCHAR(100) NOT NULL,
    achievement_description TEXT,
    achievement_icon VARCHAR(100),
    
    -- Achievement Data
    target_value INT NOT NULL,
    current_value INT DEFAULT 0,
    is_completed BOOLEAN DEFAULT FALSE,
    
    -- Timestamps
    earned_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_achievements (user_id),
    INDEX idx_achievement_type (achievement_type)
);

-- =====================================================
-- 10. LESSON CATEGORIES TABLE
-- =====================================================
CREATE TABLE lesson_categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    
    -- Category Information
    name VARCHAR(100) NOT NULL,
    description TEXT,
    color_code VARCHAR(7) DEFAULT '#007bff',
    icon VARCHAR(50),
    
    -- Order and Status
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_display_order (display_order)
);

-- =====================================================
-- 11. LESSON CATEGORY MAPPING TABLE
-- =====================================================
CREATE TABLE lesson_category_mapping (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lesson_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES lesson_categories(id) ON DELETE CASCADE,
    UNIQUE KEY unique_lesson_category (lesson_id, category_id)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- Insert sample lesson categories
INSERT INTO lesson_categories (name, description, color_code, icon, display_order) VALUES
('Listening Fundamentals', 'Basic listening skills for TOEIC', '#28a745', 'headphones', 1),
('Reading Comprehension', 'Reading skills and strategies', '#007bff', 'book-open', 2),
('Vocabulary Building', 'Essential TOEIC vocabulary', '#ffc107', 'spell-check', 3),
('Grammar Practice', 'Grammar rules and exercises', '#dc3545', 'grammar', 4),
('Test Simulation', 'Full TOEIC practice tests', '#6f42c1', 'test', 5);

-- Insert sample users
INSERT INTO users (username, email, password, first_name, last_name, level) VALUES
('john_doe', 'john@example.com', '$2a$10$example_hashed_password', 'John', 'Doe', 'BEGINNER'),
('jane_smith', 'jane@example.com', '$2a$10$example_hashed_password', 'Jane', 'Smith', 'INTERMEDIATE'),
('admin_user', 'admin@leenglish.com', '$2a$10$example_hashed_password', 'Admin', 'User', 'ADVANCED');

-- Insert sample lessons
INSERT INTO lessons (user_id, title, description, lesson_type, difficulty, toeic_part, target_score, estimated_duration, lesson_order) VALUES
(1, 'Introduction to TOEIC Listening Part 1', 'Learn to describe pictures effectively', 'LISTENING', 'EASY', 'PART1', 80, 30, 1),
(1, 'TOEIC Listening Part 2: Questions & Responses', 'Master question-response patterns', 'LISTENING', 'EASY', 'PART2', 85, 25, 2),
(1, 'Reading Comprehension: Single Passages', 'Understand single passage texts', 'READING', 'MEDIUM', 'PART7', 75, 45, 3);

-- Insert sample exercises
INSERT INTO exercises (lesson_id, title, description, exercise_type, toeic_part, skill_focus, instructions, total_questions, exercise_order) VALUES
(1, 'Picture Description Practice', 'Practice describing various workplace scenarios', 'SINGLE_CHOICE', 'PART1', 'LISTENING', 'Listen to the audio and choose the best description for each picture.', 5, 1),
(1, 'Advanced Picture Analysis', 'Analyze complex picture scenarios', 'SINGLE_CHOICE', 'PART1', 'LISTENING', 'Listen carefully and select the most accurate description.', 3, 2),
(2, 'Question-Response Basics', 'Learn basic question-response patterns', 'SINGLE_CHOICE', 'PART2', 'LISTENING', 'Choose the best response to each question or statement.', 8, 1);

-- Insert sample questions with image and audio
INSERT INTO questions (exercise_id, question_text, question_type, option_a, option_b, option_c, option_d, correct_answer, explanation, toeic_part, skill_tested, points, question_order, question_image_url, question_audio_url) VALUES
(1, 'What do you see in this picture?', 'SINGLE_CHOICE', 'A man is reading a book', 'A woman is typing on a computer', 'People are having a meeting', 'Someone is making a phone call', 'B', 'The image clearly shows a woman working at her computer in an office setting.', 'PART1', 'LISTENING', 1, 1, '/images/questions/office_woman_computer.jpg', '/audio/questions/part1_q1.mp3'),

(1, 'Describe the main activity in the image.', 'SINGLE_CHOICE', 'Cooking in the kitchen', 'Working in the garden', 'Shopping at the market', 'Exercising at the gym', 'C', 'The picture shows people shopping at an outdoor market with various vendors.', 'PART1', 'LISTENING', 1, 2, '/images/questions/outdoor_market.jpg', '/audio/questions/part1_q2.mp3'),

(2, 'When will the meeting start?', 'SINGLE_CHOICE', 'At 3 o\'clock', 'In the conference room', 'With the manager', 'Yes, I will attend', 'A', 'When asking about time, the response should indicate a specific time.', 'PART2', 'LISTENING', 1, 1, NULL, '/audio/questions/part2_q1.mp3'),

(2, 'Who is responsible for this project?', 'SINGLE_CHOICE', 'It\'s very important', 'Sarah from marketing', 'Next month', 'In the office', 'B', 'The question asks for a person, so the answer should identify who is responsible.', 'PART2', 'LISTENING', 1, 2, NULL, '/audio/questions/part2_q2.mp3');

-- Update exercise question counts
UPDATE exercises SET total_questions = (SELECT COUNT(*) FROM questions WHERE questions.exercise_id = exercises.id);

-- Update lesson exercise counts  
UPDATE lessons SET total_exercises = (SELECT COUNT(*) FROM exercises WHERE exercises.lesson_id = lessons.id);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Additional indexes for better performance
CREATE INDEX idx_user_lesson_status ON user_lesson_progress(user_id, status);
CREATE INDEX idx_user_exercise_status ON user_exercise_progress(user_id, status);
CREATE INDEX idx_question_difficulty ON questions(difficulty, toeic_part);
CREATE INDEX idx_exercise_type_part ON exercises(exercise_type, toeic_part);
CREATE INDEX idx_user_answers_exercise ON user_question_answers(user_id, exercise_id, question_id);

-- =====================================================
-- VIEWS FOR COMMON QUERIES
-- =====================================================

-- View for user progress summary
CREATE VIEW user_progress_summary AS
SELECT 
    u.id as user_id,
    u.username,
    u.level,
    COUNT(DISTINCT ulp.lesson_id) as total_lessons,
    COUNT(DISTINCT CASE WHEN ulp.status = 'COMPLETED' THEN ulp.lesson_id END) as completed_lessons,
    COALESCE(AVG(ulp.score_percentage), 0) as avg_score_percentage,
    SUM(ulp.time_spent) as total_time_spent
FROM users u
LEFT JOIN user_lesson_progress ulp ON u.id = ulp.user_id
GROUP BY u.id, u.username, u.level;

-- View for lesson details with progress
CREATE VIEW lesson_details_with_progress AS
SELECT 
    l.*,
    COUNT(DISTINCT e.id) as exercise_count,
    COUNT(DISTINCT q.id) as question_count,
    COALESCE(ulp.status, 'NOT_STARTED') as user_status,
    COALESCE(ulp.completion_percentage, 0) as user_completion_percentage,
    COALESCE(ulp.score_percentage, 0) as user_score_percentage
FROM lessons l
LEFT JOIN exercises e ON l.id = e.lesson_id
LEFT JOIN questions q ON e.id = q.exercise_id
LEFT JOIN user_lesson_progress ulp ON l.id = ulp.lesson_id
GROUP BY l.id, ulp.status, ulp.completion_percentage, ulp.score_percentage;

COMMIT;
