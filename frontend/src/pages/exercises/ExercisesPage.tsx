/**
 * ================================================================
 * EXERCISES PAGE COMPONENT
 * ================================================================
 */

import React from 'react';

const ExercisesPage: React.FC = () => {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Practice Exercises</h1>
        <p className="mt-2 text-gray-600">Take practice tests and exercises</p>
      </div>

      <div className="card">
        <div className="card-header">
          <h2 className="text-xl font-semibold text-gray-900">Available Exercises</h2>
        </div>
        <div className="card-body">
          <p className="text-gray-600">Exercise content coming soon.</p>
        </div>
      </div>
    </div>
  );
};

export default ExercisesPage;
