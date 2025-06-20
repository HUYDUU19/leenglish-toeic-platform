/**
 * ================================================================
 * LESSON SERVICE - API CALLS
 * ================================================================
 * 
 * Service for managing lesson-related API calls
 */

import { Comment, Exercise, Lesson } from '../types';
import apiClient from './api';

export const lessonService = {
  /**
   * Get all lessons
   */
  getLessons: async (): Promise<Lesson[]> => {
    try {
      const response = await apiClient.get('/lessons');
      return response.data;
    } catch (error) {
      console.error('Error fetching lessons:', error);
      // Return fallback data if API fails
      return [
        {
          id: 1,
          title: 'Basic Greetings and Introductions',
          description: 'Learn essential greetings and how to introduce yourself in English',
          level: 'A1',
          isPremium: false,
          orderIndex: 1,
          imageUrl: '/images/lesson1.jpg'
        },
        {
          id: 2,
          title: 'Present Simple Tense',
          description: 'Understanding and using present simple tense in everyday situations',
          level: 'A1',
          isPremium: false,
          orderIndex: 2,
          imageUrl: '/images/lesson2.jpg'
        },
        {
          id: 3,
          title: 'Numbers and Time',
          description: 'Learn numbers, dates, and how to tell time in English',
          level: 'A1',
          isPremium: true,
          orderIndex: 3,
          imageUrl: '/images/lesson3.jpg'
        },
        {
          id: 4,
          title: 'Past Simple Tense',
          description: 'Learn to talk about past events and experiences',
          level: 'A2',
          isPremium: true,
          orderIndex: 4,
          imageUrl: '/images/lesson4.jpg'
        },
        {
          id: 5,
          title: 'Food and Restaurants',
          description: 'Vocabulary and phrases for ordering food and dining out',
          level: 'A2',
          isPremium: true,
          orderIndex: 5,
          imageUrl: '/images/lesson5.jpg'
        },
        {
          id: 6,
          title: 'Future Tense and Plans',
          description: 'Express future intentions and make plans',
          level: 'B1',
          isPremium: true,
          orderIndex: 6,
          imageUrl: '/images/lesson6.jpg'
        }
      ];
    }
  },

  /**
   * Get lesson by ID
   */
  getLessonById: async (id: number): Promise<Lesson> => {
    try {
      const response = await apiClient.get(`/lessons/${id}`);
      return response.data;
    } catch (error) {
      console.error('Error fetching lesson:', error);
      throw error;
    }
  },

  /**
   * Get lessons by level
   */
  getLessonsByLevel: async (level: string): Promise<Lesson[]> => {
    try {
      const response = await apiClient.get(`/lessons?level=${level}`);
      return response.data;
    } catch (error) {
      console.error('Error fetching lessons by level:', error);
      throw error;
    }
  },

  /**
   * Get premium lessons
   */
  getPremiumLessons: async (): Promise<Lesson[]> => {
    try {
      const response = await apiClient.get('/lessons?premium=true');
      return response.data;
    } catch (error) {
      console.error('Error fetching premium lessons:', error);
      throw error;
    }
  },

  /**
   * Get free lessons
   */
  getFreeLessons: async (): Promise<Lesson[]> => {
    try {
      const response = await apiClient.get('/lessons?premium=false');
      return response.data;
    } catch (error) {
      console.error('Error fetching free lessons:', error);
      throw error;
    }
  },

  /**
   * Get exercises for a lesson
   */
  getLessonExercises: async (lessonId: number): Promise<Exercise[]> => {
    try {
      const response = await apiClient.get(`/lessons/${lessonId}/exercises`);
      return response.data;
    } catch (error) {
      console.error('Error fetching lesson exercises:', error);
      throw error;
    }
  },

  /**
   * Get comments for a lesson
   */
  getLessonComments: async (lessonId: number): Promise<Comment[]> => {
    try {
      const response = await apiClient.get(`/lessons/${lessonId}/comments`);
      return response.data;
    } catch (error) {
      console.error('Error fetching lesson comments:', error);
      throw error;
    }
  },

  /**
   * Add comment to lesson
   */
  addLessonComment: async (lessonId: number, content: string): Promise<Comment> => {
    try {
      const response = await apiClient.post(`/lessons/${lessonId}/comments`, {
        content
      });
      return response.data;
    } catch (error) {
      console.error('Error adding lesson comment:', error);
      throw error;
    }
  },

  /**
   * Search lessons
   */
  searchLessons: async (query: string): Promise<Lesson[]> => {
    try {
      const response = await apiClient.get(`/lessons/search?q=${encodeURIComponent(query)}`);
      return response.data;
    } catch (error) {
      console.error('Error searching lessons:', error);
      throw error;
    }
  },

  /**
   * Mark lesson as completed
   */
  markLessonCompleted: async (lessonId: number): Promise<void> => {
    try {
      await apiClient.post(`/lessons/${lessonId}/complete`);
    } catch (error) {
      console.error('Error marking lesson as completed:', error);
      throw error;
    }
  },

  /**
   * Get user's lesson progress
   */
  getUserLessonProgress: async (lessonId: number): Promise<any> => {
    try {
      const response = await apiClient.get(`/lessons/${lessonId}/progress`);
      return response.data;
    } catch (error) {
      console.error('Error fetching lesson progress:', error);
      throw error;
    }
  }
};

export default lessonService;
