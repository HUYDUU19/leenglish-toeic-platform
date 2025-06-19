import clsx from 'clsx'; // ✅ Import clsx
import React from 'react';

/**
 * ================================================================
 * LOADING SPINNER COMPONENT - LEENGLISH TOEIC PLATFORM
 * ================================================================
 * 
 * Reusable loading spinner with different sizes and variants
 * Used throughout the app for loading states
 */

interface LoadingSpinnerProps {
    /** Size variant of the spinner */
    size?: 'sm' | 'md' | 'lg' | 'xl';
    /** Color variant */
    variant?: 'primary' | 'secondary' | 'white';
    /** Custom className */
    className?: string;
    /** Loading message */
    message?: string;
    /** Show message */
    showMessage?: boolean;
}

const LoadingSpinner: React.FC<LoadingSpinnerProps> = ({
    size = 'md',
    variant = 'primary',
    className,
    message = 'Loading...',
    showMessage = false,
}) => {
    return (
        <div className={clsx('flex flex-col items-center justify-center', className)}>
            {/* Spinner */}
            <div
                className={clsx(
                    // Base styles
                    'animate-spin rounded-full border-2 border-solid border-current border-r-transparent motion-reduce:animate-[spin_1.5s_linear_infinite]',

                    // Size variants
                    {
                        'h-4 w-4': size === 'sm',
                        'h-6 w-6': size === 'md',
                        'h-8 w-8': size === 'lg',
                        'h-12 w-12': size === 'xl',
                    },

                    // Color variants
                    {
                        'text-blue-600': variant === 'primary',
                        'text-gray-600': variant === 'secondary',
                        'text-white': variant === 'white',
                    }
                )}
                role="status"
                aria-label="Loading"
            >
                <span className="sr-only">Loading...</span>
            </div>

            {/* Optional loading message */}
            {showMessage && (
                <p
                    className={clsx(
                        'mt-3 text-sm font-medium',
                        {
                            'text-gray-700': variant !== 'white',
                            'text-white': variant === 'white',
                        }
                    )}
                >
                    {message}
                </p>
            )}
        </div>
    );
};

export default LoadingSpinner;

jest.mock('./services/auth', () => ({
    getCurrentUser: jest.fn(() => null),
    isAuthenticated: jest.fn(() => false),
    // ...
}));
