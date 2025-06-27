package com.leenglish.toeic.controller;

import com.leenglish.toeic.dto.FlashcardDto;
import com.leenglish.toeic.dto.FlashcardSetDto;
import com.leenglish.toeic.service.FlashcardService;
import com.leenglish.toeic.service.FlashcardSetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/flashcards")
@CrossOrigin(origins = "*")
public class FlashcardController {

    @Autowired
    private FlashcardService flashcardService;

    @Autowired
    private FlashcardSetService flashcardSetService;

    // Flashcard Set endpoints
    @GetMapping("/sets")
    public ResponseEntity<List<FlashcardSetDto>> getPublicFlashcardSets() {
        List<FlashcardSetDto> sets = flashcardSetService.getPublicFlashcardSets();
        return ResponseEntity.ok(sets);
    }

    // Free flashcard sets for non-premium users (limited access)
    @GetMapping("/free")
    public ResponseEntity<List<FlashcardSetDto>> getFreeFlashcardSets() {
        List<FlashcardSetDto> sets = flashcardSetService.getFreeFlashcardSetsForBasicUsers();
        return ResponseEntity.ok(sets);
    }

    @GetMapping("/sets/my")
    @PreAuthorize("hasRole('USER') or hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<List<FlashcardSetDto>> getMyFlashcardSets(Authentication authentication) {
        // Extract user ID from authentication
        Long userId = 1L; // This should be extracted from the authenticated user
        List<FlashcardSetDto> sets = flashcardSetService.getFlashcardSetsByUser(userId);
        return ResponseEntity.ok(sets);
    }

    @GetMapping("/sets/accessible")
    @PreAuthorize("hasRole('USER') or hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<List<FlashcardSetDto>> getAccessibleFlashcardSets(Authentication authentication) {
        // Extract user ID from authentication
        Long userId = 1L; // This should be extracted from the authenticated user
        List<FlashcardSetDto> sets = flashcardSetService.getAccessibleFlashcardSets(userId);
        return ResponseEntity.ok(sets);
    }

    @PostMapping("/sets")
    @PreAuthorize("hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<FlashcardSetDto> createFlashcardSet(@RequestBody FlashcardSetDto setDto,
            Authentication authentication) {
        // Extract user ID from authentication
        Long userId = 1L; // This should be extracted from the authenticated user
        FlashcardSetDto createdSet = flashcardSetService.createFlashcardSet(setDto, userId);
        return ResponseEntity.ok(createdSet);
    }

    @PutMapping("/sets/{id}")
    @PreAuthorize("hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<FlashcardSetDto> updateFlashcardSet(@PathVariable Long id,
            @RequestBody FlashcardSetDto setDto) {
        FlashcardSetDto updatedSet = flashcardSetService.updateFlashcardSet(id, setDto);
        return ResponseEntity.ok(updatedSet);
    }

    @DeleteMapping("/sets/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteFlashcardSet(@PathVariable Long id) {
        flashcardSetService.deleteFlashcardSet(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/sets/search")
    public ResponseEntity<List<FlashcardSetDto>> searchFlashcardSets(@RequestParam String query,
            Authentication authentication) {
        // Extract user ID from authentication
        Long userId = 1L; // This should be extracted from the authenticated user
        List<FlashcardSetDto> sets = flashcardSetService.searchFlashcardSets(query, userId);
        return ResponseEntity.ok(sets);
    }

    // Individual Flashcard endpoints
    @GetMapping("/set/{setId}")
    public ResponseEntity<List<FlashcardDto>> getFlashcardsBySet(@PathVariable Long setId) {
        List<FlashcardDto> flashcards = flashcardService.getFlashcardsBySet(setId);
        return ResponseEntity.ok(flashcards);
    }

    @GetMapping("/level/{level}")
    public ResponseEntity<List<FlashcardDto>> getFlashcardsByLevel(@PathVariable String level) {
        List<FlashcardDto> flashcards = flashcardService.getFlashcardsByLevel(level);
        return ResponseEntity.ok(flashcards);
    }

    @GetMapping("/category/{category}")
    public ResponseEntity<List<FlashcardDto>> getFlashcardsByCategory(@PathVariable String category) {
        List<FlashcardDto> flashcards = flashcardService.getFlashcardsByCategory(category);
        return ResponseEntity.ok(flashcards);
    }

    @PostMapping
    @PreAuthorize("hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<FlashcardDto> createFlashcard(@RequestBody FlashcardDto flashcardDto) {
        FlashcardDto createdFlashcard = flashcardService.createFlashcard(flashcardDto);
        return ResponseEntity.ok(createdFlashcard);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('COLLABORATOR') or hasRole('ADMIN')")
    public ResponseEntity<FlashcardDto> updateFlashcard(@PathVariable Long id, @RequestBody FlashcardDto flashcardDto) {
        FlashcardDto updatedFlashcard = flashcardService.updateFlashcard(id, flashcardDto);
        return ResponseEntity.ok(updatedFlashcard);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteFlashcard(@PathVariable Long id) {
        flashcardService.deleteFlashcard(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<FlashcardDto>> searchFlashcards(@RequestParam String query) {
        List<FlashcardDto> flashcards = flashcardService.searchFlashcards(query);
        return ResponseEntity.ok(flashcards);
    }
private Long extractUserIdFromAuth(Authentication authentication) {
        if (authentication == null || authentication.getName() == null) {
            return 1L; // Default fallback
        }
        
        try {
            // Try to parse username as ID first
            return Long.parseLong(authentication.getName());
        } catch (NumberFormatException e) {
            // If username is not a number, you might need to lookup user by username
            // For now, return default
            return 1L;
        }
    }
}
