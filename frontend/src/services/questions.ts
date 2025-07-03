/**
 * ================================================================
 * QUESTIONS SERVICE - API CALLS
 * ================================================================
 * Service for managing question-related API calls
 */

import { Question, QuestionAnswerRequest } from "../types";
import api from "./api";

export const questionsApiService = {
  /**
   * Get questions for a specific exercise
   */
  getQuestionsByExercise: async (exerciseId: number): Promise<Question[]> => {
    try {
      console.log(`🔍 Fetching questions for exercise ${exerciseId}...`);
      const response = await api.get(`/questions/exercise/${exerciseId}`);
      console.log(`✅ Questions response:`, response);
      return response.data || [];
    } catch (error: any) {
      console.error(
        `❌ Error fetching questions for exercise ${exerciseId}:`,
        error
      );
      throw error;
    }
  },

  /**
   * Submit answers for an exercise
   */
  submitExerciseAnswers: async (
    exerciseId: number,
    answers: QuestionAnswerRequest[]
  ): Promise<any> => {
    try {
      console.log(`📝 Submitting answers for exercise ${exerciseId}...`);
      const response = await api.post(
        `/questions/exercise/${exerciseId}/submit-all`,
        answers
      );
      console.log(`✅ Submit response:`, response);
      return response.data;
    } catch (error: any) {
      console.error(
        `❌ Error submitting answers for exercise ${exerciseId}:`,
        error
      );
      throw error;
    }
  },

  /**
   * Get free sample questions
   */
  getFreeQuestions: async (limit: number = 5): Promise<Question[]> => {
    try {
      console.log(`🔍 Fetching ${limit} free questions...`);
      const response = await api.get(`/questions/free?limit=${limit}`);
      console.log(`✅ Free questions response:`, response);
      return response.data || [];
    } catch (error: any) {
      console.error(`❌ Error fetching free questions:`, error);
      throw error;
    }
  },
};

export default questionsApiService;
