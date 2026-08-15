package com.hirehub.dao;

import com.hirehub.model.Company;
import com.hirehub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAO {

    public int createCompany(Company company) {
        String sql = "INSERT INTO companies (user_id, company_name, phone, website, industry, company_size, location, description, logo_url, approval_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, company.getUserId());
            ps.setString(2, company.getCompanyName());
            ps.setString(3, company.getPhone());
            ps.setString(4, company.getWebsite());
            ps.setString(5, company.getIndustry());
            ps.setString(6, company.getCompanySize());
            ps.setString(7, company.getLocation());
            ps.setString(8, company.getDescription());
            ps.setString(9, company.getLogoUrl());
            ps.setString(10, company.getApprovalStatus() != null ? company.getApprovalStatus() : "PENDING");

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

    public Company findByUserId(int userId) {
        String sql = "SELECT c.*, u.email FROM companies c JOIN users u ON c.user_id = u.id WHERE c.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCompanyFromRS(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Company findById(int companyId) {
        String sql = "SELECT c.*, u.email FROM companies c JOIN users u ON c.user_id = u.id WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCompanyFromRS(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCompanyProfile(Company company) {
        String sql = "UPDATE companies SET company_name = ?, phone = ?, website = ?, industry = ?, " +
                     "company_size = ?, location = ?, description = ?, logo_url = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, company.getCompanyName());
            ps.setString(2, company.getPhone());
            ps.setString(3, company.getWebsite());
            ps.setString(4, company.getIndustry());
            ps.setString(5, company.getCompanySize());
            ps.setString(6, company.getLocation());
            ps.setString(7, company.getDescription());
            ps.setString(8, company.getLogoUrl());
            ps.setInt(9, company.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateApprovalStatus(int companyId, String status) {
        String sql = "UPDATE companies SET approval_status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, companyId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Company> getAllCompanies(String search, String statusFilter) {
        List<Company> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT c.*, u.email FROM companies c JOIN users u ON c.user_id = u.id WHERE 1=1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(c.company_name) LIKE ? OR LOWER(u.email) LIKE ? OR LOWER(c.industry) LIKE ? OR LOWER(c.location) LIKE ?) ");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append("AND c.approval_status = ? ");
        }

        sql.append("ORDER BY c.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String term = "%" + search.trim().toLowerCase() + "%";
                ps.setString(paramIndex++, term);
                ps.setString(paramIndex++, term);
                ps.setString(paramIndex++, term);
                ps.setString(paramIndex++, term);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
                ps.setString(paramIndex++, statusFilter.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractCompanyFromRS(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCompaniesCount() {
        String sql = "SELECT COUNT(*) FROM companies";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getPendingCompaniesCount() {
        String sql = "SELECT COUNT(*) FROM companies WHERE approval_status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Company extractCompanyFromRS(ResultSet rs) throws SQLException {
        Company c = new Company();
        c.setId(rs.getInt("id"));
        c.setUserId(rs.getInt("user_id"));
        c.setCompanyName(rs.getString("company_name"));
        c.setPhone(rs.getString("phone"));
        c.setWebsite(rs.getString("website"));
        c.setIndustry(rs.getString("industry"));
        c.setCompanySize(rs.getString("company_size"));
        c.setLocation(rs.getString("location"));
        c.setDescription(rs.getString("description"));
        c.setLogoUrl(rs.getString("logo_url"));
        c.setApprovalStatus(rs.getString("approval_status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setEmail(rs.getString("email"));
        return c;
    }
}
