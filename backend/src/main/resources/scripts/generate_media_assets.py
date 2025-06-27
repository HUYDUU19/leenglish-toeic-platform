#!/usr/bin/env python3
"""
================================================================
MEDIA ASSETS GENERATOR FOR LEENGLISH TOEIC PLATFORM - BACKEND
================================================================

This script generates sample images and audio files for the TOEIC learning platform
based on the file paths found in SQL database files.

Features:
- Generates placeholder images for lessons, exercises, and flashcards
- Creates synthetic audio files for listening exercises
- Organizes files in Spring Boot static resources structure
- Supports various image formats (JPG, PNG)
- Creates MP3 audio files with text-to-speech
- Adds watermarks and metadata to generated files

Requirements:
- Pillow (PIL) for image generation
- pydub for audio manipulation
- gTTS (Google Text-to-Speech) for audio generation
- requests for downloading assets (optional)

Usage:
    cd backend\src\main\resources\scripts
    generate_media.bat --dry-run  # Preview
    generate_media.bat            # Create files
"""

import os
import sys
import json
import random
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Tuple
import argparse

# Third-party imports (install with pip)
try:
    from PIL import Image, ImageDraw, ImageFont
    from PIL.ImageFilter import GaussianBlur
except ImportError:
    print("❌ Pillow not installed. Run: pip install Pillow")
    sys.exit(1)

try:
    from gtts import gTTS
    import io
except ImportError:
    print("❌ gTTS not installed. Run: pip install gtts")
    gTTS = None

try:
    from pydub import AudioSegment
    from pydub.generators import Sine
except ImportError:
    print("❌ pydub not installed. Run: pip install pydub")
    AudioSegment = None

# Configuration for Backend Structure
SCRIPT_DIR = Path(__file__).parent
BACKEND_ROOT = SCRIPT_DIR.parent.parent.parent.parent  # backend/
WORKSPACE_ROOT = BACKEND_ROOT.parent  # project root
RESOURCES_DIR = BACKEND_ROOT / "src" / "main" / "resources"

# Spring Boot static resources structure
STATIC_DIR = RESOURCES_DIR / "static"
IMAGES_DIR = STATIC_DIR / "images"
AUDIO_DIR = STATIC_DIR / "audio" 
VIDEO_DIR = STATIC_DIR / "videos"
UPLOADS_DIR = STATIC_DIR / "uploads"

# Also create assets in frontend for development
FRONTEND_DIR = WORKSPACE_ROOT / "frontend"
FRONTEND_PUBLIC = FRONTEND_DIR / "public"

# Mobile assets
MOBILE_DIR = WORKSPACE_ROOT / "mobile"
MOBILE_ASSETS_DIR = MOBILE_DIR / "assets"

# Image settings
IMAGE_SIZES = {
    'thumbnail': (150, 150),
    'medium': (400, 300),
    'large': (800, 600),
    'banner': (1200, 400),
    'square': (500, 500),
    'card': (300, 200)
}

# Color palettes for different content types
COLOR_PALETTES = {
    'lessons': ['#4F46E5', '#7C3AED', '#06B6D4', '#10B981'],      # Blue, Purple, Cyan, Green
    'exercises': ['#F59E0B', '#EF4444', '#8B5CF6', '#EC4899'],    # Orange, Red, Violet, Pink
    'flashcards': ['#84CC16', '#06B6D4', '#F59E0B', '#EF4444'],  # Lime, Cyan, Orange, Red
    'tests': ['#6B7280', '#374151', '#1F2937', '#111827'],       # Gray tones
    'achievements': ['#F59E0B', '#10B981', '#EF4444', '#8B5CF6'], # Gold, Green, Red, Purple
}

# Audio content for different types
AUDIO_CONTENT = {
    'greetings': [
        "Hello, good morning! How are you today?",
        "Hi there! Nice to meet you.",
        "Good afternoon! Welcome to our English learning platform.",
        "Good evening! Let's practice English together."
    ],
    'grammar': [
        "Present simple tense is used for daily habits and general facts.",
        "Past simple tense describes completed actions in the past.",
        "Future tense with 'will' expresses decisions made at the moment of speaking.",
        "Conditional sentences express hypothetical situations."
    ],
    'vocabulary': [
        "Let's learn some new vocabulary words today.",
        "Vocabulary building is essential for language learning.",
        "Practice these words in context to remember them better.",
        "Expand your vocabulary with these useful terms."
    ],
    'listening': [
        "Listen carefully to this conversation between two colleagues.",
        "Pay attention to the pronunciation and intonation.",
        "This listening exercise will improve your comprehension skills.",
        "Focus on the key information in this audio passage."
    ],
    'business': [
        "In business meetings, it's important to speak clearly and confidently.",
        "Professional email writing requires formal language and proper structure.",
        "Customer service representatives should be polite and helpful.",
        "Presentation skills are crucial for career advancement."
    ]
}

class BackendMediaGenerator:
    """Generates images and audio files for the TOEIC platform in Spring Boot structure"""
    
    def __init__(self, verbose: bool = False, dry_run: bool = False):
        self.verbose = verbose
        self.dry_run = dry_run
        self.created_files = []
        self.errors = []
        
    def log(self, message: str, level: str = "INFO"):
        """Log messages with timestamp"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        prefix = {
            "INFO": "ℹ️ ",
            "SUCCESS": "✅ ",
            "WARNING": "⚠️ ",
            "ERROR": "❌ ",
            "DEBUG": "🔍 "
        }.get(level, "")
        
        if level == "DEBUG" and not self.verbose:
            return
            
        print(f"[{timestamp}] {prefix}{message}")
    
    def create_directories(self) -> None:
        """Create necessary directory structure for Spring Boot and frontend"""
        
        # Backend static resources directories
        backend_directories = [
            STATIC_DIR,
            IMAGES_DIR / "lessons",
            IMAGES_DIR / "exercises", 
            IMAGES_DIR / "flashcards",
            IMAGES_DIR / "tests",
            IMAGES_DIR / "users",
            IMAGES_DIR / "achievements",
            AUDIO_DIR / "lessons",
            AUDIO_DIR / "exercises",
            AUDIO_DIR / "tests",
            VIDEO_DIR / "lessons",
            UPLOADS_DIR / "images",
            UPLOADS_DIR / "audio"
        ]
        
        # Frontend public directories (for development)
        frontend_directories = [
            FRONTEND_PUBLIC / "images" / "lessons",
            FRONTEND_PUBLIC / "images" / "exercises",
            FRONTEND_PUBLIC / "images" / "flashcards",
            FRONTEND_PUBLIC / "images" / "tests",
            FRONTEND_PUBLIC / "images" / "users",
            FRONTEND_PUBLIC / "images" / "achievements",
            FRONTEND_PUBLIC / "audio" / "lessons",
            FRONTEND_PUBLIC / "audio" / "exercises",
            FRONTEND_PUBLIC / "audio" / "tests"
        ]
        
        # Mobile directories
        mobile_directories = [
            MOBILE_ASSETS_DIR / "images",
            MOBILE_ASSETS_DIR / "audio"
        ]
        
        all_directories = backend_directories + frontend_directories + mobile_directories
        
        for directory in all_directories:
            if not self.dry_run:
                directory.mkdir(parents=True, exist_ok=True)
            self.log(f"Created directory: {directory.relative_to(WORKSPACE_ROOT)}", "SUCCESS")
    
    def generate_gradient_background(self, size: Tuple[int, int], colors: List[str]) -> Image.Image:
        """Generate a gradient background image"""
        width, height = size
        image = Image.new('RGB', size)
        draw = ImageDraw.Draw(image)
        
        # Convert hex colors to RGB
        rgb_colors = []
        for color in colors[:2]:  # Use first two colors
            color = color.lstrip('#')
            rgb_colors.append(tuple(int(color[i:i+2], 16) for i in (0, 2, 4)))
        
        if len(rgb_colors) < 2:
            rgb_colors.append((100, 100, 100))  # Default gray
        
        # Create gradient
        for y in range(height):
            ratio = y / height
            r = int(rgb_colors[0][0] * (1 - ratio) + rgb_colors[1][0] * ratio)
            g = int(rgb_colors[0][1] * (1 - ratio) + rgb_colors[1][1] * ratio)
            b = int(rgb_colors[0][2] * (1 - ratio) + rgb_colors[1][2] * ratio)
            draw.line([(0, y), (width, y)], fill=(r, g, b))
        
        return image
    
    def add_text_overlay(self, image: Image.Image, text: str, position: str = "center") -> Image.Image:
        """Add text overlay to image"""
        draw = ImageDraw.Draw(image)
        width, height = image.size
        
        # Try to load a font, fallback to default
        try:
            font = ImageFont.truetype("arial.ttf", size=min(width, height) // 15)
        except:
            font = ImageFont.load_default()
        
        # Get text dimensions
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        
        # Calculate position
        if position == "center":
            x = (width - text_width) // 2
            y = (height - text_height) // 2
        elif position == "top":
            x = (width - text_width) // 2
            y = height // 10
        else:  # bottom
            x = (width - text_width) // 2
            y = height - text_height - height // 10
        
        # Add text shadow
        shadow_offset = 2
        draw.text((x + shadow_offset, y + shadow_offset), text, font=font, fill=(0, 0, 0, 128))
        # Add main text
        draw.text((x, y), text, font=font, fill=(255, 255, 255))
        
        return image
    
    def save_image_to_multiple_locations(self, image: Image.Image, filename: str, category: str):
        """Save image to both backend static and frontend public directories"""
        paths = [
            IMAGES_DIR / category / filename,  # Backend static
            FRONTEND_PUBLIC / "images" / category / filename  # Frontend public
        ]
        
        for filepath in paths:
            if not self.dry_run:
                filepath.parent.mkdir(parents=True, exist_ok=True)
                image.save(filepath, 'JPEG', quality=85)
            self.created_files.append(str(filepath))
            
        return paths[0]  # Return backend path
    
    def save_audio_to_multiple_locations(self, audio_data: bytes, filename: str, category: str):
        """Save audio to both backend static and frontend public directories"""
        paths = [
            AUDIO_DIR / category / filename,  # Backend static
            FRONTEND_PUBLIC / "audio" / category / filename  # Frontend public
        ]
        
        for filepath in paths:
            if not self.dry_run:
                filepath.parent.mkdir(parents=True, exist_ok=True)
                with open(filepath, 'wb') as f:
                    f.write(audio_data)
            self.created_files.append(str(filepath))
            
        return paths[0]  # Return backend path
    
    def generate_lesson_image(self, filename: str, lesson_type: str = "general") -> Path:
        """Generate an image for a lesson"""
        size = IMAGE_SIZES['medium']
        colors = COLOR_PALETTES['lessons']
        
        image = self.generate_gradient_background(size, colors)
        
        # Add lesson-specific elements
        lesson_titles = {
            'greeting': 'English Greetings',
            'grammar': 'Grammar Lesson',
            'vocabulary': 'Vocabulary Builder',
            'listening': 'Listening Practice',
            'reading': 'Reading Comprehension',
            'speaking': 'Speaking Exercise',
            'writing': 'Writing Skills',
            'business': 'Business English',
            'toeic': 'TOEIC Preparation'
        }
        
        title = lesson_titles.get(lesson_type, 'English Lesson')
        image = self.add_text_overlay(image, title, "center")
        
        # Add decorative elements
        draw = ImageDraw.Draw(image)
        # Add some geometric shapes
        for _ in range(3):
            x = random.randint(0, size[0])
            y = random.randint(0, size[1])
            radius = random.randint(20, 50)
            color = random.choice(colors)
            # Convert hex to RGB with transparency
            color = color.lstrip('#')
            rgb = tuple(int(color[i:i+2], 16) for i in (0, 2, 4))
            draw.ellipse([x-radius, y-radius, x+radius, y+radius], 
                        fill=rgb + (100,))  # Semi-transparent
        
        filepath = self.save_image_to_multiple_locations(image, filename, "lessons")
        self.log(f"Generated lesson image: {filename}", "SUCCESS")
        return filepath
    
    def generate_exercise_image(self, filename: str, exercise_type: str = "general") -> Path:
        """Generate an image for an exercise"""
        size = IMAGE_SIZES['card']
        colors = COLOR_PALETTES['exercises']
        image = self.generate_gradient_background(size, colors)

        exercise_titles = {
            'multiple_choice': 'Multiple Choice',
            'listening': 'Listening Exercise',
            'grammar': 'Grammar Practice',
            'vocabulary': 'Vocabulary Quiz',
            'reading': 'Reading Exercise'
        }

        title = exercise_titles.get(exercise_type, 'Exercise')
        image = self.add_text_overlay(image, title, "center")

        # If multiple_choice, add answer choices A B C D at the bottom
        if exercise_type == 'multiple_choice':
            image = self.add_text_overlay(image, "A    B    C    D", position="bottom")

        filepath = self.save_image_to_multiple_locations(image, filename, "exercises")
        self.log(f"Generated exercise image: {filename}", "SUCCESS")
        return filepath
    
    def generate_flashcard_image(self, filename: str, word: str = "Sample") -> Path:
        """Generate an image for a flashcard"""
        size = IMAGE_SIZES['square']
        colors = COLOR_PALETTES['flashcards']
        
        image = self.generate_gradient_background(size, colors)
        image = self.add_text_overlay(image, word, "center")
        
        filepath = self.save_image_to_multiple_locations(image, filename, "flashcards")
        self.log(f"Generated flashcard image: {filename}", "SUCCESS")
        return filepath
    
    def generate_audio_file(self, filename: str, text: str, category: str = "general") -> Path:
        """Generate an audio file using text-to-speech"""
        
        if gTTS is None:
            self.log("gTTS not available, creating placeholder audio", "WARNING")
            return self.generate_placeholder_audio(filename, category)
        
        try:
            # Select appropriate text based on category
            if category in AUDIO_CONTENT:
                audio_text = random.choice(AUDIO_CONTENT[category])
            else:
                audio_text = text or "This is a sample audio file for English learning."
            
            if not self.dry_run:
                tts = gTTS(text=audio_text, lang='en', slow=False)
                
                # Save to temporary buffer
                audio_buffer = io.BytesIO()
                tts.write_to_fp(audio_buffer)
                audio_buffer.seek(0)
                
                # Save to multiple locations
                filepath = self.save_audio_to_multiple_locations(
                    audio_buffer.read(), filename, category
                )
            else:
                filepath = AUDIO_DIR / category / filename
            
            self.log(f"Generated audio file: {filename}", "SUCCESS")
            return filepath
            
        except Exception as e:
            self.log(f"Error generating audio: {e}", "ERROR")
            return self.generate_placeholder_audio(filename, category)
    
    def generate_placeholder_audio(self, filename: str, category: str) -> Path:
        """Generate a placeholder beep sound"""
        if AudioSegment is None:
            self.log("pydub not available, skipping audio generation", "WARNING")
            return AUDIO_DIR / category / filename
        
        try:
            # Generate a simple tone
            if not self.dry_run:
                tone = Sine(440).to_audio_segment(duration=1000)  # 1 second, 440 Hz
                
                # Export to buffer
                audio_buffer = io.BytesIO()
                tone.export(audio_buffer, format="mp3")
                audio_buffer.seek(0)
                
                # Save to multiple locations
                filepath = self.save_audio_to_multiple_locations(
                    audio_buffer.read(), filename, category
                )
            else:
                filepath = AUDIO_DIR / category / filename
            
            self.log(f"Generated placeholder audio: {filename}", "SUCCESS")
            return filepath
            
        except Exception as e:
            self.log(f"Error generating placeholder audio: {e}", "ERROR")
            return AUDIO_DIR / category / filename
    
    def process_sql_paths(self) -> None:
        """Process SQL files to extract media paths and generate corresponding files"""
        
        # Define common file patterns found in SQL
        media_patterns = {
            # Lesson images
            'greeting.jpg': ('lesson', 'greeting'),
            'present-simple.jpg': ('lesson', 'grammar'),
            'numbers-time.jpg': ('lesson', 'vocabulary'),
            'past-simple.jpg': ('lesson', 'grammar'),
            'conversations.jpg': ('lesson', 'listening'),
            'conditionals.jpg': ('lesson', 'grammar'),
            'business-email.jpg': ('lesson', 'business'),
            'advanced-vocab.jpg': ('lesson', 'vocabulary'),
            'reading-strategies.jpg': ('lesson', 'reading'),
            'meetings.jpg': ('lesson', 'business'),
            
            # Exercise images
            'photo_exercise1.jpg': ('exercise', 'listening'),
            'photo_exercise2.jpg': ('exercise', 'listening'),
            'woman_typing.jpg': ('exercise', 'listening'),
            'office_scene.jpg': ('exercise', 'listening'),
            'man_reading.jpg': ('exercise', 'reading'),
            
            # General images
            'part1_photos.jpg': ('exercise', 'listening'),
            'part2_conversation.jpg': ('exercise', 'listening'),
            'part5_grammar.jpg': ('exercise', 'grammar'),
            'reading_advanced.jpg': ('lesson', 'reading'),
            'business_vocab.jpg': ('lesson', 'business'),
        }
        
        audio_patterns = {
            # Lesson audio
            'greeting-intro.mp3': ('lesson', 'greetings'),
            'numbers.mp3': ('lesson', 'vocabulary'),
            'daily-conversations.mp3': ('lesson', 'listening'),
            'advanced-words.mp3': ('lesson', 'vocabulary'),
            'meeting-phrases.mp3': ('lesson', 'business'),
            
            # Exercise audio
            'part1_ex1.mp3': ('exercise', 'listening'),
            'part2_ex1.mp3': ('exercise', 'listening'),
            'part2_ex2.mp3': ('exercise', 'listening'),
            'q1.mp3': ('exercise', 'listening'),
            'q2.mp3': ('exercise', 'listening'),
            'q3.mp3': ('exercise', 'listening'),
            'q4.mp3': ('exercise', 'listening'),
            'q5.mp3': ('exercise', 'listening'),
            
            # Flashcard audio
            'hello.mp3': ('flashcard', 'greetings'),
            'thankyou.mp3': ('flashcard', 'greetings'),
            'water.mp3': ('flashcard', 'vocabulary'),
            'house.mp3': ('flashcard', 'vocabulary'),
            'greeting1.mp3': ('flashcard', 'greetings'),
            'time1.mp3': ('flashcard', 'vocabulary'),
        }
        
        # Generate images
        self.log("Generating lesson and exercise images...", "INFO")
        for filename, (file_type, category) in media_patterns.items():
            if file_type == 'lesson':
                self.generate_lesson_image(filename, category)
            elif file_type == 'exercise':
                self.generate_exercise_image(filename, category)
            elif file_type == 'flashcard':
                # Extract word from filename for flashcard
                word = filename.replace('.jpg', '').replace('_', ' ').title()
                self.generate_flashcard_image(filename, word)
        
        # Generate audio files
        self.log("Generating audio files...", "INFO")
        for filename, (file_type, category) in audio_patterns.items():
            # Determine subdirectory
            if file_type == 'lesson':
                subdir = "lessons"
                # Also generate lesson image with same base name
                image_name = filename.rsplit('.', 1)[0] + ".jpg"
                self.generate_lesson_image(image_name, category)
            elif file_type == 'exercise':
                subdir = "exercises"
                # Also generate exercise image with same base name
                image_name = filename.rsplit('.', 1)[0] + ".jpg"
                self.generate_exercise_image(image_name, category)
            elif file_type == 'flashcard':
                subdir = "flashcards"
                # Also generate flashcard image with same base name
                word = filename.rsplit('.', 1)[0].replace('_', ' ').title()
                image_name = filename.rsplit('.', 1)[0] + ".jpg"
                self.generate_flashcard_image(image_name, word)
            else:
                subdir = "tests"  # Default for others
            self.generate_audio_file(filename, "", category)
    
    def generate_additional_assets(self) -> None:
        """Generate additional common assets"""
        
        # User profile placeholders
        self.log("Generating user profile images...", "INFO")
        for i in range(1, 11):
            filename = f"user_{i}.jpg"
            size = IMAGE_SIZES['thumbnail']
            colors = ['#6B7280', '#9CA3AF']
            
            image = self.generate_gradient_background(size, colors)
            image = self.add_text_overlay(image, f"User {i}", "center")
            
            self.save_image_to_multiple_locations(image, filename, "users")
        
        # Achievement badges
        self.log("Generating achievement badges...", "INFO")
        achievements = [
            "First Login", "Lesson Complete", "Quiz Master", 
            "Streak Master", "Grammar Expert", "Vocabulary Builder"
        ]
        
        for i, achievement in enumerate(achievements, 1):
            filename = f"achievement_{i}.png"
            size = IMAGE_SIZES['thumbnail']
            colors = COLOR_PALETTES['achievements']
            
            image = self.generate_gradient_background(size, colors)
            image = self.add_text_overlay(image, achievement, "center")
            
            # Save as PNG for achievements
            if not self.dry_run:
                backend_path = IMAGES_DIR / "achievements" / filename
                frontend_path = FRONTEND_PUBLIC / "images" / "achievements" / filename
                
                for path in [backend_path, frontend_path]:
                    path.parent.mkdir(parents=True, exist_ok=True)
                    image.save(path, 'PNG')
                    self.created_files.append(str(path))
        
        # Mobile assets
        self.log("Generating mobile app assets...", "INFO")
        mobile_icons = [
            ("app_icon.png", "LeEnglish", IMAGE_SIZES['thumbnail']),
            ("splash_logo.png", "TOEIC Learning", IMAGE_SIZES['medium']),
            ("lesson_placeholder.png", "Lesson", IMAGE_SIZES['card'])
        ]
        
        for filename, text, size in mobile_icons:
            colors = COLOR_PALETTES['lessons']
            image = self.generate_gradient_background(size, colors)
            image = self.add_text_overlay(image, text, "center")
            
            if not self.dry_run:
                filepath = MOBILE_ASSETS_DIR / "images" / filename
                filepath.parent.mkdir(parents=True, exist_ok=True)
                image.save(filepath, 'PNG')
                self.created_files.append(str(filepath))
    
    def generate_spring_boot_properties(self) -> None:
        """Generate Spring Boot configuration for static resources"""
        properties_content = """
# Media Assets Configuration
# Added by Media Assets Generator

# Static resource handling
spring.web.resources.static-locations=classpath:/static/
spring.web.resources.cache.cachecontrol.max-age=3600

# File upload settings for media
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
spring.servlet.multipart.enabled=true

# Content type mappings
spring.web.resources.chain.strategy.content.enabled=true
spring.web.resources.chain.strategy.content.paths=/**
"""
        
        config_file = RESOURCES_DIR / "application-media.properties"
        if not self.dry_run:
            with open(config_file, 'w') as f:
                f.write(properties_content)
        
        self.created_files.append(str(config_file))
        self.log(f"Generated Spring Boot media config: {config_file.name}", "SUCCESS")
    
    def generate_summary_report(self) -> None:
        """Generate a summary report of created files"""
        report_file = BACKEND_ROOT / "media_generation_report.md"
        
        report_content = f"""# Backend Media Assets Generation Report

**Generated on:** {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
**Generated from:** `backend/src/main/resources/scripts/generate_media_assets.py`

## Summary
- **Total files created:** {len(self.created_files)}
- **Errors encountered:** {len(self.errors)}

## Generated Files

### Images
"""
        
        # Categorize files
        images = [f for f in self.created_files if f.endswith(('.jpg', '.jpeg', '.png'))]
        audio = [f for f in self.created_files if f.endswith('.mp3')]
        
        report_content += f"- **Total images:** {len(images)}\n\n"
        
        for img in sorted(images):
            relative_path = Path(img).relative_to(WORKSPACE_ROOT)
            report_content += f"  - `{relative_path}`\n"
        
        report_content += f"\n### Audio Files\n- **Total audio files:** {len(audio)}\n\n"
        
        for aud in sorted(audio):
            relative_path = Path(aud).relative_to(WORKSPACE_ROOT)
            report_content += f"  - `{relative_path}`\n"
        
        if self.errors:
            report_content += "\n## Errors\n"
            for error in self.errors:
                report_content += f"- {error}\n"
        
        report_content += f"""
## Spring Boot Directory Structure

```
backend/src/main/resources/
├── static/
│   ├── images/
│   │   ├── lessons/
│   │   ├── exercises/
│   │   ├── flashcards/
│   │   ├── users/
│   │   └── achievements/
│   ├── audio/
│   │   ├── lessons/
│   │   ├── exercises/
│   │   └── tests/
│   ├── videos/
│   │   └── lessons/
│   └── uploads/
│       ├── images/
│       └── audio/
└── application-media.properties
```

## Usage in Spring Boot Application

### Backend Controller Access
```java
@RestController
@RequestMapping("/api/media")
public class MediaController {{
    
    @GetMapping("/images/{{category}}/{{filename}}")
    public ResponseEntity<Resource> getImage(
        @PathVariable String category,
        @PathVariable String filename) {{
        
        Resource resource = resourceLoader.getResource(
            "classpath:static/images/" + category + "/" + filename
        );
        return ResponseEntity.ok(resource);
    }}
}}
```

### Frontend Access (Next.js)
```typescript
// Static assets from Spring Boot backend
const imageUrl = `${{process.env.NEXT_PUBLIC_API_URL}}/images/lessons/greeting.jpg`;
const audioUrl = `${{process.env.NEXT_PUBLIC_API_URL}}/audio/lessons/greeting-intro.mp3`;

// During development (from public folder)
const devImageUrl = "/images/lessons/greeting.jpg";
const devAudioUrl = "/audio/lessons/greeting-intro.mp3";
```

### Mobile Access (Flutter)
```dart
// Local assets
Image.asset('assets/images/app_icon.png')

// Network images from Spring Boot
Image.network('${{apiBaseUrl}}/images/lessons/greeting.jpg')

// Audio from backend
AudioPlayer.play('${{apiBaseUrl}}/audio/lessons/greeting-intro.mp3')
```

## Configuration

### Spring Boot Properties
The script generated `application-media.properties` with:
- Static resource locations
- File upload limits  
- Cache control settings
- Content type mappings

### Environment Variables
```bash
# For production
SPRING_PROFILES_ACTIVE=media

# For development
NEXT_PUBLIC_API_URL=http://localhost:8080
```

## Next Steps

1. **Add to Spring Boot main application properties:**
   ```properties
   spring.profiles.include=media
   ```

2. **Create MediaController for API endpoints**
3. **Add file upload functionality**
4. **Implement image resizing/optimization**
5. **Add media metadata storage**
6. **Configure CDN for production**

---
*Generated by LeEnglish Backend Media Assets Generator*
"""
        
        if not self.dry_run:
            with open(report_file, 'w', encoding='utf-8') as f:
                f.write(report_content)
        
        self.log(f"Generated report: {report_file.relative_to(BACKEND_ROOT)}", "SUCCESS")
    
    def run(self) -> None:
        """Main execution method"""
        self.log("🚀 Starting LeEnglish Backend Media Assets Generator", "INFO")
        self.log(f"Backend root: {BACKEND_ROOT}", "DEBUG")
        self.log(f"Static resources: {STATIC_DIR}", "DEBUG")
        
        if self.dry_run:
            self.log("Running in DRY RUN mode - no files will be created", "WARNING")
        
        try:
            # Create directory structure
            self.create_directories()
            
            # Process SQL file patterns
            self.process_sql_paths()
            
            # Generate additional assets
            self.generate_additional_assets()
            
            # Generate Spring Boot configuration
            self.generate_spring_boot_properties()
            
            # Generate report
            self.generate_summary_report()
            
            self.log(f"✅ Generation complete! Created {len(self.created_files)} files", "SUCCESS")
            self.log("📁 Files created in both backend/static and frontend/public", "INFO")
            
            if self.errors:
                self.log(f"⚠️  {len(self.errors)} errors encountered", "WARNING")
            
        except Exception as e:
            self.log(f"Fatal error: {e}", "ERROR")
            raise

def main():
    parser = argparse.ArgumentParser(
        description="Generate media assets for LeEnglish TOEIC Platform Backend"
    )
    parser.add_argument(
        "--dry-run", 
        action="store_true", 
        help="Show what would be created without actually creating files"
    )
    parser.add_argument(
        "--verbose", 
        action="store_true", 
        help="Enable verbose logging"
    )
    
    args = parser.parse_args()
    
    # Show installation instructions if required packages are missing
    missing_packages = []
    if 'PIL' not in sys.modules:
        missing_packages.append("Pillow")
    if gTTS is None:
        missing_packages.append("gtts")
    if AudioSegment is None:
        missing_packages.append("pydub")
    
    if missing_packages:
        print("📦 Missing required packages. Install with:")
        print(f"pip install {' '.join(missing_packages)}")
        print("\n⚠️  Some features will be limited without these packages.")
        response = input("Continue anyway? (y/N): ")
        if response.lower() != 'y':
            sys.exit(1)
    
    generator = BackendMediaGenerator(verbose=args.verbose, dry_run=args.dry_run)
    generator.run()

if __name__ == "__main__":
    main()
