package com.leenglish.toeic.service;

import com.leenglish.toeic.domain.FlashcardSet;
import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.dto.FlashcardSetDto;
import com.leenglish.toeic.repository.FlashcardSetRepository;
import com.leenglish.toeic.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class FlashcardSetService {

    @Autowired
    private FlashcardSetRepository flashcardSetRepository;

    @Autowired
    private UserRepository userRepository;

    public List<FlashcardSetDto> getFlashcardSetsByUser(Long userId) {
        List<FlashcardSet> flashcardSets = flashcardSetRepository.findByCreatedByIdAndIsActiveTrue(userId);
        return flashcardSets.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public List<FlashcardSetDto> getPublicFlashcardSets() {
        List<FlashcardSet> flashcardSets = flashcardSetRepository.findByIsPublicTrueAndIsActiveTrue();
        return flashcardSets.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public List<FlashcardSetDto> getAccessibleFlashcardSets(Long userId) {
        List<FlashcardSet> flashcardSets = flashcardSetRepository.findAccessibleFlashcardSets(userId);
        return flashcardSets.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public FlashcardSetDto createFlashcardSet(FlashcardSetDto flashcardSetDto, Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (!userOpt.isPresent()) {
            throw new RuntimeException("User not found with id: " + userId);
        }

        FlashcardSet flashcardSet = new FlashcardSet();
        flashcardSet.setName(flashcardSetDto.getName());
        flashcardSet.setDescription(flashcardSetDto.getDescription());
        flashcardSet.setCategory(flashcardSetDto.getCategory());
        flashcardSet.setLevel(flashcardSetDto.getLevel());
        flashcardSet.setIsPublic(flashcardSetDto.getIsPublic());
        flashcardSet.setIsActive(true);
        flashcardSet.setCardCount(0);
        flashcardSet.setCreatedAt(LocalDateTime.now());
        flashcardSet.setUpdatedAt(LocalDateTime.now());
        flashcardSet.setCreatedBy(userOpt.get());

        FlashcardSet savedFlashcardSet = flashcardSetRepository.save(flashcardSet);
        return convertToDto(savedFlashcardSet);
    }

    public FlashcardSetDto updateFlashcardSet(Long id, FlashcardSetDto flashcardSetDto) {
        Optional<FlashcardSet> flashcardSetOpt = flashcardSetRepository.findById(id);
        if (!flashcardSetOpt.isPresent()) {
            throw new RuntimeException("FlashcardSet not found with id: " + id);
        }

        FlashcardSet flashcardSet = flashcardSetOpt.get();
        flashcardSet.setName(flashcardSetDto.getName());
        flashcardSet.setDescription(flashcardSetDto.getDescription());
        flashcardSet.setCategory(flashcardSetDto.getCategory());
        flashcardSet.setLevel(flashcardSetDto.getLevel());
        flashcardSet.setIsPublic(flashcardSetDto.getIsPublic());
        flashcardSet.setUpdatedAt(LocalDateTime.now());

        FlashcardSet updatedFlashcardSet = flashcardSetRepository.save(flashcardSet);
        return convertToDto(updatedFlashcardSet);
    }

    public void deleteFlashcardSet(Long id) {
        Optional<FlashcardSet> flashcardSetOpt = flashcardSetRepository.findById(id);
        if (!flashcardSetOpt.isPresent()) {
            throw new RuntimeException("FlashcardSet not found with id: " + id);
        }

        FlashcardSet flashcardSet = flashcardSetOpt.get();
        flashcardSet.setIsActive(false);
        flashcardSet.setUpdatedAt(LocalDateTime.now());
        flashcardSetRepository.save(flashcardSet);
    }

    public List<FlashcardSetDto> searchFlashcardSets(String searchTerm, Long userId) {
        List<FlashcardSet> flashcardSets = flashcardSetRepository.searchFlashcardSets(searchTerm, userId);
        return flashcardSets.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    private FlashcardSetDto convertToDto(FlashcardSet flashcardSet) {
        return new FlashcardSetDto(
                flashcardSet.getId(),
                flashcardSet.getName(),
                flashcardSet.getDescription(),
                flashcardSet.getCategory(),
                flashcardSet.getLevel(),
                flashcardSet.getIsPublic(),
                flashcardSet.getIsActive(),
                flashcardSet.getCardCount(),
                flashcardSet.getCreatedAt(),
                flashcardSet.getUpdatedAt(),
                flashcardSet.getCreatedBy() != null ? flashcardSet.getCreatedBy().getId() : null);
    }
}
