# Backend Media Assets Generator - Usage Guide

## Tổng quan (Overview)

Script Python này sẽ tạo ra các file hình ảnh và âm thanh mẫu cho platform học TOEIC LeEnglish. Tất cả file được tạo sẽ được đặt trong cấu trúc thư mục Spring Boot phù hợp.

This Python script generates sample images and audio files for the LeEnglish TOEIC learning platform. All files are created in the appropriate Spring Boot directory structure.

## 📁 Vị trí (Location)

```
backend/src/main/resources/scripts/
├── generate_media_assets.py      # Script Python chính
├── generate_media.bat            # Script Windows batch
├── generate_media.ps1            # Script PowerShell
├── requirements.txt              # Python dependencies
├── README.md                     # Hướng dẫn chi tiết
└── USAGE_GUIDE.md               # File này
```

## 🚀 Cách sử dụng (How to Use)

### Cách 1: Sử dụng PowerShell (Recommended for Windows)

```powershell
# Mở PowerShell và chuyển đến thư mục scripts
cd backend\src\main\resources\scripts

# Chạy script với các tùy chọn:

# Chạy dry-run (chỉ xem trước, không tạo file thật)
.\generate_media.ps1 -DryRun -Verbose

# Tự động cài đặt dependencies
.\generate_media.ps1 -InstallDeps

# Tạo file thật sự
.\generate_media.ps1 -Verbose

# Kết hợp các tùy chọn
.\generate_media.ps1 -DryRun -Verbose -InstallDeps
```

### Cách 2: Sử dụng Batch File (Windows)

```cmd
# Mở Command Prompt và chuyển đến thư mục scripts
cd backend\src\main\resources\scripts

# Chạy dry-run
generate_media.bat --dry-run

# Tạo file thật
generate_media.bat
```

### Cách 3: Sử dụng Python trực tiếp

```bash
# Cài đặt dependencies trước
pip install -r requirements.txt

# Hoặc cài riêng lẻ
pip install Pillow gtts pydub

# Chạy script
python generate_media_assets.py --dry-run --verbose  # Xem trước
python generate_media_assets.py --verbose            # Tạo file thật
```

## 📂 Cấu trúc thư mục được tạo (Generated Directory Structure)

```
backend/src/main/resources/static/
├── images/
│   ├── lessons/           # 10 hình ảnh bài học
│   ├── exercises/         # 5 hình ảnh bài tập
│   ├── flashcards/        # Hình ảnh flashcard
│   ├── users/             # 10 avatar người dùng mẫu
│   └── achievements/      # 6 huy hiệu thành tích
├── audio/
│   ├── lessons/           # 5 file âm thanh bài học
│   ├── exercises/         # 8 file âm thanh bài tập
│   └── tests/             # File âm thanh kiểm tra
├── videos/
│   └── lessons/           # Thư mục video (placeholder)
└── uploads/               # Thư mục upload của user
    ├── images/
    └── audio/

frontend/public/           # Mirror của backend cho development
├── images/ (same structure)
├── audio/ (same structure)
└── videos/ (same structure)

mobile/assets/             # Assets cho mobile app
├── images/
│   ├── app_icon.png
│   ├── splash_logo.png
│   └── lesson_placeholder.png
└── audio/
```

## 🎨 Các loại file được tạo (Generated File Types)

### Hình ảnh (Images)

1. **Lesson Images** - `lessons/`

   - `greeting.jpg` - Bài học chào hỏi
   - `present-simple.jpg` - Thì hiện tại đơn
   - `numbers-time.jpg` - Số và thời gian
   - `past-simple.jpg` - Thì quá khứ đơn
   - `conversations.jpg` - Hội thoại
   - `conditionals.jpg` - Câu điều kiện
   - `business-email.jpg` - Email kinh doanh
   - `advanced-vocab.jpg` - Từ vựng nâng cao
   - `reading-strategies.jpg` - Chiến lược đọc hiểu
   - `meetings.jpg` - Cuộc họp

2. **Exercise Images** - `exercises/`

   - `photo_exercise1.jpg` - Bài tập ảnh 1
   - `photo_exercise2.jpg` - Bài tập ảnh 2
   - `woman_typing.jpg` - Phụ nữ đánh máy
   - `office_scene.jpg` - Cảnh văn phòng
   - `man_reading.jpg` - Người đàn ông đọc sách

3. **User Profiles** - `users/`

   - `user_1.jpg` đến `user_10.jpg` - Avatar người dùng mẫu

4. **Achievement Badges** - `achievements/`
   - `achievement_1.png` - First Login
   - `achievement_2.png` - Lesson Complete
   - `achievement_3.png` - Quiz Master
   - `achievement_4.png` - Streak Master
   - `achievement_5.png` - Grammar Expert
   - `achievement_6.png` - Vocabulary Builder

### File âm thanh (Audio Files)

1. **Lesson Audio** - `lessons/`

   - `greeting-intro.mp3` - Giới thiệu chào hỏi
   - `numbers.mp3` - Số đếm
   - `daily-conversations.mp3` - Hội thoại hàng ngày
   - `advanced-words.mp3` - Từ vựng nâng cao
   - `meeting-phrases.mp3` - Cụm từ họp

2. **Exercise Audio** - `exercises/`

   - `part1_ex1.mp3` - Bài tập Part 1 số 1
   - `part2_ex1.mp3` - Bài tập Part 2 số 1
   - `part2_ex2.mp3` - Bài tập Part 2 số 2
   - `q1.mp3` đến `q5.mp3` - Câu hỏi 1-5

3. **Test Audio** - `tests/`
   - `hello.mp3` - Chào hỏi
   - `thankyou.mp3` - Cảm ơn
   - `water.mp3` - Nước
   - `house.mp3` - Nhà
   - `greeting1.mp3` - Chào hỏi 1
   - `time1.mp3` - Thời gian 1

## ⚙️ Cấu hình Spring Boot (Spring Boot Configuration)

Script sẽ tạo file `application-media.properties`:

```properties
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
```

### Thêm vào application.properties chính:

```properties
# Include media configuration
spring.profiles.include=media
```

## 🔧 Tích hợp với ứng dụng (Application Integration)

### 1. Backend Controller

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
}
```

### 2. Frontend (Next.js)

```typescript
// Service để load media
export const mediaService = {
  getImageUrl: (category: string, filename: string) =>
    `${process.env.NEXT_PUBLIC_API_URL}/api/media/images/${category}/${filename}`,

  getAudioUrl: (category: string, filename: string) =>
    `${process.env.NEXT_PUBLIC_API_URL}/api/media/audio/${category}/${filename}`,
};

// Component sử dụng
const LessonCard: React.FC<{ lesson: Lesson }> = ({ lesson }) => {
  const imageUrl = mediaService.getImageUrl("lessons", lesson.imageUrl);

  return (
    <div className="lesson-card">
      <img src={imageUrl} alt={lesson.title} />
      <h3>{lesson.title}</h3>
    </div>
  );
};
```

### 3. Mobile (Flutter)

```dart
class MediaService {
  static const String baseUrl = 'http://localhost:8080/api/media';

  static String getImageUrl(String category, String filename) {
    return '$baseUrl/images/$category/$filename';
  }

  static String getAudioUrl(String category, String filename) {
    return '$baseUrl/audio/$category/$filename';
  }
}

// Widget sử dụng
class LessonTile extends StatelessWidget {
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        MediaService.getImageUrl('lessons', lesson.imageUrl),
        width: 50,
        height: 50,
      ),
      title: Text(lesson.title),
    );
  }
}
```

## 📊 Thống kê file được tạo (Generated Files Statistics)

- **Tổng số file hình ảnh**: ~35 files
- **Tổng số file âm thanh**: ~15 files
- **Tổng dung lượng**: ~15-25 MB
- **Thời gian tạo**: ~3-5 phút
- **Định dạng hình ảnh**: JPEG (lessons, exercises, users), PNG (achievements, mobile)
- **Định dạng âm thanh**: MP3

## 🚨 Lưu ý quan trọng (Important Notes)

### Dependencies cần thiết:

```bash
pip install Pillow      # Xử lý hình ảnh
pip install gtts        # Text-to-speech (cần internet)
pip install pydub       # Xử lý âm thanh
```

### Lỗi thường gặp:

1. **"Python not found"**

   - Cài đặt Python 3.7+ từ python.org
   - Thêm Python vào PATH

2. **"gTTS not available"**

   - Cần kết nối internet cho Google TTS
   - Script sẽ tạo file âm thanh placeholder nếu không có

3. **"Permission denied"**
   - Chạy terminal/command prompt với quyền administrator
   - Kiểm tra quyền ghi file trong thư mục dự án

## 📄 Report và logs

Sau khi chạy xong, script sẽ tạo:

- `media_generation_report.md` - Báo cáo chi tiết các file đã tạo
- Console logs với timestamp và status

## 🎯 Các bước tiếp theo (Next Steps)

1. **Chạy script để tạo media assets**
2. **Kiểm tra các file đã được tạo trong thư mục static/**
3. **Tích hợp MediaController vào Spring Boot app**
4. **Test API endpoints:**
   - `GET /api/media/images/lessons/greeting.jpg`
   - `GET /api/media/audio/lessons/greeting-intro.mp3`
5. **Cập nhật frontend và mobile để sử dụng media APIs**
6. **Deploy và configure CDN cho production**

---

_Tạo bởi LeEnglish Backend Media Assets Generator_
