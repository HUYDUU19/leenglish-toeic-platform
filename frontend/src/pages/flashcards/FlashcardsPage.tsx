/**
 * ================================================================
 * FLASHCARDS PAGE COMPONENT
 * ================================================================
 */

import React from 'react';

const FlashcardsPage: React.FC = () => {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Flashcards</h1>
        <p className="mt-2 text-gray-600">Study vocabulary with flashcards</p>
      </div>

      <div className="card">
        <div className="card-header">
          <h2 className="text-xl font-semibold text-gray-900">Flashcard Sets</h2>
        </div>
        <div className="card-body">
          <p className="text-gray-600">Flashcard content coming soon.</p>
        </div>
      </div>
    </div>
  );
};

export default FlashcardsPage;
