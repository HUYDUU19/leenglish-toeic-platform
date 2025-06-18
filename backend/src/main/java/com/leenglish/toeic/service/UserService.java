package com.leenglish.toeic.service;

import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.dto.UserDto;
import com.leenglish.toeic.enums.Role;
import com.leenglish.toeic.enums.Gender;
import com.leenglish.toeic.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

@Service
@Transactional
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    // Basic CRUD operations
    public List<User> findAll() {
        return userRepository.findAll();
    }

    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    
    public List<UserDto> getAllUsers() {
        return userRepository.findAll().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public Optional<UserDto> getUserById(Long id) {
        return userRepository.findById(id)
                .map(this::convertToDto);
    }
    
    public User updateUser(Long id, UserDto userDto) {
        return userRepository.findById(id)
                .map(user -> {
                    user.setUsername(userDto.getUsername());
                    user.setEmail(userDto.getEmail());
                    // Note: Password updates should be handled separately
                    return userRepository.save(user);
                })
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
    
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    private UserDto convertToDto(User user) {
        UserDto dto = new UserDto();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        return dto;
    }

    // Enum-based service methods
    public List<User> findByRole(Role role) {
        return userRepository.findByRole(role);
    }

    public List<User> findByGender(Gender gender) {
        return userRepository.findByGender(gender);
    }

    public List<User> findActiveUsersByRole(Role role) {
        return userRepository.findByRoleAndIsActive(role, true);
    }

    public List<User> findActiveUsersByGender(Gender gender) {
        return userRepository.findByGenderAndIsActive(gender, true);
    }

    // Advanced filtering with enum support
    public Page<User> findUsersWithFilters(String username, String email, Role role, 
                                         Gender gender, String country, Boolean isActive, 
                                         Pageable pageable) {
        return userRepository.findUsersWithFilters(username, email, role, gender, country, isActive, pageable);
    }

    // Save user with password encoding
    public User save(User user) {
        // Encode password if it's a new user or password changed
        if (user.getId() == null || user.getPasswordHash() != null) {
            if (user.getPasswordHash() != null && !user.getPasswordHash().startsWith("$2a$")) {
                user.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));
            }
        }
        
        // Set default values if not provided
        if (user.getRole() == null) {
            user.setRole(Role.USER);  // Default enum value
        }
        if (user.getIsActive() == null) {
            user.setIsActive(true);
        }
        if (user.getTotalScore() == null) {
            user.setTotalScore(0);
        }

        return userRepository.save(user);
    }

    // User creation and registration
    public User createUser(String username, String email, String password, String fullName, 
                          Role role, Gender gender, String country) {
        
        // Validate required fields
        if (username == null || email == null || password == null) {
            throw new IllegalArgumentException("Username, email, and password are required");
        }

        // Check if user already exists
        if (userRepository.findByUsername(username).isPresent()) {
            throw new IllegalArgumentException("Username already exists");
        }
        if (userRepository.findByEmail(email).isPresent()) {
            throw new IllegalArgumentException("Email already exists");
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(password); // Will be encoded in save()
        user.setFullName(fullName);
        user.setRole(role != null ? role : Role.USER);  // Enum with default
        user.setGender(gender);                         // Enum (can be null)
        user.setCountry(country);
        user.setIsActive(true);
        user.setTotalScore(0);

        return save(user);
    }

    public User registerUser(String username, String email, String password, String fullName) {
        return createUser(username, email, password, fullName, Role.USER, null, null);
    }

    public User updateUser(Long id, User userUpdate) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        
        user.setUsername(userUpdate.getUsername());
        user.setEmail(userUpdate.getEmail());
        user.setFullName(userUpdate.getFullName());
        if (userUpdate.getRole() != null) {
            user.setRole(userUpdate.getRole());
        }
        user.setUpdatedAt(LocalDateTime.now());
        
        return userRepository.save(user);
    }

    // Authentication methods
    public boolean checkPassword(User user, String password) {
        return passwordEncoder.matches(password, user.getPasswordHash());
    }

    public User changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        
        if (!checkPassword(user, oldPassword)) {
            throw new IllegalArgumentException("Old password is incorrect");
        }
        
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        user.setUpdatedAt(LocalDateTime.now());
        
        return userRepository.save(user);
    }

    // Premium membership methods
    public User upgradeToPremium(Long userId, LocalDateTime expiresAt) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        
        user.setIsPremium(true);
        user.setPremiumExpiresAt(expiresAt);
        user.setUpdatedAt(LocalDateTime.now());
        
        return userRepository.save(user);
    }

    public User downgradePremium(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        
        user.setIsPremium(false);
        user.setPremiumExpiresAt(null);
        user.setUpdatedAt(LocalDateTime.now());
        
        return userRepository.save(user);
    }

    // User status methods
    public User activateUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        
        user.setIsActive(true);
        user.setUpdatedAt(LocalDateTime.now());
        
        return userRepository.save(user);
    }

    public User deactivateUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        
        user.setIsActive(false);
        user.setUpdatedAt(LocalDateTime.now());
        
        return userRepository.save(user);
    }

    public User updateLastLogin(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        
        user.setLastLogin(LocalDateTime.now());
          return userRepository.save(user);
    }

    // Validation methods
    public boolean isUsernameAvailable(String username) {
        return !userRepository.existsByUsername(username);
    }

    public boolean isEmailAvailable(String email) {
        return !userRepository.existsByEmail(email);
    }

    // Additional methods needed by controllers
    public Optional<UserDto> getUserByUsername(String username) {
        return userRepository.findByUsername(username)
                .map(this::convertToDto);
    }

    public Optional<UserDto> getUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .map(this::convertToDto);
    }

    public List<UserDto> getUsersByRole(Role role) {
        return userRepository.findByRole(role).stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }    public List<UserDto> getTopUsers() {
        // Fallback implementation if specific method doesn't exist
        return userRepository.findAll().stream()
                .sorted((u1, u2) -> Integer.compare(
                    u2.getTotalScore() != null ? u2.getTotalScore() : 0,
                    u1.getTotalScore() != null ? u1.getTotalScore() : 0))
                .limit(10)
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }    public User updateUserScore(Long userId, Integer score) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        // user.setTotalScore(score); // Commented out until User entity has this field
        return userRepository.save(user);
    }

    public Long getTotalUserCount() {
        return userRepository.count();
    }

    // Legacy methods that return User entities (for backward compatibility with existing controllers)
    public Optional<User> findUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public Optional<User> findUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    // Get user statistics by enum
    public Map<String, Object> getUserStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        // Count by role
        List<Object[]> roleStats = userRepository.countUsersByRole();
        Map<String, Long> roleCounts = new HashMap<>();
        for (Object[] stat : roleStats) {
            Role role = (Role) stat[0];  // Cast to enum
            Long count = (Long) stat[1];
            roleCounts.put(role.name(), count);
        }
        stats.put("roleDistribution", roleCounts);

        // Count by gender  
        List<Object[]> genderStats = userRepository.countUsersByGender();
        Map<String, Long> genderCounts = new HashMap<>();
        for (Object[] stat : genderStats) {
            Gender gender = (Gender) stat[0];  // Cast to enum
            Long count = (Long) stat[1];
            if (gender != null) {
                genderCounts.put(gender.name(), count);
            }
        }
        stats.put("genderDistribution", genderCounts);

        // Total counts
        stats.put("totalUsers", userRepository.count());
        stats.put("activeUsers", userRepository.findByRoleAndIsActive(Role.USER, true).size());
        stats.put("admins", userRepository.findByRoleAndIsActive(Role.ADMIN, true).size());

        return stats;
    }

    // Leaderboard
    public List<User> findTopUsersByScore(int limit) {
        return userRepository.findTopUsersByRole(Role.USER, PageRequest.of(0, limit));
    }

    // Admin methods with enum support
    public List<User> findAllAdmins() {
        return userRepository.findActiveAdmins();
    }

    public List<User> findUsersByCountryAndRole(String country, Role role) {
        return userRepository.findByCountryAndRole(country, role);
    }

    public List<User> findPremiumUsersByRole(Role role) {
        return userRepository.findPremiumUsersByRole(role);
    }

    // Search users
    public List<User> searchUsers(String searchTerm) {
        return userRepository.searchUsers(searchTerm);
    }

    // Promote user to collaborator
    public User promoteToCollaborator(Long userId) {
        return updateUserRole(userId, Role.COLLABORATOR);
    }

    // Demote collaborator to user
    public User demoteToUser(Long userId) {
        return updateUserRole(userId, Role.USER);
    }
}