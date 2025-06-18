package com.leenglish.toeic.service;

import com.leenglish.toeic.domain.Lesson;
import com.leenglish.toeic.dto.LessonDto;
import com.leenglish.toeic.repository.LessonRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class LessonService {

    private final LessonRepository lessonRepository;

    @Autowired
    public LessonService(LessonRepository lessonRepository) {
        this.lessonRepository = lessonRepository;
    }

    // Basic CRUD operations
    public List<Lesson> getAllLessons() {
        return lessonRepository.findAll();
    }

    public Optional<Lesson> getLessonById(Long id) {
        return lessonRepository.findById(id);
    }

    public Lesson saveLesson(Lesson lesson) {
        if (lesson.getId() == null) {
            lesson.setCreatedAt(LocalDateTime.now());
        }
        lesson.setUpdatedAt(LocalDateTime.now());
        return lessonRepository.save(lesson);
    }

    public Lesson createLesson(Lesson lesson) {
        lesson.setId(null); // Ensure it's a new lesson
        lesson.setCreatedAt(LocalDateTime.now());
        lesson.setUpdatedAt(LocalDateTime.now());

        // Set defaults if not provided
        if (lesson.getIsActive() == null) {
            lesson.setIsActive(true);
        }
        if (lesson.getIsPremium() == null) {
            lesson.setIsPremium(false);
        }
        if (lesson.getOrderIndex() == null) {
            lesson.setOrderIndex(0);
        }

        return lessonRepository.save(lesson);
    }

    public Lesson updateLesson(Long id, Lesson lessonUpdate) {
        Lesson lesson = lessonRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Lesson not found"));

        // Update fields
        lesson.setTitle(lessonUpdate.getTitle());
        lesson.setDescription(lessonUpdate.getDescription());
        lesson.setContent(lessonUpdate.getContent());
        lesson.setLevel(lessonUpdate.getLevel());
        lesson.setImageUrl(lessonUpdate.getImageUrl());
        lesson.setAudioUrl(lessonUpdate.getAudioUrl());
        lesson.setIsPremium(lessonUpdate.getIsPremium());
        lesson.setIsActive(lessonUpdate.getIsActive());
        lesson.setOrderIndex(lessonUpdate.getOrderIndex());
        lesson.setUpdatedAt(LocalDateTime.now());

        return lessonRepository.save(lesson);
    }

    public boolean deleteLesson(Long id) {
        if (lessonRepository.existsById(id)) {
            lessonRepository.deleteById(id);
            return true;
        }
        return false;
    }

    // Query methods
    public List<Lesson> getLessonsByLevel(String level) {
        return lessonRepository.findByLevelAndIsActiveTrue(level);
    }

    public List<Lesson> getActiveLessons() {
        return lessonRepository.findByIsActiveTrueOrderByOrderIndexAsc();
    }

    public List<Lesson> getPremiumLessons() {
        return lessonRepository.findByIsPremiumAndIsActiveTrue(true);
    }

    public List<Lesson> getFreeLessons() {
        return lessonRepository.findByIsPremiumAndIsActiveTrue(false);
    }

    public List<Lesson> searchLessons(String keyword) {
        return lessonRepository.searchByKeyword(keyword);
    }

    public List<Lesson> getLessonsWithAudio() {
        return lessonRepository.findLessonsWithAudio();
    }

    public List<Lesson> getLessonsWithImages() {
        return lessonRepository.findLessonsWithImages();
    }

    public List<Lesson> getRandomLessons(String level, int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return lessonRepository.findRandomLessons(level, pageable);
    }

    public List<Lesson> getLessonsOrderByCreatedDate() {
        return lessonRepository.findActiveOrderByCreatedAtDesc();
    }

    public List<Lesson> getLessonsOrderByUpdatedDate() {
        return lessonRepository.findActiveOrderByUpdatedAtDesc();
    }

    // Advanced search
    public List<Lesson> findByCriteria(String level, Boolean isActive, Boolean isPremium) {
        return lessonRepository.findByCriteria(level, isActive, isPremium);
    }

    // Statistics
    public Long countByLevel(String level) {
        return lessonRepository.countByLevel(level);
    }

    // Status management
    public Lesson activateLesson(Long id) {
        Lesson lesson = lessonRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Lesson not found"));

        lesson.setIsActive(true);
        lesson.setUpdatedAt(LocalDateTime.now());

        return lessonRepository.save(lesson);
    }

    public Lesson deactivateLesson(Long id) {
        Lesson lesson = lessonRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Lesson not found"));

        lesson.setIsActive(false);
        lesson.setUpdatedAt(LocalDateTime.now());

        return lessonRepository.save(lesson);
    }

    public Lesson setPremium(Long id, boolean isPremium) {
        Lesson lesson = lessonRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Lesson not found"));

        lesson.setIsPremium(isPremium);
        lesson.setUpdatedAt(LocalDateTime.now());

        return lessonRepository.save(lesson);
    }

    // Validation
    public boolean validateLesson(Lesson lesson) {
        return lesson.isValid();
    }

    // DTO methods for controllers
    public List<LessonDto> getAllActiveLessons() {
        List<Lesson> lessons = lessonRepository.findByIsActiveTrueOrderByCreatedAtDesc();
        return lessons.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public LessonDto getLessonDtoById(Long id) {
        Optional<Lesson> lesson = lessonRepository.findById(id);
        return lesson.map(this::convertToDto).orElse(null);
    }

    public List<LessonDto> getLessonsByType(String type) {
        List<Lesson> lessons = lessonRepository.findByTypeAndIsActiveTrue(type);
        return lessons.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public List<LessonDto> getLessonsByDifficulty(String difficulty) {
        List<Lesson> lessons = lessonRepository.findByDifficultyAndIsActiveTrue(difficulty);
        return lessons.stream()
                .map(this::convertToDto).collect(Collectors.toList());
    }

    public LessonDto createLesson(LessonDto lessonDto) {
        Lesson lesson = convertToEntity(lessonDto);
        Lesson savedLesson = createLesson(lesson);
        return convertToDto(savedLesson);
    }

    public LessonDto updateLesson(Long id, LessonDto lessonDto) {
        Lesson lesson = convertToEntity(lessonDto);
        lesson.setId(id);
        Lesson updatedLesson = updateLesson(lesson);
        return convertToDto(updatedLesson);
    }

    private LessonDto convertToDto(Lesson lesson) {
        LessonDto dto = new LessonDto();
        dto.setId(lesson.getId());
        dto.setTitle(lesson.getTitle());
        dto.setDescription(lesson.getDescription());
        dto.setContent(lesson.getContent());
        dto.setType(lesson.getType());
        dto.setDifficulty(lesson.getDifficulty());
        dto.setLevel(lesson.getLevel());
        dto.setAudioUrl(lesson.getAudioUrl());
        dto.setImageUrl(lesson.getImageUrl());
        dto.setDuration(lesson.getDuration());
        dto.setIsActive(lesson.getIsActive());
        dto.setCreatedAt(lesson.getCreatedAt());
        dto.setUpdatedAt(lesson.getUpdatedAt());
        return dto;
    }

    private Lesson convertToEntity(LessonDto dto) {
        Lesson lesson = new Lesson();
        lesson.setId(dto.getId());
        lesson.setTitle(dto.getTitle());
        lesson.setDescription(dto.getDescription());
        lesson.setContent(dto.getContent());
        lesson.setType(dto.getType());
        lesson.setDifficulty(dto.getDifficulty());
        lesson.setLevel(dto.getLevel());
        lesson.setAudioUrl(dto.getAudioUrl());
        lesson.setImageUrl(dto.getImageUrl());
        lesson.setDuration(dto.getDuration());
        lesson.setIsActive(dto.getIsActive());
        return lesson;
    }
}
