package com.hirehub.controller;

import com.hirehub.dao.*;
import com.hirehub.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {
    "/admin/company-action",
    "/admin/user-action",
    "/admin/job-action"
})
public class AdminActionServlet extends HttpServlet {

    private CompanyDAO companyDAO;
    private UserDAO userDAO;
    private JobDAO jobDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        companyDAO = new CompanyDAO();
        userDAO = new UserDAO();
        jobDAO = new JobDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        switch (path) {
            case "/admin/company-action":
                handleCompanyAction(req, resp);
                break;
            case "/admin/user-action":
                handleUserAction(req, resp);
                break;
            case "/admin/job-action":
                handleJobAction(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                break;
        }
    }

    private void handleCompanyAction(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int companyId = Integer.parseInt(req.getParameter("companyId"));
            String action = req.getParameter("action"); // APPROVE, REJECT, BLOCK, UNBLOCK, DELETE

            Company company = companyDAO.findById(companyId);
            if (company == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/companies");
                return;
            }

            if ("APPROVE".equalsIgnoreCase(action)) {
                companyDAO.updateApprovalStatus(companyId, "APPROVED");
                userDAO.updateStatus(company.getUserId(), "ACTIVE");
                notificationDAO.createNotification(new Notification(company.getUserId(), "Company Approved", "Your company account has been approved by Admin. You can now post jobs!", "SUCCESS"));
            } else if ("REJECT".equalsIgnoreCase(action)) {
                companyDAO.updateApprovalStatus(companyId, "REJECTED");
                notificationDAO.createNotification(new Notification(company.getUserId(), "Company Registration Rejected", "Your company account registration was rejected by Admin.", "DANGER"));
            } else if ("BLOCK".equalsIgnoreCase(action)) {
                companyDAO.updateApprovalStatus(companyId, "BLOCKED");
                userDAO.updateStatus(company.getUserId(), "BLOCKED");
            } else if ("UNBLOCK".equalsIgnoreCase(action)) {
                companyDAO.updateApprovalStatus(companyId, "APPROVED");
                userDAO.updateStatus(company.getUserId(), "ACTIVE");
            } else if ("DELETE".equalsIgnoreCase(action)) {
                userDAO.deleteUser(company.getUserId());
            }
        } catch (Exception e) {}

        resp.sendRedirect(req.getContextPath() + "/admin/companies?success=Action+completed+successfully.");
    }

    private void handleUserAction(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int userId = Integer.parseInt(req.getParameter("userId"));
            String action = req.getParameter("action"); // BLOCK, UNBLOCK, DELETE

            User user = userDAO.findById(userId);
            if (user == null || "ADMIN".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/students");
                return;
            }

            if ("BLOCK".equalsIgnoreCase(action)) {
                userDAO.updateStatus(userId, "BLOCKED");
            } else if ("UNBLOCK".equalsIgnoreCase(action)) {
                userDAO.updateStatus(userId, "ACTIVE");
            } else if ("DELETE".equalsIgnoreCase(action)) {
                userDAO.deleteUser(userId);
            }
        } catch (Exception e) {}

        resp.sendRedirect(req.getContextPath() + "/admin/students?success=User+action+completed.");
    }

    private void handleJobAction(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int jobId = Integer.parseInt(req.getParameter("jobId"));
            String action = req.getParameter("action"); // ACTIVATE, DEACTIVATE, DELETE

            if ("ACTIVATE".equalsIgnoreCase(action)) {
                jobDAO.updateJobStatus(jobId, "ACTIVE");
            } else if ("DEACTIVATE".equalsIgnoreCase(action)) {
                jobDAO.updateJobStatus(jobId, "INACTIVE");
            } else if ("DELETE".equalsIgnoreCase(action)) {
                jobDAO.deleteJob(jobId);
            }
        } catch (Exception e) {}

        resp.sendRedirect(req.getContextPath() + "/admin/jobs?success=Job+action+completed.");
    }
}
