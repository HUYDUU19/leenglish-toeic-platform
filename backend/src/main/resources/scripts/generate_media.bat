@echo off
REM Media Assets Generator for LeEnglish TOEIC Platform
REM Run this batch file to generate sample images and audio files

echo ================================================================
echo MEDIA ASSETS GENERATOR FOR LEENGLISH TOEIC PLATFORM - BACKEND
echo ================================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python not found. Please install Python 3.7+ from:
    echo    https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

echo ✅ Python found
echo.

REM Check if required packages are installed
echo 📦 Checking dependencies...
python -c "import PIL" >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Pillow not installed. Installing...
    pip install Pillow
)

python -c "import gtts" >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  gTTS not installed. Installing...
    pip install gtts
)

python -c "import pydub" >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  pydub not installed. Installing...
    pip install pydub
)

echo ✅ Dependencies checked
echo.

REM Run the generator
echo 🚀 Starting media assets generation...
echo.

if "%1"=="--dry-run" (
    echo Running in DRY RUN mode...
    python generate_media_assets.py --dry-run --verbose
) else (
    echo Creating actual files...
    python generate_media_assets.py --verbose
)

echo.
echo ✅ Generation complete!
echo.
echo 📁 Check the following directories for generated files:
echo    - backend/src/main/resources/static/
echo    - frontend/public/
echo    - mobile/assets/
echo.
echo 📄 See media_generation_report.md for details
echo.
pause

import os
from PIL import Image, ImageDraw, ImageFont
from gtts import gTTS

# Example data structure
lessons = [
    {"id": 1, "title": "Lesson 1: Greetings", "text": "Hello! How are you?"},
    {"id": 2, "title": "Lesson 2: Numbers", "text": "One, two, three, four, five."},
    # Add more lessons/exercises as needed
]

# Output directories
output_dirs = [
    "../../src/main/resources/static/",  # backend
    "../../../frontend/public/",         # frontend
    "../../../mobile/assets/"            # mobile
]

for lesson in lessons:
    for out_dir in output_dirs:
        os.makedirs(out_dir, exist_ok=True)
        # Generate image
        img_path = os.path.join(out_dir, f"lesson_{lesson['id']}.png")
        img = Image.new('RGB', (400, 100), color=(73, 109, 137))
        d = ImageDraw.Draw(img)
        d.text((10, 40), lesson['title'], fill=(255, 255, 0))
        img.save(img_path)

        # Generate audio
        audio_path = os.path.join(out_dir, f"lesson_{lesson['id']}.mp3")
        tts = gTTS(lesson['text'], lang='en')
        tts.save(audio_path)

print("✅ Media assets generated for all lessons.")
