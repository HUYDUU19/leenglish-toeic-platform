/**
 * ================================================================
 * HOME PAGE COMPONENT
 * ================================================================
 * 
 * Landing page with lesson carousel and premium upgrade prompts
 */

import {
  AcademicCapIcon,
  ArrowLeftIcon,
  ArrowRightIcon,
  BookOpenIcon,
  ChartBarIcon,
  CheckIcon,
  CreditCardIcon,
  LockClosedIcon,
  PlayIcon,
  StarIcon,
  UsersIcon
} from '@heroicons/react/24/outline';
import React, { useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Link } from 'react-router-dom';
import { getCurrentUser, isAuthenticated } from '../services/auth';
import { lessonService } from '../services/lessons';
import { Lesson, User } from '../types';

const HomePage: React.FC = () => {
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [lessons, setLessons] = useState<Lesson[]>([]);
  const [currentSlide, setCurrentSlide] = useState(0);
  const [isLoading, setIsLoading] = useState(true);

  // ========== AUTHENTICATION & DATA FETCHING ==========

  useEffect(() => {
    const initializeUser = async () => {
      if (isAuthenticated()) {
        try {
          const user = await getCurrentUser();
          setCurrentUser(user);
        } catch (error) {
          console.error('Error fetching user:', error);
        }
      }
    };

    const fetchLessons = async () => {
      try {
        const response = await lessonService.getLessons();
        // Get first 6 lessons
        setLessons(response.slice(0, 6));
      } catch (error) {
        console.error('Error fetching lessons:', error);
        // Fallback lessons if API fails
        setLessons([
          {
            id: 1,
            title: 'Basic Greetings and Introductions',
            description: 'Learn essential greetings and how to introduce yourself in English',
            level: 'A1',
            isPremium: false,
            imageUrl: '/images/lesson1.jpg',
            orderIndex: 1
          },
          {
            id: 2,
            title: 'Present Simple Tense',
            description: 'Understanding and using present simple tense in everyday situations',
            level: 'A1',
            isPremium: false,
            imageUrl: '/images/lesson2.jpg',
            orderIndex: 2
          },
          {
            id: 3,
            title: 'Numbers and Time',
            description: 'Learn numbers, dates, and how to tell time in English',
            level: 'A1',
            isPremium: true,
            imageUrl: '/images/lesson3.jpg',
            orderIndex: 3
          },
          {
            id: 4,
            title: 'Past Simple Tense',
            description: 'Learn to talk about past events and experiences',
            level: 'A2',
            isPremium: true,
            imageUrl: '/images/lesson4.jpg',
            orderIndex: 4
          },
          {
            id: 5,
            title: 'Food and Restaurants',
            description: 'Vocabulary and phrases for ordering food and dining out',
            level: 'A2',
            isPremium: true,
            imageUrl: '/images/lesson5.jpg',
            orderIndex: 5
          },
          {
            id: 6,
            title: 'Future Tense and Plans',
            description: 'Express future intentions and make plans',
            level: 'B1',
            isPremium: true,
            imageUrl: '/images/lesson6.jpg',
            orderIndex: 6
          }
        ]);
      } finally {
        setIsLoading(false);
      }
    };

    initializeUser();
    fetchLessons();
  }, []);

  // ========== CAROUSEL NAVIGATION ==========

  const nextSlide = () => {
    setCurrentSlide((prev) => (prev + 3) % lessons.length);
  };

  const prevSlide = () => {
    setCurrentSlide((prev) => (prev - 3 + lessons.length) % lessons.length);
  };

  // ========== LESSON ACCESS CHECK ==========

  const canAccessLesson = (lesson: Lesson): boolean => {
    // Free users can access first 2 lessons
    if (!currentUser) {
      return lesson.orderIndex <= 2;
    }

    // Premium users can access all lessons
    if (currentUser.isPremium) {
      return true;
    }

    // Regular users can access first 2 lessons + non-premium lessons
    return lesson.orderIndex <= 2 || !lesson.isPremium;
  };

  const handleLessonClick = (lesson: Lesson) => {
    if (canAccessLesson(lesson)) {
      // Allow access
      window.location.href = `/lessons/${lesson.id}`;
    } else {
      // Show premium upgrade prompt
      showPremiumUpgradeModal(lesson);
    }
  };

  const showPremiumUpgradeModal = (lesson: Lesson) => {
    toast.error(
      <div className="text-center">
        <LockClosedIcon className="w-8 h-8 mx-auto mb-2 text-amber-500" />
        <h3 className="font-semibold">Premium Lesson</h3>
        <p className="text-sm text-gray-600 mb-3">
          Upgrade to Premium to access "{lesson.title}"
        </p>
        <Link
          to="/pricing"
          className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-4 py-2 rounded-lg text-sm hover:shadow-lg transition-all"
        >
          Upgrade Now
        </Link>
      </div>,
      { duration: 5000 }
    );
  };

  // ========== FEATURES & PRICING ==========

  const features = [
    {
      name: 'Interactive Lessons',
      description: 'Learn TOEIC concepts through engaging, step-by-step lessons designed by experts.',
      icon: BookOpenIcon,
    },
    {
      name: 'Practice Tests',
      description: 'Take realistic practice tests that simulate the actual TOEIC exam experience.',
      icon: AcademicCapIcon,
    },
    {
      name: 'Progress Tracking',
      description: 'Monitor your improvement with detailed analytics and performance insights.',
      icon: ChartBarIcon,
    },
    {
      name: 'Flashcards',
      description: 'Master vocabulary and grammar with interactive flashcard sets.',
      icon: CreditCardIcon,
    },
    {
      name: 'Expert Support',
      description: 'Get help from certified TOEIC instructors and join study groups.',
      icon: UsersIcon,
    },
  ];
  const plans = [
    {
      name: 'Free',
      price: '0',
      description: 'Perfect for getting started',
      features: [
        '2 free lessons',
        'Basic progress tracking',
        'Community support',
      ],
    },
    {
      name: 'Premium',
      price: '29',
      description: 'Unlock all content',
      features: [
        'All lessons & exercises',
        'Premium flashcard sets',
        'Advanced analytics',
        'Personalized study plans',
        'Expert instructor support',
        'Download for offline study',
      ],
      popular: true,
    },
  ];

  if (isLoading) {
    return (
      <div className="min-h-screen bg-white flex items-center justify-center">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-white">
      {/* Navigation */}
      <nav className="bg-white shadow-sm sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <div className="text-2xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                LeEnglish
              </div>
              <span className="ml-2 text-sm text-gray-500">
                TOEIC Platform
              </span>
            </div>
            <div className="flex items-center space-x-4">
              {currentUser ? (
                <div className="flex items-center space-x-4">
                  <span className="text-sm text-gray-700">
                    Welcome, {currentUser.fullName || currentUser.username}
                  </span>
                  {currentUser.isPremium && (
                    <span className="bg-amber-100 text-amber-800 text-xs px-2 py-1 rounded-full">
                      Premium
                    </span>
                  )}
                  <Link to="/dashboard" className="btn-primary">
                    Dashboard
                  </Link>
                </div>
              ) : (
                <>
                  <Link
                    to="/login"
                    className="text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium"
                  >
                    Sign in
                  </Link>
                  <Link
                    to="/register"
                    className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-4 py-2 rounded-lg hover:shadow-lg transition-all"
                  >
                    Get started
                  </Link>
                </>
              )}
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="bg-gradient-to-br from-blue-50 via-white to-purple-50 py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
              Master TOEIC with
              <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                {' '}Interactive Learning
              </span>
            </h1>
            <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
              Join thousands of learners achieving their TOEIC goals through our comprehensive platform
              with expert-designed lessons, practice tests, and personalized study plans.
            </p>

            {!currentUser && (
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                <Link
                  to="/register"
                  className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-lg text-lg font-semibold hover:shadow-xl transition-all"
                >
                  Start Free Trial
                </Link>
                <Link
                  to="/lessons"
                  className="border-2 border-gray-300 text-gray-700 px-8 py-4 rounded-lg text-lg font-semibold hover:border-gray-400 transition-all"
                >
                  Browse Lessons
                </Link>
              </div>
            )}
          </div>
        </div>
      </section>

      {/* Lessons Carousel Section */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Featured Lessons
            </h2>
            <p className="text-lg text-gray-600">
              Start your TOEIC journey with our carefully crafted lessons
            </p>
          </div>

          {/* Lesson Carousel */}
          <div className="relative">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {lessons.slice(currentSlide, currentSlide + 3).map((lesson) => {
                const canAccess = canAccessLesson(lesson);
                return (
                  <div
                    key={lesson.id}
                    className={`bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition-all cursor-pointer transform hover:scale-105 ${!canAccess ? 'opacity-75' : ''
                      }`}
                    onClick={() => handleLessonClick(lesson)}
                  >
                    <div className="relative">
                      <img
                        src={lesson.imageUrl || '/images/default-lesson.jpg'}
                        alt={lesson.title}
                        className="w-full h-48 object-cover"
                      />
                      {!canAccess && (
                        <div className="absolute inset-0 bg-black bg-opacity-40 flex items-center justify-center">
                          <LockClosedIcon className="w-12 h-12 text-white" />
                        </div>
                      )}
                      <div className="absolute top-4 left-4">
                        <span className="bg-blue-600 text-white px-2 py-1 rounded-full text-sm">
                          {lesson.level}
                        </span>
                      </div>
                      {lesson.isPremium && (
                        <div className="absolute top-4 right-4">
                          <span className="bg-amber-500 text-white px-2 py-1 rounded-full text-sm flex items-center">
                            <StarIcon className="w-4 h-4 mr-1" />
                            Premium
                          </span>
                        </div>
                      )}
                    </div>

                    <div className="p-6">
                      <h3 className="text-xl font-semibold text-gray-900 mb-2">
                        {lesson.title}
                      </h3>
                      <p className="text-gray-600 mb-4 line-clamp-2">
                        {lesson.description}
                      </p>

                      <div className="flex items-center justify-between">
                        <div className="flex items-center">
                          <PlayIcon className="w-5 h-5 text-blue-600 mr-2" />
                          <span className="text-sm text-gray-500">
                            {canAccess ? 'Available' : 'Premium Required'}
                          </span>
                        </div>

                        {canAccess ? (
                          <span className="text-blue-600 font-semibold">
                            Start Lesson →
                          </span>
                        ) : (
                          <span className="text-amber-600 font-semibold">
                            Upgrade →
                          </span>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>            {/* Carousel Navigation */}
            <button
              onClick={prevSlide}
              disabled={currentSlide === 0}
              title="Previous lessons"
              aria-label="Previous lessons"
              className="absolute left-0 top-1/2 transform -translate-y-1/2 -translate-x-4 bg-white rounded-full p-2 shadow-lg hover:shadow-xl transition-all disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <ArrowLeftIcon className="w-6 h-6 text-gray-600" />
            </button>

            <button
              onClick={nextSlide}
              disabled={currentSlide + 3 >= lessons.length}
              title="Next lessons"
              aria-label="Next lessons"
              className="absolute right-0 top-1/2 transform -translate-y-1/2 translate-x-4 bg-white rounded-full p-2 shadow-lg hover:shadow-xl transition-all disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <ArrowRightIcon className="w-6 h-6 text-gray-600" />
            </button>
          </div>

          {/* Progress indicators */}
          <div className="flex justify-center mt-6 space-x-2">
            {Array.from({ length: Math.ceil(lessons.length / 3) }).map((_, index) => (
              <button
                key={index}
                onClick={() => setCurrentSlide(index * 3)}
                title={`Go to slide ${index + 1}`}
                aria-label={`Go to slide ${index + 1}`}
                className={`w-3 h-3 rounded-full transition-all ${Math.floor(currentSlide / 3) === index
                    ? 'bg-blue-600'
                    : 'bg-gray-300 hover:bg-gray-400'
                  }`}
              />
            ))}
          </div>        </div>
      </section>

      {/* Features Section */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Why Choose LeEnglish?
            </h2>
            <p className="text-lg text-gray-600 max-w-3xl mx-auto">
              Our platform combines proven teaching methods with cutting-edge technology
              to help you achieve your TOEIC goals faster and more effectively.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {features.map((feature) => (
              <div key={feature.name} className="text-center">
                <div className="mx-auto h-12 w-12 text-blue-600 mb-4">
                  <feature.icon className="h-12 w-12" />
                </div>
                <h3 className="text-lg font-semibold text-gray-900 mb-2">
                  {feature.name}
                </h3>
                <p className="text-gray-600">
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Pricing Section */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Choose Your Plan
            </h2>
            <p className="text-lg text-gray-600">
              Start free and upgrade when you're ready for unlimited access
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl mx-auto">
            {plans.map((plan) => (
              <div
                key={plan.name}
                className={`bg-white rounded-xl shadow-lg overflow-hidden ${plan.popular ? 'ring-2 ring-blue-600 transform scale-105' : ''
                  }`}
              >
                {plan.popular && (
                  <div className="bg-blue-600 text-white text-center py-2 text-sm font-semibold">
                    Most Popular
                  </div>
                )}

                <div className="p-8">
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">
                    {plan.name}
                  </h3>
                  <p className="text-gray-600 mb-4">
                    {plan.description}
                  </p>

                  <div className="mb-6">
                    <span className="text-4xl font-bold text-gray-900">
                      ${plan.price}
                    </span>
                    <span className="text-gray-600">/month</span>
                  </div>

                  <ul className="space-y-3 mb-8">
                    {plan.features.map((feature, index) => (
                      <li key={index} className="flex items-center">
                        <CheckIcon className="h-5 w-5 text-green-500 mr-3" />
                        <span className="text-gray-700">{feature}</span>
                      </li>
                    ))}
                  </ul>

                  <Link
                    to={plan.name === 'Free' ? '/register' : '/pricing'}
                    className={`w-full block text-center py-3 px-6 rounded-lg font-semibold transition-all ${plan.popular
                        ? 'bg-blue-600 text-white hover:bg-blue-700'
                        : 'bg-gray-100 text-gray-900 hover:bg-gray-200'
                      }`}
                  >
                    {plan.name === 'Free' ? 'Get Started' : 'Upgrade Now'}
                  </Link>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 bg-gradient-to-r from-blue-600 to-purple-600">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold text-white mb-4">
            Ready to Start Your TOEIC Journey?
          </h2>
          <p className="text-xl text-blue-100 mb-8 max-w-2xl mx-auto">
            Join thousands of successful learners who achieved their target scores with LeEnglish
          </p>

          {!currentUser ? (
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                to="/register"
                className="bg-white text-blue-600 px-8 py-4 rounded-lg text-lg font-semibold hover:shadow-xl transition-all"
              >
                Start Free Trial
              </Link>
              <Link
                to="/lessons"
                className="border-2 border-white text-white px-8 py-4 rounded-lg text-lg font-semibold hover:bg-white hover:text-blue-600 transition-all"
              >
                Browse Lessons
              </Link>
            </div>
          ) : (
            <Link
              to="/dashboard"
              className="bg-white text-blue-600 px-8 py-4 rounded-lg text-lg font-semibold hover:shadow-xl transition-all"
            >
              Continue Learning
            </Link>
          )}
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div>
              <div className="text-2xl font-bold bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent mb-4">
                LeEnglish
              </div>
              <p className="text-gray-400">
                Your complete TOEIC preparation platform
              </p>
            </div>

            <div>
              <h3 className="font-semibold mb-4">Platform</h3>
              <ul className="space-y-2 text-gray-400">
                <li><Link to="/lessons" className="hover:text-white">Lessons</Link></li>
                <li><Link to="/exercises" className="hover:text-white">Exercises</Link></li>
                <li><Link to="/flashcards" className="hover:text-white">Flashcards</Link></li>
                <li><Link to="/tests" className="hover:text-white">Practice Tests</Link></li>
              </ul>
            </div>

            <div>
              <h3 className="font-semibold mb-4">Support</h3>
              <ul className="space-y-2 text-gray-400">
                <li><Link to="/help" className="hover:text-white">Help Center</Link></li>
                <li><Link to="/contact" className="hover:text-white">Contact Us</Link></li>
                <li><Link to="/community" className="hover:text-white">Community</Link></li>
              </ul>
            </div>

            <div>
              <h3 className="font-semibold mb-4">Company</h3>
              <ul className="space-y-2 text-gray-400">
                <li><Link to="/about" className="hover:text-white">About</Link></li>
                <li><Link to="/privacy" className="hover:text-white">Privacy</Link></li>
                <li><Link to="/terms" className="hover:text-white">Terms</Link></li>
              </ul>
            </div>
          </div>

          <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
            <p>&copy; 2025 LeEnglish. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default HomePage;
