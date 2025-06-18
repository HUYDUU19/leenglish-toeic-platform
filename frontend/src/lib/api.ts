// API Service for frontend
import { Question, QuestionType, Section, User } from '@/types';

// Fallback API URL configuration
const API_BASE_URL = 'http://localhost:8080/api';

class ApiService {
  private async request<T>(endpoint: string, options?: RequestInit): Promise<T> {
    const url = `${API_BASE_URL}${endpoint}`;
    
    const config: RequestInit = {
      headers: {
        'Content-Type': 'application/json',
        ...options?.headers,
      },
      ...options,
    };

    try {
      const response = await fetch(url, config);
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error('API request failed:', error);
      throw error;
    }
  }

  async get<T>(endpoint: string, token?: string): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'GET',
      headers: token ? { 'Authorization': `Bearer ${token}` } : {},
    });
  }

  async post<T>(endpoint: string, data?: any, token?: string): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'POST',
      body: data ? JSON.stringify(data) : undefined,
      headers: token ? { 'Authorization': `Bearer ${token}` } : {},
    });
  }

  async put<T>(endpoint: string, data?: any, token?: string): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'PUT',
      body: data ? JSON.stringify(data) : undefined,
      headers: token ? { 'Authorization': `Bearer ${token}` } : {},
    });
  }

  async delete<T>(endpoint: string, token?: string): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'DELETE',
      headers: token ? { 'Authorization': `Bearer ${token}` } : {},
    });
  }

  // Authentication methods
  async login(credentials: { username: string; password: string }): Promise<{
    success: boolean;
    message: string;
    accessToken?: string;
    refreshToken?: string;
    user?: {
      id: number;
      username: string;
      email: string;
      fullName: string;
      role: string;
      redirectUrl: string;
    }
  }> {
    return this.request('/auth/login', {
      method: 'POST',
      body: JSON.stringify(credentials),
    });
  }

  async register(userData: { 
    username: string; 
    email: string; 
    password: string; 
    fullName: string;
  }): Promise<{
    success: boolean;
    message: string;
    accessToken?: string;
    refreshToken?: string;
    user?: {
      id: number;
      username: string;
      email: string;
      fullName: string;
      role: string;
      redirectUrl: string;
    }
  }> {
    return this.request('/auth/register', {
      method: 'POST',
      body: JSON.stringify(userData),
    });
  }

  async getCurrentUser(token: string): Promise<{
    success: boolean;
    user?: {
      id: number;
      username: string;
      email: string;
      fullName: string;
      role: string;
    }
  }> {
    return this.request('/auth/me', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });
  }

  async refreshToken(refreshToken: string): Promise<{
    success: boolean;
    accessToken?: string;
    message: string;
  }> {
    return this.request('/auth/refresh', {
      method: 'POST',
      body: JSON.stringify({ refreshToken }),
    });
  }

  async logout(token: string): Promise<{ success: boolean; message: string }> {
    return this.request('/auth/logout', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });
  }

  // Admin methods
  async getAdminDashboard(token: string): Promise<{
    success: boolean;
    stats?: {
      totalUsers: number;
      totalExercises: number;
      totalLessons: number;
    };
    message: string;
  }> {
    return this.request('/admin/dashboard', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });
  }

  async getAllUsers(token: string): Promise<{
    success: boolean;
    users?: User[];
    message: string;
  }> {
    return this.request('/admin/users', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });
  }

  async activateUser(userId: number, token: string): Promise<{
    success: boolean;
    message: string;
  }> {
    return this.request(`/admin/users/${userId}/activate`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });
  }

  async deactivateUser(userId: number, token: string): Promise<{
    success: boolean;
    message: string;
  }> {
    return this.request(`/admin/users/${userId}/deactivate`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });
  }
  // User APIs (for regular users)
  async getUserById(id: number): Promise<User> {
    return this.request<User>(`/users/${id}`);
  }

  async getUserByUsername(username: string): Promise<User> {
    return this.request<User>(`/users/username/${username}`);
  }

  async createUser(userData: {
    username: string;
    email: string;
    password: string;
    fullName?: string;
  }): Promise<User> {
    return this.request<User>('/users', {
      method: 'POST',
      body: JSON.stringify(userData),
    });
  }

  async updateUser(id: number, userData: Partial<User>): Promise<User> {
    return this.request<User>(`/users/${id}`, {
      method: 'PUT',
      body: JSON.stringify(userData),
    });
  }

  async deleteUser(id: number): Promise<void> {
    return this.request<void>(`/users/${id}`, {
      method: 'DELETE',
    });
  }

  async updateUserScore(id: number, score: number): Promise<User> {
    return this.request<User>(`/users/${id}/score`, {
      method: 'POST',
      body: JSON.stringify({ score }),
    });
  }

  async getLeaderboard(): Promise<User[]> {
    return this.request<User[]>('/users/leaderboard');
  }

  // Question APIs
  async getAllQuestions(params?: {
    type?: QuestionType;
    section?: Section;
    difficulty?: number;
    limit?: number;
  }): Promise<Question[]> {
    const searchParams = new URLSearchParams();
    
    if (params?.type) searchParams.append('type', params.type);
    if (params?.section) searchParams.append('section', params.section);
    if (params?.difficulty) searchParams.append('difficulty', params.difficulty.toString());
    if (params?.limit) searchParams.append('limit', params.limit.toString());

    const query = searchParams.toString();
    return this.request<Question[]>(`/questions${query ? `?${query}` : ''}`);
  }

  async getQuestionById(id: number): Promise<Question> {
    return this.request<Question>(`/questions/${id}`);
  }

  async createQuestion(questionData: Omit<Question, 'id' | 'createdAt' | 'updatedAt'>): Promise<Question> {
    return this.request<Question>('/questions', {
      method: 'POST',
      body: JSON.stringify(questionData),
    });
  }

  async updateQuestion(id: number, questionData: Partial<Question>): Promise<Question> {
    return this.request<Question>(`/questions/${id}`, {
      method: 'PUT',
      body: JSON.stringify(questionData),
    });
  }

  async deleteQuestion(id: number): Promise<void> {
    return this.request<void>(`/questions/${id}`, {
      method: 'DELETE',
    });
  }

  async getRandomQuestions(limit: number = 10): Promise<Question[]> {
    return this.request<Question[]>(`/questions/random?limit=${limit}`);
  }

  async getRandomQuestionsBySection(section: Section, limit: number = 10): Promise<Question[]> {
    return this.request<Question[]>(`/questions/section/${section}/random?limit=${limit}`);
  }

  async getQuestionCountBySection(section: Section): Promise<number> {
    return this.request<number>(`/questions/count/section/${section}`);
  }

  async getQuestionCountByType(type: QuestionType): Promise<number> {
    return this.request<number>(`/questions/count/type/${type}`);
  }

  // Progress tracking methods
  async getDailyActivity(userId: number, days: number = 7, token?: string): Promise<any> {
    return this.get(`/progress/user/${userId}/daily-activity?days=${days}`, token);
  }

  async getProgressSummary(userId: number, token?: string): Promise<any> {
    return this.get(`/progress/user/${userId}/summary`, token);
  }

  async getWeeklyProgress(userId: number, token?: string): Promise<any> {
    return this.get(`/progress/user/${userId}/weekly-progress`, token);
  }

  async getStudyStreak(userId: number, token?: string): Promise<number> {
    return this.get(`/progress/user/${userId}/stats/streak`, token);
  }

  async getUserProgress(userId: number, token?: string): Promise<any[]> {
    return this.get(`/progress/user/${userId}`, token);
  }

  async updateProgress(userId: number, lessonId: number, progressPercentage: number, timeSpent: number, token?: string): Promise<any> {
    return this.request(`/progress/update`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        ...(token ? { 'Authorization': `Bearer ${token}` } : {}),
      },
      body: new URLSearchParams({
        userId: userId.toString(),
        lessonId: lessonId.toString(),
        progressPercentage: progressPercentage.toString(),
        timeSpent: timeSpent.toString(),
      }),
    });
  }

  async addTimeSpent(userId: number, lessonId: number, additionalMinutes: number, token?: string): Promise<any> {
    return this.put(`/progress/user/${userId}/lesson/${lessonId}/add-time`, 
      { additionalMinutes }, token);
  }
}

export const apiService = new ApiService();
