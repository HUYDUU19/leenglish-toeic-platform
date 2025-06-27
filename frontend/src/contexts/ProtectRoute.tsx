import { ReactNode } from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

type ProtectedRouteProps = {
    children: ReactNode;
};

const ProtectedRoute = ({ children }: ProtectedRouteProps) => {
    const { isAuthenticated, loading } = useAuth();
    if (loading) return null; // hoặc spinner
    return isAuthenticated ? children : <Navigate to="/auth/login" />;
};

export default ProtectedRoute;