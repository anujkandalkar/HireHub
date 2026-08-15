package com.hirehub.dao;

import com.hirehub.model.User;
import com.hirehub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromRS(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findByEmailAndRole(String email, String role) {
        if (role == null || role.trim().isEmpty()) {
            return findByEmail(email);
        }
        String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(?) AND role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            ps.setString(2, role.trim().toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromRS(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findByPhoneAndRole(String phone, String role) {
        if (phone == null || phone.trim().isEmpty()) return null;
        String cleanPhone = phone.replaceAll("[^0-9]", "");
        if (cleanPhone.isEmpty()) return null;

        String sql;
        if ("STUDENT".equalsIgnoreCase(role)) {
            sql = "SELECT u.* FROM users u JOIN students s ON u.id = s.user_id WHERE REPLACE(REPLACE(REPLACE(s.phone, '-', ''), ' ', ''), '+', '') LIKE ? AND u.role = 'STUDENT'";
        } else if ("COMPANY".equalsIgnoreCase(role)) {
            sql = "SELECT u.* FROM users u JOIN companies c ON u.id = c.user_id WHERE REPLACE(REPLACE(REPLACE(c.phone, '-', ''), ' ', ''), '+', '') LIKE ? AND u.role = 'COMPANY'";
        } else {
            sql = "SELECT u.* FROM users u LEFT JOIN students s ON u.id = s.user_id LEFT JOIN companies c ON u.id = c.user_id " +
                  "WHERE REPLACE(REPLACE(REPLACE(s.phone, '-', ''), ' ', ''), '+', '') LIKE ? OR REPLACE(REPLACE(REPLACE(c.phone, '-', ''), ' ', ''), '+', '') LIKE ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + cleanPhone + "%");
            if (!"STUDENT".equalsIgnoreCase(role) && !"COMPANY".equalsIgnoreCase(role)) {
                ps.setString(2, "%" + cleanPhone + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromRS(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findByEmailPhoneAndRole(String email, String phone, String role) {
        if (email == null || email.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
            return null;
        }
        String cleanPhone = phone.replaceAll("[^0-9]", "");
        if (cleanPhone.isEmpty()) return null;

        String sql;
        if ("STUDENT".equalsIgnoreCase(role)) {
            sql = "SELECT u.* FROM users u JOIN students s ON u.id = s.user_id " +
                  "WHERE LOWER(u.email) = LOWER(?) AND REPLACE(REPLACE(REPLACE(s.phone, '-', ''), ' ', ''), '+', '') LIKE ? AND u.role = 'STUDENT'";
        } else if ("COMPANY".equalsIgnoreCase(role)) {
            sql = "SELECT u.* FROM users u JOIN companies c ON u.id = c.user_id " +
                  "WHERE LOWER(u.email) = LOWER(?) AND REPLACE(REPLACE(REPLACE(c.phone, '-', ''), ' ', ''), '+', '') LIKE ? AND u.role = 'COMPANY'";
        } else {
            sql = "SELECT u.* FROM users u LEFT JOIN students s ON u.id = s.user_id LEFT JOIN companies c ON u.id = c.user_id " +
                  "WHERE LOWER(u.email) = LOWER(?) AND (REPLACE(REPLACE(REPLACE(s.phone, '-', ''), ' ', ''), '+', '') LIKE ? OR REPLACE(REPLACE(REPLACE(c.phone, '-', ''), ' ', ''), '+', '') LIKE ?)";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            ps.setString(2, "%" + cleanPhone + "%");
            if (!"STUDENT".equalsIgnoreCase(role) && !"COMPANY".equalsIgnoreCase(role)) {
                ps.setString(3, "%" + cleanPhone + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromRS(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromRS(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int createUser(User user) {
        String sql = "INSERT INTO users (email, password_hash, salt, role, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getEmail().trim());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getSalt());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getStatus() != null ? user.getStatus() : "ACTIVE");
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePassword(int userId, String newHash, String newSalt) {
        String sql = "UPDATE users SET password_hash = ?, salt = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setString(2, newSalt);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(extractUserFromRS(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    private User extractUserFromRS(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setSalt(rs.getString("salt"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
