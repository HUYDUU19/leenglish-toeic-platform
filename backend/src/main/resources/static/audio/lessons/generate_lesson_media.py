import os
from PIL import Image, ImageDraw
from gtts import gTTS

# Danh sách lesson: (image_name, audio_name, title, text)
lessons = [
    ("greeting.jpg", "greeting-intro.mp3", "Lesson 1: Greetings", "Hello! How are you?"),
    ("numbers.jpg", "numbers-intro.mp3", "Lesson 2: Numbers", "One, two, three..."),
    ("colors.jpg", "colors-intro.mp3", "Lesson 3: Colors", "Red, blue, green..."),
    ("family.jpg", "family-intro.mp3", "Lesson 4: Family", "This is my mother..."),
    ("food.jpg", "food-intro.mp3", "Lesson 5: Food", "I like pizza..."),
    ("hobbies.jpg", "hobbies-intro.mp3", "Lesson 6: Hobbies", "I enjoy reading..."),
    ("travel.jpg", "travel-intro.mp3", "Lesson 7: Travel", "I have been to Paris..."),
    ("work.jpg", "work-intro.mp3", "Lesson 8: Work", "I am a teacher..."),
    ("routine.jpg", "routine-intro.mp3", "Lesson 9: Daily Routine", "I wake up at 7 AM..."),
    ("weather.jpg", "weather-intro.mp3", "Lesson 10: Weather", "It is sunny today..."),
    ("sports.jpg", "sports-intro.mp3", "Lesson 11: Sports", "I play football..."),
    ("music.jpg", "music-intro.mp3", "Lesson 12: Music", "I love rock music..."),
    ("movies.jpg", "movies-intro.mp3", "Lesson 13: Movies", "My favorite movie is..."),
    ("books.jpg", "books-intro.mp3", "Lesson 14: Books", "I enjoy reading..."),
    ("art.jpg", "art-intro.mp3", "Lesson 15: Art", "I like painting..."),
    ("nature.jpg", "nature-intro.mp3", "Lesson 16: Nature", "I love the mountains..."),
    ("technology.jpg", "technology-intro.mp3", "Lesson 17: Technology", "I use a computer..."),
    ("health.jpg", "health-intro.mp3", "Lesson 18: Health", "I go to the gym..."),
    ("education.jpg", "education-intro.mp3", "Lesson 19: Education", "I study at university..."),
    ("shopping.jpg", "shopping-intro.mp3", "Lesson 20: Shopping", "I need to buy groceries..."),
    ("transportation.jpg", "transportation-intro.mp3", "Lesson 21: Transportation", "I drive a car..."),
    ("communication.jpg", "communication-intro.mp3", "Lesson 22: Communication", "I use email and chat..."),
    ("environment.jpg", "environment-intro.mp3", "Lesson 23: Environment", "We should protect nature..."),
    ("society.jpg", "society-intro.mp3", "Lesson 24: Society", "In my society, we value..."),
    ("culture.jpg", "culture-intro.mp3", "Lesson 25: Culture", "My culture is rich in traditions..."),
    ("history.jpg", "history-intro.mp3", "Lesson 26: History", "In history, we learn about..."),
    ("science.jpg", "science-intro.mp3", "Lesson 27: Science", "Science helps us understand the world..."),
    ("mathematics.jpg", "mathematics-intro.mp3", "Lesson 28: Mathematics", "Math is the language of the universe..."),
    ("literature.jpg", "literature-intro.mp3", "Lesson 29: Literature", "Literature reflects human experiences..."),
    ("philosophy.jpg", "philosophy-intro.mp3", "Lesson 30: Philosophy", "Philosophy explores fundamental questions..."),
]

base_dir = "backend/src/main/resources/static/audio/lessons"
os.makedirs(base_dir, exist_ok=True)

for img_name, audio_name, title, text in lessons:
    # Đường dẫn file ảnh và audio
    img_path = os.path.join(base_dir, img_name)
    audio_path = os.path.join(base_dir, audio_name)

    # Nếu file đã tồn tại thì xóa đi để giữ lại bản mới nhất
    if os.path.exists(img_path):
        os.remove(img_path)
    if os.path.exists(audio_path):
        os.remove(audio_path)

    # Tạo file ảnh .jpg cho lesson
    img = Image.new('RGB', (400, 200), color=(73, 109, 137))
    d = ImageDraw.Draw(img)
    d.text((10, 80), title, fill=(255, 255, 0))
    img.save(img_path)

    # Tạo file audio .mp3 cho lesson
    tts = gTTS(text, lang='en')
    tts.save(audio_path)

print("✅ Đã tạo xong file .jpg và .mp3 cho tất cả lesson tại static/audio/lessons!")