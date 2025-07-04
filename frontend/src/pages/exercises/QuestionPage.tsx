/**
 * ================================================================
 * QUESTION PAGE COMPONENT
 * ================================================================
 * Hiển thị và xử lý câu hỏi trong exercise
 */

import React, { useCallback, useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import Breadcrumb from '../../components/ui/Breadcrumb';
import LoadingSpinner from '../../components/ui/LoadingSpinner';
import { useAuth } from '../../contexts/AuthContext';
import { useBreadcrumb } from '../../hooks/useBreadcrumb';
import { exerciseService } from '../../services/exercises';
import { questionService } from '../../services/questions';
import { Exercise, Question, QuestionAnswerRequest } from '../../types';


const QuestionPage: React.FC = () => {
    const { lessonId, exerciseId } = useParams<{ lessonId: string; exerciseId: string }>();
    const navigate = useNavigate();
    const { currentUser } = useAuth();
    const breadcrumbItems = useBreadcrumb();

    const [exercise, setExercise] = useState<Exercise | null>(null);
    const [questions, setQuestions] = useState<Question[]>([]);
    const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
    const [answers, setAnswers] = useState<{ [questionId: number]: string }>({});
    const [timeLeft, setTimeLeft] = useState<number>(0);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [showCompletionModal, setShowCompletionModal] = useState(false);
    const [completionData, setCompletionData] = useState<{
        score: number;
        correctAnswers: number;
        totalQuestions: number;
        points: number;
    } | null>(null);

    const calculateScore = useCallback((): number => {
        const answeredQuestions = Object.keys(answers).length;
        return Math.round((answeredQuestions / questions.length) * 100);
    }, [answers, questions.length]);

    const handleSubmitExercise = useCallback(async () => {
        if (!exercise || questions.length === 0) return;

        setIsSubmitting(true);
        try {
            console.log('🎯 Submitting exercise completion...');

            // Convert answers to the format expected by backend
            const answerRequests: QuestionAnswerRequest[] = questions.map(question => ({
                questionId: question.id,
                selectedAnswer: answers[question.id] || '',
                timeTaken: timeLeft > 0 ? (exercise.timeLimit! * 60 - timeLeft) : undefined
            }));

            // Submit answers to backend
            const result = await questionService.submitExerciseAnswers(exercise.id, answerRequests);

            console.log('✅ Exercise submitted successfully:', result);

            // Calculate final score
            const finalScore = calculateScore();
            const correctAnswers = Object.values(answers).filter(answer => answer).length;
            const totalQuestions = questions.length;

            setCompletionData({
                score: finalScore,
                correctAnswers,
                totalQuestions,
                points: correctAnswers * 10
            });

            // Show completion notification
            setShowCompletionModal(true);

            // Update user progress (if API exists)
            try {
                await fetch(`/api/users/${currentUser?.id}/progress`, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        lessonId: parseInt(lessonId!),
                        exerciseId: exercise.id,
                        completed: true,
                        score: finalScore,
                        answersCorrect: correctAnswers,
                        totalQuestions,
                        completedAt: new Date().toISOString()
                    })
                });
                console.log('✅ User progress updated');
            } catch (progressError) {
                console.warn('⚠️ Failed to update progress, but continuing...');
            }

            // Navigate back to lesson page with success state
            setTimeout(() => {
                navigate(`/lessons/${lessonId}`, {
                    state: {
                        message: `Bài tập "${exercise.title}" hoàn thành thành công!`,
                        score: finalScore,
                        exerciseCompleted: true,
                        exerciseId: exercise.id
                    }
                });
            }, 2000);

        } catch (err: any) {
            console.error('❌ Error submitting exercise:', err);
            alert(`❌ Lỗi khi nộp bài: ${err.message || 'Vui lòng thử lại sau'}`);
        } finally {
            setIsSubmitting(false);
        }
    }, [exercise, questions, answers, timeLeft, lessonId, navigate, calculateScore, currentUser]);

    useEffect(() => {
        const fetchExerciseAndQuestions = async () => {
            if (!lessonId || !exerciseId) {
                setError('Exercise not found');
                setLoading(false);
                return;
            }

            try {
                setLoading(true);
                console.log(`🔍 Fetching exercise ${exerciseId} for lesson ${lessonId}...`);

                // Fetch exercise details
                const exerciseData = await exerciseService.getExerciseById(
                    parseInt(exerciseId)
                );
                setExercise(exerciseData);

                // Fetch questions for this exercise
                const questionsData = await questionService.getQuestionsByExercise(parseInt(exerciseId));
                setQuestions(questionsData);

                // Set timer if exercise has time limit
                if (exerciseData.timeLimit) {
                    setTimeLeft(exerciseData.timeLimit * 60); // Convert minutes to seconds
                }

                setError(null);
            } catch (err: any) {
                console.error('❌ Error fetching exercise:', err);
                setError(err.message || 'Failed to load exercise');
            } finally {
                setLoading(false);
            }
        };

        fetchExerciseAndQuestions();
    }, [lessonId, exerciseId]);

    // Timer effect
    useEffect(() => {
        if (timeLeft <= 0) return;

        const timer = setInterval(() => {
            setTimeLeft(prev => {
                if (prev <= 1) {
                    handleSubmitExercise();
                    return 0;
                }
                return prev - 1;
            });
        }, 1000);

        return () => clearInterval(timer);
    }, [timeLeft, handleSubmitExercise]);

    const handleAnswerSelect = (questionId: number, answer: string) => {
        setAnswers(prev => ({
            ...prev,
            [questionId]: answer
        }));
    };

    const handleNextQuestion = () => {
        if (currentQuestionIndex < questions.length - 1) {
            setCurrentQuestionIndex(prev => prev + 1);
        }
    };

    const handlePreviousQuestion = () => {
        if (currentQuestionIndex > 0) {
            setCurrentQuestionIndex(prev => prev - 1);
        }
    };

    const formatTime = (seconds: number): string => {
        const minutes = Math.floor(seconds / 60);
        const remainingSeconds = seconds % 60;
        return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
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

    // If no questions loaded, show preview
    if (questions.length === 0) {
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

                {/* No Questions Available */}
                <div className="card border-yellow-200 bg-yellow-50">
                    <div className="card-body text-center">
                        <div className="text-6xl mb-4">📚</div>
                        <h3 className="text-lg font-semibold text-yellow-900 mb-2">No Questions Available</h3>
                        <p className="text-yellow-800 text-sm mb-4">
                            This exercise doesn't have any questions yet. Please check back later or contact your instructor.
                        </p>
                        <button
                            onClick={() => navigate(`/lessons/${lessonId}/exercises`)}
                            className="btn btn-outline"
                        >
                            ← Back to Exercises
                        </button>
                    </div>
                </div>
            </div>
        );
    }

    const currentQuestion = questions[currentQuestionIndex];
    const progress = ((currentQuestionIndex + 1) / questions.length) * 100;

    // Helper function to get question text
    const getQuestionText = (question: Question) => {
        return question.questionText || '';
    };

    // Helper function to get options array from backend format
    const getOptionsArray = (question: Question): string[] => {
        // Only use properties that exist in the Question type

        // Convert backend format to array
        const options: string[] = [];
        if (question.optionA) options.push(question.optionA);
        if (question.optionB) options.push(question.optionB);
        if (question.optionC) options.push(question.optionC);
        if (question.optionD) options.push(question.optionD);

        return options;
    };

    return (
        <div className="max-w-4xl mx-auto space-y-6">
            {/* Breadcrumb Navigation */}
            <Breadcrumb items={breadcrumbItems} />

            {/* Header with Timer and Progress */}
            <div className="flex justify-between items-center">
                <div>
                    <h1 className="text-2xl font-bold text-gray-900">{exercise.title}</h1>
                </div>

                {timeLeft > 0 && (
                    <div className={`text-lg font-mono ${timeLeft < 300 ? 'text-red-600' : 'text-gray-700'}`}>
                        ⏰ {formatTime(timeLeft)}
                    </div>
                )}
            </div>

            {/* Progress Bar */}
            <div className="w-full bg-gray-200 rounded-full h-2">
                <div
                    className="bg-blue-600 h-2 rounded-full transition-all duration-300"
                    style={{ width: `${progress}%` }}
                ></div>
            </div>
            <div className="flex justify-between text-sm text-gray-600">
                <span>Question {currentQuestionIndex + 1} of {questions.length}</span>
                <span>{Math.round(progress)}% Complete</span>
            </div>

            {/* Question Card */}
            <div className="card">
                <div className="card-body">
                    <div className="mb-6">
                        <div className="flex items-center gap-3 mb-4">
                            <span className="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
                                Question {currentQuestionIndex + 1}
                            </span>
                            <span className={`px-3 py-1 rounded-full text-sm font-medium ${currentQuestion.difficulty === 'EASY' ? 'bg-green-100 text-green-800' :
                                currentQuestion.difficulty === 'MEDIUM' ? 'bg-yellow-100 text-yellow-800' :
                                    'bg-red-100 text-red-800'
                                }`}>
                                {currentQuestion.difficulty}
                            </span>
                        </div>

                        <h2 className="text-lg font-semibold text-gray-900 mb-4">
                            {getQuestionText(currentQuestion)}
                        </h2>

                        {currentQuestion.imageUrl && (
                            <img
                                src={currentQuestion.imageUrl}
                                alt="Question"
                                className="w-full max-w-md mx-auto mb-4 rounded-lg"
                            />
                        )}

                        {currentQuestion.audioUrl && (
                            <div className="mb-4">
                                <audio controls className="w-full">
                                    <source src={currentQuestion.audioUrl} type="audio/mpeg" />
                                    Your browser does not support the audio element.
                                </audio>
                            </div>
                        )}
                    </div>

                    {/* Answer Options */}
                    <div className="space-y-3">
                        {getOptionsArray(currentQuestion).map((option, index) => {
                            const optionLetter = String.fromCharCode(65 + index); // A, B, C, D
                            const isSelected = answers[currentQuestion.id] === optionLetter;

                            return (
                                <button
                                    key={index}
                                    onClick={() => handleAnswerSelect(currentQuestion.id, optionLetter)}
                                    className={`w-full p-4 text-left border rounded-lg transition-all ${isSelected
                                        ? 'border-blue-500 bg-blue-50 text-blue-900'
                                        : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50'
                                        }`}
                                >
                                    <div className="flex items-center gap-3">
                                        <span className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-semibold ${isSelected
                                            ? 'bg-blue-500 text-white'
                                            : 'bg-gray-200 text-gray-700'
                                            }`}>
                                            {optionLetter}
                                        </span>
                                        <span>{option}</span>
                                    </div>
                                </button>
                            );
                        })}
                    </div>
                </div>
            </div>

            {/* Navigation Controls */}
            <div className="flex justify-between items-center">
                <button
                    onClick={handlePreviousQuestion}
                    disabled={currentQuestionIndex === 0}
                    className="btn btn-outline disabled:opacity-50 disabled:cursor-not-allowed"
                >
                    ← Previous
                </button>

                <div className="flex gap-2">
                    {questions.map((_, index) => (
                        <button
                            key={index}
                            onClick={() => setCurrentQuestionIndex(index)}
                            className={`w-8 h-8 rounded-full text-sm font-medium ${index === currentQuestionIndex
                                ? 'bg-blue-500 text-white'
                                : answers[questions[index].id]
                                    ? 'bg-green-100 text-green-800'
                                    : 'bg-gray-200 text-gray-700'
                                }`}
                        >
                            {index + 1}
                        </button>
                    ))}
                </div>

                {currentQuestionIndex === questions.length - 1 ? (
                    <button
                        onClick={() => {
                            const unansweredCount = questions.length - Object.keys(answers).length;

                            if (unansweredCount > 0) {
                                const confirmSubmit = window.confirm(
                                    `Bạn chưa trả lời ${unansweredCount} câu hỏi.\nBạn có chắc chắn muốn nộp bài không?`
                                );
                                if (!confirmSubmit) {
                                    return;
                                }
                            }

                            handleSubmitExercise();
                        }}
                        disabled={isSubmitting}
                        className="btn btn-primary disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2"
                    >
                        {isSubmitting ? (
                            <>
                                <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                                <span>Đang nộp bài...</span>
                            </>
                        ) : (
                            <>
                                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                                <span>Submit Exercise</span>
                            </>
                        )}
                    </button>
                ) : (
                    <button
                        onClick={handleNextQuestion}
                        disabled={currentQuestionIndex === questions.length - 1}
                        className="btn btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        Next →
                    </button>
                )}
            </div>

            {/* Exercise Summary */}
            <div className="card border-gray-200 bg-gray-50">
                <div className="card-body">
                    <h3 className="font-semibold text-gray-900 mb-3">Progress Summary</h3>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                        <div className="text-center">
                            <div className="font-semibold text-blue-600">{Object.keys(answers).length}</div>
                            <div className="text-gray-600">Answered</div>
                        </div>
                        <div className="text-center">
                            <div className="font-semibold text-gray-600">{questions.length - Object.keys(answers).length}</div>
                            <div className="text-gray-600">Remaining</div>
                        </div>
                        <div className="text-center">
                            <div className="font-semibold text-green-600">{Math.round(progress)}%</div>
                            <div className="text-gray-600">Complete</div>
                        </div>
                        <div className="text-center">
                            <div className="font-semibold text-orange-600">{currentQuestion.points || 10}</div>
                            <div className="text-gray-600">Points</div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Completion Modal */}
            {showCompletionModal && completionData && (
                <div className="fixed inset-0 flex items-center justify-center z-50">
                    <div className="bg-white rounded-lg shadow-lg p-6 max-w-sm w-full">
                        <h2 className="text-xl font-bold text-center mb-4">🎉 Congratulations!</h2>
                        <div className="text-center mb-4">
                            <svg className="w-16 h-16 mx-auto text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <p className="text-gray-700 text-center mb-4">
                            Bạn đã hoàn thành bài tập này với kết quả xuất sắc!
                        </p>
                        <div className="grid grid-cols-2 gap-4 text-sm text-gray-600 mb-4">
                            <div className="text-center">
                                <div className="font-semibold text-gray-900">{completionData.correctAnswers}</div>
                                <div>Câu đúng</div>
                            </div>
                            <div className="text-center">
                                <div className="font-semibold text-gray-900">{questions.length - completionData.correctAnswers}</div>
                                <div>Câu sai</div>
                            </div>
                            <div className="text-center">
                                <div className="font-semibold text-gray-900">{completionData.totalQuestions}</div>
                                <div>Tổng câu hỏi</div>
                            </div>
                            <div className="text-center">
                                <div className="font-semibold text-gray-900">{completionData.points} điểm</div>
                                <div>Điểm thưởng</div>
                            </div>
                        </div>
                        <div className="flex justify-center gap-2">
                            <button
                                onClick={() => {
                                    setShowCompletionModal(false);
                                    navigate(`/lessons/${lessonId}`);
                                }}
                                className="btn btn-primary flex-1"
                            >
                                Quay lại bài học
                            </button>
                            <button
                                onClick={() => setShowCompletionModal(false)}
                                className="btn btn-outline flex-1"
                            >
                                Xem lại bài tập
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default QuestionPage;