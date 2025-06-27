package com.leenglish.toeic.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.leenglish.toeic.domain.Flashcard;
import com.leenglish.toeic.domain.FlashcardSet;
import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.dto.FlashcardSetCreateRequest;
import com.leenglish.toeic.dto.FlashcardSetDto;
import com.leenglish.toeic.dto.FlashcardSetUpdateRequest;
import com.leenglish.toeic.repository.FlashcardRepository;
import com.leenglish.toeic.repository.FlashcardSetRepository;
import com.leenglish.toeic.repository.UserRepository;

@Service
@Transactional
public class FlashcardSetService {

    @Autowired
    private FlashcardSetRepository flashcardSetRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FlashcardRepository flashcardRepository;

    public List<FlashcardSetDto> getFlashcardSetsByUser(Long userId) {
        try {
            List<FlashcardSet> flashcardSets = flashcardSetRepository.findAll().stream()
                    .filter(set -> set.getCreatedBy() != null &&
                            userId.equals(set.getCreatedBy().getId()) &&
                            Boolean.TRUE.equals(set.getIsActive()))
                    .collect(Collectors.toList());
            return flashcardSets.stream()
                    .map(this::convertToDto)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            System.err.println("Error getting flashcard sets by user: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public List<FlashcardSetDto> getPublicFlashcardSets() {
        try {
            System.out.println("FlashcardSetService: Getting public flashcard sets");

            // Try to get from database first
            List<FlashcardSet> flashcardSets = flashcardSetRepository.findAll().stream()
                    .filter(set -> Boolean.TRUE.equals(set.getIsPublic()) && Boolean.TRUE.equals(set.getIsActive()))
                    .collect(Collectors.toList());

            List<FlashcardSetDto> result = flashcardSets.stream()
                    .map(this::convertToDto)
                    .collect(Collectors.toList());

            // If database is empty, return sample data for testing
            if (result.isEmpty()) {
                System.out.println("Database is empty, returning sample data");
                result = getSamplePublicFlashcardSets();
            }

            System.out.println("Returning " + result.size() + " public flashcard sets");
            return result;

        } catch (Exception e) {
            System.err.println("Error getting public flashcard sets: " + e.getMessage());
            // Return sample data as fallback
            return getSamplePublicFlashcardSets();
        }
    }

    /**
     * Get free flashcard sets for basic users (non-premium)
     * Returns only basic difficulty flashcard sets that are not premium, limited to
     * 3 sets
     */
    public List<FlashcardSetDto> getFreeFlashcardSetsForBasicUsers() {
        try {
            System.out.println("FlashcardSetService: Getting free flashcard sets for basic users");

            // Try to get from database first
            List<FlashcardSet> flashcardSets = flashcardSetRepository.findAll().stream()
                    .filter(set -> Boolean.TRUE.equals(set.getIsActive()))
                    .filter(set -> Boolean.TRUE.equals(set.getIsPublic()))
                    .filter(set -> !Boolean.TRUE.equals(set.getIsPremium())) // Not premium
                    .filter(set -> "BEGINNER".equals(set.getDifficultyLevel())) // Only beginner level
                    .sorted((a, b) -> {
                        if (a.getId() == null && b.getId() == null)
                            return 0;
                        if (a.getId() == null)
                            return 1;
                        if (b.getId() == null)
                            return -1;
                        return a.getId().compareTo(b.getId());
                    })
                    .limit(3) // Only first 3 sets
                    .collect(Collectors.toList());

            List<FlashcardSetDto> result = flashcardSets.stream()
                    .map(this::convertToDto)
                    .collect(Collectors.toList());

            // If database is empty, return sample data
            if (result.isEmpty()) {
                System.out.println("Database is empty, returning sample free data");
                result = getSampleFreeFlashcardSets();
            }

            System.out.println("Returning " + result.size() + " free flashcard sets");
            return result;

        } catch (Exception e) {
            System.err.println("Error getting free flashcard sets: " + e.getMessage());
            // Return sample data as fallback
            return getSampleFreeFlashcardSets();
        }
    }

    public List<FlashcardSetDto> getAccessibleFlashcardSets(Long userId) {
        try {
            List<FlashcardSet> flashcardSets = flashcardSetRepository.findAll().stream()
                    .filter(set -> Boolean.TRUE.equals(set.getIsActive()) &&
                            (Boolean.TRUE.equals(set.getIsPublic()) ||
                                    (set.getCreatedBy() != null && userId.equals(set.getCreatedBy().getId()))))
                    .collect(Collectors.toList());

            List<FlashcardSetDto> result = flashcardSets.stream()
                    .map(this::convertToDto)
                    .collect(Collectors.toList());

            // If empty, return public sets as fallback
            if (result.isEmpty()) {
                return getPublicFlashcardSets();
            }

            return result;
        } catch (Exception e) {
            System.err.println("Error getting accessible flashcard sets: " + e.getMessage());
            return getPublicFlashcardSets();
        }
    }

    public FlashcardSetDto createFlashcardSet(FlashcardSetDto flashcardSetDto, Long userId) {
        try {
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
        } catch (Exception e) {
            System.err.println("Error creating flashcard set: " + e.getMessage());
            throw new RuntimeException("Failed to create flashcard set", e);
        }
    }

    public FlashcardSetDto updateFlashcardSet(Long id, FlashcardSetDto flashcardSetDto) {
        try {
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
        } catch (Exception e) {
            System.err.println("Error updating flashcard set: " + e.getMessage());
            throw new RuntimeException("Failed to update flashcard set", e);
        }
    }

    public void deleteFlashcardSet(Long id) {
        try {
            Optional<FlashcardSet> flashcardSetOpt = flashcardSetRepository.findById(id);
            if (!flashcardSetOpt.isPresent()) {
                throw new RuntimeException("FlashcardSet not found with id: " + id);
            }

            FlashcardSet flashcardSet = flashcardSetOpt.get();
            flashcardSet.setIsActive(false);
            flashcardSet.setUpdatedAt(LocalDateTime.now());
            flashcardSetRepository.save(flashcardSet);
        } catch (Exception e) {
            System.err.println("Error deleting flashcard set: " + e.getMessage());
            throw new RuntimeException("Failed to delete flashcard set", e);
        }
    }

    public List<FlashcardSetDto> searchFlashcardSets(String searchTerm, Long userId) {
        try {
            if (searchTerm == null || searchTerm.trim().isEmpty()) {
                return getPublicFlashcardSets();
            }

            List<FlashcardSet> flashcardSets = flashcardSetRepository.findAll().stream()
                    .filter(set -> Boolean.TRUE.equals(set.getIsActive()) &&
                            (Boolean.TRUE.equals(set.getIsPublic()) ||
                                    (set.getCreatedBy() != null && userId != null
                                            && userId.equals(set.getCreatedBy().getId())))
                            &&
                            (set.getName() != null && set.getName().toLowerCase().contains(searchTerm.toLowerCase()) ||
                                    set.getDescription() != null
                                            && set.getDescription().toLowerCase().contains(searchTerm.toLowerCase())))
                    .collect(Collectors.toList());

            List<FlashcardSetDto> result = flashcardSets.stream()
                    .map(this::convertToDto)
                    .collect(Collectors.toList());

            // If no results and database might be empty, return sample data that matches
            // search
            if (result.isEmpty()) {
                return getSamplePublicFlashcardSets().stream()
                        .filter(dto -> dto.getName().toLowerCase().contains(searchTerm.toLowerCase()) ||
                                dto.getDescription().toLowerCase().contains(searchTerm.toLowerCase()))
                        .collect(Collectors.toList());
            }

            return result;
        } catch (Exception e) {
            System.err.println("Error searching flashcard sets: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public Page<FlashcardSet> getPublicSets(String difficulty, String category, String search, Pageable pageable) {
        // TODO: Implement logic to filter and return public sets
        return flashcardSetRepository.findPublicSets(difficulty, category, search, pageable);
    }

    public FlashcardSet getSetById(Long id) {
        return flashcardSetRepository.findById(id).orElse(null);
    }

    public boolean canUserAccessSet(User user, FlashcardSet set) {
        // TODO: Implement logic for access (owner, public, premium, etc.)
        if (set.getIsPublic() && !set.getIsPremium())
            return true;
        if (user == null)
            return false;
        if (set.getCreatedBy().getId().equals(user.getId()))
            return true;
        if (user.getRole().name().equals("ADMIN"))
            return true;
        if (set.getIsPremium() && user.getMembershipType().name().equals("PREMIUM"))
            return true;
        return false;
    }

    public boolean canUserModifySet(User user, FlashcardSet set) {
        // Only owner, collaborator, or admin can modify
        if (user == null)
            return false;
        if (set.getCreatedBy().getId().equals(user.getId()))
            return true;
        if (user.getRole().name().equals("COLLABORATOR") || user.getRole().name().equals("ADMIN"))
            return true;
        return false;
    }

    public void incrementViewCount(Long id) {
        flashcardSetRepository.incrementViewCount(id);
    }

    public List<Flashcard> getFlashcardsBySetId(Long setId) {
        return flashcardRepository.findByFlashcardSetId(setId);
    }

    public FlashcardSet createSet(FlashcardSetCreateRequest request, User user) {
        // Map request to entity, set createdBy, save and return
        FlashcardSet set = new FlashcardSet();
        set.setName(request.getName());
        set.setDescription(request.getDescription());
        set.setCategory(request.getCategory());
        set.setTags(request.getTags());
        set.setDifficultyLevel(request.getDifficultyLevel()); // Sử dụng String, không cần enum nếu entity là String
        set.setEstimatedTimeMinutes(request.getEstimatedTimeMinutes());
        set.setIsPremium(request.getIsPremium());
        set.setIsPublic(request.getIsPublic());
        set.setCreatedBy(user);
        set.setIsActive(true);
        return flashcardSetRepository.save(set);
    }

    public FlashcardSet updateSet(Long id, FlashcardSetUpdateRequest request, User user) {
        FlashcardSet set = flashcardSetRepository.findById(id).orElseThrow();
        set.setName(request.getName());
        set.setDescription(request.getDescription());
        set.setCategory(request.getCategory());
        set.setTags(request.getTags());
        set.setDifficultyLevel(request.getDifficultyLevel()); // Sử dụng String, không cần enum nếu entity là String
        set.setEstimatedTimeMinutes(request.getEstimatedTimeMinutes());
        set.setIsPremium(request.getIsPremium());
        set.setIsPublic(request.getIsPublic());
        set.setUpdatedAt(java.time.LocalDateTime.now());
        return flashcardSetRepository.save(set);
    }

    public void deleteSet(Long id) {
        flashcardSetRepository.deleteById(id);
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

    // ================================================================
    // SAMPLE DATA METHODS - FOR TESTING WHEN DATABASE IS EMPTY
    // ================================================================

    /**
     * Provides sample public flashcard sets for testing
     */
    private List<FlashcardSetDto> getSamplePublicFlashcardSets() {
        List<FlashcardSetDto> sampleSets = new ArrayList<>();

        // Sample Set 1
        FlashcardSetDto set1 = new FlashcardSetDto();
        set1.setId(1L);
        set1.setName("Basic English Vocabulary");
        set1.setDescription("Essential words for English learners");
        set1.setCategory("vocabulary");
        set1.setLevel("BEGINNER");
        set1.setIsPublic(true);
        set1.setIsActive(true);
        set1.setCardCount(50);
        set1.setCreatedAt(LocalDateTime.now().minusDays(7));
        set1.setUpdatedAt(LocalDateTime.now().minusDays(7));
        sampleSets.add(set1);

        // Sample Set 2
        FlashcardSetDto set2 = new FlashcardSetDto();
        set2.setId(2L);
        set2.setName("Common English Phrases");
        set2.setDescription("Everyday English expressions and idioms");
        set2.setCategory("phrases");
        set2.setLevel("INTERMEDIATE");
        set2.setIsPublic(true);
        set2.setIsActive(true);
        set2.setCardCount(30);
        set2.setCreatedAt(LocalDateTime.now().minusDays(5));
        set2.setUpdatedAt(LocalDateTime.now().minusDays(5));
        sampleSets.add(set2);

        // Sample Set 3
        FlashcardSetDto set3 = new FlashcardSetDto();
        set3.setId(3L);
        set3.setName("Business English");
        set3.setDescription("Professional vocabulary for workplace communication");
        set3.setCategory("business");
        set3.setLevel("ADVANCED");
        set3.setIsPublic(true);
        set3.setIsActive(true);
        set3.setCardCount(40);
        set3.setCreatedAt(LocalDateTime.now().minusDays(3));
        set3.setUpdatedAt(LocalDateTime.now().minusDays(3));
        sampleSets.add(set3);

        return sampleSets;
    }

    /**
     * Provides sample free flashcard sets for basic users
     */
    private List<FlashcardSetDto> getSampleFreeFlashcardSets() {
        List<FlashcardSetDto> freeSets = new ArrayList<>();

        // Free Set 1
        FlashcardSetDto freeSet1 = new FlashcardSetDto();
        freeSet1.setId(1L);
        freeSet1.setName("Free Starter Pack");
        freeSet1.setDescription("Basic vocabulary for beginners - Free access");
        freeSet1.setCategory("vocabulary");
        freeSet1.setLevel("BEGINNER");
        freeSet1.setIsPublic(true);
        freeSet1.setIsActive(true);
        freeSet1.setCardCount(20);
        freeSet1.setCreatedAt(LocalDateTime.now().minusDays(10));
        freeSet1.setUpdatedAt(LocalDateTime.now().minusDays(10));
        freeSets.add(freeSet1);

        // Free Set 2
        FlashcardSetDto freeSet2 = new FlashcardSetDto();
        freeSet2.setId(4L);
        freeSet2.setName("Essential Greetings");
        freeSet2.setDescription("Basic greetings and introductions - Free access");
        freeSet2.setCategory("conversation");
        freeSet2.setLevel("BEGINNER");
        freeSet2.setIsPublic(true);
        freeSet2.setIsActive(true);
        freeSet2.setCardCount(15);
        freeSet2.setCreatedAt(LocalDateTime.now().minusDays(8));
        freeSet2.setUpdatedAt(LocalDateTime.now().minusDays(8));
        freeSets.add(freeSet2);

        return freeSets;
    }
}
