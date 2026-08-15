package com.hirehub.controller;

import com.hirehub.dao.StudentDAO;
import com.hirehub.model.Resume;
import com.hirehub.model.Student;
import com.hirehub.model.User;
import com.hirehub.util.FileUploadUtil;
import com.hirehub.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Date;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = {
    "/student/profile",
    "/student/profile-update",
    "/student/skills-update",
    "/student/resume-upload",
    "/student/resume-download"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 5,       // 5MB
    maxRequestSize = 1024 * 1024 * 10    // 10MB
)
public class StudentProfileServlet extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        Student student = studentDAO.findByUserId(user.getId());

        String path = req.getServletPath();

        if ("/student/resume-download".equalsIgnoreCase(path)) {
            handleResumeDownload(req, resp, student);
            return;
        }

        req.setAttribute("student", student);
        req.getRequestDispatcher("/student/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        Student student = studentDAO.findByUserId(user.getId());

        String path = req.getServletPath();

        switch (path) {
            case "/student/profile-update":
                updateProfile(req, resp, student);
                break;
            case "/student/skills-update":
                updateSkills(req, resp, student);
                break;
            case "/student/resume-upload":
                uploadResume(req, resp, student);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/student/profile");
                break;
        }
    }

    private void updateProfile(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws IOException {
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
        
        String gradStr = req.getParameter("graduationYear");
        if (gradStr != null && !gradStr.trim().isEmpty()) {
            try { student.setGraduationYear(Integer.parseInt(gradStr.trim())); } catch (Exception e) {}
        }

        String cgpaStr = req.getParameter("cgpa");
        if (cgpaStr != null && !cgpaStr.trim().isEmpty()) {
            try { student.setCgpa(Double.parseDouble(cgpaStr.trim())); } catch (Exception e) {}
        }

        student.setBio(ValidationUtil.sanitize(req.getParameter("bio")));

        studentDAO.updateStudentProfile(student);
        resp.sendRedirect(req.getContextPath() + "/student/profile?success=Profile+updated+successfully.");
    }

    private void updateSkills(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws IOException {
        String skillsInput = req.getParameter("skills");
        if (skillsInput != null) {
            List<String> skills = Arrays.stream(skillsInput.split("[,;]"))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .collect(Collectors.toList());
            studentDAO.updateSkills(student.getId(), skills);
        }
        resp.sendRedirect(req.getContextPath() + "/student/profile?success=Skills+updated+successfully.");
    }

    private void uploadResume(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws ServletException, IOException {
        Part filePart = req.getPart("resumeFile");

        if (!FileUploadUtil.isValidResume(filePart)) {
            resp.sendRedirect(req.getContextPath() + "/student/profile?error=Invalid+file.+Allowed+formats:+PDF,+DOC,+DOCX+(Max+5MB).");
            return;
        }

        String uploadPath = req.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "resumes";
        String savedFileName = FileUploadUtil.saveFile(filePart, uploadPath);

        Resume resume = new Resume();
        resume.setStudentId(student.getId());
        resume.setFileName(FileUploadUtil.getFileName(filePart));
        resume.setFilePath("uploads/resumes/" + savedFileName);
        resume.setFileType(filePart.getContentType());

        studentDAO.saveOrUpdateResume(resume);

        resp.sendRedirect(req.getContextPath() + "/student/profile?success=Resume+uploaded+successfully.");
    }

    private void handleResumeDownload(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws IOException {
        Resume resume = studentDAO.getResume(student.getId());
        if (resume == null || resume.getFilePath() == null) {
            resp.sendRedirect(req.getContextPath() + "/student/profile?error=No+resume+uploaded.");
            return;
        }

        String fullPath = req.getServletContext().getRealPath("") + File.separator + resume.getFilePath();
        File downloadFile = new File(fullPath);

        if (!downloadFile.exists()) {
            resp.sendRedirect(req.getContextPath() + "/student/profile?error=Resume+file+not+found.");
            return;
        }

        resp.setContentType(resume.getFileType() != null ? resume.getFileType() : "application/octet-stream");
        resp.setContentLength((int) downloadFile.length());
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + resume.getFileName() + "\"");

        try (FileInputStream inStream = new FileInputStream(downloadFile);
             OutputStream outStream = resp.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
        }
    }
}
