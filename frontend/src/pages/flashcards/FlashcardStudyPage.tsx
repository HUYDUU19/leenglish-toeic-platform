/**
 * ================================================================
 * FLASHCARD STUDY PAGE COMPONENT
 * ================================================================
 */

import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import LoadingSpinner from '../../components/ui/LoadingSpinner';
import { useAuth } from '../../contexts/AuthContext';
import apiClient from '../../services/api';
import { Flashcard, FlashcardSet } from '../../types'; // ✅ Import unified types

const FlashcardStudyPage: React.FC = () => {
    const { setId } = useParams<{ setId: string }>();
    const navigate = useNavigate();
    const { isAuthenticated } = useAuth();

    const [flashcardSet, setFlashcardSet] = useState<FlashcardSet | null>(null);
    const [currentCardIndex, setCurrentCardIndex] = useState(0);
    const [isFlipped, setIsFlipped] = useState(false);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const fetchFlashcardSet = async () => {
            if (!setId) {
                setError('Invalid flashcard set ID');
                setLoading(false);
                return;
            }

            try {
                setLoading(true);
                setError(null);

                // Strategy 1: Try authenticated endpoint first
                if (isAuthenticated) {
                    try {
                        console.log(`Fetching flashcard set ${setId} for authenticated user...`);
                        const response = await apiClient.get(`/flashcards/sets/${setId}`);
                        setFlashcardSet(response.data);
                        return;
                    } catch (authError: any) {
                        console.warn('Failed to fetch authenticated set:', authError.response?.status);
                        // Continue to free endpoint
                    }
                }

                // Strategy 2: Try free endpoint
                try {
                    console.log(`Fetching free flashcard set ${setId}...`);
                    const response = await apiClient.get(`/flashcards/free/${setId}`);
                    setFlashcardSet(response.data);
                    return;
                } catch (freeError: any) {
                    console.warn('Failed to fetch free set:', freeError.response?.status);
                    throw new Error('Flashcard set not found or requires premium access');
                }

            } catch (err: any) {
                console.error('Error fetching flashcard set:', err);
                setError(err.message || 'Failed to load flashcard set');

                // ✅ Updated fallback data with all required properties
                const fallbackFlashcards: Flashcard[] = [
                    {
                        id: 1,
                        setId: parseInt(setId!), // ✅ Use setId instead of flashcardSetId
                        frontText: 'Hello',
                        backText: 'A greeting used when meeting someone',
                        hint: 'A common greeting', // ✅ Now hint is allowed
                        imageUrl: '/images/flashcards/hello.jpg',
                        audioUrl: '/audio/flashcards/hello.mp3',
                        difficultyLevel: 'BEGINNER',
                        tags: 'greeting,basic,conversation', // ✅ Now tags is allowed
                        orderIndex: 1,
                        isActive: true,
                        createdAt: new Date().toISOString(),
                        updatedAt: new Date().toISOString(),
                        flashcardSetId: parseInt(setId!) // ✅ Keep for compatibility
                    },
                    {
                        id: 2,
                        setId: parseInt(setId!),
                        frontText: 'Thank you',
                        backText: 'An expression of gratitude',
                        hint: 'Used to show appreciation', // ✅ Now hint is allowed
                        difficultyLevel: 'BEGINNER',
                        tags: 'politeness,basic,gratitude', // ✅ Now tags is allowed
                        orderIndex: 2,
                        isActive: true,
                        createdAt: new Date().toISOString(),
                        updatedAt: new Date().toISOString(),
                        flashcardSetId: parseInt(setId!)
                    },
                    {
                        id: 3,
                        setId: parseInt(setId!),
                        frontText: 'Goodbye',
                        backText: 'A farewell expression',
                        hint: 'Used when leaving or ending a conversation', // ✅ Now hint is allowed
                        difficultyLevel: 'BEGINNER',
                        tags: 'farewell,basic,conversation', // ✅ Now tags is allowed
                        orderIndex: 3,
                        isActive: true,
                        createdAt: new Date().toISOString(),
                        updatedAt: new Date().toISOString(),
                        flashcardSetId: parseInt(setId!)
                    }
                ];

                // ✅ Updated fallback set with all required properties
                const fallbackSet: FlashcardSet = {
                    id: parseInt(setId!),
                    name: 'Essential Greetings Flashcards',
                    title: 'Essential Greetings Flashcards', // ✅ Add title for compatibility
                    description: 'Basic greeting vocabulary for beginners',
                    difficultyLevel: 'BEGINNER',
                    isPremium: false,
                    isPublic: true, // ✅ Add required isPublic property
                    estimatedTimeMinutes: 15,
                    tags: 'greetings,basic,vocabulary,essential',
                    viewCount: 0,
                    isActive: true,
                    createdAt: new Date().toISOString(),
                    updatedAt: new Date().toISOString(),
                    createdBy: 1,
                    flashcards: fallbackFlashcards
                };

                setFlashcardSet(fallbackSet);
            } finally {
                setLoading(false);
            }
        };

        fetchFlashcardSet();
    }, [setId, isAuthenticated]);

    const handleNext = () => {
        if (flashcardSet && flashcardSet.flashcards && currentCardIndex < flashcardSet.flashcards.length - 1) {
            setCurrentCardIndex(currentCardIndex + 1);
            setIsFlipped(false);
        }
    };

    const handlePrevious = () => {
        if (currentCardIndex > 0) {
            setCurrentCardIndex(currentCardIndex - 1);
            setIsFlipped(false);
        }
    };


    const handleFlip = () => {
        setIsFlipped(!isFlipped);
    };

    const handleFinishStudy = () => {
        // Record study session
        if (isAuthenticated && flashcardSet) {
            apiClient.post(`/flashcards/sets/${flashcardSet.id}/complete`).catch(console.error);
        }
        navigate('/flashcards');
    };

    if (loading) {
        return (
            <div className="flex justify-center items-center min-h-64">
                <LoadingSpinner size="lg" />
            </div>
        );
    }

    // ✅ Fix error check to include flashcards validation
    if (error || !flashcardSet || !flashcardSet.flashcards || flashcardSet.flashcards.length === 0) {
        return (
            <div className="max-w-4xl mx-auto p-6">
                <div className="bg-red-50 border border-red-200 rounded-lg p-4">
                    <h2 className="text-lg font-semibold text-red-800 mb-2">Error Loading Flashcards</h2>
                    <p className="text-red-600 mb-4">
                        {error ||
                            !flashcardSet ? 'Flashcard set not found' :
                            'No flashcards available in this set'}
                    </p>
                    <button
                        onClick={() => navigate('/flashcards')}
                        className="btn btn-primary"
                    >
                        Back to Flashcards
                    </button>
                </div>
            </div>
        );
    }

    // ✅ Now we can safely access flashcards - TypeScript knows it's not undefined
    const currentCard = flashcardSet.flashcards[currentCardIndex];
    const progress = ((currentCardIndex + 1) / flashcardSet.flashcards.length) * 100;


    return (
        <div className="max-w-4xl mx-auto p-6">
            {/* Header */}
            <div className="mb-6">
                <div className="flex items-center justify-between mb-4">
                    <button
                        onClick={() => navigate('/flashcards')}
                        className="btn btn-secondary"
                    >
                        ← Back to Sets
                    </button>
                    <div className="text-sm text-gray-500">
                        Card {currentCardIndex + 1} of {flashcardSet.flashcards.length}
                    </div>
                </div>

                <h1 className="text-2xl font-bold text-gray-900 mb-2">
                    {flashcardSet.title || flashcardSet.name}
                </h1>
                <p className="text-gray-600">{flashcardSet.description}</p>

                {/* Set Info */}
                <div className="flex gap-4 text-sm text-gray-500 mt-2">
                    {flashcardSet.estimatedTimeMinutes && (
                        <span>⏱️ {flashcardSet.estimatedTimeMinutes} min</span>
                    )}
                    {flashcardSet.viewCount !== undefined && (
                        <span>👀 {flashcardSet.viewCount} views</span>
                    )}
                    {flashcardSet.isPublic ? (
                        <span>🌐 Public</span>
                    ) : (
                        <span>🔒 Private</span>
                    )}
                    {flashcardSet.isPremium && (
                        <span>⭐ Premium</span>
                    )}
                </div>

                {/* Progress Bar */}
                <div className="mt-4">
                    <div className="w-full bg-gray-200 rounded-full h-2">
                        <div
                            className="bg-blue-600 h-2 rounded-full transition-all duration-300"
                            style={{ width: `${progress}%` }}
                        ></div>
                    </div>
                </div>
            </div>

            {/* Flashcard */}
            <div className="mb-8">
                <div className="relative">
                    <div
                        className={`card min-h-80 cursor-pointer transition-transform duration-300 ${isFlipped ? 'scale-95' : ''
                            }`}
                        onClick={handleFlip}
                    >
                        <div className="card-body flex items-center justify-center text-center">
                            {!isFlipped ? (
                                /* Front of card */
                                <div>
                                    <h2 className="text-3xl font-bold text-gray-900 mb-4">
                                        {currentCard.frontText}
                                    </h2>
                                    {currentCard.imageUrl && (
                                        <img
                                            src={currentCard.imageUrl}
                                            alt={currentCard.frontText}
                                            className="max-w-xs mx-auto rounded-lg"
                                            onError={(e) => {
                                                // Hide image if failed to load
                                                e.currentTarget.style.display = 'none';
                                            }}
                                        />
                                    )}
                                    {/* ✅ Now hint access is safe */}
                                    {currentCard.hint && (
                                        <p className="text-sm text-blue-600 mb-4">
                                            💡 {currentCard.hint}
                                        </p>
                                    )}
                                    <p className="text-sm text-gray-500 mt-6">Click to see answer</p>
                                </div>
                            ) : (
                                /* Back of card */
                                <div>
                                    <h3 className="text-xl font-semibold text-gray-700 mb-4">
                                        {currentCard.frontText}
                                    </h3>
                                    <p className="text-lg text-gray-900 mb-4">
                                        {currentCard.backText}
                                    </p>

                                    {/* Audio */}
                                    {currentCard.audioUrl && (
                                        <audio controls className="mx-auto mb-4">
                                            <source src={currentCard.audioUrl} type="audio/mpeg" />
                                            Your browser does not support audio playback.
                                        </audio>
                                    )}

                                    {/* ✅ Tags access is now safe */}
                                    {currentCard.tags && (
                                        <div className="flex flex-wrap gap-2 justify-center mb-4">
                                            {currentCard.tags.split(',').map((tag: string, index: number) => (
                                                <span
                                                    key={index}
                                                    className="text-xs bg-blue-100 text-blue-800 px-2 py-1 rounded"
                                                >
                                                    {tag.trim()}
                                                </span>
                                            ))}
                                        </div>
                                    )}

                                    {/* Difficulty Badge */}
                                    {currentCard.difficultyLevel && (
                                        <span className={`text-xs px-2 py-1 rounded ${currentCard.difficultyLevel === 'BEGINNER' ? 'bg-green-100 text-green-800' :
                                            currentCard.difficultyLevel === 'INTERMEDIATE' ? 'bg-yellow-100 text-yellow-800' :
                                                'bg-red-100 text-red-800'
                                            }`}>
                                            {currentCard.difficultyLevel}
                                        </span>
                                    )}
                                </div>
                            )}
                        </div>
                    </div>

                    {/* Flip indicator */}
                    <div className="absolute top-4 right-4">
                        <span className="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded">
                            {isFlipped ? 'Answer' : 'Question'}
                        </span>
                    </div>

                    {/* Card order indicator */}
                    {currentCard.orderIndex && (
                        <div className="absolute top-4 left-4">
                            <span className="text-xs bg-blue-100 text-blue-600 px-2 py-1 rounded">
                                #{currentCard.orderIndex}
                            </span>
                        </div>
                    )}
                </div>
            </div>

            {/* Navigation Controls */}
            <div className="flex items-center justify-between">
                <button
                    onClick={handlePrevious}
                    disabled={currentCardIndex === 0}
                    className="btn btn-secondary disabled:opacity-50"
                >
                    ← Previous
                </button>

                <div className="flex gap-2">
                    <button
                        onClick={handleFlip}
                        className="btn btn-outline"
                    >
                        {isFlipped ? 'Show Question' : 'Show Answer'}
                    </button>
                </div>

                {/* ✅ Safe access - we already validated flashcards exists */}
                {currentCardIndex < flashcardSet.flashcards.length - 1 ? (
                    <button
                        onClick={handleNext}
                        className="btn btn-primary"
                    >
                        Next →
                    </button>
                ) : (
                    <button
                        onClick={handleFinishStudy}
                        className="btn btn-success"
                    >
                        Finish Study
                    </button>
                )}
            </div>

            {/* Study Progress & Set Info */}
            <div className="mt-8 p-4 bg-gray-50 rounded-lg">
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm text-gray-600">
                    <div>
                        <strong>Progress:</strong> {Math.round(progress)}%
                    </div>
                    <div>
                        <strong>Set Difficulty:</strong>
                        <span className={`ml-1 px-2 py-1 rounded text-xs ${flashcardSet.difficultyLevel === 'BEGINNER' ? 'bg-green-100 text-green-800' :
                            flashcardSet.difficultyLevel === 'INTERMEDIATE' ? 'bg-yellow-100 text-yellow-800' :
                                'bg-red-100 text-red-800'
                            }`}>
                            {flashcardSet.difficultyLevel}
                        </span>
                    </div>
                    <div>
                        <strong>Estimated Time:</strong> {flashcardSet.estimatedTimeMinutes || 'N/A'} min
                    </div>
                </div>

                {/* Set Tags */}
                {flashcardSet.tags && (
                    <div className="mt-3">
                        <strong className="text-sm text-gray-600">Set Tags:</strong>
                        <div className="flex flex-wrap gap-1 mt-1">
                            {flashcardSet.tags.split(',').map((tag: string, index: number) => (
                                <span
                                    key={index}
                                    className="text-xs bg-gray-200 text-gray-700 px-2 py-1 rounded"
                                >
                                    {tag.trim()}
                                </span>
                            ))}
                        </div>
                    </div>
                )}

                {/* Access Info */}
                <div className="mt-3 text-sm text-gray-600">
                    <strong>Access:</strong>
                    <span className="ml-2">
                        {flashcardSet.isPublic ? '🌐 Public' : '🔒 Private'}
                        {flashcardSet.isPremium && ' • ⭐ Premium Required'}
                    </span>
                </div>
            </div>

            {/* Demo Notice for unauthenticated users */}
            {!isAuthenticated && (
                <div className="mt-6 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
                    <div className="flex items-start">
                        <span className="text-2xl mr-3">ℹ️</span>
                        <div>
                            <h4 className="font-semibold text-yellow-900 mb-2">Guest Mode</h4>
                            <p className="text-yellow-800 text-sm">
                                You're studying as a guest. <a href="/auth/login" className="underline">Sign in</a> to track your progress and access premium content!
                            </p>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default FlashcardStudyPage;
