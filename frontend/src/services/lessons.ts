/**
 * ================================================================
 * LESSON SERVICE - API CALLS
 * ================================================================
 *
 * Service for managing lesson-related API calls
 */

import { Exercise, Lesson } from "../types";
import api from "./api";

export const lessonService = {
  /**
   * Get all free lessons (public access)
   */
  getFreeLessons: async (): Promise<Lesson[]> => {
    try {
      console.log("🔍 Fetching free lessons...");
      const response = await api.get("/lessons/free");
      console.log("✅ Free lessons response:", response);
      console.log("✅ Free lessons data:", response.data);

      // Ensure we return an array
      if (!response.data) {
        console.warn("⚠️ No data in response");
        return [];
      }

      if (!Array.isArray(response.data)) {
        console.warn("⚠️ Response data is not an array:", response.data);
        return [];
      }

      return response.data;
    } catch (error: any) {
      console.error("❌ Error fetching free lessons:", error);
      console.error("❌ Error response:", error.response?.data);
      throw error;
    }
  },

  /**
   * Get all lessons (requires authentication)
   */
  getAllLessons: async (): Promise<Lesson[]> => {
    try {
      console.log("🔍 Fetching all lessons...");
      const response = await api.get("/lessons");
      console.log("✅ All lessons response:", response);
      console.log("✅ All lessons data:", response.data);

      // Ensure we return an array
      if (!response.data) {
        console.warn("⚠️ No data in response");
        return [];
      }

      if (!Array.isArray(response.data)) {
        console.warn("⚠️ Response data is not an array:", response.data);
        return [];
      }

      return response.data;
    } catch (error: any) {
      console.error("❌ Error fetching all lessons:", error);
      console.error("❌ Error response:", error.response?.data);
      throw error;
    }
  },

  /**
   * Get lesson by ID (free or authenticated based on lesson)
   */
  getLessonById: async (id: number): Promise<Lesson> => {
    try {
      console.log(`🔍 Fetching lesson ${id}...`);
      // Try free endpoint first
      const response = await api.get(`/lessons/free/${id}`);
      console.log(`✅ Lesson ${id} response:`, response);
      return response.data;
    } catch (error: any) {
      console.log(
        `⚠️ Free lesson ${id} failed, trying authenticated endpoint...`
      );
      // If free fails, try authenticated endpoint
      if (error.response?.status === 404 || error.response?.status === 403) {
        try {
          const response = await api.get(`/lessons/${id}`);
          console.log(`✅ Authenticated lesson ${id} response:`, response);
          return response.data;
        } catch (authError: any) {
          console.error(
            `❌ Authenticated lesson ${id} also failed:`,
            authError
          );
          throw authError;
        }
      }
      console.error(`❌ Error fetching lesson ${id}:`, error);
      throw error;
    }
  },

  /**
   * Get exercises for a lesson
   */
  getLessonExercises: async (lessonId: number): Promise<Exercise[]> => {
    try {
      const response = await api.get(`/lessons/${lessonId}/exercises`);
      return response.data || [];
    } catch (error: any) {
      console.error(`Error fetching exercises for lesson ${lessonId}:`, error);
      throw error;
    }
  },

  /**
   * Get specific exercise
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
      console.error(
        `Error fetching exercise ${exerciseId} for lesson ${lessonId}:`,
        error
      );
      throw error;
    }
  },
};

export default lessonService;
