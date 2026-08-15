package com.hirehub.dao;

import com.hirehub.model.Application;
import com.hirehub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public int createApplication(Application app) {
        String sql = "INSERT INTO applications (student_id, job_id, company_id, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, app.getStudentId());
            ps.setInt(2, app.getJobId());
            ps.setInt(3, app.getCompanyId());
            ps.setString(4, app.getStatus() != null ? app.getStatus() : "APPLIED");

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

    public boolean hasApplied(int studentId, int jobId) {
        String sql = "SELECT COUNT(*) FROM applications WHERE student_id = ? AND job_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasStudentAppliedToCompany(int studentId, int companyId) {
        String sql = "SELECT COUNT(*) FROM applications WHERE student_id = ? AND company_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int applicationId, String status) {
        String sql = "UPDATE applications SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, applicationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Application findById(int applicationId) {
        String sql = "SELECT a.*, s.full_name as student_name, u.email as student_email, s.phone as student_phone, " +
                     "j.title as job_title, j.location, j.required_skills, c.company_name " +
                     "FROM applications a " +
                     "JOIN students s ON a.student_id = s.id " +
                     "JOIN users u ON s.user_id = u.id " +
                     "JOIN jobs j ON a.job_id = j.id " +
                     "JOIN companies c ON a.company_id = c.id " +
                     "WHERE a.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractAppFromRS(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Application> getApplicationsByStudent(int studentId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, s.full_name as student_name, u.email as student_email, s.phone as student_phone, " +
                     "j.title as job_title, j.location, j.required_skills, c.company_name " +
                     "FROM applications a " +
                     "JOIN students s ON a.student_id = s.id " +
                     "JOIN users u ON s.user_id = u.id " +
                     "JOIN jobs j ON a.job_id = j.id " +
                     "JOIN companies c ON a.company_id = c.id " +
                     "WHERE a.student_id = ? ORDER BY a.applied_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractAppFromRS(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Application> getApplicationsByCompany(int companyId, Integer jobId, String statusFilter) {
        List<Application> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT a.*, s.full_name as student_name, u.email as student_email, s.phone as student_phone, " +
            "j.title as job_title, j.location, j.required_skills, c.company_name " +
            "FROM applications a " +
            "JOIN students s ON a.student_id = s.id " +
            "JOIN users u ON s.user_id = u.id " +
            "JOIN jobs j ON a.job_id = j.id " +
            "JOIN companies c ON a.company_id = c.id " +
            "WHERE a.company_id = ? "
        );

        if (jobId != null && jobId > 0) {
            sql.append("AND a.job_id = ? ");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append("AND a.status = ? ");
        }

        sql.append("ORDER BY a.applied_date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, companyId);
            if (jobId != null && jobId > 0) {
                ps.setInt(idx++, jobId);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
                ps.setString(idx++, statusFilter.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractAppFromRS(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Application> getAllApplicationsAdmin(String search, String statusFilter) {
        List<Application> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT a.*, s.full_name as student_name, u.email as student_email, s.phone as student_phone, " +
            "j.title as job_title, j.location, j.required_skills, c.company_name " +
            "FROM applications a " +
            "JOIN students s ON a.student_id = s.id " +
            "JOIN users u ON s.user_id = u.id " +
            "JOIN jobs j ON a.job_id = j.id " +
            "JOIN companies c ON a.company_id = c.id " +
            "WHERE 1=1 "
        );

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(s.full_name) LIKE ? OR LOWER(j.title) LIKE ? OR LOWER(c.company_name) LIKE ?) ");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append("AND a.status = ? ");
        }

        sql.append("ORDER BY a.applied_date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                String term = "%" + search.trim().toLowerCase() + "%";
                ps.setString(idx++, term);
                ps.setString(idx++, term);
                ps.setString(idx++, term);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
                ps.setString(idx++, statusFilter.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractAppFromRS(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalApplicationsCount() {
        String sql = "SELECT COUNT(*) FROM applications";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getApplicationsCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM applications WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getCompanyApplicationsCountByStatus(int companyId, String status) {
        String sql = "SELECT COUNT(*) FROM applications WHERE company_id = ? AND status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Application extractAppFromRS(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setId(rs.getInt("id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setJobId(rs.getInt("job_id"));
        a.setCompanyId(rs.getInt("company_id"));
        a.setAppliedDate(rs.getTimestamp("applied_date"));
        a.setStatus(rs.getString("status"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));
        a.setStudentName(rs.getString("student_name"));
        a.setStudentEmail(rs.getString("student_email"));
        a.setStudentPhone(rs.getString("student_phone"));
        a.setJobTitle(rs.getString("job_title"));
        a.setCompanyName(rs.getString("company_name"));
        a.setLocation(rs.getString("location"));
        a.setRequiredSkills(rs.getString("required_skills"));
        return a;
    }
}
