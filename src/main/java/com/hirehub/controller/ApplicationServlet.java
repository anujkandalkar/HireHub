package com.hirehub.controller;

import com.hirehub.dao.*;
import com.hirehub.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {
    "/apply-job",
    "/withdraw-application",
    "/update-application-status"
})
public class ApplicationServlet extends HttpServlet {

    private ApplicationDAO applicationDAO;
    private StudentDAO studentDAO;
    private CompanyDAO companyDAO;
    private JobDAO jobDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        applicationDAO = new ApplicationDAO();
        studentDAO = new StudentDAO();
        companyDAO = new CompanyDAO();
        jobDAO = new JobDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please+login+to+apply+or+manage+applications.");
            return;
        }

        String path = req.getServletPath();

        switch (path) {
            case "/apply-job":
                handleApply(req, resp, user);
                break;
            case "/withdraw-application":
                handleWithdraw(req, resp, user);
                break;
            case "/update-application-status":
                handleStatusUpdate(req, resp, user);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/jobs");
                break;
        }
    }

    private void handleApply(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        if (!"STUDENT".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/jobs?error=Only+students+can+apply+for+jobs.");
            return;
        }

        Student student = studentDAO.findByUserId(user.getId());
        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/jobs?error=Student+profile+not+found.");
            return;
        }

        try {
            int jobId = Integer.parseInt(req.getParameter("jobId"));
            Job job = jobDAO.findById(jobId);

            if (job == null || !"ACTIVE".equalsIgnoreCase(job.getStatus())) {
                resp.sendRedirect(req.getContextPath() + "/jobs?error=Job+is+no+longer+accepting+applications.");
                return;
            }

            if (applicationDAO.hasApplied(student.getId(), jobId)) {
                resp.sendRedirect(req.getContextPath() + "/job-details?id=" + jobId + "&error=You+have+already+applied+for+this+job.");
                return;
            }

            Application app = new Application();
            app.setStudentId(student.getId());
            app.setJobId(jobId);
            app.setCompanyId(job.getCompanyId());
            app.setStatus("APPLIED");

            int appId = applicationDAO.createApplication(app);

            if (appId > 0) {
                // Notify company user
                Company company = companyDAO.findById(job.getCompanyId());
                if (company != null) {
                    Notification notif = new Notification(
                        company.getUserId(),
                        "New Application Received",
                        student.getFullName() + " applied for " + job.getTitle(),
                        "INFO"
                    );
                    notificationDAO.createNotification(notif);
                }

                resp.sendRedirect(req.getContextPath() + "/student/applications?success=Application+submitted+successfully.");
            } else {
                resp.sendRedirect(req.getContextPath() + "/job-details?id=" + jobId + "&error=Failed+to+submit+application.");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/jobs?error=Invalid+job+request.");
        }
    }

    private void handleWithdraw(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        if (!"STUDENT".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/student/applications");
            return;
        }

        Student student = studentDAO.findByUserId(user.getId());
        try {
            int appId = Integer.parseInt(req.getParameter("applicationId"));
            Application app = applicationDAO.findById(appId);

            if (app != null && app.getStudentId() == student.getId()) {
                applicationDAO.updateStatus(appId, "WITHDRAWN");
            }
        } catch (Exception e) {}
        resp.sendRedirect(req.getContextPath() + "/student/applications?success=Application+withdrawn.");
    }

    private void handleStatusUpdate(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        try {
            int appId = Integer.parseInt(req.getParameter("applicationId"));
            String status = req.getParameter("status");

            Application app = applicationDAO.findById(appId);
            if (app == null) {
                resp.sendRedirect(req.getContextPath() + "/company/applications");
                return;
            }

            applicationDAO.updateStatus(appId, status);

            // Notify candidate
            Student student = studentDAO.findById(app.getStudentId());
            if (student != null) {
                Notification notif = new Notification(
                    student.getUserId(),
                    "Application Status Updated",
                    "Your application for " + app.getJobTitle() + " status is now " + status.replace('_', ' '),
                    "SHORTLISTED".equalsIgnoreCase(status) || "SELECTED".equalsIgnoreCase(status) ? "SUCCESS" : "INFO"
                );
                notificationDAO.createNotification(notif);
            }

            resp.sendRedirect(req.getContextPath() + "/company/applications?success=Application+status+updated+to+" + status);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/company/applications?error=Failed+to+update+status.");
        }
    }
}
