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
    "/company/dashboard",
    "/company/profile",
    "/company/manage-jobs",
    "/company/applications",
    "/company/tasks",
    "/company/interviews",
    "/company/messages",
    "/company/settings"
})
public class CompanyServlet extends HttpServlet {

    private CompanyDAO companyDAO;
    private JobDAO jobDAO;
    private ApplicationDAO applicationDAO;
    private TaskDAO taskDAO;
    private InterviewDAO interviewDAO;
    private MessageDAO messageDAO;

    @Override
    public void init() throws ServletException {
        companyDAO = new CompanyDAO();
        jobDAO = new JobDAO();
        applicationDAO = new ApplicationDAO();
        taskDAO = new TaskDAO();
        interviewDAO = new InterviewDAO();
        messageDAO = new MessageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        Company company = companyDAO.findByUserId(user.getId());

        if (company == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        session.setAttribute("companyProfile", company);

        String path = req.getServletPath();

        switch (path) {
            case "/company/dashboard":
                showDashboard(req, resp, company);
                break;
            case "/company/profile":
                req.setAttribute("company", company);
                req.getRequestDispatcher("/company/profile.jsp").forward(req, resp);
                break;
            case "/company/manage-jobs":
                showManageJobs(req, resp, company);
                break;
            case "/company/applications":
                showApplications(req, resp, company);
                break;
            case "/company/tasks":
                showTasks(req, resp, company);
                break;
            case "/company/interviews":
                showInterviews(req, resp, company);
                break;
            case "/company/messages":
                showMessages(req, resp, user);
                break;
            case "/company/settings":
                req.getRequestDispatcher("/company/settings.jsp").forward(req, resp);
                break;
            default:
                showDashboard(req, resp, company);
                break;
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp, Company company)
            throws ServletException, IOException {
        List<Job> companyJobs = jobDAO.getJobsByCompany(company.getId());
        List<Application> companyApps = applicationDAO.getApplicationsByCompany(company.getId(), null, null);
        List<Interview> interviews = interviewDAO.getInterviewsByCompany(company.getId());

        int activeJobsCount = 0;
        for (Job j : companyJobs) {
            if ("ACTIVE".equalsIgnoreCase(j.getStatus())) activeJobsCount++;
        }

        int shortlisted = applicationDAO.getCompanyApplicationsCountByStatus(company.getId(), "SHORTLISTED");
        int selected = applicationDAO.getCompanyApplicationsCountByStatus(company.getId(), "SELECTED");

        req.setAttribute("totalJobs", companyJobs.size());
        req.setAttribute("activeJobs", activeJobsCount);
        req.setAttribute("totalApps", companyApps.size());
        req.setAttribute("shortlistedApps", shortlisted);
        req.setAttribute("selectedApps", selected);
        req.setAttribute("interviewCount", interviews.size());
        if (companyApps.size() > 10) companyApps = companyApps.subList(0, 10);
        req.setAttribute("recentApplications", companyApps);
        req.setAttribute("companyJobs", companyJobs);

        req.getRequestDispatcher("/company/dashboard.jsp").forward(req, resp);
    }

    private void showManageJobs(HttpServletRequest req, HttpServletResponse resp, Company company)
            throws ServletException, IOException {
        List<Job> jobs = jobDAO.getJobsByCompany(company.getId());
        req.setAttribute("jobs", jobs);
        req.getRequestDispatcher("/company/manage-jobs.jsp").forward(req, resp);
    }

    private void showApplications(HttpServletRequest req, HttpServletResponse resp, Company company)
            throws ServletException, IOException {
        String jobIdStr = req.getParameter("jobId");
        String statusFilter = req.getParameter("status");
        Integer jobId = null;
        if (jobIdStr != null && !jobIdStr.trim().isEmpty()) {
            try { jobId = Integer.parseInt(jobIdStr.trim()); } catch (Exception e) {}
        }

        List<Application> applications = applicationDAO.getApplicationsByCompany(company.getId(), jobId, statusFilter);
        List<Job> companyJobs = jobDAO.getJobsByCompany(company.getId());

        req.setAttribute("applications", applications);
        req.setAttribute("companyJobs", companyJobs);
        req.setAttribute("selectedJobId", jobId);
        req.setAttribute("selectedStatus", statusFilter);

        req.getRequestDispatcher("/company/applications.jsp").forward(req, resp);
    }

    private void showTasks(HttpServletRequest req, HttpServletResponse resp, Company company)
            throws ServletException, IOException {
        List<Task> tasks = taskDAO.getTasksByCompany(company.getId());
        req.setAttribute("tasks", tasks);
        req.getRequestDispatcher("/company/tasks.jsp").forward(req, resp);
    }

    private void showInterviews(HttpServletRequest req, HttpServletResponse resp, Company company)
            throws ServletException, IOException {
        List<Interview> interviews = interviewDAO.getInterviewsByCompany(company.getId());
        req.setAttribute("interviews", interviews);
        req.getRequestDispatcher("/company/interviews.jsp").forward(req, resp);
    }

    private void showMessages(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        List<Message> messages = messageDAO.getMessagesForUser(user.getId());
        req.setAttribute("messages", messages);
        req.getRequestDispatcher("/company/messages.jsp").forward(req, resp);
    }
}
