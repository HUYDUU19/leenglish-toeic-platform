package com.leenglish.toeic.security;

import com.leenglish.toeic.service.JwtService;
import com.leenglish.toeic.service.UserService;
import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.dto.UserDto;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Arrays;
import java.util.Optional;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtService jwtService;

    @Autowired
    @Lazy
    private UserService userService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {

        final String authorizationHeader = request.getHeader("Authorization");

        String username = null;
        String jwt = null;
        String role = null;

        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            jwt = authorizationHeader.substring(7);
            try {
                username = jwtService.extractUsername(jwt);
                role = jwtService.extractRole(jwt);
            } catch (Exception e) {
                logger.warn("JWT extraction failed: " + e.getMessage());
            }
        }

        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            // Verify token is valid and user exists
            Optional<UserDto> userDtoOptional = userService.getUserByUsername(username);

            if (userDtoOptional.isPresent() && jwtService.isTokenValid(jwt, userDtoOptional.get())) {
                UserDto userDto = userDtoOptional.get();

                // Set authorities based on role
                SimpleGrantedAuthority authority = new SimpleGrantedAuthority("ROLE_" + userDto.getRole().name());

                UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        username, null, Arrays.asList(authority));
                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                SecurityContextHolder.getContext().setAuthentication(authToken);

                logger.info("JWT Filter: Authenticated user = " + username + ", role = " + userDto.getRole().name());
            } else {
                logger.warn("Invalid JWT token for user: " + username);
            }
        }

        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        String path = request.getRequestURI();
        return path.startsWith("/api/auth/") ||
                path.equals("/api/health") ||
                path.startsWith("/api/users/register") ||
                path.startsWith("/api/lessons/free") ||
                path.startsWith("/api/exercises/free");
    }
}
