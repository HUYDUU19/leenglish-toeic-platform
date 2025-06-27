/**
 * ================================================================
 * QUESTION PAGE COMPONENT
 * ================================================================
 * Hiển thị và xử lý câu hỏi trong exercise
 */

import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import LoadingSpinner from '../../components/ui/LoadingSpinner';
import { useAuth } from '../../contexts/AuthContext';
import { lessonService } from '../../services/lessons';
import { Exercise } from '../../types';

const QuestionPage: React.FC = () => {
    const { lessonId, exerciseId } = useParams<{ lessonId: string; exerciseId: string }>();
    const navigate = useNavigate();
    const {currentUser } = useAuth();

    const [exercise, setExercise] = useState<Exercise | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const fetchExercise = async () => {
            if (!lessonId || !exerciseId) {
                setError('Exercise not found');
                setLoading(false);
                return;
            }

            try {
                setLoading(true);
                console.log(`🔍 Fetching exercise ${exerciseId} for lesson ${lessonId}...`);

                // Get lesson để có thông tin exercise
                const lesson = await lessonService.getLessonById(parseInt(lessonId));
                console.log('✅ Lesson data:', lesson);

                // For now, create a mock exercise from lesson data
                const mockExercise: Exercise = {
                    id: parseInt(exerciseId),
                    lessonId: parseInt(lessonId),
                    title: `${lesson.title} - Exercise`,
                    description: 'Practice questions for this lesson',
                    type: 'READING',
                    difficulty: lesson.level === 'A1' || lesson.level === 'A2' ? 'EASY' : 'MEDIUM',
                    orderIndex: 1,
                    timeLimit: 15,
                    totalQuestions: 5,
                    isActive: true,
                    createdAt: new Date().toISOString(),
                    updatedAt: new Date().toISOString()
                };

                setExercise(mockExercise);
                setError(null);
            } catch (err: any) {
                console.error('❌ Error fetching exercise:', err);
                setError(err.message || 'Failed to load exercise');
            } finally {
                setLoading(false);
            }
        };

        fetchExercise();
    }, [lessonId, exerciseId]);

    const handleStartExercise = () => {
        // For now, just simulate completion
        alert(`🎯 Starting ${exercise?.title}\n\nThis is a demo version. In the full version, you would:\n- Answer multiple choice questions\n- Track your time\n- Get detailed results\n\nFor now, this will mark the exercise as completed.`);

        // Navigate back to exercises with success message
        navigate(`/lessons/${lessonId}/exercises`, {
            state: { message: 'Exercise completed successfully!' }
        });
    };

    if (loading) {
        return (
            <div className="flex justify-center items-center min-h-64">
                <LoadingSpinner size="lg" />
            </div>
        );
    }

    if (error || !exercise) {
        return (
            <div className="space-y-6">
                <div>
                    <h1 className="text-3xl font-bold text-gray-900">Exercise Not Available</h1>
                    <p className="mt-2 text-red-600">{error || 'Exercise could not be loaded.'}</p>
                </div>

                <button
                    onClick={() => navigate(`/lessons/${lessonId}/exercises`)}
                    className="btn btn-primary"
                >
                    Back to Exercises
                </button>
            </div>
        );
    }

    return (
        <div className="max-w-4xl mx-auto space-y-6">
            {/* Header */}
            <div>
                <div className="flex items-center gap-2 text-sm text-gray-500 mb-2">
                    <button onClick={() => navigate('/lessons')} className="hover:text-blue-600">
                        Lessons
                    </button>
                    <span>›</span>
                    <button onClick={() => navigate(`/lessons/${lessonId}`)} className="hover:text-blue-600">
                        Lesson {lessonId}
                    </button>
                    <span>›</span>
                    <button onClick={() => navigate(`/lessons/${lessonId}/exercises`)} className="hover:text-blue-600">
                        Exercises
                    </button>
                    <span>›</span>
                    <span>{exercise.title}</span>
                </div>

                <h1 className="text-3xl font-bold text-gray-900">{exercise.title}</h1>
                <p className="mt-2 text-gray-600">{exercise.description}</p>
            </div>

            {/* Exercise Info */}
            <div className="card">
                <div className="card-body">
                    <h2 className="text-xl font-semibold text-gray-900 mb-4">Exercise Overview</h2>

                    <div className="grid md:grid-cols-2 gap-6">
                        <div className="space-y-4">
                            <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                                <span className="text-gray-600">Type:</span>
                                <span className="font-medium">{exercise.type}</span>
                            </div>

                            <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                                <span className="text-gray-600">Difficulty:</span>
                                <span className={`font-medium ${exercise.difficulty === 'EASY' ? 'text-green-600' :
                                        exercise.difficulty === 'MEDIUM' ? 'text-yellow-600' :
                                            'text-red-600'
                                    }`}>
                                    {exercise.difficulty}
                                </span>
                            </div>

                            {exercise.timeLimit && (
                                <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                                    <span className="text-gray-600">Time Limit:</span>
                                    <span className="font-medium">{exercise.timeLimit} minutes</span>
                                </div>
                            )}

                            {exercise.totalQuestions && (
                                <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                                    <span className="text-gray-600">Questions:</span>
                                    <span className="font-medium">{exercise.totalQuestions}</span>
                                </div>
                            )}
                        </div>

                        <div className="flex items-center justify-center">
                            <div className="text-center">
                                <div className="text-6xl mb-4">
                                    {exercise.type === 'READING' ? '📖' :
                                        exercise.type === 'LISTENING' ? '🎧' :
                                            exercise.type === 'VOCABULARY' ? '📝' : '📚'}
                                </div>
                                <p className="text-gray-600">
                                    {exercise.type === 'READING' ? 'Read and comprehend' :
                                        exercise.type === 'LISTENING' ? 'Listen and answer' :
                                            exercise.type === 'VOCABULARY' ? 'Learn new words' : 'Practice grammar'}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Exercise Instructions */}
            <div className="card">
                <div className="card-body">
                    <h3 className="text-lg font-semibold text-gray-900 mb-4">Instructions</h3>
                    <div className="space-y-3 text-gray-600">
                        <p>• Read each question carefully before selecting your answer</p>
                        <p>• You can change your answers before submitting</p>
                        <p>• Make sure to complete all questions within the time limit</p>
                        <p>• Your progress will be saved automatically</p>
                    </div>
                </div>
            </div>

            {/* Action Buttons */}
            <div className="flex gap-4 justify-between">
                <button
                    onClick={() => navigate(`/lessons/${lessonId}/exercises`)}
                    className="btn btn-outline"
                >
                    ← Back to Exercises
                </button>

                <button
                    onClick={handleStartExercise}
                    className="btn btn-primary text-lg px-8"
                >
                    Start Exercise →
                </button>
            </div>

            {/* Demo Notice */}
            <div className="card border-yellow-200 bg-yellow-50">
                <div className="card-body">
                    <div className="flex items-start">
                        <span className="text-2xl mr-3">💡</span>
                        <div>
                            <h4 className="font-semibold text-yellow-900 mb-2">Demo Version</h4>
                            <p className="text-yellow-800 text-sm">
                                This is a simplified version for demonstration. The full version will include:
                                interactive questions, real-time timer, detailed scoring, and progress tracking.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default QuestionPage;