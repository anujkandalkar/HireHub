package com.hirehub.controller;

import com.hirehub.dao.*;
import com.hirehub.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
    "/admin/dashboard",
    "/admin/students",
    "/admin/student-details",
    "/admin/companies",
    "/admin/company-details",
    "/admin/jobs",
    "/admin/applications",
    "/admin/reports"
})
public class AdminServlet extends HttpServlet {

    private UserDAO userDAO;
    private StudentDAO studentDAO;
    private CompanyDAO companyDAO;
    private JobDAO jobDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        studentDAO = new StudentDAO();
        companyDAO = new CompanyDAO();
        jobDAO = new JobDAO();
        applicationDAO = new ApplicationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        switch (path) {
            case "/admin/dashboard":
                showDashboard(req, resp);
                break;
            case "/admin/students":
                showStudents(req, resp);
                break;
            case "/admin/student-details":
                showStudentDetails(req, resp);
                break;
            case "/admin/companies":
                showCompanies(req, resp);
                break;
            case "/admin/company-details":
                showCompanyDetails(req, resp);
                break;
            case "/admin/jobs":
                showJobs(req, resp);
                break;
            case "/admin/applications":
                showApplications(req, resp);
                break;
            case "/admin/reports":
                showReports(req, resp);
                break;
            default:
                showDashboard(req, resp);
                break;
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int totalStudents = studentDAO.getTotalStudentsCount();
        int totalCompanies = companyDAO.getTotalCompaniesCount();
        int pendingCompanies = companyDAO.getPendingCompaniesCount();
        int activeJobs = jobDAO.getTotalActiveJobsCount();
        int totalApps = applicationDAO.getTotalApplicationsCount();
        int shortlistedApps = applicationDAO.getApplicationsCountByStatus("SHORTLISTED");
        int selectedApps = applicationDAO.getApplicationsCountByStatus("SELECTED");

        List<Student> recentStudents = studentDAO.getAllStudents(null, null);
        List<Company> recentCompanies = companyDAO.getAllCompanies(null, null);
        List<Application> recentApps = applicationDAO.getAllApplicationsAdmin(null, null);

        req.setAttribute("totalStudents", totalStudents);
        req.setAttribute("totalCompanies", totalCompanies);
        req.setAttribute("pendingCompanies", pendingCompanies);
        req.setAttribute("activeJobs", activeJobs);
        req.setAttribute("totalApps", totalApps);
        req.setAttribute("shortlistedApps", shortlistedApps);
        req.setAttribute("selectedApps", selectedApps);

        if (recentStudents.size() > 5) recentStudents = recentStudents.subList(0, 5);
        if (recentCompanies.size() > 5) recentCompanies = recentCompanies.subList(0, 5);
        if (recentApps.size() > 5) recentApps = recentApps.subList(0, 5);

        req.setAttribute("recentStudents", recentStudents);
        req.setAttribute("recentCompanies", recentCompanies);
        req.setAttribute("recentApps", recentApps);

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }

    private void showStudents(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("search");
        String skill = req.getParameter("skill");
        List<Student> students = studentDAO.getAllStudents(search, skill);
        req.setAttribute("students", students);
        req.setAttribute("search", search);
        req.setAttribute("skill", skill);
        req.getRequestDispatcher("/admin/students.jsp").forward(req, resp);
    }

    private void showStudentDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int studentId = Integer.parseInt(idStr);
                Student student = studentDAO.findById(studentId);
                if (student != null) {
                    User user = userDAO.findById(student.getUserId());
                    List<Application> apps = applicationDAO.getApplicationsByStudent(studentId);
                    req.setAttribute("student", student);
                    req.setAttribute("studentUser", user);
                    req.setAttribute("applications", apps);
                    req.getRequestDispatcher("/admin/student-details.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception e) {}
        }
        resp.sendRedirect(req.getContextPath() + "/admin/students");
    }

    private void showCompanies(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("search");
        String status = req.getParameter("status");
        List<Company> companies = companyDAO.getAllCompanies(search, status);
        req.setAttribute("companies", companies);
        req.setAttribute("search", search);
        req.setAttribute("status", status);
        req.getRequestDispatcher("/admin/companies.jsp").forward(req, resp);
    }

    private void showCompanyDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int companyId = Integer.parseInt(idStr);
                Company company = companyDAO.findById(companyId);
                if (company != null) {
                    User user = userDAO.findById(company.getUserId());
                    List<Job> jobs = jobDAO.getJobsByCompany(companyId);
                    req.setAttribute("company", company);
                    req.setAttribute("companyUser", user);
                    req.setAttribute("jobs", jobs);
                    req.getRequestDispatcher("/admin/company-details.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception e) {}
        }
        resp.sendRedirect(req.getContextPath() + "/admin/companies");
    }

    private void showJobs(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("search");
        String status = req.getParameter("status");
        List<Job> jobs = jobDAO.getAllJobsAdmin(search, status);
        req.setAttribute("jobs", jobs);
        req.setAttribute("search", search);
        req.setAttribute("status", status);
        req.getRequestDispatcher("/admin/jobs.jsp").forward(req, resp);
    }

    private void showApplications(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("search");
        String status = req.getParameter("status");
        List<Application> applications = applicationDAO.getAllApplicationsAdmin(search, status);
        req.setAttribute("applications", applications);
        req.setAttribute("search", search);
        req.setAttribute("status", status);
        req.getRequestDispatcher("/admin/applications.jsp").forward(req, resp);
    }

    private void showReports(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int totalStudents = studentDAO.getTotalStudentsCount();
        int totalCompanies = companyDAO.getTotalCompaniesCount();
        int activeJobs = jobDAO.getTotalActiveJobsCount();
        int totalApps = applicationDAO.getTotalApplicationsCount();
        int appliedCount = applicationDAO.getApplicationsCountByStatus("APPLIED");
        int reviewCount = applicationDAO.getApplicationsCountByStatus("UNDER_REVIEW");
        int shortlistedCount = applicationDAO.getApplicationsCountByStatus("SHORTLISTED");
        int taskCount = applicationDAO.getApplicationsCountByStatus("TASK_ASSIGNED");
        int interviewCount = applicationDAO.getApplicationsCountByStatus("INTERVIEW");
        int selectedCount = applicationDAO.getApplicationsCountByStatus("SELECTED");
        int rejectedCount = applicationDAO.getApplicationsCountByStatus("REJECTED");

        req.setAttribute("totalStudents", totalStudents);
        req.setAttribute("totalCompanies", totalCompanies);
        req.setAttribute("activeJobs", activeJobs);
        req.setAttribute("totalApps", totalApps);
        req.setAttribute("appliedCount", appliedCount);
        req.setAttribute("reviewCount", reviewCount);
        req.setAttribute("shortlistedCount", shortlistedCount);
        req.setAttribute("taskCount", taskCount);
        req.setAttribute("interviewCount", interviewCount);
        req.setAttribute("selectedCount", selectedCount);
        req.setAttribute("rejectedCount", rejectedCount);

        req.getRequestDispatcher("/admin/reports.jsp").forward(req, resp);
    }
}
