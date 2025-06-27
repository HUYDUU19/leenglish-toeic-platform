// package com.leenglish.toeic.domain;

// import jakarta.persistence.*;
// import java.time.LocalDateTime;

// @Entity
// @Table(name = "user_question_answers")
// public class UserQuestionAnswer {

//     @Id
//     @GeneratedValue(strategy = GenerationType.IDENTITY)
//     private Long id;

//     @ManyToOne(fetch = FetchType.LAZY)
//     @JoinColumn(name = "user_id")
//     private User user;

//     @ManyToOne(fetch = FetchType.LAZY)
//     @JoinColumn(name = "exercise_question_id")
//     private ExerciseQuestion exerciseQuestion;

//     @ManyToOne(fetch = FetchType.LAZY)
//     @JoinColumn(name = "user_exercise_attempt_id")
//     private UserExerciseAttempt userExerciseAttempt;

//     @Column(name = "user_answer", columnDefinition = "TEXT")
//     private String userAnswer;

//     @Column(name = "is_correct")
//     private Boolean isCorrect = false;

//     @Column(name = "time_taken")
//     private Integer timeTaken; // seconds taken to answer this question

//     @Column(name = "answered_at")
//     private LocalDateTime answeredAt = LocalDateTime.now();

//     // Constructors
//     public UserQuestionAnswer() {
//     }

//     public UserQuestionAnswer(User user, ExerciseQuestion exerciseQuestion,
//             UserExerciseAttempt userExerciseAttempt, String userAnswer) {
//         this.user = user;
//         this.exerciseQuestion = exerciseQuestion;
//         this.userExerciseAttempt = userExerciseAttempt;
//         this.userAnswer = userAnswer;
//         this.answeredAt = LocalDateTime.now();
//         this.isCorrect = exerciseQuestion.isCorrect(userAnswer);
//     }

//     // Getters and Setters
//     public Long getId() {
//         return id;
//     }

//     public void setId(Long id) {
//         this.id = id;
//     }

//     public User getUser() {
//         return user;
//     }

//     public void setUser(User user) {
//         this.user = user;
//     }

//     public ExerciseQuestion getExerciseQuestion() {
//         return exerciseQuestion;
//     }

//     public void setExerciseQuestion(ExerciseQuestion exerciseQuestion) {
//         this.exerciseQuestion = exerciseQuestion;
//     }

//     public UserExerciseAttempt getUserExerciseAttempt() {
//         return userExerciseAttempt;
//     }

//     public void setUserExerciseAttempt(UserExerciseAttempt userExerciseAttempt) {
//         this.userExerciseAttempt = userExerciseAttempt;
//     }

//     public String getUserAnswer() {
//         return userAnswer;
//     }

//     public void setUserAnswer(String userAnswer) {
//         this.userAnswer = userAnswer;
//         // Auto-check correctness when answer is set
//         if (this.exerciseQuestion != null) {
//             this.isCorrect = this.exerciseQuestion.isCorrect(userAnswer);
//         }
//     }

//     public Boolean getIsCorrect() {
//         return isCorrect;
//     }

//     public void setIsCorrect(Boolean isCorrect) {
//         this.isCorrect = isCorrect;
//     }

//     public Integer getTimeTaken() {
//         return timeTaken;
//     }

//     public void setTimeTaken(Integer timeTaken) {
//         this.timeTaken = timeTaken;
//     }

//     public LocalDateTime getAnsweredAt() {
//         return answeredAt;
//     }

//     public void setAnsweredAt(LocalDateTime answeredAt) {
//         this.answeredAt = answeredAt;
//     }

//     // Business Logic Methods
//     public boolean isAnswered() {
//         return userAnswer != null && !userAnswer.trim().isEmpty();
//     }

//     public void checkCorrectness() {
//         if (exerciseQuestion != null && userAnswer != null) {
//             this.isCorrect = exerciseQuestion.isCorrect(userAnswer);
//         }
//     }

//     public String getCorrectAnswer() {
//         return exerciseQuestion != null ? exerciseQuestion.getCorrectAnswer() : null;
//     }

//     public long getTimeTakenInMinutes() {
//         return timeTaken != null ? timeTaken / 60 : 0;
//     }

//     public boolean isQuickAnswer(int thresholdSeconds) {
//         return timeTaken != null && timeTaken < thresholdSeconds;
//     }

//     public boolean isSlowAnswer(int thresholdSeconds) {
//         return timeTaken != null && timeTaken > thresholdSeconds;
//     }
// }
