/**
 * ================================================================
 * AUTHENTICATION SERVICE
 * ================================================================
 * Handles user authentication, registration, and session management
 * Integrates with Spring Boot backend auth endpoints
 */

import { LoginRequest, RegisterRequest, User } from "../types";
import api from "./api";
// CONSTANTS
// ================================================================

const TOKEN_KEY = "toeic_access_token";
const REFRESH_TOKEN_KEY = "toeic_refresh_token";
const USER_KEY = "toeic_current_user";
const API_BASE_URL =
  process.env.REACT_APP_API_BASE_URL || "http://localhost:8080/api";

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
// GLOBAL VARIABLES
// ================================================================

let refreshInterval: NodeJS.Timeout | null = null;

// ================================================================
// TOKEN MANAGEMENT
// ================================================================

export const setToken = (token: string): void => {
  localStorage.setItem(TOKEN_KEY, token);
  localStorage.setItem("authToken", token); // For backward compatibility
};

export const getToken = (): string | null => {
  // Try new key first, then fallback to old keys
  const token =
    localStorage.getItem(TOKEN_KEY) ||
    localStorage.getItem("authToken") ||
    localStorage.getItem("accessToken");

  if (token) {
    console.log("🎫 Retrieved token from localStorage");
  }
  return token;
};

export const setRefreshToken = (refreshToken: string): void => {
  localStorage.setItem(REFRESH_TOKEN_KEY, refreshToken);
  localStorage.setItem("refreshToken", refreshToken); // For compatibility
};

export const getRefreshToken = (): string | null => {
  return (
    localStorage.getItem(REFRESH_TOKEN_KEY) ||
    localStorage.getItem("refreshToken")
  );
};

export const removeToken = (): void => {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(REFRESH_TOKEN_KEY);
  localStorage.removeItem(USER_KEY);
  localStorage.removeItem("authToken"); // For backward compatibility
  localStorage.removeItem("currentUser"); // For backward compatibility
  localStorage.removeItem("accessToken");
  localStorage.removeItem("refreshToken");
  localStorage.removeItem("user");
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
    // Try new key first, then fallback to old key
    const userStr =
      localStorage.getItem(USER_KEY) || localStorage.getItem("currentUser");

    if (!userStr) return null;

    const user = JSON.parse(userStr);
    console.log("📱 Retrieved user from localStorage:", user);

    // Add computed isPremium property
    return {
      ...user,
      isPremium: user.membershipType === "PREMIUM" || user.role === "ADMIN",
    };
  } catch (error) {
    console.error("❌ Error parsing user from localStorage:", error);
    localStorage.removeItem(USER_KEY);
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

    console.log("🔍 Authentication check: true");
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
// AUTO REFRESH MECHANISM
// ================================================================

export const startAutoRefresh = (): void => {
  if (refreshInterval) {
    clearInterval(refreshInterval);
  }

  console.log("🔄 Starting auto-refresh timer");

  // Refresh token every 55 minutes (tokens usually expire in 1 hour)
  refreshInterval = setInterval(async () => {
    try {
      console.log("🔄 Auto-refreshing token...");
      await refreshAuthToken();
    } catch (error) {
      console.error("❌ Auto-refresh failed:", error);
      // If refresh fails, user will be logged out on next API call
    }
  }, 55 * 60 * 1000); // 55 minutes
};

export const stopAutoRefresh = (): void => {
  if (refreshInterval) {
    console.log("⏹️ Stopping auto-refresh timer");
    clearInterval(refreshInterval);
    refreshInterval = null;
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

    if (response.data && response.data.accessToken) {
      // Update stored tokens
      setToken(response.data.accessToken);

      if (response.data.refreshToken) {
        setRefreshToken(response.data.refreshToken);
      }

      console.log("✅ Token refreshed successfully");
      return response.data.accessToken;
    } else {
      throw new Error("Invalid refresh response - missing accessToken");
    }
  } catch (error: any) {
    console.error("❌ Token refresh error:", error);
    removeToken(); // Clear invalid tokens
    throw error;
  }
};

// ================================================================
// AUTH ACTIONS
// ================================================================

// ✅ SỬA: Hàm login chính - sử dụng LoginRequest interface
export const login = async (
  credentials: LoginRequest
): Promise<LoginResponse> => {
  try {
    // Only log in development mode
    if (process.env.NODE_ENV === "development") {
      console.log("� Login attempt for:", credentials.username);
    }

    const response = await api.post("/auth/login", credentials);
    const loginData = response.data;

    // Store authentication data
    if (loginData.accessToken) {
      setToken(loginData.accessToken);
      if (process.env.NODE_ENV === "development") {
        console.log("✅ Login successful");
      }
    }

    if (loginData.refreshToken) {
      setRefreshToken(loginData.refreshToken);
    }

    if (loginData.user) {
      setCurrentUser(loginData.user);
    }

    return loginData;
  } catch (error: any) {
    console.error("❌ Login failed:", error);

    // ✅ SỬA: Better error handling with specific messages
    if (error.response) {
      const status = error.response.status;
      const message = error.response.data?.message || "Login failed";

      console.error(`❌ Server error ${status}:`, message);

      if (status === 401) {
        throw new Error("Tên đăng nhập hoặc mật khẩu không đúng");
      } else if (status === 404) {
        throw new Error(
          "Dịch vụ đăng nhập không tìm thấy. Vui lòng kiểm tra server backend."
        );
      } else if (status === 500) {
        throw new Error("Lỗi server nội bộ. Vui lòng thử lại sau.");
      } else {
        throw new Error(message);
      }
    } else if (error.request) {
      console.error("❌ Network error:", error.request);
      throw new Error(
        "Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng."
      );
    } else {
      console.error("❌ Unknown error:", error.message);
      throw new Error("Đã xảy ra lỗi không mong muốn");
    }
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
//handleLogout
// ===============================================================
// ================================================================
// HANDLE LOGOUT FUNCTION
// ================================================================

/**
 * Handles the logout process with proper cleanup
 * Can be used directly in components with error handling
 */
export const handleLogout = async (): Promise<void> => {
  try {
    await logout();
    console.log("✅ Logout completed successfully");
  } catch (error) {
    console.error("❌ Error during logout:", error);
    // Even if logout fails, ensure local data is cleared
    clearAuthData();
    // Redirect to login page
    window.location.href = "/auth/login";
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
    stopAutoRefresh();
    // Force reload to reset app state and AuthContext
    window.location.href = "/auth/login";
    console.log("✅ Local data cleared and redirected to login");
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

// ================================================================
// UTILITY FUNCTIONS
// ================================================================

// Logout helper
export const clearAuthData = () => {
  console.log("🧹 Clearing auth data...");
  removeToken();
  removeCurrentUser();
  stopAutoRefresh();
};

// Export commonly used functions for backward compatibility
export {
  // Main auth functions
  login as authenticateUser,
  // Token functions
  getToken as getAuthToken,
  // User functions
  getCurrentUser as getUser,
  setToken as setAuthToken,
  setCurrentUser as setUser,
  logout as signOut,
};
