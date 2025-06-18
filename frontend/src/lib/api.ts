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

  // User APIs
  async getAllUsers(): Promise<User[]> {
    return this.request<User[]>('/users');
  }

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

  // Auth APIs
  async login(credentials: { username: string; password: string }): Promise<{ user: User; token: string }> {
    return this.request<{ user: User; token: string }>('/auth/login', {
      method: 'POST',
      body: JSON.stringify(credentials),
    });
  }

  async register(userData: {
    username: string;
    email: string;
    password: string;
    fullName?: string;
  }): Promise<{ user: User; token: string }> {
    return this.request<{ user: User; token: string }>('/auth/register', {
      method: 'POST',
      body: JSON.stringify(userData),
    });
  }

  async logout(): Promise<void> {
    return this.request<void>('/auth/logout', {
      method: 'POST',
    });
  }
}

export const apiService = new ApiService();
