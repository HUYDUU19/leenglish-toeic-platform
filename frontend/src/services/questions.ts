/**
 * ================================================================
 * QUESTION SERVICE
 * ================================================================
 * Service để xử lý API calls liên quan đến questions
 */

import { Question } from "../types";
import { api } from "./api";

export const questionService = {
  /**
   * Lấy danh sách questions của một exercise
   */
  getQuestionsByExerciseId: async (exerciseId: number): Promise<Question[]> => {
    console.log(`🔍 Fetching questions for exercise ${exerciseId}...`);

    try {
      const response = await api.get(`/exercises/${exerciseId}/questions`);
      console.log("✅ Questions loaded:", response.data);
      return response.data;
    } catch (error) {
      console.error("❌ Error fetching questions:", error);
      throw error;
    }
  },

  /**
   * Lấy thông tin chi tiết của một question
   */
  getQuestionById: async (questionId: number): Promise<Question> => {
    console.log(`🔍 Fetching question ${questionId}...`);

    try {
      const response = await api.get(`/questions/${questionId}`);
      console.log("✅ Question loaded:", response.data);
      return response.data;
    } catch (error) {
      console.error("❌ Error fetching question:", error);
      throw error;
    }
  },

  /**
   * Submit answer cho một question
   */
  submitAnswer: async (questionId: number, answer: string): Promise<any> => {
    console.log(`📝 Submitting answer for question ${questionId}...`);

    try {
      const response = await api.post(`/questions/${questionId}/answer`, {
        answer,
      });
      console.log("✅ Answer submitted:", response.data);
      return response.data;
    } catch (error) {
      console.error("❌ Error submitting answer:", error);
      throw error;
    }
  },
  /**
   * Submit kết quả của một exercise
   */
  submitExerciseAnswers: async (
    exerciseId: number,
    answers: { questionId: number; selectedAnswer: string }[]
  ): Promise<any> => {
    console.log(`📊 Submitting answers for exercise ${exerciseId}...`);

    try {
      const response = await api.post(`/exercises/${exerciseId}/submit`, {
        answers,
      });
      console.log("✅ Exercise answers submitted:", response.data);
      return response.data;
    } catch (error) {
      console.error("❌ Error submitting exercise answers:", error);
      throw error;
    }
    //getExercises
  },
  //getExercises
  getExercises: async (lessonId: number): Promise<any[]> => {
    console.log(`🔍 Fetching exercises for lesson ${lessonId}...`);

    try {
      const response = await api.get(`/lessons/${lessonId}/exercises`);
      console.log("✅ Exercises loaded:", response.data);
      return response.data;
    } catch (error) {
      console.error("❌ Error fetching exercises:", error);
      throw error;
    }
  },
  //getQuestionsByExercise
  getQuestionsByExercise: async (exerciseId: number): Promise<any[]> => {
    console.log(`🔍 Fetching questions for exercise ${exerciseId}...`);
    try {
      const token = localStorage.getItem('auth_token');
      const response = await api.get(`/exercises/${exerciseId}/questions`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      });
      console.log("✅ Questions loaded:", response.data);
      return response.data;
    } catch (error) {
      console.error("❌ Error fetching questions:", error);
      throw error;
    }
  }


};
