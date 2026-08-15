package com.hirehub.controller;

import com.hirehub.dao.*;
import com.hirehub.model.*;
import com.hirehub.util.FileUploadUtil;
import com.hirehub.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Date;

@WebServlet(urlPatterns = {
    "/assign-task",
    "/submit-task",
    "/review-task"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class TaskServlet extends HttpServlet {

    private TaskDAO taskDAO;
    private ApplicationDAO applicationDAO;
    private StudentDAO studentDAO;
    private CompanyDAO companyDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
        applicationDAO = new ApplicationDAO();
        studentDAO = new StudentDAO();
        companyDAO = new CompanyDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String path = req.getServletPath();

        switch (path) {
            case "/assign-task":
                handleAssignTask(req, resp, user);
                break;
            case "/submit-task":
                handleSubmitTask(req, resp, user);
                break;
            case "/review-task":
                handleReviewTask(req, resp, user);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
                break;
        }
    }

    private void handleAssignTask(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        Company company = companyDAO.findByUserId(user.getId());
        try {
            int appId = Integer.parseInt(req.getParameter("applicationId"));
            String title = ValidationUtil.sanitize(req.getParameter("title"));
            String description = ValidationUtil.sanitize(req.getParameter("description"));
            String instructions = ValidationUtil.sanitize(req.getParameter("instructions"));
            String dlStr = req.getParameter("deadline");

            Application app = applicationDAO.findById(appId);
            if (app == null || app.getCompanyId() != company.getId()) {
                resp.sendRedirect(req.getContextPath() + "/company/applications?error=Invalid+application.");
                return;
            }

            Task task = new Task();
            task.setApplicationId(appId);
            task.setCompanyId(company.getId());
            task.setStudentId(app.getStudentId());
            task.setTitle(title);
            task.setDescription(description);
            task.setInstructions(instructions);
            if (dlStr != null && !dlStr.trim().isEmpty()) {
                task.setDeadline(Date.valueOf(dlStr.trim()));
            }

            int taskId = taskDAO.createTask(task);
            if (taskId > 0) {
                applicationDAO.updateStatus(appId, "TASK_ASSIGNED");

                Student student = studentDAO.findById(app.getStudentId());
                if (student != null) {
                    Notification notif = new Notification(
                        student.getUserId(),
                        "Technical Task Assigned",
                        company.getCompanyName() + " assigned you task: " + title,
                        "INFO"
                    );
                    notificationDAO.createNotification(notif);
                }

                resp.sendRedirect(req.getContextPath() + "/company/tasks?success=Task+assigned+successfully.");
            } else {
                resp.sendRedirect(req.getContextPath() + "/company/applications?error=Failed+to+assign+task.");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/company/applications?error=Task+assignment+failed.");
        }
    }

    private void handleSubmitTask(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        Student student = studentDAO.findByUserId(user.getId());
        try {
            int taskId = Integer.parseInt(req.getParameter("taskId"));
            String submissionText = ValidationUtil.sanitize(req.getParameter("submissionText"));

            Part filePart = req.getPart("submissionFile");
            String filePath = null;

            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = req.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "tasks";
                String savedName = FileUploadUtil.saveFile(filePart, uploadPath);
                filePath = "uploads/tasks/" + savedName;
            }

            TaskSubmission sub = new TaskSubmission();
            sub.setTaskId(taskId);
            sub.setSubmissionText(submissionText);
            sub.setFilePath(filePath);

            taskDAO.submitTask(sub);

            resp.sendRedirect(req.getContextPath() + "/student/tasks?success=Task+submitted+successfully.");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/student/tasks?error=Failed+to+submit+task.");
        }
    }

    private void handleReviewTask(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        try {
            int taskId = Integer.parseInt(req.getParameter("taskId"));
            String status = req.getParameter("status"); // PASSED, FAILED
            String feedback = ValidationUtil.sanitize(req.getParameter("feedback"));

            taskDAO.reviewTaskSubmission(taskId, status, feedback);

            resp.sendRedirect(req.getContextPath() + "/company/tasks?success=Task+review+updated.");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/company/tasks?error=Failed+to+update+task+review.");
        }
    }
}
