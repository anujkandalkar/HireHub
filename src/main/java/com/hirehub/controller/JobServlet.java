package com.hirehub.controller;

import com.hirehub.dao.ApplicationDAO;
import com.hirehub.dao.CompanyDAO;
import com.hirehub.dao.JobDAO;
import com.hirehub.dao.StudentDAO;
import com.hirehub.model.Company;
import com.hirehub.model.Job;
import com.hirehub.model.Student;
import com.hirehub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
    "/jobs",
    "/job-details",
    "/companies",
    "/company-details"
})
public class JobServlet extends HttpServlet {

    private JobDAO jobDAO;
    private CompanyDAO companyDAO;
    private StudentDAO studentDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() throws ServletException {
        jobDAO = new JobDAO();
        companyDAO = new CompanyDAO();
        studentDAO = new StudentDAO();
        applicationDAO = new ApplicationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        switch (path) {
            case "/jobs":
                handleJobList(req, resp);
                break;
            case "/job-details":
                handleJobDetails(req, resp);
                break;
            case "/companies":
                handleCompanyList(req, resp);
                break;
            case "/company-details":
                handleCompanyDetails(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/jobs");
                break;
        }
    }

    private void handleJobList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String location = req.getParameter("location");
        String jobType = req.getParameter("jobType");
        String sort = req.getParameter("sort");

        Double minSalary = null;
        Double maxSalary = null;
        try {
            if (req.getParameter("minSalary") != null) minSalary = Double.parseDouble(req.getParameter("minSalary"));
            if (req.getParameter("maxSalary") != null) maxSalary = Double.parseDouble(req.getParameter("maxSalary"));
        } catch (Exception e) {}

        List<Job> jobs = jobDAO.searchAndFilterJobs(keyword, location, minSalary, maxSalary, jobType, sort);

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "STUDENT".equalsIgnoreCase(user.getRole())) {
            Student student = studentDAO.findByUserId(user.getId());
            if (student != null && student.getSkills() != null) {
                for (Job job : jobs) {
                    int matchPct = JobDAO.calculateMatchPercentage(student.getSkills(), job.getRequiredSkills());
                    job.setMatchPercentage(matchPct);
                }
            }
        }

        req.setAttribute("jobs", jobs);
        req.setAttribute("keyword", keyword);
        req.setAttribute("location", location);
        req.setAttribute("jobType", jobType);
        req.setAttribute("sort", sort);

        req.getRequestDispatcher("/jobs.jsp").forward(req, resp);
    }

    private void handleJobDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/jobs");
            return;
        }

        try {
            int jobId = Integer.parseInt(idStr);
            Job job = jobDAO.findById(jobId);
            if (job == null) {
                resp.sendRedirect(req.getContextPath() + "/jobs");
                return;
            }

            Company company = companyDAO.findById(job.getCompanyId());

            HttpSession session = req.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            boolean hasApplied = false;
            int matchPct = 0;

            if (user != null && "STUDENT".equalsIgnoreCase(user.getRole())) {
                Student student = studentDAO.findByUserId(user.getId());
                if (student != null) {
                    hasApplied = applicationDAO.hasApplied(student.getId(), jobId);
                    if (student.getSkills() != null) {
                        matchPct = JobDAO.calculateMatchPercentage(student.getSkills(), job.getRequiredSkills());
                    }
                }
            }

            req.setAttribute("job", job);
            req.setAttribute("company", company);
            req.setAttribute("hasApplied", hasApplied);
            req.setAttribute("matchPct", matchPct);

            req.getRequestDispatcher("/job-details.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/jobs");
        }
    }

    private void handleCompanyList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("search");
        List<Company> companies = companyDAO.getAllCompanies(search, "APPROVED");
        req.setAttribute("companies", companies);
        req.setAttribute("search", search);
        req.getRequestDispatcher("/companies.jsp").forward(req, resp);
    }

    private void handleCompanyDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int companyId = Integer.parseInt(idStr);
                Company company = companyDAO.findById(companyId);
                if (company != null) {
                    List<Job> jobs = jobDAO.getJobsByCompany(companyId);
                    req.setAttribute("company", company);
                    req.setAttribute("jobs", jobs);
                    req.getRequestDispatcher("/company-details.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception e) {}
        }
        resp.sendRedirect(req.getContextPath() + "/companies");
    }
}
