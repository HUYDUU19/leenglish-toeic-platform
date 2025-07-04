import React, { useContext, useEffect, useState } from 'react';
import { getCurrentUser, getToken, startAutoRefresh, stopAutoRefresh } from '../services/auth';
import { User } from '../types';

export interface AuthContextType {
    user: User | null; // For backward compatibility
    currentUser: User | null; // Primary user property
    login: (email: string, password: string) => Promise<void>; // Fixed signature
    loginWithUserData: (user: User, accessToken: string) => void; // NEW: For direct user data login
    logout: () => void;
    signOut: () => void;
    updateCurrentUser: (user: User) => void;
    isAuthenticated: boolean;
    loading: boolean;
}

export const AuthContext = React.createContext<AuthContextType>({
    user: null,
    currentUser: null,
    isAuthenticated: false,
    loading: true,
    login: async () => { }, // Fixed default to match signature
    loginWithUserData: () => { }, // NEW: Default for loginWithUserData
    logout: () => { },
    signOut: () => { },
    updateCurrentUser: () => { },
});

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const [loading, setLoading] = useState(true);
    const [currentUser, setCurrentUser] = useState<User | null>(null);

    useEffect(() => {
        console.log('🔍 AuthProvider: Checking authentication status...');

        // Use the auth service to get user and token with consistent keys
        const user = getCurrentUser();
        const token = getToken();

        if (user && token) {
            console.log('✅ User authenticated:', user.email || user.username);
            setCurrentUser(user);
            setIsAuthenticated(true);
            // Start auto-refresh for authenticated users
            startAutoRefresh();
        } else {
            console.log('❌ No valid authentication found');
            setCurrentUser(null);
            setIsAuthenticated(false);
        }
        setLoading(false);

        // Cleanup on unmount
        return () => {
            stopAutoRefresh();
        };
    }, []);

    // ✅ FIXED: Proper login function for AuthContext
    const login = async (email: string, password: string): Promise<void> => {
        try {
            console.log('🔑 AuthContext: Attempting login for:', email);

            // ✅ Import the login function from auth service
            const { login: authLogin } = await import('../services/auth');

            // ✅ Call with proper LoginRequest format
            const response = await authLogin({
                username: email, // Backend expects username field
                password: password
            });

            if (response.user && response.accessToken) {
                console.log('✅ Login successful, storing auth data...');
                setCurrentUser(response.user);
                setIsAuthenticated(true);
                startAutoRefresh();
                console.log('✅ AuthContext: Login completed successfully');
            } else {
                throw new Error('Invalid login response - missing user or accessToken');
            }
        } catch (error: any) {
            console.error('❌ AuthContext login error:', error);
            throw error; // Re-throw so components can handle the error
        }
    };

    // ✅ NEW: Function to handle login with existing user data (for after successful API call)
    const loginWithUserData = (user: User, accessToken: string) => {
        console.log('🔑 AuthContext: Logging in with user data:', user.email || user.username);

        // Store tokens using auth service functions
        const { setToken, setCurrentUser: setAuthUser } = require('../services/auth');
        setToken(accessToken);
        setAuthUser(user);

        // Update context state
        setCurrentUser(user);
        setIsAuthenticated(true);
        startAutoRefresh();

        console.log('✅ AuthContext: Login with user data completed');
    };

    const logout = () => {
        console.log('🚪 AuthContext: Logging out...');

        // Clear all possible token keys
        localStorage.removeItem('toeic_current_user');
        localStorage.removeItem('toeic_access_token');
        localStorage.removeItem('toeic_refresh_token');
        localStorage.removeItem('currentUser');
        localStorage.removeItem('authToken');
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        localStorage.removeItem('user');
        setCurrentUser(null);
        setIsAuthenticated(false);
        stopAutoRefresh();

        console.log('✅ Logout completed');
    };

    const signOut = () => {
        console.log('🚪 AuthContext: Signing out...');
        logout(); // Sử dụng logout function
    };

    const updateCurrentUser = (updatedUser: User) => {
        console.log('👤 AuthContext: Updating user info...');

        localStorage.setItem('toeic_current_user', JSON.stringify(updatedUser));
        localStorage.setItem('currentUser', JSON.stringify(updatedUser)); // For backward compatibility
        setCurrentUser(updatedUser);

        console.log('✅ User info updated');
    };

    return (
        <AuthContext.Provider
            value={{
                user: currentUser, // Provide both for compatibility
                currentUser,
                isAuthenticated,
                loading,
                login, // Now uses the correct login function
                loginWithUserData, // NEW: For direct user data login
                logout,
                signOut,
                updateCurrentUser,
            }}
        >
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => useContext(AuthContext);