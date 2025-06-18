'use client';

import { Answer, Question } from '@/types';
import React, { useState } from 'react';

interface QuestionCardProps {
  question: Question;
  onAnswer: (questionId: number, selectedAnswer: string, isCorrect: boolean) => void;
  showResult?: boolean;
  selectedAnswer?: string;
}

export const QuestionCard: React.FC<QuestionCardProps> = ({
  question,
  onAnswer,
  showResult = false,
  selectedAnswer
}) => {
  const [selected, setSelected] = useState<string>('');

  const handleAnswerSelect = (optionLabel: string, isCorrect: boolean) => {
    if (showResult) return; // Don't allow changes if showing result
    
    setSelected(optionLabel);
    onAnswer(question.id, optionLabel, isCorrect);
  };

  const getOptionClass = (option: Answer) => {
    const baseClass = "w-full p-3 text-left border-2 rounded-lg transition-colors";
    
    if (!showResult) {
      return `${baseClass} ${
        selected === option.optionLabel
          ? 'border-blue-500 bg-blue-50'
          : 'border-gray-300 hover:border-gray-400'
      }`;
    }

    // Show results
    if (option.isCorrect) {
      return `${baseClass} border-green-500 bg-green-50`;
    }
    if (selectedAnswer === option.optionLabel && !option.isCorrect) {
      return `${baseClass} border-red-500 bg-red-50`;
    }
    return `${baseClass} border-gray-300 bg-gray-50`;
  };

  return (
    <div className="bg-white rounded-lg shadow-md p-6 mb-6">
      <div className="mb-4">
        <div className="flex justify-between items-center mb-2">
          <span className="text-sm text-gray-500">
            {question.section} - Level {question.difficultyLevel}
          </span>
          <span className="text-sm text-blue-600 font-medium">
            Question #{question.id}
          </span>
        </div>
        
        {question.imageUrl && (
          <img 
            src={question.imageUrl} 
            alt="Question image" 
            className="w-full max-w-md mx-auto mb-4 rounded"
          />
        )}
        
        {question.audioUrl && (
          <audio controls className="w-full mb-4">
            <source src={question.audioUrl} type="audio/mpeg" />
            Your browser does not support the audio element.
          </audio>
        )}
        
        <p className="text-lg font-medium text-gray-800 mb-4">
          {question.content}
        </p>
      </div>

      <div className="space-y-3">
        {question.answers
          .sort((a, b) => a.optionLabel.localeCompare(b.optionLabel))
          .map((option) => (
            <button
              key={option.id}
              className={getOptionClass(option)}
              onClick={() => handleAnswerSelect(option.optionLabel, option.isCorrect)}
              disabled={showResult}
            >
              <span className="font-medium mr-2">{option.optionLabel}.</span>
              {option.content}
            </button>
          ))}
      </div>

      {showResult && (
        <div className="mt-4 p-4 bg-gray-50 rounded-lg">
          <div className="text-sm text-gray-600">
            {selectedAnswer === question.answers.find(a => a.isCorrect)?.optionLabel ? (
              <span className="text-green-600 font-medium">✓ Correct!</span>
            ) : (
              <span className="text-red-600 font-medium">✗ Incorrect</span>
            )}
          </div>
        </div>
      )}
    </div>
  );
};
