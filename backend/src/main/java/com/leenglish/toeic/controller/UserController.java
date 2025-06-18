package com.leenglish.toeic.controller;

import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.dto.UserDto;
import com.leenglish.toeic.enums.Role;
import com.leenglish.toeic.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public ResponseEntity<List<UserDto>> getAllUsers() {
        try {
            List<UserDto> users = userService.getAllUsers();
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserDto> getUserById(@PathVariable Long id) {
        try {
            return userService.getUserById(id)
                    .map(user -> ResponseEntity.ok(user))
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/username/{username}")
    public ResponseEntity<UserDto> getUserByUsername(@PathVariable String username) {
        try {
            return userService.getUserByUsername(username)
                    .map(user -> ResponseEntity.ok(user))
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/email/{email}")
    public ResponseEntity<UserDto> getUserByEmail(@PathVariable String email) {
        try {
            return userService.getUserByEmail(email)
                    .map(user -> ResponseEntity.ok(user))
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping
    public ResponseEntity<UserDto> createUser(@Valid @RequestBody Map<String, Object> requestBody) {
        try {
            UserDto userDto = new UserDto();
            userDto.setUsername((String) requestBody.get("username"));
            userDto.setEmail((String) requestBody.get("email"));
            userDto.setFullName((String) requestBody.get("fullName"));

            String password = (String) requestBody.get("password");
            if (password == null || password.trim().isEmpty()) {
                return ResponseEntity.badRequest().build();
            }

            User newUser = userService.createUser(
                    userDto.getUsername(),
                    userDto.getEmail(),
                    password,
                    userDto.getFullName(),
                    userDto.getRole() != null ? userDto.getRole() : Role.USER);

            return ResponseEntity.status(HttpStatus.CREATED).body(convertToDto(newUser));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserDto> updateUser(@PathVariable Long id, @Valid @RequestBody UserDto userDto) {
        try {
            User updatedUser = userService.updateUser(id, userDto);
            return ResponseEntity.ok(convertToDto(updatedUser));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/role/{role}")
    public ResponseEntity<List<UserDto>> getUsersByRole(@PathVariable Role role) {
        try {
            List<UserDto> users = userService.getUsersByRole(role);
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/leaderboard")
    public ResponseEntity<List<UserDto>> getTopUsers() {
        try {
            List<UserDto> topUsers = userService.getTopUsers();
            return ResponseEntity.ok(topUsers);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/{id}/score")
    public ResponseEntity<UserDto> updateUserScore(@PathVariable Long id, @RequestBody Map<String, Integer> scoreData) {
        try {
            Integer score = scoreData.get("score");
            if (score == null) {
                return ResponseEntity.badRequest().build();
            }

            User updatedUser = userService.updateUserScore(id, score);
            return ResponseEntity.ok(convertToDto(updatedUser));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    private UserDto convertToDto(User user) {
        UserDto userDto = new UserDto();
        userDto.setId(user.getId());
        userDto.setUsername(user.getUsername());
        userDto.setEmail(user.getEmail());
        userDto.setFullName(user.getFullName());
        userDto.setRole(user.getRole());
        userDto.setCreatedAt(user.getCreatedAt());
        userDto.setUpdatedAt(user.getUpdatedAt());

        // Set additional fields with default values if methods don't exist
        if (user.getTotalScore() != null) {
            userDto.setTotalScore(user.getTotalScore());
        } else {
            userDto.setTotalScore(0);
        }

        // Set default values for fields that might not exist in User entity
        userDto.setCurrentLevel(1);
        userDto.setTestsCompleted(0);

        return userDto;
    }
}
