package com.hirehub.dao;

import com.hirehub.model.Message;
import com.hirehub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public int sendMessage(Message msg) {
        String sql = "INSERT INTO messages (sender_id, receiver_id, application_id, subject, message_text) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, msg.getSenderId());
            ps.setInt(2, msg.getReceiverId());
            if (msg.getApplicationId() > 0) {
                ps.setInt(3, msg.getApplicationId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setString(4, msg.getSubject());
            ps.setString(5, msg.getMessageText());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Message> getMessagesForUser(int userId) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT m.*, u_send.email as sender_email, u_recv.email as receiver_email " +
                     "FROM messages m " +
                     "JOIN users u_send ON m.sender_id = u_send.id " +
                     "JOIN users u_recv ON m.receiver_id = u_recv.id " +
                     "WHERE m.receiver_id = ? OR m.sender_id = ? ORDER BY m.sent_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Message m = new Message();
                    m.setId(rs.getInt("id"));
                    m.setSenderId(rs.getInt("sender_id"));
                    m.setReceiverId(rs.getInt("receiver_id"));
                    m.setApplicationId(rs.getInt("application_id"));
                    m.setSubject(rs.getString("subject"));
                    m.setMessageText(rs.getString("message_text"));
                    m.setSentAt(rs.getTimestamp("sent_at"));
                    m.setRead(rs.getBoolean("is_read"));
                    m.setSenderName(rs.getString("sender_email"));
                    m.setReceiverName(rs.getString("receiver_email"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean markAsRead(int messageId, int userId) {
        String sql = "UPDATE messages SET is_read = TRUE WHERE id = ? AND receiver_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, messageId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
