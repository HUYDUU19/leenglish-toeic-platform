package com.leenglish.toeic.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import com.leenglish.toeic.domain.FlashcardSet;
import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.dto.FlashcardSetCreateRequest;
import com.leenglish.toeic.dto.FlashcardSetDto;
import com.leenglish.toeic.repository.FlashcardSetRepository;
import com.leenglish.toeic.service.FlashcardService;
import com.leenglish.toeic.service.FlashcardSetService;

@Service
public class FlashcardSetServiceImpl implements FlashcardSetService {

    @Autowired
    private FlashcardSetRepository flashcardSetRepository;

    @Autowired
    private FlashcardService flashcardService;

    private FlashcardSetDto mapToDto(FlashcardSet set) {
        FlashcardSetDto dto = new FlashcardSetDto();
        dto.setId(set.getId());
        dto.setName(set.getName());
        dto.setTitle(set.getTitle()); // Đảm bảo FlashcardSetDto có setTitle
        dto.setDescription(set.getDescription());
        dto.setIsPublic(set.getIsPublic());
        dto.setIsPremium(set.getIsPremium()); // Đảm bảo FlashcardSetDto có setIsPremium
        dto.setIsActive(set.getIsActive());
        dto.setEstimatedTimeMinutes(set.getEstimatedTimeMinutes()); // Đảm bảo FlashcardSetDto có
                                                                    // setEstimatedTimeMinutes
        dto.setCreatedAt(set.getCreatedAt());
        dto.setUpdatedAt(set.getUpdatedAt());
        return dto;
    }

    @Override
    public FlashcardSetDto getFlashcardSetWithFlashcardsById(Long id, Authentication authentication) {
        Optional<FlashcardSet> setOpt = flashcardSetRepository.findById(id);
        if (setOpt.isPresent()) {
            FlashcardSet set = setOpt.get();
            FlashcardSetDto dto = mapToDto(set);
            dto.setFlashcards(flashcardService.getFlashcardsBySet(id));
            return dto;
        }
        return null;
    }

    @Override
    public FlashcardSetDto getFreeFlashcardSetById(Long id) {
        Optional<FlashcardSet> setOpt = flashcardSetRepository
                .findByIdAndIsPublicTrueAndIsPremiumFalseAndIsActiveTrue(id);
        if (setOpt.isPresent()) {
            FlashcardSet set = setOpt.get();
            FlashcardSetDto dto = mapToDto(set);
            dto.setFlashcards(flashcardService.getFlashcardsBySet(id));
            return dto;
        }
        return null;
    }

    @Override
    public FlashcardSet getSetById(Long id) {
        return null;
    }

    @Override
    public List<FlashcardSetDto> getFlashcardSetsByUser(Long userId) {
        return null;
    }

    @Override
    public void deleteSet(Long id) {
        // TODO: implement
    }

    @Override
    public Page<FlashcardSet> getPublicSets(String difficulty, String category, String search, Pageable pageable) {
        return Page.empty();
    }

    @Override
    public List<FlashcardSetDto> getPublicFlashcardSets() {
        return null;
    }

    @Override
    public boolean canUserAccessSet(User user, FlashcardSet set) {
        return false;
    }

    @Override
    public List<FlashcardSetDto> searchFlashcardSets(String query, Long userId) {
        return null;
    }

    @Override
    public List<FlashcardSetDto> getAccessibleFlashcardSets(Long userId) {
        return null;
    }

    @Override
    public boolean canUserModifySet(User user, FlashcardSet set) {
        return false;
    }

    @Override
    public FlashcardSet createSet(FlashcardSetCreateRequest request, User user) {
        // TODO: Thêm logic tạo mới FlashcardSet từ request và user nếu cần
        return null;
    }

    @Override
    public FlashcardSetDto updateFlashcardSet(Long id, FlashcardSetDto setDto) {
        // TODO: implement logic cập nhật FlashcardSet
        return null;
    }

    @Override
    public List<FlashcardSetDto> getFreeFlashcardSetsForBasicUsers() {
        // TODO: implement logic lấy các bộ flashcard free cho user cơ bản
        return null;
    }

    @Override
    public FlashcardSetDto createFlashcardSet(FlashcardSetDto setDto, Long userId) {
        // TODO: implement logic tạo mới FlashcardSet từ DTO và userId
        return null;
    }

    @Override
    public void deleteFlashcardSet(Long id) {
        // TODO: implement logic xóa FlashcardSet
    }

    @Override
    public void incrementViewCount(Long id) {
        // TODO: implement logic tăng view count
    }

    @Override
    public List<com.leenglish.toeic.domain.Flashcard> getFlashcardsBySetId(Long id) {
        try {
            // Use the method with EntityGraph to fetch flashcards eagerly
            Optional<FlashcardSet> setOpt = flashcardSetRepository.findWithFlashcardsById(id);
            if (!setOpt.isPresent()) {
                System.err.println("❌ Flashcard set not found with id: " + id);
                return new java.util.ArrayList<>();
            }

            FlashcardSet set = setOpt.get();
            System.out.println("📚 Found flashcard set: " + set.getName());

            // Get flashcards from the set
            List<com.leenglish.toeic.domain.Flashcard> flashcards = new java.util.ArrayList<>();
            if (set.getFlashcards() != null) {
                flashcards = new java.util.ArrayList<>(set.getFlashcards());
                // Sort by order index if available
                flashcards.sort((f1, f2) -> {
                    Integer order1 = f1.getOrderIndex() != null ? f1.getOrderIndex() : 0;
                    Integer order2 = f2.getOrderIndex() != null ? f2.getOrderIndex() : 0;
                    return order1.compareTo(order2);
                });
            }

            System.out.println("📚 Found " + flashcards.size() + " flashcards for set " + id);
            return flashcards;
        } catch (Exception e) {
            System.err.println("❌ Error getting flashcards for set " + id + ": " + e.getMessage());
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    @Override
    public FlashcardSet updateSet(Long id, com.leenglish.toeic.dto.FlashcardSetUpdateRequest request, User user) {
        // TODO: implement logic cập nhật FlashcardSet từ request và user
        return null;
    }

    @Override
    public List<FlashcardSetDto> getAllFlashcardSets() {
        try {
            List<FlashcardSet> flashcardSets = flashcardSetRepository.findAll();
            System.out.println("📚 Found " + flashcardSets.size() + " flashcard sets in database");

            return flashcardSets.stream()
                    .map(this::mapToDto)
                    .collect(java.util.stream.Collectors.toList());
        } catch (Exception e) {
            System.err.println("❌ Database error in getAllFlashcardSets: " + e.getMessage());
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
}