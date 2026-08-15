package com.hirehub.controller;

import com.hirehub.dao.ApplicationDAO;
import com.hirehub.dao.CompanyDAO;
import com.hirehub.dao.StudentDAO;
import com.hirehub.model.Company;
import com.hirehub.model.Resume;
import com.hirehub.model.Student;
import com.hirehub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet(urlPatterns = {
    "/resume/view",
    "/resume/download"
})
public class ResumeServlet extends HttpServlet {

    private StudentDAO studentDAO;
    private CompanyDAO companyDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
        companyDAO = new CompanyDAO();
        applicationDAO = new ApplicationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please+login+to+access+resumes.");
            return;
        }

        User user = (User) session.getAttribute("user");
        String studentIdParam = req.getParameter("studentId");
        
        Student targetStudent = null;

        if (studentIdParam != null && !studentIdParam.trim().isEmpty()) {
            try {
                int studentId = Integer.parseInt(studentIdParam.trim());
                targetStudent = studentDAO.findById(studentId);
            } catch (NumberFormatException e) {
                targetStudent = null;
            }
        } else if ("STUDENT".equals(user.getRole())) {
            targetStudent = studentDAO.findByUserId(user.getId());
        }

        if (targetStudent == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Student profile or resume not found.");
            return;
        }

        // Authorization Check
        boolean isAuthorized = false;

        if ("ADMIN".equals(user.getRole())) {
            isAuthorized = true;
        } else if ("STUDENT".equals(user.getRole())) {
            Student loggedInStudent = studentDAO.findByUserId(user.getId());
            if (loggedInStudent != null && loggedInStudent.getId() == targetStudent.getId()) {
                isAuthorized = true;
            }
        } else if ("COMPANY".equals(user.getRole())) {
            Company company = companyDAO.findByUserId(user.getId());
            if (company != null && applicationDAO.hasStudentAppliedToCompany(targetStudent.getId(), company.getId())) {
                isAuthorized = true;
            }
        }

        if (!isAuthorized) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You are not authorized to view this resume.");
            return;
        }

        Resume resume = studentDAO.getResume(targetStudent.getId());
        if (resume == null || resume.getFilePath() == null || resume.getFilePath().trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/error.jsp?message=No+resume+uploaded+for+this+student.");
            return;
        }

        File file = new File(req.getServletContext().getRealPath("") + File.separator + resume.getFilePath());
        if (!file.exists()) {
            file = new File(resume.getFilePath());
        }

        if (!file.exists()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Resume file was not found on server.");
            return;
        }

        String fileName = resume.getFileName();
        if (fileName == null || fileName.trim().isEmpty()) {
            fileName = file.getName();
        }

        String path = req.getServletPath();
        boolean isDownload = "/resume/download".equalsIgnoreCase(path);

        String contentType = resume.getFileType();
        if (contentType == null || contentType.trim().isEmpty() || "application/octet-stream".equals(contentType)) {
            String lowerName = fileName.toLowerCase();
            if (lowerName.endsWith(".pdf")) {
                contentType = "application/pdf";
            } else if (lowerName.endsWith(".doc")) {
                contentType = "application/msword";
            } else if (lowerName.endsWith(".docx")) {
                contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            } else {
                contentType = "application/octet-stream";
            }
        }

        resp.setContentType(contentType);
        resp.setContentLength((int) file.length());

        if (isDownload) {
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        } else {
            resp.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
        }

        try (FileInputStream inStream = new FileInputStream(file);
             OutputStream outStream = resp.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
            outStream.flush();
        }
    }
}
