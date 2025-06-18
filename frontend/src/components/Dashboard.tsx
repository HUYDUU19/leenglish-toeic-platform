import React, { useEffect, useState } from 'react';
import { apiService } from '../lib/api';

interface DailyActivityData {
  dailyActivity: { [date: string]: { lessonsCount: number; completedLessons: number; totalTimeMinutes: number } };
  totalDaysActive: number;
  averageLessonsPerDay: number;
  totalLessonsInPeriod: number;
  totalTimeInPeriod: number;
}

interface ProgressStatsData {
  totalLessons: number;
  completedLessons: number;
  inProgressLessons: number;
  notStartedLessons: number;
  overallProgress: number;
  completionRate: number;
  currentStreak: number;
  averageStudyTimeMinutes: number;
  totalTimeSpent: number;
}

interface DashboardProps {
  userId: number;
}

const Dashboard: React.FC<DashboardProps> = ({ userId }) => {
  const [dailyActivity, setDailyActivity] = useState<DailyActivityData | null>(null);
  const [progressStats, setProgressStats] = useState<ProgressStatsData | null>(null);
  const [weeklyProgress, setWeeklyProgress] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [selectedPeriod, setSelectedPeriod] = useState(7);

  useEffect(() => {
    fetchDashboardData();
  }, [userId, selectedPeriod]);
  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      
      // Fetch daily activity
      const dailyResponse = await apiService.getDailyActivity(userId, selectedPeriod);
      setDailyActivity(dailyResponse);

      // Fetch progress summary
      const statsResponse = await apiService.getProgressSummary(userId);
      setProgressStats(statsResponse);

      // Fetch weekly progress
      const weeklyResponse = await apiService.getWeeklyProgress(userId);
      setWeeklyProgress(weeklyResponse);

    } catch (error) {
      console.error('Failed to fetch dashboard data:', error);
    } finally {
      setLoading(false);
    }
  };

  const formatTime = (minutes: number): string => {
    if (minutes < 60) return `${minutes}m`;
    const hours = Math.floor(minutes / 60);
    const mins = minutes % 60;
    return mins > 0 ? `${hours}h ${mins}m` : `${hours}h`;
  };

  const formatDate = (dateString: string): string => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  };

  const getStreakEmoji = (streak: number): string => {
    if (streak >= 30) return '🔥';
    if (streak >= 7) return '⭐';
    if (streak >= 3) return '💪';
    return '📈';
  };

  const getProgressColor = (progress: number): string => {
    if (progress >= 80) return 'text-green-600';
    if (progress >= 50) return 'text-yellow-600';
    return 'text-blue-600';
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading your progress...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="max-w-7xl mx-auto">
        <h1 className="text-3xl font-bold text-gray-900 mb-8">Learning Dashboard</h1>        {/* Period Selector */}
        <div className="mb-6">
          <label htmlFor="period-select" className="block text-sm font-medium text-gray-700 mb-2">
            View Activity for
          </label>
          <select
            id="period-select"
            title="Select time period for activity view"
            value={selectedPeriod}
            onChange={(e) => setSelectedPeriod(Number(e.target.value))}
            className="block w-48 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
          >
            <option value={7}>Last 7 days</option>
            <option value={14}>Last 14 days</option>
            <option value={30}>Last 30 days</option>
          </select>
        </div>

        {/* Stats Overview */}
        {progressStats && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div className="bg-white p-6 rounded-lg shadow-sm border">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <div className={`text-2xl ${getStreakEmoji(progressStats.currentStreak)}`}>
                    {getStreakEmoji(progressStats.currentStreak)}
                  </div>
                </div>
                <div className="ml-4">
                  <p className="text-sm font-medium text-gray-500">Study Streak</p>
                  <p className="text-2xl font-semibold text-gray-900">
                    {progressStats.currentStreak} days
                  </p>
                </div>
              </div>
            </div>

            <div className="bg-white p-6 rounded-lg shadow-sm border">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <div className="text-2xl">📚</div>
                </div>
                <div className="ml-4">
                  <p className="text-sm font-medium text-gray-500">Completed Lessons</p>
                  <p className="text-2xl font-semibold text-gray-900">
                    {progressStats.completedLessons} / {progressStats.totalLessons}
                  </p>
                </div>
              </div>
            </div>

            <div className="bg-white p-6 rounded-lg shadow-sm border">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <div className="text-2xl">⏱️</div>
                </div>
                <div className="ml-4">
                  <p className="text-sm font-medium text-gray-500">Total Study Time</p>
                  <p className="text-2xl font-semibold text-gray-900">
                    {formatTime(progressStats.totalTimeSpent)}
                  </p>
                </div>
              </div>
            </div>

            <div className="bg-white p-6 rounded-lg shadow-sm border">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <div className="text-2xl">📊</div>
                </div>
                <div className="ml-4">
                  <p className="text-sm font-medium text-gray-500">Overall Progress</p>
                  <p className={`text-2xl font-semibold ${getProgressColor(progressStats.overallProgress)}`}>
                    {Math.round(progressStats.overallProgress)}%
                  </p>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Daily Activity Chart */}
        {dailyActivity && (
          <div className="bg-white p-6 rounded-lg shadow-sm border mb-8">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">
              Daily Activity ({selectedPeriod} days)
            </h2>
            
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              {/* Activity Chart */}
              <div>
                <h3 className="text-lg font-medium text-gray-700 mb-3">Study Activity</h3>                <div className="space-y-3">
                  {Object.entries(dailyActivity.dailyActivity).reverse().map(([date, data]) => (
                    <div key={date} className="flex items-center space-x-4">
                      <div className="w-20 text-sm text-gray-600">
                        {formatDate(date)}
                      </div>
                      <div className="flex-1">
                        <div className="flex items-center space-x-2">
                          <div className="bg-blue-200 h-6 rounded flex-grow max-w-full">
                            <div 
                              className="bg-blue-400 h-full rounded transition-all duration-300"
                              style={{ width: `${Math.min(Math.max((data.lessonsCount / 10) * 100, 10), 100)}%` }}
                            />
                          </div>
                          <span className="text-sm text-gray-600 whitespace-nowrap">
                            {data.lessonsCount} lessons
                          </span>
                        </div>
                        <div className="flex items-center space-x-2 mt-1">
                          <div className="bg-green-200 h-4 rounded flex-grow max-w-full">
                            <div 
                              className="bg-green-400 h-full rounded transition-all duration-300"
                              style={{ width: `${Math.min(Math.max((data.completedLessons / Math.max(data.lessonsCount, 1)) * 100, 5), 100)}%` }}
                            />
                          </div>
                          <span className="text-xs text-gray-500 whitespace-nowrap">
                            {data.completedLessons} completed
                          </span>
                        </div>
                      </div>
                      <div className="w-16 text-sm text-gray-600 text-right">
                        {formatTime(data.totalTimeMinutes)}
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Summary Stats */}
              <div>
                <h3 className="text-lg font-medium text-gray-700 mb-3">Period Summary</h3>
                <div className="space-y-4">
                  <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                    <span className="text-sm text-gray-600">Total Days Active</span>
                    <span className="font-semibold">{dailyActivity.totalDaysActive}</span>
                  </div>
                  <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                    <span className="text-sm text-gray-600">Average Lessons/Day</span>
                    <span className="font-semibold">{dailyActivity.averageLessonsPerDay.toFixed(1)}</span>
                  </div>
                  <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                    <span className="text-sm text-gray-600">Total Study Time</span>
                    <span className="font-semibold">{formatTime(dailyActivity.totalTimeInPeriod)}</span>
                  </div>
                  <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                    <span className="text-sm text-gray-600">Total Lessons</span>
                    <span className="font-semibold">{dailyActivity.totalLessonsInPeriod}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Weekly Progress */}
        {weeklyProgress && (
          <div className="bg-white p-6 rounded-lg shadow-sm border">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">This Week</h2>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div className="text-center p-4 bg-blue-50 rounded-lg">
                <div className="text-2xl font-bold text-blue-600">{weeklyProgress.totalLessonsThisWeek}</div>
                <div className="text-sm text-gray-600">Lessons Accessed</div>
              </div>
              <div className="text-center p-4 bg-green-50 rounded-lg">
                <div className="text-2xl font-bold text-green-600">{weeklyProgress.completedThisWeek}</div>
                <div className="text-sm text-gray-600">Completed</div>
              </div>
              <div className="text-center p-4 bg-yellow-50 rounded-lg">
                <div className="text-2xl font-bold text-yellow-600">{weeklyProgress.inProgressThisWeek}</div>
                <div className="text-sm text-gray-600">In Progress</div>
              </div>
              <div className="text-center p-4 bg-purple-50 rounded-lg">
                <div className="text-2xl font-bold text-purple-600">
                  {formatTime(weeklyProgress.totalTimeThisWeek)}
                </div>
                <div className="text-sm text-gray-600">Study Time</div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Dashboard;
