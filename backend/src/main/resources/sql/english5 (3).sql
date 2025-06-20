-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 20, 2025 at 10:34 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `english5`
--

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` bigint(20) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `lesson_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `content`, `created_at`, `lesson_id`, `user_id`) VALUES
(1, 'Great introduction to greetings! Very helpful for beginners.', '2025-06-01 09:30:00.000000', 1, 2),
(2, 'Clear explanations and good examples. Easy to follow.', '2025-06-10 11:25:00.000000', 1, 3),
(3, 'The present simple explanations were excellent. Would love more examples.', '2025-06-05 10:25:00.000000', 2, 4),
(4, 'This lesson helped me understand verb conjugations much better.', '2025-06-02 10:35:00.000000', 2, 2),
(5, 'As a collaborator, I find this business lesson very comprehensive and well-structured.', '2025-06-10 15:00:00.000000', 9, 6),
(6, 'Advanced grammar is challenging but the explanations make it manageable.', '2025-06-01 21:10:00.000000', 8, 7),
(7, 'The irregular verbs section could use more practice exercises.', '2025-06-13 16:00:00.000000', 4, 3),
(8, 'Conditional sentences are tricky, but this lesson breaks them down well.', '2025-06-14 16:50:00.000000', 7, 4),
(9, 'Excellent advanced conversation techniques. Very practical for real-world use.', '2025-06-12 19:20:00.000000', 10, 7),
(10, 'Numbers and time are fundamental. This lesson covers everything I needed.', '2025-06-15 14:20:00.000000', 3, 2);

-- --------------------------------------------------------

--
-- Table structure for table `exercises`
--

CREATE TABLE `exercises` (
  `id` bigint(20) NOT NULL,
  `audio_url` varchar(500) DEFAULT NULL,
  `correct_answer` varchar(500) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `difficulty_level` varchar(255) DEFAULT NULL,
  `explanation` varchar(1000) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `is_active` bit(1) NOT NULL,
  `is_premium` bit(1) NOT NULL,
  `lesson_id` bigint(20) DEFAULT NULL,
  `level` varchar(5) DEFAULT NULL,
  `options` varchar(2000) DEFAULT NULL,
  `order_index` int(11) DEFAULT NULL,
  `points` int(11) DEFAULT NULL,
  `question` varchar(2000) DEFAULT NULL,
  `time_limit_seconds` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `type` varchar(100) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `difficulty` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `exercises`
--

INSERT INTO `exercises` (`id`, `audio_url`, `correct_answer`, `created_at`, `description`, `difficulty_level`, `explanation`, `image_url`, `is_active`, `is_premium`, `lesson_id`, `level`, `options`, `order_index`, `points`, `question`, `time_limit_seconds`, `title`, `type`, `updated_at`, `difficulty`) VALUES
(1, NULL, 'Good morning', '2025-06-16 18:23:39.000000', 'Choose the appropriate greeting for different times of day', 'BEGINNER', 'Good morning is used from sunrise until noon', NULL, b'1', b'0', 1, 'A1', '[\"Good morning\",\"Good afternoon\",\"Good evening\",\"Good night\"]', 1, 10, 'What greeting do you use at 9:00 AM?', 30, 'Greeting Selection', 'MULTIPLE_CHOICE', '2025-06-16 18:23:39.000000', NULL),
(2, NULL, 'is', '2025-06-16 18:23:39.000000', 'Complete the self-introduction', 'BEGINNER', 'Use \"is\" with singular subjects like \"name\"', NULL, b'1', b'0', 1, 'A1', NULL, 2, 5, 'My name ___ John.', 20, 'Introduction Practice', 'FILL_BLANK', '2025-06-16 18:23:39.000000', NULL),
(3, NULL, 'is', '2025-06-16 18:23:39.000000', 'Choose the correct form of \"be\"', 'BEGINNER', 'Use \"is\" with third person singular (he/she/it)', NULL, b'1', b'0', 2, 'A1', '[\"is\",\"am\",\"are\",\"be\"]', 1, 10, 'She ___ a teacher.', 25, 'Present Simple - Be Verb', 'MULTIPLE_CHOICE', '2025-06-16 18:23:39.000000', NULL),
(4, NULL, 'works', '2025-06-16 18:23:39.000000', 'Fill in the correct verb form', 'BEGINNER', 'Add \"-s\" to verbs with third person singular subjects', NULL, b'1', b'0', 2, 'A1', NULL, 2, 10, 'He ___ (work) in an office.', 30, 'Present Simple - Regular Verbs', 'FILL_BLANK', '2025-06-16 18:23:39.000000', NULL),
(5, NULL, 'twenty-five', '2025-06-16 18:23:39.000000', 'Write the number in words', 'BEGINNER', 'Hyphenate numbers from twenty-one to ninety-nine', NULL, b'1', b'0', 3, 'A1', NULL, 1, 10, 'Write \"25\" in words', 45, 'Number Recognition', 'TEXT_INPUT', '2025-06-16 18:23:39.000000', NULL),
(6, NULL, 'half past three', '2025-06-16 18:23:39.000000', 'What time is shown?', 'BEGINNER', '30 minutes past the hour is \"half past\"', NULL, b'1', b'0', 3, 'A1', NULL, 2, 15, 'Express 3:30 in words', 60, 'Time Telling', 'TEXT_INPUT', '2025-06-16 18:23:39.000000', NULL),
(7, NULL, 'went', '2025-06-16 18:23:39.000000', 'Choose the correct past form', 'INTERMEDIATE', '\"Go\" is irregular - past form is \"went\"', NULL, b'1', b'0', 4, 'A2', '[\"go\",\"went\",\"going\",\"goes\"]', 1, 15, 'Yesterday I ___ to the store.', 30, 'Past Simple Formation', 'MULTIPLE_CHOICE', '2025-06-16 18:23:39.000000', NULL),
(8, NULL, 'Did you visit Paris last year?', '2025-06-16 18:23:39.000000', 'Form a past simple question', 'INTERMEDIATE', 'Use \"Did\" + base form for past simple questions', NULL, b'1', b'0', 4, 'A2', NULL, 2, 20, 'Transform: You visited Paris last year.', 60, 'Past Simple Questions', 'TEXT_INPUT', '2025-06-16 18:23:39.000000', NULL),
(9, NULL, 'will', '2025-06-16 18:23:39.000000', 'Complete the conditional sentence', 'ADVANCED', 'First conditional uses \"will\" in the main clause', NULL, b'1', b'1', 7, 'B2', '[\"will\",\"would\",\"am\",\"do\"]', 1, 25, 'If it rains, I ___ stay home.', 45, 'First Conditional', 'MULTIPLE_CHOICE', '2025-06-16 18:23:39.000000', NULL),
(10, NULL, 'were', '2025-06-16 18:23:39.000000', 'Choose the correct form', 'ADVANCED', 'Use \"were\" for all persons in second conditional', NULL, b'1', b'1', 7, 'B2', '[\"am\",\"was\",\"were\",\"be\"]', 2, 30, 'If I ___ you, I would apologize.', 60, 'Second Conditional', 'MULTIPLE_CHOICE', '2025-06-16 18:23:39.000000', NULL),
(11, NULL, 'Best regards', '2025-06-16 18:23:39.000000', 'Choose the appropriate business phrase', 'ADVANCED', '\"Best regards\" is professional and widely accepted', NULL, b'1', b'1', 9, 'C1', '[\"Love\",\"Cheers\",\"Best regards\",\"See ya\"]', 1, 20, 'How do you end a formal business email?', 30, 'Business Email', 'MULTIPLE_CHOICE', '2025-06-16 18:23:39.000000', NULL),
(12, NULL, 'schedule', '2025-06-16 18:23:39.000000', 'Complete the business sentence', 'ADVANCED', '\"Schedule\" means to plan or arrange a meeting', NULL, b'1', b'1', 9, 'C1', NULL, 2, 25, 'Let us ___ the meeting for next Monday.', 45, 'Meeting Vocabulary', 'FILL_BLANK', '2025-06-16 18:23:39.000000', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `exercise_question`
--

CREATE TABLE `exercise_question` (
  `id` bigint(20) NOT NULL,
  `audio_url` varchar(500) DEFAULT NULL,
  `correct_answer` text NOT NULL,
  `exercise_id` bigint(20) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `options` longtext DEFAULT NULL,
  `question_text` text NOT NULL,
  `type` varchar(100) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `order_index` int(11) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `exercise_question`
--

INSERT INTO `exercise_question` (`id`, `audio_url`, `correct_answer`, `exercise_id`, `image_url`, `options`, `question_text`, `type`, `created_at`, `order_index`, `updated_at`) VALUES
(1, 'https://example.com/audio/greeting1.mp3', 'Good morning', 1, NULL, '[\"Good morning\",\"Good afternoon\",\"Good evening\",\"Good night\"]', 'What greeting do you use at 9:00 AM?', 'MULTIPLE_CHOICE', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000'),
(2, NULL, 'is', 2, NULL, NULL, 'My name ___ John.', 'FILL_BLANK', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000'),
(3, NULL, 'is', 3, NULL, '[\"is\",\"am\",\"are\",\"be\"]', 'She ___ a teacher.', 'MULTIPLE_CHOICE', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000'),
(4, NULL, 'works', 4, NULL, NULL, 'He ___ (work) in an office.', 'FILL_BLANK', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000'),
(5, NULL, 'twenty-five', 5, NULL, NULL, 'Write \"25\" in words', 'TEXT_INPUT', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000'),
(6, 'https://example.com/audio/time1.mp3', 'half past three', 6, NULL, NULL, 'Express 3:30 in words', 'TEXT_INPUT', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000'),
(7, NULL, 'went', 7, NULL, '[\"go\",\"went\",\"going\",\"goes\"]', 'Yesterday I ___ to the store.', 'MULTIPLE_CHOICE', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000'),
(8, NULL, 'Did you visit Paris last year?', 8, NULL, NULL, 'Transform: You visited Paris last year.', 'TEXT_INPUT', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000'),
(9, NULL, 'will', 9, NULL, '[\"will\",\"would\",\"am\",\"do\"]', 'If it rains, I ___ stay home.', 'MULTIPLE_CHOICE', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000'),
(10, NULL, 'were', 10, NULL, '[\"am\",\"was\",\"were\",\"be\"]', 'If I ___ you, I would apologize.', 'MULTIPLE_CHOICE', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000'),
(11, NULL, 'Best regards', 11, NULL, '[\"Love\",\"Cheers\",\"Best regards\",\"See ya\"]', 'How do you end a formal business email?', 'MULTIPLE_CHOICE', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000'),
(12, NULL, 'schedule', 12, NULL, NULL, 'Let us ___ the meeting for next Monday.', 'FILL_BLANK', '2025-06-20 15:30:41.000000', 1, '2025-06-20 15:30:41.000000');

-- --------------------------------------------------------

--
-- Table structure for table `flashcards`
--

CREATE TABLE `flashcards` (
  `id` bigint(20) NOT NULL,
  `audio_url` varchar(255) DEFAULT NULL,
  `back_text` text NOT NULL,
  `category` varchar(255) NOT NULL,
  `correct_count` int(11) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `explanation` text DEFAULT NULL,
  `front_text` varchar(255) NOT NULL,
  `hint` text DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `incorrect_count` int(11) DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `is_public` bit(1) DEFAULT NULL,
  `tags` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `view_count` int(11) DEFAULT NULL,
  `created_by` bigint(20) DEFAULT NULL,
  `flashcard_set_id` bigint(20) DEFAULT NULL,
  `definition` varchar(255) DEFAULT NULL,
  `example` varchar(255) DEFAULT NULL,
  `level` varchar(255) DEFAULT NULL,
  `term` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `flashcards`
--

INSERT INTO `flashcards` (`id`, `audio_url`, `back_text`, `category`, `correct_count`, `created_at`, `explanation`, `front_text`, `hint`, `image_url`, `incorrect_count`, `is_active`, `is_public`, `tags`, `updated_at`, `view_count`, `created_by`, `flashcard_set_id`, `definition`, `example`, `level`, `term`) VALUES
(1, 'https://example.com/audio/hello.mp3', 'A common greeting', 'GREETINGS', 15, '2025-06-16 18:26:00.000000', 'Used to greet someone when you meet them', 'Hello', 'What do you say when you meet someone?', NULL, 3, b'1', b'1', 'greeting,basic,common', '2025-06-16 18:26:00.000000', 45, 1, 1, NULL, NULL, NULL, NULL),
(2, 'https://example.com/audio/thankyou.mp3', 'Expression of gratitude', 'GRATITUDE', 12, '2025-06-16 18:26:00.000000', 'Used to show appreciation for something someone did', 'Thank you', 'What do you say when someone helps you?', NULL, 2, b'1', b'1', 'gratitude,polite,basic', '2025-06-16 18:26:00.000000', 38, 1, 1, NULL, NULL, NULL, NULL),
(3, 'https://example.com/audio/water.mp3', 'H2O - essential liquid for life', 'DRINKS', 20, '2025-06-16 18:26:00.000000', 'Clear, colorless liquid that all living things need', 'Water', 'What do you drink when thirsty?', NULL, 1, b'1', b'1', 'drink,essential,basic', '2025-06-16 18:26:00.000000', 52, 1, 1, NULL, NULL, NULL, NULL),
(4, 'https://example.com/audio/house.mp3', 'A building where people live', 'HOUSING', 18, '2025-06-16 18:26:00.000000', 'A place where a family lives', 'House', 'Where do people live?', NULL, 4, b'1', b'1', 'home,building,basic', '2025-06-16 18:26:00.000000', 41, 1, 1, NULL, NULL, NULL, NULL),
(5, NULL, 'Tense for habits and facts', 'TENSES', 25, '2025-06-16 18:26:00.000000', 'Used for things that happen regularly or are always true', 'Present Simple', 'What tense describes daily routines?', NULL, 5, b'1', b'1', 'grammar,tense,basic', '2025-06-16 18:26:00.000000', 67, 1, 2, NULL, NULL, NULL, NULL),
(6, NULL, 'Definite article in English', 'ARTICLES', 22, '2025-06-16 18:26:00.000000', 'Used before specific nouns that both speaker and listener know', 'Article \"The\"', 'Which article goes before specific things?', NULL, 8, b'1', b'1', 'grammar,article,definite', '2025-06-16 18:26:00.000000', 58, 1, 2, NULL, NULL, NULL, NULL),
(7, NULL, 'Adding -s to make nouns plural', 'NOUNS', 19, '2025-06-16 18:26:00.000000', 'Most nouns add -s to show more than one', 'Plural -s', 'How do you make most nouns plural?', NULL, 3, b'1', b'1', 'grammar,plural,basic', '2025-06-16 18:26:00.000000', 44, 1, 2, NULL, NULL, NULL, NULL),
(8, 'https://example.com/audio/meeting.mp3', 'Gathering of people for business discussion', 'BUSINESS_EVENTS', 8, '2025-06-16 18:26:00.000000', 'A planned gathering where people discuss business matters', 'Meeting', 'What do you call a business gathering?', NULL, 2, b'1', b'1', 'business,meeting,formal', '2025-06-16 18:26:00.000000', 23, 6, 3, NULL, NULL, NULL, NULL),
(9, NULL, 'Final date when something must be completed', 'TIME_MANAGEMENT', 12, '2025-06-16 18:26:00.000000', 'The last possible time to finish a task or project', 'Deadline', 'What do you call the final date for completion?', NULL, 4, b'1', b'1', 'business,time,pressure', '2025-06-16 18:26:00.000000', 31, 6, 3, NULL, NULL, NULL, NULL),
(10, NULL, 'Total income generated by business', 'FINANCE', 6, '2025-06-16 18:26:00.000000', 'The total amount of money a company earns from sales', 'Revenue', 'What do you call total business income?', NULL, 1, b'1', b'1', 'business,money,finance', '2025-06-16 18:26:00.000000', 18, 6, 3, NULL, NULL, NULL, NULL),
(11, NULL, 'Search for information', 'RESEARCH', 14, '2025-06-16 18:26:00.000000', 'To search for information in a book, database, or online', 'Look up', 'What do you do when you search for information?', NULL, 6, b'1', b'1', 'phrasal,search,information', '2025-06-16 18:26:00.000000', 35, 1, 4, NULL, NULL, NULL, NULL),
(12, NULL, 'Stop trying / quit', 'ACTIONS', 16, '2025-06-16 18:26:00.000000', 'To stop trying to do something because it is too difficult', 'Give up', 'What do you do when you stop trying?', NULL, 3, b'1', b'1', 'phrasal,quit,stop', '2025-06-16 18:26:00.000000', 42, 1, 4, NULL, NULL, NULL, NULL),
(13, NULL, 'Postpone / delay', 'TIME', 11, '2025-06-16 18:26:00.000000', 'To delay doing something until a later time', 'Put off', 'What do you do when you delay something?', NULL, 7, b'1', b'1', 'phrasal,delay,postpone', '2025-06-16 18:26:00.000000', 28, 1, 4, NULL, NULL, NULL, NULL),
(14, 'https://example.com/audio/howareyou.mp3', 'Common way to ask about someone wellbeing', 'GREETINGS', 23, '2025-06-16 18:26:00.000000', 'A polite question to ask about someones current state', 'How are you?', 'What question asks about someones wellbeing?', NULL, 2, b'1', b'1', 'conversation,greeting,polite', '2025-06-16 18:26:00.000000', 56, 6, 5, NULL, NULL, NULL, NULL),
(15, 'https://example.com/audio/excuseme.mp3', 'Polite way to get attention or apologize', 'POLITENESS', 18, '2025-06-16 18:26:00.000000', 'Used to politely interrupt or get someones attention', 'Excuse me', 'What do you say to politely get attention?', NULL, 1, b'1', b'1', 'conversation,polite,attention', '2025-06-16 18:26:00.000000', 41, 6, 5, NULL, NULL, NULL, NULL),
(16, NULL, 'Extremely careful and precise', 'ADJECTIVES', 5, '2025-06-16 18:26:00.000000', 'Showing great attention to detail; very careful and precise', 'Meticulous', 'What word describes extreme attention to detail?', NULL, 3, b'1', b'1', 'advanced,careful,precise', '2025-06-16 18:26:00.000000', 12, 1, 6, NULL, NULL, NULL, NULL),
(17, NULL, 'Never done or known before', 'ADJECTIVES', 7, '2025-06-16 18:26:00.000000', 'Something that has never happened or existed before', 'Unprecedented', 'What describes something never seen before?', NULL, 2, b'1', b'1', 'advanced,new,unique', '2025-06-16 18:26:00.000000', 15, 1, 6, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `flashcard_sets`
--

CREATE TABLE `flashcard_sets` (
  `id` bigint(20) NOT NULL,
  `category` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `is_public` bit(1) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `created_by` bigint(20) DEFAULT NULL,
  `active` bit(1) DEFAULT NULL,
  `premium` bit(1) DEFAULT NULL,
  `difficulty_level` varchar(255) DEFAULT NULL,
  `estimated_time_minutes` int(11) DEFAULT NULL,
  `is_premium` bit(1) DEFAULT NULL,
  `tags` varchar(255) DEFAULT NULL,
  `view_count` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `flashcard_sets`
--

INSERT INTO `flashcard_sets` (`id`, `category`, `created_at`, `description`, `is_active`, `is_public`, `name`, `updated_at`, `created_by`, `active`, `premium`, `difficulty_level`, `estimated_time_minutes`, `is_premium`, `tags`, `view_count`) VALUES
(1, 'VOCABULARY', '2025-06-16 18:23:56.000000', 'Basic English words every beginner should know', b'1', b'1', 'Essential Vocabulary A1', '2025-06-16 18:23:56.000000', 1, b'1', b'0', 'BEGINNER', 15, b'0', 'basic,vocabulary,essential', 150),
(2, 'GRAMMAR', '2025-06-16 18:23:56.000000', 'Key grammar concepts and rules', b'1', b'1', 'Grammar Fundamentals', '2025-06-16 18:23:56.000000', 1, b'1', b'0', 'BEGINNER', 20, b'0', 'grammar,fundamental,structure', 120),
(3, 'BUSINESS', '2025-06-16 18:23:56.000000', 'Important business terms and phrases', b'1', b'1', 'Business English Essentials', '2025-06-16 18:23:56.000000', 6, b'1', b'1', 'ADVANCED', 30, b'1', 'business,professional,workplace', 80),
(4, 'PHRASAL_VERBS', '2025-06-16 18:23:56.000000', 'Common phrasal verbs with examples', b'1', b'1', 'Phrasal Verbs Collection', '2025-06-16 18:23:56.000000', 1, b'1', b'1', 'INTERMEDIATE', 25, b'1', 'phrasal,verbs,advanced', 95),
(5, 'CONVERSATION', '2025-06-16 18:23:56.000000', 'Phrases for daily communication', b'1', b'1', 'Everyday Conversations', '2025-06-16 18:23:56.000000', 6, b'1', b'0', 'BEGINNER', 18, b'0', 'conversation,daily,communication', 140),
(6, 'VOCABULARY', '2025-06-16 18:23:56.000000', 'Sophisticated vocabulary for advanced learners', b'1', b'1', 'Advanced Vocabulary C1', '2025-06-16 18:23:56.000000', 1, b'1', b'1', 'ADVANCED', 35, b'1', 'advanced,sophisticated,vocabulary', 45);

-- --------------------------------------------------------

--
-- Table structure for table `lessons`
--

CREATE TABLE `lessons` (
  `id` bigint(20) NOT NULL,
  `audio_url` varchar(500) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `is_active` bit(1) NOT NULL,
  `is_premium` bit(1) NOT NULL,
  `level` varchar(10) DEFAULT NULL,
  `order_index` int(11) DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `difficulty` varchar(50) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `lessons`
--

INSERT INTO `lessons` (`id`, `audio_url`, `content`, `created_at`, `description`, `image_url`, `is_active`, `is_premium`, `level`, `order_index`, `title`, `updated_at`, `difficulty`, `duration`, `type`) VALUES
(1, 'https://example.com/audio/greetings.mp3', 'Hello, Hi, Good morning, Good afternoon, Good evening. My name is... Nice to meet you...', '2025-06-16 18:22:49.000000', 'Learn essential greetings and how to introduce yourself in English', 'https://example.com/images/greetings.jpg', b'1', b'0', 'A1', 1, 'Basic Greetings and Introductions', '2025-06-16 18:22:49.000000', NULL, NULL, NULL),
(2, 'https://example.com/audio/present-simple.mp3', 'I am, You are, He/She/It is, We are, They are. I work, You work, He works...', '2025-06-16 18:22:49.000000', 'Understanding and using present simple tense in everyday situations', 'https://example.com/images/present-simple.jpg', b'1', b'0', 'A1', 2, 'Present Simple Tense', '2025-06-16 18:22:49.000000', NULL, NULL, NULL),
(3, 'https://example.com/audio/numbers-time.mp3', 'One, two, three... What time is it? It is 3 o clock. Today is Monday...', '2025-06-16 18:22:49.000000', 'Learn numbers, dates, and how to tell time in English', 'https://example.com/images/numbers-time.jpg', b'1', b'0', 'A1', 3, 'Numbers and Time', '2025-06-16 18:22:49.000000', NULL, NULL, NULL),
(4, 'https://example.com/audio/past-simple.mp3', 'I was, You were, He/She/It was, We were, They were. I worked, You worked, He worked...', '2025-06-16 18:22:49.000000', 'Learn to talk about past events and experiences', 'https://example.com/images/past-simple.jpg', b'1', b'0', 'A2', 4, 'Past Simple Tense', '2025-06-16 18:22:49.000000', NULL, NULL, NULL),
(5, 'https://example.com/audio/food-restaurants.mp3', 'Menu, order, delicious, bill, tip. I would like... Could I have... The check, please.', '2025-06-16 18:22:49.000000', 'Vocabulary and phrases for ordering food and dining out', 'https://example.com/images/food-restaurants.jpg', b'1', b'0', 'A2', 5, 'Food and Restaurants', '2025-06-16 18:22:49.000000', NULL, NULL, NULL),
(6, 'https://example.com/audio/future-tense.mp3', 'I will, You will, He will... I am going to... Tomorrow I will visit...', '2025-06-16 18:22:49.000000', 'Express future intentions and make plans', 'https://example.com/images/future-tense.jpg', b'1', b'0', 'B1', 6, 'Future Tense and Plans', '2025-06-16 18:22:49.000000', NULL, NULL, NULL),
(7, 'https://example.com/audio/conditionals.mp3', 'If I have time, I will call you. If I were rich, I would travel. If I had known...', '2025-06-16 18:22:49.000000', 'Understanding if-clauses and conditional structures', 'https://example.com/images/conditionals.jpg', b'1', b'1', 'B2', 7, 'Conditional Sentences', '2025-06-16 18:22:49.000000', NULL, NULL, NULL),
(8, 'https://example.com/audio/advanced-grammar.mp3', 'Reported speech, passive voice, relative clauses, subjunctive mood...', '2025-06-16 18:22:49.000000', 'Complex grammar for advanced learners', 'https://example.com/images/advanced-grammar.jpg', b'1', b'1', 'B2', 8, 'Advanced Grammar Structures', '2025-06-16 18:22:49.000000', NULL, NULL, NULL),
(9, 'https://example.com/audio/business-comm.mp3', 'Meetings, presentations, negotiations, emails, reports, proposals...', '2025-06-16 18:22:49.000000', 'Professional English for workplace situations', 'https://example.com/images/business-comm.jpg', b'1', b'1', 'C1', 9, 'Business Communication', '2025-06-16 18:22:49.000000', NULL, NULL, NULL),
(10, 'https://example.com/audio/advanced-conversation.mp3', 'Idioms, phrasal verbs, advanced expressions, debate skills, discussion techniques...', '2025-06-16 18:22:49.000000', 'Fluent conversation techniques and idioms', 'https://example.com/images/advanced-conversation.jpg', b'1', b'1', 'C1', 10, 'Advanced Conversation Skills', '2025-06-16 18:22:49.000000', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `membership_plans`
--

CREATE TABLE `membership_plans` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `duration_in_days` int(11) NOT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `membership_type` enum('MONTHLY','YEARLY','LIFETIME') NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `access_audio_features` bit(1) DEFAULT NULL,
  `access_premium_content` bit(1) DEFAULT NULL,
  `currency` varchar(255) DEFAULT NULL,
  `download_offline` bit(1) DEFAULT NULL,
  `duration_days` int(11) DEFAULT NULL,
  `features` text DEFAULT NULL,
  `has_audio_access` bit(1) DEFAULT NULL,
  `has_premium_content` bit(1) DEFAULT NULL,
  `has_progress_tracking` bit(1) DEFAULT NULL,
  `is_popular` bit(1) DEFAULT NULL,
  `max_exercises_per_day` int(11) DEFAULT NULL,
  `max_flashcards_per_set` int(11) DEFAULT NULL,
  `max_lessons_access` int(11) DEFAULT NULL,
  `max_lessons_per_day` int(11) DEFAULT NULL,
  `plan_type` varchar(255) DEFAULT NULL,
  `priority_support` bit(1) DEFAULT NULL,
  `unlimited_flashcards` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `membership_plans`
--

INSERT INTO `membership_plans` (`id`, `created_at`, `description`, `duration_in_days`, `is_active`, `membership_type`, `name`, `price`, `updated_at`, `access_audio_features`, `access_premium_content`, `currency`, `download_offline`, `duration_days`, `features`, `has_audio_access`, `has_premium_content`, `has_progress_tracking`, `is_popular`, `max_exercises_per_day`, `max_flashcards_per_set`, `max_lessons_access`, `max_lessons_per_day`, `plan_type`, `priority_support`, `unlimited_flashcards`) VALUES
(1, '2025-06-16 16:58:28.000000', 'Access to basic English lessons and exercises for 30 days', 30, b'1', '', 'Basic Monthly', 9.99, '2025-06-16 16:58:28.000000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, '2025-06-16 16:58:28.000000', 'Access to standard features including flashcards for 30 days', 30, b'1', '', 'Standard Monthly', 19.99, '2025-06-16 16:58:28.000000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, '2025-06-16 16:58:28.000000', 'Full access to all features including premium content for 30 days', 30, b'1', '', 'Premium Monthly', 29.99, '2025-06-16 16:58:28.000000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, '2025-06-16 16:58:28.000000', 'Enterprise solution with advanced features for 30 days', 30, b'1', '', 'Enterprise Monthly', 49.99, '2025-06-16 16:58:28.000000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, '2025-06-16 16:58:28.000000', 'Access to basic English lessons and exercises for 1 year', 365, b'1', '', 'Basic Yearly', 99.99, '2025-06-16 16:58:28.000000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, '2025-06-16 16:58:28.000000', 'Access to standard features including flashcards for 1 year', 365, b'1', '', 'Standard Yearly', 199.99, '2025-06-16 16:58:28.000000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(7, '2025-06-16 16:58:28.000000', 'Full access to all features including premium content for 1 year', 365, b'1', '', 'Premium Yearly', 299.99, '2025-06-16 16:58:28.000000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(8, '2025-06-16 16:58:28.000000', 'Enterprise solution with advanced features for 1 year', 365, b'1', '', 'Enterprise Yearly', 499.99, '2025-06-16 16:58:28.000000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `mock_tests`
--

CREATE TABLE `mock_tests` (
  `id` bigint(20) NOT NULL,
  `description` text DEFAULT NULL,
  `level` varchar(5) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `mock_tests`
--

INSERT INTO `mock_tests` (`id`, `description`, `level`, `title`) VALUES
(1, 'Comprehensive test for A1 level English proficiency', 'A1', 'A1 Beginner Assessment'),
(2, 'Assessment covering A2 level English skills', 'A2', 'A2 Elementary Test'),
(3, 'Mid-level English proficiency examination', 'B1', 'B1 Intermediate Evaluation'),
(4, 'Advanced intermediate English assessment', 'B2', 'B2 Upper-Intermediate Test'),
(5, 'High-level English proficiency examination', 'C1', 'C1 Advanced Proficiency Test');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `id` bigint(20) NOT NULL,
  `audio_duration` int(11) DEFAULT NULL,
  `correct_answer` varchar(1) NOT NULL,
  `correct_answer_text` text DEFAULT NULL,
  `correct_attempts` int(11) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `difficulty` enum('EASY','BEGINNER','INTERMEDIATE','ADVANCED','EXPERT') DEFAULT NULL,
  `explanation` text DEFAULT NULL,
  `explanation_audio_url` varchar(500) DEFAULT NULL,
  `explanation_image_url` varchar(500) DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `learning_tip` text DEFAULT NULL,
  `option_a` varchar(500) DEFAULT NULL,
  `option_b` varchar(500) DEFAULT NULL,
  `option_c` varchar(500) DEFAULT NULL,
  `option_d` varchar(500) DEFAULT NULL,
  `option_e` varchar(500) DEFAULT NULL,
  `points` int(11) DEFAULT NULL,
  `question_audio_url` varchar(500) DEFAULT NULL,
  `question_image_url` varchar(500) DEFAULT NULL,
  `question_order` int(11) DEFAULT NULL,
  `question_text` text NOT NULL,
  `question_type` enum('LISTENING','READING','VOCABULARY','GRAMMAR','SPEAKING','WRITING','MIXED') NOT NULL,
  `skill_tested` varchar(50) NOT NULL,
  `time_limit` int(11) DEFAULT NULL,
  `toeic_part` enum('PART_1','PART_2','PART_3','PART_4','PART_5','PART_6','PART_7') NOT NULL,
  `total_attempts` int(11) DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL,
  `exercise_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`id`, `audio_duration`, `correct_answer`, `correct_answer_text`, `correct_attempts`, `created_at`, `difficulty`, `explanation`, `explanation_audio_url`, `explanation_image_url`, `is_active`, `learning_tip`, `option_a`, `option_b`, `option_c`, `option_d`, `option_e`, `points`, `question_audio_url`, `question_image_url`, `question_order`, `question_text`, `question_type`, `skill_tested`, `time_limit`, `toeic_part`, `total_attempts`, `updated_at`, `exercise_id`) VALUES
(1, 5, 'A', 'Good morning', 20, '2025-06-20 15:30:41.000000', 'EASY', 'Good morning is used from sunrise until noon (around 12:00 PM)', NULL, NULL, b'1', 'This is a basic greeting that shows respect and politeness', 'Good morning', 'Good afternoon', 'Good evening', 'Good night', NULL, 10, 'https://example.com/audio/greeting1.mp3', NULL, 1, 'What greeting do you use at 9:00 AM?', '', 'Listening Comprehension', 30, 'PART_1', 25, '2025-06-20 15:30:41.000000', 1),
(2, 0, 'i', 'is', 25, '2025-06-20 15:30:41.000000', 'EASY', 'Use \"is\" with singular subjects like \"name\". The correct form is \"My name is John.\"', NULL, NULL, b'1', 'Remember: I am, You are, He/She/It is', NULL, NULL, NULL, NULL, NULL, 5, NULL, NULL, 1, 'My name ___ John.', '', 'Grammar', 20, 'PART_5', 30, '2025-06-20 15:30:41.000000', 2),
(3, 0, 'A', 'is', 35, '2025-06-20 15:30:41.000000', 'EASY', 'Use \"is\" with third person singular (he/she/it)', NULL, NULL, b'1', 'Third person singular always uses \"is\"', 'is', 'am', 'are', 'be', NULL, 10, NULL, NULL, 1, 'She ___ a teacher.', '', 'Grammar', 25, 'PART_5', 40, '2025-06-20 15:30:41.000000', 3),
(4, 0, 'w', 'works', 28, '2025-06-20 15:30:41.000000', 'EASY', 'Add \"-s\" to verbs with third person singular subjects. \"He works in an office.\"', NULL, NULL, b'1', 'Remember to add -s for he/she/it', NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, 1, 'He ___ (work) in an office.', '', 'Grammar', 30, 'PART_5', 35, '2025-06-20 15:30:41.000000', 4),
(5, 0, 't', 'twenty-five', 18, '2025-06-20 15:30:41.000000', 'EASY', 'Hyphenate numbers from twenty-one to ninety-nine', NULL, NULL, b'1', 'Always use hyphens for compound numbers', NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, 1, 'Write \"25\" in words', '', 'Reading Comprehension', 45, 'PART_7', 20, '2025-06-20 15:30:41.000000', 5),
(6, 3, 'h', 'half past three', 19, '2025-06-20 15:30:41.000000', 'EASY', '30 minutes past the hour is \"half past\". Alternative: \"three thirty\"', NULL, NULL, b'1', 'Half past = 30 minutes after the hour', NULL, NULL, NULL, NULL, NULL, 15, 'https://example.com/audio/time1.mp3', NULL, 1, 'Express 3:30 in words', '', 'Listening Comprehension', 60, 'PART_1', 22, '2025-06-20 15:30:41.000000', 6),
(7, 0, 'B', 'went', 40, '2025-06-20 15:30:41.000000', 'INTERMEDIATE', '\"Go\" is irregular - past form is \"went\". \"Yesterday I went to the store.\"', NULL, NULL, b'1', 'Irregular verbs must be memorized', 'go', 'went', 'going', 'goes', NULL, 15, NULL, NULL, 1, 'Yesterday I ___ to the store.', '', 'Grammar', 30, 'PART_5', 45, '2025-06-20 15:30:41.000000', 7),
(8, 0, 'D', 'Did you visit Paris last year?', 25, '2025-06-20 15:30:41.000000', 'INTERMEDIATE', 'Use \"Did\" + base form for past simple questions. The structure is: Did + subject + base verb + object + time?', NULL, NULL, b'1', 'Questions in past simple always use \"did\" + base form', NULL, NULL, NULL, NULL, NULL, 20, NULL, NULL, 1, 'Transform: You visited Paris last year.', '', 'Grammar', 60, 'PART_5', 30, '2025-06-20 15:30:41.000000', 8),
(9, 0, 'A', 'will', 15, '2025-06-20 15:30:41.000000', 'ADVANCED', 'First conditional uses \"will\" in the main clause. Structure: If + present simple, will + base form', NULL, NULL, b'1', 'First conditional = real possibility in future', 'will', 'would', 'am', 'do', NULL, 25, NULL, NULL, 1, 'If it rains, I ___ stay home.', '', 'Grammar', 45, 'PART_5', 20, '2025-06-20 15:30:41.000000', 9),
(10, 0, 'C', 'were', 12, '2025-06-20 15:30:41.000000', 'ADVANCED', 'Use \"were\" for all persons in second conditional. This is subjunctive mood for hypothetical situations.', NULL, NULL, b'1', 'Second conditional = unreal/hypothetical situation', 'am', 'was', 'were', 'be', NULL, 30, NULL, NULL, 1, 'If I ___ you, I would apologize.', '', 'Grammar', 60, 'PART_5', 18, '2025-06-20 15:30:41.000000', 10),
(11, 0, 'C', 'Best regards', 22, '2025-06-20 15:30:41.000000', 'ADVANCED', '\"Best regards\" is professional and widely accepted in business communication', NULL, NULL, b'1', 'Always use formal closings in business emails', 'Love', 'Cheers', 'Best regards', 'See ya', NULL, 20, NULL, NULL, 1, 'How do you end a formal business email?', '', 'Reading Comprehension', 30, 'PART_7', 25, '2025-06-20 15:30:41.000000', 11),
(12, 0, 's', 'schedule', 12, '2025-06-20 15:30:41.000000', 'ADVANCED', '\"Schedule\" means to plan or arrange a meeting at a specific time', NULL, NULL, b'1', 'Common business verbs: schedule, arrange, organize', NULL, NULL, NULL, NULL, NULL, 25, NULL, NULL, 1, 'Let us ___ the meeting for next Monday.', '', 'Grammar', 45, 'PART_5', 15, '2025-06-20 15:30:41.000000', 12);

-- --------------------------------------------------------

--
-- Table structure for table `test_results`
--

CREATE TABLE `test_results` (
  `id` bigint(20) NOT NULL,
  `score` int(11) DEFAULT NULL,
  `taken_at` datetime(6) DEFAULT NULL,
  `mock_test_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `test_results`
--

INSERT INTO `test_results` (`id`, `score`, `taken_at`, `mock_test_id`, `user_id`) VALUES
(45, 85, '2025-06-10 16:00:00.000000', 1, 2),
(46, 92, '2025-06-12 14:30:00.000000', 1, 3),
(47, 78, '2025-06-14 15:00:00.000000', 2, 3),
(48, 98, '2025-06-06 10:00:00.000000', 1, 4),
(49, 95, '2025-06-08 11:00:00.000000', 2, 4),
(50, 88, '2025-06-12 13:00:00.000000', 3, 4),
(51, 91, '2025-05-25 17:00:00.000000', 4, 6),
(52, 87, '2025-06-05 18:30:00.000000', 5, 6),
(53, 72, '2025-05-15 14:00:00.000000', 1, 2),
(54, 65, '2025-04-20 16:30:00.000000', 1, 5),
(55, 58, '2025-03-10 15:15:00.000000', 1, 1),
(56, 85, '2025-06-10 16:00:00.000000', 1, 2),
(57, 92, '2025-06-12 14:30:00.000000', 1, 3),
(58, 78, '2025-06-14 15:00:00.000000', 2, 3),
(59, 98, '2025-06-06 10:00:00.000000', 1, 4),
(60, 95, '2025-06-08 11:00:00.000000', 2, 4),
(61, 88, '2025-06-12 13:00:00.000000', 3, 4),
(62, 91, '2025-05-25 17:00:00.000000', 4, 6),
(63, 87, '2025-06-05 18:30:00.000000', 5, 6),
(64, 72, '2025-05-15 14:00:00.000000', 1, 2),
(65, 65, '2025-04-20 16:30:00.000000', 1, 5),
(66, 58, '2025-03-10 15:15:00.000000', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `is_active` bit(1) NOT NULL,
  `is_premium` bit(1) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `premium_expires_at` datetime(6) DEFAULT NULL,
  `profile_picture_url` varchar(500) DEFAULT NULL,
  `role` enum('USER','COLLABORATOR','ADMIN') NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `username` varchar(50) NOT NULL,
  `country` varchar(50) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('MALE','FEMALE','OTHER') DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `total_score` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `created_at`, `email`, `full_name`, `is_active`, `is_premium`, `last_login`, `password_hash`, `premium_expires_at`, `profile_picture_url`, `role`, `updated_at`, `username`, `country`, `date_of_birth`, `gender`, `phone`, `total_score`) VALUES
(1, '2025-06-16 17:02:58.000000', 'admin@englishback.com', 'System Administrator', b'1', b'1', NULL, '$2a$12$UphTMB.7a00/9KN44NnhC.T/Uhede1rXJ9ym34L2/k3Mq.yI6sZ4C', '2026-06-16 17:02:58.000000', 'https://robohash.org/admin?set=set1&size=200x200', 'ADMIN', '2025-06-16 17:02:58.000000', 'admin', NULL, NULL, NULL, NULL, 0),
(2, '2025-06-16 17:02:58.000000', 'test@example.com', 'Test User', b'1', b'0', NULL, '$2a$12$urj6e0rHs7.3IFYN7xkIMu.eUbXgXnDByOHnQHvnaCpB5WoXtoZYW', NULL, 'https://robohash.org/testuser?set=set2&size=200x200', 'USER', '2025-06-16 17:02:58.000000', 'testuser', NULL, NULL, NULL, NULL, 0),
(3, '2025-06-16 17:02:58.000000', 'john@example.com', 'John Doe', b'1', b'0', NULL, '$2a$10$N.fO7.F2.1bq9A2Kqf9Cue3YYs/Q.RK6XEtzPJ6K8LQGXg.Yy5GZq', NULL, 'https://robohash.org/johndoe?set=set3&size=200x200', 'USER', '2025-06-16 17:02:58.000000', 'john_doe', NULL, NULL, NULL, NULL, 0),
(4, '2025-06-16 17:02:58.000000', 'jane@example.com', 'Jane Smith', b'1', b'1', NULL, '$2a$10$N.fO7.F2.1bq9A2Kqf9Cue3YYs/Q.RK6XEtzPJ6K8LQGXg.Yy5GZq', '2025-12-16 17:02:58.000000', 'https://robohash.org/janesmith?set=set4&size=200x200', 'USER', '2025-06-16 17:02:58.000000', 'jane_smith', NULL, NULL, NULL, NULL, 0),
(5, '2025-06-16 17:02:58.000000', 'mike@example.com', 'Mike Wilson', b'1', b'0', NULL, '$2a$10$N.fO7.F2.1bq9A2Kqf9Cue3YYs/Q.RK6XEtzPJ6K8LQGXg.Yy5GZq', NULL, 'https://robohash.org/mikewilson?set=set1&size=200x200', 'USER', '2025-06-16 17:02:58.000000', 'mike_wilson', NULL, NULL, NULL, NULL, 0),
(6, '2025-06-16 17:02:58.000000', 'sarah@example.com', 'Sarah Jones', b'1', b'0', NULL, '$2a$10$N.fO7.F2.1bq9A2Kqf9Cue3YYs/Q.RK6XEtzPJ6K8LQGXg.Yy5GZq', NULL, 'https://robohash.org/sarahjones?set=set2&size=200x200', 'COLLABORATOR', '2025-06-16 17:02:58.000000', 'sarah_jones', NULL, NULL, NULL, NULL, 0),
(7, '2025-06-16 17:02:58.000000', 'alice@example.com', 'Alice Brown', b'1', b'1', NULL, '$2a$10$N.fO7.F2.1bq9A2Kqf9Cue3YYs/Q.RK6XEtzPJ6K8LQGXg.Yy5GZq', '2026-06-16 17:02:58.000000', 'https://robohash.org/alicebrown?set=set3&size=200x200', 'USER', '2025-06-16 17:02:58.000000', 'alice_brown', NULL, NULL, NULL, NULL, 0),
(8, '2025-06-16 17:02:58.000000', 'bob@example.com', 'Bob Taylor', b'1', b'0', NULL, '$2a$10$N.fO7.F2.1bq9A2Kqf9Cue3YYs/Q.RK6XEtzPJ6K8LQGXg.Yy5GZq', NULL, 'https://robohash.org/bobtaylor?set=set4&size=200x200', 'USER', '2025-06-16 17:02:58.000000', 'bob_taylor', NULL, NULL, NULL, NULL, 0),
(9, '2025-06-20 05:47:56.000000', 'huyduu19@gmail.com', 'Huy Duu', b'1', b'0', NULL, '$2a$12$Wr2RQlwTadjwIiSn4fJ/pu9iMD/jOkJBoHQzI/2TphZTO9wd12e86', NULL, NULL, 'USER', '2025-06-20 05:47:56.000000', 'huyduu19', NULL, NULL, NULL, NULL, 0),
(10, '2025-06-20 05:48:49.000000', 'huyplumber@gmail.com', 'Huy Duu', b'1', b'0', NULL, '$2a$12$ueT7wE59x02cmHdxZMdNyOLnyG6LS1m58wlAPxlCI6y61synbXHDW', NULL, NULL, 'USER', '2025-06-20 05:48:49.000000', 'huyduudtvd', NULL, NULL, NULL, NULL, 0),
(11, '2025-06-20 06:13:02.000000', 'test2@example.com', 'Test User 2', b'1', b'0', NULL, '$2a$12$KihMJHJfP7DgF3z31zYlYOUDm01pciGIHNT5xS8t1JaTN.xY2rK9O', NULL, NULL, 'USER', '2025-06-20 06:13:02.000000', 'testuser2', NULL, NULL, NULL, NULL, 0),
(12, '2025-06-20 06:18:07.000000', 'test3@example.com', 'Test User 3', b'1', b'0', NULL, '$2a$12$0RL58ydfzLef1S8gP5bql.iXjWxk8aJJX1z9RnOd6.rarQe1vqZWC', NULL, NULL, 'USER', '2025-06-20 06:18:07.000000', 'testuser3', NULL, NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_exercise_attempts`
--

CREATE TABLE `user_exercise_attempts` (
  `id` bigint(20) NOT NULL,
  `attempt_number` int(11) DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `correct_answers` int(11) DEFAULT NULL,
  `score` double DEFAULT NULL,
  `started_at` datetime(6) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `time_taken` int(11) DEFAULT NULL,
  `total_questions` int(11) NOT NULL,
  `exercise_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `user_exercise_attempts`
--

INSERT INTO `user_exercise_attempts` (`id`, `attempt_number`, `completed_at`, `correct_answers`, `score`, `started_at`, `status`, `time_taken`, `total_questions`, `exercise_id`, `user_id`) VALUES
(1, 1, '2025-06-01 09:10:15.000000', 1, 100, '2025-06-01 09:10:00.000000', 'COMPLETED', 15, 1, 1, 2),
(2, 1, '2025-06-01 09:15:12.000000', 1, 100, '2025-06-01 09:15:00.000000', 'COMPLETED', 12, 1, 2, 2),
(3, 1, '2025-06-02 10:10:20.000000', 1, 100, '2025-06-02 10:10:00.000000', 'COMPLETED', 20, 1, 3, 2),
(4, 1, '2025-06-02 10:15:25.000000', 1, 100, '2025-06-02 10:15:00.000000', 'COMPLETED', 25, 1, 4, 2),
(5, 1, '2025-06-10 11:05:10.000000', 1, 100, '2025-06-10 11:05:00.000000', 'COMPLETED', 10, 1, 1, 3),
(6, 1, '2025-06-10 11:10:08.000000', 1, 100, '2025-06-10 11:10:00.000000', 'COMPLETED', 8, 1, 2, 3),
(7, 1, '2025-06-11 12:10:18.000000', 1, 100, '2025-06-11 12:10:00.000000', 'COMPLETED', 18, 1, 3, 3),
(8, 1, '2025-06-11 12:15:22.000000', 1, 100, '2025-06-11 12:15:00.000000', 'COMPLETED', 22, 1, 4, 3),
(9, 1, '2025-06-12 13:10:35.000000', 1, 100, '2025-06-12 13:10:00.000000', 'COMPLETED', 35, 1, 5, 3),
(10, 1, '2025-06-12 13:15:45.000000', 1, 100, '2025-06-12 13:15:00.000000', 'COMPLETED', 45, 1, 6, 3),
(11, 1, '2025-06-13 15:10:25.000000', 1, 80, '2025-06-13 15:10:00.000000', 'COMPLETED', 25, 1, 7, 3),
(12, 1, '2025-06-05 09:35:08.000000', 1, 100, '2025-06-05 09:35:00.000000', 'COMPLETED', 8, 1, 1, 4),
(13, 1, '2025-06-05 09:40:06.000000', 1, 100, '2025-06-05 09:40:00.000000', 'COMPLETED', 6, 1, 2, 4),
(14, 1, '2025-06-07 14:20:30.000000', 1, 90, '2025-06-07 14:20:00.000000', 'COMPLETED', 30, 1, 7, 4),
(15, 1, '2025-06-07 14:25:50.000000', 1, 85, '2025-06-07 14:25:00.000000', 'COMPLETED', 50, 1, 8, 4),
(16, 1, '2025-06-14 16:20:35.000000', 1, 95, '2025-06-14 16:20:00.000000', 'COMPLETED', 35, 1, 9, 4),
(17, 2, '2025-06-15 10:00:28.000000', 1, 100, '2025-06-15 10:00:00.000000', 'COMPLETED', 28, 1, 9, 4),
(18, 1, '2025-05-20 19:30:25.000000', 1, 100, '2025-05-20 19:30:00.000000', 'COMPLETED', 25, 1, 9, 7),
(19, 1, '2025-05-20 19:35:40.000000', 1, 95, '2025-05-20 19:35:00.000000', 'COMPLETED', 40, 1, 10, 7),
(20, 1, '2025-06-01 20:30:20.000000', 1, 90, '2025-06-01 20:30:00.000000', 'COMPLETED', 20, 1, 11, 7),
(21, 1, '2025-06-01 20:35:35.000000', 1, 100, '2025-06-01 20:35:00.000000', 'COMPLETED', 35, 1, 12, 7),
(22, 1, '2025-06-15 14:06:00.000000', 0, 60, '2025-06-15 14:05:00.000000', 'COMPLETED', 60, 1, 5, 2),
(23, 1, '2025-06-13 15:26:15.000000', 0, 70, '2025-06-13 15:25:00.000000', 'COMPLETED', 55, 1, 8, 3),
(24, 1, '2025-06-14 16:26:10.000000', 0, 75, '2025-06-14 16:25:00.000000', 'COMPLETED', 45, 1, 10, 4),
(25, 1, '2025-06-01 09:10:15.000000', 1, 100, '2025-06-01 09:10:00.000000', 'COMPLETED', 15, 1, 1, 2),
(26, 1, '2025-06-01 09:15:12.000000', 1, 100, '2025-06-01 09:15:00.000000', 'COMPLETED', 12, 1, 2, 2),
(27, 1, '2025-06-02 10:10:20.000000', 1, 100, '2025-06-02 10:10:00.000000', 'COMPLETED', 20, 1, 3, 2),
(28, 1, '2025-06-02 10:15:25.000000', 1, 100, '2025-06-02 10:15:00.000000', 'COMPLETED', 25, 1, 4, 2),
(29, 1, '2025-06-10 11:05:10.000000', 1, 100, '2025-06-10 11:05:00.000000', 'COMPLETED', 10, 1, 1, 3),
(30, 1, '2025-06-10 11:10:08.000000', 1, 100, '2025-06-10 11:10:00.000000', 'COMPLETED', 8, 1, 2, 3),
(31, 1, '2025-06-11 12:10:18.000000', 1, 100, '2025-06-11 12:10:00.000000', 'COMPLETED', 18, 1, 3, 3),
(32, 1, '2025-06-11 12:15:22.000000', 1, 100, '2025-06-11 12:15:00.000000', 'COMPLETED', 22, 1, 4, 3),
(33, 1, '2025-06-12 13:10:35.000000', 1, 100, '2025-06-12 13:10:00.000000', 'COMPLETED', 35, 1, 5, 3),
(34, 1, '2025-06-12 13:15:45.000000', 1, 100, '2025-06-12 13:15:00.000000', 'COMPLETED', 45, 1, 6, 3),
(35, 1, '2025-06-13 15:10:25.000000', 1, 80, '2025-06-13 15:10:00.000000', 'COMPLETED', 25, 1, 7, 3),
(36, 1, '2025-06-05 09:35:08.000000', 1, 100, '2025-06-05 09:35:00.000000', 'COMPLETED', 8, 1, 1, 4),
(37, 1, '2025-06-05 09:40:06.000000', 1, 100, '2025-06-05 09:40:00.000000', 'COMPLETED', 6, 1, 2, 4),
(38, 1, '2025-06-07 14:20:30.000000', 1, 90, '2025-06-07 14:20:00.000000', 'COMPLETED', 30, 1, 7, 4),
(39, 1, '2025-06-07 14:25:50.000000', 1, 85, '2025-06-07 14:25:00.000000', 'COMPLETED', 50, 1, 8, 4),
(40, 1, '2025-06-14 16:20:35.000000', 1, 95, '2025-06-14 16:20:00.000000', 'COMPLETED', 35, 1, 9, 4),
(41, 2, '2025-06-15 10:00:28.000000', 1, 100, '2025-06-15 10:00:00.000000', 'COMPLETED', 28, 1, 9, 4),
(42, 1, '2025-05-20 19:30:25.000000', 1, 100, '2025-05-20 19:30:00.000000', 'COMPLETED', 25, 1, 9, 7),
(43, 1, '2025-05-20 19:35:40.000000', 1, 95, '2025-05-20 19:35:00.000000', 'COMPLETED', 40, 1, 10, 7),
(44, 1, '2025-06-01 20:30:20.000000', 1, 90, '2025-06-01 20:30:00.000000', 'COMPLETED', 20, 1, 11, 7),
(45, 1, '2025-06-01 20:35:35.000000', 1, 100, '2025-06-01 20:35:00.000000', 'COMPLETED', 35, 1, 12, 7),
(46, 1, '2025-06-15 14:06:00.000000', 0, 60, '2025-06-15 14:05:00.000000', 'COMPLETED', 60, 1, 5, 2),
(47, 1, '2025-06-13 15:26:15.000000', 0, 70, '2025-06-13 15:25:00.000000', 'COMPLETED', 55, 1, 8, 3),
(48, 1, '2025-06-14 16:26:10.000000', 0, 75, '2025-06-14 16:25:00.000000', 'COMPLETED', 45, 1, 10, 4);

-- --------------------------------------------------------

--
-- Table structure for table `user_lesson_progress`
--

CREATE TABLE `user_lesson_progress` (
  `id` bigint(20) NOT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `last_accessed_at` datetime(6) DEFAULT NULL,
  `lesson_id` bigint(20) NOT NULL,
  `notes` text DEFAULT NULL,
  `progress_percentage` int(11) NOT NULL,
  `started_at` datetime(6) DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `time_spent_minutes` int(11) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `user_lesson_progress`
--

INSERT INTO `user_lesson_progress` (`id`, `completed_at`, `created_at`, `last_accessed_at`, `lesson_id`, `notes`, `progress_percentage`, `started_at`, `status`, `time_spent_minutes`, `updated_at`, `user_id`) VALUES
(1, '2025-06-01 09:25:00.000000', '2025-06-16 18:26:19.000000', '2025-06-01 09:25:00.000000', 1, 'Completed all greetings exercises', 100, '2025-06-01 09:00:00.000000', 'COMPLETED', 25, '2025-06-16 18:26:19.000000', 2),
(2, '2025-06-02 10:30:00.000000', '2025-06-16 18:26:19.000000', '2025-06-02 10:30:00.000000', 2, 'Good understanding of present simple', 100, '2025-06-02 10:00:00.000000', 'COMPLETED', 30, '2025-06-16 18:26:19.000000', 2),
(3, NULL, '2025-06-16 18:26:19.000000', '2025-06-15 14:15:00.000000', 3, 'Working on time expressions', 60, '2025-06-15 14:00:00.000000', 'IN_PROGRESS', 15, '2025-06-16 18:26:19.000000', 2),
(4, '2025-06-10 11:20:00.000000', '2025-06-16 18:26:19.000000', '2025-06-10 11:20:00.000000', 1, 'Quick learner', 100, '2025-06-10 11:00:00.000000', 'COMPLETED', 20, '2025-06-16 18:26:19.000000', 3),
(5, '2025-06-11 12:35:00.000000', '2025-06-16 18:26:19.000000', '2025-06-11 12:35:00.000000', 2, 'Practiced verb conjugations', 100, '2025-06-11 12:00:00.000000', 'COMPLETED', 35, '2025-06-16 18:26:19.000000', 3),
(6, '2025-06-12 13:28:00.000000', '2025-06-16 18:26:19.000000', '2025-06-12 13:28:00.000000', 3, 'Mastered numbers and time', 100, '2025-06-12 13:00:00.000000', 'COMPLETED', 28, '2025-06-16 18:26:19.000000', 3),
(7, NULL, '2025-06-16 18:26:19.000000', '2025-06-15 16:20:00.000000', 4, 'Learning irregular verbs', 75, '2025-06-13 15:00:00.000000', 'IN_PROGRESS', 40, '2025-06-16 18:26:19.000000', 3),
(8, '2025-06-05 09:48:00.000000', '2025-06-16 18:26:19.000000', '2025-06-05 09:48:00.000000', 1, 'Easy lesson', 100, '2025-06-05 09:30:00.000000', 'COMPLETED', 18, '2025-06-16 18:26:19.000000', 4),
(9, '2025-06-05 10:22:00.000000', '2025-06-16 18:26:19.000000', '2025-06-05 10:22:00.000000', 2, 'Clear explanations', 100, '2025-06-05 10:00:00.000000', 'COMPLETED', 22, '2025-06-16 18:26:19.000000', 4),
(10, '2025-06-06 11:25:00.000000', '2025-06-16 18:26:19.000000', '2025-06-06 11:25:00.000000', 3, 'Numbers were challenging', 100, '2025-06-06 11:00:00.000000', 'COMPLETED', 25, '2025-06-16 18:26:19.000000', 4),
(11, '2025-06-07 14:35:00.000000', '2025-06-16 18:26:19.000000', '2025-06-07 14:35:00.000000', 4, 'Past tense practice needed', 100, '2025-06-07 14:00:00.000000', 'COMPLETED', 35, '2025-06-16 18:26:19.000000', 4),
(12, '2025-06-08 15:30:00.000000', '2025-06-16 18:26:19.000000', '2025-06-08 15:30:00.000000', 5, 'Useful vocabulary', 100, '2025-06-08 15:00:00.000000', 'COMPLETED', 30, '2025-06-16 18:26:19.000000', 4),
(13, NULL, '2025-06-16 18:26:19.000000', '2025-06-15 16:45:00.000000', 7, 'Conditionals are complex', 40, '2025-06-14 16:00:00.000000', 'IN_PROGRESS', 20, '2025-06-16 18:26:19.000000', 4),
(14, '2025-05-01 08:15:00.000000', '2025-06-16 18:26:19.000000', '2025-05-01 08:15:00.000000', 1, 'Review lesson', 100, '2025-05-01 08:00:00.000000', 'COMPLETED', 15, '2025-06-16 18:26:19.000000', 6),
(15, '2025-05-01 09:20:00.000000', '2025-06-16 18:26:19.000000', '2025-05-01 09:20:00.000000', 2, 'Good refresher', 100, '2025-05-01 09:00:00.000000', 'COMPLETED', 20, '2025-06-16 18:26:19.000000', 6),
(16, '2025-05-15 10:45:00.000000', '2025-06-16 18:26:19.000000', '2025-05-15 10:45:00.000000', 6, 'Future plans lesson', 100, '2025-05-15 10:00:00.000000', 'COMPLETED', 45, '2025-06-16 18:26:19.000000', 6),
(17, NULL, '2025-06-16 18:26:19.000000', '2025-06-15 15:30:00.000000', 9, 'Preparing business materials', 80, '2025-06-10 14:00:00.000000', 'IN_PROGRESS', 60, '2025-06-16 18:26:19.000000', 6),
(18, '2025-04-15 07:12:00.000000', '2025-06-16 18:26:19.000000', '2025-04-15 07:12:00.000000', 1, 'Fast completion', 100, '2025-04-15 07:00:00.000000', 'COMPLETED', 12, '2025-06-16 18:26:19.000000', 7),
(19, '2025-04-16 08:18:00.000000', '2025-06-16 18:26:19.000000', '2025-04-16 08:18:00.000000', 2, 'Well structured', 100, '2025-04-16 08:00:00.000000', 'COMPLETED', 18, '2025-06-16 18:26:19.000000', 7),
(20, '2025-05-20 19:55:00.000000', '2025-06-16 18:26:19.000000', '2025-05-20 19:55:00.000000', 7, 'Challenging but manageable', 100, '2025-05-20 19:00:00.000000', 'COMPLETED', 55, '2025-06-16 18:26:19.000000', 7),
(21, '2025-06-01 21:05:00.000000', '2025-06-16 18:26:19.000000', '2025-06-01 21:05:00.000000', 8, 'Advanced grammar mastered', 100, '2025-06-01 20:00:00.000000', 'COMPLETED', 65, '2025-06-16 18:26:19.000000', 7),
(22, NULL, '2025-06-16 18:26:19.000000', '2025-06-15 19:15:00.000000', 10, 'Working on conversation skills', 30, '2025-06-12 18:00:00.000000', 'IN_PROGRESS', 25, '2025-06-16 18:26:19.000000', 7),
(23, '2025-06-01 09:25:00.000000', '2025-06-16 18:29:34.000000', '2025-06-01 09:25:00.000000', 1, 'Completed all greetings exercises', 100, '2025-06-01 09:00:00.000000', 'COMPLETED', 25, '2025-06-16 18:29:34.000000', 2),
(24, '2025-06-02 10:30:00.000000', '2025-06-16 18:29:34.000000', '2025-06-02 10:30:00.000000', 2, 'Good understanding of present simple', 100, '2025-06-02 10:00:00.000000', 'COMPLETED', 30, '2025-06-16 18:29:34.000000', 2),
(25, NULL, '2025-06-16 18:29:34.000000', '2025-06-15 14:15:00.000000', 3, 'Working on time expressions', 60, '2025-06-15 14:00:00.000000', 'IN_PROGRESS', 15, '2025-06-16 18:29:34.000000', 2),
(26, '2025-06-10 11:20:00.000000', '2025-06-16 18:29:34.000000', '2025-06-10 11:20:00.000000', 1, 'Quick learner', 100, '2025-06-10 11:00:00.000000', 'COMPLETED', 20, '2025-06-16 18:29:34.000000', 3),
(27, '2025-06-11 12:35:00.000000', '2025-06-16 18:29:34.000000', '2025-06-11 12:35:00.000000', 2, 'Practiced verb conjugations', 100, '2025-06-11 12:00:00.000000', 'COMPLETED', 35, '2025-06-16 18:29:34.000000', 3),
(28, '2025-06-12 13:28:00.000000', '2025-06-16 18:29:34.000000', '2025-06-12 13:28:00.000000', 3, 'Mastered numbers and time', 100, '2025-06-12 13:00:00.000000', 'COMPLETED', 28, '2025-06-16 18:29:34.000000', 3),
(29, NULL, '2025-06-16 18:29:34.000000', '2025-06-15 16:20:00.000000', 4, 'Learning irregular verbs', 75, '2025-06-13 15:00:00.000000', 'IN_PROGRESS', 40, '2025-06-16 18:29:34.000000', 3),
(30, '2025-06-05 09:48:00.000000', '2025-06-16 18:29:34.000000', '2025-06-05 09:48:00.000000', 1, 'Easy lesson', 100, '2025-06-05 09:30:00.000000', 'COMPLETED', 18, '2025-06-16 18:29:34.000000', 4),
(31, '2025-06-05 10:22:00.000000', '2025-06-16 18:29:34.000000', '2025-06-05 10:22:00.000000', 2, 'Clear explanations', 100, '2025-06-05 10:00:00.000000', 'COMPLETED', 22, '2025-06-16 18:29:34.000000', 4),
(32, '2025-06-06 11:25:00.000000', '2025-06-16 18:29:34.000000', '2025-06-06 11:25:00.000000', 3, 'Numbers were challenging', 100, '2025-06-06 11:00:00.000000', 'COMPLETED', 25, '2025-06-16 18:29:34.000000', 4),
(33, '2025-06-07 14:35:00.000000', '2025-06-16 18:29:34.000000', '2025-06-07 14:35:00.000000', 4, 'Past tense practice needed', 100, '2025-06-07 14:00:00.000000', 'COMPLETED', 35, '2025-06-16 18:29:34.000000', 4),
(34, '2025-06-08 15:30:00.000000', '2025-06-16 18:29:34.000000', '2025-06-08 15:30:00.000000', 5, 'Useful vocabulary', 100, '2025-06-08 15:00:00.000000', 'COMPLETED', 30, '2025-06-16 18:29:34.000000', 4),
(35, NULL, '2025-06-16 18:29:34.000000', '2025-06-15 16:45:00.000000', 7, 'Conditionals are complex', 40, '2025-06-14 16:00:00.000000', 'IN_PROGRESS', 20, '2025-06-16 18:29:34.000000', 4),
(36, '2025-05-01 08:15:00.000000', '2025-06-16 18:29:34.000000', '2025-05-01 08:15:00.000000', 1, 'Review lesson', 100, '2025-05-01 08:00:00.000000', 'COMPLETED', 15, '2025-06-16 18:29:34.000000', 6),
(37, '2025-05-01 09:20:00.000000', '2025-06-16 18:29:34.000000', '2025-05-01 09:20:00.000000', 2, 'Good refresher', 100, '2025-05-01 09:00:00.000000', 'COMPLETED', 20, '2025-06-16 18:29:34.000000', 6),
(38, '2025-05-15 10:45:00.000000', '2025-06-16 18:29:34.000000', '2025-05-15 10:45:00.000000', 6, 'Future plans lesson', 100, '2025-05-15 10:00:00.000000', 'COMPLETED', 45, '2025-06-16 18:29:34.000000', 6),
(39, NULL, '2025-06-16 18:29:34.000000', '2025-06-15 15:30:00.000000', 9, 'Preparing business materials', 80, '2025-06-10 14:00:00.000000', 'IN_PROGRESS', 60, '2025-06-16 18:29:34.000000', 6),
(40, '2025-04-15 07:12:00.000000', '2025-06-16 18:29:34.000000', '2025-04-15 07:12:00.000000', 1, 'Fast completion', 100, '2025-04-15 07:00:00.000000', 'COMPLETED', 12, '2025-06-16 18:29:34.000000', 7),
(41, '2025-04-16 08:18:00.000000', '2025-06-16 18:29:34.000000', '2025-04-16 08:18:00.000000', 2, 'Well structured', 100, '2025-04-16 08:00:00.000000', 'COMPLETED', 18, '2025-06-16 18:29:34.000000', 7),
(42, '2025-05-20 19:55:00.000000', '2025-06-16 18:29:34.000000', '2025-05-20 19:55:00.000000', 7, 'Challenging but manageable', 100, '2025-05-20 19:00:00.000000', 'COMPLETED', 55, '2025-06-16 18:29:34.000000', 7),
(43, '2025-06-01 21:05:00.000000', '2025-06-16 18:29:34.000000', '2025-06-01 21:05:00.000000', 8, 'Advanced grammar mastered', 100, '2025-06-01 20:00:00.000000', 'COMPLETED', 65, '2025-06-16 18:29:34.000000', 7),
(44, NULL, '2025-06-16 18:29:34.000000', '2025-06-15 19:15:00.000000', 10, 'Working on conversation skills', 30, '2025-06-12 18:00:00.000000', 'IN_PROGRESS', 25, '2025-06-16 18:29:34.000000', 7);

-- --------------------------------------------------------

--
-- Table structure for table `user_memberships`
--

CREATE TABLE `user_memberships` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `end_date` date NOT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `start_date` date NOT NULL,
  `status` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `membership_plan_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `auto_renew` bit(1) DEFAULT NULL,
  `cancellation_reason` varchar(255) DEFAULT NULL,
  `cancelled_at` datetime(6) DEFAULT NULL,
  `payment_status` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_progress`
--

CREATE TABLE `user_progress` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `progress_data` text DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `lesson_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_question_answers`
--

CREATE TABLE `user_question_answers` (
  `id` bigint(20) NOT NULL,
  `answered_at` datetime(6) DEFAULT NULL,
  `is_correct` bit(1) DEFAULT NULL,
  `time_taken` int(11) DEFAULT NULL,
  `user_answer` text DEFAULT NULL,
  `exercise_question_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `user_exercise_attempt_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_comments_lesson` (`lesson_id`),
  ADD KEY `fk_comments_user` (`user_id`);

--
-- Indexes for table `exercises`
--
ALTER TABLE `exercises`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_exercises_lesson_id` (`lesson_id`),
  ADD KEY `idx_exercises_difficulty` (`difficulty_level`);

--
-- Indexes for table `exercise_question`
--
ALTER TABLE `exercise_question`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_exercise_question_exercise` (`exercise_id`);

--
-- Indexes for table `flashcards`
--
ALTER TABLE `flashcards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_flashcards_creator` (`created_by`),
  ADD KEY `idx_flashcards_set_id` (`flashcard_set_id`);

--
-- Indexes for table `flashcard_sets`
--
ALTER TABLE `flashcard_sets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_flashcard_sets_creator` (`created_by`);

--
-- Indexes for table `lessons`
--
ALTER TABLE `lessons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lessons_level` (`level`),
  ADD KEY `idx_lessons_is_premium` (`is_premium`);

--
-- Indexes for table `membership_plans`
--
ALTER TABLE `membership_plans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_nconflq2x1uvxvs7sc0mnmh4` (`name`);

--
-- Indexes for table `mock_tests`
--
ALTER TABLE `mock_tests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_questions_exercise_id` (`exercise_id`);

--
-- Indexes for table `test_results`
--
ALTER TABLE `test_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_test_results_mock_test` (`mock_test_id`),
  ADD KEY `fk_test_results_user` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_6dotkott2kjsp8vw4d0m25fb7` (`email`),
  ADD UNIQUE KEY `UK_r43af9ap4edm43mmtq01oddj6` (`username`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_users_email` (`email`);

--
-- Indexes for table `user_exercise_attempts`
--
ALTER TABLE `user_exercise_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_exercise_attempts_exercise` (`exercise_id`),
  ADD KEY `fk_user_exercise_attempts_user` (`user_id`);

--
-- Indexes for table `user_lesson_progress`
--
ALTER TABLE `user_lesson_progress`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKkm3wlef4wdkrsdwkbly0sid0l` (`lesson_id`),
  ADD KEY `FK15tdn9l75kjm9imsarb223k9q` (`user_id`);

--
-- Indexes for table `user_memberships`
--
ALTER TABLE `user_memberships`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKhe1hvgjpdth3xh0p4ogsl7c01` (`membership_plan_id`),
  ADD KEY `FK3aftj3ypdb19itnsapcxykedv` (`user_id`);

--
-- Indexes for table `user_progress`
--
ALTER TABLE `user_progress`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKk20r0wgq69ilv4py005filedb` (`lesson_id`),
  ADD KEY `FKrt37sneeps21829cuqetjm5ye` (`user_id`);

--
-- Indexes for table `user_question_answers`
--
ALTER TABLE `user_question_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKnm8dq34y6wr8jxrbqy32etejb` (`exercise_question_id`),
  ADD KEY `FKgs2ic883pr89dlhvrwak94dc8` (`user_id`),
  ADD KEY `FK3t9vj6h25uvpbffu2pixd9noh` (`user_exercise_attempt_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `exercises`
--
ALTER TABLE `exercises`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `exercise_question`
--
ALTER TABLE `exercise_question`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `flashcards`
--
ALTER TABLE `flashcards`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `flashcard_sets`
--
ALTER TABLE `flashcard_sets`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `lessons`
--
ALTER TABLE `lessons`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `membership_plans`
--
ALTER TABLE `membership_plans`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `mock_tests`
--
ALTER TABLE `mock_tests`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `test_results`
--
ALTER TABLE `test_results`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `user_exercise_attempts`
--
ALTER TABLE `user_exercise_attempts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `user_lesson_progress`
--
ALTER TABLE `user_lesson_progress`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `user_memberships`
--
ALTER TABLE `user_memberships`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `user_progress`
--
ALTER TABLE `user_progress`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_question_answers`
--
ALTER TABLE `user_question_answers`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `FK37jam8u2nwqw9enhv7nqn52e4` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`),
  ADD CONSTRAINT `FK8omq0tc18jd43bu5tjh6jvraq` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_comments_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `exercises`
--
ALTER TABLE `exercises`
  ADD CONSTRAINT `FKes9e0n86cjfb0l6349clxvxc1` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`),
  ADD CONSTRAINT `fk_exercises_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `exercise_question`
--
ALTER TABLE `exercise_question`
  ADD CONSTRAINT `FK6gdow2e73q4cyr9y5ypa1si9c` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`),
  ADD CONSTRAINT `fk_exercise_question_exercise` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `flashcards`
--
ALTER TABLE `flashcards`
  ADD CONSTRAINT `FK5pxwgncsxw718gfdlk6uc3u3e` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKob8kpup4qkh3734j7imlsl2hu` FOREIGN KEY (`flashcard_set_id`) REFERENCES `flashcard_sets` (`id`),
  ADD CONSTRAINT `fk_flashcards_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_flashcards_set` FOREIGN KEY (`flashcard_set_id`) REFERENCES `flashcard_sets` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `flashcard_sets`
--
ALTER TABLE `flashcard_sets`
  ADD CONSTRAINT `FK1s8x1irthn2o421vb54f3ubrq` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_flashcard_sets_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `FKh5a0kaygr150d8lqep5u1tmwr` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`),
  ADD CONSTRAINT `fk_questions_exercise` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `test_results`
--
ALTER TABLE `test_results`
  ADD CONSTRAINT `FK3pgkl7t3gw3f6eu20n4db4i20` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKs3wjvn59gss65qda8kxewopmj` FOREIGN KEY (`mock_test_id`) REFERENCES `mock_tests` (`id`),
  ADD CONSTRAINT `fk_test_results_mock_test` FOREIGN KEY (`mock_test_id`) REFERENCES `mock_tests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_test_results_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_exercise_attempts`
--
ALTER TABLE `user_exercise_attempts`
  ADD CONSTRAINT `FKibglq9977xq7ddd1wi5974bbj` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKjkn4lyhdch3xfw41w9fp9fbpi` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`),
  ADD CONSTRAINT `fk_user_exercise_attempts_exercise` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_exercise_attempts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_lesson_progress`
--
ALTER TABLE `user_lesson_progress`
  ADD CONSTRAINT `FK15tdn9l75kjm9imsarb223k9q` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKkm3wlef4wdkrsdwkbly0sid0l` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`);

--
-- Constraints for table `user_memberships`
--
ALTER TABLE `user_memberships`
  ADD CONSTRAINT `FK3aftj3ypdb19itnsapcxykedv` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKhe1hvgjpdth3xh0p4ogsl7c01` FOREIGN KEY (`membership_plan_id`) REFERENCES `membership_plans` (`id`);

--
-- Constraints for table `user_progress`
--
ALTER TABLE `user_progress`
  ADD CONSTRAINT `FKk20r0wgq69ilv4py005filedb` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`),
  ADD CONSTRAINT `FKrt37sneeps21829cuqetjm5ye` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_question_answers`
--
ALTER TABLE `user_question_answers`
  ADD CONSTRAINT `FK3t9vj6h25uvpbffu2pixd9noh` FOREIGN KEY (`user_exercise_attempt_id`) REFERENCES `user_exercise_attempts` (`id`),
  ADD CONSTRAINT `FKgs2ic883pr89dlhvrwak94dc8` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKnm8dq34y6wr8jxrbqy32etejb` FOREIGN KEY (`exercise_question_id`) REFERENCES `exercise_question` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
