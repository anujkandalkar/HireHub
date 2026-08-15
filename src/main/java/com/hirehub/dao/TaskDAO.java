package com.hirehub.dao;

import com.hirehub.model.Task;
import com.hirehub.model.TaskSubmission;
import com.hirehub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {

    public int createTask(Task task) {
        String sql = "INSERT INTO tasks (application_id, company_id, student_id, title, description, instructions, deadline) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, task.getApplicationId());
            ps.setInt(2, task.getCompanyId());
            ps.setInt(3, task.getStudentId());
            ps.setString(4, task.getTitle());
            ps.setString(5, task.getDescription());
            ps.setString(6, task.getInstructions());
            ps.setDate(7, task.getDeadline());

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

    public List<Task> getTasksByStudent(int studentId) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.*, c.company_name, s.full_name as student_name, j.title as job_title " +
                     "FROM tasks t " +
                     "JOIN companies c ON t.company_id = c.id " +
                     "JOIN students s ON t.student_id = s.id " +
                     "JOIN applications a ON t.application_id = a.id " +
                     "JOIN jobs j ON a.job_id = j.id " +
                     "WHERE t.student_id = ? ORDER BY t.assigned_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Task t = extractTaskFromRS(rs);
                    t.setSubmission(getSubmissionByTaskId(t.getId()));
                    tasks.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    public List<Task> getTasksByCompany(int companyId) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.*, c.company_name, s.full_name as student_name, j.title as job_title " +
                     "FROM tasks t " +
                     "JOIN companies c ON t.company_id = c.id " +
                     "JOIN students s ON t.student_id = s.id " +
                     "JOIN applications a ON t.application_id = a.id " +
                     "JOIN jobs j ON a.job_id = j.id " +
                     "WHERE t.company_id = ? ORDER BY t.assigned_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Task t = extractTaskFromRS(rs);
                    t.setSubmission(getSubmissionByTaskId(t.getId()));
                    tasks.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    public boolean submitTask(TaskSubmission sub) {
        String sql = "INSERT INTO task_submissions (task_id, submission_text, file_path, status) VALUES (?, ?, ?, 'SUBMITTED') " +
                     "ON DUPLICATE KEY UPDATE submission_text = VALUES(submission_text), file_path = VALUES(file_path), submitted_at = CURRENT_TIMESTAMP, status = 'SUBMITTED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sub.getTaskId());
            ps.setString(2, sub.getSubmissionText());
            ps.setString(3, sub.getFilePath());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean reviewTaskSubmission(int taskId, String status, String feedback) {
        String sql = "UPDATE task_submissions SET status = ?, feedback = ? WHERE task_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, feedback);
            ps.setInt(3, taskId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public TaskSubmission getSubmissionByTaskId(int taskId) {
        String sql = "SELECT * FROM task_submissions WHERE task_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TaskSubmission sub = new TaskSubmission();
                    sub.setId(rs.getInt("id"));
                    sub.setTaskId(rs.getInt("task_id"));
                    sub.setSubmissionText(rs.getString("submission_text"));
                    sub.setFilePath(rs.getString("file_path"));
                    sub.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    sub.setStatus(rs.getString("status"));
                    sub.setFeedback(rs.getString("feedback"));
                    return sub;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Task extractTaskFromRS(ResultSet rs) throws SQLException {
        Task t = new Task();
        t.setId(rs.getInt("id"));
        t.setApplicationId(rs.getInt("application_id"));
        t.setCompanyId(rs.getInt("company_id"));
        t.setStudentId(rs.getInt("student_id"));
        t.setTitle(rs.getString("title"));
        t.setDescription(rs.getString("description"));
        t.setInstructions(rs.getString("instructions"));
        t.setDeadline(rs.getDate("deadline"));
        t.setAssignedAt(rs.getTimestamp("assigned_at"));
        t.setCompanyName(rs.getString("company_name"));
        t.setStudentName(rs.getString("student_name"));
        t.setJobTitle(rs.getString("job_title"));
        return t;
    }
}
