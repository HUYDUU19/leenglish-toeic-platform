package com.leenglish.toeic.service;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Value;
import com.leenglish.toeic.domain.User;
import java.time.*;
import java.util.*;
import java.util.function.Function;
import java.time.temporal.ChronoUnit;
import io.jsonwebtoken.*;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.Key;

@Service
public class JwtService {

    @Value("${app.jwt.secret:defaultSecretKeyForDevelopment}")
    private String secretKey;

    @Value("${app.jwt.expiration:86400}") // 24 hours in seconds
    private long jwtExpiration;

    @Value("${app.jwt.refresh-expiration:604800}") // 7 days in seconds
    private long refreshExpiration;

    private static final String TOKEN_TYPE_CLAIM = "tokenType";
    private static final String ACCESS_TOKEN_TYPE = "ACCESS";
    private static final String REFRESH_TOKEN_TYPE = "REFRESH";

    public String generateAccessToken(User user) {
        return generateToken(user, jwtExpiration, ACCESS_TOKEN_TYPE);
    }

    public String generateRefreshToken(User user) {
        return generateToken(user, refreshExpiration, REFRESH_TOKEN_TYPE);
    }

    private String generateToken(User user, long expiration, String tokenType) {
        Key key = getSigningKey();
        return Jwts.builder()
                .setSubject(user.getUsername())
                .claim("userId", user.getId())
                .claim("role", user.getRole().name())
                .claim("email", user.getEmail())
                .claim(TOKEN_TYPE_CLAIM, tokenType)
                .setIssuedAt(new Date())
                .setExpiration(Date.from(Instant.now().plus(expiration, ChronoUnit.SECONDS)))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    public String generateToken(User user) {
        return generateAccessToken(user);
    }

    public String generateToken(String username, String role) {
        Key key = getSigningKey();
        return Jwts.builder()
                .setSubject(username)
                .claim("role", role)
                .claim(TOKEN_TYPE_CLAIM, ACCESS_TOKEN_TYPE)
                .setIssuedAt(new Date())
                .setExpiration(Date.from(Instant.now().plus(jwtExpiration, ChronoUnit.SECONDS)))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public String extractRole(String token) {
        return extractClaim(token, claims -> claims.get("role", String.class));
    }

    public Long extractUserId(String token) {
        return extractClaim(token, claims -> claims.get("userId", Long.class));
    }

    public String extractEmail(String token) {
        return extractClaim(token, claims -> claims.get("email", String.class));
    }

    public String extractTokenType(String token) {
        return extractClaim(token, claims -> claims.get(TOKEN_TYPE_CLAIM, String.class));
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public Date extractIssuedAt(String token) {
        return extractClaim(token, Claims::getIssuedAt);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        try {
            Key key = getSigningKey();
            return Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (ExpiredJwtException e) {
            throw new IllegalArgumentException("Token has expired", e);
        } catch (UnsupportedJwtException e) {
            throw new IllegalArgumentException("Token is unsupported", e);
        } catch (MalformedJwtException e) {
            throw new IllegalArgumentException("Token is malformed", e);
        } catch (SignatureException e) {
            throw new IllegalArgumentException("Token signature is invalid", e);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Token is invalid", e);
        }
    }

    private Key getSigningKey() {
        byte[] keyBytes = secretKey.getBytes(StandardCharsets.UTF_8);
        return new SecretKeySpec(keyBytes, SignatureAlgorithm.HS256.getJcaName());
    }

    public boolean isTokenExpired(String token) {
        try {
            Date expiration = extractExpiration(token);
            return expiration.before(new Date());
        } catch (Exception e) {
            return true;
        }
    }

    public boolean isAccessToken(String token) {
        try {
            String tokenType = extractTokenType(token);
            return ACCESS_TOKEN_TYPE.equals(tokenType);
        } catch (Exception e) {
            return false;
        }
    }

    public boolean isRefreshToken(String token) {
        try {
            String tokenType = extractTokenType(token);
            return REFRESH_TOKEN_TYPE.equals(tokenType);
        } catch (Exception e) {
            return false;
        }
    }

    public boolean isTokenValid(String token) {
        try {
            extractAllClaims(token);
            return !isTokenExpired(token);
        } catch (Exception e) {
            return false;
        }
    }

    public boolean isTokenValid(String token, User user) {
        try {
            final String username = extractUsername(token);
            return (username.equals(user.getUsername())) && !isTokenExpired(token);
        } catch (Exception e) {
            return false;
        }
    }

    public String refreshAccessToken(String refreshToken, User user) {
        if (isRefreshToken(refreshToken) && isTokenValid(refreshToken, user)) {
            return generateAccessToken(user);
        }
        throw new IllegalArgumentException("Invalid refresh token");
    }

    public String refreshToken(String token) {
        if (isTokenValid(token)) {
            String username = extractUsername(token);
            String role = extractRole(token);
            return generateToken(username, role);
        }
        throw new IllegalArgumentException("Invalid token");
    }

    // Additional utility methods
    public long getAccessTokenExpiration() {
        return jwtExpiration;
    }

    public long getRefreshTokenExpiration() {
        return refreshExpiration;
    }

    public Date getExpirationDateFromToken(String token) {
        return extractExpiration(token);
    }

    public boolean canTokenBeRefreshed(String token) {
        return isRefreshToken(token) && !isTokenExpired(token);
    }

    public Map<String, Object> getTokenInfo(String token) {
        Map<String, Object> info = new HashMap<>();
        try {
            info.put("username", extractUsername(token));
            info.put("role", extractRole(token));
            info.put("userId", extractUserId(token));
            info.put("email", extractEmail(token));
            info.put("tokenType", extractTokenType(token));
            info.put("issuedAt", extractIssuedAt(token));
            info.put("expiration", extractExpiration(token));
            info.put("isExpired", isTokenExpired(token));
            info.put("isValid", isTokenValid(token));
        } catch (Exception e) {
            info.put("error", e.getMessage());
        }
        return info;
    }
}
