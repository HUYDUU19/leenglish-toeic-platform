/**
 * ================================================================
 * API SERVICE CONFIGURATION
 * ================================================================
 *
 * Central configuration for all API calls to the Spring Boot backend
 * Base URL and common headers setup
 */

import { AxiosError, AxiosResponse } from "axios";
import { ApiResponse, ErrorResponse } from "../types";
import apiClient from "./apiRequest";

// ========== REQUEST INTERCEPTOR ==========

apiClient.interceptors.request.use(
  (config) => {
    // Add authorization token if available
    const token = localStorage.getItem("accessToken");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    // Add current user info for authorization checks
    const currentUser = localStorage.getItem("currentUser");
    if (currentUser) {
      config.headers["X-Current-User"] = currentUser;
    }

    console.log(
      `🚀 API Request: ${config.method?.toUpperCase()} ${config.url}`
    );
    return config;
  },
  (error) => {
    console.error("❌ Request Error:", error);
    return Promise.reject(error);
  }
);

// ========== RESPONSE INTERCEPTOR ==========

apiClient.interceptors.response.use(
  (response: AxiosResponse) => {
    console.log(
      `✅ API Response: ${response.config.method?.toUpperCase()} ${
        response.config.url
      } - ${response.status}`
    );
    return response;
  },
  (error: AxiosError) => {
    console.error(
      `❌ API Error: ${error.config?.method?.toUpperCase()} ${
        error.config?.url
      } - ${error.response?.status}`,
      error.response?.data
    );

    // Handle common error scenarios
    if (error.response?.status === 401) {
      // Unauthorized - redirect to login
      localStorage.removeItem("accessToken");
      localStorage.removeItem("currentUser");
      window.location.href = "/login";
    }

    if (error.response?.status === 403) {
      // Forbidden - show access denied message
      console.warn("🚫 Access Denied: Insufficient permissions");
    }

    return Promise.reject(error);
  }
);

// ========== HELPER FUNCTIONS ==========

/**
 * Extract data from API response
 */
export const extractData = <T>(response: AxiosResponse<ApiResponse<T>>): T => {
  return response.data.data;
};

/**
 * Handle API errors consistently
 */
export const handleApiError = (error: AxiosError): ErrorResponse => {
  if (error.response?.data) {
    return error.response.data as ErrorResponse;
  }

  return {
    success: false,
    message: error.message || "An unexpected error occurred",
    details: error.code,
    timestamp: new Date().toISOString(),
  };
};

/**
 * Check if current user has admin privileges
 */
export const isAdmin = (): boolean => {
  const currentUser = localStorage.getItem("currentUser");
  if (!currentUser) return false;

  try {
    const user = JSON.parse(currentUser);
    return user.role === "ADMIN";
  } catch {
    return false;
  }
};

/**
 * Check if current user has collaborator or admin privileges
 */
export const canEditContent = (): boolean => {
  const currentUser = localStorage.getItem("currentUser");
  if (!currentUser) return false;

  try {
    const user = JSON.parse(currentUser);
    return user.role === "ADMIN" || user.role === "COLLABORATOR";
  } catch {
    return false;
  }
};

/**
 * Get current user ID
 */
export const getCurrentUserId = (): number | null => {
  const currentUser = localStorage.getItem("currentUser");
  if (!currentUser) return null;

  try {
    const user = JSON.parse(currentUser);
    return user.id;
  } catch {
    return null;
  }
};

/**
 * Build query parameters string
 */
export const buildQueryParams = (params: Record<string, any>): string => {
  const searchParams = new URLSearchParams();

  Object.entries(params).forEach(([key, value]) => {
    if (value !== undefined && value !== null && value !== "") {
      searchParams.append(key, value.toString());
    }
  });

  const queryString = searchParams.toString();
  return queryString ? `?${queryString}` : "";
};

/**
 * Generic API request wrapper
 */
export const apiRequest = async <T>(
  method: "GET" | "POST" | "PUT" | "DELETE",
  url: string,
  data?: any
): Promise<T> => {
  try {
    let response;

    switch (method) {
      case "GET":
        response = await apiClient.get(url);
        break;
      case "POST":
        response = await apiClient.post(url, data);
        break;
      case "PUT":
        response = await apiClient.put(url, data);
        break;
      case "DELETE":
        response = await apiClient.delete(url);
        break;
      default:
        throw new Error(`Unsupported HTTP method: ${method}`);
    }

    return response.data;
  } catch (error: any) {
    throw handleApiError(error);
  }
};

export { apiClient as api };
export default apiClient;
