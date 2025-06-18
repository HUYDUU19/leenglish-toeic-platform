// Frontend Types for Next.js
export interface User {
  id: number;
  username: string;
  email: string;
  fullName?: string;
  role: 'USER' | 'ADMIN';
  currentLevel: number;
  totalScore: number;
  testsCompleted: number;
  createdAt: string;
  updatedAt: string;
}

export interface Question {
  id: number;
  content: string;
  type: QuestionType;
  section: Section;
  difficultyLevel: number;
  audioUrl?: string;
  imageUrl?: string;
  answers: Answer[];
  createdAt: string;
  updatedAt: string;
}

export interface Answer {
  id: number;
  content: string;
  isCorrect: boolean;
  optionLabel: string;
  questionId: number;
  createdAt: string;
  updatedAt: string;
}

export enum QuestionType {
  LISTENING_PHOTO_DESCRIPTION = 'LISTENING_PHOTO_DESCRIPTION',
  LISTENING_QUESTION_RESPONSE = 'LISTENING_QUESTION_RESPONSE',
  LISTENING_CONVERSATION = 'LISTENING_CONVERSATION',
  LISTENING_SHORT_TALKS = 'LISTENING_SHORT_TALKS',
  READING_INCOMPLETE_SENTENCES = 'READING_INCOMPLETE_SENTENCES',
  READING_TEXT_COMPLETION = 'READING_TEXT_COMPLETION',
  READING_SINGLE_PASSAGE = 'READING_SINGLE_PASSAGE',
  READING_DOUBLE_PASSAGE = 'READING_DOUBLE_PASSAGE',
  READING_TRIPLE_PASSAGE = 'READING_TRIPLE_PASSAGE'
}

export enum Section {
  LISTENING = 'LISTENING',
  READING = 'READING'
}

export interface TestResult {
  userId: number;
  score: number;
  questionsAnswered: number;
  correctAnswers: number;
  section: Section;
  completedAt: string;
}

export interface ApiResponse<T> {
  data: T;
  message?: string;
  success: boolean;
}
