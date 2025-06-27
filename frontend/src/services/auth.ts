/**
 * ================================================================
 * AUTHENTICATION SERVICE
 * ================================================================
 * Handles user authentication, registration, and session management
 * Integrates with Spring Boot backend auth endpoints
 */

import { LoginRequest, RegisterRequest, User } from "../types";
import api from "./api";

// ================================================================
// CONSTANTS
// ================================================================

const TOKEN_KEY = "toeic_access_token";
const REFRESH_TOKEN_KEY = "toeic_refresh_token";
const USER_KEY = "toeic_current_user";

// ================================================================
// TYPES
// ================================================================

export interface LoginResponse {
  accessToken: string;
  refreshToken?: string;
  user: User;
  expiresIn?: number;
}

export interface AuthResponse {
  token: string;
  user: User;
  expiresAt: string;
}

// ================================================================
// TOKEN MANAGEMENT
// ================================================================

export const setToken = (token: string): void => {
  localStorage.setItem(TOKEN_KEY, token);
  localStorage.setItem("authToken", token); // For backward compatibility
};

export const getToken = (): string | null => {
  return localStorage.getItem(TOKEN_KEY) || localStorage.getItem("authToken");
};

export const setRefreshToken = (refreshToken: string): void => {
  localStorage.setItem(REFRESH_TOKEN_KEY, refreshToken);
};

export const getRefreshToken = (): string | null => {
  return localStorage.getItem(REFRESH_TOKEN_KEY);
};

export const removeToken = (): void => {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(REFRESH_TOKEN_KEY);
  localStorage.removeItem(USER_KEY);
  localStorage.removeItem("authToken"); // For backward compatibility
  localStorage.removeItem("currentUser"); // For backward compatibility
  localStorage.removeItem("tokenExpiry"); // For backward compatibility
};

// ================================================================
// USER MANAGEMENT
// ================================================================

export const setCurrentUser = (user: User): void => {
  localStorage.setItem(USER_KEY, JSON.stringify(user));
  localStorage.setItem("currentUser", JSON.stringify(user)); // For backward compatibility
};

export const getCurrentUser = (): User | null => {
  try {
    // Ưu tiên lấy từ key mới
    const userStr =
      localStorage.getItem("toeic_current_user") ||
      localStorage.getItem("currentUser");
    if (!userStr) return null;

    const user = JSON.parse(userStr);

    // Add computed isPremium property
    return {
      ...user,
      isPremium: user.membershipType === "PREMIUM" || user.role === "ADMIN",
    };
  } catch (error) {
    console.error("Error parsing user from localStorage:", error);
    localStorage.removeItem("toeic_current_user");
    localStorage.removeItem("currentUser");
    return null;
  }
};

export const removeCurrentUser = (): void => {
  localStorage.removeItem(USER_KEY);
  localStorage.removeItem("currentUser"); // For backward compatibility
};

// ================================================================
// AUTHENTICATION STATUS
// ================================================================

export const isAuthenticated = (): boolean => {
  const token = getToken();
  const user = getCurrentUser();

  if (!token || !user) {
    return false;
  }

  // Check if token is expired (basic check)
  try {
    const tokenPayload = JSON.parse(atob(token.split(".")[1]));
    const currentTime = Date.now() / 1000;

    if (tokenPayload.exp && tokenPayload.exp < currentTime) {
      console.warn("🔑 Token expired, removing authentication");
      removeToken();
      return false;
    }

    return true;
  } catch (error) {
    console.error("🔑 Error checking token validity:", error);
    // Don't clear token on parse error, just return true if we have token and user
    return !!(token && user);
  }
};

export const isTokenExpiringSoon = (): boolean => {
  const token = getToken();
  if (!token) return false;

  try {
    const tokenPayload = JSON.parse(atob(token.split(".")[1]));
    const currentTime = Date.now() / 1000;
    const fiveMinutesFromNow = currentTime + 5 * 60; // 5 minutes

    return tokenPayload.exp && tokenPayload.exp <= fiveMinutesFromNow;
  } catch (error) {
    console.error("Error checking token expiry:", error);
    return false;
  }
};

// ================================================================
// AUTH ACTIONS
// ================================================================

export const login = async (
  credentials: LoginRequest
): Promise<LoginResponse> => {
  try {
    console.log("🔐 Attempting login for:", credentials.username);

    const response = await api.post("/auth/login", credentials);
    const loginData = response.data;

    console.log("✅ Login response received:", {
      hasAccessToken: !!loginData.accessToken,
      hasUser: !!loginData.user,
      username: loginData.user?.username,
    });

    // Store authentication data
    if (loginData.accessToken) {
      setToken(loginData.accessToken);
      console.log("✅ Access token stored");
    }

    if (loginData.refreshToken) {
      setRefreshToken(loginData.refreshToken);
      console.log("✅ Refresh token stored");
    }

    if (loginData.user) {
      setCurrentUser(loginData.user);
      console.log("✅ User data stored:", loginData.user.username);
    }

    console.log("✅ Login successful and data persisted");
    return loginData;
  } catch (error: any) {
    console.error("❌ Login failed:", error);

    // Handle different error types
    if (error.message?.includes("timeout")) {
      throw new Error(
        "Login request timed out. Please check your internet connection and try again."
      );
    }

    if (error.response?.status === 401) {
      throw new Error("Invalid username or password");
    }

    if (error.response?.status === 404) {
      throw new Error(
        "Login service not found. Please check if the backend server is running."
      );
    }

    if (error.code === "ERR_NETWORK") {
      throw new Error(
        "Cannot connect to server. Please check if the backend is running on http://localhost:8080"
      );
    }

    throw new Error(
      error.response?.data?.message || error.message || "Login failed"
    );
  }
};

export const register = async (userData: RegisterRequest): Promise<User> => {
  try {
    console.log("📝 Attempting registration for:", userData.username);

    const response = await api.post("/auth/register", userData);
    const registrationData = response.data;

    console.log("✅ Registration successful:", registrationData);
    return registrationData.user || registrationData;
  } catch (error: any) {
    console.error("❌ Registration failed:", error);
    throw new Error(
      error.response?.data?.message || error.message || "Registration failed"
    );
  }
};

export const logout = async (): Promise<void> => {
  try {
    console.log("🚪 Logging out...");

    // Try to call logout endpoint (if available)
    try {
      await api.post("/auth/logout");
      console.log("✅ Server logout successful");
    } catch (error) {
      console.warn("⚠️ Server logout failed, but clearing local data anyway");
    }
  } finally {
    // Always clear local storage
    removeToken();
    removeCurrentUser();
    console.log("✅ Local data cleared");
  }
};

// ================================================================
// TOKEN REFRESH
// ================================================================

export const refreshAuthToken = async (): Promise<string | null> => {
  try {
    const refreshToken = getRefreshToken();
    if (!refreshToken) {
      throw new Error("No refresh token available");
    }

    console.log("🔄 Refreshing auth token...");
    const response = await api.post("/auth/refresh", {
      refreshToken: refreshToken,
    });

    const newToken = response.data.accessToken;
    if (newToken) {
      setToken(newToken);
      console.log("✅ Token refreshed successfully");
      return newToken;
    }

    return null;
  } catch (error) {
    console.error("❌ Token refresh failed:", error);
    removeToken(); // Clear invalid tokens
    return null;
  }
};

// ================================================================
// INITIALIZATION
// ================================================================

export function initializeAuth() {
  const userStr = localStorage.getItem("currentUser");
  if (userStr) {
    try {
      return JSON.parse(userStr);
    } catch {
      return null;
    }
  }
  return null;
}

// ================================================================
// ROLE-BASED UTILITIES
// ================================================================

export const isCurrentUserAdmin = (): boolean => {
  const user = getCurrentUser();
  return user?.role === "ADMIN";
};

export const canCurrentUserEditContent = (): boolean => {
  const user = getCurrentUser();
  return user?.role === "ADMIN" || user?.role === "COLLABORATOR";
};

export const canEditUserProfile = (targetUserId: number): boolean => {
  const currentUser = getCurrentUser();

  if (!currentUser) {
    return false;
  }

  // Admin can edit anyone
  if (currentUser.role === "ADMIN") {
    return true;
  }

  // Users can only edit their own profile
  return currentUser.id === targetUserId;
};

// ================================================================
// AUTO REFRESH MECHANISM
// ================================================================

let refreshInterval: NodeJS.Timeout | null = null;

export const startAutoRefresh = (): void => {
  if (refreshInterval) {
    clearInterval(refreshInterval);
  }

  refreshInterval = setInterval(async () => {
    if (isAuthenticated() && isTokenExpiringSoon()) {
      try {
        await refreshAuthToken();
        console.log("🔄 Token refreshed automatically");
      } catch (error) {
        console.error("❌ Failed to refresh token automatically:", error);
        // Don't auto-logout here, let user handle it
      }
    }
  }, 60000); // Check every minute
};

export const stopAutoRefresh = (): void => {
  if (refreshInterval) {
    clearInterval(refreshInterval);
    refreshInterval = null;
  }
};

// ================================================================
// PASSWORD MANAGEMENT
// ================================================================

export const changePassword = async (
  currentPassword: string,
  newPassword: string
): Promise<void> => {
  try {
    await api.put("/auth/change-password", {
      currentPassword,
      newPassword,
    });
    console.log("✅ Password changed successfully");
  } catch (error: any) {
    console.error("❌ Password change failed:", error);
    throw new Error(error.response?.data?.message || "Password change failed");
  }
};

export const requestPasswordReset = async (email: string): Promise<void> => {
  try {
    await api.post("/auth/forgot-password", { email });
    console.log("✅ Password reset requested");
  } catch (error: any) {
    console.error("❌ Password reset request failed:", error);
    throw new Error(
      error.response?.data?.message || "Password reset request failed"
    );
  }
};

export const resetPassword = async (
  token: string,
  newPassword: string
): Promise<void> => {
  try {
    await api.post("/auth/reset-password", {
      token,
      newPassword,
    });
    console.log("✅ Password reset successful");
  } catch (error: any) {
    console.error("❌ Password reset failed:", error);
    throw new Error(error.response?.data?.message || "Password reset failed");
  }
};
