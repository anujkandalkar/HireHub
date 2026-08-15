package com.hirehub.controller;

import com.hirehub.dao.CompanyDAO;
import com.hirehub.dao.StudentDAO;
import com.hirehub.dao.UserDAO;
import com.hirehub.model.Company;
import com.hirehub.model.Resume;
import com.hirehub.model.Student;
import com.hirehub.model.User;
import com.hirehub.util.FileUploadUtil;
import com.hirehub.util.PasswordUtil;
import com.hirehub.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/register")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 5,       // 5MB
    maxRequestSize = 1024 * 1024 * 10    // 10MB
)
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;
    private StudentDAO studentDAO;
    private CompanyDAO companyDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        studentDAO = new StudentDAO();
        companyDAO = new CompanyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String role = ValidationUtil.sanitize(req.getParameter("role")).toUpperCase();
        String email = ValidationUtil.sanitize(req.getParameter("email"));
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Security check: Admin registration is forbidden
        if ("ADMIN".equalsIgnoreCase(role)) {
            req.setAttribute("errorMessage", "Admin registration is not allowed.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!"STUDENT".equals(role) && !"COMPANY".equals(role)) {
            req.setAttribute("errorMessage", "Invalid account type selected.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("errorMessage", "Please provide a valid email address.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!ValidationUtil.isValidPassword(password)) {
            req.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (password == null || !password.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "Passwords do not match.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.emailExists(email)) {
            req.setAttribute("errorMessage", "An account with this email already exists.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // Validate Resume file upfront if Student
        Part resumePart = null;
        if ("STUDENT".equals(role)) {
            try {
                resumePart = req.getPart("resumeFile");
                if (resumePart == null || resumePart.getSize() == 0) {
                    resumePart = req.getPart("resume");
                }
            } catch (Exception e) {
                resumePart = null;
            }

            if (resumePart == null || resumePart.getSize() == 0) {
                req.setAttribute("errorMessage", "Resume file is required for student registration.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            if (!FileUploadUtil.isValidResume(resumePart)) {
                req.setAttribute("errorMessage", "Invalid resume file. Only PDF, DOC, and DOCX files up to 5 MB are allowed.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }
        }

        String salt = PasswordUtil.generateSalt();
        String passwordHash = PasswordUtil.hashPassword(password, salt);

        User user = new User();
        user.setEmail(email);
        user.setPasswordHash(passwordHash);
        user.setSalt(salt);
        user.setRole(role);
        user.setStatus("ACTIVE");

        int userId = userDAO.createUser(user);

        if (userId <= 0) {
            req.setAttribute("errorMessage", "Registration failed. Please try again later.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        user.setId(userId);

        if ("STUDENT".equals(role)) {
            Student student = new Student();
            student.setUserId(userId);
            student.setFullName(ValidationUtil.sanitize(req.getParameter("fullName")));
            student.setPhone(ValidationUtil.sanitize(req.getParameter("phone")));
            student.setGender(ValidationUtil.sanitize(req.getParameter("gender")));
            
            String dobStr = req.getParameter("dob");
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try { student.setDob(Date.valueOf(dobStr.trim())); } catch (Exception e) {}
            }
            
            student.setCity(ValidationUtil.sanitize(req.getParameter("city")));
            student.setState(ValidationUtil.sanitize(req.getParameter("state")));
            student.setEducationLevel(ValidationUtil.sanitize(req.getParameter("educationLevel")));
            student.setCollegeName(ValidationUtil.sanitize(req.getParameter("collegeName")));
            
            String gradYearStr = req.getParameter("graduationYear");
            if (gradYearStr != null && !gradYearStr.trim().isEmpty()) {
                try { student.setGraduationYear(Integer.parseInt(gradYearStr.trim())); } catch (Exception e) {}
            }

            String skillsStr = req.getParameter("skills");
            if (skillsStr != null && !skillsStr.trim().isEmpty()) {
                List<String> skillsList = Arrays.stream(skillsStr.split("[,;]"))
                        .map(String::trim)
                        .filter(s -> !s.isEmpty())
                        .collect(Collectors.toList());
                student.setSkills(skillsList);
            }

            int studentId = studentDAO.createStudent(student);

            if (studentId <= 0) {
                userDAO.deleteUser(userId);
                req.setAttribute("errorMessage", "Student profile creation failed. Registration aborted.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            // Save Resume File & Record
            try {
                String uploadPath = req.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "resumes";
                String savedFileName = FileUploadUtil.saveFile(resumePart, uploadPath);

                Resume resume = new Resume();
                resume.setStudentId(studentId);
                resume.setFileName(FileUploadUtil.getFileName(resumePart));
                resume.setFilePath("uploads/resumes/" + savedFileName);
                resume.setFileType(resumePart.getContentType());

                boolean saved = studentDAO.saveOrUpdateResume(resume);
                if (!saved) {
                    userDAO.deleteUser(userId);
                    req.setAttribute("errorMessage", "Resume record creation failed. Registration aborted.");
                    req.getRequestDispatcher("/register.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception e) {
                userDAO.deleteUser(userId);
                req.setAttribute("errorMessage", "Failed to upload resume file: " + e.getMessage());
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/login.jsp?success=Registration+successful.+Please+login+to+continue.");
        } else if ("COMPANY".equals(role)) {
            Company company = new Company();
            company.setUserId(userId);
            company.setCompanyName(ValidationUtil.sanitize(req.getParameter("companyName")));
            company.setPhone(ValidationUtil.sanitize(req.getParameter("companyPhone")));
            company.setWebsite(ValidationUtil.sanitize(req.getParameter("website")));
            company.setIndustry(ValidationUtil.sanitize(req.getParameter("industry")));
            company.setCompanySize(ValidationUtil.sanitize(req.getParameter("companySize")));
            company.setLocation(ValidationUtil.sanitize(req.getParameter("companyLocation")));
            company.setDescription(ValidationUtil.sanitize(req.getParameter("description")));
            company.setApprovalStatus("PENDING");

            int companyId = companyDAO.createCompany(company);
            if (companyId <= 0) {
                userDAO.deleteUser(userId);
                req.setAttribute("errorMessage", "Company profile creation failed. Registration aborted.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/login.jsp?success=Company+registration+successful.+Account+is+pending+Admin+approval.");
        }
    }
}
