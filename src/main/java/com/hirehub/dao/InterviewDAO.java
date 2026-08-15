package com.hirehub.dao;

import com.hirehub.model.Interview;
import com.hirehub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InterviewDAO {

    public int scheduleInterview(Interview interview) {
        String sql = "INSERT INTO interviews (application_id, company_id, student_id, interview_date, interview_time, interview_type, meeting_link, interviewer_name, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, interview.getApplicationId());
            ps.setInt(2, interview.getCompanyId());
            ps.setInt(3, interview.getStudentId());
            ps.setDate(4, interview.getInterviewDate());
            ps.setTime(5, interview.getInterviewTime());
            ps.setString(6, interview.getInterviewType());
            ps.setString(7, interview.getMeetingLink());
            ps.setString(8, interview.getInterviewerName());
            ps.setString(9, interview.getNotes());

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

    public List<Interview> getInterviewsByStudent(int studentId) {
        List<Interview> list = new ArrayList<>();
        String sql = "SELECT i.*, c.company_name, s.full_name as student_name, j.title as job_title " +
                     "FROM interviews i " +
                     "JOIN companies c ON i.company_id = c.id " +
                     "JOIN students s ON i.student_id = s.id " +
                     "JOIN applications a ON i.application_id = a.id " +
                     "JOIN jobs j ON a.job_id = j.id " +
                     "WHERE i.student_id = ? ORDER BY i.interview_date ASC, i.interview_time ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractInterviewFromRS(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Interview> getInterviewsByCompany(int companyId) {
        List<Interview> list = new ArrayList<>();
        String sql = "SELECT i.*, c.company_name, s.full_name as student_name, j.title as job_title " +
                     "FROM interviews i " +
                     "JOIN companies c ON i.company_id = c.id " +
                     "JOIN students s ON i.student_id = s.id " +
                     "JOIN applications a ON i.application_id = a.id " +
                     "JOIN jobs j ON a.job_id = j.id " +
                     "WHERE i.company_id = ? ORDER BY i.interview_date ASC, i.interview_time ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractInterviewFromRS(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Interview extractInterviewFromRS(ResultSet rs) throws SQLException {
        Interview i = new Interview();
        i.setId(rs.getInt("id"));
        i.setApplicationId(rs.getInt("application_id"));
        i.setCompanyId(rs.getInt("company_id"));
        i.setStudentId(rs.getInt("student_id"));
        i.setInterviewDate(rs.getDate("interview_date"));
        i.setInterviewTime(rs.getTime("interview_time"));
        i.setInterviewType(rs.getString("interview_type"));
        i.setMeetingLink(rs.getString("meeting_link"));
        i.setInterviewerName(rs.getString("interviewer_name"));
        i.setNotes(rs.getString("notes"));
        i.setCreatedAt(rs.getTimestamp("created_at"));
        i.setCompanyName(rs.getString("company_name"));
        i.setStudentName(rs.getString("student_name"));
        i.setJobTitle(rs.getString("job_title"));
        return i;
    }
}
