/**
 * ================================================================
 * LESSON DETAIL PAGE COMPONENT
 * ================================================================
 */

import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import LoadingSpinner from '../../components/ui/LoadingSpinner';
import { lessonService } from '../../services/lessons';
import { Lesson } from '../../types';

const LessonDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const [lesson, setLesson] = useState<Lesson | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchLesson = async () => {
      if (!id) {
        setError('Lesson ID not found');
        setLoading(false);
        return;
      }

      try {
        setLoading(true);
        const lessonData = await lessonService.getLessonById(parseInt(id));
        setLesson(lessonData);
        setError(null);
      } catch (err: any) {
        console.error('Error fetching lesson:', err);
        setError(err.message || 'Failed to load lesson');
      } finally {
        setLoading(false);
      }
    };

    fetchLesson();
  }, [id]);

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-64">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Lesson Detail</h1>
          <p className="mt-2 text-red-600">Error: {error}</p>
        </div>
      </div>
    );
  }

  if (!lesson) {
    return (
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Lesson Not Found</h1>
          <p className="mt-2 text-gray-600">The requested lesson could not be found.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">{lesson.title}</h1>
        <p className="mt-2 text-gray-600">Level: {lesson.level} {lesson.isPremium && '🔒 Premium'}</p>
      </div>

      <div className="card">
        <div className="card-body space-y-4">
          <div>
            <h2 className="text-xl font-semibold text-gray-900 mb-2">Description</h2>
            <p className="text-gray-600">{lesson.description}</p>
          </div>

          {lesson.content && (
            <div>
              <h2 className="text-xl font-semibold text-gray-900 mb-2">Content</h2>
              <div className="bg-gray-50 p-4 rounded-lg">
                <p className="text-gray-700 whitespace-pre-line">{lesson.content}</p>
              </div>
            </div>
          )}

          {lesson.imageUrl && (
            <div>
              <h2 className="text-xl font-semibold text-gray-900 mb-2">Visual Content</h2>
              <img
                src={lesson.imageUrl}
                alt={lesson.title}
                className="w-full max-w-md rounded-lg shadow-md"
                onError={(e) => {
                  e.currentTarget.style.display = 'none';
                }}
              />
            </div>
          )}

          {lesson.audioUrl && (
            <div>
              <h2 className="text-xl font-semibold text-gray-900 mb-2">Audio Content</h2>
              <audio controls className="w-full">
                <source src={lesson.audioUrl} type="audio/mpeg" />
                Your browser does not support the audio element.
              </audio>
            </div>
          )}

          <div className="flex gap-4 pt-4">
            <button className="btn btn-primary">
              Start Lesson
            </button>
            <button className="btn btn-secondary">
              Take Notes
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LessonDetailPage;
