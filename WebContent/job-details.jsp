<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Job, com.hirehub.model.Company, com.hirehub.model.User" %>
<%
    Job job = (Job) request.getAttribute("job");
    Company company = (Company) request.getAttribute("company");
    Boolean hasApplied = (Boolean) request.getAttribute("hasApplied");
    Integer matchPct = (Integer) request.getAttribute("matchPct");
    User loggedInUser = (User) session.getAttribute("user");
    request.setAttribute("pageTitle", (job != null ? job.getTitle() : "Job Details") + " - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <% if (job != null) { %>
            <div class="row g-4">
                <!-- Left Details Column -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-start mb-4 gap-3">
                            <div>
                                <span class="badge bg-primary bg-opacity-10 text-primary job-badge-type mb-2"><%= job.getJobType().replace('_', ' ') %></span>
                                <h2 class="fw-bold text-dark mb-1"><%= job.getTitle() %></h2>
                                <h5 class="text-primary mb-2"><i class="bi bi-building me-2"></i><%= job.getCompanyName() %></h5>
                                <div class="text-muted small">
                                    <span class="me-3"><i class="bi bi-geo-alt me-1"></i><%= job.getLocation() %></span>
                                    <span class="me-3"><i class="bi bi-briefcase me-1"></i><%= job.getExperienceYears() %></span>
                                    <span><i class="bi bi-clock me-1"></i>Posted <%= job.getCreatedAt() %></span>
                                </div>
                            </div>

                            <% if (matchPct != null && matchPct > 0) { %>
                                <div class="text-md-end">
                                    <div class="match-badge fs-6 py-2 px-3">
                                        <i class="bi bi-lightning-charge-fill me-1"></i><%= matchPct %>% Skill Match
                                    </div>
                                    <div class="small text-muted mt-1">Based on your skills</div>
                                </div>
                            <% } %>
                        </div>

                        <hr class="my-4">

                        <h5 class="fw-bold mb-3">Job Description</h5>
                        <p class="text-secondary leading-relaxed mb-4"><%= job.getDescription() %></p>

                        <% if (job.getResponsibilities() != null && !job.getResponsibilities().isEmpty()) { %>
                            <h5 class="fw-bold mb-3">Responsibilities</h5>
                            <p class="text-secondary leading-relaxed mb-4"><%= job.getResponsibilities() %></p>
                        <% } %>

                        <% if (job.getRequirements() != null && !job.getRequirements().isEmpty()) { %>
                            <h5 class="fw-bold mb-3">Requirements</h5>
                            <p class="text-secondary leading-relaxed mb-4"><%= job.getRequirements() %></p>
                        <% } %>

                        <h5 class="fw-bold mb-3">Required Skills</h5>
                        <div class="mb-4">
                            <% if (job.getRequiredSkills() != null) {
                                String[] skills = job.getRequiredSkills().split("[,;]");
                                for (String s : skills) { %>
                                    <span class="badge bg-light text-dark border px-3 py-2 me-2 mb-2 fs-6"><%= s.trim() %></span>
                            <%  } 
                               } %>
                        </div>

                        <div class="p-3 bg-light rounded-3 d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small d-block">Estimated Salary Range</span>
                                <span class="fw-bold fs-4 text-success">$<%= (int)job.getSalaryMin() %> - $<%= (int)job.getSalaryMax() %> <small class="text-muted fs-6">/ year</small></span>
                            </div>
                            <% if (job.getDeadline() != null) { %>
                                <div>
                                    <span class="text-muted small d-block">Application Deadline</span>
                                    <span class="fw-bold text-dark"><i class="bi bi-calendar-event me-1"></i><%= job.getDeadline() %></span>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Right Sidebar Column -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white sticky-lg-top" style="top: 90px; z-index: 10;">
                        <h5 class="fw-bold mb-4">Application Summary</h5>

                        <% if (loggedInUser == null) { %>
                            <div class="alert alert-warning mb-3 small">
                                <i class="bi bi-exclamation-circle me-1"></i> You must be logged in as a student to apply for this position.
                            </div>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary w-100 rounded-pill py-2.5 fw-bold">Login to Apply</a>
                        <% } else if ("STUDENT".equalsIgnoreCase(loggedInUser.getRole())) { %>
                            <% if (hasApplied != null && hasApplied) { %>
                                <button class="btn btn-success w-100 rounded-pill py-2.5 fw-bold" disabled>
                                    <i class="bi bi-check-circle-fill me-2"></i>Already Applied
                                </button>
                                <a href="${pageContext.request.contextPath}/student/applications" class="btn btn-outline-secondary w-100 rounded-pill py-2 mt-2">Track Application</a>
                            <% } else { %>
                                <form action="${pageContext.request.contextPath}/apply-job" method="post">
                                    <input type="hidden" name="jobId" value="<%= job.getId() %>">
                                    <button type="submit" class="btn btn-primary w-100 rounded-pill py-2.5 fw-bold">
                                        <i class="bi bi-send-fill me-2"></i>Apply Now
                                    </button>
                                </form>
                            <% } %>
                        <% } else { %>
                            <div class="alert alert-info mb-0 small">
                                <i class="bi bi-info-circle me-1"></i> Logged in as <%= loggedInUser.getRole() %>. Only Students can submit job applications.
                            </div>
                        <% } %>

                        <% if (company != null) { %>
                            <hr class="my-4">
                            <h6 class="fw-bold mb-3">About the Company</h6>
                            <p class="small text-muted mb-2"><strong><%= company.getCompanyName() %></strong></p>
                            <p class="small text-muted mb-2"><i class="bi bi-tag me-1"></i><%= company.getIndustry() %></p>
                            <p class="small text-muted mb-2"><i class="bi bi-people me-1"></i><%= company.getCompanySize() %> Employees</p>
                            <p class="small text-muted mb-3"><i class="bi bi-globe me-1"></i><a href="<%= company.getWebsite() %>" target="_blank" class="text-decoration-none"><%= company.getWebsite() %></a></p>
                            <a href="${pageContext.request.contextPath}/company-details?id=<%= company.getId() %>" class="btn btn-outline-primary btn-sm w-100 rounded-pill">View Company Profile</a>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="text-center py-5">
                <h4>Job Not Found</h4>
                <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary rounded-pill mt-3">Back to Jobs</a>
            </div>
        <% } %>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
