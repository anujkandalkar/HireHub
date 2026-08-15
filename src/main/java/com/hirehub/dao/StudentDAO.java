package com.hirehub.dao;

import com.hirehub.model.*;
import com.hirehub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public int createStudent(Student student) {
        String sql = "INSERT INTO students (user_id, full_name, phone, gender, dob, city, state, education_level, college_name, graduation_year, cgpa, bio) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, student.getUserId());
            ps.setString(2, student.getFullName());
            ps.setString(3, student.getPhone());
            ps.setString(4, student.getGender());
            ps.setDate(5, student.getDob());
            ps.setString(6, student.getCity());
            ps.setString(7, student.getState());
            ps.setString(8, student.getEducationLevel());
            ps.setString(9, student.getCollegeName());
            ps.setInt(10, student.getGraduationYear());
            ps.setDouble(11, student.getCgpa());
            ps.setString(12, student.getBio());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int studentId = rs.getInt(1);
                        if (student.getSkills() != null && !student.getSkills().isEmpty()) {
                            updateSkills(studentId, student.getSkills());
                        }
                        return studentId;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public Student findByUserId(int userId) {
        String sql = "SELECT s.*, u.email FROM students s JOIN users u ON s.user_id = u.id WHERE s.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student student = extractStudentFromRS(rs);
                    loadStudentDetails(student);
                    return student;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Student findById(int studentId) {
        String sql = "SELECT s.*, u.email FROM students s JOIN users u ON s.user_id = u.id WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student student = extractStudentFromRS(rs);
                    loadStudentDetails(student);
                    return student;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStudentProfile(Student student) {
        String sql = "UPDATE students SET full_name = ?, phone = ?, gender = ?, dob = ?, city = ?, state = ?, " +
                     "education_level = ?, college_name = ?, graduation_year = ?, cgpa = ?, bio = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, student.getFullName());
            ps.setString(2, student.getPhone());
            ps.setString(3, student.getGender());
            ps.setDate(4, student.getDob());
            ps.setString(5, student.getCity());
            ps.setString(6, student.getState());
            ps.setString(7, student.getEducationLevel());
            ps.setString(8, student.getCollegeName());
            ps.setInt(9, student.getGraduationYear());
            ps.setDouble(10, student.getCgpa());
            ps.setString(11, student.getBio());
            ps.setInt(12, student.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void updateSkills(int studentId, List<String> skills) {
        String deleteSql = "DELETE FROM student_skills WHERE student_id = ?";
        String insertSql = "INSERT INTO student_skills (student_id, skill_name) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement delPs = conn.prepareStatement(deleteSql)) {
                delPs.setInt(1, studentId);
                delPs.executeUpdate();
            }
            try (PreparedStatement insPs = conn.prepareStatement(insertSql)) {
                for (String skill : skills) {
                    if (skill != null && !skill.trim().isEmpty()) {
                        insPs.setInt(1, studentId);
                        insPs.setString(2, skill.trim());
                        insPs.addBatch();
                    }
                }
                insPs.executeBatch();
            }
            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<String> getSkills(int studentId) {
        List<String> skills = new ArrayList<>();
        String sql = "SELECT skill_name FROM student_skills WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    skills.add(rs.getString("skill_name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return skills;
    }

    public boolean saveOrUpdateResume(Resume resume) {
        String checkSql = "SELECT id FROM resumes WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, resume.getStudentId());
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    String updateSql = "UPDATE resumes SET file_name = ?, file_path = ?, file_type = ?, uploaded_at = CURRENT_TIMESTAMP WHERE student_id = ?";
                    try (PreparedStatement upPs = conn.prepareStatement(updateSql)) {
                        upPs.setString(1, resume.getFileName());
                        upPs.setString(2, resume.getFilePath());
                        upPs.setString(3, resume.getFileType());
                        upPs.setInt(4, resume.getStudentId());
                        return upPs.executeUpdate() > 0;
                    }
                } else {
                    String insertSql = "INSERT INTO resumes (student_id, file_name, file_path, file_type) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement inPs = conn.prepareStatement(insertSql)) {
                        inPs.setInt(1, resume.getStudentId());
                        inPs.setString(2, resume.getFileName());
                        inPs.setString(3, resume.getFilePath());
                        inPs.setString(4, resume.getFileType());
                        return inPs.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Resume getResume(int studentId) {
        String sql = "SELECT * FROM resumes WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Resume resume = new Resume();
                    resume.setId(rs.getInt("id"));
                    resume.setStudentId(rs.getInt("student_id"));
                    resume.setFileName(rs.getString("file_name"));
                    resume.setFilePath(rs.getString("file_path"));
                    resume.setFileType(rs.getString("file_type"));
                    resume.setUploadedAt(rs.getTimestamp("uploaded_at"));
                    return resume;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Student> getAllStudents(String search, String skillFilter) {
        List<Student> students = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT DISTINCT s.*, u.email FROM students s JOIN users u ON s.user_id = u.id ");
        if (skillFilter != null && !skillFilter.trim().isEmpty()) {
            sql.append("JOIN student_skills sk ON s.id = sk.student_id ");
        }
        sql.append("WHERE 1=1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(s.full_name) LIKE ? OR LOWER(u.email) LIKE ? OR LOWER(s.college_name) LIKE ?) ");
        }
        if (skillFilter != null && !skillFilter.trim().isEmpty()) {
            sql.append("AND LOWER(sk.skill_name) = LOWER(?) ");
        }

        sql.append("ORDER BY s.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String term = "%" + search.trim().toLowerCase() + "%";
                ps.setString(paramIndex++, term);
                ps.setString(paramIndex++, term);
                ps.setString(paramIndex++, term);
            }
            if (skillFilter != null && !skillFilter.trim().isEmpty()) {
                ps.setString(paramIndex++, skillFilter.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student student = extractStudentFromRS(rs);
                    loadStudentDetails(student);
                    students.add(student);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public int getTotalStudentsCount() {
        String sql = "SELECT COUNT(*) FROM students";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void loadStudentDetails(Student student) {
        student.setSkills(getSkills(student.getId()));
        student.setResume(getResume(student.getId()));
        student.setEducations(getEducations(student.getId()));
        student.setExperiences(getExperiences(student.getId()));
        student.setProjects(getProjects(student.getId()));
    }

    public List<Education> getEducations(int studentId) {
        List<Education> list = new ArrayList<>();
        String sql = "SELECT * FROM educations WHERE student_id = ? ORDER BY end_year DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Education ed = new Education();
                    ed.setId(rs.getInt("id"));
                    ed.setStudentId(rs.getInt("student_id"));
                    ed.setDegree(rs.getString("degree"));
                    ed.setInstitution(rs.getString("institution"));
                    ed.setFieldOfStudy(rs.getString("field_of_study"));
                    ed.setStartYear(rs.getInt("start_year"));
                    ed.setEndYear(rs.getInt("end_year"));
                    ed.setScore(rs.getString("score"));
                    list.add(ed);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Experience> getExperiences(int studentId) {
        List<Experience> list = new ArrayList<>();
        String sql = "SELECT * FROM experiences WHERE student_id = ? ORDER BY start_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Experience exp = new Experience();
                    exp.setId(rs.getInt("id"));
                    exp.setStudentId(rs.getInt("student_id"));
                    exp.setCompanyName(rs.getString("company_name"));
                    exp.setRoleTitle(rs.getString("role_title"));
                    exp.setStartDate(rs.getDate("start_date"));
                    exp.setEndDate(rs.getDate("end_date"));
                    exp.setDescription(rs.getString("description"));
                    list.add(exp);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Project> getProjects(int studentId) {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT * FROM projects WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Project p = new Project();
                    p.setId(rs.getInt("id"));
                    p.setStudentId(rs.getInt("student_id"));
                    p.setTitle(rs.getString("title"));
                    p.setDescription(rs.getString("description"));
                    p.setTechnologies(rs.getString("technologies"));
                    p.setGithubUrl(rs.getString("github_url"));
                    list.add(p);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Student extractStudentFromRS(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setUserId(rs.getInt("user_id"));
        s.setFullName(rs.getString("full_name"));
        s.setPhone(rs.getString("phone"));
        s.setGender(rs.getString("gender"));
        s.setDob(rs.getDate("dob"));
        s.setCity(rs.getString("city"));
        s.setState(rs.getString("state"));
        s.setEducationLevel(rs.getString("education_level"));
        s.setCollegeName(rs.getString("college_name"));
        s.setGraduationYear(rs.getInt("graduation_year"));
        s.setCgpa(rs.getDouble("cgpa"));
        s.setBio(rs.getString("bio"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        s.setEmail(rs.getString("email"));
        return s;
    }
}
