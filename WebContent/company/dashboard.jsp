<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Company, com.hirehub.model.Job, com.hirehub.model.Application, java.util.List" %>
<%
    Company company = (Company) session.getAttribute("companyProfile");
    List<Job> companyJobs = (List<Job>) request.getAttribute("companyJobs");
    List<Application> recentApps = (List<Application>) request.getAttribute("recentApplications");
    request.setAttribute("pageTitle", "Company Dashboard — HireHub Recruiter Portal");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-4 bg-light">
    <div class="container">
        <!-- Approval Warning Banner if Pending -->
        <% if (company != null && !"APPROVED".equalsIgnoreCase(company.getApprovalStatus())) { %>
            <div class="alert alert-warning glass-card border-warning border-opacity-25 p-4 mb-4" role="alert">
                <div class="d-flex align-items-center">
                    <i class="bi bi-clock-history fs-2 me-3 text-warning"></i>
                    <div>
                        <h5 class="fw-bold mb-1 text-dark">Recruiter Status: <%= company.getApprovalStatus() %></h5>
                        <p class="mb-0 small text-muted">Your recruiter account is pending Admin approval. You will be able to publish job listings once an administrator approves your company profile.</p>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- Welcome Hero Glass Banner -->
        <div class="glass-card p-4 p-md-5 mb-4">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                <div class="d-flex align-items-center gap-3">
                    <div class="company-avatar" style="width: 56px; height: 56px; font-size: 1.6rem;">
                        <i class="bi bi-building"></i>
                    </div>
                    <div>
                        <h3 class="fw-bold text-dark mb-1">Welcome, <%= company != null ? company.getCompanyName() : "Employer" %>! 🏢</h3>
                        <p class="text-muted mb-0"><i class="bi bi-tag me-1 text-primary"></i><%= company != null ? company.getIndustry() : "" %> &bull; <i class="bi bi-geo-alt me-1 text-info"></i><%= company != null ? company.getLocation() : "" %></p>
                    </div>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <a href="${pageContext.request.contextPath}/company/post-job" class="btn btn-primary rounded-pill px-4 shadow-sm">
                        <i class="bi bi-plus-lg me-1"></i>Post New Job
                    </a>
                    <a href="${pageContext.request.contextPath}/company/profile" class="btn btn-outline-primary rounded-pill px-3">
                        <i class="bi bi-building me-1"></i>Company Profile
                    </a>
                </div>
            </div>
        </div>

        <!-- Metric Stat Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-2 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary mx-auto mb-2"><i class="bi bi-briefcase"></i></div>
                    <div class="stat-value"><%= request.getAttribute("totalJobs") != null ? request.getAttribute("totalJobs") : 0 %></div>
                    <div class="stat-label">Total Jobs</div>
                </div>
            </div>
            <div class="col-md-2 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-success bg-opacity-10 text-success mx-auto mb-2"><i class="bi bi-check-circle"></i></div>
                    <div class="stat-value"><%= request.getAttribute("activeJobs") != null ? request.getAttribute("activeJobs") : 0 %></div>
                    <div class="stat-label">Active Jobs</div>
                </div>
            </div>
            <div class="col-md-2 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-info bg-opacity-10 text-info mx-auto mb-2"><i class="bi bi-people"></i></div>
                    <div class="stat-value"><%= request.getAttribute("totalApps") != null ? request.getAttribute("totalApps") : 0 %></div>
                    <div class="stat-label">Applications</div>
                </div>
            </div>
            <div class="col-md-2 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning mx-auto mb-2"><i class="bi bi-star"></i></div>
                    <div class="stat-value"><%= request.getAttribute("shortlistedApps") != null ? request.getAttribute("shortlistedApps") : 0 %></div>
                    <div class="stat-label">Shortlisted</div>
                </div>
            </div>
            <div class="col-md-2 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-purple bg-opacity-10 text-primary mx-auto mb-2"><i class="bi bi-camera-video"></i></div>
                    <div class="stat-value"><%= request.getAttribute("interviewCount") != null ? request.getAttribute("interviewCount") : 0 %></div>
                    <div class="stat-label">Interviews</div>
                </div>
            </div>
            <div class="col-md-2 col-6">
                <div class="stat-card">
                    <div class="stat-icon bg-success bg-opacity-10 text-success mx-auto mb-2"><i class="bi bi-trophy"></i></div>
                    <div class="stat-value"><%= request.getAttribute("selectedApps") != null ? request.getAttribute("selectedApps") : 0 %></div>
                    <div class="stat-label">Selected</div>
                </div>
            </div>
        </div>

        <!-- Recent Applicants Table Card -->
        <div class="glass-card overflow-hidden">
            <div class="p-4 border-bottom d-flex justify-content-between align-items-center">
                <h5 class="fw-bold text-dark mb-0"><i class="bi bi-people me-2 text-primary"></i>Recent Candidate Applications</h5>
                <a href="${pageContext.request.contextPath}/company/applications" class="small text-primary fw-semibold text-decoration-none">Manage All Applicants &rarr;</a>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Candidate Name</th>
                            <th>Applied Job</th>
                            <th>Applied Date</th>
                            <th>Status</th>
                            <th class="text-end pe-4">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentApps != null && !recentApps.isEmpty()) { 
                            for (Application app : recentApps) { %>
                                <tr>
                                    <td class="ps-4">
                                        <h6 class="fw-bold mb-0 text-dark"><%= app.getStudentName() %></h6>
                                        <span class="small text-muted"><%= app.getStudentEmail() %></span>
                                    </td>
                                    <td class="fw-semibold text-dark"><%= app.getJobTitle() %></td>
                                    <td class="small text-muted"><%= app.getAppliedDate() %></td>
                                    <td><span class="badge bg-primary bg-opacity-10 text-primary px-3 py-1.5 rounded-pill"><%= app.getStatus() %></span></td>
                                    <td class="text-end pe-4">
                                        <a href="${pageContext.request.contextPath}/company/applications" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                            Manage Candidate
                                        </a>
                                    </td>
                                </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">
                                    <i class="bi bi-inbox d-block fs-2 mb-1"></i>
                                    No candidate applications received yet.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
