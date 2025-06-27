import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/toeic_models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // Headers
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Generic request method
  Future<dynamic> _makeRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final uriWithParams =
          queryParams != null ? uri.replace(queryParameters: queryParams) : uri;

      late http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uriWithParams, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uriWithParams,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uriWithParams,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uriWithParams, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return null;
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // User API methods
  Future<List<User>> getAllUsers() async {
    final data = await _makeRequest('/users');
    return (data as List).map((json) => User.fromJson(json)).toList();
  }

  Future<User> getUserById(int id) async {
    final data = await _makeRequest('/users/$id');
    return User.fromJson(data);
  }

  Future<User> getUserByUsername(String username) async {
    final data = await _makeRequest('/users/username/$username');
    return User.fromJson(data);
  }

  Future<User> createUser(Map<String, dynamic> userData) async {
    final data = await _makeRequest('/users', method: 'POST', body: userData);
    return User.fromJson(data);
  }

  Future<User> updateUser(int id, Map<String, dynamic> userData) async {
    final data = await _makeRequest(
      '/users/$id',
      method: 'PUT',
      body: userData,
    );
    return User.fromJson(data);
  }

  Future<void> deleteUser(int id) async {
    await _makeRequest('/users/$id', method: 'DELETE');
  }

  Future<User> updateUserScore(int id, int score) async {
    final data = await _makeRequest(
      '/users/$id/score',
      method: 'POST',
      body: {'score': score},
    );
    return User.fromJson(data);
  }

  Future<List<User>> getLeaderboard() async {
    final data = await _makeRequest('/users/leaderboard');
    return (data as List).map((json) => User.fromJson(json)).toList();
  }

  // Question API methods
  Future<List<Question>> getAllQuestions({
    QuestionType? type,
    Section? section,
    int? difficulty,
    int? limit,
  }) async {
    final queryParams = <String, String>{};

    if (type != null) queryParams['type'] = type.toString().split('.').last;
    if (section != null) {
      queryParams['section'] = section.toString().split('.').last;
    }
    if (difficulty != null) queryParams['difficulty'] = difficulty.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    final data = await _makeRequest('/questions', queryParams: queryParams);
    return (data as List).map((json) => Question.fromJson(json)).toList();
  }

  Future<Question> getQuestionById(int id) async {
    final data = await _makeRequest('/questions/$id');
    return Question.fromJson(data);
  }

  Future<Question> createQuestion(Map<String, dynamic> questionData) async {
    final data = await _makeRequest(
      '/questions',
      method: 'POST',
      body: questionData,
    );
    return Question.fromJson(data);
  }

  Future<Question> updateQuestion(
    int id,
    Map<String, dynamic> questionData,
  ) async {
    final data = await _makeRequest(
      '/questions/$id',
      method: 'PUT',
      body: questionData,
    );
    return Question.fromJson(data);
  }

  Future<void> deleteQuestion(int id) async {
    await _makeRequest('/questions/$id', method: 'DELETE');
  }

  Future<List<Question>> getRandomQuestions({int limit = 10}) async {
    final data = await _makeRequest(
      '/questions/random',
      queryParams: {'limit': limit.toString()},
    );
    return (data as List).map((json) => Question.fromJson(json)).toList();
  }

  Future<List<Question>> getRandomQuestionsBySection(
    Section section, {
    int limit = 10,
  }) async {
    final sectionName = section.toString().split('.').last;
    final data = await _makeRequest(
      '/questions/section/$sectionName/random',
      queryParams: {'limit': limit.toString()},
    );
    return (data as List).map((json) => Question.fromJson(json)).toList();
  }

  Future<int> getQuestionCountBySection(Section section) async {
    final sectionName = section.toString().split('.').last;
    final data = await _makeRequest('/questions/count/section/$sectionName');
    return data as int;
  }

  Future<int> getQuestionCountByType(QuestionType type) async {
    final typeName = type.toString().split('.').last;
    final data = await _makeRequest('/questions/count/type/$typeName');
    return data as int;
  }

  // Auth API methods
  Future<Map<String, dynamic>> login(String username, String password) async {
    final data = await _makeRequest(
      '/auth/login',
      method: 'POST',
      body: {'username': username, 'password': password},
    );
    return {'user': User.fromJson(data['user']), 'token': data['token']};
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final data = await _makeRequest(
      '/auth/register',
      method: 'POST',
      body: userData,
    );
    return {'user': User.fromJson(data['user']), 'token': data['token']};
  }

  Future<void> logout() async {
    await _makeRequest('/auth/logout', method: 'POST');
  }
}
