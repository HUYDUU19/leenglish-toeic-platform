-- 5 flashcard set cho user thường (is_premium = 0, created_by = 1)
INSERT INTO flashcard_sets
(name, description, category, level, tags, difficulty_level, estimated_time_minutes, is_premium, is_public, is_active, created_by, created_at)
VALUES
('Basic Nouns', 'Common nouns for beginners', 'Vocabulary', 'BEGINNER', 'noun, basic', 'BEGINNER', 10, 0, 1, 1, 1, NOW()),
('Daily Verbs', 'Everyday verbs', 'Vocabulary', 'BEGINNER', 'verb, daily', 'BEGINNER', 10, 0, 1, 1, 1, NOW()),
('Colors', 'Basic color words', 'Vocabulary', 'BEGINNER', 'color, basic', 'BEGINNER', 8, 0, 1, 1, 1, NOW()),
('Fruits', 'Names of fruits', 'Vocabulary', 'BEGINNER', 'fruit, food', 'BEGINNER', 8, 0, 1, 1, 1, NOW()),
('Animals', 'Common animals', 'Vocabulary', 'BEGINNER', 'animal, basic', 'BEGINNER', 8, 0, 1, 1, 1, NOW());

-- 5 flashcard set cho user premium (is_premium = 1, created_by = 2)
INSERT INTO flashcard_sets
(name, description, category, level, tags, difficulty_level, estimated_time_minutes, is_premium, is_public, is_active, created_by, created_at)
VALUES
('Business English', 'Vocabulary for business', 'Business', 'INTERMEDIATE', 'business, work', 'INTERMEDIATE', 12, 1, 1, 1, 2, NOW()),
('Travel', 'Travel-related words', 'Travel', 'INTERMEDIATE', 'travel, tourism', 'INTERMEDIATE', 12, 1, 1, 1, 2, NOW()),
('Technology', 'Tech vocabulary', 'Technology', 'INTERMEDIATE', 'tech, IT', 'INTERMEDIATE', 12, 1, 1, 1, 2, NOW()),
('Idioms', 'Common English idioms', 'Idioms', 'ADVANCED', 'idiom, phrase', 'ADVANCED', 15, 1, 1, 1, 2, NOW()),
('Advanced Verbs', 'Difficult verbs', 'Vocabulary', 'ADVANCED', 'verb, advanced', 'ADVANCED', 15, 1, 1, 1, 2, NOW());

-- 20 flashcard cho user thường (4 flashcard mỗi set)
INSERT INTO flashcards
(front_text, back_text, hint, image_url, audio_url, order_index, difficulty, difficulty_level, tags, is_active, created_at, term, definition, example, level, category, flashcard_set_id)
VALUES
('Apple', 'Quả táo', 'A common fruit', NULL, NULL, 1, 'EASY', 'BEGINNER', 'fruit, food', 1, NOW(), 'Apple', 'A round fruit with red or green skin.', 'I eat an apple.', 'BEGINNER', 'Vocabulary', 1),
('Book', 'Quyển sách', 'You read it', NULL, NULL, 2, 'EASY', 'BEGINNER', 'object, study', 1, NOW(), 'Book', 'A set of written pages.', 'This is my book.', 'BEGINNER', 'Vocabulary', 1),
('Car', 'Xe hơi', 'You drive it', NULL, NULL, 3, 'EASY', 'BEGINNER', 'vehicle, transport', 1, NOW(), 'Car', 'A road vehicle with four wheels.', 'The car is red.', 'BEGINNER', 'Vocabulary', 1),
('Dog', 'Con chó', 'A pet animal', NULL, NULL, 4, 'EASY', 'BEGINNER', 'animal, pet', 1, NOW(), 'Dog', 'A common domestic animal.', 'The dog barks.', 'BEGINNER', 'Vocabulary', 1),

('Go', 'Đi', 'To move from one place to another', NULL, NULL, 1, 'EASY', 'BEGINNER', 'verb, move', 1, NOW(), 'Go', 'To move or travel somewhere.', 'I go to school.', 'BEGINNER', 'Vocabulary', 2),
('Eat', 'Ăn', 'To consume food', NULL, NULL, 2, 'EASY', 'BEGINNER', 'verb, food', 1, NOW(), 'Eat', 'To put food in your mouth and swallow it.', 'They eat lunch.', 'BEGINNER', 'Vocabulary', 2),
('Read', 'Đọc', 'To look at and understand words', NULL, NULL, 3, 'EASY', 'BEGINNER', 'verb, study', 1, NOW(), 'Read', 'To look at and understand written words.', 'She reads a book.', 'BEGINNER', 'Vocabulary', 2),
('Write', 'Viết', 'To form letters or words', NULL, NULL, 4, 'EASY', 'BEGINNER', 'verb, study', 1, NOW(), 'Write', 'To make letters or words on a surface.', 'He writes a letter.', 'BEGINNER', 'Vocabulary', 2),

('Red', 'Màu đỏ', 'A color', NULL, NULL, 1, 'EASY', 'BEGINNER', 'color', 1, NOW(), 'Red', 'The color of blood.', 'The apple is red.', 'BEGINNER', 'Vocabulary', 3),
('Blue', 'Màu xanh', 'A color', NULL, NULL, 2, 'EASY', 'BEGINNER', 'color', 1, NOW(), 'Blue', 'The color of the sky.', 'The sky is blue.', 'BEGINNER', 'Vocabulary', 3),
('Green', 'Màu xanh lá', 'A color', NULL, NULL, 3, 'EASY', 'BEGINNER', 'color', 1, NOW(), 'Green', 'The color of grass.', 'The grass is green.', 'BEGINNER', 'Vocabulary', 3),
('Yellow', 'Màu vàng', 'A color', NULL, NULL, 4, 'EASY', 'BEGINNER', 'color', 1, NOW(), 'Yellow', 'The color of the sun.', 'The sun is yellow.', 'BEGINNER', 'Vocabulary', 3),

('Banana', 'Quả chuối', 'A yellow fruit', NULL, NULL, 1, 'EASY', 'BEGINNER', 'fruit, food', 1, NOW(), 'Banana', 'A long curved fruit.', 'Bananas are yellow.', 'BEGINNER', 'Vocabulary', 4),
('Orange', 'Quả cam', 'A citrus fruit', NULL, NULL, 2, 'EASY', 'BEGINNER', 'fruit, food', 1, NOW(), 'Orange', 'A round citrus fruit.', 'I like orange juice.', 'BEGINNER', 'Vocabulary', 4),
('Grape', 'Quả nho', 'A small fruit', NULL, NULL, 3, 'EASY', 'BEGINNER', 'fruit, food', 1, NOW(), 'Grape', 'A small round fruit.', 'Grapes are sweet.', 'BEGINNER', 'Vocabulary', 4),
('Mango', 'Quả xoài', 'A tropical fruit', NULL, NULL, 4, 'EASY', 'BEGINNER', 'fruit, food', 1, NOW(), 'Mango', 'A sweet tropical fruit.', 'Mangoes are delicious.', 'BEGINNER', 'Vocabulary', 4),

('Cat', 'Con mèo', 'A pet animal', NULL, NULL, 1, 'EASY', 'BEGINNER', 'animal, pet', 1, NOW(), 'Cat', 'A small domestic animal.', 'The cat sleeps.', 'BEGINNER', 'Vocabulary', 5),
('Bird', 'Con chim', 'It can fly', NULL, NULL, 2, 'EASY', 'BEGINNER', 'animal, bird', 1, NOW(), 'Bird', 'An animal with wings.', 'Birds can fly.', 'BEGINNER', 'Vocabulary', 5),
('Fish', 'Con cá', 'It swims', NULL, NULL, 3, 'EASY', 'BEGINNER', 'animal, fish', 1, NOW(), 'Fish', 'An animal that lives in water.', 'Fish swim in water.', 'BEGINNER', 'Vocabulary', 5),
('Horse', 'Con ngựa', 'It runs fast', NULL, NULL, 4, 'EASY', 'BEGINNER', 'animal, horse', 1, NOW(), 'Horse', 'A large animal for riding.', 'The horse runs fast.', 'BEGINNER', 'Vocabulary', 5);

-- 20 flashcard cho user premium (4 flashcard mỗi set)
INSERT INTO flashcards
(front_text, back_text, hint, image_url, audio_url, order_index, difficulty, difficulty_level, tags, is_active, created_at, term, definition, example, level, category, flashcard_set_id)
VALUES
('Meeting', 'Cuộc họp', 'Business event', NULL, NULL, 1, 'MEDIUM', 'INTERMEDIATE', 'business, work', 1, NOW(), 'Meeting', 'A gathering of people for discussion.', 'We have a meeting at 9.', 'INTERMEDIATE', 'Business', 6),
('Deadline', 'Hạn chót', 'Due date', NULL, NULL, 2, 'MEDIUM', 'INTERMEDIATE', 'business, time', 1, NOW(), 'Deadline', 'The latest time for something.', 'The deadline is tomorrow.', 'INTERMEDIATE', 'Business', 6),
('Contract', 'Hợp đồng', 'Legal document', NULL, NULL, 3, 'MEDIUM', 'INTERMEDIATE', 'business, legal', 1, NOW(), 'Contract', 'A legal agreement.', 'Sign the contract.', 'INTERMEDIATE', 'Business', 6),
('Promotion', 'Thăng chức', 'Career advancement', NULL, NULL, 4, 'MEDIUM', 'INTERMEDIATE', 'business, career', 1, NOW(), 'Promotion', 'A move to a higher position.', 'She got a promotion.', 'INTERMEDIATE', 'Business', 6),

('Airport', 'Sân bay', 'Travel place', NULL, NULL, 1, 'MEDIUM', 'INTERMEDIATE', 'travel, place', 1, NOW(), 'Airport', 'A place for airplanes.', 'I am at the airport.', 'INTERMEDIATE', 'Travel', 7),
('Passport', 'Hộ chiếu', 'Travel document', NULL, NULL, 2, 'MEDIUM', 'INTERMEDIATE', 'travel, document', 1, NOW(), 'Passport', 'An official travel document.', 'Show your passport.', 'INTERMEDIATE', 'Travel', 7),
('Luggage', 'Hành lý', 'Travel bags', NULL, NULL, 3, 'MEDIUM', 'INTERMEDIATE', 'travel, bag', 1, NOW(), 'Luggage', 'Bags for travel.', 'My luggage is heavy.', 'INTERMEDIATE', 'Travel', 7),
('Tourist', 'Khách du lịch', 'A traveler', NULL, NULL, 4, 'MEDIUM', 'INTERMEDIATE', 'travel, person', 1, NOW(), 'Tourist', 'A person who travels.', 'Tourists visit Hanoi.', 'INTERMEDIATE', 'Travel', 7),

('Software', 'Phần mềm', 'Computer program', NULL, NULL, 1, 'MEDIUM', 'INTERMEDIATE', 'tech, computer', 1, NOW(), 'Software', 'Programs for computers.', 'Install the software.', 'INTERMEDIATE', 'Technology', 8),
('Hardware', 'Phần cứng', 'Physical computer parts', NULL, NULL, 2, 'MEDIUM', 'INTERMEDIATE', 'tech, computer', 1, NOW(), 'Hardware', 'Physical parts of a computer.', 'The hardware is new.', 'INTERMEDIATE', 'Technology', 8),
('Network', 'Mạng', 'Connection system', NULL, NULL, 3, 'MEDIUM', 'INTERMEDIATE', 'tech, connection', 1, NOW(), 'Network', 'A system of connections.', 'The network is down.', 'INTERMEDIATE', 'Technology', 8),
('Database', 'Cơ sở dữ liệu', 'Data storage', NULL, NULL, 4, 'MEDIUM', 'INTERMEDIATE', 'tech, data', 1, NOW(), 'Database', 'A collection of data.', 'Check the database.', 'INTERMEDIATE', 'Technology', 8),

('Break a leg', 'Chúc may mắn', 'Good luck', NULL, NULL, 1, 'HARD', 'ADVANCED', 'idiom, luck', 1, NOW(), 'Break a leg', 'Wish someone good luck.', 'Break a leg in your exam!', 'ADVANCED', 'Idioms', 9),
('Hit the books', 'Học bài', 'To study', NULL, NULL, 2, 'HARD', 'ADVANCED', 'idiom, study', 1, NOW(), 'Hit the books', 'To study hard.', 'I need to hit the books.', 'ADVANCED', 'Idioms', 9),
('Piece of cake', 'Dễ dàng', 'Very easy', NULL, NULL, 3, 'HARD', 'ADVANCED', 'idiom, easy', 1, NOW(), 'Piece of cake', 'Something very easy.', 'The test was a piece of cake.', 'ADVANCED', 'Idioms', 9),
('Under the weather', 'Không khỏe', 'Not feeling well', NULL, NULL, 4, 'HARD', 'ADVANCED', 'idiom, health', 1, NOW(), 'Under the weather', 'Feeling ill.', 'I feel under the weather.', 'ADVANCED', 'Idioms', 9),

('Arise', 'Phát sinh', 'To happen', NULL, NULL, 1, 'HARD', 'ADVANCED', 'verb, advanced', 1, NOW(), 'Arise', 'To happen or occur.', 'Problems may arise.', 'ADVANCED', 'Vocabulary', 10),
('Comprehend', 'Hiểu', 'To understand', NULL, NULL, 2, 'HARD', 'ADVANCED', 'verb, advanced', 1, NOW(), 'Comprehend', 'To understand.', 'Do you comprehend?', 'ADVANCED', 'Vocabulary', 10),
('Negotiate', 'Đàm phán', 'To discuss for agreement', NULL, NULL, 3, 'HARD', 'ADVANCED', 'verb, advanced', 1, NOW(), 'Negotiate', 'To discuss to reach agreement.', 'They negotiate the price.', 'ADVANCED', 'Vocabulary', 10),
('Accomplish', 'Hoàn thành', 'To finish successfully', NULL, NULL, 4, 'HARD', 'ADVANCED', 'verb, advanced', 1, NOW(), 'Accomplish', 'To finish something successfully.', 'We accomplish our goals.', 'ADVANCED', 'Vocabulary', 10);