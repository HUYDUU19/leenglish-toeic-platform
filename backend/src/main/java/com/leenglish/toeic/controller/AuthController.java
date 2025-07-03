package com.leenglish.toeic.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.dto.RegisterRequest;
import com.leenglish.toeic.enums.Role;
import com.leenglish.toeic.service.JwtService;
import com.leenglish.toeic.service.UserService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserService userService;

    @Autowired
    private JwtService jwtService;

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> loginRequest) {
        String username = loginRequest.get("username");
        String email = loginRequest.get("email");
        String password = loginRequest.get("password");

        Map<String, Object> response = new HashMap<>();

        try {
            String loginIdentifier = username != null ? username : email;

            if (loginIdentifier == null || password == null) {
                response.put("success", false);
                response.put("message", "Username/email and password are required");
                return ResponseEntity.badRequest().body(response);
            }

            // Lấy user từ DB (phải đúng username/email)
            Optional<User> userOptional = username != null
                    ? userService.findUserByUsername(username)
                    : userService.findUserByEmail(email);

            if (userOptional.isEmpty()) {
                response.put("success", false);
                response.put("message", "User not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }

            User user = userOptional.get();

            // Check if user is active
            if (!user.isActiveUser()) {
                response.put("success", false);
                response.put("message", "Account is not active");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }

            // Authenticate user (sẽ throw nếu sai password)
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginIdentifier, password));

            // Nếu tới đây là đúng password
            String accessToken = jwtService.generateAccessToken(user);
            String refreshToken = jwtService.generateRefreshToken(user);

            response.put("success", true);
            response.put("message", "Login successful");
            response.put("accessToken", accessToken);
            response.put("refreshToken", refreshToken);
            response.put("tokenType", "Bearer");
            response.put("expiresIn", jwtService.getAccessTokenExpiration());

            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("id", user.getId());
            userInfo.put("username", user.getUsername());
            userInfo.put("email", user.getEmail());
            userInfo.put("fullName", user.getFullName());
            userInfo.put("role", user.getRole().name());
            String redirectUrl = "/dashboard";
            if ("ADMIN".equals(user.getRole().name())) {
                redirectUrl = "/admin/dashboard";
            } else if ("USER".equals(user.getRole().name())) {
                redirectUrl = "/user/dashboard";
            }
            userInfo.put("redirectUrl", redirectUrl);
            response.put("user", userInfo);

            return ResponseEntity.ok(response);
        } catch (BadCredentialsException e) {
            response.put("success", false);
            response.put("message", "Invalid username or password");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        } catch (AuthenticationException e) {
            response.put("success", false);
            response.put("message", "Authentication failed: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Login failed: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest req) {
        String username = req.getUsername();
        String email = req.getEmail();
        String password = req.getPassword();
        String fullName = req.getFullName();

        Map<String, Object> response = new HashMap<>();

        try {
            // Validate required fields
            if (username == null || email == null || password == null || fullName == null) {
                response.put("success", false);
                response.put("message", "All fields are required: username, email, password, fullName");
                return ResponseEntity.badRequest().body(response);
            }

            // Check if user already exists (case-insensitive)
            if (userService.findUserByUsername(username).isPresent()) {
                response.put("success", false);
                response.put("message", "Username already exists");
                return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
            }

            if (userService.findUserByEmail(email).isPresent()) {
                response.put("success", false);
                response.put("message", "Email already exists");
                return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
            }

            // DEBUG: Log all existing usernames and emails for troubleshooting
            System.out.println("DEBUG: Existing usernames:");
            userService.getAllUsers().forEach(u -> System.out.println(u.getUsername() + " / " + u.getEmail()));

            // Create new user (only USER role allowed for registration)
            User newUser = userService.createUser(
                    req.getUsername(),
                    req.getEmail(),
                    req.getPassword(),
                    req.getFullName(),
                    Role.USER // Add the default role
            );

            // Đảm bảo user đã được lưu vào DB
            if (newUser == null || newUser.getId() == null) {
                response.put("success", false);
                response.put("message", "Failed to save user to database");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
            }

            // Generate tokens
            String accessToken = jwtService.generateAccessToken(newUser);
            String refreshToken = jwtService.generateRefreshToken(newUser);

            response.put("success", true);
            response.put("message", "Registration successful");
            response.put("accessToken", accessToken);
            response.put("refreshToken", refreshToken);
            response.put("tokenType", "Bearer");
            response.put("expiresIn", jwtService.getAccessTokenExpiration());

            // User info with redirect URL
            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("id", newUser.getId());
            userInfo.put("username", newUser.getUsername());
            userInfo.put("email", newUser.getEmail());
            userInfo.put("fullName", newUser.getFullName());
            userInfo.put("role", newUser.getRole().name());
            userInfo.put("redirectUrl", "/user/dashboard"); // Regular users go to user dashboard
            response.put("user", userInfo);

            return ResponseEntity.status(HttpStatus.CREATED).body(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Registration failed: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PostMapping("/refresh")
    public ResponseEntity<Map<String, Object>> refreshToken(@RequestBody Map<String, String> refreshRequest) {
        String refreshToken = refreshRequest.get("refreshToken");
        Map<String, Object> response = new HashMap<>();

        try {
            if (refreshToken == null) {
                response.put("success", false);
                response.put("message", "Refresh token is required");
                return ResponseEntity.badRequest().body(response);
            }

            // Validate refresh token
            if (!jwtService.isRefreshToken(refreshToken) || !jwtService.isTokenValid(refreshToken)) {
                response.put("success", false);
                response.put("message", "Invalid refresh token");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            } // Get user from token
            String username = jwtService.extractUsername(refreshToken);
            Optional<User> userOptional = userService.findUserByUsername(username);

            if (userOptional.isPresent()) {
                User user = userOptional.get();

                // Generate new access token
                String newAccessToken = jwtService.refreshAccessToken(refreshToken, user);

                response.put("success", true);
                response.put("message", "Token refreshed successfully");
                response.put("accessToken", newAccessToken);
                response.put("tokenType", "Bearer");
                response.put("expiresIn", jwtService.getAccessTokenExpiration());

                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "User not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Token refresh failed: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(
            @RequestHeader(value = "Authorization", required = false) String token) {
        Map<String, Object> response = new HashMap<>();

        // TODO: Implement token blacklisting for enhanced security
        // For now, we'll just return success since JWT tokens are stateless
        response.put("success", true);
        response.put("message", "Logout successful");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> getCurrentUser(@RequestHeader("Authorization") String authHeader) {
        Map<String, Object> response = new HashMap<>();

        try {
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                response.put("success", false);
                response.put("message", "Invalid authorization header");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }

            String token = authHeader.substring(7);
            String username = jwtService.extractUsername(token);
            Optional<User> userOptional = userService.findUserByUsername(username);

            if (userOptional.isPresent()) {
                User user = userOptional.get();

                Map<String, Object> userInfo = new HashMap<>();
                userInfo.put("id", user.getId());
                userInfo.put("username", user.getUsername());
                userInfo.put("email", user.getEmail());
                userInfo.put("fullName", user.getFullName());
                userInfo.put("role", user.getRole().name());
                userInfo.put("isActive", user.isActiveUser());

                response.put("success", true);
                response.put("user", userInfo);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "User not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to get user info: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
