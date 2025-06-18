package com.leenglish.toeic.service;

import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Optional;

/**
 * Service xử lý authentication (xác thực)
 * Tạm thời dùng simple authentication, sau này sẽ integrate JWT
 */
@Service
public class AuthenticationService {

    @Autowired
    private UserRepository userRepository;

    /**
     * Lấy user hiện tại từ ID (giả lập JWT token parsing)
     * 
     * @param userId ID của user (thường parse từ JWT token)
     * @return User object nếu tìm thấy
     */
    public Optional<User> getCurrentUser(Long userId) {
        if (userId == null) {
            return Optional.empty();
        }
        return userRepository.findById(userId);
    }

    /**
     * Kiểm tra xem user có đang active không
     * 
     * @param user User cần kiểm tra
     * @return true nếu user active
     */
    public boolean isActiveUser(User user) {
        return user != null && user.getIsActive() != null && user.getIsActive();
    }

    /**
     * Authenticate user bằng username/password (cho login)
     * 
     * @param username Username
     * @param password Password (plain text, sẽ được encode)
     * @return User nếu authentication thành công
     */
    public Optional<User> authenticate(String username, String password) {
        // Tìm user theo username
        Optional<User> userOpt = userRepository.findByUsername(username);

        if (userOpt.isEmpty()) {
            return Optional.empty();
        }

        User user = userOpt.get();

        // Kiểm tra password (tạm thời dùng plain text, sau này sẽ dùng BCrypt)
        // TODO: Implement proper password hashing với BCrypt
        if (user.getPasswordHash().equals(password) && isActiveUser(user)) {
            return Optional.of(user);
        }

        return Optional.empty();
    }
}
