/**
 * ================================================================
 * MAIN APP COMPONENT - LEENGLISH TOEIC PLATFORM
 * ================================================================
 * 
 * Root component with routing, authentication, and global state
 * Provides comprehensive TOEIC learning platform features
 */

import React, { useEffect, useState } from 'react';
import { Toaster } from 'react-hot-toast';
import { Navigate, Route, BrowserRouter as Router, Routes } from 'react-router-dom';

// Authentication
import { getCurrentUser, isAuthenticated, startAutoRefresh, stopAutoRefresh } from './services/auth';
import { User } from './types';

// Layout Components
import Footer from './components/layout/Footer';
import Navbar from './components/layout/Navbar';
import Sidebar from './components/layout/Sidebar';

// Page Components
import AdminContentPage from './pages/admin/AdminContentPage';
import AdminUsersPage from './pages/admin/AdminUsersPage';
import LoginPage from './pages/auth/LoginPage';
import RegisterPage from './pages/auth/RegisterPage';
import DashboardPage from './pages/DashboardPage';
import ExerciseDetailPage from './pages/exercises/ExerciseDetailPage';
import ExercisesPage from './pages/exercises/ExercisesPage';
import FlashcardsPage from './pages/flashcards/FlashcardsPage';
import HomePage from './pages/HomePage';
import LessonDetailPage from './pages/lessons/LessonDetailPage';
import LessonsPage from './pages/lessons/LessonsPage';
import NotFoundPage from './pages/NotFoundPage';
import PricingPage from './pages/PricingPage';
import ProfilePage from './pages/user/ProfilePage';
import SettingsPage from './pages/user/SettingsPage';

// Loading Component
import LoadingSpinner from './components/ui/LoadingSpinner';

// ========== MAIN APP COMPONENT ==========

const App: React.FC = () => {
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);

  // ========== AUTHENTICATION SETUP ==========

  useEffect(() => {
    const initializeAuth = async () => {
      try {
        if (isAuthenticated()) {
          const user = getCurrentUser();
          setCurrentUser(user);
          startAutoRefresh();
        }
      } catch (error) {
        console.error('Failed to initialize authentication:', error);
      } finally {
        setIsLoading(false);
      }
    };

    initializeAuth();

    // Cleanup on unmount
    return () => {
      stopAutoRefresh();
    };
  }, []);

  // ========== PROTECTED ROUTE COMPONENT ==========

  const ProtectedRoute: React.FC<{ children: React.ReactNode; adminOnly?: boolean }> = ({
    children,
    adminOnly = false
  }) => {
    if (!isAuthenticated() || !currentUser) {
      return <Navigate to="/login" replace />;
    }

    if (adminOnly && currentUser.role !== 'ADMIN') {
      return <Navigate to="/dashboard" replace />;
    }

    return <>{children}</>;
  };

  // ========== LAYOUT COMPONENT ==========

  const Layout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    return (
      <div className="min-h-screen bg-gray-50">
        <Navbar
          currentUser={currentUser}
          onMenuClick={() => setIsSidebarOpen(!isSidebarOpen)}
        />

        <div className="flex">
          <Sidebar
            currentUser={currentUser}
            isOpen={isSidebarOpen}
            onClose={() => setIsSidebarOpen(false)}
          />

          <main className={`flex-1 transition-all duration-300 ${currentUser ? 'lg:ml-64' : ''
            }`}>
            <div className="p-4 lg:p-8">
              {children}
            </div>
          </main>
        </div>

        <Footer />
      </div>
    );
  };

  // ========== LOADING STATE ==========

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <LoadingSpinner size="lg" />
          <p className="mt-4 text-gray-600">Loading LeEnglish TOEIC Platform...</p>
        </div>
      </div>
    );
  }

  // ========== MAIN RENDER ==========

  return (
    <Router>
      <div className="App">
        {/* Global Toast Notifications */}
        <Toaster
          position="top-right"
          toastOptions={{
            duration: 4000,
            style: {
              background: '#363636',
              color: '#fff',
            },
          }}
        />

        <Routes>
          {/* ========== PUBLIC ROUTES ========== */}
          {/* FIX: Allow authenticated users to access home page
               Previously redirected logged-in users to dashboard automatically
               Now both authenticated and non-authenticated users can view home page */}
          <Route
            path="/"
            element={<HomePage />}
          />
          <Route
            path="/login"
            element={
              currentUser ? <Navigate to="/dashboard" replace /> : <LoginPage />
            }
          />
          <Route
            path="/register"
            element={
              currentUser ? <Navigate to="/dashboard" replace /> : <RegisterPage />
            }
          />
          <Route
            path="/pricing"
            element={<PricingPage />}
          />

          {/* ========== PROTECTED ROUTES ========== */}
          <Route
            path="/dashboard"
            element={
              <ProtectedRoute>
                <Layout>
                  <DashboardPage />
                </Layout>
              </ProtectedRoute>
            }
          />

          {/* User Routes */}
          <Route
            path="/profile"
            element={
              <ProtectedRoute>
                <Layout>
                  <ProfilePage />
                </Layout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/settings"
            element={
              <ProtectedRoute>
                <Layout>
                  <SettingsPage />
                </Layout>
              </ProtectedRoute>
            }
          />

          {/* Learning Routes */}
          <Route
            path="/lessons"
            element={
              <ProtectedRoute>
                <Layout>
                  <LessonsPage />
                </Layout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/lessons/:id"
            element={
              <ProtectedRoute>
                <Layout>
                  <LessonDetailPage />
                </Layout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/exercises"
            element={
              <ProtectedRoute>
                <Layout>
                  <ExercisesPage />
                </Layout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/exercises/:id"
            element={
              <ProtectedRoute>
                <Layout>
                  <ExerciseDetailPage />
                </Layout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/flashcards"
            element={
              <ProtectedRoute>
                <Layout>
                  <FlashcardsPage />
                </Layout>
              </ProtectedRoute>
            }
          />

          {/* Admin Routes */}
          <Route
            path="/admin/users"
            element={
              <ProtectedRoute adminOnly>
                <Layout>
                  <AdminUsersPage />
                </Layout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/content"
            element={
              <ProtectedRoute adminOnly>
                <Layout>
                  <AdminContentPage />
                </Layout>
              </ProtectedRoute>
            }
          />

          {/* 404 Route */}
          <Route
            path="*"
            element={
              <Layout>
                <NotFoundPage />
              </Layout>
            }
          />
        </Routes>
      </div>
    </Router>
  );
};

export default App;
