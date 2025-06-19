/**
 * ================================================================
 * DASHBOARD PAGE COMPONENT
 * ================================================================
 */

import React from 'react';

const DashboardPage: React.FC = () => {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-2 text-gray-600">Welcome to your learning dashboard</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div className="card">
          <div className="card-body">
            <h3 className="text-lg font-medium text-gray-900">Lessons Completed</h3>
            <p className="text-3xl font-bold text-primary-600">12</p>
            <p className="text-sm text-gray-500">+2 this week</p>
          </div>
        </div>

        <div className="card">
          <div className="card-body">
            <h3 className="text-lg font-medium text-gray-900">Practice Tests</h3>
            <p className="text-3xl font-bold text-primary-600">8</p>
            <p className="text-sm text-gray-500">+1 this week</p>
          </div>
        </div>

        <div className="card">
          <div className="card-body">
            <h3 className="text-lg font-medium text-gray-900">Average Score</h3>
            <p className="text-3xl font-bold text-primary-600">825</p>
            <p className="text-sm text-gray-500">+15 improvement</p>
          </div>
        </div>
      </div>

      <div className="card">
        <div className="card-header">
          <h2 className="text-xl font-semibold text-gray-900">Recent Activity</h2>
        </div>
        <div className="card-body">
          <p className="text-gray-600">Your recent learning activities will appear here.</p>
        </div>
      </div>
    </div>
  );
};

export default DashboardPage;
