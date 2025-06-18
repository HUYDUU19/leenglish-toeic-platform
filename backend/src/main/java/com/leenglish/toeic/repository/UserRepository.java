package com.leenglish.toeic.repository;

import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.enums.Role;
import com.leenglish.toeic.enums.Gender;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // Basic finder methods
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    Boolean existsByUsername(String username);
    Boolean existsByEmail(String email);
    
    // Find users by role
    List<User> findByRole(Role role);
    List<User> findByGender(Gender gender);
    List<User> findByRoleAndIsActive(Role role, Boolean isActive);
    List<User> findByGenderAndIsActive(Gender gender, Boolean isActive);

    // Advanced filtering with multiple enums
    @Query("SELECT u FROM User u WHERE " +
           "(:username IS NULL OR u.username LIKE %:username%) AND " +
           "(:email IS NULL OR u.email LIKE %:email%) AND " +
           "(:role IS NULL OR u.role = :role) AND " +                    // ✅ Enum parameter
           "(:gender IS NULL OR u.gender = :gender) AND " +               // ✅ Enum parameter  
           "(:country IS NULL OR u.country LIKE %:country%) AND " +
           "(:isActive IS NULL OR u.isActive = :isActive)")
    Page<User> findUsersWithFilters(
        @Param("username") String username,
        @Param("email") String email, 
        @Param("role") Role role,           // ✅ Enum type
        @Param("gender") Gender gender,     // ✅ Enum type
        @Param("country") String country,
        @Param("isActive") Boolean isActive,
        Pageable pageable);

    // Leaderboard query
    @Query("SELECT u FROM User u WHERE u.role = :role AND u.isActive = true ORDER BY u.totalScore DESC")
    List<User> findTopUsersByRole(@Param("role") Role role, Pageable pageable);

    // Admin queries  
    @Query("SELECT u FROM User u WHERE u.role = 'ADMIN' AND u.isActive = true")
    List<User> findActiveAdmins();

    // User statistics by enum
    @Query("SELECT u.role, COUNT(u) FROM User u WHERE u.isActive = true GROUP BY u.role")
    List<Object[]> countUsersByRole();

    @Query("SELECT u.gender, COUNT(u) FROM User u WHERE u.isActive = true GROUP BY u.gender")
    List<Object[]> countUsersByGender();

    // Country-based queries with enum filtering
    @Query("SELECT u FROM User u WHERE u.country = :country AND u.role = :role AND u.isActive = true")
    List<User> findByCountryAndRole(@Param("country") String country, @Param("role") Role role);

    // Premium users with enum support
    @Query("SELECT u FROM User u WHERE u.isPremium = true AND u.role = :role ORDER BY u.premiumExpiresAt DESC")
    List<User> findPremiumUsersByRole(@Param("role") Role role);

    // Leaderboard - top users by score
    List<User> findTop10ByIsActiveTrueOrderByTotalScoreDesc();

    // Search users
    @Query("SELECT u FROM User u WHERE u.isActive = true AND " +
           "(u.username LIKE %:searchTerm% OR u.fullName LIKE %:searchTerm% OR u.email LIKE %:searchTerm%)")
    List<User> searchUsers(@Param("searchTerm") String searchTerm);

    // Find inactive users (haven't logged in since date)
    @Query("SELECT u FROM User u WHERE u.lastLogin < :date")
    List<User> findInactiveUsers(@Param("date") LocalDate date);

    // Count users by role
    @Query("SELECT COUNT(u) FROM User u WHERE u.role = :role")
    Long countByRole(@Param("role") Role role);

    // Find users by keyword (email, username or fullName)
    @Query("SELECT u FROM User u WHERE u.email LIKE %:keyword% OR u.username LIKE %:keyword% OR u.fullName LIKE %:keyword%")
    List<User> findByKeyword(@Param("keyword") String keyword);

    // Find users by keyword and role
    @Query("SELECT u FROM User u WHERE (u.email LIKE %:keyword% OR u.username LIKE %:keyword% OR u.fullName LIKE %:keyword%) AND u.role = :role")
    List<User> findByKeywordAndRole(@Param("keyword") String keyword, @Param("role") Role role);

    // Find active users
    @Query("SELECT u FROM User u WHERE u.isActive = true")
    List<User> findActiveUsers();

    // Find active users by role
    @Query("SELECT u FROM User u WHERE u.isActive = true AND u.role = :role")
    List<User> findActiveUsersByRole(@Param("role") Role role);

    // Find active users by keyword
    @Query("SELECT u FROM User u WHERE u.isActive = true AND (u.email LIKE %:keyword% OR u.username LIKE %:keyword% OR u.fullName LIKE %:keyword%)")
    List<User> findActiveUsersByKeyword(@Param("keyword") String keyword);

    // Find user by username or email (for login)
    @Query("SELECT u FROM User u WHERE u.username = :usernameOrEmail OR u.email = :usernameOrEmail")
    Optional<User> findByUsernameOrEmail(@Param("usernameOrEmail") String usernameOrEmail);

    // Find premium users
    @Query("SELECT u FROM User u WHERE u.isPremium = true")
    List<User> findPremiumUsers();

    // Find expired premium users
    @Query("SELECT u FROM User u WHERE u.isPremium = true AND u.premiumExpiresAt < CURRENT_TIMESTAMP")
    List<User> findExpiredPremiumUsers();
}