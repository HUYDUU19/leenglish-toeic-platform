import { Exercise, Question } from "../types";
import api from "./api";

export const exerciseService = {
  /**
   * Get exercise by ID
   */
  getExercise: async (
    lessonId: number,
    exerciseId: number
  ): Promise<Exercise> => {
    try {
      const response = await api.get(
        `/lessons/${lessonId}/exercises/${exerciseId}`
      );
      return response.data;
    } catch (error: any) {
      console.error(`Error fetching exercise ${exerciseId}:`, error);
      throw error;
    }
  },

  /**
   * Get questions for an exercise
   */
  getExerciseQuestions: async (exerciseId: number): Promise<Question[]> => {
    try {
      const response = await api.get(`/exercises/${exerciseId}/questions`);
      return response.data || [];
    } catch (error: any) {
      console.error(
        `Error fetching questions for exercise ${exerciseId}:`,
        error
      );
      throw error;
    }
  },

  /**
   * Submit exercise answers
   */
  submitExercise: async (submissionData: any): Promise<any> => {
    try {
      const response = await api.post("/exercises/submit", submissionData);
      return response.data;
    } catch (error: any) {
      console.error("Error submitting exercise:", error);
      throw error;
    }
  },

  /**
   * Get exercise results
   */
  getExerciseResults: async (
    exerciseId: number,
    userId: number
  ): Promise<any> => {
    try {
      const response = await api.get(
        `/exercises/${exerciseId}/results/${userId}`
      );
      return response.data;
    } catch (error: any) {
      console.error("Error fetching exercise results:", error);
      throw error;
    }
  },
};
