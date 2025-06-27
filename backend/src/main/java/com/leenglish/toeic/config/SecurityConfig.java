package com.leenglish.toeic.config;

import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.leenglish.toeic.security.JwtAuthenticationEntryPoint;
import com.leenglish.toeic.security.JwtAuthenticationFilter;

@EnableMethodSecurity
@Configuration
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;
    private final UserDetailsService userDetailsService;

    @Autowired
    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter,
            JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint, UserDetailsService userDetailsService) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
        this.jwtAuthenticationEntryPoint = jwtAuthenticationEntryPoint;
        this.userDetailsService = userDetailsService;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }

    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(authz -> authz
                        // ================================================================
                        // BASIC PUBLIC ENDPOINTS
                        // ================================================================
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/api/health").permitAll()
                        .requestMatchers("/api/users/register").permitAll()
                        .requestMatchers("/h2-console/**").permitAll()
                        .requestMatchers("/swagger-ui/**", "/v3/api-docs/**").permitAll()

                        // ================================================================
                        // PUBLIC LESSON ENDPOINTS
                        // ================================================================
                        .requestMatchers(HttpMethod.GET, "/api/lessons/free").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/lessons/free/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/lessons/*/exercises/*/questions/free").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/questions/free").permitAll()

                        // ================================================================
                        // PUBLIC FLASHCARD ENDPOINTS (UPDATED)
                        // ================================================================
                        // Public flashcard set endpoints
                        .requestMatchers(HttpMethod.GET, "/api/flashcard-sets/public").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcard-sets/*/public").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcard-sets/search").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcard-sets/category/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcard-sets/difficulty/**").permitAll()

                        // Public flashcards endpoints
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/free").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/free/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/sets").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/sets/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/search").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/test").permitAll()

                        // Legacy public endpoints (for backward compatibility)
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/sets").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/sets/search").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/set/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/level/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/category/**").permitAll()

                        // ================================================================
                        // AUTHENTICATED LESSON ENDPOINTS
                        // ================================================================
                        .requestMatchers(HttpMethod.GET, "/api/lessons").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/lessons/{lessonId}").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/lessons/{lessonId}/exercises").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/lessons/{lessonId}/exercises/{exerciseId}")
                        .authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/lessons/{lessonId}/exercises/{exerciseId}/questions")
                        .authenticated()
                        .requestMatchers(HttpMethod.GET,
                                "/api/lessons/{lessonId}/exercises/{exerciseId}/questions/{questionId}")
                        .authenticated()

                        // Submit answers
                        .requestMatchers(HttpMethod.POST,
                                "/api/lessons/{lessonId}/exercises/{exerciseId}/questions/submit")
                        .authenticated()
                        .requestMatchers(HttpMethod.POST, "/api/lessons/{lessonId}/exercises/{exerciseId}/submit")
                        .authenticated()

                        // ================================================================
                        // AUTHENTICATED FLASHCARD ENDPOINTS (NEW)
                        // ================================================================
                        // Flashcard sets
                        .requestMatchers(HttpMethod.GET, "/api/flashcard-sets").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/flashcard-sets/{id}").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/flashcard-sets/{id}/flashcards").authenticated()
                        .requestMatchers(HttpMethod.POST, "/api/flashcard-sets/{id}/view").authenticated() // Track
                                                                                                           // views

                        // User's flashcard sets
                        .requestMatchers(HttpMethod.GET, "/api/flashcard-sets/my").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/flashcard-sets/accessible").authenticated()

                        // Flashcard study endpoints
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/study/{setId}").authenticated()
                        .requestMatchers(HttpMethod.POST, "/api/flashcards/study/{setId}/answer").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/flashcards/study/{setId}/progress").authenticated()

                        // ================================================================
                        // DASHBOARD & USER ACTIVITY ENDPOINTS
                        // ================================================================
                        .requestMatchers("/api/dashboard/test").permitAll() // TEMPORARY FOR TESTING
                        .requestMatchers("/api/dashboard/debug").permitAll() // TEMPORARY FOR TESTING
                        .requestMatchers("/api/dashboard/**").hasAnyRole("USER", "ADMIN")
                        .requestMatchers("/api/user-activities/my/**").authenticated()
                        .requestMatchers("/api/user-activities/admin/**").hasRole("ADMIN")

                        // ================================================================
                        // CONTENT CREATION ENDPOINTS (COLLABORATORS + ADMINS)
                        // ================================================================
                        .requestMatchers(HttpMethod.POST, "/api/flashcard-sets").hasAnyRole("COLLABORATOR", "ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/flashcard-sets/**").hasAnyRole("COLLABORATOR", "ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/flashcard-sets/**").hasRole("ADMIN")

                        .requestMatchers(HttpMethod.POST, "/api/flashcards").hasAnyRole("COLLABORATOR", "ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/flashcards/**").hasAnyRole("COLLABORATOR", "ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/flashcards/**").hasRole("ADMIN")

                        // ================================================================
                        // PREMIUM CONTENT ENDPOINTS
                        // ================================================================
                        .requestMatchers("/api/lessons/premium/**").hasAnyRole("PREMIUM", "ADMIN")
                        .requestMatchers("/api/exercises/premium/**").hasAnyRole("PREMIUM", "ADMIN")
                        .requestMatchers("/api/flashcard-sets/premium/**").hasAnyRole("PREMIUM", "ADMIN")

                        // ================================================================
                        // ADMIN ENDPOINTS
                        // ================================================================
                        .requestMatchers("/api/admin/**").hasRole("ADMIN")
                        .requestMatchers("/api/users/admin/**").hasRole("ADMIN")

                        // Admin content management
                        .requestMatchers("/api/admin/lessons/**").hasRole("ADMIN")
                        .requestMatchers("/api/admin/exercises/**").hasRole("ADMIN")
                        .requestMatchers("/api/admin/flashcard-sets/**").hasRole("ADMIN")
                        .requestMatchers("/api/admin/flashcards/**").hasRole("ADMIN")

                        // ================================================================
                        // OTHER PROTECTED ENDPOINTS
                        // ================================================================
                        .requestMatchers("/api/users/profile").hasAnyRole("USER", "ADMIN")
                        .requestMatchers("/api/progress/**").hasAnyRole("USER", "ADMIN")

                        // Legacy catch-all patterns (maintain backward compatibility)
                        .requestMatchers("/api/lessons/**").hasAnyRole("USER", "ADMIN")
                        .requestMatchers("/api/exercises/**").hasAnyRole("USER", "ADMIN")
                        .requestMatchers("/api/questions/**").hasAnyRole("USER", "ADMIN")
                        .requestMatchers("/api/flashcards/**").hasAnyRole("USER", "ADMIN")

                        // All other requests require authentication
                        .anyRequest().authenticated())
                .exceptionHandling(ex -> ex.authenticationEntryPoint(jwtAuthenticationEntryPoint))
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        configuration.setAllowedOriginPatterns(Arrays.asList(
                "http://localhost:3000",
                "http://localhost:3001",
                "http://127.0.0.1:3000",
                "http://127.0.0.1:3001"));

        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));
        configuration.setAllowedHeaders(Arrays.asList("*"));

        configuration.setExposedHeaders(Arrays.asList(
                "Access-Control-Allow-Origin",
                "Access-Control-Allow-Credentials"));

        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
