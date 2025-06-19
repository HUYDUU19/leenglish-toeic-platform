/**
 * ================================================================
 * TYPESCRIPT TYPES FOR LEENGLISH TOEIC PLATFORM
 * ================================================================
 * 
 * These types match the backend Java entities and enums
 * Synchronized with backend/src/main/java/com/leenglish/toeic/
 */

// ========== ENUMS ==========

export enum Role {
  USER = 'USER',
  COLLABORATOR = 'COLLABORATOR',
  ADMIN = 'ADMIN'
}

export enum Gender {
  MALE = 'MALE',
  FEMALE = 'FEMALE',
  OTHER = 'OTHER'
}

export enum Skill {
  LISTENING = 'LISTENING',
  READING = 'READING',
  SPEAKING = 'SPEAKING',
  WRITING = 'WRITING'
}

export enum ToeicPart {
  PART1 = 'PART1', // Pictures
  PART2 = 'PART2', // Question-Response
  PART3 = 'PART3', // Conversations
  PART4 = 'PART4', // Short Talks
  PART5 = 'PART5', // Incomplete Sentences
  PART6 = 'PART6', // Text Completion
  PART7 = 'PART7'  // Reading Comprehension
}

export enum DifficultyLevel {
  BEGINNER = 'BEGINNER',
  INTERMEDIATE = 'INTERMEDIATE',
  ADVANCED = 'ADVANCED'
}

export enum QuestionType {
  MULTIPLE_CHOICE = 'MULTIPLE_CHOICE',
  TRUE_FALSE = 'TRUE_FALSE',
  FILL_IN_BLANK = 'FILL_IN_BLANK',
  LISTENING = 'LISTENING',
  READING_COMPREHENSION = 'READING_COMPREHENSION'
}

export enum ExerciseType {
  PRACTICE = 'PRACTICE',
  MOCK_TEST = 'MOCK_TEST',
  QUICK_QUIZ = 'QUICK_QUIZ',
  FULL_TEST = 'FULL_TEST'
}

export enum LessonType {
  GRAMMAR = 'GRAMMAR',
  VOCABULARY = 'VOCABULARY',
  LISTENING = 'LISTENING',
  READING = 'READING',
  SPEAKING = 'SPEAKING',
  WRITING = 'WRITING'
}

export enum ProgressType {
  NOT_STARTED = 'NOT_STARTED',
  IN_PROGRESS = 'IN_PROGRESS',
  COMPLETED = 'COMPLETED'
}

// ========== DOMAIN ENTITIES ==========

export interface User {
  id: number;
  username: string;
  email: string;
  firstName: string;
  lastName: string;
  role: Role;
  gender?: Gender;
  birthDate?: string;
  phoneNumber?: string;
  address?: string;
  targetScore?: number;
  currentLevel?: DifficultyLevel;
  registrationDate: string;
  lastLoginDate?: string;
  isActive: boolean;
  profilePicture?: string;
}

export interface Lesson {
  id: number;
  title: string;
  description: string;
  lessonType: LessonType;
  difficulty: DifficultyLevel;
  skill: Skill;
  toeicPart?: ToeicPart;
  content: string;
  duration: number; // in minutes
  isPublished: boolean;
  createdDate: string;
  updatedDate: string;
  createdBy: User;
  orderIndex: number;
}

export interface Exercise {
  id: number;
  title: string;
  description: string;
  exerciseType: ExerciseType;
  difficulty: DifficultyLevel;
  skill: Skill;
  toeicPart?: ToeicPart;
  timeLimit: number; // in minutes
  passingScore: number;
  isPublished: boolean;
  createdDate: string;
  updatedDate: string;
  createdBy: User;
  lesson?: Lesson;
  questions: Question[];
}

export interface Question {
  id: number;
  questionText: string;
  questionType: QuestionType;
  difficulty: DifficultyLevel;
  skill: Skill;
  toeicPart?: ToeicPart;
  audioUrl?: string;
  imageUrl?: string;
  optionA?: string;
  optionB?: string;
  optionC?: string;
  optionD?: string;
  correctAnswer: string;
  explanation?: string;
  orderIndex: number;
  createdDate: string;
  updatedDate: string;
  createdBy: User;
}

export interface ExerciseQuestion {
  id: number;
  exercise: Exercise;
  question: Question;
  orderIndex: number;
}

export interface UserLessonProgress {
  id: number;
  user: User;
  lesson: Lesson;
  progress: ProgressType;
  completionPercentage: number;
  startDate: string;
  completionDate?: string;
  lastAccessDate: string;
  timeSpent: number; // in minutes
}

export interface UserExerciseAttempt {
  id: number;
  user: User;
  exercise: Exercise;
  score: number;
  totalQuestions: number;
  correctAnswers: number;
  timeSpent: number; // in minutes
  startTime: string;
  endTime: string;
  isPassed: boolean;
}

export interface UserQuestionAnswer {
  id: number;
  user: User;
  question: Question;
  userAnswer: string;
  isCorrect: boolean;
  timeSpent: number; // in seconds
  answeredAt: string;
  exercise?: Exercise;
}

export interface FlashcardSet {
  id: number;
  title: string;
  description: string;
  difficulty: DifficultyLevel;
  skill: Skill;
  isPublished: boolean;
  createdDate: string;
  updatedDate: string;
  createdBy: User;
  flashcards: Flashcard[];
}

export interface Flashcard {
  id: number;
  front: string;
  back: string;
  audioUrl?: string;
  imageUrl?: string;
  orderIndex: number;
  flashcardSet: FlashcardSet;
}

// ========== API RESPONSE TYPES ==========

export interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
  timestamp: string;
}

export interface PaginatedResponse<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;
  first: boolean;
  last: boolean;
}

export interface ErrorResponse {
  success: false;
  message: string;
  details?: string;
  timestamp: string;
}

// ========== AUTH TYPES ==========

export interface LoginRequest {
  username: string;
  password: string;
}

export interface RegisterRequest {
  username: string;
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  gender?: Gender;
  birthDate?: string;
  phoneNumber?: string;
}

export interface AuthResponse {
  user: User;
  token: string;
  expiresAt: string;
}

export interface ChangePasswordRequest {
  currentPassword: string;
  newPassword: string;
  confirmPassword: string;
}

// ========== STATS AND ANALYTICS ==========

export interface UserStats {
  totalLessonsCompleted: number;
  totalExercisesCompleted: number;
  averageScore: number;
  totalTimeSpent: number; // in minutes
  currentStreak: number;
  longestStreak: number;
  skillBreakdown: {
    [key in Skill]: {
      lessonsCompleted: number;
      averageScore: number;
      timeSpent: number;
    };
  };
  partBreakdown: {
    [key in ToeicPart]: {
      questionsAnswered: number;
      correctAnswers: number;
      averageScore: number;
    };
  };
}

export interface DashboardData {
  user: User;
  stats: UserStats;
  recentLessons: UserLessonProgress[];
  recentExercises: UserExerciseAttempt[];
  recommendations: {
    lessons: Lesson[];
    exercises: Exercise[];
  };
  upcomingDeadlines: any[]; // For future membership or challenge features
}

// ========== FORM TYPES ==========

export interface LessonFormData {
  title: string;
  description: string;
  lessonType: LessonType;
  difficulty: DifficultyLevel;
  skill: Skill;
  toeicPart?: ToeicPart;
  content: string;
  duration: number;
  orderIndex: number;
}

export interface ExerciseFormData {
  title: string;
  description: string;
  exerciseType: ExerciseType;
  difficulty: DifficultyLevel;
  skill: Skill;
  toeicPart?: ToeicPart;
  timeLimit: number;
  passingScore: number;
  lessonId?: number;
}

export interface QuestionFormData {
  questionText: string;
  questionType: QuestionType;
  difficulty: DifficultyLevel;
  skill: Skill;
  toeicPart?: ToeicPart;
  audioUrl?: string;
  imageUrl?: string;
  optionA?: string;
  optionB?: string;
  optionC?: string;
  optionD?: string;
  correctAnswer: string;
  explanation?: string;
  orderIndex: number;
}

// ========== UTILITY TYPES ==========

export type LoadingState = 'idle' | 'loading' | 'success' | 'error';

export interface SelectOption {
  value: string;
  label: string;
}

export interface FilterOptions {
  skill?: Skill;
  difficulty?: DifficultyLevel;
  toeicPart?: ToeicPart;
  lessonType?: LessonType;
  exerciseType?: ExerciseType;
}

export interface SortOptions {
  field: string;
  direction: 'asc' | 'desc';
}

export interface PaginationOptions {
  page: number;
  size: number;
}
