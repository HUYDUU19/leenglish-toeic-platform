package com.leenglish.toeic.service;

import com.leenglish.toeic.domain.User;
import com.leenglish.toeic.enums.Role;
import org.springframework.stereotype.Service;

/**
 * Service xử lý authorization (kiểm tra quyền)
 * Quy định:
 * - ADMIN: Có thể làm tất cả mọi thứ
 * - USER: Chỉ có thể sửa profile của chính mình
 */
@Service
public class AuthorizationService {

    /**
     * Kiểm tra xem user có quyền sửa profile của target user không
     * 
     * @param currentUser  User đang đăng nhập (người thực hiện action)
     * @param targetUserId ID của user bị sửa (target)
     * @return true nếu có quyền, false nếu không
     */
    public boolean canEditUser(User currentUser, Long targetUserId) {
        // Nếu currentUser là null thì không có quyền gì
        if (currentUser == null) {
            return false;
        }

        // CASE 1: Nếu là ADMIN thì được phép sửa bất kỳ ai
        if (currentUser.getRole() == Role.ADMIN) {
            return true; // Admin có full quyền
        }

        // CASE 2: Nếu là USER thì chỉ được sửa chính mình
        if (currentUser.getRole() == Role.USER || currentUser.getRole() == Role.COLLABORATOR) {
            // So sánh ID: chỉ được sửa nếu targetUserId = currentUser.getId()
            return currentUser.getId().equals(targetUserId);
        }

        // CASE 3: Các role khác (nếu có) thì không có quyền
        return false;
    }

    /**
     * Kiểm tra xem user có quyền xóa user khác không
     * 
     * @param currentUser  User đang đăng nhập
     * @param targetUserId ID của user bị xóa
     * @return true nếu có quyền, false nếu không
     */
    public boolean canDeleteUser(User currentUser, Long targetUserId) {
        // Chỉ ADMIN mới được xóa user
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return false;
        }

        // ADMIN không thể tự xóa chính mình (để tránh lockout)
        if (currentUser.getId().equals(targetUserId)) {
            return false;
        }

        return true;
    }

    /**
     * Kiểm tra xem user có quyền thay đổi role của user khác không
     * 
     * @param currentUser  User đang đăng nhập
     * @param targetUserId ID của user bị thay đổi role
     * @param newRole      Role mới muốn set
     * @return true nếu có quyền, false nếu không
     */
    public boolean canChangeUserRole(User currentUser, Long targetUserId, Role newRole) {
        // Chỉ ADMIN mới được thay đổi role
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return false;
        }

        // ADMIN không thể thay đổi role của chính mình (để tránh lockout)
        if (currentUser.getId().equals(targetUserId)) {
            return false;
        }

        return true;
    }

    /**
     * Kiểm tra xem user có quyền xem thông tin của user khác không
     * 
     * @param currentUser  User đang đăng nhập
     * @param targetUserId ID của user muốn xem
     * @return true nếu có quyền, false nếu không
     */
    public boolean canViewUser(User currentUser, Long targetUserId) {
        if (currentUser == null) {
            return false;
        }

        // ADMIN có thể xem tất cả
        if (currentUser.getRole() == Role.ADMIN) {
            return true;
        }

        // USER chỉ có thể xem profile của chính mình
        return currentUser.getId().equals(targetUserId);
    }

    /**
     * Kiểm tra xem có phải là admin không
     * 
     * @param currentUser User cần kiểm tra
     * @return true nếu là admin
     */
    public boolean isAdmin(User currentUser) {
        return currentUser != null && currentUser.getRole() == Role.ADMIN;
    }

    /**
     * Lấy error message phù hợp khi không có quyền
     * 
     * @param action          Hành động bị cấm (edit, delete, view)
     * @param currentUserRole Role hiện tại của user
     * @return Message lỗi
     */
    public String getUnauthorizedMessage(String action, Role currentUserRole) {
        if (currentUserRole == Role.ADMIN) {
            return "Admin cannot " + action + " themselves to prevent system lockout";
        } else {
            return "You don't have permission to " + action + " other users. You can only " + action
                    + " your own profile.";
        }
    }
}
