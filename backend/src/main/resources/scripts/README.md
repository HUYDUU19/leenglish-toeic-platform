# Backend Media Assets Generator

This directory contains the Python script to generate sample images and audio files for the LeEnglish TOEIC Platform backend.

## 📁 Files

- **`generate_media_assets.py`** - Main Python script for generating media assets
- **`requirements.txt`** - Python dependencies
- **`README.md`** - This documentation

## 🚀 Quick Start

### Prerequisites

1. **Python 3.7+** installed on your system
2. **Spring Boot backend** project structure

### Installation

```bash
# Navigate to the scripts directory
cd backend/src/main/resources/scripts

# Install Python dependencies
pip install -r requirements.txt

# Or install individually
pip install Pillow gTTS pydub requests
```

### Usage

```bash
# Run the generator (creates actual files)
python generate_media_assets.py

# Dry run (preview what would be created)
python generate_media_assets.py --dry-run

# Verbose output
python generate_media_assets.py --verbose

# Combine options
python generate_media_assets.py --dry-run --verbose
```

## 📂 Generated Structure

The script creates the following directory structure:

### Backend (Spring Boot)

```
backend/src/main/resources/
├── static/
│   ├── images/
│   │   ├── lessons/           # Lesson thumbnails and banners
│   │   ├── exercises/         # Exercise images
│   │   ├── flashcards/        # Flashcard images
│   │   ├── tests/             # Test-related images
│   │   ├── users/             # User profile placeholders
│   │   └── achievements/      # Achievement badges
│   ├── audio/
│   │   ├── lessons/           # Lesson audio files
│   │   ├── exercises/         # Exercise audio
│   │   └── tests/             # Test audio
│   ├── videos/
│   │   └── lessons/           # Video lessons (placeholder)
│   └── uploads/               # User upload directory
│       ├── images/
│       └── audio/
└── application-media.properties  # Spring Boot media config
```

### Frontend (Development)

```
frontend/public/
├── images/                    # Mirror of backend images
├── audio/                     # Mirror of backend audio
└── videos/                    # Mirror of backend videos
```

### Mobile

```
mobile/assets/
├── images/                    # Mobile app assets
└── audio/                     # Mobile audio assets
```

## 🎨 Generated Assets

### Image Types

1. **Lesson Images** (400x300)

   - Gradient backgrounds with lesson titles
   - Category-specific color schemes
   - Decorative geometric elements

2. **Exercise Images** (300x200)

   - Exercise type indicators
   - Multiple choice, listening, grammar themes

3. **Flashcard Images** (500x500)

   - Square format for word cards
   - Clean, readable text overlays

4. **User Profiles** (150x150)

   - Placeholder avatars
   - Numbered for testing

5. **Achievement Badges** (150x150)
   - PNG format with transparency
   - Various achievement types

### Audio Types

1. **Text-to-Speech Audio** (MP3)

   - Generated using Google TTS
   - English language
   - Various content categories

2. **Placeholder Audio** (MP3)
   - Simple tone beeps when TTS unavailable
   - 440Hz, 1 second duration

## 🔧 Configuration

### Color Palettes

The script uses predefined color schemes:

```python
COLOR_PALETTES = {
    'lessons': ['#4F46E5', '#7C3AED', '#06B6D4', '#10B981'],     # Blues/Greens
    'exercises': ['#F59E0B', '#EF4444', '#8B5CF6', '#EC4899'],   # Warm colors
    'flashcards': ['#84CC16', '#06B6D4', '#F59E0B', '#EF4444'], # Mixed
    'tests': ['#6B7280', '#374151', '#1F2937', '#111827'],      # Grays
}
```

### Audio Content

Pre-defined text content for different categories:

- **Greetings**: Basic English greetings and introductions
- **Grammar**: Grammar explanations and examples
- **Vocabulary**: Vocabulary building content
- **Listening**: Listening exercise instructions
- **Business**: Business English scenarios

## 🌐 Integration with Spring Boot

### 1. Static Resource Configuration

The script generates `application-media.properties`:

```properties
# Static resource handling
spring.web.resources.static-locations=classpath:/static/
spring.web.resources.cache.cachecontrol.max-age=3600

# File upload settings
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

### 2. Controller Example

```java
@RestController
@RequestMapping("/api/media")
public class MediaController {

    @GetMapping("/images/{category}/{filename}")
    public ResponseEntity<Resource> getImage(
        @PathVariable String category,
        @PathVariable String filename) {

        Resource resource = resourceLoader.getResource(
            "classpath:static/images/" + category + "/" + filename
        );

        return ResponseEntity.ok()
            .contentType(MediaType.IMAGE_JPEG)
            .body(resource);
    }

    @GetMapping("/audio/{category}/{filename}")
    public ResponseEntity<Resource> getAudio(
        @PathVariable String category,
        @PathVariable String filename) {

        Resource resource = resourceLoader.getResource(
            "classpath:static/audio/" + category + "/" + filename
        );

        return ResponseEntity.ok()
            .contentType(MediaType.valueOf("audio/mpeg"))
            .body(resource);
    }
}
```

### 3. Frontend Integration

```typescript
// Next.js component
const LessonCard: React.FC<{ lesson: Lesson }> = ({ lesson }) => {
  const imageUrl = `${process.env.NEXT_PUBLIC_API_URL}/api/media/images/lessons/${lesson.imageUrl}`;

  return (
    <div className="lesson-card">
      <img src={imageUrl} alt={lesson.title} />
      <h3>{lesson.title}</h3>
    </div>
  );
};
```

### 4. Mobile Integration

```dart
// Flutter widget
class LessonTile extends StatelessWidget {
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        '${ApiConfig.baseUrl}/api/media/images/lessons/${lesson.imageUrl}',
        width: 50,
        height: 50,
      ),
      title: Text(lesson.title),
    );
  }
}
```

## 🚨 Production Considerations

### 1. CDN Integration

For production, consider using a CDN:

```java
@Value("${media.cdn.baseUrl:}")
private String cdnBaseUrl;

public String getMediaUrl(String path) {
    return cdnBaseUrl.isEmpty() ?
        "/api/media/" + path :
        cdnBaseUrl + "/" + path;
}
```

### 2. Image Optimization

Add image processing for different sizes:

```java
@Service
public class ImageService {

    public byte[] resizeImage(byte[] original, int width, int height) {
        // Implementation using ImageIO or external library
    }

    public byte[] convertToWebP(byte[] original) {
        // Convert to WebP for better compression
    }
}
```

### 3. Caching Strategy

Configure caching headers:

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
            .addResourceLocations("classpath:/static/")
            .setCacheControl(CacheControl.maxAge(Duration.ofDays(30)));
    }
}
```

## 🛠️ Troubleshooting

### Common Issues

1. **"ModuleNotFoundError: No module named 'PIL'"**

   ```bash
   pip install Pillow
   ```

2. **"gTTS not available"**

   ```bash
   pip install gTTS
   # Requires internet connection for Google TTS API
   ```

3. **"pydub not available"**

   ```bash
   pip install pydub
   # May require ffmpeg for audio conversion
   ```

4. **Audio generation fails**
   - Check internet connection (gTTS requires online access)
   - Fallback to placeholder beep sounds
   - Install ffmpeg for audio processing

### Permissions

Ensure the script has write permissions:

```bash
# Linux/Mac
chmod +x generate_media_assets.py

# Windows (run as administrator if needed)
python generate_media_assets.py
```

## 📊 Performance

### Generation Times (Approximate)

- **Images**: ~0.5 seconds per image
- **Audio (TTS)**: ~2-3 seconds per file
- **Total runtime**: ~2-5 minutes for full generation

### File Sizes

- **Images**: 10-50 KB per JPEG
- **Audio**: 20-100 KB per MP3
- **Total size**: ~10-20 MB for complete asset set

## 🔗 Related Files

- `backend/src/main/java/com/leenglish/toeic/controller/MediaController.java`
- `backend/src/main/resources/application.properties`
- `frontend/src/services/mediaApi.ts`
- `mobile/lib/services/media_service.dart`

## 📝 License

This script is part of the LeEnglish TOEIC Platform project and follows the same license terms.
