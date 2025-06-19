/**
 * ================================================================
 * EXERCISE DETAIL PAGE COMPONENT
 * ================================================================
 */

import React from 'react';

const ExerciseDetailPage: React.FC = () => {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Exercise Detail</h1>
        <p className="mt-2 text-gray-600">Take this exercise</p>
      </div>

      <div className="card">
        <div className="card-body">
          <p className="text-gray-600">Exercise detail content coming soon.</p>
        </div>
      </div>
    </div>
  );
};

export default ExerciseDetailPage;
