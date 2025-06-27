import React, { createContext, useContext, useEffect, useState } from 'react';

interface AuthContextType {
    isAuthenticated: boolean;
    loading: boolean;
    currentUser: any;
    login: (user: any, token: string) => void;
    logout: () => void;
}

const AuthContext = createContext<AuthContextType>({
    isAuthenticated: false,
    loading: true,
    currentUser: null,
    login: () => { },
    logout: () => { },
});

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const [loading, setLoading] = useState(true);
    const [currentUser, setCurrentUser] = useState<any>(null);

    useEffect(() => {
        const userStr = localStorage.getItem('currentUser');
        const token = localStorage.getItem('accessToken');
        if (userStr && token) {
            setCurrentUser(JSON.parse(userStr));
            setIsAuthenticated(true);
        } else {
            setCurrentUser(null);
            setIsAuthenticated(false);
        }
        setLoading(false);
    }, []);

    const login = (user: any, token: string) => {
        localStorage.setItem('currentUser', JSON.stringify(user));
        localStorage.setItem('accessToken', token);
        setCurrentUser(user);
        setIsAuthenticated(true);
    };

    const logout = () => {
        localStorage.removeItem('currentUser');
        localStorage.removeItem('accessToken');
        setCurrentUser(null);
        setIsAuthenticated(false);
    };

    return (
        <AuthContext.Provider value={{ isAuthenticated, loading, currentUser, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => useContext(AuthContext);