/**
 * ================================================================
 * NAVBAR COMPONENT
 * ================================================================
 * 
 * Main navigation bar with user profile, search, and menu
 */

import {
  Bars3Icon,
  BellIcon,
  MagnifyingGlassIcon,
  UserCircleIcon
} from '@heroicons/react/24/outline';
import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { logout } from '../../services/auth';
import { User } from '../../types';

interface NavbarProps {
  currentUser: User | null;
  onMenuClick: () => void;
}

const Navbar: React.FC<NavbarProps> = ({ currentUser, onMenuClick }) => {
  const navigate = useNavigate();

  const handleLogout = async () => {
    try {
      await logout();
      navigate('/login');
    } catch (error) {
      console.error('Logout failed:', error);
    }
  };

  return (
    <nav className="bg-white shadow-sm border-b border-gray-200 fixed w-full top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Left Side */}
          <div className="flex items-center">            {currentUser && (
            <button
              onClick={onMenuClick}
              className="p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-primary-500 lg:hidden"
              aria-label="Open main menu"
            >
              <Bars3Icon className="h-6 w-6" />
            </button>
          )}

            <Link to="/" className="flex items-center">
              <div className="text-2xl font-bold text-gradient">
                LeEnglish
              </div>
              <span className="ml-2 text-sm text-gray-500 hidden sm:block">
                TOEIC Platform
              </span>
            </Link>
          </div>

          {/* Center - Search */}
          {currentUser && (
            <div className="flex-1 max-w-lg mx-4">
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <MagnifyingGlassIcon className="h-5 w-5 text-gray-400" />
                </div>
                <input
                  type="text"
                  className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-primary-500 focus:border-primary-500"
                  placeholder="Search lessons, exercises..."
                />
              </div>
            </div>
          )}

          {/* Right Side */}
          <div className="flex items-center space-x-4">
            {currentUser ? (
              <>                {/* Notifications */}
                <button
                  className="p-1 rounded-full text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
                  aria-label="View notifications"
                >
                  <BellIcon className="h-6 w-6" />
                </button>

                {/* Profile Dropdown */}
                <div className="relative group">                  <button className="flex items-center space-x-3 text-sm rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                  {currentUser.profilePicture ? (
                    <img
                      className="h-8 w-8 rounded-full"
                      src={currentUser.profilePicture}
                      alt={currentUser.fullName}
                    />
                  ) : (
                    <UserCircleIcon className="h-8 w-8 text-gray-400" />
                  )}
                  <span className="hidden md:block text-gray-700 font-medium">
                    {currentUser.fullName}
                  </span>
                </button>

                  {/* Dropdown Menu */}
                  <div className="absolute right-0 mt-2 w-48 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200">
                    <div className="py-1">
                      <Link
                        to="/profile"
                        className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                      >
                        Your Profile
                      </Link>
                      <Link
                        to="/settings"
                        className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                      >
                        Settings
                      </Link>
                      {currentUser.role === 'ADMIN' && (
                        <>
                          <div className="border-t border-gray-100"></div>
                          <Link
                            to="/admin/users"
                            className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                          >
                            Admin Panel
                          </Link>
                        </>
                      )}
                      <div className="border-t border-gray-100"></div>
                      <button
                        onClick={handleLogout}
                        className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                      >
                        Sign out
                      </button>
                    </div>
                  </div>
                </div>
              </>
            ) : (
              <div className="flex items-center space-x-4">
                <Link
                  to="/login"
                  className="text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium"
                >
                  Sign in
                </Link>
                <Link
                  to="/register"
                  className="btn-primary"
                >
                  Get started
                </Link>
              </div>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
