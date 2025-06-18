package com.leenglish.toeic.repository;

import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.enums.Role;
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