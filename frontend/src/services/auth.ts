/**
 * ================================================================
 * AUTHENTICATION SERVICE
 * ================================================================
 * 
 * Handles user authentication, registration, and session management
 * Integrates with Spring Boot backend auth endpoints
 */

import {
  ApiResponse,
  AuthResponse,
  ChangePasswordRequest,
  LoginRequest,
  RegisterRequest,
  User
} from '../types';
import apiClient, { extractData, handleApiError } from './api';

// ========== AUTHENTICATION ENDPOINTS ==========

/**
 * Login user with username/password
 */
export const login = async (credentials: LoginRequest): Promise<AuthResponse> => {
  try {
    const response = await apiClient.post<any>('/auth/login', credentials);
    const backendData = response.data;
    
    if (!backendData.success) {
      throw new Error(backendData.message || 'Login failed');
    }
    
    // Transform backend response to frontend format
    const authData: AuthResponse = {
      token: backendData.accessToken,
      user: backendData.user,
      expiresAt: new Date(Date.now() + (backendData.expiresIn * 1000)).toISOString()
    };
    
    // Store auth data in localStorage
    localStorage.setItem('authToken', authData.token);
    localStorage.setItem('currentUser', JSON.stringify(authData.user));
    localStorage.setItem('tokenExpiry', authData.expiresAt);
    
    return authData;
  } catch (error: any) {
    const errorInfo = handleApiError(error);
    throw new Error(errorInfo.message);
  }
};

/**
 * Register new user
 */
export const register = async (userData: RegisterRequest): Promise<AuthResponse> => {
  try {
    const response = await apiClient.post<any>('/auth/register', userData);
    const backendData = response.data;
    
    if (!backendData.success) {
      throw new Error(backendData.message || 'Registration failed');
    }
    
    // Transform backend response to frontend format
    const authData: AuthResponse = {
      token: backendData.accessToken,
      user: backendData.user,
      expiresAt: new Date(Date.now() + (backendData.expiresIn * 1000)).toISOString()
    };
    
    // Store auth data in localStorage
    localStorage.setItem('authToken', authData.token);
    localStorage.setItem('currentUser', JSON.stringify(authData.user));
    localStorage.setItem('tokenExpiry', authData.expiresAt);
    
    return authData;
  } catch (error: any) {
    const errorInfo = handleApiError(error);
    throw new Error(errorInfo.message);
  }
};

/**
 * Logout user and clear session
 */
export const logout = async (): Promise<void> => {
  try {
    // Call backend logout endpoint
    await apiClient.post('/auth/logout');
  } catch (error) {
    // Continue with local logout even if backend call fails
    console.warn('Backend logout failed, continuing with local logout');
  } finally {
    // Clear local storage
    localStorage.removeItem('authToken');
    localStorage.removeItem('currentUser');
    localStorage.removeItem('tokenExpiry');
    
    // Redirect to login page
    window.location.href = '/login';
  }
};

/**
 * Refresh authentication token
 */
export const refreshToken = async (): Promise<AuthResponse> => {
  try {
    const response = await apiClient.post<ApiResponse<AuthResponse>>('/auth/refresh');
    const authData = extractData(response);
    
    // Update stored auth data
    localStorage.setItem('authToken', authData.token);
    localStorage.setItem('currentUser', JSON.stringify(authData.user));
    localStorage.setItem('tokenExpiry', authData.expiresAt);
    
    return authData;
  } catch (error: any) {
    // If refresh fails, logout user
    logout();
    const errorInfo = handleApiError(error);
    throw new Error(errorInfo.message);
  }
};

/**
 * Change user password
 */
export const changePassword = async (passwordData: ChangePasswordRequest): Promise<void> => {
  try {
    await apiClient.put<ApiResponse<void>>('/auth/change-password', passwordData);
  } catch (error: any) {
    const errorInfo = handleApiError(error);
    throw new Error(errorInfo.message);
  }
};

/**
 * Request password reset
 */
export const requestPasswordReset = async (email: string): Promise<void> => {
  try {
    await apiClient.post<ApiResponse<void>>('/auth/forgot-password', { email });
  } catch (error: any) {
    const errorInfo = handleApiError(error);
    throw new Error(errorInfo.message);
  }
};

/**
 * Reset password with token
 */
export const resetPassword = async (token: string, newPassword: string): Promise<void> => {
  try {
    await apiClient.post<ApiResponse<void>>('/auth/reset-password', { 
      token, 
      newPassword 
    });
  } catch (error: any) {
    const errorInfo = handleApiError(error);
    throw new Error(errorInfo.message);
  }
};

// ========== SESSION MANAGEMENT ==========

/**
 * Check if user is currently authenticated
 */
export const isAuthenticated = (): boolean => {
  const token = localStorage.getItem('authToken');
  const expiry = localStorage.getItem('tokenExpiry');
  
  if (!token || !expiry) {
    return false;
  }
  
  // Check if token is expired
  const expiryDate = new Date(expiry);
  const now = new Date();
  
  if (now >= expiryDate) {
    // Token expired, clear storage
    localStorage.removeItem('authToken');
    localStorage.removeItem('currentUser');
    localStorage.removeItem('tokenExpiry');
    return false;
  }
  
  return true;
};

/**
 * Get current authenticated user
 */
export const getCurrentUser = (): User | null => {
  const userData = localStorage.getItem('currentUser');
  
  if (!userData || !isAuthenticated()) {
    return null;
  }
  
  try {
    return JSON.parse(userData) as User;
  } catch (error) {
    console.error('Failed to parse user data:', error);
    localStorage.removeItem('currentUser');
    return null;
  }
};

/**
 * Update current user data in localStorage
 */
export const updateCurrentUser = (user: User): void => {
  localStorage.setItem('currentUser', JSON.stringify(user));
};

/**
 * Check if token is about to expire (within 5 minutes)
 */
export const isTokenExpiringSoon = (): boolean => {
  const expiry = localStorage.getItem('tokenExpiry');
  
  if (!expiry) {
    return false;
  }
  
  const expiryDate = new Date(expiry);
  const now = new Date();
  const fiveMinutesFromNow = new Date(now.getTime() + 5 * 60 * 1000);
  
  return expiryDate <= fiveMinutesFromNow;
};

// ========== AUTO REFRESH MECHANISM ==========

let refreshInterval: NodeJS.Timeout | null = null;

/**
 * Start automatic token refresh
 */
export const startAutoRefresh = (): void => {
  if (refreshInterval) {
    clearInterval(refreshInterval);
  }
  
  refreshInterval = setInterval(async () => {
    if (isAuthenticated() && isTokenExpiringSoon()) {
      try {
        await refreshToken();
        console.log('🔄 Token refreshed automatically');
      } catch (error) {
        console.error('❌ Failed to refresh token:', error);
        logout();
      }
    }
  }, 60000); // Check every minute
};

/**
 * Stop automatic token refresh
 */
export const stopAutoRefresh = (): void => {
  if (refreshInterval) {
    clearInterval(refreshInterval);
    refreshInterval = null;
  }
};

// ========== ROLE-BASED UTILITIES ==========

/**
 * Check if current user has admin role
 */
export const isCurrentUserAdmin = (): boolean => {
  const user = getCurrentUser();
  return user?.role === 'ADMIN';
};

/**
 * Check if current user can edit content (ADMIN or COLLABORATOR)
 */
export const canCurrentUserEditContent = (): boolean => {
  const user = getCurrentUser();
  return user?.role === 'ADMIN' || user?.role === 'COLLABORATOR';
};

/**
 * Check if current user can edit specific user profile
 */
export const canEditUserProfile = (targetUserId: number): boolean => {
  const currentUser = getCurrentUser();
  
  if (!currentUser) {
    return false;
  }
  
  // Admin can edit anyone
  if (currentUser.role === 'ADMIN') {
    return true;
  }
  
  // Users can only edit their own profile
  return currentUser.id === targetUserId;
};
