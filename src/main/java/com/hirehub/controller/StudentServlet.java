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
import java.util.List;

@WebServlet(urlPatterns = {
    "/student/dashboard",
    "/student/applications",
    "/student/tasks",
    "/student/messages",
    "/student/interviews",
    "/student/settings"
})
public class StudentServlet extends HttpServlet {

    private StudentDAO studentDAO;
    private JobDAO jobDAO;
    private ApplicationDAO applicationDAO;
    private TaskDAO taskDAO;
    private InterviewDAO interviewDAO;
    private MessageDAO messageDAO;

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
        jobDAO = new JobDAO();
        applicationDAO = new ApplicationDAO();
        taskDAO = new TaskDAO();
        interviewDAO = new InterviewDAO();
        messageDAO = new MessageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"STUDENT".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Student student = studentDAO.findByUserId(user.getId());
        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        session.setAttribute("studentProfile", student);

        String path = req.getServletPath();

        switch (path) {
            case "/student/dashboard":
                showDashboard(req, resp, student);
                break;
            case "/student/applications":
                showApplications(req, resp, student);
                break;
            case "/student/tasks":
                showTasks(req, resp, student);
                break;
            case "/student/messages":
                showMessages(req, resp, user);
                break;
            case "/student/interviews":
                showInterviews(req, resp, student);
                break;
            case "/student/settings":
                req.getRequestDispatcher("/student/settings.jsp").forward(req, resp);
                break;
            default:
                showDashboard(req, resp, student);
                break;
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws ServletException, IOException {
        List<Application> applications = applicationDAO.getApplicationsByStudent(student.getId());
        List<Job> recommendedJobs = jobDAO.getRecommendedJobsForStudent(student.getId(), student.getSkills());
        List<Interview> interviews = interviewDAO.getInterviewsByStudent(student.getId());
        List<Task> tasks = taskDAO.getTasksByStudent(student.getId());

        int pendingCount = 0;
        int shortlistedCount = 0;
        int selectedCount = 0;

        for (Application app : applications) {
            String st = app.getStatus();
            if ("APPLIED".equalsIgnoreCase(st) || "UNDER_REVIEW".equalsIgnoreCase(st)) pendingCount++;
            else if ("SHORTLISTED".equalsIgnoreCase(st) || "TASK_ASSIGNED".equalsIgnoreCase(st) || "INTERVIEW".equalsIgnoreCase(st)) shortlistedCount++;
            else if ("SELECTED".equalsIgnoreCase(st)) selectedCount++;
        }

        req.setAttribute("totalApps", applications.size());
        req.setAttribute("pendingApps", pendingCount);
        req.setAttribute("shortlistedApps", shortlistedCount);
        req.setAttribute("selectedApps", selectedCount);
        req.setAttribute("interviewCount", interviews.size());
        req.setAttribute("taskCount", tasks.size());
        req.setAttribute("recommendedJobs", recommendedJobs);
        req.setAttribute("applications", applications);
        req.setAttribute("interviews", interviews);

        req.getRequestDispatcher("/student/dashboard.jsp").forward(req, resp);
    }

    private void showApplications(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws ServletException, IOException {
        List<Application> applications = applicationDAO.getApplicationsByStudent(student.getId());
        req.setAttribute("applications", applications);
        req.getRequestDispatcher("/student/applications.jsp").forward(req, resp);
    }

    private void showTasks(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws ServletException, IOException {
        List<Task> tasks = taskDAO.getTasksByStudent(student.getId());
        req.setAttribute("tasks", tasks);
        req.getRequestDispatcher("/student/tasks.jsp").forward(req, resp);
    }

    private void showMessages(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        List<Message> messages = messageDAO.getMessagesForUser(user.getId());
        req.setAttribute("messages", messages);
        req.getRequestDispatcher("/student/messages.jsp").forward(req, resp);
    }

    private void showInterviews(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws ServletException, IOException {
        List<Interview> interviews = interviewDAO.getInterviewsByStudent(student.getId());
        req.setAttribute("interviews", interviews);
        req.getRequestDispatcher("/student/interviews.jsp").forward(req, resp);
    }
}
