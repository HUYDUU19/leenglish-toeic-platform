package com.leenglish.toeic.service;

import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.dto.UserDto;
import com.leenglish.toeic.enums.Role;
import com.leenglish.toeic.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
      public User registerUser(UserDto userDto) {
        User user = new User();
        user.setUsername(userDto.getUsername());
        user.setEmail(userDto.getEmail());
        // Note: Password should be handled separately for security
        
        return userRepository.save(user);
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

    

    public List<User> findPremiumUsers() {
        return userRepository.findPremiumUsers();
    }

    public List<User> findExpiredPremiumUsers() {
        return userRepository.findExpiredPremiumUsers();
    }
      public User saveUser(User user) {
        return userRepository.save(user);
    }

    // User creation and registration
    public User createUser(String username, String email, String password, String fullName, Role role) {
        // Check if username or email already exists
        if (userRepository.existsByUsername(username)) {
            throw new IllegalArgumentException("Username already exists");
        }
        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("Email already exists");
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setFullName(fullName);
        user.setRole(role != null ? role : Role.USER);
        user.setIsActive(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        
        return userRepository.save(user);
    }

    public User registerUser(String username, String email, String password, String fullName) {
        return createUser(username, email, password, fullName, Role.USER);
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
}