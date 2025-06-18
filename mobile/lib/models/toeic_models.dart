// Flutter Models
class User {
  final int id;
  final String username;
  final String email;
  final String? fullName;
  final UserRole role;
  final int currentLevel;
  final int totalScore;
  final int testsCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    required this.role,
    required this.currentLevel,
    required this.totalScore,
    required this.testsCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
      ),
      currentLevel: json['currentLevel'],
      totalScore: json['totalScore'],
      testsCompleted: json['testsCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'role': role.toString().split('.').last,
      'currentLevel': currentLevel,
      'totalScore': totalScore,
      'testsCompleted': testsCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

enum UserRole { USER, ADMIN }

class Question {
  final int id;
  final String content;
  final QuestionType type;
  final Section section;
  final int difficultyLevel;
  final String? audioUrl;
  final String? imageUrl;
  final List<Answer> answers;
  final DateTime createdAt;
  final DateTime updatedAt;

  Question({
    required this.id,
    required this.content,
    required this.type,
    required this.section,
    required this.difficultyLevel,
    this.audioUrl,
    this.imageUrl,
    required this.answers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      content: json['content'],
      type: QuestionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      section: Section.values.firstWhere(
        (e) => e.toString().split('.').last == json['section'],
      ),
      difficultyLevel: json['difficultyLevel'],
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'],
      answers:
          (json['answers'] as List)
              .map((answerJson) => Answer.fromJson(answerJson))
              .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.toString().split('.').last,
      'section': section.toString().split('.').last,
      'difficultyLevel': difficultyLevel,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'answers': answers.map((answer) => answer.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

enum QuestionType {
  LISTENING_PHOTO_DESCRIPTION,
  LISTENING_QUESTION_RESPONSE,
  LISTENING_CONVERSATION,
  LISTENING_SHORT_TALKS,
  READING_INCOMPLETE_SENTENCES,
  READING_TEXT_COMPLETION,
  READING_SINGLE_PASSAGE,
  READING_DOUBLE_PASSAGE,
  READING_TRIPLE_PASSAGE,
}

enum Section { LISTENING, READING }

class Answer {
  final int id;
  final String content;
  final bool isCorrect;
  final String optionLabel;
  final int questionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Answer({
    required this.id,
    required this.content,
    required this.isCorrect,
    required this.optionLabel,
    required this.questionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      content: json['content'],
      isCorrect: json['isCorrect'],
      optionLabel: json['optionLabel'],
      questionId: json['questionId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isCorrect': isCorrect,
      'optionLabel': optionLabel,
      'questionId': questionId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class TestResult {
  final int userId;
  final int score;
  final int questionsAnswered;
  final int correctAnswers;
  final Section section;
  final DateTime completedAt;

  TestResult({
    required this.userId,
    required this.score,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.section,
    required this.completedAt,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      userId: json['userId'],
      score: json['score'],
      questionsAnswered: json['questionsAnswered'],
      correctAnswers: json['correctAnswers'],
      section: Section.values.firstWhere(
        (e) => e.toString().split('.').last == json['section'],
      ),
      completedAt: DateTime.parse(json['completedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'score': score,
      'questionsAnswered': questionsAnswered,
      'correctAnswers': correctAnswers,
      'section': section.toString().split('.').last,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}
