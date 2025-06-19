/**
 * ================================================================
 * HOME PAGE COMPONENT
 * ================================================================
 * 
 * Landing page for non-authenticated users
 */

import {
    AcademicCapIcon,
    BookOpenIcon,
    ChartBarIcon,
    CheckIcon,
    CreditCardIcon,
    UsersIcon
} from '@heroicons/react/24/outline';
import React from 'react';
import { Link } from 'react-router-dom';

const HomePage: React.FC = () => {
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
        '5 lessons per month',
        '2 practice tests',
        'Basic progress tracking',
        'Community support',
      ],
    },
    {
      name: 'Pro',
      price: '29',
      description: 'Most popular choice',
      features: [
        'Unlimited lessons',
        'Unlimited practice tests',
        'Advanced analytics',
        'Personalized study plans',
        'Expert instructor support',
        'All flashcard sets',
      ],
      popular: true,
    },
    {
      name: 'Enterprise',
      price: '99',
      description: 'For teams and institutions',
      features: [
        'Everything in Pro',
        'Team management',
        'Custom content creation',
        'API access',
        'Priority support',
        'Admin dashboard',
      ],
    },
  ];

  return (
    <div className="min-h-screen bg-white">
      {/* Navigation for non-authenticated users */}
      <nav className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <div className="text-2xl font-bold text-gradient">
                LeEnglish
              </div>
              <span className="ml-2 text-sm text-gray-500">
                TOEIC Platform
              </span>
            </div>
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
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <div className="relative bg-white overflow-hidden">
        <div className="max-w-7xl mx-auto">
          <div className="relative z-10 pb-8 bg-white sm:pb-16 md:pb-20 lg:max-w-2xl lg:w-full lg:pb-28 xl:pb-32">
            <main className="mt-10 mx-auto max-w-7xl px-4 sm:mt-12 sm:px-6 md:mt-16 lg:mt-20 lg:px-8 xl:mt-28">
              <div className="sm:text-center lg:text-left">
                <h1 className="text-4xl tracking-tight font-extrabold text-gray-900 sm:text-5xl md:text-6xl">
                  <span className="block xl:inline">Master the</span>{' '}
                  <span className="block text-gradient xl:inline">TOEIC Test</span>
                </h1>
                <p className="mt-3 text-base text-gray-500 sm:mt-5 sm:text-lg sm:max-w-xl sm:mx-auto md:mt-5 md:text-xl lg:mx-0">
                  Achieve your target TOEIC score with our comprehensive learning platform. 
                  Interactive lessons, realistic practice tests, and personalized study plans 
                  designed by TOEIC experts.
                </p>
                <div className="mt-5 sm:mt-8 sm:flex sm:justify-center lg:justify-start">
                  <div className="rounded-md shadow">
                    <Link
                      to="/register"
                      className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 md:py-4 md:text-lg md:px-10"
                    >
                      Start Learning
                    </Link>
                  </div>
                  <div className="mt-3 sm:mt-0 sm:ml-3">
                    <Link
                      to="/login"
                      className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-primary-700 bg-primary-100 hover:bg-primary-200 md:py-4 md:text-lg md:px-10"
                    >
                      Sign In
                    </Link>
                  </div>
                </div>
              </div>
            </main>
          </div>
        </div>
        <div className="lg:absolute lg:inset-y-0 lg:right-0 lg:w-1/2">
          <div className="h-56 w-full bg-gradient-to-r from-primary-400 to-primary-600 sm:h-72 md:h-96 lg:w-full lg:h-full flex items-center justify-center">
            <div className="text-white text-6xl font-bold opacity-20">
              TOEIC
            </div>
          </div>
        </div>
      </div>

      {/* Features Section */}
      <div className="py-12 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="lg:text-center">
            <h2 className="text-base text-primary-600 font-semibold tracking-wide uppercase">Features</h2>
            <p className="mt-2 text-3xl leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl">
              Everything you need to succeed
            </p>
            <p className="mt-4 max-w-2xl text-xl text-gray-500 lg:mx-auto">
              Our platform provides comprehensive tools and resources to help you achieve your TOEIC goals.
            </p>
          </div>

          <div className="mt-10">
            <dl className="space-y-10 md:space-y-0 md:grid md:grid-cols-2 md:gap-x-8 md:gap-y-10">
              {features.map((feature) => (
                <div key={feature.name} className="relative">
                  <dt>
                    <div className="absolute flex items-center justify-center h-12 w-12 rounded-md bg-primary-500 text-white">
                      <feature.icon className="h-6 w-6" aria-hidden="true" />
                    </div>
                    <p className="ml-16 text-lg leading-6 font-medium text-gray-900">{feature.name}</p>
                  </dt>
                  <dd className="mt-2 ml-16 text-base text-gray-500">{feature.description}</dd>
                </div>
              ))}
            </dl>
          </div>
        </div>
      </div>

      {/* Pricing Section */}
      <div className="bg-white">
        <div className="max-w-7xl mx-auto py-24 px-4 sm:px-6 lg:px-8">
          <div className="sm:flex sm:flex-col sm:align-center">
            <h1 className="text-5xl font-extrabold text-gray-900 sm:text-center">Pricing Plans</h1>
            <p className="mt-5 text-xl text-gray-500 sm:text-center">
              Choose the plan that works best for you
            </p>
          </div>
          <div className="mt-12 space-y-4 sm:mt-16 sm:space-y-0 sm:grid sm:grid-cols-2 sm:gap-6 lg:max-w-4xl lg:mx-auto xl:max-w-none xl:mx-0 xl:grid-cols-3">
            {plans.map((plan) => (
              <div
                key={plan.name}
                className={`border border-gray-200 rounded-lg shadow-sm divide-y divide-gray-200 ${
                  plan.popular ? 'border-primary-500 shadow-lg scale-105' : ''
                }`}
              >
                <div className="p-6">
                  {plan.popular && (
                    <p className="text-sm font-medium text-primary-600 text-center">Most Popular</p>
                  )}
                  <h2 className="text-lg leading-6 font-medium text-gray-900">{plan.name}</h2>
                  <p className="mt-4 text-sm text-gray-500">{plan.description}</p>
                  <p className="mt-8">
                    <span className="text-4xl font-extrabold text-gray-900">${plan.price}</span>
                    <span className="text-base font-medium text-gray-500">/month</span>
                  </p>
                  <Link
                    to="/register"
                    className={`mt-8 block w-full py-2 px-4 border border-transparent rounded-md text-sm font-medium text-center ${
                      plan.popular
                        ? 'bg-primary-600 text-white hover:bg-primary-700'
                        : 'bg-primary-50 text-primary-700 hover:bg-primary-100'
                    }`}
                  >
                    Get started
                  </Link>
                </div>
                <div className="pt-6 pb-8 px-6">
                  <h3 className="text-xs font-medium text-gray-900 tracking-wide uppercase">
                    What's included
                  </h3>
                  <ul className="mt-6 space-y-4">
                    {plan.features.map((feature) => (
                      <li key={feature} className="flex space-x-3">
                        <CheckIcon className="flex-shrink-0 h-5 w-5 text-green-500" aria-hidden="true" />
                        <span className="text-sm text-gray-500">{feature}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* CTA Section */}
      <div className="bg-primary-700">
        <div className="max-w-2xl mx-auto text-center py-16 px-4 sm:py-20 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-extrabold text-white sm:text-4xl">
            <span className="block">Ready to start learning?</span>
            <span className="block">Create your account today.</span>
          </h2>
          <p className="mt-4 text-lg leading-6 text-primary-200">
            Join thousands of students who have improved their TOEIC scores with LeEnglish.
          </p>
          <Link
            to="/register"
            className="mt-8 w-full inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-primary-600 bg-white hover:bg-primary-50 sm:w-auto"
          >
            Get Started
          </Link>
        </div>
      </div>
    </div>
  );
};

export default HomePage;
