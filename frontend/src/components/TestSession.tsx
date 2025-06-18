'use client';

import { apiService } from '@/lib/api';
import { Question, Section } from '@/types';
import React, { useEffect, useState } from 'react';
import { QuestionCard } from './QuestionCard';

interface TestSessionProps {
  section: Section;
  questionCount: number;
  onTestComplete: (results: {
    totalQuestions: number;
    correctAnswers: number;
    score: number;
    timeSpent: number;
  }) => void;
}

export const TestSession: React.FC<TestSessionProps> = ({
  section,
  questionCount,
  onTestComplete
}) => {
  const [questions, setQuestions] = useState<Question[]>([]);
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const [answers, setAnswers] = useState<Map<number, { selected: string; isCorrect: boolean }>>(new Map());
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [startTime] = useState(Date.now());
  const [showResults, setShowResults] = useState(false);

  useEffect(() => {
    loadQuestions();
  }, [section, questionCount]);

  const loadQuestions = async () => {
    try {
      setLoading(true);
      const loadedQuestions = await apiService.getRandomQuestionsBySection(section, questionCount);
      setQuestions(loadedQuestions);
    } catch (err) {
      setError('Failed to load questions. Please try again.');
      console.error('Error loading questions:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleAnswer = (questionId: number, selectedAnswer: string, isCorrect: boolean) => {
    setAnswers(prev => new Map(prev).set(questionId, { selected: selectedAnswer, isCorrect }));
  };

  const goToNextQuestion = () => {
    if (currentQuestionIndex < questions.length - 1) {
      setCurrentQuestionIndex(prev => prev + 1);
    }
  };

  const goToPreviousQuestion = () => {
    if (currentQuestionIndex > 0) {
      setCurrentQuestionIndex(prev => prev - 1);
    }
  };

  const finishTest = () => {
    const timeSpent = Math.floor((Date.now() - startTime) / 1000);
    const correctAnswers = Array.from(answers.values()).filter(answer => answer.isCorrect).length;
    const score = Math.round((correctAnswers / questions.length) * 100);

    setShowResults(true);
    onTestComplete({
      totalQuestions: questions.length,
      correctAnswers,
      score,
      timeSpent
    });
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-red-50 border border-red-300 rounded-lg p-4">
        <p className="text-red-700">{error}</p>
        <button 
          onClick={loadQuestions}
          className="mt-2 px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
        >
          Retry
        </button>
      </div>
    );
  }

  if (questions.length === 0) {
    return (
      <div className="text-center py-8">
        <p className="text-gray-600">No questions available for this section.</p>
      </div>
    );
  }

  const currentQuestion = questions[currentQuestionIndex];
  const isLastQuestion = currentQuestionIndex === questions.length - 1;
  const hasAnswered = answers.has(currentQuestion.id);

  return (
    <div className="max-w-4xl mx-auto">
      {/* Progress Bar */}
      <div className="mb-6">
        <div className="flex justify-between items-center mb-2">
          <span className="text-sm font-medium text-gray-700">
            Question {currentQuestionIndex + 1} of {questions.length}
          </span>
          <span className="text-sm text-gray-500">
            {section} Section
          </span>
        </div>
        <div className="w-full bg-gray-200 rounded-full h-2">
          <div 
            className="bg-blue-600 h-2 rounded-full transition-all duration-300"
            style={{ width: `${((currentQuestionIndex + 1) / questions.length) * 100}%` }}
          ></div>
        </div>
      </div>

      {/* Question */}
      <QuestionCard
        question={currentQuestion}
        onAnswer={handleAnswer}
        showResult={showResults}
        selectedAnswer={answers.get(currentQuestion.id)?.selected}
      />

      {/* Navigation */}
      <div className="flex justify-between items-center mt-6">
        <button
          onClick={goToPreviousQuestion}
          disabled={currentQuestionIndex === 0}
          className="px-4 py-2 bg-gray-300 text-gray-700 rounded disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-400"
        >
          Previous
        </button>

        <div className="flex space-x-2">
          {questions.map((_, index) => (
            <button
              key={index}
              onClick={() => setCurrentQuestionIndex(index)}
              className={`w-8 h-8 rounded-full text-sm font-medium ${
                index === currentQuestionIndex
                  ? 'bg-blue-600 text-white'
                  : answers.has(questions[index].id)
                  ? 'bg-green-100 text-green-800 border-2 border-green-300'
                  : 'bg-gray-100 text-gray-600 border-2 border-gray-300'
              }`}
            >
              {index + 1}
            </button>
          ))}
        </div>

        {isLastQuestion ? (
          <button
            onClick={finishTest}
            disabled={!hasAnswered || showResults}
            className="px-6 py-2 bg-green-600 text-white rounded disabled:opacity-50 disabled:cursor-not-allowed hover:bg-green-700"
          >
            Finish Test
          </button>
        ) : (
          <button
            onClick={goToNextQuestion}
            disabled={!hasAnswered}
            className="px-4 py-2 bg-blue-600 text-white rounded disabled:opacity-50 disabled:cursor-not-allowed hover:bg-blue-700"
          >
            Next
          </button>
        )}
      </div>

      {/* Results Summary */}
      {showResults && (
        <div className="mt-8 bg-blue-50 border border-blue-300 rounded-lg p-6">
          <h3 className="text-lg font-semibold text-blue-800 mb-4">Test Results</h3>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">
                {Array.from(answers.values()).filter(a => a.isCorrect).length}
              </div>
              <div className="text-sm text-gray-600">Correct</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">{questions.length}</div>
              <div className="text-sm text-gray-600">Total</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">
                {Math.round((Array.from(answers.values()).filter(a => a.isCorrect).length / questions.length) * 100)}%
              </div>
              <div className="text-sm text-gray-600">Score</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">
                {Math.floor((Date.now() - startTime) / 60000)}m
              </div>
              <div className="text-sm text-gray-600">Time</div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
