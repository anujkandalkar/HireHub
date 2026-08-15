package com.hirehub.controller;

import com.hirehub.dao.CompanyDAO;
import com.hirehub.dao.JobDAO;
import com.hirehub.model.Company;
import com.hirehub.model.Job;
import com.hirehub.model.User;
import com.hirehub.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

@WebServlet(urlPatterns = {
    "/company/post-job",
    "/company/edit-job",
    "/company/delete-job",
    "/company/toggle-job-status"
})
public class PostJobServlet extends HttpServlet {

    private CompanyDAO companyDAO;
    private JobDAO jobDAO;

    @Override
    public void init() throws ServletException {
        companyDAO = new CompanyDAO();
        jobDAO = new JobDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        Company company = companyDAO.findByUserId(user.getId());

        String path = req.getServletPath();

        if ("/company/edit-job".equalsIgnoreCase(path)) {
            String jobIdStr = req.getParameter("id");
            if (jobIdStr != null) {
                try {
                    int jobId = Integer.parseInt(jobIdStr);
                    Job job = jobDAO.findById(jobId);
                    if (job != null && job.getCompanyId() == company.getId()) {
                        req.setAttribute("job", job);
                        req.getRequestDispatcher("/company/edit-job.jsp").forward(req, resp);
                        return;
                    }
                } catch (Exception e) {}
            }
            resp.sendRedirect(req.getContextPath() + "/company/manage-jobs");
            return;
        }

        // Default: post-job form
        req.setAttribute("company", company);
        req.getRequestDispatcher("/company/post-job.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        Company company = companyDAO.findByUserId(user.getId());

        if (company == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Check Company approval status
        if (!"APPROVED".equalsIgnoreCase(company.getApprovalStatus())) {
            req.setAttribute("errorMessage", "Your company account is currently " + company.getApprovalStatus() + ". Only APPROVED companies can post or edit jobs.");
            req.getRequestDispatcher("/company/post-job.jsp").forward(req, resp);
            return;
        }

        String path = req.getServletPath();

        if ("/company/delete-job".equalsIgnoreCase(path)) {
            handleDelete(req, resp, company);
            return;
        } else if ("/company/toggle-job-status".equalsIgnoreCase(path)) {
            handleToggleStatus(req, resp, company);
            return;
        }

        // Post or Edit Job
        String title = ValidationUtil.sanitize(req.getParameter("title"));
        String description = ValidationUtil.sanitize(req.getParameter("description"));
        String responsibilities = ValidationUtil.sanitize(req.getParameter("responsibilities"));
        String requirements = ValidationUtil.sanitize(req.getParameter("requirements"));
        String requiredSkills = ValidationUtil.sanitize(req.getParameter("requiredSkills"));
        String location = ValidationUtil.sanitize(req.getParameter("location"));
        String jobType = ValidationUtil.sanitize(req.getParameter("jobType"));
        String experienceYears = ValidationUtil.sanitize(req.getParameter("experienceYears"));

        double salaryMin = 0.0;
        double salaryMax = 0.0;
        int vacancies = 1;
        Date deadline = null;

        try {
            if (req.getParameter("salaryMin") != null) salaryMin = Double.parseDouble(req.getParameter("salaryMin").trim());
            if (req.getParameter("salaryMax") != null) salaryMax = Double.parseDouble(req.getParameter("salaryMax").trim());
            if (req.getParameter("vacancies") != null) vacancies = Integer.parseInt(req.getParameter("vacancies").trim());
            String dlStr = req.getParameter("deadline");
            if (dlStr != null && !dlStr.trim().isEmpty()) deadline = Date.valueOf(dlStr.trim());
        } catch (Exception e) {}

        if (title.isEmpty() || description.isEmpty() || requiredSkills.isEmpty() || location.isEmpty()) {
            req.setAttribute("errorMessage", "Please fill in all mandatory job fields.");
            req.getRequestDispatcher("/company/post-job.jsp").forward(req, resp);
            return;
        }

        Job job = new Job();
        job.setCompanyId(company.getId());
        job.setTitle(title);
        job.setDescription(description);
        job.setResponsibilities(responsibilities);
        job.setRequirements(requirements);
        job.setRequiredSkills(requiredSkills);
        job.setLocation(location);
        job.setSalaryMin(salaryMin);
        job.setSalaryMax(salaryMax);
        job.setExperienceYears(experienceYears);
        job.setJobType(jobType.isEmpty() ? "FULL_TIME" : jobType);
        job.setVacancies(vacancies);
        job.setDeadline(deadline);
        job.setStatus("ACTIVE");

        if ("/company/edit-job".equalsIgnoreCase(path)) {
            int jobId = Integer.parseInt(req.getParameter("jobId"));
            job.setId(jobId);
            jobDAO.updateJob(job);
            resp.sendRedirect(req.getContextPath() + "/company/manage-jobs?success=Job+updated+successfully.");
        } else {
            jobDAO.createJob(job);
            resp.sendRedirect(req.getContextPath() + "/company/manage-jobs?success=Job+posted+successfully.");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, Company company) throws IOException {
        try {
            int jobId = Integer.parseInt(req.getParameter("jobId"));
            Job job = jobDAO.findById(jobId);
            if (job != null && job.getCompanyId() == company.getId()) {
                jobDAO.deleteJob(jobId);
            }
        } catch (Exception e) {}
        resp.sendRedirect(req.getContextPath() + "/company/manage-jobs?success=Job+deleted+successfully.");
    }

    private void handleToggleStatus(HttpServletRequest req, HttpServletResponse resp, Company company) throws IOException {
        try {
            int jobId = Integer.parseInt(req.getParameter("jobId"));
            Job job = jobDAO.findById(jobId);
            if (job != null && job.getCompanyId() == company.getId()) {
                String newStatus = "ACTIVE".equalsIgnoreCase(job.getStatus()) ? "INACTIVE" : "ACTIVE";
                jobDAO.updateJobStatus(jobId, newStatus);
            }
        } catch (Exception e) {}
        resp.sendRedirect(req.getContextPath() + "/company/manage-jobs?success=Job+status+updated.");
    }
}
