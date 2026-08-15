package com.hirehub.dao;

import com.hirehub.model.Job;
import com.hirehub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class JobDAO {

    public int createJob(Job job) {
        String sql = "INSERT INTO jobs (company_id, title, description, responsibilities, requirements, required_skills, location, salary_min, salary_max, experience_years, job_type, vacancies, deadline, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, job.getCompanyId());
            ps.setString(2, job.getTitle());
            ps.setString(3, job.getDescription());
            ps.setString(4, job.getResponsibilities());
            ps.setString(5, job.getRequirements());
            ps.setString(6, job.getRequiredSkills());
            ps.setString(7, job.getLocation());
            ps.setDouble(8, job.getSalaryMin());
            ps.setDouble(9, job.getSalaryMax());
            ps.setString(10, job.getExperienceYears());
            ps.setString(11, job.getJobType());
            ps.setInt(12, job.getVacancies());
            ps.setDate(13, job.getDeadline());
            ps.setString(14, job.getStatus() != null ? job.getStatus() : "ACTIVE");

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

    public boolean updateJob(Job job) {
        String sql = "UPDATE jobs SET title = ?, description = ?, responsibilities = ?, requirements = ?, " +
                     "required_skills = ?, location = ?, salary_min = ?, salary_max = ?, experience_years = ?, " +
                     "job_type = ?, vacancies = ?, deadline = ?, status = ? WHERE id = ? AND company_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, job.getTitle());
            ps.setString(2, job.getDescription());
            ps.setString(3, job.getResponsibilities());
            ps.setString(4, job.getRequirements());
            ps.setString(5, job.getRequiredSkills());
            ps.setString(6, job.getLocation());
            ps.setDouble(7, job.getSalaryMin());
            ps.setDouble(8, job.getSalaryMax());
            ps.setString(9, job.getExperienceYears());
            ps.setString(10, job.getJobType());
            ps.setInt(11, job.getVacancies());
            ps.setDate(12, job.getDeadline());
            ps.setString(13, job.getStatus());
            ps.setInt(14, job.getId());
            ps.setInt(15, job.getCompanyId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteJob(int jobId) {
        String sql = "DELETE FROM jobs WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateJobStatus(int jobId, String status) {
        String sql = "UPDATE jobs SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, jobId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Job findById(int jobId) {
        String sql = "SELECT j.*, c.company_name, c.logo_url, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.id) as app_count " +
                     "FROM jobs j JOIN companies c ON j.company_id = c.id WHERE j.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractJobFromRS(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Job> getJobsByCompany(int companyId) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT j.*, c.company_name, c.logo_url, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.id) as app_count " +
                     "FROM jobs j JOIN companies c ON j.company_id = c.id WHERE j.company_id = ? ORDER BY j.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    jobs.add(extractJobFromRS(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobs;
    }

    public List<Job> searchAndFilterJobs(String keyword, String location, Double minSalary, Double maxSalary, String jobType, String sort) {
        List<Job> jobs = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT j.*, c.company_name, c.logo_url, " +
            "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.id) as app_count " +
            "FROM jobs j JOIN companies c ON j.company_id = c.id " +
            "WHERE j.status = 'ACTIVE' AND c.approval_status = 'APPROVED' "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(j.title) LIKE ? OR LOWER(j.required_skills) LIKE ? OR LOWER(c.company_name) LIKE ?) ");
        }
        if (location != null && !location.trim().isEmpty()) {
            sql.append("AND LOWER(j.location) LIKE ? ");
        }
        if (minSalary != null && minSalary > 0) {
            sql.append("AND j.salary_max >= ? ");
        }
        if (maxSalary != null && maxSalary > 0) {
            sql.append("AND j.salary_min <= ? ");
        }
        if (jobType != null && !jobType.trim().isEmpty() && !"ALL".equalsIgnoreCase(jobType)) {
            sql.append("AND j.job_type = ? ");
        }

        if ("SALARY_HIGH".equalsIgnoreCase(sort)) {
            sql.append("ORDER BY j.salary_max DESC");
        } else if ("SALARY_LOW".equalsIgnoreCase(sort)) {
            sql.append("ORDER BY j.salary_min ASC");
        } else {
            sql.append("ORDER BY j.created_at DESC");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String term = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, term);
                ps.setString(idx++, term);
                ps.setString(idx++, term);
            }
            if (location != null && !location.trim().isEmpty()) {
                ps.setString(idx++, "%" + location.trim().toLowerCase() + "%");
            }
            if (minSalary != null && minSalary > 0) {
                ps.setDouble(idx++, minSalary);
            }
            if (maxSalary != null && maxSalary > 0) {
                ps.setDouble(idx++, maxSalary);
            }
            if (jobType != null && !jobType.trim().isEmpty() && !"ALL".equalsIgnoreCase(jobType)) {
                ps.setString(idx++, jobType.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    jobs.add(extractJobFromRS(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobs;
    }

    public List<Job> getRecommendedJobsForStudent(int studentId, List<String> studentSkills) {
        List<Job> allActiveJobs = searchAndFilterJobs(null, null, null, null, null, "NEWEST");
        if (studentSkills == null || studentSkills.isEmpty()) {
            return allActiveJobs;
        }

        for (Job job : allActiveJobs) {
            int matchPercent = calculateMatchPercentage(studentSkills, job.getRequiredSkills());
            job.setMatchPercentage(matchPercent);
        }

        // Sort by match percentage descending
        allActiveJobs.sort((j1, j2) -> Integer.compare(j2.getMatchPercentage(), j1.getMatchPercentage()));
        return allActiveJobs;
    }

    public static int calculateMatchPercentage(List<String> studentSkills, String requiredSkillsStr) {
        if (requiredSkillsStr == null || requiredSkillsStr.trim().isEmpty() || studentSkills == null || studentSkills.isEmpty()) {
            return 0;
        }
        String[] reqArray = requiredSkillsStr.split("[,;/]");
        int totalRequired = 0;
        int matchedCount = 0;

        for (String req : reqArray) {
            String cleanReq = req.trim().toLowerCase();
            if (cleanReq.isEmpty()) continue;
            totalRequired++;

            for (String studentSkill : studentSkills) {
                String cleanStudent = studentSkill.trim().toLowerCase();
                if (cleanStudent.contains(cleanReq) || cleanReq.contains(cleanStudent)) {
                    matchedCount++;
                    break;
                }
            }
        }

        if (totalRequired == 0) return 0;
        int percentage = Math.max(0, Math.min((int) Math.round(((double) matchedCount / totalRequired) * 100), 100));
        return percentage;
    }

    public int getTotalActiveJobsCount() {
        String sql = "SELECT COUNT(*) FROM jobs WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Job> getAllJobsAdmin(String search, String statusFilter) {
        List<Job> jobs = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT j.*, c.company_name, c.logo_url, " +
            "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.id) as app_count " +
            "FROM jobs j JOIN companies c ON j.company_id = c.id WHERE 1=1 "
        );
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(j.title) LIKE ? OR LOWER(c.company_name) LIKE ? OR LOWER(j.location) LIKE ?) ");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append("AND j.status = ? ");
        }
        sql.append("ORDER BY j.created_at DESC");

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
                    jobs.add(extractJobFromRS(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobs;
    }

    private Job extractJobFromRS(ResultSet rs) throws SQLException {
        Job j = new Job();
        j.setId(rs.getInt("id"));
        j.setCompanyId(rs.getInt("company_id"));
        j.setTitle(rs.getString("title"));
        j.setDescription(rs.getString("description"));
        j.setResponsibilities(rs.getString("responsibilities"));
        j.setRequirements(rs.getString("requirements"));
        j.setRequiredSkills(rs.getString("required_skills"));
        j.setLocation(rs.getString("location"));
        j.setSalaryMin(rs.getDouble("salary_min"));
        j.setSalaryMax(rs.getDouble("salary_max"));
        j.setExperienceYears(rs.getString("experience_years"));
        j.setJobType(rs.getString("job_type"));
        j.setVacancies(rs.getInt("vacancies"));
        j.setDeadline(rs.getDate("deadline"));
        j.setStatus(rs.getString("status"));
        j.setCreatedAt(rs.getTimestamp("created_at"));
        j.setCompanyName(rs.getString("company_name"));
        j.setCompanyLogo(rs.getString("logo_url"));
        j.setApplicationCount(rs.getInt("app_count"));
        return j;
    }
}
