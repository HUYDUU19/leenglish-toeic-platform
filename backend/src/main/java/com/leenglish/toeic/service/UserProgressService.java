package com.leenglish.toeic.service;

import com.leenglish.toeic.domain.UserLessonProgress;
import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.domain.Lesson;
import com.leenglish.toeic.dto.UserProgressDto;
import com.leenglish.toeic.repository.UserLessonProgressRepository;
import com.leenglish.toeic.repository.UserRepository;
import com.leenglish.toeic.repository.LessonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class UserProgressService {

    @Autowired
    private UserLessonProgressRepository userLessonProgressRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private LessonRepository lessonRepository;

    public List<UserProgressDto> getUserProgress(Long userId) {
        List<UserLessonProgress> progressList = userLessonProgressRepository
                .findByUserIdOrderByLastAccessedAtDesc(userId);
        return progressList.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public List<UserProgressDto> getCompletedLessons(Long userId) {
        List<UserLessonProgress> progressList = userLessonProgressRepository.findCompletedLessonsByUser(userId);
        return progressList.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public UserProgressDto updateProgress(Long userId, Long lessonId, Integer progressPercentage, Integer timeSpent) {
        Optional<UserLessonProgress> existingProgress = userLessonProgressRepository.findByUserIdAndLessonId(userId,
                lessonId);
        UserLessonProgress progress;

        if (existingProgress.isPresent()) {
            progress = existingProgress.get();
            progress.setProgressPercentage(progressPercentage);
            progress.setTimeSpentMinutes(progress.getTimeSpentMinutes() + timeSpent);
            progress.setLastAccessedAt(LocalDateTime.now());

            if (progressPercentage >= 100) {
                progress.setStatus("COMPLETED");
                progress.setCompletedAt(LocalDateTime.now());
            } else if (progressPercentage > 0) {
                progress.setStatus("IN_PROGRESS");
            }
        } else {
            Optional<User> userOpt = userRepository.findById(userId);
            Optional<Lesson> lessonOpt = lessonRepository.findById(lessonId);

            if (!userOpt.isPresent() || !lessonOpt.isPresent()) {
                throw new RuntimeException("User or Lesson not found");
            }

            progress = new UserLessonProgress();
            progress.setUser(userOpt.get());
            progress.setLesson(lessonOpt.get());
            progress.setProgressPercentage(progressPercentage);
            progress.setTimeSpentMinutes(timeSpent);
            progress.setStartedAt(LocalDateTime.now());
            progress.setLastAccessedAt(LocalDateTime.now());

            if (progressPercentage >= 100) {
                progress.setStatus("COMPLETED");
                progress.setCompletedAt(LocalDateTime.now());
            } else if (progressPercentage > 0) {
                progress.setStatus("IN_PROGRESS");
            } else {
                progress.setStatus("NOT_STARTED");
            }
        }

        UserLessonProgress savedProgress = userLessonProgressRepository.save(progress);
        return convertToDto(savedProgress);
    }

    public Long getCompletedLessonsCount(Long userId) {
        return userLessonProgressRepository.countCompletedLessonsByUser(userId);
    }

    public Double getAverageProgress(Long userId) {
        return userLessonProgressRepository.getAverageProgressByUser(userId);
    }

    public Long getTotalTimeSpent(Long userId) {
        return userLessonProgressRepository.getTotalTimeSpentByUser(userId);
    }

    private UserProgressDto convertToDto(UserLessonProgress progress) {
        return new UserProgressDto(
                progress.getId(),
                progress.getUser().getId(),
                progress.getLesson().getId(),
                progress.getLesson().getTitle(),
                progress.getStatus(),
                progress.getProgressPercentage(),
                progress.getTimeSpentMinutes(),
                progress.getStartedAt(),
                progress.getCompletedAt(),
                progress.getLastAccessedAt());
    }
}
