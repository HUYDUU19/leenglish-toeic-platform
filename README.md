# 🎯 LeEnglish TOEIC Learning Platform

A comprehensive **multi-platform TOEIC learning platform** with Spring Boot backend, Next.js frontend, and Flutter mobile app.

![Platform Overview](https://img.shields.io/badge/Platform-Multi--Platform-brightgreen)
![Backend](https://img.shields.io/badge/Backend-Spring_Boot-green)
![Frontend](https://img.shields.io/badge/Frontend-Next.js-blue)
![Mobile](https://img.shields.io/badge/Mobile-Flutter-lightblue)

🔗 **Repository**: [https://github.com/HUYDUU19/leenglish-toeic-platform](https://github.com/HUYDUU19/leenglish-toeic-platform)

## 🏗️ Project Architecture

```
📦 LeEnglish TOEIC Platform
├── 🚀 backend/           # Spring Boot API Server
├── 🌐 frontend/          # Next.js Web Application
├── 📱 mobile/            # Flutter Mobile App
├── 🔧 .vscode/           # VS Code Workspace Settings
├── 📝 .gitignore         # Git Ignore Rules
├── ⚙️ package.json       # Root Scripts & Dependencies
└── 📖 README.md          # This Documentation
```

## 🚀 Technology Stack

| Component            | Technology            | Version | Purpose               |
| -------------------- | --------------------- | ------- | --------------------- |
| **Backend**          | Spring Boot           | 3.2.0   | REST API Server       |
| **Database**         | H2/MySQL              | Latest  | Data Storage          |
| **Security**         | Spring Security + JWT | Latest  | Authentication        |
| **Frontend**         | Next.js               | 14+     | Web Application       |
| **Styling**          | Tailwind CSS          | Latest  | UI Styling            |
| **Mobile**           | Flutter               | 3.x     | Cross-platform Mobile |
| **State Management** | Riverpod              | Latest  | Flutter State         |

## ⚡ Quick Start Guide

### 📋 Prerequisites

```bash
# Required Software
- Java 17+ (for Spring Boot backend)
- Node.js 18+ (for Next.js frontend)
- Flutter SDK 3.0+ (for mobile app)
- Maven (for Spring Boot)
- Git
```

### 🛠️ One-Command Setup

```bash
# Clone repository
git clone https://github.com/your-username/leenglish-toeic-platform.git
cd leenglish-toeic-platform

# Open VS Code workspace
code leenglish-workspace.code-workspace

# Install all dependencies
npm run install:all

# Start all development servers
npm run dev:backend    # Terminal 1: Backend on :8080
npm run dev:frontend   # Terminal 2: Frontend on :3000
npm run dev:mobile     # Terminal 3: Mobile app
```

### 🎯 Individual Project Setup

#### 1. 🚀 Backend (Spring Boot)

```bash
cd backend
mvn clean install
mvn spring-boot:run
# 🌐 Server: http://localhost:8080
# 📚 API Docs: http://localhost:8080/swagger-ui.html
```

#### 2. 🌐 Frontend (Next.js)

```bash
cd frontend
npm install
npm run dev
# 🌐 App: http://localhost:3000
```

#### 3. 📱 Mobile (Flutter)

```bash
cd mobile
flutter pub get
flutter run
# 📱 Choose your target device
```

## 🔗 API Documentation

### 📊 Base URL

```
Development: http://localhost:8080
```

### 🔒 Authentication

All protected endpoints require JWT token in Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

### 🏥 Health Check

| Method | Endpoint      | Description           | Auth Required |
| ------ | ------------- | --------------------- | ------------- |
| `GET`  | `/api/health` | Backend health status | ❌            |

### 🔐 Authentication Endpoints

| Method | Endpoint             | Description       | Request Body                  | Response        |
| ------ | -------------------- | ----------------- | ----------------------------- | --------------- |
| `POST` | `/api/auth/login`    | User login        | `{username, password}`        | `{token, user}` |
| `POST` | `/api/auth/register` | User registration | `{username, email, password}` | `{message}`     |
| `POST` | `/api/auth/logout`   | User logout       | -                             | `{message}`     |
| `POST` | `/api/auth/refresh`  | Refresh JWT token | `{refreshToken}`              | `{token}`       |

### 👤 User Management

| Method | Endpoint                 | Description         | Auth Required | Response    |
| ------ | ------------------------ | ------------------- | ------------- | ----------- |
| `GET`  | `/api/users`             | Get all users       | ✅            | `[{users}]` |
| `GET`  | `/api/users/{id}`        | Get user by ID      | ✅            | `{user}`    |
| `PUT`  | `/api/users/{id}`        | Update user profile | ✅            | `{user}`    |
| `POST` | `/api/users/{id}/score`  | Update user score   | ✅            | `{message}` |
| `GET`  | `/api/users/leaderboard` | Get top users       | ❌            | `[{users}]` |

### 📝 Questions & Tests

| Method   | Endpoint                                  | Description                | Parameters                     | Auth Required |
| -------- | ----------------------------------------- | -------------------------- | ------------------------------ | ------------- |
| `GET`    | `/api/questions`                          | Get questions with filters | `?section=&difficulty=&limit=` | ✅            |
| `GET`    | `/api/questions/{id}`                     | Get specific question      | -                              | ✅            |
| `POST`   | `/api/questions`                          | Create new question        | Question object                | ✅            |
| `PUT`    | `/api/questions/{id}`                     | Update question            | Question object                | ✅            |
| `DELETE` | `/api/questions/{id}`                     | Delete question            | -                              | ✅            |
| `GET`    | `/api/questions/random`                   | Get random questions       | `?count=10`                    | ✅            |
| `GET`    | `/api/questions/section/{section}/random` | Random by section          | `?count=10`                    | ✅            |

### 🏆 Test Sessions

| Method | Endpoint                         | Description            | Auth Required |
| ------ | -------------------------------- | ---------------------- | ------------- |
| `POST` | `/api/test-sessions`             | Start new test session | ✅            |
| `GET`  | `/api/test-sessions/{id}`        | Get test session       | ✅            |
| `PUT`  | `/api/test-sessions/{id}`        | Update test session    | ✅            |
| `POST` | `/api/test-sessions/{id}/submit` | Submit test answers    | ✅            |

## ⚙️ Backend Configuration

### 📋 Application Properties

The backend uses the following configuration in `application.properties`:

```properties
# Application Name
spring.application.name=englishback

# Database Configuration (MySQL)
spring.datasource.url=jdbc:mysql://localhost:3306/english5?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA/Hibernate Configuration
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.use_sql_comments=true

# Server Configuration
server.port=8080

# JWT Configuration
app.jwt.secret=leenglish-secret-key

# File Upload Configuration
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB

# Liquibase (Disabled)
spring.liquibase.enabled=false

# Logging Configuration
logging.level.org.springframework.web=DEBUG
logging.level.org.springframework.http.converter.json=DEBUG
logging.level.org.springframework=DEBUG
logging.level.com.leenglish.toeic=INFO
logging.level.org.springframework.security=DEBUG
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss} - %msg%n
```

### 🗄️ Database Setup

1. **Install MySQL** (version 8.0+)
2. **Create Database**:
   ```sql
   CREATE DATABASE english5;
   ```
3. **Update credentials** in `application.properties` if needed
4. **Run the application** - tables will be created automatically

### 🔐 Security Configuration

- **JWT Secret**: Change `app.jwt.secret` in production
- **CORS**: Configured for development (localhost:3000)
- **Authentication**: JWT-based with refresh tokens
- **Password Encoding**: BCrypt hashing

## 🧪 API Testing Guide

### 🚀 Starting the Backend Server

1. **Make sure MySQL is running** and database `english5` exists
2. **Start the backend server**:
   ```bash
   cd backend
   mvn spring-boot:run
   ```
   Or use VS Code task: `Start Backend Server`

3. **Verify server is running**: http://localhost:8080/api/health

### 🛠️ Testing Tools

#### 1. **Postman** (Recommended)
- Download: https://www.postman.com/downloads/
- Import collection từ file `postman_collection.json` (nếu có)

#### 2. **Thunder Client** (VS Code Extension)
- Install extension: `Thunder Client`
- Lightweight alternative to Postman

#### 3. **curl** (Command Line)
- Built-in với Windows PowerShell/CMD

#### 4. **REST Client** (VS Code Extension)
- Install extension: `REST Client`
- Create `.http` files for testing

### 📋 Step-by-Step Testing

#### Step 1: Test Health Check
```bash
# Using curl
curl -X GET http://localhost:8080/api/health

# Expected Response:
{
  "status": "UP",
  "timestamp": "2025-06-18T10:30:00Z"
}
```

#### Step 2: User Registration
```bash
# Using curl
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'

# Expected Response:
{
  "message": "User registered successfully"
}
```

#### Step 3: User Login
```bash
# Using curl
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123"
  }'

# Expected Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com"
  }
}
```

#### Step 4: Test Protected Endpoints
```bash
# Save the token from login response
TOKEN="your-jwt-token-here"

# Get user profile
curl -X GET http://localhost:8080/api/users/1 \
  -H "Authorization: Bearer $TOKEN"

# Get questions
curl -X GET http://localhost:8080/api/questions \
  -H "Authorization: Bearer $TOKEN"
```

### 📝 Postman Collection Example

Create a new collection với các requests sau:

```json
{
  "info": {
    "name": "LeEnglish TOEIC API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Health Check",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "{{base_url}}/api/health",
          "host": ["{{base_url}}"],
          "path": ["api", "health"]
        }
      }
    },
    {
      "name": "Register User",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"username\": \"testuser\",\n  \"email\": \"test@example.com\",\n  \"password\": \"password123\"\n}"
        },
        "url": {
          "raw": "{{base_url}}/api/auth/register",
          "host": ["{{base_url}}"],
          "path": ["api", "auth", "register"]
        }
      }
    }
  ],
  "variable": [
    {
      "key": "base_url",
      "value": "http://localhost:8080"
    },
    {
      "key": "token",
      "value": ""
    }
  ]
}
```

### 🔧 REST Client (.http files)

Create file `api-tests.http` trong VS Code:

```http
### Variables
@baseUrl = http://localhost:8080
@token = your-jwt-token-here

### Health Check
GET {{baseUrl}}/api/health

### Register User
POST {{baseUrl}}/api/auth/register
Content-Type: application/json

{
  "username": "testuser",
  "email": "test@example.com",
  "password": "password123"
}

### Login User
POST {{baseUrl}}/api/auth/login
Content-Type: application/json

{
  "username": "testuser",
  "password": "password123"
}

### Get User Profile (Protected)
GET {{baseUrl}}/api/users/1
Authorization: Bearer {{token}}

### Get Questions (Protected)
GET {{baseUrl}}/api/questions?limit=10
Authorization: Bearer {{token}}

### Create Question (Protected)
POST {{baseUrl}}/api/questions
Authorization: Bearer {{token}}
Content-Type: application/json

{
  "questionText": "What is the capital of Vietnam?",
  "options": ["Hanoi", "Ho Chi Minh City", "Da Nang", "Hue"],
  "correctAnswer": 0,
  "section": "reading",
  "difficulty": "easy"
}
```

### 🚨 Common Issues & Solutions

#### 1. **CORS Error**
```
Access to fetch at 'http://localhost:8080' from origin 'http://localhost:3000' has been blocked by CORS policy
```
**Solution**: Check CORS configuration trong Spring Boot

#### 2. **401 Unauthorized**
```
{
  "error": "Unauthorized",
  "message": "JWT token is missing or invalid"
}
```
**Solution**: 
- Kiểm tra token có đúng không
- Thêm `Authorization: Bearer <token>` header

#### 3. **500 Internal Server Error**
**Solution**: 
- Check server logs
- Verify database connection
- Check application.properties

### 📊 Testing Checklist

- [ ] ✅ Health check endpoint works
- [ ] ✅ User registration works
- [ ] ✅ User login returns valid JWT
- [ ] ✅ Protected endpoints reject requests without token
- [ ] ✅ Protected endpoints work with valid token
- [ ] ✅ CRUD operations work for questions
- [ ] ✅ File upload works (if implemented)
- [ ] ✅ Error handling returns proper status codes

## 🛠️ Development Scripts

```bash
# 🏃‍♂️ Development
npm run dev:backend      # Start Spring Boot server
npm run dev:frontend     # Start Next.js dev server
npm run dev:mobile       # Start Flutter app

# 📦 Installation
npm run install:all      # Install all dependencies

# 🏗️ Building
npm run build:backend    # Build Spring Boot JAR
npm run build:frontend   # Build Next.js for production
npm run build:all        # Build all projects

# 🧪 Testing
npm run test:backend     # Run Spring Boot tests
npm run test:frontend    # Run Next.js tests
npm run test:mobile      # Run Flutter tests
npm run test:all         # Run all tests

# 🧹 Cleaning
npm run clean:backend    # Clean Spring Boot build
npm run clean:frontend   # Clean Next.js build
npm run clean:mobile     # Clean Flutter build
npm run clean:all        # Clean all projects
```

## 📁 Detailed Project Structure

### 🚀 Backend (Spring Boot)

```
backend/
├── src/main/java/com/leenglish/toeic/
│   ├── ToeicBackendApplication.java     # Main Application
│   ├── controller/                      # REST Controllers
│   │   ├── AuthController.java         # Authentication
│   │   ├── UserController.java         # User Management
│   │   ├── QuestionController.java     # Questions API
│   │   └── HealthController.java       # Health Check
│   ├── service/                         # Business Logic
│   │   ├── UserService.java           # User Operations
│   │   └── QuestionService.java       # Question Operations
│   ├── repository/                      # Data Access
│   │   ├── UserRepository.java        # User Data Access
│   │   ├── QuestionRepository.java    # Question Data Access
│   │   └── AnswerRepository.java      # Answer Data Access
│   ├── model/                          # Entity Models
│   │   ├── User.java                  # User Entity
│   │   ├── Question.java              # Question Entity
│   │   ├── Answer.java                # Answer Entity
│   │   ├── QuestionType.java          # Question Types
│   │   └── Section.java               # TOEIC Sections
│   ├── dto/                           # Data Transfer Objects
│   │   ├── UserDto.java               # User DTO
│   │   ├── QuestionDto.java           # Question DTO
│   │   └── AnswerDto.java             # Answer DTO
│   └── config/                        # Configuration
│       └── SecurityConfig.java        # Security Setup
├── src/main/resources/
│   ├── application.properties         # App Configuration
│   └── data.sql                      # Sample Data
└── pom.xml                           # Maven Dependencies
```

### 🌐 Frontend (Next.js)

```
frontend/
├── src/
│   ├── app/                          # App Router (Next.js 13+)
│   │   ├── globals.css              # Global Styles
│   │   ├── layout.tsx               # Root Layout
│   │   └── page.tsx                 # Home Page
│   ├── components/                   # React Components
│   │   ├── QuestionCard.tsx         # Question Display
│   │   └── TestSession.tsx          # Test Management
│   ├── lib/                         # Utilities
│   │   └── api.ts                   # API Client
│   └── types/                       # TypeScript Types
│       └── index.ts                 # Type Definitions
├── package.json                     # Dependencies
├── next.config.js                   # Next.js Config
├── tailwind.config.js               # Tailwind Config
└── postcss.config.js                # PostCSS Config
```

### 📱 Mobile (Flutter)

```
mobile/
├── lib/
│   ├── main.dart                    # App Entry Point
│   ├── models/                      # Data Models
│   │   └── toeic_models.dart       # TOEIC Data Models
│   ├── services/                    # API Services
│   │   └── api_service.dart        # HTTP Client
│   ├── screens/                     # App Screens
│   ├── widgets/                     # Reusable Widgets
│   │   └── question_widget.dart    # Question Display
│   ├── providers/                   # State Management
│   └── utils/                       # Helper Functions
├── assets/                          # Static Assets
│   ├── images/                     # Images
│   ├── audio/                      # Audio Files
│   └── icons/                      # App Icons
├── pubspec.yaml                    # Flutter Dependencies
└── README.md                       # Mobile Documentation
```

## 🔧 Configuration Files

### 🌍 Environment Variables

**Backend (application.properties)**

```properties
server.port=8080
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.h2.console.enabled=true
spring.jpa.hibernate.ddl-auto=create-drop
```

**Frontend (.env.local)**

```env
NEXT_PUBLIC_API_URL=http://localhost:8080/api
NEXT_PUBLIC_APP_NAME=LeEnglish TOEIC
```

**Mobile (lib/config/app_config.dart)**

```dart
class AppConfig {
  static const String apiBaseUrl = 'http://localhost:8080/api';
  static const String appName = 'LeEnglish TOEIC';
}
```

## 🌟 Key Features

- ✅ **Multi-platform**: Web, Android, iOS from single codebase
- ✅ **Modern Architecture**: Clean, scalable, maintainable
- ✅ **Real-time Sync**: Live data across all platforms
- ✅ **Responsive Design**: Works on all screen sizes
- ✅ **TOEIC Focused**: Specialized for TOEIC test preparation
- ✅ **User Progress**: Track learning progress and scores
- ✅ **Question Bank**: Comprehensive question database
- ✅ **Practice Tests**: Full-length TOEIC practice tests

## 🚦 Development Status

| Feature           | Backend | Frontend | Mobile | Status      |
| ----------------- | ------- | -------- | ------ | ----------- |
| Authentication    | ✅      | ✅       | ✅     | Complete    |
| User Management   | ✅      | ✅       | ✅     | Complete    |
| Question System   | ✅      | ✅       | ✅     | Complete    |
| Test Engine       | ✅      | ✅       | ✅     | Complete    |
| Progress Tracking | 🚧      | 🚧       | 🚧     | In Progress |
| Audio Support     | 🚧      | 🚧       | 🚧     | In Progress |
| Offline Mode      | ❌      | ❌       | 🚧     | Planned     |

## 🎯 VS Code Workspace Features

- 🚀 **One-click development**: Start all servers with VS Code tasks
- 🔧 **Integrated debugging**: Debug all platforms from VS Code
- 📦 **Extension recommendations**: Auto-install recommended extensions
- 🎨 **Consistent formatting**: Shared code formatting rules
- 🔍 **Multi-project search**: Search across all projects

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** your changes: `git commit -m 'Add amazing feature'`
4. **Push** to branch: `git push origin feature/amazing-feature`
5. **Submit** a Pull Request

## 📈 Roadmap

- 🎯 **Q1 2025**: Complete audio support
- 🎯 **Q2 2025**: Add offline mode for mobile
- 🎯 **Q3 2025**: Advanced analytics dashboard
- 🎯 **Q4 2025**: AI-powered question recommendations

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 💬 Support & Community

- 📧 **Email**: support@leenglish.com
- 💬 **Discord**: [Join our community](https://discord.gg/leenglish)
- 🐛 **Issues**: [GitHub Issues](https://github.com/your-username/leenglish-toeic-platform/issues)
- 📖 **Wiki**: [Documentation Wiki](https://github.com/your-username/leenglish-toeic-platform/wiki)

---

<div align="center">

**⭐ Star this repository if you find it helpful! ⭐**

Made with ❤️ by the LeEnglish Team

</div>

## 🏗️ Project Structure

```
├── backend/           # Spring Boot (Java) API server
├── frontend/          # Next.js (React) web application
├── mobile/            # Flutter mobile application
├── .vscode/          # VS Code workspace settings
├── .gitignore        # Git ignore rules
└── README.md         # This file
```

## 🚀 Technology Stack

### Backend - Spring Boot

- **Framework**: Spring Boot 3.2.0
- **Language**: Java 17
- **Database**: H2 (development), MySQL (production)
- **Security**: Spring Security + JWT
- **Documentation**: OpenAPI 3 (Swagger)
- **Build Tool**: Maven

### Frontend - Next.js

- **Framework**: Next.js 14
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **UI Components**: Headless UI + Heroicons
- **HTTP Client**: Axios
- **Build Tool**: npm/yarn

### Mobile - Flutter

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Local Storage**: Hive

## ⚡ Quick Start

### Prerequisites

- Java 17+ (for Spring Boot backend)
- Node.js 18+ (for Next.js frontend)
- Flutter SDK 3.0+ (for mobile app)
- Maven (for Spring Boot)

### 1. Backend Setup (Spring Boot)

```bash
cd backend
mvn clean install
mvn spring-boot:run
# Server runs on http://localhost:8080
```

### 2. Frontend Setup (Next.js)

```bash
cd frontend
npm install
npm run dev
# App runs on http://localhost:3000
```

### 3. Mobile Setup (Flutter)

```bash
cd mobile
flutter pub get
flutter run
# Choose your target device
```

## 🔗 API Endpoints

### Health Check

- `GET /api/health` - Backend health status

### Authentication (Coming Soon)

- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/logout` - User logout

### User Management (Coming Soon)

- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile

### Tests & Questions (Coming Soon)

- `GET /api/tests` - Get available tests
- `GET /api/tests/{id}` - Get specific test
- `POST /api/tests/{id}/submit` - Submit test answers

## 🛠️ Development Workflow

1. **Start Backend**: `cd backend && mvn spring-boot:run`
2. **Start Frontend**: `cd frontend && npm run dev`
3. **Run Mobile**: `cd mobile && flutter run`

All three platforms can run simultaneously and will communicate through the Spring Boot API.

## 📁 Directory Structure

### Backend (Spring Boot)

```
backend/
├── src/main/java/com/leenglish/toeic/
│   ├── ToeicBackendApplication.java
│   ├── controller/
│   ├── service/
│   ├── repository/
│   ├── model/
│   ├── config/
│   └── dto/
├── src/main/resources/
├── pom.xml
└── README.md
```

### Frontend (Next.js)

```
frontend/
├── src/
│   ├── app/
│   ├── components/
│   ├── lib/
│   └── types/
├── package.json
├── next.config.js
├── tailwind.config.js
└── README.md
```

### Mobile (Flutter)

```
mobile/
├── lib/
│   ├── screens/
│   ├── widgets/
│   ├── services/
│   ├── models/
│   ├── providers/
│   └── utils/
├── assets/
├── pubspec.yaml
└── README.md
```

## 🔧 Configuration

### Environment Variables

**Backend (application.properties)**

```properties
server.port=8080
spring.datasource.url=jdbc:h2:mem:testdb
app.jwt.secret=mySecretKey
```

**Frontend (.env.local)**

```env
NEXT_PUBLIC_BACKEND_URL=http://localhost:8080
```

**Mobile**

- API base URL configured in services layer
- Points to http://localhost:8080 by default

## 🌟 Features

- **Multi-platform**: Web, mobile, and API
- **Modern Architecture**: Microservices-ready backend
- **Responsive Design**: Works on all screen sizes
- **Real-time Updates**: Live data synchronization
- **Scalable**: Ready for production deployment

## 🚧 Development Status

- ✅ Project structure setup
- ✅ Backend Spring Boot foundation
- ✅ Frontend Next.js setup
- ✅ Mobile Flutter foundation
- 🚧 Authentication system
- 🚧 Test management
- 🚧 User profiles
- 🚧 Progress tracking

## ✅ Setup Status

**COMPLETED:**

- ✅ Monorepo structure with Git initialization
- ✅ Spring Boot backend with REST API endpoints
- ✅ Next.js frontend with TypeScript and Tailwind CSS
- ✅ Flutter mobile app with Riverpod and GoRouter
- ✅ VS Code multi-root workspace configuration
- ✅ Comprehensive VS Code tasks for all projects
- ✅ VS Code launch configurations for debugging
- ✅ Basic authentication and question API endpoints
- ✅ Flutter state management with Riverpod providers
- ✅ Cross-platform .gitignore configuration

**READY FOR DEVELOPMENT:**

- 🚀 All three projects can be started independently
- 🚀 VS Code tasks available for parallel development
- 🚀 Basic API communication between frontend/mobile and backend
- 🚀 Authentication system foundation in place

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Make your changes
4. Commit: `git commit -am 'Add new feature'`
5. Push: `git push origin feature/new-feature`
6. Submit a pull request

## 📝 License

This project is licensed under the MIT License.

## 📞 Support

For support and questions, please open an issue on GitHub.
