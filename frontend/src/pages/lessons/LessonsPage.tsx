/**
 * ================================================================
 * LESSONS PAGE COMPONENT
 * ================================================================
 */

import React from 'react';

const LessonsPage: React.FC = () => {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Lessons</h1>
        <p className="mt-2 text-gray-600">Browse and study TOEIC lessons</p>
      </div>

      <div className="card">
        <div className="card-header">
          <h2 className="text-xl font-semibold text-gray-900">Available Lessons</h2>
        </div>
        <div className="card-body">
          <p className="text-gray-600">Lesson content coming soon.</p>
        </div>
      </div>
    </div>
  );
};

export default LessonsPage;
